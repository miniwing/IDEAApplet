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

#import "IDEAAppletServiceRootController.h"
#import "IDEAAppletDockerWindow.h"

#import "__pragma_push.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@interface IDEAAppletDockerWindow ()

@prop_assign( CGPoint , originPoint );

@end

#pragma mark -

@implementation IDEAAppletDockerWindow

@def_prop_assign  ( CGPoint , originPoint );


- (id)init {
   
   int                            nErr                                     = EFAULT;
   
   __TRY;
   
   self = [super init];
   if (self) {
      
      //   self.alpha = 0.75f;
      self.backgroundColor    = [UIColor clearColor];
      self.windowLevel        = UIWindowLevelStatusBar + 2.0f;
      self.rootViewController = [[ServiceRootController alloc] init];
      
      [[NSNotificationCenter defaultCenter] addObserver:self
                                               selector:@selector(orientationWillChange)
                                                   name:UIApplicationWillChangeStatusBarOrientationNotification
                                                 object:nil];
      
      [[NSNotificationCenter defaultCenter] addObserver:self
                                               selector:@selector(orientationDidChanged)
                                                   name:UIApplicationDidChangeStatusBarOrientationNotification
                                                 object:nil];
      
      [[UIApplication sharedApplication].delegate.window addObserver:self
                                                          forKeyPath:@"rootViewController"
                                                             options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew
                                                             context:nil];

      [[NSNotificationCenter defaultCenter] addObserver:self
                                               selector:@selector(onKeyboardWillShowNotification:)
                                                   name:UIKeyboardWillShowNotification
                                                 object:nil];

      [[NSNotificationCenter defaultCenter] addObserver:self
                                               selector:@selector(onKeyboardWillHideNotification:)
                                                   name:UIKeyboardWillHideNotification
                                                 object:nil];

   } /* End if () */
   
   __CATCH(nErr);
   
   return self;
}

- (void)dealloc {
   
   [[UIApplication sharedApplication].delegate.window removeObserver:self
                                                          forKeyPath:@"rootViewController"
                                                             context:nil];
   [[NSNotificationCenter defaultCenter] removeObserver:self];

   __SUPER_DEALLOC;
   
   return;
}

- (void)observeValueForKeyPath:(NSString *)aKeyPath ofObject:(id)aObject change:(NSDictionary<NSString *,id> *)aChange context:(void *)aContext {
   
   int                            nErr                                     = EFAULT;
   
   UIViewController              *stViewControllerOld                      = nil;
   UIViewController              *stViewControllerNew                      = nil;

   __TRY;

   LogDebug((@"-[IDEAAppletDockerWindow observeValueForKeyPath:ofObject:change:context] : KeyPath : %@", aKeyPath));

   if ([aKeyPath isEqualToString:@"rootViewController"]) {

      stViewControllerOld  = [aChange objectForKey:NSKeyValueChangeOldKey];
      LogDebug((@"-[IDEAAppletDockerWindow observeValueForKeyPath:ofObject:change:context] : NSKeyValueChangeOldKey : %@", stViewControllerOld));

      stViewControllerNew  = [aChange objectForKey:NSKeyValueChangeNewKey];
      LogDebug((@"-[IDEAAppletDockerWindow observeValueForKeyPath:ofObject:change:context] : NSKeyValueChangeNewKey : %@", stViewControllerNew));

      if (![stViewControllerOld isEqual:stViewControllerNew]) {
         
         if ([stViewControllerNew isKindOfClass:[UITabBarController class]]) {
            
            dispatch_async_foreground(^{

               [UIView animateWithDuration:0.25
                                animations:^{
                  
                  [self relayoutAllDockerViews];
               }];
            });
            
         } /* End if () */
         
      } /* End if () */
      
   } /* End if () */
      
   __CATCH(nErr);
   
   return;
}

- (void)addDockerView:(IDEAAppletDockerView *)aDocker {
   
   int                            nErr                                     = EFAULT;
   
   __TRY;
   
   [self addSubview:aDocker];
   
   __CATCH(nErr);
   
   return;
}

- (void)removeDockerView:(IDEAAppletDockerView *)aDocker {
   
   int                            nErr                                     = EFAULT;
   
   __TRY;
   
   if (aDocker.superview == self) {
      
      [aDocker removeFromSuperview];
      
   } /* End if () */
   
   __CATCH(nErr);
   
   return;
}

- (void)removeAllDockerViews {
   
   int                            nErr                                     = EFAULT;
   
   __TRY;
   
   // TODO:
   
   __CATCH(nErr);
   
   return;
}

