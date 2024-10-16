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
#import "IDEAAppletServiceRootController.h"

#import "__pragma_push.h"

@interface ServiceRootController ()
@end

// ----------------------------------
// Source code
// ----------------------------------
@implementation ServiceRootController

#pragma mark - UIStatusBar
- (UIStatusBarStyle)preferredStatusBarStyle {
   
   if ([IDEAApplet isAppExtension]) {
      
      if ((@available(iOS 13.0, *))) {
         
         return UIStatusBarStyleDarkContent;

      } /* End if () */
      else {
         
         return UIStatusBarStyleDefault;

      } /* End else */
      
   } /* End if () */
   
   if (nil != [IDEAApplet sharedExtensionApplication].delegate.window.rootViewController) {
      
      return [IDEAApplet sharedExtensionApplication].delegate.window.rootViewController.preferredStatusBarStyle;

   } /* End if () */
   
   return [[IDEAApplet sharedExtensionApplication] statusBarStyle];
}

- (BOOL)prefersStatusBarHidden {
   
   if (nil != [IDEAApplet sharedExtensionApplication].delegate.window.rootViewController) {
      
      return [IDEAApplet sharedExtensionApplication].delegate.window.rootViewController.prefersStatusBarHidden;

   } /* End if () */

   return [IDEAApplet sharedExtensionApplication].isStatusBarHidden;
}

@end

#pragma mark -

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#import "__pragma_pop.h"
