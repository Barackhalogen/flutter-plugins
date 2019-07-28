// Copyright 2019, the Chromium project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:io';
import 'package:flutter_driver/driver_extension.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() {
  final Completer<String> completer = Completer<String>();
  enableFlutterDriverExtension(handler: (_) => completer.future);
  tearDownAll(() => completer.complete(null));

  group('$FirebaseAuth', () {
    final FirebaseAuth auth = FirebaseAuth.instance;

    test('signInAnonymously', () async {
      final FirebaseUser user = await auth.signInAnonymously();
      expect(user.uid, isNotNull);
      expect(user.isAnonymous, isTrue);
      final IdTokenResult result = await user.getIdToken();
      expect(result.token, isNotNull);
      expect(result.expirationTime.isAfter(DateTime.now()), isTrue);
      expect(result.authTime, isNotNull);
      expect(result.issuedAtTime, isNotNull);
      // TODO(jackson): Remove this `if` check once iOS is fixed
      // https://github.com/firebase/firebase-ios-sdk/issues/3445
      if (Platform.isAndroid) {
        expect(result.signInProvider, 'anonymous');
      }
      expect(result.claims['provider_id'], 'anonymous');
      expect(result.claims['firebase']['sign_in_provider'], 'anonymous');
      expect(result.claims['user_id'], user.uid);
    });

    test('isSignInWithEmailLink', () async {
      final String emailLink1 = 'https://www.example.com/action?mode=signIn&'
          'oobCode=oobCode&apiKey=API_KEY';
      final String emailLink2 =
          'https://www.example.com/action?mode=verifyEmail&'
          'oobCode=oobCode&apiKey=API_KEY';
      final String emailLink3 = 'https://www.example.com/action?mode=signIn';
      expect(await auth.isSignInWithEmailLink(emailLink1), true);
      expect(await auth.isSignInWithEmailLink(emailLink2), false);
      expect(await auth.isSignInWithEmailLink(emailLink3), false);
    });
  });
}
