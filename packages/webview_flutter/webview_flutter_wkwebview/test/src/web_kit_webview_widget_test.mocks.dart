// Mocks generated by Mockito 5.1.0 from annotations
// in webview_flutter_wkwebview/test/src/web_kit_webview_widget_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i7;
import 'dart:math' as _i3;

import 'package:mockito/mockito.dart' as _i1;
import 'package:webview_flutter_platform_interface/src/types/javascript_channel.dart'
    as _i10;
import 'package:webview_flutter_platform_interface/src/types/types.dart'
    as _i11;
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart'
    as _i9;
import 'package:webview_flutter_wkwebview/src/foundation/foundation.dart'
    as _i8;
import 'package:webview_flutter_wkwebview/src/foundation/foundation_api_impls.dart'
    as _i6;
import 'package:webview_flutter_wkwebview/src/ui_kit/ui_kit.dart' as _i5;
import 'package:webview_flutter_wkwebview/src/ui_kit/ui_kit_api_impls.dart'
    as _i2;
import 'package:webview_flutter_wkwebview/src/web_kit/web_kit.dart' as _i4;
import 'package:webview_flutter_wkwebview/src/web_kit_webview_widget.dart'
    as _i12;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types

class _FakeUIScrollViewHostApiImpl_0 extends _i1.Fake
    implements _i2.UIScrollViewHostApiImpl {}

class _FakePoint_1<T extends num> extends _i1.Fake implements _i3.Point<T> {}

class _FakeWKWebViewConfiguration_2 extends _i1.Fake
    implements _i4.WKWebViewConfiguration {}

class _FakeUIScrollView_3 extends _i1.Fake implements _i5.UIScrollView {}

class _FakeNSObjectHostApiImpl_4 extends _i1.Fake
    implements _i6.NSObjectHostApiImpl {}

class _FakeWKUserContentController_5 extends _i1.Fake
    implements _i4.WKUserContentController {}

class _FakeWKWebsiteDataStore_6 extends _i1.Fake
    implements _i4.WKWebsiteDataStore {}

class _FakeWKWebView_7 extends _i1.Fake implements _i4.WKWebView {}

class _FakeWKScriptMessageHandler_8 extends _i1.Fake
    implements _i4.WKScriptMessageHandler {}

class _FakeWKUIDelegate_9 extends _i1.Fake implements _i4.WKUIDelegate {}

class _FakeWKNavigationDelegate_10 extends _i1.Fake
    implements _i4.WKNavigationDelegate {}

