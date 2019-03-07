// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/src/channel.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/services.dart';
import './sk_product_wrapper.dart';

part 'sk_payment_queue_wrapper.g.dart';

/// A wrapper around [`SKPaymentQueue`](https://developer.apple.com/documentation/storekit/skpaymentqueue?language=objc).
///
/// The payment queue contains payment related operations. It communicates with App Store and presents
/// a user interface for the user to process and authorize the payment.
class SKPaymentQueueWrapper {
  SKTransactionObserverWrapper _observer;

  /// Returns the default payment queue.
  ///
  /// We do not support instantiating a custom payment queue, hence the singleton. However, you can
  /// override the observer
  factory SKPaymentQueueWrapper() {
    return _singleton;
  }

  static final SKPaymentQueueWrapper _singleton = new SKPaymentQueueWrapper._();

  SKPaymentQueueWrapper._() {
    callbackChannel.setMethodCallHandler(_handleObserverCallbacks);
  }

  /// Calls [`-[SKPaymentQueue canMakePayments:]`](https://developer.apple.com/documentation/storekit/skpaymentqueue/1506139-canmakepayments?language=objc).
  static Future<bool> canMakePayments() async =>
      await channel.invokeMethod('-[SKPaymentQueue canMakePayments:]');

  /// Sets a transaction observer to listen to all the transaction events of the payment queue.
  ///
  /// You have to have a transaction observer to be added to the payment queue to handle the
  /// payment follow.
  /// You must set the observer right when App launches to avoid missing callback when your user
  /// started a purchase flow from the App Store.
  /// This method calls StoreKit's [`-[SKPaymentQueue finishTransaction:]`](https://developer.apple.com/documentation/storekit/skpaymentqueue/1506042-addtransactionobserver?language=objc).
  void setTransactionObserver(SKTransactionObserverWrapper observer) {
    _observer = observer;
  }

  /// Adds a payment object to the payment queue.
  ///
  /// Prior to this call, you have to make sure at least one [SKTransactionObserverWrapper] is added to the payment queue
  /// using [addTransactionObserver]. You also have to make sure the [SKProductWrapper] of the payment has been fetched using [SKRequestMaker.startProductRequest].
  /// Each payment will generate a [SKPaymentTransactionWrapper]. After a payment is added to the payment queue, the [SKTransactionObserverWrapper] is responsible for handling
  /// the transaction that is generated by the payment.
  /// The [productIdentifier] must match one of the products that are returned in [SKRequestMaker.startProductRequest].
  /// to test the payment in the [sandbox](https://developer.apple.com/apple-pay/sandbox-testing/).
  /// This method calls StoreKit's [`-[SKPaymentQueue addPayment:]`] (https://developer.apple.com/documentation/storekit/skpaymentqueue/1506036-addpayment?preferredLanguage=occ).
  Future<void> addPayment(SKPaymentWrapper payment) async {
    assert(_observer != null,
        '[in_app_purchase]: Trying to add a payment without an observer. Observer must be set using `setTransactionObserver` before adding a payment `setTransactionObserver`. It is mandatory to set the observer at the moment when app launches.');
    Map requestMap = payment.toMap();
    await channel.invokeMethod(
      '-[InAppPurchasePlugin addPayment:result:]',
      requestMap,
    );
  }

  /// Finishes a transaction and removes it from the queue.
  ///
  /// This method should be called from an [SKTransactionObserverWrapper] callback when receiving notification from the payment queue. You should only
  /// call this method after the transaction is successfully processed and the functionality purchased by the user is unlocked.
  /// It will throw a Platform exception if the [SKPaymentTransactionWrapper.transactionState] is [SKPaymentTransactionStateWrapper.purchasing].
  /// This method calls StoreKit's [`-[SKPaymentQueue finishTransaction:]`](https://developer.apple.com/documentation/storekit/skpaymentqueue/1506003-finishtransaction?language=objc).
  Future<void> finishTransaction(
      SKPaymentTransactionWrapper transaction) async {
    await channel.invokeMethod(
        '-[InAppPurchasePlugin finishTransaction:result:]',
        transaction.transactionIdentifier);
  }

