// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider_windows/path_provider_windows.dart';

void main() {
  PathProviderWindows pathProvider;

  setUp(() {
    pathProvider = PathProviderWindows();
  });

  tearDown(() {});

  test('getTemporaryPath', () async {
    expect(await pathProvider.getTemporaryPath(), contains('C:\\'));
  });
}
