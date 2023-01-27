// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
// Autogenerated from Pigeon (v7.0.5), do not edit directly.
// See also: https://pub.dev/packages/pigeon

#import <Foundation/Foundation.h>

@protocol FlutterBinaryMessenger;
@protocol FlutterMessageCodec;
@class FlutterError;
@class FlutterStandardTypedData;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, FLTFontWeight) {
  FLTFontWeightUltraLight = 0,
  FLTFontWeightThin = 1,
  FLTFontWeightLight = 2,
  FLTFontWeightRegular = 3,
  FLTFontWeightMedium = 4,
  FLTFontWeightSemibold = 5,
  FLTFontWeightBold = 6,
  FLTFontWeightHeavy = 7,
  FLTFontWeightBlack = 8,
};

@class FLTPlatformImage;

@interface FLTPlatformImage : NSObject
+ (instancetype)makeWithScale:(nullable NSNumber *)scale
                        bytes:(nullable FlutterStandardTypedData *)bytes;
@property(nonatomic, strong, nullable) NSNumber *scale;
@property(nonatomic, strong, nullable) FlutterStandardTypedData *bytes;
@end

/// The codec used by FLTPlatformImagesApi.
NSObject<FlutterMessageCodec> *FLTPlatformImagesApiGetCodec(void);

@protocol FLTPlatformImagesApi
- (nullable FLTPlatformImage *)getSystemImageName:(NSString *)name
                                             size:(NSNumber *)size
                                           weight:(FLTFontWeight)weight
                                       colorsRGBA:(NSArray<NSNumber *> *)colorsRGBA
                                 preferMulticolor:(NSNumber *)preferMulticolor
                                            error:(FlutterError *_Nullable *_Nonnull)error;
- (nullable FLTPlatformImage *)getPlatformImageName:(NSString *)name
                                              error:(FlutterError *_Nullable *_Nonnull)error;
- (nullable NSString *)resolveURLName:(NSString *)name
                            extension:(nullable NSString *)extension
                                error:(FlutterError *_Nullable *_Nonnull)error;
@end

extern void FLTPlatformImagesApiSetup(id<FlutterBinaryMessenger> binaryMessenger,
                                      NSObject<FLTPlatformImagesApi> *_Nullable api);

NS_ASSUME_NONNULL_END