  /// Restore transactions to maintain access to content that customers have already purchased.
  ///
  /// For example, when a user upgrades to a new phone, they want to keep the content they purchased in the old phone.
  /// This call will invoke the [SKTransactionObserverWrapper.restoreCompletedTransactions] or [SKTransactionObserverWrapper.paymentQueueRestoreCompletedTransactionsFinished] as well as [SKTransactionObserverWrapper.updatedTransaction]
  /// in the [SKTransactionObserverWrapper]. If you keep the download content in your own server, in the observer methods, you can simply finish the transaction by calling [finishTransaction] and
  /// download the content from your own server.
  /// If you keep the download content on Apple's server, you can access the download content in the transaction object that you get from [SKTransactionObserverWrapper.updatedTransaction] when the [SKPaymentTransactionWrapper.transactionState] is [SKPaymentTransactionStateWrapper.restored].
  /// The `applicationUserName` is the [SKPaymentWrapper.applicationUsername] you used to create payments. If you did not use a `applicationUserName` when creating payments, then you can ignore this parameter.
  /// This method either triggers [`-[SKPayment restoreCompletedTransactions]`](https://developer.apple.com/documentation/storekit/skpaymentqueue/1506123-restorecompletedtransactions?language=objc) or [`-[SKPayment restoreCompletedTransactionsWithApplicationUsername:]`](https://developer.apple.com/documentation/storekit/skpaymentqueue/1505992-restorecompletedtransactionswith?language=objc)
  /// depends on weather the `applicationUserName` is passed.
  Future<void> restoreTransactions({String applicationUserName}) async {
    await channel.invokeMethod(
        '-[InAppPurchasePlugin restoreTransactions:result:]',
        applicationUserName);
  }

  // Triage a method channel call from the platform and triggers the correct observer method.
  Future<dynamic> _handleObserverCallbacks(MethodCall call) {
    assert(_observer != null,
        '[in_app_purchase]: (Fatal)The observer has not been set but we received a purchase transaction notification. Please ensure the observer has been set using `setTransactionObserver`. Make sure the observer is added right at the App Launch.');
    switch (call.method) {
      case 'updatedTransactions':
        {
          final List<SKPaymentTransactionWrapper> transactions =
              _getTransactionList(call.arguments);
          return Future<void>(() {
            _observer.updatedTransactions(transactions: transactions);
          });
        }
      case 'removedTransactions':
        {
          final List<SKPaymentTransactionWrapper> transactions =
              _getTransactionList(call.arguments);
          return Future<void>(() {
            _observer.removedTransactions(transactions: transactions);
          });
        }
      case 'restoreCompletedTransactions':
        {
          final Error error = call.arguments;
          return Future<void>(() {
            _observer.restoreCompletedTransactions(error: error);
          });
        }
      case 'paymentQueueRestoreCompletedTransactionsFinished':
        {
          return Future<void>(() {
            _observer.paymentQueueRestoreCompletedTransactionsFinished();
          });
        }
      case 'updatedDownloads':
        {
          final List<SKDownloadWrapper> downloads =
              _getDownloadList(call.arguments);
          return Future<void>(() {
            _observer.updatedDownloads(downloads: downloads);
          });
        }
      case 'shouldAddStorePayment':
        {
          SKPaymentWrapper payment =
              SKPaymentWrapper.fromJson(call.arguments['payment']);
          SKProductWrapper product =
              SKProductWrapper.fromJson(call.arguments['product']);
          return Future<void>(() {
            if (_observer.shouldAddStorePayment(
                    payment: payment, product: product) ==
                true) {
              SKPaymentQueueWrapper().addPayment(payment);
            }
          });
        }
      default:
        break;
    }
    return null;
  }

  // Get transaction wrapper object list from arguments.
  List<SKPaymentTransactionWrapper> _getTransactionList(dynamic arguments) {
    final List<SKPaymentTransactionWrapper> transactions = arguments
        .map<SKPaymentTransactionWrapper>(
            (dynamic map) => SKPaymentTransactionWrapper.fromJson(map))
        .toList();
    return transactions;
  }

  // Get download wrapper object list from arguments.
  List<SKDownloadWrapper> _getDownloadList(dynamic arguments) {
    final List<SKDownloadWrapper> downloads = arguments
        .map<SKDownloadWrapper>(
            (dynamic map) => SKDownloadWrapper.fromJson(map))
        .toList();
    return downloads;
  }
}

/// This class is Dart wrapper around [SKTransactionObserver](https://developer.apple.com/documentation/storekit/skpaymenttransactionobserver?language=objc).
///
/// Must be subclassed. Must be instantiated and added to the [SKPaymentQueueWrapper] via [SKPaymentQueueWrapper.setTransactionObserver] at the app launch.
abstract class SKTransactionObserverWrapper {
  /// Triggered when any transactions are updated.
  void updatedTransactions({List<SKPaymentTransactionWrapper> transactions});

  /// Triggered when any transactions are removed from the payment queue.
  void removedTransactions({List<SKPaymentTransactionWrapper> transactions});

