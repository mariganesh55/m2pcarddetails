#import "M2pcarddetailsPlugin.h"
#if __has_include(<m2pcarddetails/m2pcarddetails-Swift.h>)
#import <m2pcarddetails/m2pcarddetails-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "m2pcarddetails-Swift.h"
#endif

@implementation M2pcarddetailsPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftM2pcarddetailsPlugin registerWithRegistrar:registrar];
}
@end
