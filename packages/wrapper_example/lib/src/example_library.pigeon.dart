// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
// Autogenerated from Pigeon (v3.2.6), do not edit directly.
// See also: https://pub.dev/packages/pigeon
// ignore_for_file: public_member_api_docs, non_constant_identifier_names, avoid_as, unused_import, unnecessary_parenthesis, prefer_null_aware_operators, omit_local_variable_types, unused_shown_name, unnecessary_import
import 'dart:async';
import 'dart:typed_data' show Uint8List, Int32List, Int64List, Float64List;

import 'package:flutter/foundation.dart' show WriteBuffer, ReadBuffer;
import 'package:flutter/services.dart';

class _BaseObjectHostApiCodec extends StandardMessageCodec {
  const _BaseObjectHostApiCodec();
}

class BaseObjectHostApi {
  /// Constructor for [BaseObjectHostApi].  The [binaryMessenger] named argument is
  /// available for dependency injection.  If it is left null, the default
  /// BinaryMessenger will be used which routes to the host platform.
  BaseObjectHostApi({BinaryMessenger? binaryMessenger}) : _binaryMessenger = binaryMessenger;

  final BinaryMessenger? _binaryMessenger;

  static const MessageCodec<Object?> codec = _BaseObjectHostApiCodec();

  Future<void> dispose(int arg_identifier) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.BaseObjectHostApi.dispose', codec, binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(<Object?>[arg_identifier]) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error = (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else {
      return;
    }
  }
}

class _BaseObjectFlutterApiCodec extends StandardMessageCodec {
  const _BaseObjectFlutterApiCodec();
}
abstract class BaseObjectFlutterApi {
  static const MessageCodec<Object?> codec = _BaseObjectFlutterApiCodec();

  void dispose(int identifier);
  static void setup(BaseObjectFlutterApi? api, {BinaryMessenger? binaryMessenger}) {
    {
      final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.BaseObjectFlutterApi.dispose', codec, binaryMessenger: binaryMessenger);
      if (api == null) {
        channel.setMessageHandler(null);
      } else {
        channel.setMessageHandler((Object? message) async {
          assert(message != null, 'Argument for dev.flutter.pigeon.BaseObjectFlutterApi.dispose was null.');
          final List<Object?> args = (message as List<Object?>?)!;
          final int? arg_identifier = (args[0] as int?);
          assert(arg_identifier != null, 'Argument for dev.flutter.pigeon.BaseObjectFlutterApi.dispose was null, expected non-null int.');
          api.dispose(arg_identifier!);
          return;
        });
      }
    }
  }
}

class _MyClassHostApiCodec extends StandardMessageCodec {
  const _MyClassHostApiCodec();
}

class MyClassHostApi {
  /// Constructor for [MyClassHostApi].  The [binaryMessenger] named argument is
  /// available for dependency injection.  If it is left null, the default
  /// BinaryMessenger will be used which routes to the host platform.
  MyClassHostApi({BinaryMessenger? binaryMessenger}) : _binaryMessenger = binaryMessenger;

  final BinaryMessenger? _binaryMessenger;

  static const MessageCodec<Object?> codec = _MyClassHostApiCodec();

  Future<void> create(int arg_identifier, String arg_primitiveField, int arg_classFieldIdentifier) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.MyClassHostApi.create', codec, binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(<Object?>[arg_identifier, arg_primitiveField, arg_classFieldIdentifier]) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error = (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else {
      return;
    }
  }

  Future<void> myStaticMethod() async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.MyClassHostApi.myStaticMethod', codec, binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(null) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error = (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else {
      return;
    }
  }

  Future<void> myMethod(int arg_identifier, String arg_primitiveParam, int arg_classParamIdentifier) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.MyClassHostApi.myMethod', codec, binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(<Object?>[arg_identifier, arg_primitiveParam, arg_classParamIdentifier]) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error = (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else {
      return;
    }
  }

  Future<void> attachClassField(int arg_identifier, int arg_classFieldIdentifier) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.MyClassHostApi.attachClassField', codec, binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(<Object?>[arg_identifier, arg_classFieldIdentifier]) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error = (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else {
      return;
    }
  }
}

class _MyClassFlutterApiCodec extends StandardMessageCodec {
  const _MyClassFlutterApiCodec();
}
abstract class MyClassFlutterApi {
  static const MessageCodec<Object?> codec = _MyClassFlutterApiCodec();

