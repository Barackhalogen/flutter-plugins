// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
// Autogenerated from Pigeon (v3.1.5), do not edit directly.
// See also: https://pub.dev/packages/pigeon
#import <Foundation/Foundation.h>
@protocol FlutterBinaryMessenger;
@protocol FlutterMessageCodec;
@class FlutterError;
@class FlutterStandardTypedData;

NS_ASSUME_NONNULL_BEGIN

/// The codec used by FLTPathProviderApi.
NSObject<FlutterMessageCodec> *FLTPathProviderApiGetCodec(void);

@protocol FLTPathProviderApi
- (nullable NSString *)getTemporaryPathWithError:(FlutterError *_Nullable *_Nonnull)error;
- (nullable NSString *)getApplicationSupportPathWithError:(FlutterError *_Nullable *_Nonnull)error;
- (nullable NSString *)getLibraryPathWithError:(FlutterError *_Nullable *_Nonnull)error;
- (nullable NSString *)getApplicationDocumentsPathWithError:
    (FlutterError *_Nullable *_Nonnull)error;
@end

extern void FLTPathProviderApiSetup(id<FlutterBinaryMessenger> binaryMessenger,
                                    NSObject<FLTPathProviderApi> *_Nullable api);

NS_ASSUME_NONNULL_END
