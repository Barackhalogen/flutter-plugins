import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

final MethodChannel _channel = const MethodChannel('plugins.flutter.io/camera')
  ..invokeMethod('init');

enum CameraLensDirection { front, back, external }

enum ResolutionPreset { low, medium, high }

typedef void OnLatestImageAvailable(CameraImage image);

/// A single color plane of image data.
///
/// The number and meaning of the planes in an image are determined by the
/// format of the Image.
class Plane {
  Plane._fromPlatformData(dynamic data)
      : bytes = data['bytes'],
        bytesPerPixel = data['bytesPerPixel'],
        bytesPerRow = data['bytesPerRow'],
        height = data['height'],
        width = data['width'];

  /// Bytes representing this plane.
  final Uint8List bytes;

  /// The distance between adjacent pixel samples on Android, in bytes.
  ///
  /// Will be `null` on iOS.
  final int bytesPerPixel;

  /// The row stride for this color plane, in bytes.
  final int bytesPerRow;

  /// Height of the pixel buffer on iOS.
  ///
  /// Will be `null` on Android
  final int height;

  /// Width of the pixel buffer on iOS.
  ///
  /// Will be `null` on Android.
  final int width;
}

/// Group of image formats that are comparable across Android and iOS platforms.
enum ImageFormatGroup {
  /// The image format does not fit into any specific group.
  unknown,

  /// Multi-plane YUV 420 format.
  ///
  /// This format is a generic YCbCr format, capable of describing any 4:2:0
  /// chroma-subsampled planar or semiplanar buffer (but not fully interleaved),
  /// with 8 bits per color sample.
  ///
  /// On Android, this is `android.graphics.ImageFormat.YUV_420_888`. See
  /// https://developer.android.com/reference/android/graphics/ImageFormat.html#YUV_420_888
  ///
  /// On iOS, this is `kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange`. See
  /// https://developer.apple.com/documentation/corevideo/1563591-pixel_format_identifiers/kcvpixelformattype_420ypcbcr8biplanarvideorange?language=objc
  yuv420,
}

/// Describes how pixels are represented in an image.
class ImageFormat {
  ImageFormat._fromPlatformData(this.raw) : group = _asImageFormatGroup(raw);

  /// Describes the format group the raw image format falls into.
  final ImageFormatGroup group;

  /// Raw version of the format from the Android or iOS platform.
  ///
  /// On Android, this is an `int` from class `android.graphics.ImageFormat`. See
  /// https://developer.android.com/reference/android/graphics/ImageFormat
  ///
  /// On iOS, this is a `FourCharCode` constant from Pixel Format Identifiers.
  /// See https://developer.apple.com/documentation/corevideo/1563591-pixel_format_identifiers?language=objc
  final dynamic raw;
}

ImageFormatGroup _asImageFormatGroup(dynamic rawFormat) {
  if (rawFormat == 35 || rawFormat == 875704438) {
    return ImageFormatGroup.yuv420;
  } else {
    return ImageFormatGroup.unknown;
  }
}

/// A single complete image buffer from the platform camera.
///
/// This class allows for direct application access to the pixel data of an
/// Image through one or more [Uint8List]. Each buffer is encapsulated in a
/// [Plane] that describes the layout of the pixel data in that plane. The
/// [CameraImage] is not directly usable as a UI resource.
///
/// Although not all image formats are planar on iOS, we treat 1-dimensional
/// images as single planar images.
class CameraImage {
  CameraImage._fromPlatformData(dynamic data)
      : format = ImageFormat._fromPlatformData(data['format']),
        height = data['height'],
        width = data['width'],
        planes = List<Plane>.unmodifiable(data['planes']
            .map((dynamic planeData) => Plane._fromPlatformData(planeData)));

  /// Format of the image provided.
  ///
  /// Determines the number of planes needed to represent the image, and
  /// the general layout of the pixel data in each [Uint8List].
  final ImageFormat format;

  /// Height of the image in pixels.
  ///
  /// For formats where some color channels are subsampled, this is the height
  /// of the largest-resolution plane.
  final int height;

  /// Width of the image in pixels.
  ///
  /// For formats where some color channels are subsampled, this is the width
  /// of the largest-resolution plane.
  final int width;

