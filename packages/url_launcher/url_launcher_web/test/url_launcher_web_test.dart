// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

@TestOn('chrome') // Uses web-only Flutter SDK

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher_web/url_launcher_web.dart';

void main() {
  group('URL Launcher for Web', () {
    setUp(() {
      TestWidgetsFlutterBinding.ensureInitialized();
      webPluginRegistry.registerMessageHandler();
      final Registrar registrar =
          webPluginRegistry.registrarFor(UrlLauncherPlugin);
      UrlLauncherPlugin.registerWith(registrar);
    });

    test('can launch "http" URLs', () {
      expect(canLaunch('http://google.com'), completion(isTrue));
    });

    test('can launch "https" URLs', () {
      expect(canLaunch('https://google.com'), completion(isTrue));
    });

    test('cannot launch "tel" URLs', () {
      expect(canLaunch('tel:5551234567'), completion(isFalse));
    });
  });
}
