#import "QuickActionsPlugin.h"

static NSString *const CHANNEL_NAME = @"plugins.flutter.io/quick_actions";

@interface QuickActionsPlugin ()
@property(nonatomic, retain) FlutterMethodChannel *channel;
@end

@implementation QuickActionsPlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
  FlutterMethodChannel *channel =
      [FlutterMethodChannel methodChannelWithName:CHANNEL_NAME
                                  binaryMessenger:[registrar messenger]];
  QuickActionsPlugin *instance = [[QuickActionsPlugin alloc] init];
  instance.channel = channel;
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
  if ([call.method isEqualToString:@"setShortcutItems"]) {
    setShortcutItems(call.arguments);
    result(nil);
  } else if ([call.method isEqualToString:@"clearShortcutItems"]) {
    [UIApplication sharedApplication].shortcutItems = @[];
    result(nil);
  } else {
    result(FlutterMethodNotImplemented);
  }
}

- (void)dealloc {
  [self.channel setMethodCallHandler:nil];
  self.channel = nil;
}

- (void)performActionForShortcutItem:(UIApplicationShortcutItem *)item {
  [self.channel invokeMethod:@"launch" arguments:item.type];
}

#pragma mark Private functions

static void setShortcutItems(NSArray *items) {
  NSMutableArray *newShortcuts = [[NSMutableArray alloc] init];

  for (id item in items) {
    UIApplicationShortcutItem *shortcut = deserializeShortcutItem(item);
    [newShortcuts addObject:shortcut];
  }

  [UIApplication sharedApplication].shortcutItems = newShortcuts;
}

static UIApplicationShortcutItem *deserializeShortcutItem(NSDictionary *serialized) {
  UIApplicationShortcutIcon *icon =
      [serialized[@"icon"] isKindOfClass:[NSNull class]]
          ? nil
          : [UIApplicationShortcutIcon iconWithTemplateImageName:serialized[@"icon"]];

  return [[UIApplicationShortcutItem alloc] initWithType:serialized[@"type"]
                                          localizedTitle:serialized[@"localizedTitle"]
                                       localizedSubtitle:nil
                                                    icon:icon
                                                userInfo:nil];
}

@end