  /// The pixels planes for this image.
  ///
  /// The number of planes is determined by the format of the image.
  final List<Plane> planes;
}

/// Returns the resolution preset as a String.
String serializeResolutionPreset(ResolutionPreset resolutionPreset) {
  switch (resolutionPreset) {
    case ResolutionPreset.high:
      return 'high';
    case ResolutionPreset.medium:
      return 'medium';
    case ResolutionPreset.low:
      return 'low';
  }
  throw ArgumentError('Unknown ResolutionPreset value');
}

CameraLensDirection _parseCameraLensDirection(String string) {
  switch (string) {
    case 'front':
      return CameraLensDirection.front;
    case 'back':
      return CameraLensDirection.back;
    case 'external':
      return CameraLensDirection.external;
  }
  throw ArgumentError('Unknown CameraLensDirection value');
}

/// Completes with a list of available cameras.
///
/// May throw a [CameraException].
Future<List<CameraDescription>> availableCameras() async {
  try {
    final List<dynamic> cameras =
        await _channel.invokeMethod('availableCameras');
    return cameras.map((dynamic camera) {
      return CameraDescription(
        name: camera['name'],
        lensDirection: _parseCameraLensDirection(camera['lensFacing']),
      );
    }).toList();
  } on PlatformException catch (e) {
    throw CameraException(e.code, e.message);
  }
}

class CameraDescription {
  CameraDescription({this.name, this.lensDirection});

  final String name;
  final CameraLensDirection lensDirection;

  @override
  bool operator ==(Object o) {
    return o is CameraDescription &&
        o.name == name &&
        o.lensDirection == lensDirection;
  }

  @override
  int get hashCode {
    return hashValues(name, lensDirection);
  }

  @override
  String toString() {
    return '$runtimeType($name, $lensDirection)';
  }
}

/// This is thrown when the plugin reports an error.
class CameraException implements Exception {
  CameraException(this.code, this.description);

  String code;
  String description;

  @override
  String toString() => '$runtimeType($code, $description)';
}

// Build the UI texture view of the video data with textureId.
class CameraPreview extends StatelessWidget {
  const CameraPreview(this.controller);

  final CameraController controller;

  @override
  Widget build(BuildContext context) {
    return controller.value.isInitialized
        ? Texture(textureId: controller._textureId)
        : Container();
  }
}

/// The state of a [CameraController].
class CameraValue {
  const CameraValue({
    this.isInitialized,
    this.errorDescription,
    this.previewSize,
    this.isRecordingVideo,
    this.isTakingPicture,
    this.isStreamingBytes,
  });

  const CameraValue.uninitialized()
      : this(
            isInitialized: false,
            isRecordingVideo: false,
            isTakingPicture: false,
            isStreamingBytes: false);

  /// True after [CameraController.initialize] has completed successfully.
  final bool isInitialized;

  /// True when a picture capture request has been sent but as not yet returned.
  final bool isTakingPicture;

  /// True when the camera is recording (not the same as previewing).
  final bool isRecordingVideo;

  /// True when bytes from the camera are being streamed.
  final bool isStreamingBytes;

  final String errorDescription;

  /// The size of the preview in pixels.
  ///
  /// Is `null` until  [isInitialized] is `true`.
  final Size previewSize;

  /// Convenience getter for `previewSize.height / previewSize.width`.
  ///
  /// Can only be called when [initialize] is done.
  double get aspectRatio => previewSize.height / previewSize.width;

  bool get hasError => errorDescription != null;

  CameraValue copyWith({
    bool isInitialized,
    bool isRecordingVideo,
    bool isTakingPicture,
    bool isStreamingBytes,
    String errorDescription,
    Size previewSize,
  }) {
    return CameraValue(
      isInitialized: isInitialized ?? this.isInitialized,
      errorDescription: errorDescription,
      previewSize: previewSize ?? this.previewSize,
      isRecordingVideo: isRecordingVideo ?? this.isRecordingVideo,
      isTakingPicture: isTakingPicture ?? this.isTakingPicture,
      isStreamingBytes: isStreamingBytes ?? this.isStreamingBytes,
    );
  }

