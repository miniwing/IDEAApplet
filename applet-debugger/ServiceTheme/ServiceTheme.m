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

#import "ServiceTheme.h"

// ----------------------------------
// Private
// ----------------------------------

@interface ServiceTheme ()

@end

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation ServiceTheme

#pragma mark - ManagedService

- (BOOL)isAutoLoad {
   
   return SERVICE_THEME;
}

#pragma mark -

- (void)install {
   
   int                            nErr                                     = EFAULT;
   
   __TRY;

   __CATCH(nErr);
   
   return;
}

- (void)uninstall {
   
   int                            nErr                                     = EFAULT;
   
   __TRY;

   __CATCH(nErr);
   
   return;
}

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

- (void)didDockerOpen {
   
   int                            nErr                                     = EFAULT;
   
   __TRY;

   [self themeVersionChange];

   __CATCH(nErr);
   
   return;
}

- (void)didDockerClose {
   
   int                            nErr                                     = EFAULT;
   
   __TRY;

   [self themeVersionChange];

   __CATCH(nErr);
   
   return;
}

- (void)themeVersionChange {
   
   int                            nErr                                     = EFAULT;
   
   __TRY;

   if ([DKThemeVersionNight isEqualToString:[DKNightVersionManager sharedManager].themeVersion]) {
      
      [[DKNightVersionManager sharedManager] dawnComing];

   } /* End if () */
   else {

      [[DKNightVersionManager sharedManager] nightFalling];

   } /* End else */

   __CATCH(nErr);
   
   return;
}

@end
