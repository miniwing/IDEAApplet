//
//     ____    _                        __     _      _____
//    / ___\  /_\     /\/\    /\ /\    /__\   /_\     \_   \
//    \ \    //_\\   /    \  / / \ \  / \//  //_\\     / /\/
//  /\_\ \  /  _  \ / /\/\ \ \ \_/ / / _  \ /  _  \ /\/ /_
//  \____/  \_/ \_/ \/    \/  \___/  \/ \_/ \_/ \_/ \____/
//
//   Copyright Samurai development team and other contributors
//
//   http://www.samurai-framework.com
//
//   Permission is hereby granted, free of charge, to any person obtaining a copy
//   of this software and associated documentation files (the "Software"), to deal
//   in the Software without restriction, including without limitation the rights
//   to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//   copies of the Software, and to permit persons to whom the Software is
//   furnished to do so, subject to the following conditions:
//
//   The above copyright notice and this permission notice shall be included in
//   all copies or substantial portions of the Software.
//
//   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//   IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//   FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//   AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//   LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//   OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//   THE SOFTWARE.
//

#import "IDEAApplet.h"
#import "IDEAAppletClassLoader.h"

#import "IDEAAppletDebug.h"

#import "__pragma_push.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation IDEAApplet

@def_singleton    ( IDEAApplet );

#if __IDEA_APPLET_AUTO_LOAD__


+ (void)load {

//   dispatch_async_background_serial(^() {
//
//      [IDEAApplet sharedInstance];
//   });

//   LogDebug((@"+[IDEAApplet load] : OnceToken : %p", &stOnceToken));
//   LogDebug((@"-[CallStack : %s] : %@", __PRETTY_FUNCTION__, [[IDEAAppletDebugger sharedInstance] callstack:10]));
   static dispatch_once_t   stOnceToken;

   dispatch_once(&stOnceToken, ^{

//      __init();

      [IDEAApplet sharedInstance];
   });
   
   return;
}

//static dispatch_once_t onceToken;
//
//NS_INLINE void __init() {
//
//   @synchronized (IDEAAppletServiceLoader.class) {
//
//      dispatch_once(&onceToken, ^(void) {
//
//         _dyld_register_func_for_add_image(__dyld_callback);
//      });
//
//   } /* synchronized */
//
//   return;
//}
//
//NS_INLINE void __dyld_callback(const struct mach_header *_mach_header, intptr_t _vmaddr_slide) {
//
//   char           *psz_section_name = __SERVICE_STARTUP_KEY;
//   unsigned long   ul_size          = 0;
//#ifndef __LP64__
//   uintptr_t      *pst_memory       = (uintptr_t*)getsectiondata(_mach_header, __SERVICE_STARTUP_SECTION_NAME, psz_section_name, &ul_size);
//#else
//   const struct mach_header_64   *mhp64 = (const struct mach_header_64 *)_mach_header;
//   uintptr_t      *pst_memory       = (uintptr_t*)getsectiondata(mhp64, __SERVICE_STARTUP_SECTION_NAME, psz_section_name, &ul_size);
//#endif
//
//   unsigned long   ul_counter = ul_size / sizeof(St_ServicStartUp);
//   unsigned long   ul_offset  = sizeof(St_ServicStartUp) / sizeof(void *);
//
//   for (int H = 0; H < ul_counter; ++H) {
//
//      St_ServicStartUp   st_start_up   = *(St_ServicStartUp*)(pst_memory + ul_offset * (H));
//
//      if (st_start_up.key) {
//
//         st_start_up.function();
//
//      } /* End if () */
//
//   } /* End if () */
//
//   return;
//}

#endif /* __IDEA_APPLET_AUTO_LOAD__ */

- (id)init {
   
   int                            nErr                                     = EFAULT;
   
   __TRY;
   
   self = [super init];
   
   if (self) {
      
#if TARGET_INTERFACE_BUILDER
#else
      [self install];
#endif /* TARGET_INTERFACE_BUILDER */
      
   } /* End if () */
   
   __CATCH(nErr);
   
   return self;
}

- (void)dealloc {
      
   [self uninstall];
   
   __SUPER_DEALLOC;
   
   return;
}