  @override
  String toString() {
    return '$runtimeType('
        'isRecordingVideo: $isRecordingVideo, '
        'isRecordingVideo: $isRecordingVideo, '
        'isInitialized: $isInitialized, '
        'errorDescription: $errorDescription, '
        'previewSize: $previewSize, '
        'isStreamingBytes: $isStreamingBytes)';
  }
}

/// Controls a device camera.
///
/// Use [availableCameras] to get a list of available cameras.
///
/// Before using a [CameraController] a call to [initialize] must complete.
///
/// To show the camera preview on the screen use a [CameraPreview] widget.
class CameraController extends ValueNotifier<CameraValue> {
  CameraController(this.description, this.resolutionPreset)
      : super(const CameraValue.uninitialized());

  final CameraDescription description;
  final ResolutionPreset resolutionPreset;

  int _textureId;
  bool _isDisposed = false;
  StreamSubscription<dynamic> _eventSubscription;
  StreamSubscription<dynamic> _byteStreamSubscription;
  Completer<void> _creatingCompleter;

  /// Initializes the camera on the device.
  ///
  /// Throws a [CameraException] if the initialization fails.
  Future<void> initialize() async {
    if (_isDisposed) {
      return Future<void>.value();
    }
    try {
      _creatingCompleter = Completer<void>();
      final Map<dynamic, dynamic> reply = await _channel.invokeMethod(
        'initialize',
        <String, dynamic>{
          'cameraName': description.name,
          'resolutionPreset': serializeResolutionPreset(resolutionPreset),
        },
      );
      _textureId = reply['textureId'];
      value = value.copyWith(
        isInitialized: true,
        previewSize: Size(
          reply['previewWidth'].toDouble(),
          reply['previewHeight'].toDouble(),
        ),
      );
    } on PlatformException catch (e) {
      throw CameraException(e.code, e.message);
    }
    _eventSubscription =
        EventChannel('flutter.io/cameraPlugin/cameraEvents$_textureId')
            .receiveBroadcastStream()
            .listen(_listener);
    _creatingCompleter.complete();
    return _creatingCompleter.future;
  }

  /// Listen to events from the native plugins.
  ///
  /// A "cameraClosing" event is sent when the camera is closed automatically by the system (for example when the app go to background). The plugin will try to reopen the camera automatically but any ongoing recording will end.
  void _listener(dynamic event) {
    final Map<dynamic, dynamic> map = event;
    if (_isDisposed) {
      return;
    }

    switch (map['eventType']) {
      case 'error':
        value = value.copyWith(errorDescription: event['errorDescription']);
        break;
      case 'cameraClosing':
        value = value.copyWith(isRecordingVideo: false);
        break;
    }
  }

  /// Captures an image and saves it to [path].
  ///
  /// A path can for example be obtained using
  /// [path_provider](https://pub.dartlang.org/packages/path_provider).
  ///
  /// If a file already exists at the provided path an error will be thrown.
  /// The file can be read as this function returns.
  ///
  /// Throws a [CameraException] if the capture fails.
  Future<void> takePicture(String path) async {
    if (!value.isInitialized || _isDisposed) {
      throw CameraException(
        'Uninitialized CameraController.',
        'takePicture was called on uninitialized CameraController',
      );
    }
    if (value.isTakingPicture) {
      throw CameraException(
        'Previous capture has not returned yet.',
        'takePicture was called before the previous capture returned.',
      );
    }
    try {
      value = value.copyWith(isTakingPicture: true);
      await _channel.invokeMethod(
        'takePicture',
        <String, dynamic>{'textureId': _textureId, 'path': path},
      );
      value = value.copyWith(isTakingPicture: false);
    } on PlatformException catch (e) {
      value = value.copyWith(isTakingPicture: false);
      throw CameraException(e.code, e.message);
    }
  }

