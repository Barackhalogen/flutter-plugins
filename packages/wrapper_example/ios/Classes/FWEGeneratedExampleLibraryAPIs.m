// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
// Autogenerated from Pigeon (v4.0.2), do not edit directly.
// See also: https://pub.dev/packages/pigeon
#import "FWEGeneratedExampleLibraryAPIs.h"
#import <Flutter/Flutter.h>

#if !__has_feature(objc_arc)
#error File requires ARC to be enabled.
#endif

static NSDictionary<NSString *, id> *wrapResult(id result, FlutterError *error) {
  NSDictionary *errorDict = (NSDictionary *)[NSNull null];
  if (error) {
    errorDict = @{
        @"code": (error.code ?: [NSNull null]),
        @"message": (error.message ?: [NSNull null]),
        @"details": (error.details ?: [NSNull null]),
        };
  }
  return @{
      @"result": (result ?: [NSNull null]),
      @"error": errorDict,
      };
}
static id GetNullableObject(NSDictionary* dict, id key) {
  id result = dict[key];
  return (result == [NSNull null]) ? nil : result;
}
static id GetNullableObjectAtIndex(NSArray* array, NSInteger key) {
  id result = array[key];
  return (result == [NSNull null]) ? nil : result;
}



@interface FWEBaseObjectHostApiCodecReader : FlutterStandardReader
@end
@implementation FWEBaseObjectHostApiCodecReader
@end

@interface FWEBaseObjectHostApiCodecWriter : FlutterStandardWriter
@end
@implementation FWEBaseObjectHostApiCodecWriter
@end

@interface FWEBaseObjectHostApiCodecReaderWriter : FlutterStandardReaderWriter
@end
@implementation FWEBaseObjectHostApiCodecReaderWriter
- (FlutterStandardWriter *)writerWithData:(NSMutableData *)data {
  return [[FWEBaseObjectHostApiCodecWriter alloc] initWithData:data];
}
- (FlutterStandardReader *)readerWithData:(NSData *)data {
  return [[FWEBaseObjectHostApiCodecReader alloc] initWithData:data];
}
@end

NSObject<FlutterMessageCodec> *FWEBaseObjectHostApiGetCodec() {
  static dispatch_once_t sPred = 0;
  static FlutterStandardMessageCodec *sSharedObject = nil;
  dispatch_once(&sPred, ^{
    FWEBaseObjectHostApiCodecReaderWriter *readerWriter = [[FWEBaseObjectHostApiCodecReaderWriter alloc] init];
    sSharedObject = [FlutterStandardMessageCodec codecWithReaderWriter:readerWriter];
  });
  return sSharedObject;
}


void FWEBaseObjectHostApiSetup(id<FlutterBinaryMessenger> binaryMessenger, NSObject<FWEBaseObjectHostApi> *api) {
  {
    FlutterBasicMessageChannel *channel =
      [[FlutterBasicMessageChannel alloc]
        initWithName:@"dev.flutter.pigeon.BaseObjectHostApi.dispose"
        binaryMessenger:binaryMessenger
        codec:FWEBaseObjectHostApiGetCodec()        ];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(disposeIdentifier:error:)], @"FWEBaseObjectHostApi api (%@) doesn't respond to @selector(disposeIdentifier:error:)", api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSNumber *arg_identifier = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        [api disposeIdentifier:arg_identifier error:&error];
        callback(wrapResult(nil, error));
      }];
    }
    else {
      [channel setMessageHandler:nil];
    }
  }
}
@interface FWEBaseObjectFlutterApiCodecReader : FlutterStandardReader
@end
@implementation FWEBaseObjectFlutterApiCodecReader
@end

@interface FWEBaseObjectFlutterApiCodecWriter : FlutterStandardWriter
@end
@implementation FWEBaseObjectFlutterApiCodecWriter
@end

@interface FWEBaseObjectFlutterApiCodecReaderWriter : FlutterStandardReaderWriter
@end
@implementation FWEBaseObjectFlutterApiCodecReaderWriter
- (FlutterStandardWriter *)writerWithData:(NSMutableData *)data {
  return [[FWEBaseObjectFlutterApiCodecWriter alloc] initWithData:data];
}
- (FlutterStandardReader *)readerWithData:(NSData *)data {
  return [[FWEBaseObjectFlutterApiCodecReader alloc] initWithData:data];
}
@end

