// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'navigation_callback_delegate.dart';
import 'types/types.dart';
import 'webview_controller_delegate.dart';
import 'webview_cookie_manager_delegate.dart';
import 'webview_widget_delegate.dart';

export 'types/types.dart';

/// Interface for a platform implementation of a WebView.
abstract class WebViewPlatform extends PlatformInterface {
  /// Creates a new [WebViewPlatform].
  WebViewPlatform() : super(token: _token);

  static final Object _token = Object();

  static WebViewPlatform? _instance;

  /// The instance of [WebViewPlatform] to use.
  static WebViewPlatform? get instance => _instance;

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [WebViewPlatform] when they register themselves.
  static set instance(WebViewPlatform? instance) {
    if (instance == null) {
      throw AssertionError(
          'Platform interfaces can only be set to a non-null instance');
    }

    PlatformInterface.verify(instance, _token);
    _instance = instance;
  }

  /// Creates a new [WebViewCookieManagerDelegate].
  ///
  /// This function should only be called by the app-facing package.
  /// Look at using [WebViewCookieManager] in `webview_flutter` instead.
  WebViewCookieManagerDelegate createCookieManagerDelegate(
    WebViewCookieManagerCreationParams params,
  ) {
    throw UnimplementedError(
        'createCookieManagerDelegate is not implemented on the current platform.');
  }

  /// Creates a new [NavigationCallbackDelegate].
  ///
  /// This function should only be called by the app-facing package.
  /// Look at using [NavigationCallbackHandler] in `webview_flutter` instead.
  NavigationCallbackDelegate createNavigationCallbackDelegate(
    NavigationCallbackCreationParams params,
  ) {
    throw UnimplementedError(
        'createNavigationCallbackDelegate is not implemented on the current platform.');
  }

  /// Create a new [WebViewControllerDelegate].
  ///
  /// This function should only be called by the app-facing package.
  /// Look at using [WebViewController] in `webview_flutter` instead.
  WebViewControllerDelegate createWebViewControllerDelegate(
    WebViewControllerCreationParams params,
  ) {
    throw UnimplementedError(
        'createWebViewControllerDelegate is not implemented on the current platform.');
  }

  /// Create a new [WebViewWidgetDelegate].
  ///
  /// This function should only be called by the app-facing package.
  /// Look at using [WebViewWidget] in `webview_flutter` instead.
  WebViewWidgetDelegate createWebViewWidgetDelegate(
    WebViewWidgetCreationParams params,
  ) {
    throw UnimplementedError(
        'createWebViewWidgetDelegate is not implemented on the current platform.');
  }
}
