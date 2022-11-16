// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
// Autogenerated from Pigeon (v3.2.9), do not edit directly.
// See also: https://pub.dev/packages/pigeon
// ignore_for_file: public_member_api_docs, non_constant_identifier_names, avoid_as, unused_import, unnecessary_parenthesis, unnecessary_import
// ignore_for_file: avoid_relative_lib_imports
import 'dart:async';
import 'dart:typed_data' show Uint8List, Int32List, Int64List, Float64List;
import 'package:flutter/foundation.dart' show WriteBuffer, ReadBuffer;
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:camera_android_camerax/src/camerax_library.pigeon.dart';

class _TestJavaObjectHostApiCodec extends StandardMessageCodec {
  const _TestJavaObjectHostApiCodec();
}
abstract class TestJavaObjectHostApi {
  static const MessageCodec<Object?> codec = _TestJavaObjectHostApiCodec();

  void dispose(int identifier);
  static void setup(TestJavaObjectHostApi? api, {BinaryMessenger? binaryMessenger}) {
    {
      final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.JavaObjectHostApi.dispose', codec, binaryMessenger: binaryMessenger);
      if (api == null) {
        channel.setMockMessageHandler(null);
      } else {
        channel.setMockMessageHandler((Object? message) async {
          assert(message != null, 'Argument for dev.flutter.pigeon.JavaObjectHostApi.dispose was null.');
          final List<Object?> args = (message as List<Object?>?)!;
          final int? arg_identifier = (args[0] as int?);
          assert(arg_identifier != null, 'Argument for dev.flutter.pigeon.JavaObjectHostApi.dispose was null, expected non-null int.');
          api.dispose(arg_identifier!);
          return <Object?, Object?>{};
        });
      }
    }
  }
}

class _TestCameraInfoHostApiCodec extends StandardMessageCodec {
  const _TestCameraInfoHostApiCodec();
}
abstract class TestCameraInfoHostApi {
  static const MessageCodec<Object?> codec = _TestCameraInfoHostApiCodec();

  int getSensorRotationDegrees(int identifier);
  static void setup(TestCameraInfoHostApi? api, {BinaryMessenger? binaryMessenger}) {
    {
      final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.CameraInfoHostApi.getSensorRotationDegrees', codec, binaryMessenger: binaryMessenger);
      if (api == null) {
        channel.setMockMessageHandler(null);
      } else {
        channel.setMockMessageHandler((Object? message) async {
          assert(message != null, 'Argument for dev.flutter.pigeon.CameraInfoHostApi.getSensorRotationDegrees was null.');
          final List<Object?> args = (message as List<Object?>?)!;
          final int? arg_identifier = (args[0] as int?);
          assert(arg_identifier != null, 'Argument for dev.flutter.pigeon.CameraInfoHostApi.getSensorRotationDegrees was null, expected non-null int.');
          final int output = api.getSensorRotationDegrees(arg_identifier!);
          return <Object?, Object?>{'result': output};
        });
      }
    }
  }
}

class _TestCameraSelectorHostApiCodec extends StandardMessageCodec {
  const _TestCameraSelectorHostApiCodec();
}
abstract class TestCameraSelectorHostApi {
  static const MessageCodec<Object?> codec = _TestCameraSelectorHostApiCodec();