- (void)install {
   
   int                            nErr                                     = EFAULT;
   
   struct utsname                 stSystemInfo                             = {0};
   
   const char                    * options[]                               = {
                                                                              "[Off]",
                                                                              "[On]"
                                                                             };

   __TRY;
   
   uname(&stSystemInfo);

#if __Debug__
   fprintf(stderr, "  +----------------------------------------------------------------------------+  \n");
   fprintf(stderr, "                                                                                  \n");
   fprintf(stderr, "       ____    _                        __     _      _____                       \n");
   fprintf(stderr, "      / ___\  /_\     /\/\    /\ /\    /__\   /_\     \_   \                      \n");
   fprintf(stderr, "      \ \    //_\\   /    \  / / \ \  / \//  //_\\     / /\/                      \n");
   fprintf(stderr, "    /\_\ \  /  _  \ / /\/\ \ \ \_/ / / _  \ /  _  \ /\/ /_                        \n");
   fprintf(stderr, "    \____/  \_/ \_/ \/    \/  \___/  \/ \_/ \_/ \_/ \____/                        \n");
   fprintf(stderr, "                                                                                  \n");
   fprintf(stderr, "                                                                                  \n");
   fprintf(stderr, "    version: %s\n", __SAMURAI_VERSION__);
   fprintf(stderr, "                                                                                  \n");
   fprintf(stderr, "  - debug:   %s\n", options[__SAMURAI_DEBUG__]);
   fprintf(stderr, "  - logging: %s\n", options[__SAMURAI_LOGGING__]);
   fprintf(stderr, "  - testing: %s\n", options[__SAMURAI_TESTING__]);
   fprintf(stderr, "  - service: %s\n", options[__SAMURAI_SERVICE__]);
   fprintf(stderr, "                                                                                  \n");
   fprintf(stderr, "  - system:  %s\n", stSystemInfo.sysname);
   fprintf(stderr, "  - node:    %s\n", stSystemInfo.nodename);
   fprintf(stderr, "  - release: %s\n", stSystemInfo.release);
   fprintf(stderr, "  - version: %s\n", stSystemInfo.version);
   fprintf(stderr, "  - machine: %s\n", stSystemInfo.machine);
   fprintf(stderr, "                                                                                  \n");
   fprintf(stderr, "  +----------------------------------------------------------------------------+  \n");
//   fprintf(stderr, "  |                                                                            |   \n");
//   fprintf(stderr, "  |  1. Have a bug or a feature request?                                       |   \n");
//   fprintf(stderr, "  |     https://github.com/hackers-painters/samurai-native/issues              |   \n");
//   fprintf(stderr, "  |                                                                            |   \n");
//   fprintf(stderr, "  |  2. Download lastest version?                                              |   \n");
//   fprintf(stderr, "  |     https://github.com/hackers-painters/samurai-native/archive/master.zip  |   \n");
//   fprintf(stderr, "  |                                                                            |   \n");
//   fprintf(stderr, "  +----------------------------------------------------------------------------+   \n");
//   fprintf(stderr, "                                                                                   \n");
//   fprintf(stderr, "                                                                                   \n");
#endif /* __Debug__ */
   
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
   
   [[IDEAAppletServiceLoader sharedInstance] installServices];
   
   [[NSNotificationCenter defaultCenter] addObserver:self
                                            selector:@selector(UIApplicationDidFinishLaunchingNotification)
                                                name:UIApplicationDidFinishLaunchingNotification
                                              object:nil];
   
   [[NSNotificationCenter defaultCenter] addObserver:self
                                            selector:@selector(UIApplicationWillTerminateNotification)
                                                name:UIApplicationWillTerminateNotification
                                              object:nil];
   
#else // #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
   
   [self startup];
   
#endif // #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
   
   __CATCH(nErr);
   
   return;
}

- (void)uninstall {
   
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
   
   [[IDEAAppletServiceLoader sharedInstance] uninstallServices];
   
#endif // #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
   
   return;
}

#pragma mark -

- (void)UIApplicationDidFinishLaunchingNotification {
   
   [self startup];
   
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
   
   dispatch_after_foreground(1.0f, ^{
      [[IDEAAppletDockerManager sharedInstance] installDockers];
   });
   
#endif // #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
   
   return;
}

- (void)UIApplicationWillTerminateNotification {
   
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
   
   [[IDEAAppletDockerManager sharedInstance] uninstallDockers];
   
#endif // #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
   
   return;
}

#pragma mark -

- (void)startup {
   
   [[IDEAAppletClassLoader classLoader] loadClasses:@[
      @"__ClassLoader_Config",
      @"__ClassLoader_Core",
      @"__ClassLoader_Event",
      @"__ClassLoader_Module",
      
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
      @"__ClassLoader_UI",
      @"__ClassLoader_Service"
#endif // #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
      
   ]];
   
#if __SAMURAI_TESTING__
   [[IDEAAppletUnitTest sharedInstance] run];
#endif // #if __SAMURAI_TESTING__
   
   return;
}

+ (BOOL)isAppExtension {
   
   static BOOL             isAppExtension = NO;
   static dispatch_once_t  onceToken;
   
   dispatch_once(&onceToken, ^{
      
      Class stClass  = NSClassFromString(@"UIApplication");
      
      if (!stClass || ![stClass respondsToSelector:@selector(sharedApplication)]) {
         
         isAppExtension = YES;
      }
      
      if ([[[NSBundle mainBundle] bundlePath] hasSuffix:@".appex"]) {
         
         isAppExtension = YES;
      }
   });
   return isAppExtension;
}

+ (UIApplication *)sharedExtensionApplication {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
   return [self isAppExtension] ? nil : [UIApplication performSelector:@selector(sharedApplication)];
#pragma clang diagnostic pop
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#import "__pragma_pop.h"