NSObject<FlutterMessageCodec> *FWEBaseObjectFlutterApiGetCodec() {
  static dispatch_once_t sPred = 0;
  static FlutterStandardMessageCodec *sSharedObject = nil;
  dispatch_once(&sPred, ^{
    FWEBaseObjectFlutterApiCodecReaderWriter *readerWriter = [[FWEBaseObjectFlutterApiCodecReaderWriter alloc] init];
    sSharedObject = [FlutterStandardMessageCodec codecWithReaderWriter:readerWriter];
  });
  return sSharedObject;
}


@interface FWEBaseObjectFlutterApi ()
@property (nonatomic, strong) NSObject<FlutterBinaryMessenger> *binaryMessenger;
@end

@implementation FWEBaseObjectFlutterApi

- (instancetype)initWithBinaryMessenger:(NSObject<FlutterBinaryMessenger> *)binaryMessenger {
  self = [super init];
  if (self) {
    _binaryMessenger = binaryMessenger;
  }
  return self;
}
- (void)disposeIdentifier:(NSNumber *)arg_identifier completion:(void(^)(NSError *_Nullable))completion {
  FlutterBasicMessageChannel *channel =
    [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.BaseObjectFlutterApi.dispose"
      binaryMessenger:self.binaryMessenger
      codec:FWEBaseObjectFlutterApiGetCodec()];
  [channel sendMessage:@[arg_identifier ?: [NSNull null]] reply:^(id reply) {
    completion(nil);
  }];
}
@end
@interface FWEMyClassHostApiCodecReader : FlutterStandardReader
@end
@implementation FWEMyClassHostApiCodecReader
@end

@interface FWEMyClassHostApiCodecWriter : FlutterStandardWriter
@end
@implementation FWEMyClassHostApiCodecWriter
@end

@interface FWEMyClassHostApiCodecReaderWriter : FlutterStandardReaderWriter
@end
@implementation FWEMyClassHostApiCodecReaderWriter
- (FlutterStandardWriter *)writerWithData:(NSMutableData *)data {
  return [[FWEMyClassHostApiCodecWriter alloc] initWithData:data];
}
- (FlutterStandardReader *)readerWithData:(NSData *)data {
  return [[FWEMyClassHostApiCodecReader alloc] initWithData:data];
}
@end

NSObject<FlutterMessageCodec> *FWEMyClassHostApiGetCodec() {
  static dispatch_once_t sPred = 0;
  static FlutterStandardMessageCodec *sSharedObject = nil;
  dispatch_once(&sPred, ^{
    FWEMyClassHostApiCodecReaderWriter *readerWriter = [[FWEMyClassHostApiCodecReaderWriter alloc] init];
    sSharedObject = [FlutterStandardMessageCodec codecWithReaderWriter:readerWriter];
  });
  return sSharedObject;
}


