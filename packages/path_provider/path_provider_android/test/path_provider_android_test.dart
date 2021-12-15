// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider_android/path_provider_android.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const String kTemporaryPath = 'temporaryPath';
  const String kApplicationSupportPath = 'applicationSupportPath';
  const String kApplicationDocumentsPath = 'applicationDocumentsPath';
  const String kStoragePath = 'storagePath';
  const List<String> kExternalCachePaths = <String>['externalCachePath'];
  const List<String> kExternalStoragePaths = <String>['externalStoragePath'];

  group('PathProviderAndroid', () {
    late PathProviderAndroid pathProvider;
    final List<MethodCall> log = <MethodCall>[];

    setUp(() async {
      pathProvider = PathProviderAndroid();
      TestDefaultBinaryMessengerBinding.instance!.defaultBinaryMessenger
          .setMockMethodCallHandler(pathProvider.methodChannel,
              (MethodCall methodCall) async {
        log.add(methodCall);
        switch (methodCall.method) {
          case 'getTemporaryDirectory':
            return kTemporaryPath;
          case 'getApplicationSupportDirectory':
            return kApplicationSupportPath;
          case 'getApplicationDocumentsDirectory':
            return kApplicationDocumentsPath;
          case 'getStorageDirectory':
            return kStoragePath;
          case 'getExternalCacheDirectories':
            return kExternalCachePaths;
          case 'getExternalStorageDirectories':
            return kExternalStoragePaths;
          default:
            return null;
        }
      });
    });

    tearDown(() {
      log.clear();
    });

    test('getTemporaryPath', () async {
      final String? path = await pathProvider.getTemporaryPath();
      expect(
        log,
        <Matcher>[isMethodCall('getTemporaryDirectory', arguments: null)],
      );
      expect(path, kTemporaryPath);
    });

    test('getApplicationSupportPath', () async {
      final String? path = await pathProvider.getApplicationSupportPath();
      expect(
        log,
        <Matcher>[
          isMethodCall('getApplicationSupportDirectory', arguments: null)
        ],
      );
      expect(path, kApplicationSupportPath);
    });

    test('getApplicationDocumentsPath', () async {
      final String? path = await pathProvider.getApplicationDocumentsPath();
      expect(
        log,
        <Matcher>[
          isMethodCall('getApplicationDocumentsDirectory', arguments: null)
        ],
      );
      expect(path, kApplicationDocumentsPath);
    });

    test('getExternalStoragePath', () async {
      final String? result = await pathProvider.getExternalStoragePath();
      expect(
        log,
        <Matcher>[isMethodCall('getStorageDirectory', arguments: null)],
      );
      expect(result, kStoragePath);
    });

    test('getExternalCachePaths', () async {
      final List<String>? result = await pathProvider.getExternalCachePaths();
      expect(
        log,
        <Matcher>[isMethodCall('getExternalCacheDirectories', arguments: null)],
      );
      expect(result, kExternalCachePaths);
    });

    test('getExternalStoragePaths', () async {
      final List<String>? result = await pathProvider.getExternalStoragePaths();
      expect(
        log,
        <Matcher>[
          isMethodCall('getExternalStorageDirectories', arguments: null)
        ],
      );
      expect(result, kExternalStoragePaths);
    });

    test('getLibraryPath fails', () async {
      try {
        await pathProvider.getLibraryPath();
        fail('should throw UnsupportedError');
      } catch (e) {
        expect(e, isUnsupportedError);
      }
    });

    test('getDownloadsPath fails', () async {
      try {
        await pathProvider.getDownloadsPath();
        fail('should throw UnsupportedError');
      } catch (e) {
        expect(e, isUnsupportedError);
      }
    });
  });
}
