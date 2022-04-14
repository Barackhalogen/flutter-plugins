// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'webview_platform.dart';

/// An interface defining navigation events that occur on the native platform.
///
/// The [WebViewControllerDelegate] is notifying this delegate on events that
/// happened on the platform's webview. Platform implementations should
/// implement this class and pass an instance to the[WebViewControllerDelegate].
abstract class NavigationCallbackDelegate extends PlatformInterface {
  /// Creates a new [NavigationCallbackDelegate]
  factory NavigationCallbackDelegate(NavigationCallbackCreationParams params) {
    final NavigationCallbackDelegate callbackDelegate =
        WebViewPlatform.instance!.createNavigationCallbackDelegate(params);
    PlatformInterface.verify(callbackDelegate, _token);
    return callbackDelegate;
  }

  /// Used by the platform implementation to create a new [NavigationCallbackDelegate].
  ///
  /// Should only be used by platform implementations because they can't extend
  /// a class that only contains a factory constructor.
  @protected
  NavigationCallbackDelegate.implementation(this.params) : super(token: _token);

  static final Object _token = Object();

  /// The parameters used to initialize the [NavigationCallbackDelegate].
  final NavigationCallbackCreationParams params;

  /// Invoked when a navigation request is pending.
  ///
  /// See [WebViewControllerDelegate.setNavigationCallbackDelegate].
  Future<void> setOnNavigationRequest(
    FutureOr<bool> Function({required String url, required bool isForMainFrame})
        onNavigationRequest,
  ) {
    throw UnimplementedError(
        'setOnNavigationRequest is not implemented on the current platform.');
  }

  /// Invoked when a page has started loading.
  ///
  /// See [WebViewControllerDelegate.setNavigationCallbackDelegate].
  Future<void> setOnPageStarted(
    void Function(String url) onPageStarted,
  ) {
    throw UnimplementedError(
        'setOnPageStarted is not implemented on the current platform.');
  }

  /// Invoked when a page has finished loading.
  ///
  /// See [WebViewControllerDelegate.setNavigationCallbackDelegate].
  Future<void> setOnPageFinished(
    void Function(String url) onPageFinished,
  ) {
    throw UnimplementedError(
        'setOnPageFinished is not implemented on the current platform.');
  }

  /// Invoked when a page is loading to report the progress.
  ///
  /// See [WebViewControllerDelegate.setNavigationCallbackDelegate].
  Future<void> setOnProgress(
    void Function(int progress) onProgress,
  ) {
    throw UnimplementedError(
        'setOnProgress is not implemented on the current platform.');
  }

  /// Invoked when a resource loading error occurred.
  ///
  /// See [WebViewControllerDelegate.setNavigationCallbackDelegate].
  Future<void> setOnWebResourceError(
    void Function(WebResourceError error) onWebResourceError,
  ) {
    throw UnimplementedError(
        'setOnWebResourceError is not implemented on the current platform.');
  }
}
