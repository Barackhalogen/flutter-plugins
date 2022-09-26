// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:webview_flutter_platform_interface/v4/webview_flutter_platform_interface.dart';
import 'package:webview_flutter_wkwebview/src/foundation/foundation.dart';
import 'package:webview_flutter_wkwebview/src/v4/src/webkit_proxy.dart';
import 'package:webview_flutter_wkwebview/src/v4/webview_flutter_wkwebview.dart';
import 'package:webview_flutter_wkwebview/src/web_kit/web_kit.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  group('WebKitNavigationDelegate', () {
    test('setOnPageFinished', () {
      final WebKitNavigationDelegate webKitDelgate = WebKitNavigationDelegate(
        _buildCreationParams(),
      );

      late final String callbackUrl;
      webKitDelgate.setOnPageFinished((String url) => callbackUrl = url);

      CapturingNavigationDelegate.lastCreatedDelegate.didFinishNavigation!(
        WKWebView.detached(),
        'https://www.google.com',
      );

      expect(callbackUrl, 'https://www.google.com');
    });

    test('setOnPageStarted', () {
      final WebKitNavigationDelegate webKitDelgate = WebKitNavigationDelegate(
        _buildCreationParams(),
      );

      late final String callbackUrl;
      webKitDelgate.setOnPageStarted((String url) => callbackUrl = url);

      CapturingNavigationDelegate
          .lastCreatedDelegate.didStartProvisionalNavigation!(
        WKWebView.detached(),
        'https://www.google.com',
      );

      expect(callbackUrl, 'https://www.google.com');
    });

    test('onWebResourceError from didFailNavigation', () {
      final WebKitNavigationDelegate webKitDelgate = WebKitNavigationDelegate(
        _buildCreationParams(),
      );

      late final WebKitWebResourceError callbackError;
      void onWebResourceError(WebResourceError error) {
        callbackError = error as WebKitWebResourceError;
      }

      webKitDelgate.setOnWebResourceError(onWebResourceError);

      CapturingNavigationDelegate.lastCreatedDelegate.didFailNavigation!(
        WKWebView.detached(),
        const NSError(
          code: WKErrorCode.webViewInvalidated,
          domain: 'domain',
          localizedDescription: 'my desc',
        ),
      );

      expect(callbackError.description, 'my desc');
      expect(callbackError.errorCode, WKErrorCode.webViewInvalidated);
      expect(callbackError.domain, 'domain');
      expect(callbackError.errorType, WebResourceErrorType.webViewInvalidated);
    });

    test('onWebResourceError from didFailProvisionalNavigation', () {
      final WebKitNavigationDelegate webKitDelgate = WebKitNavigationDelegate(
        _buildCreationParams(),
      );

      late final WebKitWebResourceError callbackError;
      void onWebResourceError(WebResourceError error) {
        callbackError = error as WebKitWebResourceError;
      }

      webKitDelgate.setOnWebResourceError(onWebResourceError);

      CapturingNavigationDelegate
          .lastCreatedDelegate.didFailProvisionalNavigation!(
        WKWebView.detached(),
        const NSError(
          code: WKErrorCode.webViewInvalidated,
          domain: 'domain',
          localizedDescription: 'my desc',
        ),
      );

      expect(callbackError.description, 'my desc');
      expect(callbackError.errorCode, WKErrorCode.webViewInvalidated);
      expect(callbackError.domain, 'domain');
      expect(callbackError.errorType, WebResourceErrorType.webViewInvalidated);
    });

    test('onWebResourceError from webViewWebContentProcessDidTerminate', () {
      final WebKitNavigationDelegate webKitDelgate = WebKitNavigationDelegate(
        _buildCreationParams(),
      );

      late final WebKitWebResourceError callbackError;
      void onWebResourceError(WebResourceError error) {
        callbackError = error as WebKitWebResourceError;
      }

      webKitDelgate.setOnWebResourceError(onWebResourceError);

      CapturingNavigationDelegate
          .lastCreatedDelegate.webViewWebContentProcessDidTerminate!(
        WKWebView.detached(),
      );

      expect(callbackError.description, '');
      expect(callbackError.errorCode, WKErrorCode.webContentProcessTerminated);
      expect(callbackError.domain, 'WKErrorDomain');
      expect(
        callbackError.errorType,
        WebResourceErrorType.webContentProcessTerminated,
      );
    });

    test('onNavigationRequest from decidePolicyForNavigationAction', () {
      final WebKitNavigationDelegate webKitDelgate = WebKitNavigationDelegate(
        _buildCreationParams(),
      );

      late final NavigationRequest callbackRequest;
      FutureOr<NavigationDecision> onNavigationRequest(
          NavigationRequest request) {
        callbackRequest = request;
        return NavigationDecision.navigate;
      }

      webKitDelgate.setOnNavigationRequest(onNavigationRequest);

      expect(
        CapturingNavigationDelegate
            .lastCreatedDelegate.decidePolicyForNavigationAction!(
          WKWebView.detached(),
          const WKNavigationAction(
            request: NSUrlRequest(url: 'https://www.google.com'),
            targetFrame: WKFrameInfo(isMainFrame: false),
          ),
        ),
        completion(WKNavigationActionPolicy.allow),
      );

      expect(callbackRequest.url, 'https://www.google.com');
      expect(callbackRequest.isMainFrame, isFalse);
    });
  });
}

WebKitNavigationDelegateCreationParams _buildCreationParams() {
  return const WebKitNavigationDelegateCreationParams
      .fromPlatformNavigationDelegateCreationParams(
    PlatformNavigationDelegateCreationParams(),
    webKitProxy: WebKitProxy(
      createNavigationDelegate: CapturingNavigationDelegate.new,
    ),
  );
}

// Records the last created instance of itself.
class CapturingNavigationDelegate extends WKNavigationDelegate {
  CapturingNavigationDelegate({
    super.didFinishNavigation,
    super.didStartProvisionalNavigation,
    super.didFailNavigation,
    super.didFailProvisionalNavigation,
    super.decidePolicyForNavigationAction,
    super.webViewWebContentProcessDidTerminate,
  }) : super.detached() {
    lastCreatedDelegate = this;
  }
  static CapturingNavigationDelegate lastCreatedDelegate =
      CapturingNavigationDelegate();
}
