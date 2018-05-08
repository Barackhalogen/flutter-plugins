#import "FirebaseDynamicLinksPlugin.h"

#import "Firebase/Firebase.h"

@implementation FirebaseDynamicLinksPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"plugins.flutter.io/firebase_dynamic_links"
            binaryMessenger:[registrar messenger]];
  FirebaseDynamicLinksPlugin* instance = [[FirebaseDynamicLinksPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (instancetype)init {
  self = [super init];
  if (self) {
    if (![FIRApp defaultApp]) {
      [FIRApp configure];
    }
  }
  return self;
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
  if ([@"DynamicLinkComponents#uri" isEqualToString:call.method]) {
    NSURL *url = [self createLink:call.arguments];
    result([url absoluteString]);
  } else {
    result(FlutterMethodNotImplemented);
  }
}

- (NSURL *)createLink:(NSDictionary *)arguments {
  NSURL *link = [NSURL URLWithString:arguments[@"link"]];
  NSString *domain = arguments[@"domain"];

  FIRDynamicLinkComponents *components =
      [FIRDynamicLinkComponents componentsWithLink:link domain:domain];

  if (![arguments[@"androidParameters"] isEqual:[NSNull null]]) {
    NSDictionary *params = arguments[@"androidParameters"];

    FIRDynamicLinkAndroidParameters *androidParams = [FIRDynamicLinkAndroidParameters parametersWithPackageName: params[@"packageName"]];

    NSString *fallbackUrl = params[@"fallbackUrl"];
    NSNumber *minimumVersion = params[@"minimumVersion"];

    if (![fallbackUrl isEqual:[NSNull null]]) androidParams.fallbackURL = [NSURL URLWithString:fallbackUrl];
    if (![minimumVersion isEqual:[NSNull null]]) androidParams.minimumVersion = ((NSNumber *) minimumVersion).integerValue;

    components.androidParameters = androidParams;
  }

  if (![arguments[@"googleAnalyticsParameters"] isEqual:[NSNull null]]) {
    NSDictionary *params = arguments[@"googleAnalyticsParameters"];

    FIRDynamicLinkGoogleAnalyticsParameters *googleAnalyticsParameters =
        [FIRDynamicLinkGoogleAnalyticsParameters parameters];

    NSString *campaign = params[@"campaign"];
    NSString *content = params[@"content"];
    NSString *medium = params[@"medium"];
    NSString *source = params[@"source"];
    NSString *term = params[@"term"];

    if (![campaign isEqual:[NSNull null]]) googleAnalyticsParameters.campaign = campaign;
    if (![content isEqual:[NSNull null]]) googleAnalyticsParameters.content = content;
    if (![medium isEqual:[NSNull null]]) googleAnalyticsParameters.medium = medium;
    if (![source isEqual:[NSNull null]]) googleAnalyticsParameters.source = source;
    if (![term isEqual:[NSNull null]]) googleAnalyticsParameters.term = term;

    components.analyticsParameters = googleAnalyticsParameters;
  }

  if (![arguments[@"iosParameters"] isEqual:[NSNull null]]) {
    NSDictionary *params = arguments[@"iosParameters"];

    FIRDynamicLinkIOSParameters *iosParameters =
        [FIRDynamicLinkIOSParameters parametersWithBundleID:params[@"bundleId"]];

    NSString *appStoreID = params[@"appStoreId"];
    NSString *customScheme = params[@"customScheme"];
    NSString *fallbackURL = params[@"fallbackUrl"];
    NSString *iPadBundleID = params[@"ipadBundleId"];
    NSString *iPadFallbackURL = params[@"ipadFallbackUrl"];
    NSString *minimumAppVersion = params[@"minimumVersion"];

    if (![appStoreID isEqual:[NSNull null]]) iosParameters.appStoreID = appStoreID;
    if (![customScheme isEqual:[NSNull null]]) iosParameters.customScheme = customScheme;
    if (![fallbackURL isEqual:[NSNull null]]) iosParameters.fallbackURL = [NSURL URLWithString:fallbackURL];
    if (![iPadBundleID isEqual:[NSNull null]]) iosParameters.iPadBundleID = iPadBundleID;
    if (![iPadFallbackURL isEqual:[NSNull null]]) iosParameters.iPadFallbackURL = [NSURL URLWithString:iPadFallbackURL];
    if (![minimumAppVersion isEqual:[NSNull null]]) iosParameters.minimumAppVersion = minimumAppVersion;

    components.iOSParameters = iosParameters;
  }

  if (![arguments[@"itunesConnectAnalyticsParameters"] isEqual:[NSNull null]]) {
    NSDictionary *params = arguments[@"itunesConnectAnalyticsParameters"];

    FIRDynamicLinkItunesConnectAnalyticsParameters *itunesConnectAnalyticsParameters = [FIRDynamicLinkItunesConnectAnalyticsParameters parameters];

    NSString *affiliateToken = params[@"affiliateToken"];
    NSString *campaignToken = params[@"campaignToken"];
    NSString *providerToken = params[@"providerToken"];

    if (![affiliateToken isEqual:[NSNull null]]) itunesConnectAnalyticsParameters.affiliateToken = affiliateToken;
    if (![campaignToken isEqual:[NSNull null]]) itunesConnectAnalyticsParameters.campaignToken = campaignToken;
    if (![providerToken isEqual:[NSNull null]]) itunesConnectAnalyticsParameters.providerToken = providerToken;

    components.iTunesConnectParameters = itunesConnectAnalyticsParameters;
  }

  if (![arguments[@"navigationInfoParameters"] isEqual:[NSNull null]]) {
    NSDictionary *params = arguments[@"navigationInfoParameters"];

    FIRDynamicLinkNavigationInfoParameters *navigationInfoParameters =
        [FIRDynamicLinkNavigationInfoParameters parameters];

    NSNumber *forcedRedirectEnabled = params[@"forcedRedirectEnabled"];
    if (![forcedRedirectEnabled isEqual:[NSNull null]]) navigationInfoParameters.forcedRedirectEnabled = [forcedRedirectEnabled boolValue];

    components.navigationInfoParameters = navigationInfoParameters;
  }

  if (![arguments[@"socialMetaTagParameters"] isEqual:[NSNull null]]) {
    NSDictionary *params = arguments[@"socialMetaTagParameters"];

    FIRDynamicLinkSocialMetaTagParameters *socialMetaTagParameters =
        [FIRDynamicLinkSocialMetaTagParameters parameters];

    NSString *descriptionText = params[@"description"];
    NSString *imageURL = params[@"imageUrl"];
    NSString *title = params[@"title"];

    if (![descriptionText isEqual:[NSNull null]]) socialMetaTagParameters.descriptionText = descriptionText;
    if (![imageURL isEqual:[NSNull null]]) socialMetaTagParameters.imageURL = [NSURL URLWithString:imageURL];
    if (![title isEqual:[NSNull null]]) socialMetaTagParameters.title = title;

    components.socialMetaTagParameters = socialMetaTagParameters;
  }

  return components.url;
}

@end
