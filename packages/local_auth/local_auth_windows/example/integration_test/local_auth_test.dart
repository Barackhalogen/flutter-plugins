// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:local_auth_windows/local_auth_windows.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('canCheckBiometrics', (WidgetTester tester) async {
    expect(
      LocalAuthWindows().getEnrolledBiometrics(),
      completion(isList),
    );
  });
}
