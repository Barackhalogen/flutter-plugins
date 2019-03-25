// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter/widgets.dart';
import '../../billing_client_wrappers.dart';
import 'in_app_purchase_connection.dart';
import 'product_details.dart';

/// An [InAppPurchaseConnection] that wraps Google Play Billing.
///
/// This translates various [BillingClient] calls and responses into the
/// common plugin API.
class GooglePlayConnection
    with WidgetsBindingObserver
    implements InAppPurchaseConnection {
  GooglePlayConnection._()
      : _billingClient = BillingClient((PurchasesResultWrapper resultWrapper) {
          for (PurchaseWrapper purchase in resultWrapper.purchasesList) {
            _purchaseUpdateListener(purchaseDetails: purchase.toPurchaseDetails(), status:resultWrapper.responseCode == BillingResponse.ok ? PurchaseStatus.purchased: PurchaseStatus.error);
          }
        }) {
    _readyFuture = _connect();
    WidgetsBinding.instance.addObserver(this);
  }
  static GooglePlayConnection get instance => _getOrCreateInstance();
  static GooglePlayConnection _instance;
  final BillingClient _billingClient;
  Future<void> _readyFuture;
  static PurchaseUpdateListener _purchaseUpdateListener;
  static StorePaymentDecisionMaker _storePaymentDecisionMaker;

  @override
  Future<bool> isAvailable() async {
    await _readyFuture;
    return _billingClient.isReady();
  }

  /// Query the product detail list.
  ///
  /// This method only returns [ProductDetailsResponse].
  /// To get detailed Google Play sku list, use [BillingClient.querySkuDetails]
  /// to get the [SkuDetailsResponseWrapper].
  Future<ProductDetailsResponse> queryProductDetails(
      Set<String> identifiers) async {
    List<SkuDetailsResponseWrapper> responses = await Future.wait([
      _billingClient.querySkuDetails(
          skuType: SkuType.inapp, skusList: identifiers.toList()),
      _billingClient.querySkuDetails(
          skuType: SkuType.subs, skusList: identifiers.toList())
    ]);
    List<ProductDetails> productDetails =
        responses.expand((SkuDetailsResponseWrapper response) {
      return response.skuDetailsList;
    }).map((SkuDetailsWrapper skuDetailWrapper) {
      return skuDetailWrapper.toProductDetails();
    }).toList();
    Set<String> successIDS = productDetails
        .map((ProductDetails productDetails) => productDetails.id)
        .toSet();
    List<String> notFoundIDS = identifiers.difference(successIDS).toList();
    return ProductDetailsResponse(
        productDetails: productDetails, notFoundIDs: notFoundIDS);
  }

  @override
  Future<void> makePayment(
      {String productID, String applicationUserName}) async {
      BillingResponse response = await _billingClient.launchBillingFlow(sku: productID, accountId: applicationUserName);
      print('xx ' + response.toString());
      PurchaseStatus status = response == BillingResponse.ok ? PurchaseStatus.purchased :PurchaseStatus.error;
      String error = response == BillingResponse.ok ? null : response.toString();
      //return PurchaseResponse(status: status, error: error);
  }

  @override
  Future<QueryPastPurchaseResponse> queryPastPurchases(
      {String applicationUserName}) async {
    List<PurchasesResultWrapper> responses = await Future.wait([
      _billingClient.queryPurchaseHistory(SkuType.inapp),
      _billingClient.queryPurchaseHistory(SkuType.subs)
    ]);

    BillingResponse errorInApp = responses.first.responseCode;
    BillingResponse errorSubs = responses.last.responseCode;
    String errorMessage = null;
    if (errorInApp != BillingResponse.ok) {
      errorMessage = errorInApp.toString();
    }
    if (errorSubs != BillingResponse.ok && errorSubs != errorInApp) {
      errorMessage += ', ${errorSubs.toString()}';
    }

    List<PurchaseDetails> pastPurchases;
    if (responses == null) {
      pastPurchases = [];
    } else {
      pastPurchases = responses.expand((PurchasesResultWrapper response) {
        return response.purchasesList;
      }).map((PurchaseWrapper purchaseWrapper) {
        return purchaseWrapper.toPurchaseDetails();
      }).toList();
    }
    return QueryPastPurchaseResponse(
      pastPurchases: pastPurchases,
      error: errorMessage != null
          ? {
              'errorCode': 'restore_transactions_failed',
              'message': errorMessage
            }
          : null,
    );
  }

  @override
  Future<PurchaseVerificationData> refreshPurchaseVerificationData(
      PurchaseDetails purchase) async {
    return purchase.verificationData;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
        _disconnect();
        break;
      case AppLifecycleState.resumed:
        _readyFuture = _connect();
        break;
      default:
    }
  }

  @visibleForTesting
  static void reset() => _instance = null;

  static GooglePlayConnection _getOrCreateInstance() {
    assert(_purchaseUpdateListener != null);
    assert(_storePaymentDecisionMaker != null);
    if (_instance != null) {
      return _instance;
    }

    _instance = GooglePlayConnection._();
    return _instance;
  }

  static void configure({PurchaseUpdateListener purchaseUpdateListener, StorePaymentDecisionMaker storePaymentDecisionMaker}) {
    _purchaseUpdateListener = purchaseUpdateListener;
    _storePaymentDecisionMaker = storePaymentDecisionMaker;
  }

  Future<void> _connect() =>
      _billingClient.startConnection(onBillingServiceDisconnected: () {});

  Future<void> _disconnect() => _billingClient.endConnection();
}
