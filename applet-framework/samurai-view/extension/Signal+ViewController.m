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

#import "Signal+ViewController.h"

#import "__pragma_push.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

@implementation IDEAAppletSignal(ViewController)

@def_prop_dynamic ( UIViewController   *, sourceViewController );
@def_prop_dynamic ( IDEAAppletActivity *, sourceActivity       );

- (UIViewController *)sourceViewController {
   
   if ( nil == self.source ) {
      return nil;
   }
   
   if ( [self.source isKindOfClass:[UIView class]] ) {
      
      UIResponder * nextResponder = [(UIView *)self.source nextResponder];
      
      if ( nextResponder && [nextResponder isKindOfClass:[UIViewController class]] ) {
         
         return (UIViewController *)nextResponder;
      }
   }
   else if ( [self.source isKindOfClass:[UIViewController class]] ) {
      
      return (UIViewController *)self.source;
   }

   return nil;   
}

- (IDEAAppletActivity *)sourceActivity {
   
   UIViewController * controller = [self sourceViewController];

   if ( controller && [controller isKindOfClass:[IDEAAppletActivity class]] ) {
      
      return (IDEAAppletActivity *)controller;
   }
   
   return nil;
}

@end

#endif   // #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
