// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:math';

import '../web_kit/web_kit.dart';

/// A view that allows the scrolling and zooming of its contained views.
///
/// Wraps [UIScrollView](https://developer.apple.com/documentation/uikit/uiscrollview?language=objc).
class UIScrollView {
  /// Constructs a [UIScrollView] that is owned by [webView].
  // TODO(bparrishMines): Remove ignore once constructor is implemented.
  // ignore: avoid_unused_constructor_parameters
  UIScrollView.fromWebView(WKWebView webView);

  /// Point at which the origin of the content view is offset from the origin of the scroll view.
  Future<Point<double>> get contentOffset {
    throw UnimplementedError();
  }

  /// Set point at which the origin of the content view is offset from the origin of the scroll view.
  ///
  /// The default value is `Point<double>(0.0, 0.0)`.
  set contentOffset(FutureOr<Point<double>> offset) {
    throw UnimplementedError();
  }
}