  /// Triggered when there is an error while restoring transactions.
  void restoreCompletedTransactions({Error error});

  /// Triggered when payment queue has finished sending restored transactions.
  void paymentQueueRestoreCompletedTransactionsFinished();

  /// Triggered when any download objects are updated.
  void updatedDownloads({List<SKDownloadWrapper> downloads});

  /// Triggered when a user initiated an in-app purchase from App Store.
  ///
  /// Return `true` to continue the transaction in your app. If you have multiple [SKTransactionObserverWrapper]s, the transaction
  /// will continue if one [SKTransactionObserverWrapper] has [shouldAddStorePayment] returning `true`.
  /// Return `false` to defer or cancel the transaction. For example, you may need to defer a transaction if the user is in the middle of onboarding.
  /// You can also continue the transaction later by calling
  /// [addPayment] with the [SKPaymentWrapper] object you get from this method.
  bool shouldAddStorePayment(
      {SKPaymentWrapper payment, SKProductWrapper product});
}

/// Dart wrapper around StoreKit's
/// [SKPaymentTransactionState](https://developer.apple.com/documentation/storekit/skpaymenttransactionstate?language=objc).
///
/// Presents the state of a transaction. Used for handling a transaction based on different state.
enum SKPaymentTransactionStateWrapper {
  /// Indicates the transaction is being processed in App Store.
  ///
  /// You should update your UI to indicate the process and waiting for the transaction to update to the next state.
  /// Never complete a transaction that is in purchasing state.
  @JsonValue(0)
  purchasing,

  /// The payment is processed. You should provide the user the content they purchased.
  @JsonValue(1)
  purchased,

  /// The transaction failed. Check the [SKPaymentTransactionWrapper.error] property from [SKPaymentTransactionWrapper] for details.
  @JsonValue(2)
  failed,

  /// This transaction restores the content previously purchased by the user. The previous transaction information can be
  /// obtained in [SKPaymentTransactionWrapper.originalTransaction] from [SKPaymentTransactionWrapper].
  @JsonValue(3)
  restored,

  /// The transaction is in the queue but pending external action. Wait for another callback to get the final state.
  ///
  /// You should update your UI to indicate the process and waiting for the transaction to update to the next state.
  @JsonValue(4)
  deferred,
}

/// Dart wrapper around StoreKit's [SKPaymentTransaction](https://developer.apple.com/documentation/storekit/skpaymenttransaction?language=objc).
///
/// Created when a payment is added to the [SKPaymentQueueWrapper]. Transactions are delivered to your app when a payment is finished processing.
/// Completed transactions provide a receipt and a transaction identifier that the app can use to save a permanent record of the processed payment.
@JsonSerializable(nullable: true)
class SKPaymentTransactionWrapper {
  SKPaymentTransactionWrapper({
    @required this.payment,
    @required this.transactionState,
    @required this.originalTransaction,
    @required this.transactionTimeStamp,
    @required this.transactionIdentifier,
    @required this.downloads,
    @required this.error,
  });

  /// Constructs an instance of this from a key value map of data.
  ///
  /// The map needs to have named string keys with values matching the names and
  /// types of all of the members on this class.
  /// The `map` parameter must not be null.
  @visibleForTesting
  factory SKPaymentTransactionWrapper.fromJson(Map map) {
    if (map == null) {
      return null;
    }
    return _$SKPaymentTransactionWrapperFromJson(map);
  }

  /// Current transaction state.
  final SKPaymentTransactionStateWrapper transactionState;

  /// The payment that is created and added to the payment queue which generated this transaction.
  final SKPaymentWrapper payment;

  /// The original Transaction, only available if the [transactionState] is [SKPaymentTransactionStateWrapper.restored].
  ///
  /// When the [transactionState] is [SKPaymentTransactionStateWrapper.restored], the current transaction object holds a new
  /// [transactionIdentifier].
  final SKPaymentTransactionWrapper originalTransaction;

  /// The timestamp of the transaction.
  ///
  /// Milliseconds since epoch.
  /// It is only defined when the [transactionState] is [SKPaymentTransactionStateWrapper.purchased] or [SKPaymentTransactionStateWrapper.restored].
  final double transactionTimeStamp;

  /// The unique string identifer of the transaction.
  ///
  /// It is only defined when the [transactionState] is [SKPaymentTransactionStateWrapper.purchased] or [SKPaymentTransactionStateWrapper.restored].
  /// You may wish to record this string as part of an audit trail for App Store purchases.
  /// The value of this string corresponds to the same property in the receipt.
  final String transactionIdentifier;