  void create(int identifier, String primitiveField, int classFieldIdentifier);
  void myCallbackMethod(int identifier);
  static void setup(MyClassFlutterApi? api, {BinaryMessenger? binaryMessenger}) {
    {
      final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.MyClassFlutterApi.create', codec, binaryMessenger: binaryMessenger);
      if (api == null) {
        channel.setMessageHandler(null);
      } else {
        channel.setMessageHandler((Object? message) async {
          assert(message != null, 'Argument for dev.flutter.pigeon.MyClassFlutterApi.create was null.');
          final List<Object?> args = (message as List<Object?>?)!;
          final int? arg_identifier = (args[0] as int?);
          assert(arg_identifier != null, 'Argument for dev.flutter.pigeon.MyClassFlutterApi.create was null, expected non-null int.');
          final String? arg_primitiveField = (args[1] as String?);
          assert(arg_primitiveField != null, 'Argument for dev.flutter.pigeon.MyClassFlutterApi.create was null, expected non-null String.');
          final int? arg_classFieldIdentifier = (args[2] as int?);
          assert(arg_classFieldIdentifier != null, 'Argument for dev.flutter.pigeon.MyClassFlutterApi.create was null, expected non-null int.');
          api.create(arg_identifier!, arg_primitiveField!, arg_classFieldIdentifier!);
          return;
        });
      }
    }
    {
      final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.MyClassFlutterApi.myCallbackMethod', codec, binaryMessenger: binaryMessenger);
      if (api == null) {
        channel.setMessageHandler(null);
      } else {
        channel.setMessageHandler((Object? message) async {
          assert(message != null, 'Argument for dev.flutter.pigeon.MyClassFlutterApi.myCallbackMethod was null.');
          final List<Object?> args = (message as List<Object?>?)!;
          final int? arg_identifier = (args[0] as int?);
          assert(arg_identifier != null, 'Argument for dev.flutter.pigeon.MyClassFlutterApi.myCallbackMethod was null, expected non-null int.');
          api.myCallbackMethod(arg_identifier!);
          return;
        });
      }
    }
  }
}

class _MyOtherClassHostApiCodec extends StandardMessageCodec {
  const _MyOtherClassHostApiCodec();
}

class MyOtherClassHostApi {
  /// Constructor for [MyOtherClassHostApi].  The [binaryMessenger] named argument is
  /// available for dependency injection.  If it is left null, the default
  /// BinaryMessenger will be used which routes to the host platform.
  MyOtherClassHostApi({BinaryMessenger? binaryMessenger}) : _binaryMessenger = binaryMessenger;

  final BinaryMessenger? _binaryMessenger;

  static const MessageCodec<Object?> codec = _MyOtherClassHostApiCodec();

  Future<void> create(int arg_identifier) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.MyOtherClassHostApi.create', codec, binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(<Object?>[arg_identifier]) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error = (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else {
      return;
    }
  }
}

class _MyOtherClassFlutterApiCodec extends StandardMessageCodec {
  const _MyOtherClassFlutterApiCodec();
}
abstract class MyOtherClassFlutterApi {
  static const MessageCodec<Object?> codec = _MyOtherClassFlutterApiCodec();

  void create(int identifier);
  static void setup(MyOtherClassFlutterApi? api, {BinaryMessenger? binaryMessenger}) {
    {
      final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.MyOtherClassFlutterApi.create', codec, binaryMessenger: binaryMessenger);
      if (api == null) {
        channel.setMessageHandler(null);
      } else {
        channel.setMessageHandler((Object? message) async {
          assert(message != null, 'Argument for dev.flutter.pigeon.MyOtherClassFlutterApi.create was null.');
          final List<Object?> args = (message as List<Object?>?)!;
          final int? arg_identifier = (args[0] as int?);
          assert(arg_identifier != null, 'Argument for dev.flutter.pigeon.MyOtherClassFlutterApi.create was null, expected non-null int.');
          api.create(arg_identifier!);
          return;
        });
      }
    }
  }
}

class _MyClassSubclassHostApiCodec extends StandardMessageCodec {
  const _MyClassSubclassHostApiCodec();
}

class MyClassSubclassHostApi {
  /// Constructor for [MyClassSubclassHostApi].  The [binaryMessenger] named argument is
  /// available for dependency injection.  If it is left null, the default
  /// BinaryMessenger will be used which routes to the host platform.
  MyClassSubclassHostApi({BinaryMessenger? binaryMessenger}) : _binaryMessenger = binaryMessenger;

  final BinaryMessenger? _binaryMessenger;

  static const MessageCodec<Object?> codec = _MyClassSubclassHostApiCodec();

  Future<void> create(int arg_identifier, String arg_primitiveField, int arg_classFieldIdentifier) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.MyClassSubclassHostApi.create', codec, binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(<Object?>[arg_identifier, arg_primitiveField, arg_classFieldIdentifier]) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error = (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else {
      return;
    }
  }
}
