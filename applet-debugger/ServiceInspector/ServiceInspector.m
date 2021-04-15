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

#import "ServiceInspector.h"
#import "ServiceInspectorWindow.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation ServiceInspector {
   
   ServiceInspectorWindow  * _window;
}

#pragma mark - ManagedService

- (BOOL)isAutoLoad {
   
   return SERVICE_INSPECTOR;
}

#pragma mark -

- (void)install {
   
   int                            nErr                                     = EFAULT;
   
   __TRY;
   
   [[NSNotificationCenter defaultCenter] addObserver:self
                                            selector:@selector(didApplicationLaunched)
                                                name:UIApplicationDidFinishLaunchingNotification
                                              object:nil];
   [[NSNotificationCenter defaultCenter] addObserver:self
                                            selector:@selector(willApplicationTerminate)
                                                name:UIApplicationWillTerminateNotification
                                              object:nil];
   
   __CATCH(nErr);
   
   return;
}

- (void)uninstall {
   
   int                            nErr                                     = EFAULT;
   
   __TRY;
   
   _window = nil;
   
   [[NSNotificationCenter defaultCenter] removeObserver:self];
   
   __CATCH(nErr);
   
   return;
}

#pragma mark -

- (void)powerOn {
   
   int                            nErr                                     = EFAULT;
   
   __TRY;
   
   __CATCH(nErr);
   
   return;
}

- (void)powerOff {
   
   int                            nErr                                     = EFAULT;
   
   __TRY;
   
   __CATCH(nErr);
   
   return;
}

#pragma mark -

- (void)didApplicationLaunched {
   
   int                            nErr                                     = EFAULT;
   
   __TRY;
   
   if ( nil == _window ) {
      
      _window  = [[ServiceInspectorWindow alloc] init];
      _window.hidden = YES;
      
   } /* End if () */
   
   __CATCH(nErr);
   
   return;
}

- (void)willApplicationTerminate {
   
   int                            nErr                                     = EFAULT;
   
   __TRY;
   
   _window = nil;
   
   __CATCH(nErr);
   
   return;
}

#pragma mark -

- (void)didDockerOpen {
   
   int                            nErr                                     = EFAULT;
   
   __TRY;

//   [_window makeKeyAndVisible];
   
   [_window show];
   
   __CATCH(nErr);
   
   return;
}

- (void)didDockerClose {
   
   int                            nErr                                     = EFAULT;
   
   UIWindow                      *stKeyWindow                              = nil;
   
   __TRY;
   
   [_window hide];
   
//   [[UIApplication sharedApplication].delegate.window makeKeyAndVisible];

   for (UIWindow *stWindow in [UIApplication sharedApplication].windows) {
      
      if ([stWindow isMemberOfClass:[UIWindow class]]) {
         
         stKeyWindow  = stWindow;

         break;

      } /* End if () */
      
   } /* End for () */

   if (nil == stKeyWindow) {
      
      stKeyWindow = [UIApplication sharedApplication].delegate.window;
      
   } /* End if () */
   
   [stKeyWindow makeKeyAndVisible];
   
   __CATCH(nErr);
   
   return;
}


@end
