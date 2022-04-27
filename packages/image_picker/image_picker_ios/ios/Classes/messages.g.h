// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
// Autogenerated from Pigeon (v3.0.3), do not edit directly.
// See also: https://pub.dev/packages/pigeon
#import <Foundation/Foundation.h>
@protocol FlutterBinaryMessenger;
@protocol FlutterMessageCodec;
@class FlutterError;
@class FlutterStandardTypedData;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, FLTSourceCamera) {
  FLTSourceCameraRear = 0,
  FLTSourceCameraFront = 1,
};

typedef NS_ENUM(NSUInteger, FLTSourceType) {
  FLTSourceTypeCamera = 0,
  FLTSourceTypeGallery = 1,
};

@class FLTMaxSize;
@class FLTSourceSpecification;

@interface FLTMaxSize : NSObject
+ (instancetype)makeWithWidth:(nullable NSNumber *)width height:(nullable NSNumber *)height;
@property(nonatomic, strong, nullable) NSNumber *width;
@property(nonatomic, strong, nullable) NSNumber *height;
@end

@interface FLTSourceSpecification : NSObject
/// `init` unavailable to enforce nonnull fields, see the `make` class method.
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)makeWithType:(FLTSourceType)type camera:(FLTSourceCamera)camera;
@property(nonatomic, assign) FLTSourceType type;
@property(nonatomic, assign) FLTSourceCamera camera;
@end

/// The codec used by FLTImagePickerApi.
NSObject<FlutterMessageCodec> *FLTImagePickerApiGetCodec(void);

@protocol FLTImagePickerApi
- (void)pickImageWithSource:(FLTSourceSpecification *)source
                    maxSize:(FLTMaxSize *)maxSize
                    quality:(nullable NSNumber *)imageQuality
        requestFullMetadata:(NSNumber *)requestFullMetadata
                 completion:(void (^)(NSString *_Nullable, FlutterError *_Nullable))completion;
- (void)pickMultiImageWithMaxSize:(FLTMaxSize *)maxSize
                          quality:(nullable NSNumber *)imageQuality
                       completion:(void (^)(NSArray<NSString *> *_Nullable,
                                            FlutterError *_Nullable))completion;
- (void)pickVideoWithSource:(FLTSourceSpecification *)source
                maxDuration:(nullable NSNumber *)maxDurationSeconds
                 completion:(void (^)(NSString *_Nullable, FlutterError *_Nullable))completion;
@end

extern void FLTImagePickerApiSetup(id<FlutterBinaryMessenger> binaryMessenger,
                                   NSObject<FLTImagePickerApi> *_Nullable api);

NS_ASSUME_NONNULL_END
