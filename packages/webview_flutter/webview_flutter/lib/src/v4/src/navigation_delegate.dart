// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:webview_flutter_platform_interface/v4/webview_flutter_platform_interface.dart';

import 'webview_controller.dart';

/// Callbacks for accepting or rejecting navigation changes, and for tracking
/// the progress of navigation requests.
///
/// See [WebViewController.setNavigationDelegate].
class NavigationDelegate {
  /// Constructs a [NavigationDelegate].
  NavigationDelegate({
    FutureOr<bool> Function({
      required String url,
      required bool isForMainFrame,
    })?
        onNavigationRequest,
    void Function(String url)? onPageStarted,
    void Function(String url)? onPageFinished,
    void Function(int progress)? onProgress,
    void Function(WebResourceError error)? onWebResourceError,
  }) : this.fromPlatformCreationParams(
          const PlatformNavigationDelegateCreationParams(),
          onNavigationRequest: onNavigationRequest,
          onPageStarted: onPageStarted,
          onPageFinished: onPageFinished,
          onProgress: onProgress,
          onWebResourceError: onWebResourceError,
        );

  /// Constructs a [NavigationDelegate] from creation params for a specific
  /// platform.
  NavigationDelegate.fromPlatformCreationParams(
    PlatformNavigationDelegateCreationParams params, {
    FutureOr<bool> Function({
      required String url,
      required bool isForMainFrame,
    })?
        onNavigationRequest,
    void Function(String url)? onPageStarted,
    void Function(String url)? onPageFinished,
    void Function(int progress)? onProgress,
    void Function(WebResourceError error)? onWebResourceError,
  }) : this.fromPlatform(
          PlatformNavigationDelegate(params),
          onNavigationRequest: onNavigationRequest,
          onPageStarted: onPageStarted,
          onPageFinished: onPageFinished,
          onProgress: onProgress,
          onWebResourceError: onWebResourceError,
        );

  /// Constructs a [NavigationDelegate] from a specific platform implementation.
  NavigationDelegate.fromPlatform(
    this.platform, {
    this.onNavigationRequest,
    this.onPageStarted,
    this.onPageFinished,
    this.onProgress,
    this.onWebResourceError,
  }) {
    if (onNavigationRequest != null) {
      platform.setOnNavigationRequest(onNavigationRequest!);
    }
    if (onPageStarted != null) {
      platform.setOnPageStarted(onPageStarted!);
    }
    if (onPageFinished != null) {
      platform.setOnPageFinished(onPageFinished!);
    }
    if (onProgress != null) {
      platform.setOnProgress(onProgress!);
    }
    if (onWebResourceError != null) {
      platform.setOnWebResourceError(onWebResourceError!);
    }
  }

  /// Implementation of [PlatformNavigationDelegate] for the current platform.
  final PlatformNavigationDelegate platform;

  /// Invoked when a navigation request is pending.
  final FutureOr<bool> Function({
    required String url,
    required bool isForMainFrame,
  })? onNavigationRequest;

  /// Invoked when a page has started loading.
  final void Function(String url)? onPageStarted;

  /// Invoked when a page has finished loading.
  final void Function(String url)? onPageFinished;

  /// Invoked when a page is loading to report the progress.
  final void Function(int progress)? onProgress;

  /// Invoked when a resource loading error occurred.
  final void Function(WebResourceError error)? onWebResourceError;
}
