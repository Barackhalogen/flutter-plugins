// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:in_app_purchase_platform_interface/in_app_purchase_platform_interface.dart';

import '../in_app_purchase_ios.dart';
import '../store_kit_wrappers.dart';

/// [IAPError.code] code for failed purchases.
final String kPurchaseErrorCode = 'purchase_error';

/// [IAPError.code] code used when a query for previouys transaction has failed.
final String kRestoredPurchaseErrorCode = 'restore_transactions_failed';

/// [IAPError.code] code used when a consuming a purchased item fails.
final String kConsumptionFailedErrorCode = 'consume_purchase_failed';

/// Indicates store front is Apple AppStore.
final String kIAPSource = 'app_store';

/// An [InAppPurchasePlatform] that wraps StoreKit.
///
/// This translates various `StoreKit` calls and responses into the
/// generic plugin API.
class InAppPurchaseIosPlatform implements InAppPurchasePlatform {
  /// Returns the singleton instance of the [InAppPurchaseIosPlatform] that should be
  /// used across the app.
  static InAppPurchaseIosPlatform get instance => _getOrCreateInstance();
  static InAppPurchaseIosPlatform? _instance;
  static late SKPaymentQueueWrapper _skPaymentQueueWrapper;
  static late _TransactionObserver _observer;

  /// Creates an [InAppPurchaseIosPlatform] object.
  ///
  /// This constructor should only be used for testing, for any other purpose
  /// get the connection from the [instance] getter.
  @visibleForTesting
  InAppPurchaseIosPlatform();

  Stream<List<PurchaseDetails>> get purchaseStream =>
      _observer.purchaseUpdatedController.stream;

  /// Callback handler for transaction status changes.
  @visibleForTesting
  static SKTransactionObserverWrapper get observer => _observer;

  static InAppPurchaseIosPlatform _getOrCreateInstance() {
    if (_instance != null) {
      return _instance!;
    }

    _instance = InAppPurchaseIosPlatform();
    _skPaymentQueueWrapper = SKPaymentQueueWrapper();
    _observer = _TransactionObserver(StreamController.broadcast());
    _skPaymentQueueWrapper.setTransactionObserver(observer);
    return _instance!;
  }

  @override
  Future<bool> isAvailable() => SKPaymentQueueWrapper.canMakePayments();

  @override
  Future<bool> buyNonConsumable({required PurchaseParam purchaseParam}) async {
    if (!(purchaseParam is AppStorePurchaseParam)) {
      throw ArgumentError(
        'On iOS, the `purchaseParam` should always be of type `AppStorePurchaseParam`.',
      );
    }

    await _skPaymentQueueWrapper.addPayment(SKPaymentWrapper(
        productIdentifier: purchaseParam.productDetails.id,
        quantity: 1,
        applicationUsername: purchaseParam.applicationUserName,
        simulatesAskToBuyInSandbox: purchaseParam.simulatesAskToBuyInSandbox,
        requestData: null));

    return true; // There's no error feedback from iOS here to return.
  }

  @override
  Future<bool> buyConsumable(
      {required PurchaseParam purchaseParam, bool autoConsume = true}) {
    assert(autoConsume == true, 'On iOS, we should always auto consume');
    return buyNonConsumable(purchaseParam: purchaseParam);
  }

  @override
  Future<void> completePurchase(PurchaseDetails purchase) {
    if (!(purchase is AppStorePurchaseDetails)) {
      throw ArgumentError(
        'On iOS, the `purchase` should always be of type `AppStorePurchaseDetails`.',
      );
    }

    return _skPaymentQueueWrapper.finishTransaction(
      purchase.skPaymentTransaction,
    );
  }

  @override
  Future<void> restorePurchases({String? applicationUserName}) async {
    return _observer
        .restoreTransactions(
            queue: _skPaymentQueueWrapper,
            applicationUserName: applicationUserName)
        .whenComplete(() => _observer.cleanUpRestoredTransactions());
  }

