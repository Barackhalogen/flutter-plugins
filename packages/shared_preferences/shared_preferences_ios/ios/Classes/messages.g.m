// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
// Autogenerated from Pigeon (v1.0.16), do not edit directly.
// See also: https://pub.dev/packages/pigeon
#import "messages.g.h"
#import <Flutter/Flutter.h>

#if !__has_feature(objc_arc)
#error File requires ARC to be enabled.
#endif

static NSDictionary<NSString *, id> *wrapResult(id result, FlutterError *error) {
  NSDictionary *errorDict = (NSDictionary *)[NSNull null];
  if (error) {
    errorDict = @{
      @"code" : (error.code ? error.code : [NSNull null]),
      @"message" : (error.message ? error.message : [NSNull null]),
      @"details" : (error.details ? error.details : [NSNull null]),
    };
  }
  return @{
    @"result" : (result ? result : [NSNull null]),
    @"error" : errorDict,
  };
}

@interface SharedPreferencesApiCodecReader : FlutterStandardReader
@end
@implementation SharedPreferencesApiCodecReader
@end

@interface SharedPreferencesApiCodecWriter : FlutterStandardWriter
@end
@implementation SharedPreferencesApiCodecWriter
@end

@interface SharedPreferencesApiCodecReaderWriter : FlutterStandardReaderWriter
@end
@implementation SharedPreferencesApiCodecReaderWriter
- (FlutterStandardWriter *)writerWithData:(NSMutableData *)data {
  return [[SharedPreferencesApiCodecWriter alloc] initWithData:data];
}
- (FlutterStandardReader *)readerWithData:(NSData *)data {
  return [[SharedPreferencesApiCodecReader alloc] initWithData:data];
}
@end

NSObject<FlutterMessageCodec> *SharedPreferencesApiGetCodec() {
  static dispatch_once_t s_pred = 0;
  static FlutterStandardMessageCodec *s_sharedObject = nil;
  dispatch_once(&s_pred, ^{
    SharedPreferencesApiCodecReaderWriter *readerWriter =
        [[SharedPreferencesApiCodecReaderWriter alloc] init];
    s_sharedObject = [FlutterStandardMessageCodec codecWithReaderWriter:readerWriter];
  });
  return s_sharedObject;
}

void SharedPreferencesApiSetup(id<FlutterBinaryMessenger> binaryMessenger,
                               NSObject<SharedPreferencesApi> *api) {
  {
    FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
        messageChannelWithName:@"dev.flutter.pigeon.SharedPreferencesApi.remove"
               binaryMessenger:binaryMessenger
                         codec:SharedPreferencesApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(removeKey:error:)],
                @"SharedPreferencesApi api (%@) doesn't respond to @selector(removeKey:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSString *arg_key = args[0];
        FlutterError *error;
        NSNumber *output = [api removeKey:arg_key error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
        messageChannelWithName:@"dev.flutter.pigeon.SharedPreferencesApi.setBool"
               binaryMessenger:binaryMessenger
                         codec:SharedPreferencesApiGetCodec()];
    if (api) {
      NSCAssert(
          [api respondsToSelector:@selector(setBoolKey:value:error:)],
          @"SharedPreferencesApi api (%@) doesn't respond to @selector(setBoolKey:value:error:)",
          api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSString *arg_key = args[0];
        NSNumber *arg_value = args[1];
        FlutterError *error;
        NSNumber *output = [api setBoolKey:arg_key value:arg_value error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
        messageChannelWithName:@"dev.flutter.pigeon.SharedPreferencesApi.setDouble"
               binaryMessenger:binaryMessenger
                         codec:SharedPreferencesApiGetCodec()];
    if (api) {
      NSCAssert(
          [api respondsToSelector:@selector(setDoubleKey:value:error:)],
          @"SharedPreferencesApi api (%@) doesn't respond to @selector(setDoubleKey:value:error:)",
          api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSString *arg_key = args[0];
        NSNumber *arg_value = args[1];
        FlutterError *error;
        NSNumber *output = [api setDoubleKey:arg_key value:arg_value error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
        messageChannelWithName:@"dev.flutter.pigeon.SharedPreferencesApi.setInt"
               binaryMessenger:binaryMessenger
                         codec:SharedPreferencesApiGetCodec()];
    if (api) {
      NSCAssert(
          [api respondsToSelector:@selector(setIntKey:value:error:)],
          @"SharedPreferencesApi api (%@) doesn't respond to @selector(setIntKey:value:error:)",
          api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSString *arg_key = args[0];
        NSNumber *arg_value = args[1];
        FlutterError *error;
        NSNumber *output = [api setIntKey:arg_key value:arg_value error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
        messageChannelWithName:@"dev.flutter.pigeon.SharedPreferencesApi.setString"
               binaryMessenger:binaryMessenger
                         codec:SharedPreferencesApiGetCodec()];
    if (api) {
      NSCAssert(
          [api respondsToSelector:@selector(setStringKey:value:error:)],
          @"SharedPreferencesApi api (%@) doesn't respond to @selector(setStringKey:value:error:)",
          api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSString *arg_key = args[0];
        NSString *arg_value = args[1];
        FlutterError *error;
        NSNumber *output = [api setStringKey:arg_key value:arg_value error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
        messageChannelWithName:@"dev.flutter.pigeon.SharedPreferencesApi.setStringList"
               binaryMessenger:binaryMessenger
                         codec:SharedPreferencesApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(setStringListKey:value:error:)],
                @"SharedPreferencesApi api (%@) doesn't respond to "
                @"@selector(setStringListKey:value:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSString *arg_key = args[0];
        NSArray<NSString *> *arg_value = args[1];
        FlutterError *error;
        NSNumber *output = [api setStringListKey:arg_key value:arg_value error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
        messageChannelWithName:@"dev.flutter.pigeon.SharedPreferencesApi.clear"
               binaryMessenger:binaryMessenger
                         codec:SharedPreferencesApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(clearWithError:)],
                @"SharedPreferencesApi api (%@) doesn't respond to @selector(clearWithError:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        FlutterError *error;
        NSNumber *output = [api clearWithError:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
        messageChannelWithName:@"dev.flutter.pigeon.SharedPreferencesApi.getAll"
               binaryMessenger:binaryMessenger
                         codec:SharedPreferencesApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(getAllWithError:)],
                @"SharedPreferencesApi api (%@) doesn't respond to @selector(getAllWithError:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        FlutterError *error;
        NSDictionary<NSString *, id> *output = [api getAllWithError:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
}
