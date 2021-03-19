Pod::Spec.new do |spec|
  spec.name                 = "IDEAApplet"
  spec.version              = "1.0.0"
  spec.summary              = "IDEAApplet"
  spec.description          = "IDEAApplet"
  spec.homepage             = "https://github.com/miniwing"
  spec.license              = "MIT"
  spec.author               = { "Harry" => "miniwing.hz@gmail.com" }
  spec.platform             = :ios, "10.0"
  
#  spec.requires_arc = true
#  spec.non_arc_files  = ['Classes/Frameworks/PGSQLKit/*.{h,m}']

  spec.frameworks           = ['Foundation', 'UIKit', 'CoreGraphics', 'QuartzCore', 'CoreFoundation']

  spec.source               = { :path => "." }
  
  spec.xcconfig             = {
    'HEADER_SEARCH_PATHS'   => ' "${PODS_TARGET_SRCROOT}/" "${PODS_TARGET_SRCROOT}/../" "${PODS_TARGET_SRCROOT}/applet-webcore/vendor" "${PODS_ROOT}/Headers/Public/AFNetworking/" ',
#    'GCC_PREPROCESSOR_DEFINITIONS'  => 'HAVE_AV_CONFIG_H=1 USE_VAR_BIT_DEPTH=1 USE_PRED=1'
  }
  
#  spec.pod_target_xcconfig  = {
#    'GCC_PREPROCESSOR_DEFINITIONS'  => 'IDEAKIT_AFNETWORKING_OPERATIONS=1'
#  }

#  spec.dependency 'FoundationExtension'
#  spec.dependency 'UIKitExtension'
  
#  spec.dependency 'AFNetworking'
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

  spec.subspec 'Framework' do |sub|
    sub.ios.deployment_target   = '10.0'
        
    sub.ios.public_header_files = 'applet-framework/*.{h,hpp}',
                                  'applet-framework/**/*.{h,hpp}'

    sub.ios.source_files        = 'applet-framework/*.{h,m,c}',
                                  'applet-framework/**/*.{h,m,c}'
  end

  spec.subspec 'Webcore' do |sub|
    sub.ios.deployment_target   = '10.0'
    
    sub.ios.public_header_files = 'applet-webcore/*.{h}',
                                  'applet-webcore/**/*.{h,hpp}'

    sub.ios.source_files        = 'applet-webcore/*.{h,m,c}',
                                  'applet-webcore/modules/**/*.{h,m,c}',
                                  'applet-webcore/extension/**/*.{h,m,c}',
                                  'applet-webcore/vendor/gumbo-parser/**/*.{h, m,c}',
                                  'applet-webcore/vendor/katana-parser/**/*.{h, m,c}',
                                  'applet-webcore/vendor/AFNetworking/**/*.{h,m,c}'
  end
  
#  spec.subspec 'Services' do |sub|
#    sub.ios.deployment_target   = '10.0'
#
#    sub.ios.public_header_files = 'applet-debugger/**/*.{h,hpp}'
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

#import <objc/runtime.h>

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

/******************************************************************************************************/

#define LOG_BUG_SIZE                               (1024 * 1)

enum
{
   LogLevelFatal = 0,
   LogLevelError,
   LogLevelWarn,
   LogLevelInfo,
   LogLevelDebug
   
};

#ifdef __OBJC__

NS_INLINE const char* __LogLevelToString(int _eLevel)
{
   switch (_eLevel)
   {
      case LogLevelFatal:
         return ("Fatal");
      case LogLevelError:
         return ("Error");
      case LogLevelWarn:
         return (" Warn");
      case LogLevelInfo:
         return (" Info");
      case LogLevelDebug:
         return ("Debug");
      default:
         break;
         
   } /* End switch (); */
   
   return ("Unknown");
}

NS_INLINE void __Log(int _eLevel, const char *_cpszMsg)
{
   printf("%s :: %s\\n", __LogLevelToString(_eLevel), _cpszMsg);
   
   return;
}

NS_INLINE void LoggerFatal(NSString *aFormat, ...)
{
   va_list      args;
   NSString    *szMSG   = nil;
   
   va_start (args, aFormat);
   szMSG = [[NSString alloc] initWithFormat:aFormat  arguments:args];
   va_end (args);
   
   __Log(LogLevelFatal, [szMSG UTF8String]);
   
   __RELEASE(szMSG);
   
   return;
}

