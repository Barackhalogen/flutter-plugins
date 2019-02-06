// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:test/test.dart';

import 'package:flutter/widgets.dart';
import 'package:in_app_purchase/billing_client_wrappers.dart';
import 'package:in_app_purchase/src/billing_client_wrappers/enum_converters.dart';
import 'package:in_app_purchase/src/in_app_purchase_connection/google_play_connection.dart';
import 'package:in_app_purchase/src/channel.dart';
import '../stub_in_app_purchase_platform.dart';
import 'package:in_app_purchase/src/in_app_purchase_connection/product.dart';
import '../billing_client_wrappers/sku_details_wrapper_test.dart';

void main() {
  final StubInAppPurchasePlatform stubPlatform = StubInAppPurchasePlatform();
  GooglePlayConnection connection;
  const String startConnectionCall =
      'BillingClient#startConnection(BillingClientStateListener)';
  const String endConnectionCall = 'BillingClient#endConnection()';

  setUpAll(() =>
      channel.setMockMethodCallHandler(stubPlatform.fakeMethodCallHandler));

  setUp(() {
    WidgetsFlutterBinding.ensureInitialized();
    stubPlatform.addResponse(
        name: startConnectionCall,
        value: BillingResponseConverter().toJson(BillingResponse.ok));
    stubPlatform.addResponse(name: endConnectionCall, value: null);
    connection = GooglePlayConnection.instance;
  });

  tearDown(() {
    stubPlatform.reset();
    GooglePlayConnection.reset();
  });

  group('connection management', () {
    test('connects on initialization', () {
      expect(stubPlatform.countPreviousCalls(startConnectionCall), equals(1));
    });

    test('disconnects on app pause', () {
      expect(stubPlatform.countPreviousCalls(endConnectionCall), equals(0));
      connection.didChangeAppLifecycleState(AppLifecycleState.paused);
      expect(stubPlatform.countPreviousCalls(endConnectionCall), equals(1));
    });

    test('reconnects on app resume', () {
      expect(stubPlatform.countPreviousCalls(startConnectionCall), equals(1));
      connection.didChangeAppLifecycleState(AppLifecycleState.resumed);
      expect(stubPlatform.countPreviousCalls(startConnectionCall), equals(2));
    });
  });

  group('isAvailable', () {
    test('true', () async {
      stubPlatform.addResponse(name: 'BillingClient#isReady()', value: true);
      expect(await connection.isAvailable(), isTrue);
    });

    test('false', () async {
      stubPlatform.addResponse(name: 'BillingClient#isReady()', value: false);
      expect(await connection.isAvailable(), isFalse);
    });
  });

  group('querySkuDetails', () {
    final String queryMethodName =
        'BillingClient#querySkuDetailsAsync(SkuDetailsParams, SkuDetailsResponseListener)';

    test('handles empty skuDetails', () async {
      final BillingResponse responseCode = BillingResponse.developerError;
      stubPlatform.addResponse(name: queryMethodName, value: <dynamic, dynamic>{
        'responseCode': BillingResponseConverter().toJson(responseCode),
        'skuDetailsList': <Map<String, dynamic>>[]
      });

      final List<Product> products =
          await connection.queryProductDetails(<String>['invalid']);
      expect(products, isEmpty);
    });

    test('returns SkuDetailsResponseWrapper', () async {
      final BillingResponse responseCode = BillingResponse.ok;
      stubPlatform.addResponse(name: queryMethodName, value: <String, dynamic>{
        'responseCode': BillingResponseConverter().toJson(responseCode),
        'skuDetailsList': <Map<String, dynamic>>[buildSkuMap(dummyWrapper)]
      });

      final List<Product> products =
          await connection.queryProductDetails(<String>['invalid']);
      expect(products.first.title, dummyWrapper.title);
      expect(products.first.description, dummyWrapper.description);
      expect(products.first.price, dummyWrapper.price);
    });
  });
}
