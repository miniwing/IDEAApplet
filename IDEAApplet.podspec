Pod::Spec.new do |spec|
  spec.name                 = "IDEAApplet"
  spec.version              = "1.0.1"
  spec.summary              = "IDEAApplet"
  spec.description          = "IDEAApplet"
  spec.homepage             = "https://github.com/miniwing"
  spec.license              = "MIT"
  spec.author               = { "Harry" => "miniwing.hz@gmail.com" }
  spec.platform             = :ios, "10.0"
  
  spec.ios.pod_target_xcconfig     = {
                                        'PRODUCT_BUNDLE_IDENTIFIER' => 'com.idea.IDEAApplet',
                                        'ENABLE_BITCODE'            => 'NO',
                                        'SWIFT_VERSION'             => '5.0',
                                        'EMBEDDED_CONTENT_CONTAINS_SWIFT'       => 'NO',
                                        'ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES' => 'NO',
                                        'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES'
                                      }
  spec.osx.pod_target_xcconfig      = { 'PRODUCT_BUNDLE_IDENTIFIER' => 'com.idea.IDEAApplet' }
  spec.watchos.pod_target_xcconfig  = { 'PRODUCT_BUNDLE_IDENTIFIER' => 'com.idea.IDEAApplet-watchOS' }
  spec.tvos.pod_target_xcconfig     = { 'PRODUCT_BUNDLE_IDENTIFIER' => 'com.idea.IDEAApplet' }

#  spec.requires_arc = true
#  spec.non_arc_files  = ['Classes/Frameworks/PGSQLKit/*.{h,m}']

  spec.frameworks           = ['Foundation', 'UIKit', 'CoreGraphics', 'QuartzCore', 'CoreFoundation']

#  spec.source               = { :git => "https://github.com/miniwing/Idea.Applets.git" }
  spec.source               = { :path => "." }

  spec.xcconfig             = {
    'HEADER_SEARCH_PATHS'   => ' "${PODS_TARGET_SRCROOT}/" "${PODS_TARGET_SRCROOT}/../" "${PODS_TARGET_SRCROOT}/"/** "${PODS_ROOT}/Headers/Public/AFNetworking/" ',
#    'GCC_PREPROCESSOR_DEFINITIONS'  => 'HAVE_AV_CONFIG_H=1 USE_VAR_BIT_DEPTH=1 USE_PRED=1'
  }
  
  spec.pod_target_xcconfig  = {
    'GCC_PREPROCESSOR_DEFINITIONS'  => ' $(inherited) MODULE=\"IDEAApplet\" __UIWebView__=0 '
  }

#  spec.dependency 'FoundationExtension'
#  spec.dependency 'UIKitExtension'
  
  spec.dependency 'AFNetworking'
#  spec.dependency 'AFNetworking/Serialization'
#  spec.dependency 'AFNetworking/Security'
#  spec.dependency 'AFNetworking/Reachability'
#  spec.dependency 'AFNetworking/NSURLSession'
#  spec.dependency 'YYKit'
#  spec.dependency 'OpenSSL-Universal'
#  spec.dependency 'MIHCrypto'
#  spec.dependency 'RegexKitLite'

#  spec.public_header_files      = 'IDEAKit/**/*.{h}',
#                                  'IDEAExtension/**/*.{h}'
#  spec.source_files             = 'IDEAKit/**/*.{h,m,mm,c,cpp}',
#                                  'IDEAExtension/**/*.{h,m,mm,c,cpp}'
                              
