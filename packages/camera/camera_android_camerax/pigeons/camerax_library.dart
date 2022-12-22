// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/src/camerax_library.pigeon.dart',
    dartTestOut: 'test/test_camerax_library.pigeon.dart',
    dartOptions: DartOptions(copyrightHeader: <String>[
      'Copyright 2013 The Flutter Authors. All rights reserved.',
      'Use of this source code is governed by a BSD-style license that can be',
      'found in the LICENSE file.',
    ]),
    javaOut:
        'android/src/main/java/io/flutter/plugins/camerax/GeneratedCameraXLibrary.java',
    javaOptions: JavaOptions(
      package: 'io.flutter.plugins.camerax',
      className: 'GeneratedCameraXLibrary',
      copyrightHeader: <String>[
        'Copyright 2013 The Flutter Authors. All rights reserved.',
        'Use of this source code is governed by a BSD-style license that can be',
        'found in the LICENSE file.',
      ],
    ),
  ),
)

@HostApi(dartHostTestHandler: 'TestJavaObjectHostApi')
abstract class JavaObjectHostApi {
  void dispose(int identifier);
}

@FlutterApi()
abstract class JavaObjectFlutterApi {
  void dispose(int identifier);
}

@HostApi(dartHostTestHandler: 'TestCameraInfoHostApi')
abstract class CameraInfoHostApi {
  int getSensorRotationDegrees(int identifier);
}

@FlutterApi()
abstract class CameraInfoFlutterApi {
  void create(int identifier);
}

@HostApi(dartHostTestHandler: 'TestCameraSelectorHostApi')
abstract class CameraSelectorHostApi {
  void create(int identifier, int? lensFacing);

  List<int> filter(int identifier, List<int> cameraInfoIds);
}

@FlutterApi()
abstract class CameraSelectorFlutterApi {
  void create(int identifier, int? lensFacing);
}

@HostApi(dartHostTestHandler: 'TestProcessCameraProviderHostApi')
abstract class ProcessCameraProviderHostApi {
  @async
  int getInstance();

  List<int> getAvailableCameraInfos(int identifier);

  int bindToLifecycle(
      int identifier, int cameraSelectorIdentifier, List<int> useCaseIds);

  void unbind(int identifier, List<int> useCaseIds);

  void unbindAll(int identifier);
}

@FlutterApi()
abstract class ProcessCameraProviderFlutterApi {
  void create(int identifier);
}

@HostApi(dartHostTestHandler: 'TestPreviewHostApi')
abstract class PreviewHostApi {
  void create(
      int identifier, int? rotation, Map<String, int>? targetResolution);

  int setSurfaceProvider(int identifier);

  void setTargetRotation(int identifier, int targetRotation);

  List<int> getResolutionInfo(int identifier);
}

@FlutterApi()
abstract class PreviewFlutterApi {
  void create(int identifier, int targetRotation, Map<String, int>? targetResolution);
}

@HostApi(dartHostTestHandler: 'TestCameraHostApi')
abstract class CameraHostApi {
  int getCameraControl(int identifier);
}

@FlutterApi()
abstract class CameraFlutterApi {
  void create(int identifier);
}

@HostApi(dartHostTestHandler: 'TestCameraControlHostApi')
abstract class CameraControlHostApi {
  void setZoomRatio(int identifier, int ratio);
}

@FlutterApi()
abstract class CameraControlFlutterApi {
  void create(int identifier);
}

@HostApi(dartHostTestHandler: 'TestSystemServicesHostApi')
abstract class SystemServicesHostApi {
  bool requestCameraPermissions(bool enableAudio);

  void startListeningForDeviceOrientationChange(bool isFrontFacing, int sensorOrientation);
}

@FlutterApi()
abstract class SystemServicesFlutterApi {
  void onCameraPermissionsRequestResult(String resultCode, String resultMessage);

  void onDeviceOrientationChanged(String orientation);
}
