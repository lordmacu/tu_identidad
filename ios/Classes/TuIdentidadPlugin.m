#import "TuIdentidadPlugin.h"
#if __has_include(<tu_identidad/tu_identidad-Swift.h>)
#import <tu_identidad/tu_identidad-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "tu_identidad-Swift.h"
#endif

@implementation TuIdentidadPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftTuIdentidadPlugin registerWithRegistrar:registrar];
}
@end