#  spec.vendored_libraries       = 'libXG-SDK.a'
#  spec.vendored_frameworks      = 'libXG-SDK.a'

  spec.subspec 'applet-framework' do |framework|
    framework.ios.deployment_target   = '10.0'
        
    framework.ios.public_header_files = 'applet-framework/*.{h,hpp}'
    framework.ios.source_files        = 'applet-framework/*.{h,m,c}'

    framework.subspec 'samurai-config' do |config|
      config.ios.public_header_files  = 'applet-framework/samurai-config/*.{h,hpp}'
      config.ios.source_files         = 'applet-framework/samurai-config/*.{h,m,c}'
    end # 'samurai-config'

    framework.subspec 'samurai-core' do |core|
      core.ios.public_header_files    = 'applet-framework/samurai-core/*.{h,hpp}'
      core.ios.source_files           = 'applet-framework/samurai-core/*.{h,m,c}'

      core.subspec 'extension' do |extension|
        extension.ios.public_header_files = 'applet-framework/samurai-core/extension/*.{h,hpp}'
        extension.ios.source_files        = 'applet-framework/samurai-core/extension/*.{h,m,c}'
      end # 'extension'

      core.subspec 'modules' do |modules|
        modules.ios.public_header_files = 'applet-framework/samurai-core/modules/*.{h,hpp}'
        modules.ios.source_files        = 'applet-framework/samurai-core/modules/*.{h,m,c}'
      end # 'modules'

    end # 'samurai-core'

    framework.subspec 'samurai-event' do |event|
      event.ios.public_header_files = 'applet-framework/samurai-event/*.{h,hpp}'
      event.ios.source_files        = 'applet-framework/samurai-event/*.{h,m,c}'

      event.subspec 'modules' do |modules|
        modules.ios.public_header_files = 'applet-framework/samurai-event/modules/*.{h,hpp}'
        modules.ios.source_files        = 'applet-framework/samurai-event/modules/*.{h,m,c}'
      end # 'modules'

    end # 'samurai-event'

    framework.subspec 'samurai-model' do |model|
      model.ios.public_header_files = 'applet-framework/samurai-model/*.{h,hpp}'
      model.ios.source_files        = 'applet-framework/samurai-model/*.{h,m,c}'

      model.subspec 'extension' do |extension|
        extension.ios.public_header_files = 'applet-framework/samurai-model/extension/*.{h,hpp}'
        extension.ios.source_files        = 'applet-framework/samurai-model/extension/*.{h,m,c}'
      end # 'extension'

      model.subspec 'modules' do |modules|
        modules.ios.public_header_files = 'applet-framework/samurai-model/modules/*.{h,hpp}'
        modules.ios.source_files        = 'applet-framework/samurai-model/modules/*.{h,m,c}'
      end # 'modules'

    end # 'samurai-model'

    framework.subspec 'samurai-service' do |service|
      service.ios.public_header_files = 'applet-framework/samurai-service/*.{h,hpp}'
      service.ios.source_files        = 'applet-framework/samurai-service/*.{h,m,c}'

      service.subspec 'modules' do |modules|
        modules.ios.public_header_files = 'applet-framework/samurai-service/modules/*.{h,hpp}'
        modules.ios.source_files        = 'applet-framework/samurai-service/modules/*.{h,m,c}'

        modules.subspec 'docker' do |docker|
          docker.ios.public_header_files = 'applet-framework/samurai-service/modules/docker/*.{h,hpp}'
          docker.ios.source_files        = 'applet-framework/samurai-service/modules/docker/*.{h,m,c}'
        end # 'docker'

        modules.subspec 'service' do |service|
          service.ios.public_header_files = 'applet-framework/samurai-service/modules/service/*.{h,hpp}'
          service.ios.source_files        = 'applet-framework/samurai-service/modules/service/*.{h,m,c}'
        end # 'service'

      end # 'modules'

    end # 'samurai-service'

    framework.subspec 'samurai-view' do |view|
      view.ios.public_header_files  = 'applet-framework/samurai-view/*.{h,hpp}'
      view.ios.source_files         = 'applet-framework/samurai-view/*.{h,m,c}'

      view.subspec 'extension' do |extension|
        extension.ios.public_header_files = 'applet-framework/samurai-view/extension/*.{h,hpp}'
        extension.ios.source_files        = 'applet-framework/samurai-view/extension/*.{h,m,c}'
      end # 'extension'

      view.subspec 'modules' do |modules|
        modules.ios.public_header_files = 'applet-framework/samurai-view/modules/*.{h,hpp}'
        modules.ios.source_files        = 'applet-framework/samurai-view/modules/*.{h,m,c}'

        modules.subspec 'view-component' do |component|
          component.ios.public_header_files = 'applet-framework/samurai-view/modules/view-component/*.{h,hpp}'
          component.ios.source_files        = 'applet-framework/samurai-view/modules/view-component/*.{h,m,c}'
        end # ''view-component''

        modules.subspec 'view-controller' do |controller|
          controller.ios.public_header_files  = 'applet-framework/samurai-view/modules/view-controller/*.{h,hpp}'
          controller.ios.source_files         = 'applet-framework/samurai-view/modules/view-controller/*.{h,m,c}'
        end # ''view-controller''

        modules.subspec 'view-core' do |core|
          core.ios.public_header_files  = 'applet-framework/samurai-view/modules/view-core/*.{h,hpp}'
          core.ios.source_files         = 'applet-framework/samurai-view/modules/view-core/*.{h,m,c}'
        end # ''view-core''

        modules.subspec 'view-event' do |event|
          event.ios.public_header_files = 'applet-framework/samurai-view/modules/view-event/*.{h,hpp}'
          event.ios.source_files        = 'applet-framework/samurai-view/modules/view-event/*.{h,m,c}'
        end # ''view-core''

        modules.subspec 'view-utility' do |utility|
          utility.ios.public_header_files = 'applet-framework/samurai-view/modules/view-utility/*.{h,hpp}'
          utility.ios.source_files        = 'applet-framework/samurai-view/modules/view-utility/*.{h,m,c}'
        end # ''view-core''

      end # 'modules'

    end # 'samurai-view'

    framework.subspec 'vendor' do |vendor|
      vendor.subspec 'fishhook' do |fishhook|
        fishhook.ios.private_header_files = 'applet-framework/vendor/fishhook/*.{h,hpp}'
        fishhook.ios.source_files         = 'applet-framework/vendor/fishhook/*.{h,m,c}'
      end # 'fishhook'
    end # 'vendor'

  end

  spec.subspec 'applet-webcore' do |webcore|
    webcore.ios.deployment_target   = '10.0'
    
    webcore.ios.private_header_files = 'applet-webcore/*.{h}'
    webcore.ios.source_files        = 'applet-webcore/*.{h,m,c}'

    webcore.subspec 'resource' do |resource|
      resource.resource_bundle      = { 'IDEAApplet'  => [ 'applet-webcore/resource/*.{css,html}' ] }
    end

    webcore.subspec 'extension' do |extension|
      extension.ios.private_header_files  = 'applet-webcore/extension/*.{h}'
      extension.ios.source_files          = 'applet-webcore/extension/*.{h,m,c}'
    end

    webcore.subspec 'modules' do |modules|
      
      modules.subspec 'css-media' do |media|
        media.ios.private_header_files  = 'applet-webcore/modules/css-media/*.{h}'
        media.ios.source_files          = 'applet-webcore/modules/css-media/*.{h,m,c}'
      end

      modules.subspec 'css-parser' do |parser|
        parser.ios.private_header_files= 'applet-webcore/modules/css-parser/*.{h}'
        parser.ios.source_files         = 'applet-webcore/modules/css-parser/*.{h,m,c}'
      end

      modules.subspec 'css-resolver' do |resolver|
        resolver.ios.private_header_files= 'applet-webcore/modules/css-resolver/*.{h}'
        resolver.ios.source_files         = 'applet-webcore/modules/css-resolver/*.{h,m,c}'
      end

      modules.subspec 'css-stylesheet' do |stylesheet|
        stylesheet.ios.private_header_files = 'applet-webcore/modules/css-stylesheet/*.{h}'
        stylesheet.ios.source_files         = 'applet-webcore/modules/css-stylesheet/*.{h,m,c}'
      end

      modules.subspec 'css-value' do |value|
        value.ios.private_header_files  = 'applet-webcore/modules/css-value/*.{h}'
        value.ios.source_files          = 'applet-webcore/modules/css-value/*.{h,m,c}'
      end

      modules.subspec 'html-component' do |component|
        component.ios.private_header_files = 'applet-webcore/modules/html-component/*.{h}'
        component.ios.source_files          = 'applet-webcore/modules/html-component/*.{h,m,c}'
      end

      modules.subspec 'html-document' do |document|
        document.ios.private_header_files = 'applet-webcore/modules/html-document/*.{h}'
        document.ios.source_files         = 'applet-webcore/modules/html-document/*.{h,m,c}'
      end

      modules.subspec 'html-document-workflow' do |workflow|
        workflow.ios.private_header_files = 'applet-webcore/modules/html-document-workflow/*.{h}'
        workflow.ios.source_files         = 'applet-webcore/modules/html-document-workflow/*.{h,m,c}'
      end

      modules.subspec 'html-dom' do |dom|
        dom.ios.private_header_files  = 'applet-webcore/modules/html-dom/*.{h}'
        dom.ios.source_files          = 'applet-webcore/modules/html-dom/*.{h,m,c}'
      end

      modules.subspec 'html-element' do |element|
        element.ios.private_header_files  = 'applet-webcore/modules/html-element/*.{h}'
        element.ios.source_files          = 'applet-webcore/modules/html-element/*.{h,m,c}'
      end

      modules.subspec 'html-layout' do |layout|
        layout.ios.private_header_files = 'applet-webcore/modules/html-layout/*.{h}'
        layout.ios.source_files         = 'applet-webcore/modules/html-layout/*.{h,m,c}'
      end

      modules.subspec 'html-render' do |render|
        render.ios.private_header_files = 'applet-webcore/modules/html-render/*.{h}'
        render.ios.source_files         = 'applet-webcore/modules/html-render/*.{h,m,c}'
      end

      modules.subspec 'html-render-query' do |query|
        query.ios.private_header_files  = 'applet-webcore/modules/html-render-query/*.{h}'
        query.ios.source_files          = 'applet-webcore/modules/html-render-query/*.{h,m,c}'
      end

      modules.subspec 'html-render-store' do |store|
        store.ios.private_header_files  = 'applet-webcore/modules/html-render-store/*.{h}'
        store.ios.source_files          = 'applet-webcore/modules/html-render-store/*.{h,m,c}'
      end

      modules.subspec 'html-render-style' do |style|
        style.ios.private_header_files  = 'applet-webcore/modules/html-render-style/*.{h}'
        style.ios.source_files          = 'applet-webcore/modules/html-render-style/*.{h,m,c}'
      end

      modules.subspec 'html-render-workflow' do |render_workflow|
        render_workflow.ios.private_header_files  = 'applet-webcore/modules/html-render-workflow/*.{h}'
        render_workflow.ios.source_files          = 'applet-webcore/modules/html-render-workflow/*.{h,m,c}'
      end

      modules.subspec 'html-useragent' do |useragent|
        useragent.ios.private_header_files  = 'applet-webcore/modules/html-useragent/*.{h}'
        useragent.ios.source_files          = 'applet-webcore/modules/html-useragent/*.{h,m,c}'
      end

    end

    webcore.subspec 'vendor' do |vendor|

