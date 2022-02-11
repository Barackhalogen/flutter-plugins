// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart'
    show SynchronousFuture, describeIdentity, immutable, objectRuntimeType;
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class _FutureImageStreamCompleter extends ImageStreamCompleter {
  _FutureImageStreamCompleter({
    required Future<ui.Codec> codec,
    required this.futureScale,
  }) {
    codec.then<void>(_onCodecReady, onError: (Object error, StackTrace stack) {
      reportError(
        context: ErrorDescription('resolving a single-frame image stream'),
        exception: error,
        stack: stack,
        silent: true,
      );
    });
  }

  final Future<double> futureScale;

  Future<void> _onCodecReady(ui.Codec codec) async {
    try {
      final ui.FrameInfo nextFrame = await codec.getNextFrame();
      final double scale = await futureScale;
      setImage(ImageInfo(image: nextFrame.image, scale: scale));
    } catch (exception, stack) {
      reportError(
        context: ErrorDescription('resolving an image frame'),
        exception: exception,
        stack: stack,
        silent: true,
      );
    }
  }
}

/// Performs exactly like a [MemoryImage] but instead of taking in bytes it takes
/// in a future that represents bytes.
@immutable
class _FutureMemoryImage extends ImageProvider<_FutureMemoryImage> {
  /// Constructor for FutureMemoryImage.  [_futureBytes] is the bytes that will
  /// be loaded into an image and [_futureScale] is the scale that will be applied to
  /// that image to account for high-resolution images.
  const _FutureMemoryImage(this._futureBytes, this._futureScale);

  final Future<Uint8List> _futureBytes;
  final Future<double> _futureScale;

  /// See [ImageProvider.obtainKey].
  @override
  Future<_FutureMemoryImage> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<_FutureMemoryImage>(this);
  }

  @override
  ImageStreamCompleter loadBuffer(
    _FutureMemoryImage key,
    DecoderBufferCallback decode, // ignore: deprecated_member_use
  ) {
    return _FutureImageStreamCompleter(
      codec: _loadAsync(key, decode),
      futureScale: _futureScale,
    );
  }

  Future<ui.Codec> _loadAsync(
    _FutureMemoryImage key,
    DecoderBufferCallback decode, // ignore: deprecated_member_use
  ) {
    assert(key == this);
    return _futureBytes.then(ui.ImmutableBuffer.fromUint8List).then(decode);
  }

  /// See [ImageProvider.operator==].
  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is _FutureMemoryImage &&
        _futureBytes == other._futureBytes &&
        _futureScale == other._futureScale;
  }

  /// See [ImageProvider.hashCode].
  @override
  int get hashCode => Object.hash(_futureBytes.hashCode, _futureScale);

  /// See [ImageProvider.toString].
  @override
  String toString() => '${objectRuntimeType(this, '_FutureMemoryImage')}'
      '(${describeIdentity(_futureBytes)}, scale: $_futureScale)';
}

// ignore: avoid_classes_with_only_static_members
/// Class to help loading of iOS platform images into Flutter.
///
/// For example, loading an image that is in `Assets.xcassts`.
class IosPlatformImages {
  static const MethodChannel _channel =
      MethodChannel('plugins.flutter.io/ios_platform_images');

  /// Loads an image from asset catalogs.  The equivalent would be:
  /// `[UIImage imageNamed:name]`.
  ///
  /// Throws an exception if the image can't be found.
  ///
  /// See [https://developer.apple.com/documentation/uikit/uiimage/1624146-imagenamed?language=objc]
  static ImageProvider load(String name) {
    final Future<Map<String, dynamic>?> loadInfo =
        _channel.invokeMapMethod<String, dynamic>('loadImage', name);
    final Completer<Uint8List> bytesCompleter = Completer<Uint8List>();
    final Completer<double> scaleCompleter = Completer<double>();
    loadInfo.then((Map<String, dynamic>? map) {
      if (map == null) {
        scaleCompleter.completeError(
          Exception("Image couldn't be found: $name"),
        );
        bytesCompleter.completeError(
          Exception("Image couldn't be found: $name"),
        );
        return;
      }
      scaleCompleter.complete(map['scale']! as double);
      bytesCompleter.complete(map['data']! as Uint8List);
    });
    return _FutureMemoryImage(bytesCompleter.future, scaleCompleter.future);
  }

  /// Loads an image from the system.  The equivalent would be:
  /// `[UIImage systemImageNamed:name]`.
  ///
  /// Throws an exception if the image can't be found.
  ///
  /// **This method requires at least iOS 13.0**
  ///
  /// See [https://developer.apple.com/documentation/uikit/uiimage/configuring_and_displaying_symbol_images_in_your_ui?language=objc]
  static ImageProvider loadSystemImage(
    String name,
    List<Color> colors,
    double pointSize,
    int weightIndex,
    int scaleIndex,
  ) {
    final List<double> colorsRGBA = colors
        .expand((Color color) => <double>[
              color.red.toDouble() / 255,
              color.green.toDouble() / 255,
              color.blue.toDouble() / 255,
              color.alpha.toDouble() / 255,
            ])
        .toList();

    final Future<Map<String, dynamic>?> loadInfo =
        _channel.invokeMapMethod<String, dynamic>(
      'loadSystemImage',
      <dynamic>[
        name,
        pointSize,
        weightIndex,
        scaleIndex,
        colorsRGBA,
      ],
    );
    final Completer<Uint8List> bytesCompleter = Completer<Uint8List>();
    final Completer<double> scaleCompleter = Completer<double>();
    loadInfo.then((Map<String, dynamic>? map) {
      if (map == null) {
        scaleCompleter.completeError(
          Exception("System image couldn't be found: $name"),
        );
        bytesCompleter.completeError(
          Exception("System image couldn't be found: $name"),
        );
        return;
      }
      scaleCompleter.complete(map['scale']! as double);
      bytesCompleter.complete(map['data']! as Uint8List);
    });
    return _FutureMemoryImage(bytesCompleter.future, scaleCompleter.future);
  }

  /// Resolves an URL for a resource.  The equivalent would be:
  /// `[[NSBundle mainBundle] URLForResource:name withExtension:ext]`.
  ///
  /// Returns null if the resource can't be found.
  ///
  /// See [https://developer.apple.com/documentation/foundation/nsbundle/1411540-urlforresource?language=objc]
  static Future<String?> resolveURL(String name, {String? extension}) {
    return _channel
        .invokeMethod<String>('resolveURL', <Object?>[name, extension]);
  }
}