NS_INLINE void LoggerError(NSString *aFormat, ...)
{
   va_list      args;
   NSString    *szMSG   = nil;
   
   va_start (args, aFormat);
   szMSG = [[NSString alloc] initWithFormat:aFormat  arguments:args];
   va_end (args);
   
   __Log(LogLevelError, [szMSG UTF8String]);
   
   __RELEASE(szMSG);
   
   return;
}

NS_INLINE void LoggerWarn(NSString *aFormat, ...)
{
   va_list      args;
   NSString    *szMSG   = nil;
   
   va_start (args, aFormat);
   szMSG = [[NSString alloc] initWithFormat:aFormat  arguments:args];
   va_end (args);
   
   __Log(LogLevelWarn, [szMSG UTF8String]);
   
   __RELEASE(szMSG);
   
   return;
}

NS_INLINE void LoggerInfo(NSString *aFormat, ...)
{
   va_list      args;
   NSString    *szMSG   = nil;
   
   va_start (args, aFormat);
   szMSG = [[NSString alloc] initWithFormat:aFormat  arguments:args];
   va_end (args);
   
   __Log(LogLevelInfo, [szMSG UTF8String]);
   
   __RELEASE(szMSG);
   
   return;
}

NS_INLINE void LoggerDebug(NSString *aFormat, ...)
{
   va_list      args;
   NSString    *szMSG   = nil;
   
   va_start (args, aFormat);
   szMSG = [[NSString alloc] initWithFormat:aFormat  arguments:args];
   va_end (args);
   
   __Log(LogLevelDebug, [szMSG UTF8String]);
   
   __RELEASE(szMSG);
   
   return;
}
#else

__BEGIN_DECLS

static __inline void LoggerFatal(char *_Format, ...)
{
   va_list      args;
   static char s_MSG[LOG_BUG_SIZE]  = {0};
   
   bzero(s_MSG, sizeof(s_MSG));
   
   va_start (args, _Format);
   vsnprintf(s_MSG, sizeof(s_MSG), _Format, args);
   va_end (args);
   
   printf("%s :: %s\\n", "Fatal", s_MSG);
   
   return;
}

static __inline void LoggerError(char *_Format, ...)
{
   va_list      args;
   static char s_MSG[LOG_BUG_SIZE]  = {0};
   
   bzero(s_MSG, sizeof(s_MSG));
   
   va_start (args, _Format);
   vsnprintf(s_MSG, sizeof(s_MSG), _Format, args);
   va_end (args);
   
   printf("%s :: %s\\n", "Error", s_MSG);
   
   return;
}

static __inline void LoggerWarn(char *_Format, ...)
{
   va_list      args;
   static char s_MSG[LOG_BUG_SIZE]  = {0};
   
   bzero(s_MSG, sizeof(s_MSG));
   
   va_start (args, _Format);
   vsnprintf(s_MSG, sizeof(s_MSG), _Format, args);
   va_end (args);
   
   printf("%s :: %s\\n", "Warning", s_MSG);
   
   return;
}

static __inline void LoggerInfo(char *_Format, ...)
{
   va_list      args;
   static char s_MSG[LOG_BUG_SIZE]  = {0};
   
   bzero(s_MSG, sizeof(s_MSG));
   
   va_start (args, _Format);
   vsnprintf(s_MSG, sizeof(s_MSG), _Format, args);
   va_end (args);
   
   printf("%s :: %s\\n", "Info", s_MSG);
   
   return;
}

static __inline void LoggerDebug(char *_Format, ...)
{
   va_list      args;
   static char s_MSG[LOG_BUG_SIZE]  = {0};
   
   bzero(s_MSG, sizeof(s_MSG));
   
   va_start (args, _Format);
   vsnprintf(s_MSG, sizeof(s_MSG), _Format, args);
   va_end (args);
   
   printf("%s :: %s\\n", "Debug", s_MSG);
   
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

/******************************************************************************************************/

#if (defined(DEBUG) && (1 == DEBUG))
#  define LogDebug(x)                              LoggerDebug x
#  define LogFunc(x)                               LoggerDebug x
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
