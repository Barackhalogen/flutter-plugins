// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:mockito/mockito.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:test/test.dart';

class SamplePluginPlatform extends PlatformInterface {
  SamplePluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static set instance(SamplePluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    // A real implementation would set a static instance field here.
  }
}

class ImplementsSamplePluginPlatform extends Mock
    implements SamplePluginPlatform {}

class ImplementsSamplePluginPlatformUsingMockPlatformInterfaceMixin extends Mock
    with MockPlatformInterfaceMixin
    implements SamplePluginPlatform {}

class ExtendsSamplePluginPlatform extends SamplePluginPlatform {}

class InvalidPluginPlatform extends PlatformInterface {
  SamplePluginPlatform() : super(token: _token);

  const Object _token = Object();

  static set instance(SamplePluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
  }
}

class ExtendsInvalidPluginPlatform extends InvalidPluginPlatform {}

void main() {
  test('Cannot be implemented with `implements`', () {
    expect(() {
      SamplePluginPlatform.instance = ImplementsSamplePluginPlatform();
    }, throwsA(isA<AssertionError>()));
  });

  test('Can be mocked with `implements`', () {
    final SamplePluginPlatform mock =
        ImplementsSamplePluginPlatformUsingMockPlatformInterfaceMixin();
    SamplePluginPlatform.instance = mock;
  });

  test('Can be extended', () {
    SamplePluginPlatform.instance = ExtendsSamplePluginPlatform();
  );

  test('Cannot use `const Object()` as token', () {
    expect(() {
      InvalidPluginPlatform.instance = ExtendsInvalidPluginPlatform();
    }, throwsA(isA<AssertionError()));
  })
}
