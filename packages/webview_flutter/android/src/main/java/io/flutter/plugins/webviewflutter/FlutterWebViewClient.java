// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package io.flutter.plugins.webviewflutter;

import android.annotation.TargetApi;
import android.graphics.Bitmap;
import android.os.Build;
import android.util.Log;
import android.webkit.WebResourceError;
import android.webkit.WebResourceRequest;
import android.webkit.WebResourceResponse;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import androidx.annotation.NonNull;
import androidx.webkit.WebViewClientCompat;
import io.flutter.plugin.common.MethodChannel;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

// We need to use WebViewClientCompat to get
// shouldOverrideUrlLoading(WebView view, WebResourceRequest request)
// invoked by the webview on older Android devices, without it pages that use iframes will
// be broken when a navigationDelegate is set on Android version earlier than N.
class FlutterWebViewClient {
  private static final String TAG = "FlutterWebViewClient";
  private final MethodChannel methodChannel;
  private boolean hasNavigationDelegate;

  FlutterWebViewClient(MethodChannel methodChannel) {
    this.methodChannel = methodChannel;
  }

  @TargetApi(Build.VERSION_CODES.LOLLIPOP)
  private boolean shouldOverrideUrlLoading(WebView view, WebResourceRequest request) {
    if (!hasNavigationDelegate) {
      return false;
    }
    notifyOnNavigationRequest(
        request.getUrl().toString(), request.getRequestHeaders(), view, request.isForMainFrame());
    // We must make a synchronous decision here whether to allow the navigation or not,
    // if the Dart code has set a navigation delegate we want that delegate to decide whether
    // to navigate or not, and as we cannot get a response from the Dart delegate synchronously we
    // return true here to block the navigation, if the Dart delegate decides to allow the
    // navigation the plugin will later make an addition loadUrl call for this url.
    //
    // Since we cannot call loadUrl for a subframe, we currently only allow the delegate to stop
    // navigations that target the main frame, if the request is not for the main frame
    // we just return false to allow the navigation.
    //
    // For more details see: https://github.com/flutter/flutter/issues/25329#issuecomment-464863209
    return request.isForMainFrame();
  }

  private boolean shouldOverrideUrlLoading(WebView view, String url) {
    if (!hasNavigationDelegate) {
      return false;
    }
    // This version of shouldOverrideUrlLoading is only invoked by the webview on devices with
    // webview versions  earlier than 67(it is also invoked when hasNavigationDelegate is false).
    // On these devices we cannot tell whether the navigation is targeted to the main frame or not.
    // We proceed assuming that the navigation is targeted to the main frame. If the page had any
    // frames they will be loaded in the main frame instead.
    Log.w(
        TAG,
        "Using a navigationDelegate with an old webview implementation, pages with frames or iframes will not work");
    notifyOnNavigationRequest(url, null, view, true);
    return true;
  }

  private void onPageFinished(WebView view, String url) {
    Map<String, Object> args = new HashMap<>();
    args.put("url", url);
    methodChannel.invokeMethod("onPageFinished", args);
  }

  private void onPageStarted(WebView view, String url, Bitmap favicon) {
    methodChannel.invokeMethod("onPageStarted", Collections.singletonMap("url", url));
  }

  private String parseWebViewErrorCode(int errorCode) {
    switch (errorCode) {
      case WebViewClient.ERROR_CONNECT:
        return "connect";
      case WebViewClient.ERROR_FAILED_SSL_HANDSHAKE:
        return "failedSslHandshake";
      case WebViewClient.ERROR_BAD_URL:
        return "badUrl";
      case WebViewClient.ERROR_TOO_MANY_REQUESTS:
        return "tooManyRequests";
      case WebViewClient.ERROR_REDIRECT_LOOP:
        return "redirectLoop";
      default:
        return "unknown";
    }
  }