  /// An array of the [SKDownloadWrapper] object of this transaction.
  ///
  /// Only available if the transaction contains downloadable contents.
  ///
  /// It is only defined when the [transactionState] is [SKPaymentTransactionStateWrapper.purchased].
  /// Must be used to download the transaction's content before the transaction is finished.
  final List<SKDownloadWrapper> downloads;

  /// The error object, only available if the [transactionState] is [SKPaymentTransactionStateWrapper.failed].
  final SKError error;

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    final SKPaymentTransactionWrapper typedOther = other;
    return typedOther.payment == payment &&
        typedOther.transactionState == transactionState &&
        typedOther.originalTransaction == originalTransaction &&
        typedOther.transactionTimeStamp == transactionTimeStamp &&
        typedOther.transactionIdentifier == transactionIdentifier &&
        DeepCollectionEquality().equals(typedOther.downloads, downloads) &&
        typedOther.error == error;
  }
}

/// Dart wrapper around StoreKit's [SKDownloadState](https://developer.apple.com/documentation/storekit/skdownloadstate?language=objc).
///
/// The state a download operation that can be in.
enum SKDownloadState {
  /// Indicates that downloadable content is waiting to start.
  @JsonValue(0)
  waiting,

  /// The downloadable content is currently being downloaded
  @JsonValue(1)
  active,

  /// The app paused the download.
  @JsonValue(2)
  pause,

  /// The content is successfully downloaded.
  @JsonValue(3)
  finished,

  /// Indicates that some error occurred while the content was being downloaded.
  @JsonValue(4)
  failed,

  /// The app canceled the download.
  @JsonValue(5)
  cancelled,
}

/// Dart wrapper around StoreKit's [SKDownload](https://developer.apple.com/documentation/storekit/skdownload?language=objc).
///
/// When a product is created in the App Store Connect, one or more download contents can be associated with it.
/// When the product is purchased, a List of [SKDownloadWrapper] object will be present in an [SKPaymentTransactionWrapper] object.
/// To download the content, add the [SKDownloadWrapper] objects to the payment queue and wait for the content to be downloaded.
/// You can also read the [contentURL] to get the URL of the downloaded content after the download completes.
/// Note that all downloaded files must be processed before the completion of the [SKPaymentTransactionWrapper]([SKPaymentQueueWrapper.finishTransaction] is called).
/// After the transaction is complete, any [SKDownloadWrapper] object in the transaction will not be able to be added to the payment queue
/// and the [contentURL ]of the [SKDownloadWrapper] object will be invalid.
@JsonSerializable(nullable: true)
class SKDownloadWrapper {
  SKDownloadWrapper({
    @required this.contentIdentifier,
    @required this.state,
    @required this.contentLength,
    @required this.contentURL,
    @required this.contentVersion,
    @required this.transactionID,
    @required this.progress,
    @required this.timeRemaining,
    @required this.downloadTimeUnknown,
    @required this.error,
  });

  /// Constructs an instance of this from a key value map of data.
  ///
  /// The map needs to have named string keys with values matching the names and
  /// types of all of the members on this class.
  /// The `map` parameter must not be null.
  @visibleForTesting
  factory SKDownloadWrapper.fromJson(Map map) {
    assert(map != null);
    return _$SKDownloadWrapperFromJson(map);
  }

  /// Identifies the downloadable content.
  ///
  /// It is specified in the App Store Connect when the downloadable content is created.
  final String contentIdentifier;

  /// The current download state.
  ///
  /// When the state changes, one of the [SKTransactionObserverWrapper] subclasses' observing methods should be triggered.
  /// The developer should properly handle the downloadable content based on the state.
  final SKDownloadState state;

  /// Length of the content in bytes.
  final int contentLength;

  /// The URL string of the content.
  final String contentURL;

  /// Version of the content formatted as a series of dot-separated integers.
  final String contentVersion;

  /// The transaction ID of the transaction that is associated with the downloadable content.
  final String transactionID;

  /// The download progress, between 0.0 to 1.0.
  final double progress;

  /// The estimated time remaining for the download; if no good estimate is able to be made,
  /// [downloadTimeUnknown] will be set to true.
  final double timeRemaining;

  /// true if [timeRemaining] cannot be estimated.
  final bool downloadTimeUnknown;

  /// The error that prevented the downloading; only available if the [transactionState] is [SKPaymentTransactionStateWrapper.failed].
  final SKError error;

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    final SKDownloadWrapper typedOther = other;
    return typedOther.contentIdentifier == contentIdentifier &&
        typedOther.state == state &&
        typedOther.contentLength == contentLength &&
        typedOther.contentURL == contentURL &&
        typedOther.contentVersion == contentVersion &&
        typedOther.transactionID == transactionID &&
        typedOther.progress == progress &&
        typedOther.timeRemaining == timeRemaining &&
        typedOther.downloadTimeUnknown == downloadTimeUnknown &&
        typedOther.error == error;
  }
}