  void create(int identifier, int? lensFacing);
  List<int?> filter(int identifier, List<int?> cameraInfoIds);
  static void setup(TestCameraSelectorHostApi? api, {BinaryMessenger? binaryMessenger}) {
    {
      final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.CameraSelectorHostApi.create', codec, binaryMessenger: binaryMessenger);
      if (api == null) {
        channel.setMockMessageHandler(null);
      } else {
        channel.setMockMessageHandler((Object? message) async {
          assert(message != null, 'Argument for dev.flutter.pigeon.CameraSelectorHostApi.create was null.');
          final List<Object?> args = (message as List<Object?>?)!;
          final int? arg_identifier = (args[0] as int?);
          assert(arg_identifier != null, 'Argument for dev.flutter.pigeon.CameraSelectorHostApi.create was null, expected non-null int.');
          final int? arg_lensFacing = (args[1] as int?);
          api.create(arg_identifier!, arg_lensFacing);
          return <Object?, Object?>{};
        });
      }
    }
    {
      final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.CameraSelectorHostApi.filter', codec, binaryMessenger: binaryMessenger);
      if (api == null) {
        channel.setMockMessageHandler(null);
      } else {
        channel.setMockMessageHandler((Object? message) async {
          assert(message != null, 'Argument for dev.flutter.pigeon.CameraSelectorHostApi.filter was null.');
          final List<Object?> args = (message as List<Object?>?)!;
          final int? arg_identifier = (args[0] as int?);
          assert(arg_identifier != null, 'Argument for dev.flutter.pigeon.CameraSelectorHostApi.filter was null, expected non-null int.');
          final List<int?>? arg_cameraInfoIds = (args[1] as List<Object?>?)?.cast<int?>();
          assert(arg_cameraInfoIds != null, 'Argument for dev.flutter.pigeon.CameraSelectorHostApi.filter was null, expected non-null List<int?>.');
          final List<int?> output = api.filter(arg_identifier!, arg_cameraInfoIds!);
          return <Object?, Object?>{'result': output};
        });
      }
    }
  }
}

class _TestProcessCameraProviderHostApiCodec extends StandardMessageCodec {
  const _TestProcessCameraProviderHostApiCodec();
}
abstract class TestProcessCameraProviderHostApi {
  static const MessageCodec<Object?> codec = _TestProcessCameraProviderHostApiCodec();

