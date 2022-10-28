// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
// Autogenerated from Pigeon (v4.2.3), do not edit directly.
// See also: https://pub.dev/packages/pigeon
// ignore_for_file: public_member_api_docs, non_constant_identifier_names, avoid_as, unused_import, unnecessary_parenthesis, unnecessary_import
// ignore_for_file: avoid_relative_lib_imports
import 'dart:async';
import 'dart:typed_data' show Float64List, Int32List, Int64List, Uint8List;
import 'package:flutter/foundation.dart' show ReadBuffer, WriteBuffer;
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:path_provider_macos/messages.g.dart';

abstract class TestPathProviderApi {
  static const MessageCodec<Object?> codec = StandardMessageCodec();

  String? getDirectoryPath(DirectoryType type);
  static void setup(TestPathProviderApi? api,
      {BinaryMessenger? binaryMessenger}) {
    {
      final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.PathProviderApi.getDirectoryPath', codec,
          binaryMessenger: binaryMessenger);
      if (api == null) {
        channel.setMockMessageHandler(null);
      } else {
        channel.setMockMessageHandler((Object? message) async {
          assert(message != null,
              'Argument for dev.flutter.pigeon.PathProviderApi.getDirectoryPath was null.');
          final List<Object?> args = (message as List<Object?>?)!;
          // Manually changed to work around
          // https://github.com/flutter/flutter/issues/105742.
          final DirectoryType? arg_type =
              args[0] == null ? null : DirectoryType.values[args[0] as int];
          assert(arg_type != null,
              'Argument for dev.flutter.pigeon.PathProviderApi.getDirectoryPath was null, expected non-null DirectoryType.');
          final String? output = api.getDirectoryPath(arg_type!);
          return <Object?, Object?>{'result': output};
        });
      }
    }
  }
}