/// Dart wrapper around StoreKit's [NSError](https://developer.apple.com/documentation/foundation/nserror?language=objc).
@JsonSerializable(nullable: true)
class SKError {
  SKError(
      {@required this.code, @required this.domain, @required this.userInfo});

  /// Constructs an instance of this from a key-value map of data.
  ///
  /// The map needs to have named string keys with values matching the names and
  /// types of all of the members on this class.
  /// The `map` parameter must not be null.
  @visibleForTesting
  factory SKError.fromJson(Map map) {
    assert(map != null);
    return _$SKErrorFromJson(map);
  }

  /// Error [code](https://developer.apple.com/documentation/foundation/1448136-nserror_codes) defined in the Cocoa Framework.
  final int code;

  /// Error [domain](https://developer.apple.com/documentation/foundation/nscocoaerrordomain?language=objc) defined in the Cocoa Framework.
  final String domain;

  /// A map that contains more detailed information about the error. Any key of the map must be one of the [NSErrorUserInfoKey](https://developer.apple.com/documentation/foundation/nserroruserinfokey?language=objc).
  final Map<String, dynamic> userInfo;

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    final SKError typedOther = other;
    return typedOther.code == code &&
        typedOther.domain == domain &&
        DeepCollectionEquality.unordered()
            .equals(typedOther.userInfo, userInfo);
  }
}

/// Dart wrapper around StoreKit's [SKPayment](https://developer.apple.com/documentation/storekit/skpayment?language=objc).
///
/// Used as the parameter to initiate a payment.
/// In general, a developer should not need to create the payment object explicitly; instead, use
/// [SKPaymentQueueWrapper.addPayment] directly with a product identifier to initiate a payment.
@JsonSerializable(nullable: true)
class SKPaymentWrapper {
  SKPaymentWrapper(
      {@required this.productIdentifier,
      this.applicationUsername,
      this.requestData,
      this.quantity = 1,
      this.simulatesAskToBuyInSandbox = false});

  /// Constructs an instance of this from a key value map of data.
  ///
  /// The map needs to have named string keys with values matching the names and
  /// types of all of the members on this class.
  /// The `map` parameter must not be null.
  @visibleForTesting
  factory SKPaymentWrapper.fromJson(Map map) {
    assert(map != null);
    return _$SKPaymentWrapperFromJson(map);
  }

  /// Creates a Map object describes the payment object.
  Map<String, dynamic> toMap() {
    return {
      'productIdentifier': productIdentifier,
      'applicationUsername': applicationUsername,
      'requestData': requestData,
      'quantity': quantity,
      'simulatesAskToBuyInSandbox': simulatesAskToBuyInSandbox
    };
  }

  /// The id for the product that the payment is for.
  final String productIdentifier;

  /// An opaque id for the user's account.
  ///
  /// Used to help the store detect irregular activity. See https://developer.apple.com/documentation/storekit/skpayment/1506116-applicationusername?language=objc for more details.
  /// For example, you can use a one-way hash of the user’s account name on your server. Don’t use the Apple ID for your developer account, the user’s Apple ID, or the user’s not hashed account name on your server.
  final String applicationUsername;

  /// Reserved for future use.
  ///
  /// The value must be null before sending the payment. If the value is not null, the payment will be rejected.
  /// Converted to String from NSData from ios platform using UTF8Encoding. The default is null.
  // The iOS Platform provided this property but it is reserved for future use. We also provide this
  // property to match the iOS platform; in case any future update for this property occurs, we do not need to
  // add this property later.
  final String requestData;

  /// The amount of the product this payment is for. The default is 1. The minimum is 1. The maximum is 10.
  final int quantity;

  /// Produces an "ask to buy" flow in the sandbox if set to true. Default is false. I doesn't do it.
  ///
  /// For how to test in App Store sand box, see https://developer.apple.com/in-app-purchase/.
  final bool simulatesAskToBuyInSandbox;

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    final SKPaymentWrapper typedOther = other;
    return typedOther.productIdentifier == productIdentifier &&
        typedOther.applicationUsername == applicationUsername &&
        typedOther.quantity == quantity &&
        typedOther.simulatesAskToBuyInSandbox == simulatesAskToBuyInSandbox &&
        typedOther.requestData == requestData;
  }
}
