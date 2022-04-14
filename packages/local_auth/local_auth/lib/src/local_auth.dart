// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// This is a temporary ignore to allow us to land a new set of linter rules in a
// series of manageable patches instead of one gigantic PR. It disables some of
// the new lints that are already failing on this plugin, for this plugin. It
// should be deleted and the failing lints addressed as soon as possible.
// ignore_for_file: public_member_api_docs

import 'dart:async';

import 'package:flutter/services.dart';
import 'package:local_auth/src/types/error_codes.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_ios/local_auth_ios.dart';
import 'package:local_auth_platform_interface/local_auth_platform_interface.dart';
import 'package:local_auth_platform_interface/types/auth_messages.dart';
import 'package:local_auth_platform_interface/types/biometric_type.dart';

/// A Flutter plugin for authenticating the user identity locally.
class LocalAuthentication {
  /// Authenticates the user with biometrics available on the device while also
  /// allowing the user to use device authentication - pin, pattern, passcode.
  ///
  /// Returns true if the user successfully authenticated, false otherwise.
  ///
  /// [localizedReason] is the message to show to user while prompting them
  /// for authentication. This is typically along the lines of: 'Please scan
  /// your finger to access MyApp.'. This must not be empty.
  ///
  /// Provide [authMessages] if you want to
  /// customize messages in the dialogs.
  ///
  /// Provide [options] for configuring further authentication related options.
  ///
  /// Throws a [PlatformException] if there were technical problems with local
  /// authentication (e.g. lack of relevant hardware). This might throw
  /// [PlatformException] with error code [otherOperatingSystem] on the iOS
  /// simulator.
  Future<bool> authenticate(
      {required String localizedReason,
      Iterable<AuthMessages> authMessages = const <AuthMessages>[
        IOSAuthMessages(),
        AndroidAuthMessages()
      ],
      AuthenticationOptions options = const AuthenticationOptions()}) {
    return LocalAuthPlatform.instance.authenticate(
      localizedReason: localizedReason,
      authMessages: authMessages,
      options: options,
    );
  }

  /// Returns true if auth was cancelled successfully.
  /// This api only works for Android.
  /// Returns false if there was some error, no authentication in progress,
  /// or the current platform lacks support.
  ///
  /// Returns [Future] bool true or false:
  Future<bool> stopAuthentication() async {
    return LocalAuthPlatform.instance.stopAuthentication();
  }

  /// Returns true if device is capable of checking biometrics
  ///
  /// Returns a [Future] bool true or false:
  Future<bool> get canCheckBiometrics =>
      LocalAuthPlatform.instance.deviceSupportsBiometrics();

  /// Returns true if device is capable of checking biometrics or is able to
  /// fail over to device credentials.
  ///
  /// Returns a [Future] bool true or false:
  Future<bool> isDeviceSupported() async =>
      LocalAuthPlatform.instance.isDeviceSupported();

  /// Returns a list of enrolled biometrics
  ///
  /// Returns a [Future] List<BiometricType> with the following possibilities:
  /// - BiometricType.face
  /// - BiometricType.fingerprint
  /// - BiometricType.iris (not yet implemented)
  Future<List<BiometricType>> getAvailableBiometrics() =>
      LocalAuthPlatform.instance.getEnrolledBiometrics();
}
