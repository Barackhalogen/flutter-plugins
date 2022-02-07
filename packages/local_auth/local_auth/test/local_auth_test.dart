// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth/src/local_auth.dart';
import 'package:local_auth_platform_interface/local_auth_platform_interface.dart';
import 'package:local_auth_platform_interface/types/auth_messages.dart';
import 'package:mockito/mockito.dart';
import 'package:platform/platform.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  late LocalAuthentication localAuthentication;
  late MockLocalAuthPlatform mockLocalAuthPlatform;

  setUp(() {
    localAuthentication = LocalAuthentication();
    mockLocalAuthPlatform = MockLocalAuthPlatform();
    LocalAuthPlatform.instance = mockLocalAuthPlatform;
  });

  test('authenticateWithBiometrics calls platform implementation', () {
    when(mockLocalAuthPlatform.authenticate(
      localizedReason: anyNamed('localizedReason'),
      authMessages: anyNamed('authMessages'),
      options: anyNamed('options'),
    )).thenAnswer((_) async => true);
    localAuthentication.authenticateWithBiometrics(
        localizedReason: 'Test Reason');
    verify(mockLocalAuthPlatform.authenticate(
      localizedReason: 'Test Reason',
      authMessages: <AuthMessages>[
        const IOSAuthMessages(),
        const AndroidAuthMessages(),
      ],
      options: const AuthenticationOptions(biometricOnly: true),
    )).called(1);
  });

  test('authenticate calls platform implementation', () {
    when(mockLocalAuthPlatform.authenticate(
      localizedReason: anyNamed('localizedReason'),
      authMessages: anyNamed('authMessages'),
      options: anyNamed('options'),
    )).thenAnswer((_) async => true);
    localAuthentication.authenticate(localizedReason: 'Test Reason');
    verify(mockLocalAuthPlatform.authenticate(
      localizedReason: 'Test Reason',
      authMessages: <AuthMessages>[
        const IOSAuthMessages(),
        const AndroidAuthMessages(),
      ],
      options: const AuthenticationOptions(),
    )).called(1);
  });

  test('requestAuthentication calls platform implementation', () {
    when(mockLocalAuthPlatform.authenticate(
      localizedReason: anyNamed('localizedReason'),
      authMessages: anyNamed('authMessages'),
      options: anyNamed('options'),
    )).thenAnswer((_) async => true);
    localAuthentication.requestAuthentication(localizedReason: 'Test Reason');
    verify(mockLocalAuthPlatform.authenticate(
      localizedReason: 'Test Reason',
      authMessages: <AuthMessages>[
        const IOSAuthMessages(),
        const AndroidAuthMessages(),
      ],
      options: const AuthenticationOptions(),
    )).called(1);
  });

  test('isDeviceSupported calls platform implementation', () {
    when(mockLocalAuthPlatform.isDeviceSupported())
        .thenAnswer((_) async => true);
    localAuthentication.isDeviceSupported();
    verify(mockLocalAuthPlatform.isDeviceSupported()).called(1);
  });

  test('getAvailableBiometrics calls platform implementation', () {
    when(mockLocalAuthPlatform.getAvailableBiometrics())
        .thenAnswer((_) async => <BiometricType>[]);
    localAuthentication.getAvailableBiometrics();
    verify(mockLocalAuthPlatform.getAvailableBiometrics()).called(1);
  });

  test('stopAuthentication calls platform implementation on Android', () {
    when(mockLocalAuthPlatform.stopAuthentication())
        .thenAnswer((_) async => true);
    setMockPathProviderPlatform(FakePlatform(operatingSystem: 'android'));
    localAuthentication.stopAuthentication();
    verify(mockLocalAuthPlatform.stopAuthentication()).called(1);
  });

  test('stopAuthentication does not call platform implementation on iOS', () {
    setMockPathProviderPlatform(FakePlatform(operatingSystem: 'ios'));
    localAuthentication.stopAuthentication();
    verifyNever(mockLocalAuthPlatform.stopAuthentication());
  });

  test('canCheckBiometrics returns correct result', () async {
    when(mockLocalAuthPlatform.getAvailableBiometrics())
        .thenAnswer((_) async => <BiometricType>[]);
    bool? result;
    result = await localAuthentication.canCheckBiometrics;
    expect(result, false);
    when(mockLocalAuthPlatform.getAvailableBiometrics())
        .thenAnswer((_) async => <BiometricType>[BiometricType.face]);
    result = await localAuthentication.canCheckBiometrics;
    expect(result, true);
    verify(mockLocalAuthPlatform.getAvailableBiometrics()).called(2);
  });
}

class MockLocalAuthPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements LocalAuthPlatform {
  MockLocalAuthPlatform() {
    throwOnMissingStub(this);
  }

  @override
  Future<bool> authenticate({
    String? localizedReason,
    Iterable<AuthMessages>? authMessages = const <AuthMessages>[
      IOSAuthMessages(),
      AndroidAuthMessages()
    ],
    AuthenticationOptions? options = const AuthenticationOptions(),
  }) =>
      super.noSuchMethod(
          Invocation.method(#authenticate, <Object>[], <Symbol, Object?>{
            #localizedReason: localizedReason,
            #authMessages: authMessages,
            #options: options,
          }),
          returnValue: Future<bool>.value(false)) as Future<bool>;

  @override
  Future<List<BiometricType>> getAvailableBiometrics() =>
      super.noSuchMethod(Invocation.method(#getAvailableBiometrics, <Object>[]),
              returnValue: Future<List<BiometricType>>.value(<BiometricType>[]))
          as Future<List<BiometricType>>;

  @override
  Future<bool> isDeviceSupported() =>
      super.noSuchMethod(Invocation.method(#isDeviceSupported, <Object>[]),
          returnValue: Future<bool>.value(false)) as Future<bool>;

  @override
  Future<bool> stopAuthentication() =>
      super.noSuchMethod(Invocation.method(#stopAuthentication, <Object>[]),
          returnValue: Future<bool>.value(false)) as Future<bool>;
}
