#import "PerfeqtCameraPlugin.h"
#if __has_include(<perfeqt_camera/perfeqt_camera-Swift.h>)
#import <perfeqt_camera/perfeqt_camera-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "perfeqt_camera-Swift.h"
#endif

@implementation PerfeqtCameraPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftPerfeqtCameraPlugin registerWithRegistrar:registrar];
}
@end