/// A class which mocks [UIScrollView].
///
/// See the documentation for Mockito's code generation for more information.
class MockUIScrollView extends _i1.Mock implements _i5.UIScrollView {
  MockUIScrollView() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.UIScrollViewHostApiImpl get scrollViewApi =>
      (super.noSuchMethod(Invocation.getter(#scrollViewApi),
              returnValue: _FakeUIScrollViewHostApiImpl_0())
          as _i2.UIScrollViewHostApiImpl);
  @override
  _i7.Future<_i3.Point<double>> getContentOffset() => (super.noSuchMethod(
          Invocation.method(#getContentOffset, []),
          returnValue: Future<_i3.Point<double>>.value(_FakePoint_1<double>()))
      as _i7.Future<_i3.Point<double>>);
  @override
  _i7.Future<void> scrollBy(_i3.Point<double>? offset) =>
      (super.noSuchMethod(Invocation.method(#scrollBy, [offset]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i7.Future<void>);
  @override
  _i7.Future<void> setContentOffset(_i7.FutureOr<_i3.Point<double>>? offset) =>
      (super.noSuchMethod(Invocation.method(#setContentOffset, [offset]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i7.Future<void>);
}

/// A class which mocks [WKNavigationDelegate].
///
/// See the documentation for Mockito's code generation for more information.
class MockWKNavigationDelegate extends _i1.Mock
    implements _i4.WKNavigationDelegate {
  MockWKNavigationDelegate() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i7.Future<void> setDidStartProvisionalNavigation(
          void Function(_i4.WKWebView, String?)?
              didStartProvisionalNavigation) =>
      (super.noSuchMethod(
          Invocation.method(#setDidStartProvisionalNavigation,
              [didStartProvisionalNavigation]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i7.Future<void>);
  @override
  _i7.Future<void> setDidFinishNavigation(
          void Function(_i4.WKWebView, String?)? didFinishNavigation) =>
      (super.noSuchMethod(
          Invocation.method(#setDidFinishNavigation, [didFinishNavigation]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i7.Future<void>);
  @override
  _i7.Future<void> setDecidePolicyForNavigationAction(
          _i7.Future<_i4.WKNavigationActionPolicy> Function(
                  _i4.WKWebView, _i4.WKNavigationAction)?
              decidePolicyForNavigationAction) =>
      (super.noSuchMethod(
          Invocation.method(#setDecidePolicyForNavigationAction,
              [decidePolicyForNavigationAction]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i7.Future<void>);
  @override
  _i7.Future<void> setDidFailNavigation(
          void Function(_i4.WKWebView, _i8.NSError)? didFailNavigation) =>
      (super.noSuchMethod(
          Invocation.method(#setDidFailNavigation, [didFailNavigation]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i7.Future<void>);
  @override
  _i7.Future<void> setDidFailProvisionalNavigation(
          void Function(_i4.WKWebView, _i8.NSError)?
              didFailProvisionalNavigation) =>
      (super.noSuchMethod(
          Invocation.method(
              #setDidFailProvisionalNavigation, [didFailProvisionalNavigation]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i7.Future<void>);
  @override
  _i7.Future<void> setWebViewWebContentProcessDidTerminate(
          void Function(_i4.WKWebView)? webViewWebContentProcessDidTerminate) =>
      (super.noSuchMethod(
          Invocation.method(#setWebViewWebContentProcessDidTerminate,
              [webViewWebContentProcessDidTerminate]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i7.Future<void>);
}

/// A class which mocks [WKScriptMessageHandler].
///
/// See the documentation for Mockito's code generation for more information.
class MockWKScriptMessageHandler extends _i1.Mock
    implements _i4.WKScriptMessageHandler {
  MockWKScriptMessageHandler() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i7.Future<void> setDidReceiveScriptMessage(
          void Function(_i4.WKUserContentController, _i4.WKScriptMessage)?
              didReceiveScriptMessage) =>
      (super.noSuchMethod(
          Invocation.method(
              #setDidReceiveScriptMessage, [didReceiveScriptMessage]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i7.Future<void>);
}

/// A class which mocks [WKWebView].
///
/// See the documentation for Mockito's code generation for more information.
class MockWKWebView extends _i1.Mock implements _i4.WKWebView {
  MockWKWebView() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.WKWebViewConfiguration get configuration =>
      (super.noSuchMethod(Invocation.getter(#configuration),
              returnValue: _FakeWKWebViewConfiguration_2())
          as _i4.WKWebViewConfiguration);
  @override
  _i5.UIScrollView get scrollView =>
      (super.noSuchMethod(Invocation.getter(#scrollView),
          returnValue: _FakeUIScrollView_3()) as _i5.UIScrollView);
  @override
  _i6.NSObjectHostApiImpl get objectApi => (super.noSuchMethod(
      Invocation.getter(#objectApi),
      returnValue: _FakeNSObjectHostApiImpl_4()) as _i6.NSObjectHostApiImpl);
  @override
  set observeValue(
          void Function(
                  String, _i8.NSObject, Map<_i8.NSKeyValueChangeKey, Object?>)?
              observeValue) =>
      super.noSuchMethod(Invocation.setter(#observeValue, observeValue),
          returnValueForMissingStub: null);
  @override
  _i7.Future<void> setUIDelegate(_i4.WKUIDelegate? delegate) =>
      (super.noSuchMethod(Invocation.method(#setUIDelegate, [delegate]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i7.Future<void>);
  @override
  _i7.Future<void> setNavigationDelegate(_i4.WKNavigationDelegate? delegate) =>
      (super.noSuchMethod(Invocation.method(#setNavigationDelegate, [delegate]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i7.Future<void>);
  @override
  _i7.Future<String?> getUrl() =>
      (super.noSuchMethod(Invocation.method(#getUrl, []),
          returnValue: Future<String?>.value()) as _i7.Future<String?>);
  @override
  _i7.Future<double> getEstimatedProgress() =>
      (super.noSuchMethod(Invocation.method(#getEstimatedProgress, []),
          returnValue: Future<double>.value(0.0)) as _i7.Future<double>);
  @override
  _i7.Future<void> loadRequest(_i8.NSUrlRequest? request) =>
      (super.noSuchMethod(Invocation.method(#loadRequest, [request]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i7.Future<void>);
  @override
  _i7.Future<void> loadHtmlString(String? string, {String? baseUrl}) =>
      (super.noSuchMethod(
          Invocation.method(#loadHtmlString, [string], {#baseUrl: baseUrl}),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i7.Future<void>);
  @override
  _i7.Future<void> loadFileUrl(String? url, {String? readAccessUrl}) =>
      (super.noSuchMethod(
          Invocation.method(
              #loadFileUrl, [url], {#readAccessUrl: readAccessUrl}),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i7.Future<void>);
  @override
  _i7.Future<void> loadFlutterAsset(String? key) =>
      (super.noSuchMethod(Invocation.method(#loadFlutterAsset, [key]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i7.Future<void>);
  @override
  _i7.Future<bool> canGoBack() =>
      (super.noSuchMethod(Invocation.method(#canGoBack, []),
          returnValue: Future<bool>.value(false)) as _i7.Future<bool>);
  @override
  _i7.Future<bool> canGoForward() =>
      (super.noSuchMethod(Invocation.method(#canGoForward, []),
          returnValue: Future<bool>.value(false)) as _i7.Future<bool>);
  @override
  _i7.Future<void> goBack() =>
      (super.noSuchMethod(Invocation.method(#goBack, []),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i7.Future<void>);
  @override
  _i7.Future<void> goForward() =>
      (super.noSuchMethod(Invocation.method(#goForward, []),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i7.Future<void>);
  @override
  _i7.Future<void> reload() =>
      (super.noSuchMethod(Invocation.method(#reload, []),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i7.Future<void>);
  @override
  _i7.Future<String?> getTitle() =>
      (super.noSuchMethod(Invocation.method(#getTitle, []),
          returnValue: Future<String?>.value()) as _i7.Future<String?>);
  @override
  _i7.Future<void> setAllowsBackForwardNavigationGestures(bool? allow) =>
      (super.noSuchMethod(
          Invocation.method(#setAllowsBackForwardNavigationGestures, [allow]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i7.Future<void>);
  @override
  _i7.Future<void> setCustomUserAgent(String? userAgent) =>
      (super.noSuchMethod(Invocation.method(#setCustomUserAgent, [userAgent]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i7.Future<void>);
  @override
  _i7.Future<Object?> evaluateJavaScript(String? javaScriptString) => (super
      .noSuchMethod(Invocation.method(#evaluateJavaScript, [javaScriptString]),
          returnValue: Future<Object?>.value()) as _i7.Future<Object?>);
  @override
  _i7.Future<void> addObserver(_i8.NSObject? observer,
          {String? keyPath, Set<_i8.NSKeyValueObservingOptions>? options}) =>
      (super.noSuchMethod(
          Invocation.method(
              #addObserver, [observer], {#keyPath: keyPath, #options: options}),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i7.Future<void>);
  @override
  _i7.Future<void> removeObserver(_i8.NSObject? observer, {String? keyPath}) =>
      (super.noSuchMethod(
          Invocation.method(#removeObserver, [observer], {#keyPath: keyPath}),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i7.Future<void>);
  @override
  _i7.Future<void> dispose() =>
      (super.noSuchMethod(Invocation.method(#dispose, []),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i7.Future<void>);
}

/// A class which mocks [WKWebViewConfiguration].
///
/// See the documentation for Mockito's code generation for more information.
class MockWKWebViewConfiguration extends _i1.Mock
    implements _i4.WKWebViewConfiguration {
  MockWKWebViewConfiguration() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.WKUserContentController get userContentController =>
      (super.noSuchMethod(Invocation.getter(#userContentController),
              returnValue: _FakeWKUserContentController_5())
          as _i4.WKUserContentController);
  @override
  _i4.WKWebsiteDataStore get websiteDataStore =>
      (super.noSuchMethod(Invocation.getter(#websiteDataStore),
          returnValue: _FakeWKWebsiteDataStore_6()) as _i4.WKWebsiteDataStore);
  @override
  _i7.Future<void> setAllowsInlineMediaPlayback(bool? allow) => (super
      .noSuchMethod(Invocation.method(#setAllowsInlineMediaPlayback, [allow]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i7.Future<void>);
  @override
  _i7.Future<void> setMediaTypesRequiringUserActionForPlayback(
          Set<_i4.WKAudiovisualMediaType>? types) =>
      (super.noSuchMethod(
          Invocation.method(
              #setMediaTypesRequiringUserActionForPlayback, [types]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i7.Future<void>);
}

/// A class which mocks [WKWebsiteDataStore].
///
/// See the documentation for Mockito's code generation for more information.
class MockWKWebsiteDataStore extends _i1.Mock
    implements _i4.WKWebsiteDataStore {
  MockWKWebsiteDataStore() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i7.Future<void> removeDataOfTypes(
          Set<_i4.WKWebsiteDataTypes>? dataTypes, DateTime? since) =>
      (super.noSuchMethod(
          Invocation.method(#removeDataOfTypes, [dataTypes, since]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i7.Future<void>);
}

/// A class which mocks [WKUIDelegate].
///
/// See the documentation for Mockito's code generation for more information.
class MockWKUIDelegate extends _i1.Mock implements _i4.WKUIDelegate {
  MockWKUIDelegate() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i7.Future<void> setOnCreateWebView(
          void Function(_i4.WKWebViewConfiguration, _i4.WKNavigationAction)?
              onCreateWebView) =>
      (super.noSuchMethod(
          Invocation.method(#setOnCreateWebView, [onCreateWebView]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i7.Future<void>);
}

/// A class which mocks [WKUserContentController].
///
/// See the documentation for Mockito's code generation for more information.
class MockWKUserContentController extends _i1.Mock
    implements _i4.WKUserContentController {
  MockWKUserContentController() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i7.Future<void> addScriptMessageHandler(
          _i4.WKScriptMessageHandler? handler, String? name) =>
      (super.noSuchMethod(
          Invocation.method(#addScriptMessageHandler, [handler, name]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i7.Future<void>);
  @override
  _i7.Future<void> removeScriptMessageHandler(String? name) => (super
      .noSuchMethod(Invocation.method(#removeScriptMessageHandler, [name]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i7.Future<void>);
  @override
  _i7.Future<void> removeAllScriptMessageHandlers() => (super.noSuchMethod(
      Invocation.method(#removeAllScriptMessageHandlers, []),
      returnValue: Future<void>.value(),
      returnValueForMissingStub: Future<void>.value()) as _i7.Future<void>);
  @override
  _i7.Future<void> addUserScript(_i4.WKUserScript? userScript) =>
      (super.noSuchMethod(Invocation.method(#addUserScript, [userScript]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i7.Future<void>);
  @override
  _i7.Future<void> removeAllUserScripts() =>
      (super.noSuchMethod(Invocation.method(#removeAllUserScripts, []),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i7.Future<void>);
}

/// A class which mocks [JavascriptChannelRegistry].
///
/// See the documentation for Mockito's code generation for more information.
class MockJavascriptChannelRegistry extends _i1.Mock
    implements _i9.JavascriptChannelRegistry {
  MockJavascriptChannelRegistry() {
    _i1.throwOnMissingStub(this);
  }

  @override
  Map<String, _i10.JavascriptChannel> get channels =>
      (super.noSuchMethod(Invocation.getter(#channels),
              returnValue: <String, _i10.JavascriptChannel>{})
          as Map<String, _i10.JavascriptChannel>);
  @override
  void onJavascriptChannelMessage(String? channel, String? message) =>
      super.noSuchMethod(
          Invocation.method(#onJavascriptChannelMessage, [channel, message]),
          returnValueForMissingStub: null);
  @override
  void updateJavascriptChannelsFromSet(Set<_i10.JavascriptChannel>? channels) =>
      super.noSuchMethod(
          Invocation.method(#updateJavascriptChannelsFromSet, [channels]),
          returnValueForMissingStub: null);
}

/// A class which mocks [WebViewPlatformCallbacksHandler].
///
/// See the documentation for Mockito's code generation for more information.
class MockWebViewPlatformCallbacksHandler extends _i1.Mock
    implements _i9.WebViewPlatformCallbacksHandler {
  MockWebViewPlatformCallbacksHandler() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i7.FutureOr<bool> onNavigationRequest({String? url, bool? isForMainFrame}) =>
      (super.noSuchMethod(
          Invocation.method(#onNavigationRequest, [],
              {#url: url, #isForMainFrame: isForMainFrame}),
          returnValue: Future<bool>.value(false)) as _i7.FutureOr<bool>);
  @override
  void onPageStarted(String? url) =>
      super.noSuchMethod(Invocation.method(#onPageStarted, [url]),
          returnValueForMissingStub: null);
  @override
  void onPageFinished(String? url) =>
      super.noSuchMethod(Invocation.method(#onPageFinished, [url]),
          returnValueForMissingStub: null);
  @override
  void onProgress(int? progress) =>
      super.noSuchMethod(Invocation.method(#onProgress, [progress]),
          returnValueForMissingStub: null);
  @override
  void onWebResourceError(_i11.WebResourceError? error) =>
      super.noSuchMethod(Invocation.method(#onWebResourceError, [error]),
          returnValueForMissingStub: null);
}

/// A class which mocks [WebViewWidgetProxy].
///
/// See the documentation for Mockito's code generation for more information.
class MockWebViewWidgetProxy extends _i1.Mock
    implements _i12.WebViewWidgetProxy {
  MockWebViewWidgetProxy() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.WKWebView createWebView(_i4.WKWebViewConfiguration? configuration) =>
      (super.noSuchMethod(Invocation.method(#createWebView, [configuration]),
          returnValue: _FakeWKWebView_7()) as _i4.WKWebView);
  @override
  _i4.WKScriptMessageHandler createScriptMessageHandler() =>
      (super.noSuchMethod(Invocation.method(#createScriptMessageHandler, []),
              returnValue: _FakeWKScriptMessageHandler_8())
          as _i4.WKScriptMessageHandler);
  @override
  _i4.WKUIDelegate createUIDelgate() =>
      (super.noSuchMethod(Invocation.method(#createUIDelgate, []),
          returnValue: _FakeWKUIDelegate_9()) as _i4.WKUIDelegate);
  @override
  _i4.WKNavigationDelegate createNavigationDelegate() => (super.noSuchMethod(
      Invocation.method(#createNavigationDelegate, []),
      returnValue: _FakeWKNavigationDelegate_10()) as _i4.WKNavigationDelegate);
}
