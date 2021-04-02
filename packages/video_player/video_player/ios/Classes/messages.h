// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Autogenerated from Pigeon (v0.1.23), do not edit directly.
// See also: https://pub.dev/packages/pigeon
#import <Foundation/Foundation.h>
@protocol FlutterBinaryMessenger;
@class FlutterError;
@class FlutterStandardTypedData;

NS_ASSUME_NONNULL_BEGIN

@class FLTTextureMessage;
@class FLTCreateMessage;
@class FLTLoopingMessage;
@class FLTVolumeMessage;
@class FLTPlaybackSpeedMessage;
@class FLTPositionMessage;
@class FLTTrackSelectionsMessage;
@class FLTMixWithOthersMessage;

@interface FLTTextureMessage : NSObject
@property(nonatomic, strong, nullable) NSNumber *textureId;
@end

@interface FLTCreateMessage : NSObject
@property(nonatomic, copy, nullable) NSString *asset;
@property(nonatomic, copy, nullable) NSString *uri;
@property(nonatomic, copy, nullable) NSString *packageName;
@property(nonatomic, copy, nullable) NSString *formatHint;
@property(nonatomic, strong, nullable) NSDictionary *httpHeaders;
@end

@interface FLTLoopingMessage : NSObject
@property(nonatomic, strong, nullable) NSNumber *textureId;
@property(nonatomic, strong, nullable) NSNumber *isLooping;
@end

@interface FLTVolumeMessage : NSObject
@property(nonatomic, strong, nullable) NSNumber *textureId;
@property(nonatomic, strong, nullable) NSNumber *volume;
@end

@interface FLTPlaybackSpeedMessage : NSObject
@property(nonatomic, strong, nullable) NSNumber *textureId;
@property(nonatomic, strong, nullable) NSNumber *speed;
@end

@interface FLTPositionMessage : NSObject
@property(nonatomic, strong, nullable) NSNumber *textureId;
@property(nonatomic, strong, nullable) NSNumber *position;
@end

@interface FLTTrackSelectionsMessage : NSObject
@property(nonatomic, strong, nullable) NSNumber *textureId;
@property(nonatomic, copy, nullable) NSString *trackId;
@property(nonatomic, strong, nullable) NSArray *trackSelections;
@end

@interface FLTMixWithOthersMessage : NSObject
@property(nonatomic, strong, nullable) NSNumber *mixWithOthers;
@end

@protocol FLTVideoPlayerApi
- (void)initialize:(FlutterError *_Nullable *_Nonnull)error;
- (nullable FLTTextureMessage *)create:(FLTCreateMessage *)input
                                 error:(FlutterError *_Nullable *_Nonnull)error;
- (void)dispose:(FLTTextureMessage *)input error:(FlutterError *_Nullable *_Nonnull)error;
- (void)setLooping:(FLTLoopingMessage *)input error:(FlutterError *_Nullable *_Nonnull)error;
- (void)setVolume:(FLTVolumeMessage *)input error:(FlutterError *_Nullable *_Nonnull)error;
- (void)setPlaybackSpeed:(FLTPlaybackSpeedMessage *)input
                   error:(FlutterError *_Nullable *_Nonnull)error;
- (void)play:(FLTTextureMessage *)input error:(FlutterError *_Nullable *_Nonnull)error;
- (nullable FLTPositionMessage *)position:(FLTTextureMessage *)input
                                    error:(FlutterError *_Nullable *_Nonnull)error;
- (void)seekTo:(FLTPositionMessage *)input error:(FlutterError *_Nullable *_Nonnull)error;
- (nullable FLTTrackSelectionsMessage *)trackSelections:(FLTTextureMessage *)input
                                                  error:(FlutterError *_Nullable *_Nonnull)error;
- (void)setTrackSelection:(FLTTrackSelectionsMessage *)input
                    error:(FlutterError *_Nullable *_Nonnull)error;
- (void)pause:(FLTTextureMessage *)input error:(FlutterError *_Nullable *_Nonnull)error;
- (void)setMixWithOthers:(FLTMixWithOthersMessage *)input
                   error:(FlutterError *_Nullable *_Nonnull)error;
@end

extern void FLTVideoPlayerApiSetup(id<FlutterBinaryMessenger> binaryMessenger,
                                   id<FLTVideoPlayerApi> _Nullable api);

NS_ASSUME_NONNULL_END