void FWEMyClassHostApiSetup(id<FlutterBinaryMessenger> binaryMessenger, NSObject<FWEMyClassHostApi> *api) {
  {
    FlutterBasicMessageChannel *channel =
      [[FlutterBasicMessageChannel alloc]
        initWithName:@"dev.flutter.pigeon.MyClassHostApi.create"
        binaryMessenger:binaryMessenger
        codec:FWEMyClassHostApiGetCodec()        ];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(createIdentifier:primitiveField:classFieldIdentifier:error:)], @"FWEMyClassHostApi api (%@) doesn't respond to @selector(createIdentifier:primitiveField:classFieldIdentifier:error:)", api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSNumber *arg_identifier = GetNullableObjectAtIndex(args, 0);
        NSString *arg_primitiveField = GetNullableObjectAtIndex(args, 1);
        NSNumber *arg_classFieldIdentifier = GetNullableObjectAtIndex(args, 2);
        FlutterError *error;
        [api createIdentifier:arg_identifier primitiveField:arg_primitiveField classFieldIdentifier:arg_classFieldIdentifier error:&error];
        callback(wrapResult(nil, error));
      }];
    }
    else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel =
      [[FlutterBasicMessageChannel alloc]
        initWithName:@"dev.flutter.pigeon.MyClassHostApi.myStaticMethod"
        binaryMessenger:binaryMessenger
        codec:FWEMyClassHostApiGetCodec()        ];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(myStaticMethodWithError:)], @"FWEMyClassHostApi api (%@) doesn't respond to @selector(myStaticMethodWithError:)", api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        FlutterError *error;
        [api myStaticMethodWithError:&error];
        callback(wrapResult(nil, error));
      }];
    }
    else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel =
      [[FlutterBasicMessageChannel alloc]
        initWithName:@"dev.flutter.pigeon.MyClassHostApi.myMethod"
        binaryMessenger:binaryMessenger
        codec:FWEMyClassHostApiGetCodec()        ];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(myMethodIdentifier:primitiveParam:classParamIdentifier:error:)], @"FWEMyClassHostApi api (%@) doesn't respond to @selector(myMethodIdentifier:primitiveParam:classParamIdentifier:error:)", api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSNumber *arg_identifier = GetNullableObjectAtIndex(args, 0);
        NSString *arg_primitiveParam = GetNullableObjectAtIndex(args, 1);
        NSNumber *arg_classParamIdentifier = GetNullableObjectAtIndex(args, 2);
        FlutterError *error;
        [api myMethodIdentifier:arg_identifier primitiveParam:arg_primitiveParam classParamIdentifier:arg_classParamIdentifier error:&error];
        callback(wrapResult(nil, error));
      }];
    }
    else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel =
      [[FlutterBasicMessageChannel alloc]
        initWithName:@"dev.flutter.pigeon.MyClassHostApi.attachClassField"
        binaryMessenger:binaryMessenger
        codec:FWEMyClassHostApiGetCodec()        ];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(attachClassFieldIdentifier:classFieldIdentifier:error:)], @"FWEMyClassHostApi api (%@) doesn't respond to @selector(attachClassFieldIdentifier:classFieldIdentifier:error:)", api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSNumber *arg_identifier = GetNullableObjectAtIndex(args, 0);
        NSNumber *arg_classFieldIdentifier = GetNullableObjectAtIndex(args, 1);
        FlutterError *error;
        [api attachClassFieldIdentifier:arg_identifier classFieldIdentifier:arg_classFieldIdentifier error:&error];
        callback(wrapResult(nil, error));
      }];
    }
    else {
      [channel setMessageHandler:nil];
    }
  }
}
@interface FWEMyClassFlutterApiCodecReader : FlutterStandardReader
@end
@implementation FWEMyClassFlutterApiCodecReader
@end

@interface FWEMyClassFlutterApiCodecWriter : FlutterStandardWriter
@end
@implementation FWEMyClassFlutterApiCodecWriter
@end

@interface FWEMyClassFlutterApiCodecReaderWriter : FlutterStandardReaderWriter
@end
@implementation FWEMyClassFlutterApiCodecReaderWriter
- (FlutterStandardWriter *)writerWithData:(NSMutableData *)data {
  return [[FWEMyClassFlutterApiCodecWriter alloc] initWithData:data];
}
- (FlutterStandardReader *)readerWithData:(NSData *)data {
  return [[FWEMyClassFlutterApiCodecReader alloc] initWithData:data];
}
@end

NSObject<FlutterMessageCodec> *FWEMyClassFlutterApiGetCodec() {
  static dispatch_once_t sPred = 0;
  static FlutterStandardMessageCodec *sSharedObject = nil;
  dispatch_once(&sPred, ^{
    FWEMyClassFlutterApiCodecReaderWriter *readerWriter = [[FWEMyClassFlutterApiCodecReaderWriter alloc] init];
    sSharedObject = [FlutterStandardMessageCodec codecWithReaderWriter:readerWriter];
  });
  return sSharedObject;
}


@interface FWEMyClassFlutterApi ()
@property (nonatomic, strong) NSObject<FlutterBinaryMessenger> *binaryMessenger;
@end

@implementation FWEMyClassFlutterApi