- (void)relayoutAllDockerViews {
   
   int                            nErr                                     = EFAULT;
   
   NSMutableArray                *stDockerViews                            = [NSMutableArray nonRetainingArray];
   
   CGRect                         stWindowBound                            = CGRectZero;
   
   __TRY;
   
   for (UIView * subview in self.subviews) {
      
      if ([subview isKindOfClass:[IDEAAppletDockerView class]]) {
         
         [stDockerViews addObject:subview];
         
      } /* End if () */
      
   } /* End for () */
   
#define DOCKER_RIGHT    (10.0f)
#define DOCKER_BOTTOM   (0)
#define DOCKER_MARGIN   (4.0f)
#define DOCKER_HEIGHT   (30.0f)
   
   stWindowBound.size.width   = DOCKER_HEIGHT;
   stWindowBound.size.height  = stDockerViews.count * (DOCKER_HEIGHT + DOCKER_MARGIN);
   stWindowBound.origin.x     = [UIScreen mainScreen].bounds.size.width - stWindowBound.size.width - DOCKER_RIGHT;
   stWindowBound.origin.y     = [UIScreen mainScreen].bounds.size.height - stWindowBound.size.height - DOCKER_BOTTOM;
   
   if ([[UIApplication sharedApplication].delegate.window.rootViewController isKindOfClass:[UITabBarController class]]) {
      
      UITabBarController   *stTabBarController  = [UIApplication sharedApplication].delegate.window.rootViewController;
      
      stWindowBound.origin.y  = [UIScreen mainScreen].bounds.size.height - stWindowBound.size.height - stTabBarController.tabBar.frame.size.height - DOCKER_BOTTOM;
      
   } /* End if () */
   
   if (@available(iOS 11, *)) {
      
//      stWindowBound.origin.y  = stWindowBound.origin.y - [UIApplication sharedApplication].delegate.window.safeAreaInsets.bottom;
      
   } /* End if () */
   
   self.frame = stWindowBound;
   
   for (IDEAAppletDockerView * stDockerView in stDockerViews) {
      
      CGRect stDockerFrame;
      stDockerFrame.size.width   = DOCKER_HEIGHT;
      stDockerFrame.size.height  = DOCKER_HEIGHT;
      stDockerFrame.origin.x     = 0.0f;
      stDockerFrame.origin.y     = (DOCKER_HEIGHT + DOCKER_MARGIN) * [stDockerViews indexOfObject:stDockerView];
      stDockerView.frame         = stDockerFrame;
      
   } /* End for () */
   
   self.originPoint  = self.frame.origin;
   
   __CATCH(nErr);
   
   return;
}

- (void)setFrame:(CGRect)newFrame {
   
   [super setFrame:newFrame];
   
   return;
}

- (void)orientationWillChange {
   
   [self relayoutAllDockerViews];
   
   return;
}

- (void)orientationDidChanged {
   
   [self relayoutAllDockerViews];
   
   return;
}

#pragma mark - Keyboard
- (void)onKeyboardWillShowNotification:(NSNotification *)aNotification {
   
   int                            nErr                                     = EFAULT;
   
   NSDictionary                  *stUserInfo                               = nil;
   
   NSInteger                     nAnimationCurve                           = 0;
   NSTimeInterval                tAnimationDuration                        = 0;
   
   NSValue                       *stValue                                  = nil;
   CGRect                         stKeyboardEndFrame                       = CGRectZero;
   CGFloat                        fKeyboardHeight                          = 0;

   CGRect                         stFrame                                  = CGRectZero;

   __TRY;
   
   stUserInfo  = [aNotification userInfo];
   nAnimationCurve      = [[stUserInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
   tAnimationDuration   = [[stUserInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
   
   stValue  = [stUserInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
   
   if (stValue) {
      
      stKeyboardEndFrame   = [stValue CGRectValue];
      fKeyboardHeight      = stKeyboardEndFrame.size.height;
      
      stFrame  = self.frame;
      stFrame.origin.y  = self.originPoint.y - fKeyboardHeight;
      
      [UIView beginAnimations:nil context:nil];
      [UIView setAnimationDuration:tAnimationDuration];
      [UIView setAnimationCurve:nAnimationCurve];
      
//      [UIView setAnimationDelegate:self];
//      [UIView setAnimationDidStopSelector:@selector(startAnimationStep2)];

      [self setFrame:stFrame];

      [UIView commitAnimations];
      
   } /* End if () */
   
   __CATCH(nErr);
   
   return;
}

- (void)onKeyboardWillHideNotification:(NSNotification *)aNotification {
   
   int                            nErr                                     = EFAULT;
   
   NSDictionary                  *stUserInfo                               = nil;
   
   NSInteger                     nAnimationCurve                           = 0;
   NSTimeInterval                tAnimationDuration                        = 0;
   
   NSValue                       *stValue                                  = nil;
   CGRect                         stKeyboardEndFrame                       = CGRectZero;
   CGFloat                        fKeyboardHeight                          = 0;

   CGRect                         stFrame                                  = CGRectZero;

   __TRY;
   
   stUserInfo  = [aNotification userInfo];
   nAnimationCurve      = [[stUserInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
   tAnimationDuration   = [[stUserInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
   
   stValue  = [stUserInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
   
   if (stValue) {
      
      stKeyboardEndFrame   = [stValue CGRectValue];
      fKeyboardHeight      = stKeyboardEndFrame.size.height;
      
      stFrame  = self.frame;
      stFrame.origin = self.originPoint;
      
      [UIView beginAnimations:nil context:nil];
      [UIView setAnimationDuration:tAnimationDuration];
      [UIView setAnimationCurve:nAnimationCurve];
      
//      [UIView setAnimationDelegate:self];
//      [UIView setAnimationDidStopSelector:@selector(startAnimationStep2)];

      [self setFrame:stFrame];

      [UIView commitAnimations];
      
   } /* End if () */
   
   __CATCH(nErr);
   
   return;
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE(Service, DockerWindow)

DESCRIBE(before) {
}

DESCRIBE(after) {
}

TEST_CASE_END

#endif   // #if __SAMURAI_TESTING__

#import "__pragma_pop.h"