#      vendor.subspec 'AFNetworking' do |networking|
#        networking.ios.private_header_files = 'applet-webcore/vendor/AFNetworking/*.{h}'
#        networking.ios.source_files         = 'applet-webcore/vendor/AFNetworking/*.{h,m,c}'
#      end

      vendor.subspec 'gumbo-parser' do |gumbo|
        gumbo.ios.private_header_files= 'applet-webcore/vendor/gumbo-parser/*.{h}'
        gumbo.ios.source_files        = 'applet-webcore/vendor/gumbo-parser/*.{h,m,c}'
      end

      vendor.subspec 'katana-parser' do |katana|
        katana.ios.private_header_files = 'applet-webcore/vendor/katana-parser/*.{h}'
        katana.ios.source_files         = 'applet-webcore/vendor/katana-parser/*.{h,m,c}'
      end

    end

  end
  
#  spec.subspec 'Services' do |sub|
#    sub.ios.deployment_target   = '10.0'
#
#    sub.ios.private_header_files = 'applet-debugger/**/*.{h,hpp}'
#
#    sub.ios.source_files        = 'applet-debugger/**/*.{h,m,c}'
#
##    sub.dependency 'IDEAApplet'
#  end

  pch_app_kit = <<-EOS
#ifdef DEBUG
#  pragma clang diagnostic ignored                 "-Wgnu"
#  pragma clang diagnostic ignored                 "-Wcomma"
#  pragma clang diagnostic ignored                 "-Wformat"
#  pragma clang diagnostic ignored                 "-Wswitch"
#  pragma clang diagnostic ignored                 "-Wvarargs"
#  pragma clang diagnostic ignored                 "-Wnonnull"
#  pragma clang diagnostic ignored                 "-Wpointer-sign"
#  pragma clang diagnostic ignored                 "-Wdangling-else"
#  pragma clang diagnostic ignored                 "-Wunused-result"
#  pragma clang diagnostic ignored                 "-Wuninitialized"
#  pragma clang diagnostic ignored                 "-Wdocumentation"
#  pragma clang diagnostic ignored                 "-Wpch-date-time"
#  pragma clang diagnostic ignored                 "-Wenum-conversion"
#  pragma clang diagnostic ignored                 "-Wunused-variable"
#  pragma clang diagnostic ignored                 "-Wunused-function"
#  pragma clang diagnostic ignored                 "-Wmissing-noescape"
#  pragma clang diagnostic ignored                 "-Wwritable-strings"
#  pragma clang diagnostic ignored                 "-Wunreachable-code"
#  pragma clang diagnostic ignored                 "-Wshorten-64-to-32"
#  pragma clang diagnostic ignored                 "-Wwritable-strings"
#  pragma clang diagnostic ignored                 "-Wstrict-prototypes"
#  pragma clang diagnostic ignored                 "-Wdocumentation-html"
#  pragma clang diagnostic ignored                 "-Wobjc-method-access"
#  pragma clang diagnostic ignored                 "-Wundeclared-selector"
#  pragma clang diagnostic ignored                 "-Wimplicit-retain-self"
#  pragma clang diagnostic ignored                 "-Wunguarded-availability"
#  pragma clang diagnostic ignored                 "-Wunknown-warning-option"
#  pragma clang diagnostic ignored                 "-Wlogical-op-parentheses"
#  pragma clang diagnostic ignored                 "-Wlogical-not-parentheses"
#  pragma clang diagnostic ignored                 "-Wdeprecated-declarations"
#  pragma clang diagnostic ignored                 "-Wnullability-completeness"
#  pragma clang diagnostic ignored                 "-Wobjc-missing-super-calls"
#  pragma clang diagnostic ignored                 "-Wnonportable-include-path"
#  pragma clang diagnostic ignored                 "-Wconditional-uninitialized"
#  pragma clang diagnostic ignored                 "-Wincompatible-pointer-types"
#  pragma clang diagnostic ignored                 "-Wdeprecated-implementations"
#  pragma clang diagnostic ignored                 "-Wmismatched-parameter-types"
#  pragma clang diagnostic ignored                 "-Wobjc-redundant-literal-use"
#  pragma clang diagnostic ignored                 "-Wblock-capture-autoreleasing"
#  pragma clang diagnostic ignored                 "-Wtautological-pointer-compare"
#  pragma clang diagnostic ignored                 "-Wimplicit-function-declaration"
#  pragma clang diagnostic ignored                 "-Wquoted-include-in-framework-header"
#  pragma clang diagnostic ignored                 "-Wnullability-completeness-on-arrays"
#endif /* DEBUG */

