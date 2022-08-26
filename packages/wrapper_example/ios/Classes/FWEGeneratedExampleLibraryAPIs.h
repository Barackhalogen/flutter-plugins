// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
// Autogenerated from Pigeon (v4.0.2), do not edit directly.
// See also: https://pub.dev/packages/pigeon
#import <Foundation/Foundation.h>
@protocol FlutterBinaryMessenger;
@protocol FlutterMessageCodec;
@class FlutterError;
@class FlutterStandardTypedData;

NS_ASSUME_NONNULL_BEGIN


/// The codec used by FWEBaseObjectHostApi.
NSObject<FlutterMessageCodec> *FWEBaseObjectHostApiGetCodec(void);

@protocol FWEBaseObjectHostApi
- (void)disposeIdentifier:(NSNumber *)identifier error:(FlutterError *_Nullable *_Nonnull)error;
@end

extern void FWEBaseObjectHostApiSetup(id<FlutterBinaryMessenger> binaryMessenger, NSObject<FWEBaseObjectHostApi> *_Nullable api);

/// The codec used by FWEBaseObjectFlutterApi.
NSObject<FlutterMessageCodec> *FWEBaseObjectFlutterApiGetCodec(void);

@interface FWEBaseObjectFlutterApi : NSObject
- (instancetype)initWithBinaryMessenger:(id<FlutterBinaryMessenger>)binaryMessenger;
- (void)disposeIdentifier:(NSNumber *)identifier completion:(void(^)(NSError *_Nullable))completion;
@end
/// The codec used by FWEMyClassHostApi.
NSObject<FlutterMessageCodec> *FWEMyClassHostApiGetCodec(void);

@protocol FWEMyClassHostApi
- (void)createIdentifier:(NSNumber *)identifier primitiveField:(NSString *)primitiveField classFieldIdentifier:(NSNumber *)classFieldIdentifier error:(FlutterError *_Nullable *_Nonnull)error;
- (void)myStaticMethodWithError:(FlutterError *_Nullable *_Nonnull)error;
- (void)myMethodIdentifier:(NSNumber *)identifier primitiveParam:(NSString *)primitiveParam classParamIdentifier:(NSNumber *)classParamIdentifier error:(FlutterError *_Nullable *_Nonnull)error;
- (void)attachClassFieldIdentifier:(NSNumber *)identifier classFieldIdentifier:(NSNumber *)classFieldIdentifier error:(FlutterError *_Nullable *_Nonnull)error;
@end

extern void FWEMyClassHostApiSetup(id<FlutterBinaryMessenger> binaryMessenger, NSObject<FWEMyClassHostApi> *_Nullable api);

/// The codec used by FWEMyClassFlutterApi.
NSObject<FlutterMessageCodec> *FWEMyClassFlutterApiGetCodec(void);

@interface FWEMyClassFlutterApi : NSObject
- (instancetype)initWithBinaryMessenger:(id<FlutterBinaryMessenger>)binaryMessenger;
- (void)createIdentifier:(NSNumber *)identifier primitiveField:(NSString *)primitiveField completion:(void(^)(NSError *_Nullable))completion;
- (void)myCallbackMethodIdentifier:(NSNumber *)identifier completion:(void(^)(NSError *_Nullable))completion;
@end
/// The codec used by FWEMyOtherClassHostApi.
NSObject<FlutterMessageCodec> *FWEMyOtherClassHostApiGetCodec(void);

@protocol FWEMyOtherClassHostApi
- (void)createIdentifier:(NSNumber *)identifier error:(FlutterError *_Nullable *_Nonnull)error;
@end

extern void FWEMyOtherClassHostApiSetup(id<FlutterBinaryMessenger> binaryMessenger, NSObject<FWEMyOtherClassHostApi> *_Nullable api);

/// The codec used by FWEMyOtherClassFlutterApi.
NSObject<FlutterMessageCodec> *FWEMyOtherClassFlutterApiGetCodec(void);

@interface FWEMyOtherClassFlutterApi : NSObject
- (instancetype)initWithBinaryMessenger:(id<FlutterBinaryMessenger>)binaryMessenger;
- (void)createIdentifier:(NSNumber *)identifier completion:(void(^)(NSError *_Nullable))completion;
@end
/// The codec used by FWEMyClassSubclassHostApi.
NSObject<FlutterMessageCodec> *FWEMyClassSubclassHostApiGetCodec(void);

@protocol FWEMyClassSubclassHostApi
- (void)createIdentifier:(NSNumber *)identifier primitiveField:(NSString *)primitiveField classFieldIdentifier:(NSNumber *)classFieldIdentifier error:(FlutterError *_Nullable *_Nonnull)error;
@end

extern void FWEMyClassSubclassHostApiSetup(id<FlutterBinaryMessenger> binaryMessenger, NSObject<FWEMyClassSubclassHostApi> *_Nullable api);

NS_ASSUME_NONNULL_END
