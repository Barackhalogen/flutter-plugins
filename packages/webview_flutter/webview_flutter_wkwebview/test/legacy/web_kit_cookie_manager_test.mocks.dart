// Mocks generated by Mockito 5.3.2 from annotations
// in webview_flutter_wkwebview/example/ios/.symlinks/plugins/webview_flutter_wkwebview/test/legacy/web_kit_cookie_manager_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i3;

import 'package:mockito/mockito.dart' as _i1;
import 'package:webview_flutter_wkwebview/src/foundation/foundation.dart'
    as _i4;
import 'package:webview_flutter_wkwebview/src/web_kit/web_kit.dart' as _i2;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeWKHttpCookieStore_0 extends _i1.SmartFake
    implements _i2.WKHttpCookieStore {
  _FakeWKHttpCookieStore_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeWKWebsiteDataStore_1 extends _i1.SmartFake
    implements _i2.WKWebsiteDataStore {
  _FakeWKWebsiteDataStore_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [WKHttpCookieStore].
///
/// See the documentation for Mockito's code generation for more information.
// ignore: must_be_immutable
class MockWKHttpCookieStore extends _i1.Mock implements _i2.WKHttpCookieStore {
  MockWKHttpCookieStore() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Future<void> setCookie(_i4.NSHttpCookie? cookie) => (super.noSuchMethod(
        Invocation.method(
          #setCookie,
          [cookie],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);
  @override
  _i2.WKHttpCookieStore copy() => (super.noSuchMethod(
        Invocation.method(
          #copy,
          [],
        ),
        returnValue: _FakeWKHttpCookieStore_0(
          this,
          Invocation.method(
            #copy,
            [],
          ),
        ),
      ) as _i2.WKHttpCookieStore);
  @override
  _i3.Future<void> addObserver(
    _i4.NSObject? observer, {
    required String? keyPath,
    required Set<_i4.NSKeyValueObservingOptions>? options,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #addObserver,
          [observer],
          {
            #keyPath: keyPath,
            #options: options,
          },
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);
  @override
  _i3.Future<void> removeObserver(
    _i4.NSObject? observer, {
    required String? keyPath,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #removeObserver,
          [observer],
          {#keyPath: keyPath},
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);
}

/// A class which mocks [WKWebsiteDataStore].
///
/// See the documentation for Mockito's code generation for more information.
// ignore: must_be_immutable
class MockWKWebsiteDataStore extends _i1.Mock
    implements _i2.WKWebsiteDataStore {
  MockWKWebsiteDataStore() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.WKHttpCookieStore get httpCookieStore => (super.noSuchMethod(
        Invocation.getter(#httpCookieStore),
        returnValue: _FakeWKHttpCookieStore_0(
          this,
          Invocation.getter(#httpCookieStore),
        ),
      ) as _i2.WKHttpCookieStore);
  @override
  _i3.Future<bool> removeDataOfTypes(
    Set<_i2.WKWebsiteDataType>? dataTypes,
    DateTime? since,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #removeDataOfTypes,
          [
            dataTypes,
            since,
          ],
        ),
        returnValue: _i3.Future<bool>.value(false),
      ) as _i3.Future<bool>);
  @override
  _i2.WKWebsiteDataStore copy() => (super.noSuchMethod(
        Invocation.method(
          #copy,
          [],
        ),
        returnValue: _FakeWKWebsiteDataStore_1(
          this,
          Invocation.method(
            #copy,
            [],
          ),
        ),
      ) as _i2.WKWebsiteDataStore);
  @override
  _i3.Future<void> addObserver(
    _i4.NSObject? observer, {
    required String? keyPath,
    required Set<_i4.NSKeyValueObservingOptions>? options,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #addObserver,
          [observer],
          {
            #keyPath: keyPath,
            #options: options,
          },
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);
  @override
  _i3.Future<void> removeObserver(
    _i4.NSObject? observer, {
    required String? keyPath,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #removeObserver,
          [observer],
          {#keyPath: keyPath},
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);
}
