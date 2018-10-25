// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

part of firebase_ml_vision;

enum _FirebaseVisionImageType { file, bytes }

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
  FirebaseVisionImage._({
    @required _FirebaseVisionImageType type,
    File imageFile,
    Uint8List bytes,
  })  : _imageFile = imageFile,
        _bytes = bytes,
        _type = type;

  /// Construct a [FirebaseVisionImage] from a file.
  factory FirebaseVisionImage.fromFile(File imageFile) {
    assert(imageFile != null);
    return FirebaseVisionImage._(
      type: _FirebaseVisionImageType.file,
      imageFile: imageFile,
    );
  }

  /// Construct a [FirebaseVisionImage] from a file path.
  factory FirebaseVisionImage.fromFilePath(String imagePath) {
    assert(imagePath != null);
    return FirebaseVisionImage._(
      type: _FirebaseVisionImageType.file,
      imageFile: File(imagePath),
    );
  }

  /// Construct a [FirebaseVisionImage] from a list of bytes.
  factory FirebaseVisionImage.fromBytes(Uint8List bytes) {
    assert(bytes != null);
    return FirebaseVisionImage._(
      type: _FirebaseVisionImageType.bytes,
      bytes: bytes,
    );
  }

  final File _imageFile;
  final Uint8List _bytes;
  final _FirebaseVisionImageType _type;
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