- (instancetype)initWithBinaryMessenger:(NSObject<FlutterBinaryMessenger> *)binaryMessenger {
  self = [super init];
  if (self) {
    _binaryMessenger = binaryMessenger;
  }
  return self;
}
- (void)createIdentifier:(NSNumber *)arg_identifier primitiveField:(NSString *)arg_primitiveField completion:(void(^)(NSError *_Nullable))completion {
  FlutterBasicMessageChannel *channel =
    [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.MyClassFlutterApi.create"
      binaryMessenger:self.binaryMessenger
      codec:FWEMyClassFlutterApiGetCodec()];
  [channel sendMessage:@[arg_identifier ?: [NSNull null], arg_primitiveField ?: [NSNull null]] reply:^(id reply) {
    completion(nil);
  }];
}
- (void)myCallbackMethodIdentifier:(NSNumber *)arg_identifier completion:(void(^)(NSError *_Nullable))completion {
  FlutterBasicMessageChannel *channel =
    [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.MyClassFlutterApi.myCallbackMethod"
      binaryMessenger:self.binaryMessenger
      codec:FWEMyClassFlutterApiGetCodec()];
  [channel sendMessage:@[arg_identifier ?: [NSNull null]] reply:^(id reply) {
    completion(nil);
  }];
}
@end
@interface FWEMyOtherClassHostApiCodecReader : FlutterStandardReader
@end
@implementation FWEMyOtherClassHostApiCodecReader
@end

@interface FWEMyOtherClassHostApiCodecWriter : FlutterStandardWriter
@end
@implementation FWEMyOtherClassHostApiCodecWriter
@end

@interface FWEMyOtherClassHostApiCodecReaderWriter : FlutterStandardReaderWriter
@end
@implementation FWEMyOtherClassHostApiCodecReaderWriter
- (FlutterStandardWriter *)writerWithData:(NSMutableData *)data {
  return [[FWEMyOtherClassHostApiCodecWriter alloc] initWithData:data];
}
- (FlutterStandardReader *)readerWithData:(NSData *)data {
  return [[FWEMyOtherClassHostApiCodecReader alloc] initWithData:data];
}
@end

NSObject<FlutterMessageCodec> *FWEMyOtherClassHostApiGetCodec() {
  static dispatch_once_t sPred = 0;
  static FlutterStandardMessageCodec *sSharedObject = nil;
  dispatch_once(&sPred, ^{
    FWEMyOtherClassHostApiCodecReaderWriter *readerWriter = [[FWEMyOtherClassHostApiCodecReaderWriter alloc] init];
    sSharedObject = [FlutterStandardMessageCodec codecWithReaderWriter:readerWriter];
  });
  return sSharedObject;
}


void FWEMyOtherClassHostApiSetup(id<FlutterBinaryMessenger> binaryMessenger, NSObject<FWEMyOtherClassHostApi> *api) {
  {
    FlutterBasicMessageChannel *channel =
      [[FlutterBasicMessageChannel alloc]
        initWithName:@"dev.flutter.pigeon.MyOtherClassHostApi.create"
        binaryMessenger:binaryMessenger
        codec:FWEMyOtherClassHostApiGetCodec()        ];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(createIdentifier:error:)], @"FWEMyOtherClassHostApi api (%@) doesn't respond to @selector(createIdentifier:error:)", api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSNumber *arg_identifier = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        [api createIdentifier:arg_identifier error:&error];
        callback(wrapResult(nil, error));
      }];
    }
    else {
      [channel setMessageHandler:nil];
    }
  }
}
@interface FWEMyOtherClassFlutterApiCodecReader : FlutterStandardReader
@end
@implementation FWEMyOtherClassFlutterApiCodecReader
@end

@interface FWEMyOtherClassFlutterApiCodecWriter : FlutterStandardWriter
@end
@implementation FWEMyOtherClassFlutterApiCodecWriter
@end

@interface FWEMyOtherClassFlutterApiCodecReaderWriter : FlutterStandardReaderWriter
@end
@implementation FWEMyOtherClassFlutterApiCodecReaderWriter
- (FlutterStandardWriter *)writerWithData:(NSMutableData *)data {
  return [[FWEMyOtherClassFlutterApiCodecWriter alloc] initWithData:data];
}
- (FlutterStandardReader *)readerWithData:(NSData *)data {
  return [[FWEMyOtherClassFlutterApiCodecReader alloc] initWithData:data];
}
@end

