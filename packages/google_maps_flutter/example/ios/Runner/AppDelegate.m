#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
#import "GoogleMaps/GoogleMaps.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication*)application
    didFinishLaunchingWithOptions:(NSDictionary*)launchOptions {
  // Provide the GoogleMaps API key.
  NSString* mapsApiKey = [[NSProcessInfo processInfo] environment][@"MAPS_API_KEY"];
  [GMSServices provideAPIKey:mapsApiKey];

  // Register Flutter plugins.
  [GeneratedPluginRegistrant registerWithRegistry:self];

  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
