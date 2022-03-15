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
#import "IDEAAppletGCD.h"

#import "__pragma_push.h"

// ----------------------------------
// Source code
// ----------------------------------
void IDEA_APPLET_DISPATCH_ASYNC_ON_MAIN_QUEUE(void (^block)(void)) {
   
   if (pthread_main_np()) {
      
      dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
         dispatch_async(dispatch_get_main_queue(), block);
      });
      
   } /* End if () */
   else {
      
      dispatch_async(dispatch_get_main_queue(), block);
      
   } /* End else */
   
   return;
}

void IDEA_APPLET_DISPATCH_SYNC_ON_MAIN_QUEUE(void (^block)(void)) {
   
   if (pthread_main_np()) {
      
      block();
      
   } /* End if () */
   else {
      
      dispatch_sync(dispatch_get_main_queue(), block);
      
   } /* End else */
   
   return;
}

void IDEA_APPLET_DISPATCH_ASYNC_ON_BACKGROUND_QUEUE(void (^block)(void)) {
   
   dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), block);
   
   return;
}

void IDEA_APPLET_DISPATCH_SYNC_ON_BACKGROUND_QUEUE(void (^block)(void)) {
   
   dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), block);
   
   return;
}

#pragma mark -

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#import "__pragma_pop.h"