#import <Availability.h>

#ifndef __IPHONE_10_0
#  warning "This project uses features only available in iOS SDK 10.0 and later."
#endif

#import <objc/message.h>
#import <objc/runtime.h>

#ifdef __OBJC__

#  import <UIKit/UIKit.h>
#  import <Foundation/Foundation.h>
#  import <QuartzCore/QuartzCore.h>
#  import <QuartzCore/CAAnimation.h>
#  import <MessageUI/MessageUI.h>

#endif /* __OBJC__ */

/******************************************************************************************************/

#ifdef __OBJC__

#  if __has_include(<AFNetworking/AFNetworking.h>)
#     define AF_NETWORKING                                                 (1)
#     import <AFNetworking/AFNetworking.h>
#     import <AFNetworking/AFNetworkActivityIndicatorManager.h>
#  elif __has_include("AFNetworking/AFNetworking.h")
#     define AF_NETWORKING                                                 (1)
#     import "AFNetworking/AFNetworking.h"
#     import "AFNetworking/AFNetworkActivityIndicatorManager.h"
#  elif __has_include("AFNetworking.h")
#     define AF_NETWORKING                                                 (1)
#     import "AFNetworking.h"
#     import "AFNetworkActivityIndicatorManager.h"
#  else
#     define AF_NETWORKING                                                 (0)
#  endif

