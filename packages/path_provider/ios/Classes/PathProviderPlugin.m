// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "PathProviderPlugin.h"

NSString* GetDirectoryOfType(NSSearchPathDirectory dir) {
  NSArray* paths = NSSearchPathForDirectoriesInDomains(dir, NSUserDomainMask, YES);
  return paths.firstObject;
}

static FlutterError* getFlutterError(NSError* error) {
  if (error == nil) return nil;
  return [FlutterError errorWithCode:[NSString stringWithFormat:@"Error %ld", error.code]
                             message:error.domain
                             details:error.localizedDescription];
}

@implementation FLTPathProviderPlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel =
      [FlutterMethodChannel methodChannelWithName:@"plugins.flutter.io/path_provider"
                                  binaryMessenger:registrar.messenger];
  [channel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
    if ([@"getTemporaryDirectory" isEqualToString:call.method]) {
      result([self getTemporaryDirectory]);
    } else if ([@"getApplicationDocumentsDirectory" isEqualToString:call.method]) {
      result([self getApplicationDocumentsDirectory]);
    } else if ([@"getApplicationSupportDirectory" isEqualToString:call.method]) {
      NSString* path = [self getApplicationSupportDirectory];

      // Create the path if it doesn't exist
      NSError* error;
      BOOL success = [self createDirectoryAtPath:path
                     withIntermediateDirectories:YES
                                      attributes:nil
                                           error:&error];
      if (!success) {
        result(getFlutterError(error));
      } else {
        result(path);
      }
    } else {
      result(FlutterMethodNotImplemented);
    }
  }];
}

+ (NSString*)getTemporaryDirectory {
  return GetDirectoryOfType(NSCachesDirectory);
}

+ (NSString*)getApplicationDocumentsDirectory {
  return GetDirectoryOfType(NSDocumentDirectory);
}

+ (NSString*)getApplicationSupportDirectory {
  return GetDirectoryOfType(NSApplicationSupportDirectory);
}

@end