  private void onReceivedError(WebView view, WebResourceRequest request, WebResourceError error) {
    Map<String, Object> map = new HashMap<>();
    map.put("isConnectError", true);
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
      map.put("description", error.getDescription().toString());
      map.put("connectErrorType", parseWebViewErrorCode(error.getErrorCode()));
    } else {
      map.put("description", error.toString());
      map.put("connectErrorType", "unknown");
    }
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
      map.put("url", request.getUrl().toString());
      map.put("isForMainFrame", request.isForMainFrame());
    } else {
      // before Lollipop we only receive errors for the main frame.
      map.put("isForMainFrame", true);
    }
    this.methodChannel.invokeMethod("onReceivedError", map);
  }

  private void onReceivedHttpError(
      WebView view, WebResourceRequest request, WebResourceResponse errorResponse) {
    Map<String, Object> map = new HashMap<>();
    map.put("isConnectError", false);
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
      map.put("url", request.getUrl().toString());
      map.put("description", errorResponse.getReasonPhrase());
      map.put("isForMainFrame", request.isForMainFrame());
    } else {
      // before Lollipop we only receive errors for the main frame.
      map.put("isForMainFrame", true);
    }
    this.methodChannel.invokeMethod("onReceivedError", map);
  }

  private void notifyOnNavigationRequest(
      String url, Map<String, String> headers, WebView webview, boolean isMainFrame) {
    HashMap<String, Object> args = new HashMap<>();
    args.put("url", url);
    args.put("isForMainFrame", isMainFrame);
    if (isMainFrame) {
      methodChannel.invokeMethod(
          "navigationRequest", args, new OnNavigationRequestResult(url, headers, webview));
    } else {
      methodChannel.invokeMethod("navigationRequest", args);
    }
  }

  // This method attempts to avoid using WebViewClientCompat due to bug
  // https://bugs.chromium.org/p/chromium/issues/detail?id=925887. Also, see
  // https://github.com/flutter/flutter/issues/29446.
  WebViewClient createWebViewClient(boolean hasNavigationDelegate) {
    this.hasNavigationDelegate = hasNavigationDelegate;

    if (!hasNavigationDelegate || android.os.Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
      return internalCreateWebViewClient();
    }

    return internalCreateWebViewClientCompat();
  }

  private WebViewClient internalCreateWebViewClient() {
    return new WebViewClient() {
      @TargetApi(Build.VERSION_CODES.N)
      @Override
      public boolean shouldOverrideUrlLoading(WebView view, WebResourceRequest request) {
        return FlutterWebViewClient.this.shouldOverrideUrlLoading(view, request);
      }

      @Override
      public void onPageFinished(WebView view, String url) {
        FlutterWebViewClient.this.onPageFinished(view, url);
      }

      @Override
      public void onPageStarted(WebView view, String url, Bitmap favicon) {
        FlutterWebViewClient.this.onPageStarted(view, url, favicon);
      }

      @Override
      public void onReceivedError(
          WebView view, WebResourceRequest request, WebResourceError error) {
        FlutterWebViewClient.this.onReceivedError(view, request, error);
      }

      @Override
      public void onReceivedHttpError(
          WebView view, WebResourceRequest request, WebResourceResponse errorResponse) {
        FlutterWebViewClient.this.onReceivedHttpError(view, request, errorResponse);
      }
    };
  }

  private WebViewClientCompat internalCreateWebViewClientCompat() {
    return new WebViewClientCompat() {
      @Override
      public boolean shouldOverrideUrlLoading(
          @NonNull WebView view, @NonNull WebResourceRequest request) {
        return FlutterWebViewClient.this.shouldOverrideUrlLoading(view, request);
      }

      @Override
      public boolean shouldOverrideUrlLoading(WebView view, String url) {
        return FlutterWebViewClient.this.shouldOverrideUrlLoading(view, url);
      }

      @Override
      public void onPageFinished(WebView view, String url) {
        FlutterWebViewClient.this.onPageFinished(view, url);
      }
    };
  }

  private static class OnNavigationRequestResult implements MethodChannel.Result {
    private final String url;
    private final Map<String, String> headers;
    private final WebView webView;

    private OnNavigationRequestResult(String url, Map<String, String> headers, WebView webView) {
      this.url = url;
      this.headers = headers;
      this.webView = webView;
    }

    @Override
    public void success(Object shouldLoad) {
      Boolean typedShouldLoad = (Boolean) shouldLoad;
      if (typedShouldLoad) {
        loadUrl();
      }
    }

    @Override
    public void error(String errorCode, String s1, Object o) {
      throw new IllegalStateException("navigationRequest calls must succeed");
    }

    @Override
    public void notImplemented() {
      throw new IllegalStateException(
          "navigationRequest must be implemented by the webview method channel");
    }

    private void loadUrl() {
      if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
        webView.loadUrl(url, headers);
      } else {
        webView.loadUrl(url);
      }
    }
  }
}
