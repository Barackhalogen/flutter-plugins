// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart'
    show SynchronousFuture, describeIdentity, immutable, objectRuntimeType;
import 'package:flutter/rendering.dart';

import './platform_images_api.g.dart';

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
  static final PlatformImagesApi _api = PlatformImagesApi();

  /// Empty registerWith method.
  static void registerWith() {}

  /// Loads an image from asset catalogs.  The equivalent would be:
  /// `[UIImage imageNamed:name]`.
  ///
  /// Throws an exception if the image can't be found.
  ///
  /// See [https://developer.apple.com/documentation/uikit/uiimage/1624146-imagenamed?language=objc]
  static ImageProvider load(String name) {
    final Future<PlatformImage?> image = _api.getPlatformImage(name);
    return _platformImageToFutureMemoryImage(image, name);
  }

  /// Loads an image from the system.  The equivalent would be:
  /// `[UIImage systemImageNamed:name]`.
  ///
  /// Throws an exception if the image can't be found.
  ///
  /// The [name] is the symbol name as defined by iOS. You can browse a list of
  /// symbols in the SF Symbols app (see below).
  ///
  /// The [pointSize] is the size of the image in iOS font points.
  ///
  /// The [colors] variable is a list of colors to be applied to the corresponding layer
  /// of the icon, assuming that layer exists. An icon can have up to 3 layers,
  /// if a layer color is not specified it will take the color of the most recent
  /// valid index. Defaults to an empty list (black).
  ///
  /// For more information see [https://developer.apple.com/documentation/uikit/uiimagesymbolconfiguration/3810054-configurationwithpalettecolors?language=objc]
  ///
  /// If true, [preferMulticolor] overrides [colors] and asks iOS to provide its
  /// preset multicolor variant of the symbol. Depending on the symbol, these colors
  /// *may not be mutable*. To find out, use the SF Symbols app found at
  /// [https://developer.apple.com/sf-symbols/].
  /// Also note that regardless of mutability, the symbols default colors are
  /// affected by the devices theme preference.
  ///
  /// The [weight] is the weight or thickness of the icon. The default is [FontWeight.normal].
  ///
  /// Multi-layer and multi-color symbols only work on iOS 15.0 and above.
  /// **This method requires at least iOS 13.0.**
  ///
  /// See [https://developer.apple.com/documentation/uikit/uiimage/configuring_and_displaying_symbol_images_in_your_ui?language=objc]
  static ImageProvider loadSystemImage(
    String name,
    double size, {
    List<Color> colors = const <Color>[],
    bool preferMulticolor = false,
    FontWeight weight = FontWeight.regular,
  }) {
    if (preferMulticolor) {
      if (colors != const <Color>[]) {
        throw ArgumentError(
          'preferMulticolor and colors cannot be used together.',
        );
      }
    }

    final List<double> colorsRGBA = colors
        .expand((Color color) => <double>[
              color.red.toDouble() / 255,
              color.green.toDouble() / 255,
              color.blue.toDouble() / 255,
              color.alpha.toDouble() / 255,
            ])
        .toList();

    final Future<PlatformImage?> image =
        _api.getSystemImage(name, size, weight, colorsRGBA, preferMulticolor);

    return _platformImageToFutureMemoryImage(image, name);
  }

  static _FutureMemoryImage _platformImageToFutureMemoryImage(
      Future<PlatformImage?> image, String name) {
    final Completer<Uint8List> bytesCompleter = Completer<Uint8List>();
    final Completer<double> scaleCompleter = Completer<double>();
    image.then((PlatformImage? image) {
      if (image == null || image.bytes == null || image.scale == null) {
        bytesCompleter.completeError(
          ArgumentError("Image couldn't be found: $name"),
        );
        return;
      }

      scaleCompleter.complete(image.scale);
      bytesCompleter.complete(image.bytes);
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
    return _api.resolveURL(name, extension);
  }
}
