// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import <Flutter/Flutter.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * The WkWebView used for the plugin.
 *
 * This class overrides some methods in `WKWebView` to serve the needs for the plugin.
 */
@interface FLTWKWebView : WKWebView
@end

@interface FLTWebViewController : NSObject <FlutterPlatformView, WKUIDelegate>

@property(nonatomic) FLTWKWebView* webView;

- (instancetype)initWithFrame:(CGRect)frame
               viewIdentifier:(int64_t)viewId
                    arguments:(id _Nullable)args
              registrar:(NSObject<FlutterPluginRegistrar>*)registrar;

- (UIView*)view;

- (void)onMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result;
@end

@interface FLTWebViewFactory : NSObject <FlutterPlatformViewFactory>
- (instancetype)initWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar;
@end

NS_ASSUME_NONNULL_END