  /// Query the product detail list.
  ///
  /// This method only returns [ProductDetailsResponse].
  /// To get detailed Store Kit product list, use [SkProductResponseWrapper.startProductRequest]
  /// to get the [SKProductResponseWrapper].
  @override
  Future<ProductDetailsResponse> queryProductDetails(
      Set<String> identifiers) async {
    final SKRequestMaker requestMaker = SKRequestMaker();
    SkProductResponseWrapper response;
    PlatformException? exception;
    try {
      response = await requestMaker.startProductRequest(identifiers.toList());
    } on PlatformException catch (e) {
      exception = e;
      response = SkProductResponseWrapper(
          products: [], invalidProductIdentifiers: identifiers.toList());
    }
    List<AppStoreProductDetails> productDetails = [];
    if (response.products != null) {
      productDetails = response.products
          .map((SKProductWrapper productWrapper) =>
              AppStoreProductDetails.fromSKProduct(productWrapper))
          .toList();
    }
    List<String> invalidIdentifiers = response.invalidProductIdentifiers;
    if (productDetails.isEmpty) {
      invalidIdentifiers = identifiers.toList();
    }
    ProductDetailsResponse productDetailsResponse = ProductDetailsResponse(
      productDetails: productDetails,
      notFoundIDs: invalidIdentifiers,
      error: exception == null
          ? null
          : IAPError(
              source: kIAPSource,
              code: exception.code,
              message: exception.message ?? '',
              details: exception.details),
    );
    return productDetailsResponse;
  }

  // TODO(mvanbeusekom): Move into `InAppPurchaseIosAddition` class...
  /*
  @override
  Future<PurchaseVerificationData?> refreshPurchaseVerificationData() async {
    await SKRequestMaker().startRefreshReceiptRequest();
    final String? receipt = await SKReceiptManager.retrieveReceiptData();
    if (receipt == null) {
      return null;
    }
    return PurchaseVerificationData(
        localVerificationData: receipt,
        serverVerificationData: receipt,
        source: kIAPSource);
  }

  @override
  Future presentCodeRedemptionSheet() {
    return _skPaymentQueueWrapper.presentCodeRedemptionSheet();
  }
  */
}

class _TransactionObserver implements SKTransactionObserverWrapper {
  final StreamController<List<PurchaseDetails>> purchaseUpdatedController;

  Completer<List<SKPaymentTransactionWrapper>>? _restoreCompleter;
  late String _receiptData;

  _TransactionObserver(this.purchaseUpdatedController);

  Future<void> restoreTransactions(
      {required SKPaymentQueueWrapper queue, String? applicationUserName}) {
    _restoreCompleter = Completer();
    queue.restoreTransactions(applicationUserName: applicationUserName);
    return _restoreCompleter!.future;
  }

  void cleanUpRestoredTransactions() {
    _restoreCompleter = null;
  }

  void updatedTransactions(
      {required List<SKPaymentTransactionWrapper> transactions}) async {
    String receiptData = await getReceiptData();
    purchaseUpdatedController
        .add(transactions.map((SKPaymentTransactionWrapper transaction) {
      AppStorePurchaseDetails purchaseDetails =
          AppStorePurchaseDetails.fromSKTransaction(transaction, receiptData);
      return purchaseDetails;
    }).toList());
  }

  void removedTransactions(
      {required List<SKPaymentTransactionWrapper> transactions}) {}

  /// Triggered when there is an error while restoring transactions.
  void restoreCompletedTransactionsFailed({required SKError error}) {
    _restoreCompleter!.completeError(error);
  }

  void paymentQueueRestoreCompletedTransactionsFinished() {
    _restoreCompleter!.complete();
  }

  bool shouldAddStorePayment(
      {required SKPaymentWrapper payment, required SKProductWrapper product}) {
    // In this unified API, we always return true to keep it consistent with the behavior on Google Play.
    return true;
  }

  Future<String> getReceiptData() async {
    try {
      _receiptData = await SKReceiptManager.retrieveReceiptData();
    } catch (e) {
      _receiptData = '';
    }
    return _receiptData;
  }
}