#endif /* __OBJC__ */

/******************************************************************************************************/

#if __has_feature(objc_arc)
#  define __AUTORELEASE(x)                         (x);
#  define __RELEASE(x)                             (x) = nil;
#  define __RETAIN(x)                              (x)
#  define __SUPER_DEALLOC                          objc_removeAssociatedObjects(self);
#  define __dispatch_release(x)                    (x) = nil;
#else
#  define __RETAIN(x)                              [(x) retain];
#  define __AUTORELEASE(x)                         [(x) autorelease];
#  define __RELEASE(x)                             if (nil != (x))                                                                                      {                                                                                                       [(x) release];                                                                                       (x) = nil;                                                                                        }
#  define __SUPER_DEALLOC                          objc_removeAssociatedObjects(self);[super dealloc];
#  define __dispatch_release(x)                    dispatch_release((x))
#endif

#if defined(DEBUG) && (1==DEBUG)
#  define __AUTO__         (1)
#else
#  define __AUTO__         (0)
#endif

/******************************************************************************************************/

#define LOG_BUG_SIZE                               (1024 * 1)

enum {
  
  __LogLevelFatal   = 0,
  __LogLevelError,
  __LogLevelWarn,
  __LogLevelInfo,
  __LogLevelDebug

};

#ifdef __OBJC__

