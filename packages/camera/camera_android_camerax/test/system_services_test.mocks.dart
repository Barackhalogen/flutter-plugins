// Mocks generated by Mockito 5.3.2 from annotations
// in camera_android_camerax/test/system_services_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i3;

import 'package:camera_android_camerax/src/camerax_library.pigeon.dart' as _i4;
import 'package:mockito/mockito.dart' as _i1;

import 'test_camerax_library.pigeon.dart' as _i2;

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

/// A class which mocks [TestSystemServicesHostApi].
///
/// See the documentation for Mockito's code generation for more information.
class MockTestSystemServicesHostApi extends _i1.Mock
    implements _i2.TestSystemServicesHostApi {
  MockTestSystemServicesHostApi() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Future<_i4.CameraPermissionsErrorData?> requestCameraPermissions(
          bool? enableAudio) =>
      (super.noSuchMethod(
        Invocation.method(
          #requestCameraPermissions,
          [enableAudio],
        ),
        returnValue: _i3.Future<_i4.CameraPermissionsErrorData?>.value(),
      ) as _i3.Future<_i4.CameraPermissionsErrorData?>);
  @override
  void startListeningForDeviceOrientationChange(
    bool? isFrontFacing,
    int? sensorOrientation,
  ) =>
      super.noSuchMethod(
        Invocation.method(
          #startListeningForDeviceOrientationChange,
          [
            isFrontFacing,
            sensorOrientation,
          ],
        ),
        returnValueForMissingStub: null,
      );
}