NSObject<FlutterMessageCodec> *FWEMyOtherClassFlutterApiGetCodec() {
  static dispatch_once_t sPred = 0;
  static FlutterStandardMessageCodec *sSharedObject = nil;
  dispatch_once(&sPred, ^{
    FWEMyOtherClassFlutterApiCodecReaderWriter *readerWriter = [[FWEMyOtherClassFlutterApiCodecReaderWriter alloc] init];
    sSharedObject = [FlutterStandardMessageCodec codecWithReaderWriter:readerWriter];
  });
  return sSharedObject;
}


@interface FWEMyOtherClassFlutterApi ()
@property (nonatomic, strong) NSObject<FlutterBinaryMessenger> *binaryMessenger;
@end

@implementation FWEMyOtherClassFlutterApi

- (instancetype)initWithBinaryMessenger:(NSObject<FlutterBinaryMessenger> *)binaryMessenger {
  self = [super init];
  if (self) {
    _binaryMessenger = binaryMessenger;
  }
  return self;
}
- (void)createIdentifier:(NSNumber *)arg_identifier completion:(void(^)(NSError *_Nullable))completion {
  FlutterBasicMessageChannel *channel =
    [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.MyOtherClassFlutterApi.create"
      binaryMessenger:self.binaryMessenger
      codec:FWEMyOtherClassFlutterApiGetCodec()];
  [channel sendMessage:@[arg_identifier ?: [NSNull null]] reply:^(id reply) {
    completion(nil);
  }];
}
@end
@interface FWEMyClassSubclassHostApiCodecReader : FlutterStandardReader
@end
@implementation FWEMyClassSubclassHostApiCodecReader
@end

@interface FWEMyClassSubclassHostApiCodecWriter : FlutterStandardWriter
@end
@implementation FWEMyClassSubclassHostApiCodecWriter
@end

@interface FWEMyClassSubclassHostApiCodecReaderWriter : FlutterStandardReaderWriter
@end
@implementation FWEMyClassSubclassHostApiCodecReaderWriter
- (FlutterStandardWriter *)writerWithData:(NSMutableData *)data {
  return [[FWEMyClassSubclassHostApiCodecWriter alloc] initWithData:data];
}
- (FlutterStandardReader *)readerWithData:(NSData *)data {
  return [[FWEMyClassSubclassHostApiCodecReader alloc] initWithData:data];
}
@end

NSObject<FlutterMessageCodec> *FWEMyClassSubclassHostApiGetCodec() {
  static dispatch_once_t sPred = 0;
  static FlutterStandardMessageCodec *sSharedObject = nil;
  dispatch_once(&sPred, ^{
    FWEMyClassSubclassHostApiCodecReaderWriter *readerWriter = [[FWEMyClassSubclassHostApiCodecReaderWriter alloc] init];
    sSharedObject = [FlutterStandardMessageCodec codecWithReaderWriter:readerWriter];
  });
  return sSharedObject;
}


void FWEMyClassSubclassHostApiSetup(id<FlutterBinaryMessenger> binaryMessenger, NSObject<FWEMyClassSubclassHostApi> *api) {
  {
    FlutterBasicMessageChannel *channel =
      [[FlutterBasicMessageChannel alloc]
        initWithName:@"dev.flutter.pigeon.MyClassSubclassHostApi.create"
        binaryMessenger:binaryMessenger
        codec:FWEMyClassSubclassHostApiGetCodec()        ];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(createIdentifier:primitiveField:classFieldIdentifier:error:)], @"FWEMyClassSubclassHostApi api (%@) doesn't respond to @selector(createIdentifier:primitiveField:classFieldIdentifier:error:)", api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSNumber *arg_identifier = GetNullableObjectAtIndex(args, 0);
        NSString *arg_primitiveField = GetNullableObjectAtIndex(args, 1);
        NSNumber *arg_classFieldIdentifier = GetNullableObjectAtIndex(args, 2);
        FlutterError *error;
        [api createIdentifier:arg_identifier primitiveField:arg_primitiveField classFieldIdentifier:arg_classFieldIdentifier error:&error];
        callback(wrapResult(nil, error));
      }];
    }
    else {
      [channel setMessageHandler:nil];
    }
  }
}