  Future<int> getInstance();
  List<int?> getAvailableCameraInfos(int identifier);
  int bindToLifecycle(int identifier, int cameraSelectorIdentifier, List<int?> useCaseIds);
  void unbind(int identifier, List<int?> useCaseIds);
  void unbindAll(int identifier);
  static void setup(TestProcessCameraProviderHostApi? api, {BinaryMessenger? binaryMessenger}) {
    {
      final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.ProcessCameraProviderHostApi.getInstance', codec, binaryMessenger: binaryMessenger);
      if (api == null) {
        channel.setMockMessageHandler(null);
      } else {
        channel.setMockMessageHandler((Object? message) async {
          // ignore message
          final int output = await api.getInstance();
          return <Object?, Object?>{'result': output};
        });
      }
    }
    {
      final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.ProcessCameraProviderHostApi.getAvailableCameraInfos', codec, binaryMessenger: binaryMessenger);
      if (api == null) {
        channel.setMockMessageHandler(null);
      } else {
        channel.setMockMessageHandler((Object? message) async {
          assert(message != null, 'Argument for dev.flutter.pigeon.ProcessCameraProviderHostApi.getAvailableCameraInfos was null.');
          final List<Object?> args = (message as List<Object?>?)!;
          final int? arg_identifier = (args[0] as int?);
          assert(arg_identifier != null, 'Argument for dev.flutter.pigeon.ProcessCameraProviderHostApi.getAvailableCameraInfos was null, expected non-null int.');
          final List<int?> output = api.getAvailableCameraInfos(arg_identifier!);
          return <Object?, Object?>{'result': output};
        });
      }
    }
    {
      final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.ProcessCameraProviderHostApi.bindToLifecycle', codec, binaryMessenger: binaryMessenger);
      if (api == null) {
        channel.setMockMessageHandler(null);
      } else {
        channel.setMockMessageHandler((Object? message) async {
          assert(message != null, 'Argument for dev.flutter.pigeon.ProcessCameraProviderHostApi.bindToLifecycle was null.');
          final List<Object?> args = (message as List<Object?>?)!;
          final int? arg_identifier = (args[0] as int?);
          assert(arg_identifier != null, 'Argument for dev.flutter.pigeon.ProcessCameraProviderHostApi.bindToLifecycle was null, expected non-null int.');
          final int? arg_cameraSelectorIdentifier = (args[1] as int?);
          assert(arg_cameraSelectorIdentifier != null, 'Argument for dev.flutter.pigeon.ProcessCameraProviderHostApi.bindToLifecycle was null, expected non-null int.');
          final List<int?>? arg_useCaseIds = (args[2] as List<Object?>?)?.cast<int?>();
          assert(arg_useCaseIds != null, 'Argument for dev.flutter.pigeon.ProcessCameraProviderHostApi.bindToLifecycle was null, expected non-null List<int?>.');
          final int output = api.bindToLifecycle(arg_identifier!, arg_cameraSelectorIdentifier!, arg_useCaseIds!);
          return <Object?, Object?>{'result': output};
        });
      }
    }
    {
      final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.ProcessCameraProviderHostApi.unbind', codec, binaryMessenger: binaryMessenger);
      if (api == null) {
        channel.setMockMessageHandler(null);
      } else {
        channel.setMockMessageHandler((Object? message) async {
          assert(message != null, 'Argument for dev.flutter.pigeon.ProcessCameraProviderHostApi.unbind was null.');
          final List<Object?> args = (message as List<Object?>?)!;
          final int? arg_identifier = (args[0] as int?);
          assert(arg_identifier != null, 'Argument for dev.flutter.pigeon.ProcessCameraProviderHostApi.unbind was null, expected non-null int.');
          final List<int?>? arg_useCaseIds = (args[1] as List<Object?>?)?.cast<int?>();
          assert(arg_useCaseIds != null, 'Argument for dev.flutter.pigeon.ProcessCameraProviderHostApi.unbind was null, expected non-null List<int?>.');
          api.unbind(arg_identifier!, arg_useCaseIds!);
          return <Object?, Object?>{};
        });
      }
    }
    {
      final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.ProcessCameraProviderHostApi.unbindAll', codec, binaryMessenger: binaryMessenger);
      if (api == null) {
        channel.setMockMessageHandler(null);
      } else {
        channel.setMockMessageHandler((Object? message) async {
          assert(message != null, 'Argument for dev.flutter.pigeon.ProcessCameraProviderHostApi.unbindAll was null.');
          final List<Object?> args = (message as List<Object?>?)!;
          final int? arg_identifier = (args[0] as int?);
          assert(arg_identifier != null, 'Argument for dev.flutter.pigeon.ProcessCameraProviderHostApi.unbindAll was null, expected non-null int.');
          api.unbindAll(arg_identifier!);
          return <Object?, Object?>{};
        });
      }
    }
  }
}

class _TestPreviewHostApiCodec extends StandardMessageCodec {
  const _TestPreviewHostApiCodec();
}
abstract class TestPreviewHostApi {
  static const MessageCodec<Object?> codec = _TestPreviewHostApiCodec();

