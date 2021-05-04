#import "PlacePlugin.h"
#if __has_include(<place_plugin/place_plugin-Swift.h>)
#import <place_plugin/place_plugin-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "place_plugin-Swift.h"
#endif

@implementation PlacePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftPlacePlugin registerWithRegistrar:registrar];
}
@end
