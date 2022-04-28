// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import <Flutter/Flutter.h>
#import <WebKit/WebKit.h>

#import "FWFGeneratedWebKitApis.h"
#import "FWFInstanceManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface FWFAssetManager : NSObject
- (NSString *)lookupKeyForAsset:(NSString *)asset;
@end

/**
 * Implementation of WKWebView that can be used as a FlutterPlatformView.
 */
@interface FWFWebView : WKWebView <FlutterPlatformView>
@end

/**
 * Host api implementation for WKWebView.
 *
 * Handles creating WKWebViews that intercommunicate with a paired Dart object.
 */
@interface FWFWebViewHostApiImpl : NSObject <FWFWKWebViewHostApi>
- (instancetype)initWithInstanceManager:(FWFInstanceManager *)instanceManager;
- (instancetype)initWithInstanceManager:(FWFInstanceManager *)instanceManager
                                 bundle:(NSBundle *)bundle
                           assetManager:(FWFAssetManager *)assetManager;
@end

NS_ASSUME_NONNULL_END
