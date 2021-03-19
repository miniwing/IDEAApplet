//
//     ____    _                        __     _      _____
//    / ___\  /_\     /\/\    /\ /\    /__\   /_\     \_   \
//    \ \    //_\\   /    \  / / \ \  / \//  //_\\     / /\/
//  /\_\ \  /  _  \ / /\/\ \ \ \_/ / / _  \ /  _  \ /\/ /_
//  \____/  \_/ \_/ \/    \/  \___/  \/ \_/ \_/ \_/ \____/
//
//	Copyright Samurai development team and other contributors
//
//	http://www.samurai-framework.com
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights
//	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//	copies of the Software, and to permit persons to whom the Software is
//	furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//	THE SOFTWARE.
//

#import "Samurai_ServiceRootController.h"
#import "Samurai_DockerWindow.h"

#import "_pragma_push.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation SamuraiDockerWindow


- (id)init
{
   int                            nErr                                     = EFAULT;
   
   __TRY;
   
   self = [super init];
   if ( self )
   {
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
      
   } /* End if () */
   
   __CATCH(nErr);
   
   return self;
}


- (void)dealloc
{
   int                            nErr                                     = EFAULT;
   
   __TRY;
   
   [[NSNotificationCenter defaultCenter] removeObserver:self];
   
   __CATCH(nErr);
   
   return;
}


- (void)addDockerView:(SamuraiDockerView *)aDocker
{
   int                            nErr                                     = EFAULT;
   
   __TRY;
   
   [self addSubview:aDocker];
   
   __CATCH(nErr);
   
   return;
}


- (void)removeDockerView:(SamuraiDockerView *)aDocker
{
   int                            nErr                                     = EFAULT;
   
   __TRY;
   
   if ( aDocker.superview == self )
   {
      [aDocker removeFromSuperview];
      
   } /* End if () */
   
   __CATCH(nErr);
   
   return;
}


- (void)removeAllDockerViews
{
   int                            nErr                                     = EFAULT;
   
   __TRY;
   
   // TODO:
   
   __CATCH(nErr);
   
   return;
}


- (void)relayoutAllDockerViews
{
   int                            nErr                                     = EFAULT;
   
   NSMutableArray                *stDockerViews                            = [NSMutableArray nonRetainingArray];
   
   CGRect                         stWindowBound                            = CGRectZero;
   
   __TRY;
   
   
   for ( UIView * subview in self.subviews )
   {
      if ( [subview isKindOfClass:[SamuraiDockerView class]] )
      {
         [stDockerViews addObject:subview];
         
      } /* End if () */
      
   } /* End for () */
   
#define DOCKER_RIGHT    10.0f
#define DOCKER_BOTTOM   64.0f
#define DOCKER_MARGIN   4.0f
#define DOCKER_HEIGHT   30.0f
   
   stWindowBound.size.width   = DOCKER_HEIGHT;
   stWindowBound.size.height  = stDockerViews.count * (DOCKER_HEIGHT + DOCKER_MARGIN);
   stWindowBound.origin.x     = [UIScreen mainScreen].bounds.size.width - stWindowBound.size.width - DOCKER_RIGHT;
   stWindowBound.origin.y     = [UIScreen mainScreen].bounds.size.height - stWindowBound.size.height - DOCKER_BOTTOM;
   
   if ([[UIApplication sharedApplication].delegate.window.rootViewController isKindOfClass:[UITabBarController class]])
   {
      UITabBarController   *stTabBarController  = [UIApplication sharedApplication].delegate.window.rootViewController;
      
      stWindowBound.origin.y  = [UIScreen mainScreen].bounds.size.height - stWindowBound.size.height - stTabBarController.tabBar.frame.size.height - DOCKER_BOTTOM;

   } /* End if () */

   self.frame = stWindowBound;
   
   for ( SamuraiDockerView * stDockerView in stDockerViews )
   {
      CGRect stDockerFrame;
      stDockerFrame.size.width   = DOCKER_HEIGHT;
      stDockerFrame.size.height  = DOCKER_HEIGHT;
      stDockerFrame.origin.x     = 0.0f;
      stDockerFrame.origin.y     = (DOCKER_HEIGHT + DOCKER_MARGIN) * [stDockerViews indexOfObject:stDockerView];
      stDockerView.frame         = stDockerFrame;
      
   } /* End for () */
   
   __CATCH(nErr);
   
   return;
}


- (void)setFrame:(CGRect)newFrame
{
   [super setFrame:newFrame];

   return;
}


- (void)orientationWillChange
{
   [self relayoutAllDockerViews];

   return;
}


- (void)orientationDidChanged
{
   [self relayoutAllDockerViews];

   return;
}


@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( Service, DockerWindow )

DESCRIBE( before )
{
}

DESCRIBE( after )
{
}

TEST_CASE_END

#endif	// #if __SAMURAI_TESTING__

#import "_pragma_pop.h"
