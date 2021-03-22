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

#import "__pragma_push.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation IDEAApplet

@def_singleton(IDEAApplet)

+ (void)load
{
   [IDEAApplet sharedInstance];
   
   return;
}

- (id)init
{
   int                            nErr                                     = EFAULT;
   
   __TRY;
   
   self = [super init];
   
   if (self)
   {
      [self install];
      
   } /* End if () */
   
   __CATCH(nErr);
   
   return self;
}

- (void)dealloc
{
   [self uninstall];
   
   __SUPER_DEALLOC;
   
   return;
}

- (void)install
{
   int                            nErr                                     = EFAULT;

   struct utsname                 stSystemInfo                             = {0};

   __TRY;
   
   uname(&stSystemInfo);
   
   const char * options[] = {
      "[Off]",
      "[On]"
   };
   
   fprintf(stderr, "                                                                                   \n");
   fprintf(stderr, "     ____    _                        __     _      _____                          \n");
   fprintf(stderr, "    / ___\\  /_\\     /\\/\\    /\\ /\\    /__\\   /_\\     \\_   \\               \n");
   fprintf(stderr, "    \\ \\    //_\\\\   /    \\  / / \\ \\  / \\//  //_\\\\     / /\\/              \n");
   fprintf(stderr, "  /\\_\\ \\  /  _  \\ / /\\/\\ \\ \\ \\_/ / / _  \\ /  _  \\ /\\/ /_               \n");
   fprintf(stderr, "  \\____/  \\_/ \\_/ \\/    \\/  \\___/  \\/ \\_/ \\_/ \\_/ \\____/                \n");
   fprintf(stderr, "                                                                                   \n");
   fprintf(stderr, "                                                                                   \n");
   fprintf(stderr, "  version: %s\n", __SAMURAI_VERSION__);
   fprintf(stderr, "                                                                                   \n");
   fprintf(stderr, "  - debug:   %s\n", options[__SAMURAI_DEBUG__]);
   fprintf(stderr, "  - logging: %s\n", options[__SAMURAI_LOGGING__]);
   fprintf(stderr, "  - testing: %s\n", options[__SAMURAI_TESTING__]);
   fprintf(stderr, "  - service: %s\n", options[__SAMURAI_SERVICE__]);
   fprintf(stderr, "                                                                                   \n");
   fprintf(stderr, "  - system:  %s\n", stSystemInfo.sysname);
   fprintf(stderr, "  - node:    %s\n", stSystemInfo.nodename);
   fprintf(stderr, "  - release: %s\n", stSystemInfo.release);
   fprintf(stderr, "  - version: %s\n", stSystemInfo.version);
   fprintf(stderr, "  - machine: %s\n", stSystemInfo.machine);
   fprintf(stderr, "                                                                                   \n");
   fprintf(stderr, "  +----------------------------------------------------------------------------+   \n");
   fprintf(stderr, "  |                                                                            |   \n");
   fprintf(stderr, "  |  1. Have a bug or a feature request?                                       |   \n");
   fprintf(stderr, "  |     https://github.com/hackers-painters/samurai-native/issues              |   \n");
   fprintf(stderr, "  |                                                                            |   \n");
   fprintf(stderr, "  |  2. Download lastest version?                                              |   \n");
   fprintf(stderr, "  |     https://github.com/hackers-painters/samurai-native/archive/master.zip  |   \n");
   fprintf(stderr, "  |                                                                            |   \n");
   fprintf(stderr, "  +----------------------------------------------------------------------------+   \n");
   fprintf(stderr, "                                                                                   \n");
   fprintf(stderr, "                                                                                   \n");
   
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
   
   [[SamuraiServiceLoader sharedInstance] installServices];
   
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
   
#endif   // #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
   
   __CATCH(nErr);
   
   return;
}

- (void)uninstall
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
   
   [[SamuraiServiceLoader sharedInstance] uninstallServices];
   
#endif // #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
   
   return;
}

#pragma mark -

- (void)UIApplicationDidFinishLaunchingNotification
{
   [self startup];
   
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
   
   dispatch_after_foreground(1.0f, ^{
      [[SamuraiDockerManager sharedInstance] installDockers];
   });
   
#endif // #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
   
   return;
}

- (void)UIApplicationWillTerminateNotification
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
   
   [[SamuraiDockerManager sharedInstance] uninstallDockers];
   
#endif // #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
   
   return;
}

#pragma mark -

- (void)startup
{
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
   [[SamuraiUnitTest sharedInstance] run];
#endif // #if __SAMURAI_TESTING__
   
   return;
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#import "__pragma_pop.h"