NS_INLINE const char* ____LogLevelToString(int _eLevel) {
  
   switch (_eLevel)
   {
      case __LogLevelFatal:
         return ("Fatal");
      case __LogLevelError:
         return ("Error");
      case __LogLevelWarn:
         return (" Warn");
      case __LogLevelInfo:
         return (" Info");
      case __LogLevelDebug:
         return ("Debug");
      default:
         break;
         
   } /* End switch (); */
   
   return ("Unknown");
}

NS_INLINE void ____Log(int _eLevel, const char *_cpszMsg) {
  
  printf("[%s] %s :: %s\\n", MODULE, ____LogLevelToString(_eLevel), _cpszMsg);
   
   return;
}

NS_INLINE void __LoggerFatal(NSString *aFormat, ...) {
  
   va_list      args;
   NSString    *szMSG   = nil;
   
   va_start (args, aFormat);
   szMSG = [[NSString alloc] initWithFormat:aFormat  arguments:args];
   va_end (args);
   
   ____Log(__LogLevelFatal, [szMSG UTF8String]);
   
   __RELEASE(szMSG);
   
   return;
}

NS_INLINE void __LoggerError(NSString *aFormat, ...) {
  
   va_list      args;
   NSString    *szMSG   = nil;
   
   va_start (args, aFormat);
   szMSG = [[NSString alloc] initWithFormat:aFormat  arguments:args];
   va_end (args);
   
   ____Log(__LogLevelError, [szMSG UTF8String]);
   
   __RELEASE(szMSG);
   
   return;
}

NS_INLINE void __LoggerWarn(NSString *aFormat, ...) {
  
   va_list      args;
   NSString    *szMSG   = nil;
   
   va_start (args, aFormat);
   szMSG = [[NSString alloc] initWithFormat:aFormat  arguments:args];
   va_end (args);
   
   ____Log(__LogLevelWarn, [szMSG UTF8String]);
   
   __RELEASE(szMSG);
   
   return;
}

NS_INLINE void __LoggerInfo(NSString *aFormat, ...) {
  
   va_list      args;
   NSString    *szMSG   = nil;
   
   va_start (args, aFormat);
   szMSG = [[NSString alloc] initWithFormat:aFormat  arguments:args];
   va_end (args);
   
   ____Log(__LogLevelInfo, [szMSG UTF8String]);
   
   __RELEASE(szMSG);
   
   return;
}

NS_INLINE void __LoggerDebug(NSString *aFormat, ...) {
  
   va_list      args;
   NSString    *szMSG   = nil;
   
   va_start (args, aFormat);
   szMSG = [[NSString alloc] initWithFormat:aFormat  arguments:args];
   va_end (args);
   
   ____Log(__LogLevelDebug, [szMSG UTF8String]);
   
   __RELEASE(szMSG);
   
   return;
}

#else

__BEGIN_DECLS

