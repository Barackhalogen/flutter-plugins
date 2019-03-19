// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sk_product_wrapper.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SkProductResponseWrapper _$SkProductResponseWrapperFromJson(Map json) {
  return SkProductResponseWrapper(
      products: (json['products'] as List)
          .map((e) => SKProductWrapper.fromJson(e as Map))
          .toList(),
      invalidProductIdentifiers: (json['invalidProductIdentifiers'] as List)
          .map((e) => e as String)
          .toList());
}

SKProductSubscriptionPeriodWrapper _$SKProductSubscriptionPeriodWrapperFromJson(
    Map json) {
  return SKProductSubscriptionPeriodWrapper(
      numberOfUnits: json['numberOfUnits'] as int,
      unit:
          _$enumDecodeNullable(_$SubscriptionPeriodUnitEnumMap, json['unit']));
}

T _$enumDecode<T>(Map<T, dynamic> enumValues, dynamic source) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }
  return enumValues.entries
      .singleWhere((e) => e.value == source,
          orElse: () => throw ArgumentError(
              '`$source` is not one of the supported values: '
              '${enumValues.values.join(', ')}'))
      .key;
}

T _$enumDecodeNullable<T>(Map<T, dynamic> enumValues, dynamic source) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source);
}

const _$SubscriptionPeriodUnitEnumMap = <SKSubscriptionPeriodUnit, dynamic>{
  SKSubscriptionPeriodUnit.day: 0,
  SKSubscriptionPeriodUnit.week: 1,
  SKSubscriptionPeriodUnit.month: 2,
  SKSubscriptionPeriodUnit.year: 3
};

SKProductDiscountWrapper _$SKProductDiscountWrapperFromJson(Map json) {
  return SKProductDiscountWrapper(
      price: json['price'] as String,
      priceLocale: json['priceLocale'] == null
          ? null
          : SKPriceLocaleWrapper.fromJson(json['priceLocale'] as Map),
      numberOfPeriods: json['numberOfPeriods'] as int,
      paymentMode: _$enumDecodeNullable(
          _$ProductDiscountPaymentModeEnumMap, json['paymentMode']),
      subscriptionPeriod: json['subscriptionPeriod'] == null
          ? null
          : SKProductSubscriptionPeriodWrapper.fromJson(
              json['subscriptionPeriod'] as Map));
}

const _$ProductDiscountPaymentModeEnumMap =
    <SKProductDiscountPaymentMode, dynamic>{
  SKProductDiscountPaymentMode.payAsYouGo: 0,
  SKProductDiscountPaymentMode.payUpFront: 1,
  SKProductDiscountPaymentMode.freeTrail: 2
};

SKProductWrapper _$SKProductWrapperFromJson(Map json) {
  return SKProductWrapper(
      productIdentifier: json['productIdentifier'] as String,
      localizedTitle: json['localizedTitle'] as String,
      localizedDescription: json['localizedDescription'] as String,
      priceLocale: json['priceLocale'] == null
          ? null
          : SKPriceLocaleWrapper.fromJson(json['priceLocale'] as Map),
      downloadContentVersion: json['downloadContentVersion'] as String,
      subscriptionGroupIdentifier:
          json['subscriptionGroupIdentifier'] as String,
      price: json['price'] as String,
      downloadable: json['downloadable'] as bool,
      downloadContentLengths: (json['downloadContentLengths'] as List)
          ?.map((e) => e as int)
          ?.toList(),
      subscriptionPeriod: json['subscriptionPeriod'] == null
          ? null
          : SKProductSubscriptionPeriodWrapper.fromJson(
              json['subscriptionPeriod'] as Map),
      introductoryPrice: json['introductoryPrice'] == null
          ? null
          : SKProductDiscountWrapper.fromJson(
              json['introductoryPrice'] as Map));
}

SKPriceLocaleWrapper _$PriceLocaleWrapperFromJson(Map json) {
  return SKPriceLocaleWrapper(currencySymbol: json['currencySymbol'] as String);
}
