// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

part of firebase_ml_vision;

enum _ImageType { file, bytes }

/// Indicates the image rotation.
///
/// Rotation is counter-clockwise.
enum ImageRotation { rotation_0, rotation_90, rotation_180, rotation_270 }

/// The Firebase machine learning vision API.
///
/// You can get an instance by calling [FirebaseVision.instance] and then get
/// a detector from the instance:
///
/// ```dart
/// TextRecognizer textRecognizer = FirebaseVision.instance.textRecognizer();
/// ```
class FirebaseVision {
  FirebaseVision._();

  @visibleForTesting
  static const MethodChannel channel =
      MethodChannel('plugins.flutter.io/firebase_ml_vision');

  /// Singleton of [FirebaseVision].
  ///
  /// Use this get an instance of a detector:
  ///
  /// ```dart
  /// TextRecognizer textRecognizer = FirebaseVision.instance.textRecognizer();
  /// ```
  static final FirebaseVision instance = FirebaseVision._();

  /// Creates an instance of [BarcodeDetector].
  BarcodeDetector barcodeDetector([BarcodeDetectorOptions options]) {
    return BarcodeDetector._(options ?? const BarcodeDetectorOptions());
  }

  /// Creates an instance of [FaceDetector].
  FaceDetector faceDetector([FaceDetectorOptions options]) {
    return FaceDetector._(options ?? const FaceDetectorOptions());
  }

  /// Creates an instance of [LabelDetector].
  LabelDetector labelDetector([LabelDetectorOptions options]) {
    return LabelDetector._(options ?? const LabelDetectorOptions());
  }

  /// Creates an instance of [TextRecognizer].
  TextRecognizer textRecognizer() => TextRecognizer._();

  /// Creates an instance of [CloudLabelDetector].
  CloudLabelDetector cloudLabelDetector([CloudDetectorOptions options]) {
    return CloudLabelDetector._(options ?? const CloudDetectorOptions());
  }
}

/// Represents an image object used for both on-device and cloud API detectors.
///
/// Create an instance by calling one of the factory constructors.
class FirebaseVisionImage {
  const FirebaseVisionImage._({
    @required _ImageType type,
    FirebaseVisionImageMetadata metadata,
    File imageFile,
    Uint8List bytes,
  })  : _imageFile = imageFile,
        _metadata = metadata,
        _bytes = bytes,
        _type = type;

  /// Construct a [FirebaseVisionImage] from a file.
  factory FirebaseVisionImage.fromFile(File imageFile) {
    assert(imageFile != null);
    return FirebaseVisionImage._(
      type: _ImageType.file,
      imageFile: imageFile,
    );
  }

  /// Construct a [FirebaseVisionImage] from a file path.
  factory FirebaseVisionImage.fromFilePath(String imagePath) {
    assert(imagePath != null);
    return FirebaseVisionImage._(
      type: _ImageType.file,
      imageFile: File(imagePath),
    );
  }

  /// Construct a [FirebaseVisionImage] from a list of bytes.
  ///
  /// Expects `android.graphics.ImageFormat.NV21` format on Android. Note:
  /// Concatenating the planes of `android.graphics.ImageFormat.YUV_420_888`
  /// into a single plane, converts it to `android.graphics.ImageFormat.NV21`.
  ///
  /// Expects `kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange` or any other
  /// planar format on iOS.
  factory FirebaseVisionImage.fromBytes(
    Uint8List bytes,
    FirebaseVisionImageMetadata metadata,
  ) {
    assert(bytes != null);
    assert(metadata != null);
    return FirebaseVisionImage._(
      type: _ImageType.bytes,
      bytes: bytes,
      metadata: metadata,
    );
  }

  final Uint8List _bytes;
  final File _imageFile;
  final FirebaseVisionImageMetadata _metadata;
  final _ImageType _type;

  Map<String, dynamic> _serialize() => <String, dynamic>{
        'type': _enumToString(_type),
        'bytes': _bytes,
        'path': _imageFile?.path,
        'metadata': _type == _ImageType.bytes ? _metadata._serialize() : null,
      };
}

/// Plane attributes to create the image buffer on iOS.
class FirebaseVisionImagePlaneMetadata {
  const FirebaseVisionImagePlaneMetadata({
    @required this.bytesPerRow,
    @required this.height,
    @required this.width,
  })  : assert(bytesPerRow != null),
        assert(height != null),
        assert(width != null);

  /// The row stride for this color plane, in bytes.
  final int bytesPerRow;

  /// Height of the pixel buffer on iOS.
  final int height;

  /// Width of the pixel buffer on iOS.
  final int width;

  Map<String, dynamic> _serialize() => <String, dynamic>{
        'bytesPerRow': bytesPerRow,
        'height': height,
        'width': width,
      };
}

/// Image metadata used by [FirebaseVision] detectors.
///
/// [rotation] defaults to [ImageRotation.rotation_0]. Currently only rotates on
/// Android.
class FirebaseVisionImageMetadata {
  const FirebaseVisionImageMetadata({
    @required this.size,
    @required this.rawFormat,
    @required this.planeData,
    this.rotation = ImageRotation.rotation_0,
  }) : assert(size != null);

  /// Size of the image in pixels.
  final Size size;

  /// Rotation of the image for Android.
  ///
  /// Not currently used on iOS.
  final ImageRotation rotation;

  /// Raw version of the format from the iOS platform.
  ///
  /// Since iOS can use any planar format, this format will be used to create
  /// the image buffer on iOS.
  ///
  /// On iOS, this is a `FourCharCode` constant from Pixel Format Identifiers.
  /// See https://developer.apple.com/documentation/corevideo/1563591-pixel_format_identifiers?language=objc
  ///
  /// Not used on Android.
  final dynamic rawFormat;

  /// The plane attributes to create the image buffer on iOS.
  ///
  /// Not used on Android.
  final List<FirebaseVisionImagePlaneMetadata> planeData;

  int _imageRotationToInt(ImageRotation rotation) {
    switch (rotation) {
      case ImageRotation.rotation_90:
        return 90;
      case ImageRotation.rotation_180:
        return 180;
      case ImageRotation.rotation_270:
        return 270;
      default:
        assert(rotation == ImageRotation.rotation_0);
        return 0;
    }
  }

  Map<String, dynamic> _serialize() => <String, dynamic>{
        'width': size.width,
        'height': size.height,
        'rotation': _imageRotationToInt(rotation),
        'rawFormat': rawFormat,
        'planeData': planeData
            .map((FirebaseVisionImagePlaneMetadata plane) => plane._serialize())
            .toList(),
      };
}

/// Abstract class for detectors in [FirebaseVision] API.
abstract class FirebaseVisionDetector {
  /// Uses machine learning model to detect objects of interest in an image.
  Future<dynamic> detectInImage(FirebaseVisionImage visionImage);
}

String _enumToString(dynamic enumValue) {
  final String enumString = enumValue.toString();
  return enumString.substring(enumString.indexOf('.') + 1);
}