static __inline void __LoggerFatal(char *_Format, ...) {
  
   va_list      args;
   static char s_MSG[LOG_BUG_SIZE]  = {0};
   
   bzero(s_MSG, sizeof(s_MSG));
   
   va_start (args, _Format);
   vsnprintf(s_MSG, sizeof(s_MSG), _Format, args);
   va_end (args);
   
   printf("[%s] %s :: %s\\n", MODULE, "Fatal", s_MSG);
   
   return;
}

static __inline void __LoggerError(char *_Format, ...) {
  
   va_list      args;
   static char s_MSG[LOG_BUG_SIZE]  = {0};
   
   bzero(s_MSG, sizeof(s_MSG));
   
   va_start (args, _Format);
   vsnprintf(s_MSG, sizeof(s_MSG), _Format, args);
   va_end (args);
   
   printf("[%s] %s :: %s\\n", MODULE, "Error", s_MSG);
   
   return;
}

static __inline void __LoggerWarn(char *_Format, ...) {
  
   va_list      args;
   static char s_MSG[LOG_BUG_SIZE]  = {0};
   
   bzero(s_MSG, sizeof(s_MSG));
   
   va_start (args, _Format);
   vsnprintf(s_MSG, sizeof(s_MSG), _Format, args);
   va_end (args);
   
   printf("[%s] %s :: %s\\n", MODULE, "Warning", s_MSG);
   
   return;
}

static __inline void __LoggerInfo(char *_Format, ...) {
  
   va_list      args;
   static char s_MSG[LOG_BUG_SIZE]  = {0};
   
   bzero(s_MSG, sizeof(s_MSG));
   
   va_start (args, _Format);
   vsnprintf(s_MSG, sizeof(s_MSG), _Format, args);
   va_end (args);
   
   printf("[%s] %s :: %s\\n", MODULE, "Info", s_MSG);
   
   return;
}

static __inline void __LoggerDebug(char *_Format, ...) {
  
   va_list      args;
   static char s_MSG[LOG_BUG_SIZE]  = {0};
   
   bzero(s_MSG, sizeof(s_MSG));
   
   va_start (args, _Format);
   vsnprintf(s_MSG, sizeof(s_MSG), _Format, args);
   va_end (args);
   
   printf("[%s] %s :: %s\\n", MODULE, "Debug", s_MSG);
   
   return;
}

__END_DECLS

#endif /* !__OBJC__ */

/******************************************************************************************************/

#define IsInvalid                                  (YES)

#define I_FUNCTION                                 __PRETTY_FUNCTION__

#ifndef __STRING
#  define __STRING(STR)                            (#STR)
#endif /* __STRING */

#ifndef FREE_IF
#  define FREE_IF(p)                               if(p) {free (p); (p)=NULL;}
#endif /* DELETE_IF */

/******************************************************************************************************/

#if (defined(DEBUG) && (1 == DEBUG))
#  define LogDebug(x)                              __LoggerDebug x
#  define LogFunc(x)                               __LoggerDebug x
#else
#  define LogDebug(x)
#  define LogFunc(x)
#endif

#define  __Function_Start()                        LogFunc(((@"%s - Enter!") , I_FUNCTION));


#define  __Function_End(_Return)                                                                                              \\
                                                   {                                                                          \\
                                                      if (noErr == (_Return))                                                 \\
                                                      {                                                                       \\
                                                         LogFunc(((@"%s - Leave with Success!"), I_FUNCTION));                \\
                                                      } /*End if () */                                                        \\
                                                      else                                                                    \\
                                                      {                                                                       \\
                                                         LogFunc(((@"%s - Leave with Error : %d(0x%08x)!"), I_FUNCTION, (int)_Return, (int)_Return));\\
                                                      } /*End else () */                                                      \\
                                                   }

#if (defined(DEBUG) && (1 == DEBUG))
#  define FunctionStart                            __Function_Start
#  define FunctionEnd                              __Function_End
#else
#  define FunctionStart()
#  define FunctionEnd(x)

#endif /* __DebugInfo__ */

#define __TRY                                      FunctionStart();           \\
                                                   do {


#define __CATCH(nErr)                                 nErr = noErr;           \\
                                                   } while (0);               \\
                                                   FunctionEnd(nErr);


#define __LOG_FUNCTION                             LogFunc((@"%s :", __PRETTY_FUNCTION__))


/******************************************************************************************************/

  EOS
  spec.prefix_header_contents = pch_app_kit
      
end
