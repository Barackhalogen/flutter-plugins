// Mocks generated by Mockito 5.0.16 from annotations
// in webview_flutter_platform_interface/test/src/v4/types/web_resource_error_delegate_test.dart.
// Do not manually edit this file.

import 'package:mockito/mockito.dart' as _i1;
import 'package:webview_flutter_platform_interface/src/v4/webview_platform.dart'
    as _i2;

// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types

/// A class which mocks [WebResourceErrorDelegate].
///
/// See the documentation for Mockito's code generation for more information.
class MockWebResourceErrorDelegate extends _i1.Mock
    implements _i2.WebResourceErrorDelegate {
  MockWebResourceErrorDelegate() {
    _i1.throwOnMissingStub(this);
  }

  @override
  int get errorCode =>
      (super.noSuchMethod(Invocation.getter(#errorCode), returnValue: 0)
          as int);
  @override
  String get description =>
      (super.noSuchMethod(Invocation.getter(#description), returnValue: '')
          as String);
  @override
  String toString() => super.toString();
}
