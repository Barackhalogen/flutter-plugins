// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider_linux/path_provider_linux.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  PathProviderLinux.registerWith();

  test('registered instance', () {
    expect(PathProviderPlatform.instance, isA<PathProviderLinux>());
  });

  test('getTemporaryPath', () async {
    final Map<String, String> environment = <String, String>{};

    final PathProviderPlatform plugin = PathProviderLinux.private(
      environment: environment,
    );
    expect(await plugin.getTemporaryPath(), '/tmp');

    environment['TMPDIR'] = '';
    expect(await plugin.getTemporaryPath(), '/tmp');

    environment['TMPDIR'] = '/run/user/0/tmp';
    expect(await plugin.getTemporaryPath(), '/run/user/0/tmp');
  });

  test('getApplicationSupportPath', () async {
    final PathProviderPlatform plugin = PathProviderPlatform.instance;
    expect(await plugin.getApplicationSupportPath(), startsWith('/'));
  });

  test('getApplicationDocumentsPath', () async {
    final PathProviderPlatform plugin = PathProviderPlatform.instance;
    expect(await plugin.getApplicationDocumentsPath(), startsWith('/'));
  });

  test('getDownloadsPath', () async {
    final PathProviderPlatform plugin = PathProviderPlatform.instance;
    expect(await plugin.getDownloadsPath(), startsWith('/'));
  });
}
