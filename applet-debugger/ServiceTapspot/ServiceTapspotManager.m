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

#import "AppletCore.h"

#import "ServiceTapspotManager.h"
#import "ServiceTapspotView.h"

// ----------------------------------
// Source code
// ----------------------------------

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#pragma mark -

@implementation ServiceTapspotManager

@def_singleton( ServiceTapspotManager )

- (void)handleUIEvent:(UIEvent *)aEvent {
   
   UIWindow *stKeyWindow   = [UIApplication sharedApplication].keyWindow;
   
   if ( stKeyWindow ) {
      
      if ( UIEventTypeTouches == aEvent.type )
      {
         NSSet * stAllTouches  = [aEvent allTouches];
         
         for ( UITouch * stTouch in stAllTouches ) {
            
            if ( nil == stTouch.view || stTouch.view.window != stKeyWindow ) {
               
               continue;
               
            } /* End if () */

            if ( UITouchPhaseBegan == stTouch.phase ) {
               
               INFO( @"View '%@ %p', touch began", [[touch.view class] description], touch.view );

//               if ( NO == [touch.view isKindOfClass:[UIScrollView class]] )
//               {
//                  BOOL      clicked = NO;
//                  UIView *   clickedView = nil;
//                  
//                  for ( UIView * view = touch.view; nil != view; view = view.superview )
//                  {
//                     if ( view.gestureRecognizers && view.gestureRecognizers.count )
//                     {
//                        for ( UIGestureRecognizer * gesture in view.gestureRecognizers )
//                        {
//                           if ( [gesture isKindOfClass:[UITapGestureRecognizer class]] )
//                           {
//                              clicked = YES;
//                              clickedView = view;
//                              break;
//                           }
//                        }
//                     }
//                     
//                     if ( [view isKindOfClass:[UIControl class]] )
//                     {
//                        clicked = YES;
//                        clickedView = view;
//                        break;
//                     }
//                     
//                     if ( [view.renderer isClickable] )
//                     {
//                        clicked = YES;
//                        clickedView = view;
//                        break;
//                     }
//                  }
//
//                  if ( clicked )
//                  {
//                     [clickedView.layer removeAnimationForKey:@"scale"];
//                     
//                     CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
//                     animation.fromValue = [NSNumber numberWithFloat:1.0f];
//                     animation.toValue = [NSNumber numberWithFloat:0.9f];
//                     animation.duration = 0.15f;
//                     animation.repeatCount = 1;
//                     animation.autoreverses = YES;
//                     
//                     [clickedView.layer addAnimation:animation forKey:@"scale"];
//                  }
//               }
            }
            else if ( UITouchPhaseMoved == stTouch.phase ) {
               
               INFO( @"View '%@ %p', touch moved", [[touch.view class] description], touch.view );
            }
            else if ( UITouchPhaseEnded == stTouch.phase ) {
               
               INFO( @"View '%@ %p', touch ended", [[touch.view class] description], touch.view );

//               [touch.view.layer removeAnimationForKey:@"alpha"];
//               
//               CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
//               animation.fromValue = [NSNumber numberWithFloat:1.0f];
//               animation.toValue = [NSNumber numberWithFloat:0.25f];
//               animation.duration = 0.2f;
//               animation.repeatCount = 1;
//               animation.autoreverses = YES;
//               
//               [touch.view.layer addAnimation:animation forKey:@"alpha"];

               ServiceTapspotView * spotView = [[ServiceTapspotView alloc] init];
               spotView.frame = CGRectMake( 0, 0, 50.0f, 50.0f );
               spotView.center = [stTouch locationInView:stKeyWindow];
               [stKeyWindow addSubview:spotView];
               [stKeyWindow bringSubviewToFront:spotView];
               [spotView startAnimation];
            }
            else if ( UITouchPhaseCancelled == stTouch.phase ) {
               
            }
         }
      }
   }
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#endif   // #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
