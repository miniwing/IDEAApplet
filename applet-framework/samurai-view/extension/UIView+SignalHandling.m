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

#import "UIView+SignalHandling.h"

#import "__pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation UIView(SignalHandling)

- (NSString *)signalNamespace {
   
   IDEAAppletRenderObject  *stRenderer = [self renderer];
   
   if ( stRenderer ) {
      
      return [stRenderer signalNamespace];
      
   } /* End if () */
   else {
      
      return [[self class] description];
      
   } /* End else */
}

- (NSString *)signalTag {
   
   IDEAAppletRenderObject  *stRenderer = [self renderer];
   
   if ( stRenderer ) {
      
      return [stRenderer signalTag];
      
   } /* End if () */
   else {
      
      return nil;
      
   } /* End else */
}

- (NSString *)signalDescription {
   
   IDEAAppletRenderObject  *stRenderer = [self renderer];
   
   if ( stRenderer ) {
      
      return [stRenderer signalDescription];
      
   } /* End if () */
   else {
      
      return [[self class] description];
      
   } /* End else */
}

- (id)signalResponders {
   
   IDEAAppletRenderObject  *stRenderer = [self renderer];
   
   if ( stRenderer ) {
      
      return [stRenderer signalResponders];
      
   } /* End if () */
   else {
      
      /**
       Harry FIXED:
       修复动态注册的bug
       */
      NSObject *stResponder   = [self userResponders];
      
      if (stResponder) {
         
         return stResponder;
         
      } /* End if () */
      
      return [self nextResponder];
      
   } /* End else */
}

- (id)signalAlias {
   
   IDEAAppletRenderObject  *stRenderer = [self renderer];
   
   if ( stRenderer ) {
      
      return [stRenderer signalAlias];
      
   } /* End if () */
   else {
      
      return nil;
      
   } /* End else */
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( UI, UIView_SignalHandling )

DESCRIBE( before ) {
   
}

DESCRIBE( after ) {
   
}

TEST_CASE_END

#endif   // #if __SAMURAI_TESTING__

#endif   // #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "__pragma_pop.h"
