#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
// Add the GoogleMaps import.
#import "GoogleMaps/GoogleMaps.h"
@implementation AppDelegate
- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  // Add the following line with your API key.
  [GMSServices provideAPIKey:@"AIzaSyCJiC5kG5DClDjyQApnXBazmeu8recwaD0"];
  [GeneratedPluginRegistrant registerWithRegistry:self];
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}
@end