  void create(int identifier, int? rotation);
  int setSurfaceProvider(int identifier);
  void setTargetRotation(int identifier, int targetRotation);
  static void setup(TestPreviewHostApi? api, {BinaryMessenger? binaryMessenger}) {
    {
      final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.PreviewHostApi.create', codec, binaryMessenger: binaryMessenger);
      if (api == null) {
        channel.setMockMessageHandler(null);
      } else {
        channel.setMockMessageHandler((Object? message) async {
          assert(message != null, 'Argument for dev.flutter.pigeon.PreviewHostApi.create was null.');
          final List<Object?> args = (message as List<Object?>?)!;
          final int? arg_identifier = (args[0] as int?);
          assert(arg_identifier != null, 'Argument for dev.flutter.pigeon.PreviewHostApi.create was null, expected non-null int.');
          final int? arg_rotation = (args[1] as int?);
          api.create(arg_identifier!, arg_rotation);
          return <Object?, Object?>{};
        });
      }
    }
    {
      final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.PreviewHostApi.setSurfaceProvider', codec, binaryMessenger: binaryMessenger);
      if (api == null) {
        channel.setMockMessageHandler(null);
      } else {
        channel.setMockMessageHandler((Object? message) async {
          assert(message != null, 'Argument for dev.flutter.pigeon.PreviewHostApi.setSurfaceProvider was null.');
          final List<Object?> args = (message as List<Object?>?)!;
          final int? arg_identifier = (args[0] as int?);
          assert(arg_identifier != null, 'Argument for dev.flutter.pigeon.PreviewHostApi.setSurfaceProvider was null, expected non-null int.');
          final int output = api.setSurfaceProvider(arg_identifier!);
          return <Object?, Object?>{'result': output};
        });
      }
    }
    {
      final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.PreviewHostApi.setTargetRotation', codec, binaryMessenger: binaryMessenger);
      if (api == null) {
        channel.setMockMessageHandler(null);
      } else {
        channel.setMockMessageHandler((Object? message) async {
          assert(message != null, 'Argument for dev.flutter.pigeon.PreviewHostApi.setTargetRotation was null.');
          final List<Object?> args = (message as List<Object?>?)!;
          final int? arg_identifier = (args[0] as int?);
          assert(arg_identifier != null, 'Argument for dev.flutter.pigeon.PreviewHostApi.setTargetRotation was null, expected non-null int.');
          final int? arg_targetRotation = (args[1] as int?);
          assert(arg_targetRotation != null, 'Argument for dev.flutter.pigeon.PreviewHostApi.setTargetRotation was null, expected non-null int.');
          api.setTargetRotation(arg_identifier!, arg_targetRotation!);
          return <Object?, Object?>{};
        });
      }
    }
  }
}

class _TestCameraHostApiCodec extends StandardMessageCodec {
  const _TestCameraHostApiCodec();
}
abstract class TestCameraHostApi {
  static const MessageCodec<Object?> codec = _TestCameraHostApiCodec();

  int getCameraControl(int identifier);
  static void setup(TestCameraHostApi? api, {BinaryMessenger? binaryMessenger}) {
    {
      final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.CameraHostApi.getCameraControl', codec, binaryMessenger: binaryMessenger);
      if (api == null) {
        channel.setMockMessageHandler(null);
      } else {
        channel.setMockMessageHandler((Object? message) async {
          assert(message != null, 'Argument for dev.flutter.pigeon.CameraHostApi.getCameraControl was null.');
          final List<Object?> args = (message as List<Object?>?)!;
          final int? arg_identifier = (args[0] as int?);
          assert(arg_identifier != null, 'Argument for dev.flutter.pigeon.CameraHostApi.getCameraControl was null, expected non-null int.');
          final int output = api.getCameraControl(arg_identifier!);
          return <Object?, Object?>{'result': output};
        });
      }
    }
  }
}

class _TestCameraControlHostApiCodec extends StandardMessageCodec {
  const _TestCameraControlHostApiCodec();
}
abstract class TestCameraControlHostApi {
  static const MessageCodec<Object?> codec = _TestCameraControlHostApiCodec();

  void setZoomRatio(int identifier, int ratio);
  static void setup(TestCameraControlHostApi? api, {BinaryMessenger? binaryMessenger}) {
    {
      final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.CameraControlHostApi.setZoomRatio', codec, binaryMessenger: binaryMessenger);
      if (api == null) {
        channel.setMockMessageHandler(null);
      } else {
        channel.setMockMessageHandler((Object? message) async {
          assert(message != null, 'Argument for dev.flutter.pigeon.CameraControlHostApi.setZoomRatio was null.');
          final List<Object?> args = (message as List<Object?>?)!;
          final int? arg_identifier = (args[0] as int?);
          assert(arg_identifier != null, 'Argument for dev.flutter.pigeon.CameraControlHostApi.setZoomRatio was null, expected non-null int.');
          final int? arg_ratio = (args[1] as int?);
          assert(arg_ratio != null, 'Argument for dev.flutter.pigeon.CameraControlHostApi.setZoomRatio was null, expected non-null int.');
          api.setZoomRatio(arg_identifier!, arg_ratio!);
          return <Object?, Object?>{};
        });
      }
    }
  }
}