  /// Start a streaming bytes from platform camera.
  ///
  /// The stream will always use the latest image and discard the others.
  ///
  /// [onAvailable] is a method that takes a [CameraImage] and
  /// returns `void`.
  ///
  /// Throws a [CameraException] if byte streaming or video recording has
  /// already started.
  Future<void> startByteStream(OnLatestImageAvailable onAvailable) async {
    if (!value.isInitialized || _isDisposed) {
      throw CameraException(
        'Uninitialized CameraController',
        'startByteStream was called on uninitialized CameraController.',
      );
    }
    if (value.isRecordingVideo) {
      throw CameraException(
        'A video recording is already started.',
        'startByteStream was called while a video is being recorded.',
      );
    }
    if (value.isStreamingBytes) {
      throw CameraException(
        'A camera has started streaming bytes.',
        'startByteStream was called while a camera was streaming bytes.',
      );
    }

    try {
      await _channel.invokeMethod('startByteStream');
      value = value.copyWith(isStreamingBytes: true);
    } on PlatformException catch (e) {
      throw CameraException(e.code, e.message);
    }
    const EventChannel cameraEventChannel =
        EventChannel('plugins.flutter.io/camera/bytes');
    _byteStreamSubscription =
        cameraEventChannel.receiveBroadcastStream().listen(
      (dynamic imageData) {
        onAvailable(CameraImage._fromPlatformData(imageData));
      },
    );
  }

  /// Stop the stream of bytes from the camera.
  ///
  /// Throws a [CameraException] if byte streaming was not started or video
  /// recording was started.
  Future<void> stopByteStream() async {
    if (!value.isInitialized || _isDisposed) {
      throw CameraException(
        'Uninitialized CameraController',
        'stopByteStream was called on uninitialized CameraController.',
      );
    }
    if (value.isRecordingVideo) {
      throw CameraException(
        'A video recording is already started.',
        'stopByteStream was called while a video is being recorded.',
      );
    }
    if (!value.isStreamingBytes) {
      throw CameraException(
        'No camera is streaming bytes',
        'stopByteStream was called when no camera is streaming bytes.',
      );
    }

    try {
      value = value.copyWith(isStreamingBytes: false);
      await _channel.invokeMethod('stopByteStream');
    } on PlatformException catch (e) {
      throw CameraException(e.code, e.message);
    }

    _byteStreamSubscription.cancel();
    _byteStreamSubscription = null;
  }

  /// Start a video recording and save the file to [path].
  ///
  /// A path can for example be obtained using
  /// [path_provider](https://pub.dartlang.org/packages/path_provider).
  ///
  /// The file is written on the flight as the video is being recorded.
  /// If a file already exists at the provided path an error will be thrown.
  /// The file can be read as soon as [stopVideoRecording] returns.
  ///
  /// Throws a [CameraException] if the capture fails.
  Future<void> startVideoRecording(String filePath) async {
    if (!value.isInitialized || _isDisposed) {
      throw CameraException(
        'Uninitialized CameraController',
        'startVideoRecording was called on uninitialized CameraController',
      );
    }
    if (value.isRecordingVideo) {
      throw CameraException(
        'A video recording is already started.',
        'startVideoRecording was called when a recording is already started.',
      );
    }
    if (value.isStreamingBytes) {
      throw CameraException(
        'A camera has started streaming bytes.',
        'startVideoRecording was called while a camera was streaming bytes.',
      );
    }

    try {
      await _channel.invokeMethod(
        'startVideoRecording',
        <String, dynamic>{'textureId': _textureId, 'filePath': filePath},
      );
      value = value.copyWith(isRecordingVideo: true);
    } on PlatformException catch (e) {
      throw CameraException(e.code, e.message);
    }
  }

  /// Stop recording.
  Future<void> stopVideoRecording() async {
    if (!value.isInitialized || _isDisposed) {
      throw CameraException(
        'Uninitialized CameraController',
        'stopVideoRecording was called on uninitialized CameraController',
      );
    }
    if (!value.isRecordingVideo) {
      throw CameraException(
        'No video is recording',
        'stopVideoRecording was called when no video is recording.',
      );
    }
    try {
      value = value.copyWith(isRecordingVideo: false);
      await _channel.invokeMethod(
        'stopVideoRecording',
        <String, dynamic>{'textureId': _textureId},
      );
    } on PlatformException catch (e) {
      throw CameraException(e.code, e.message);
    }
  }

  /// Releases the resources of this camera.
  @override
  Future<void> dispose() async {
    if (_isDisposed) {
      return;
    }
    _isDisposed = true;
    super.dispose();
    if (_creatingCompleter != null) {
      await _creatingCompleter.future;
      await _channel.invokeMethod(
        'dispose',
        <String, dynamic>{'textureId': _textureId},
      );
      await _eventSubscription?.cancel();
    }
  }
}
