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
#import "ServiceInspectorWindow.h"

#pragma mark -

#undef   Degree2Radian
#define Degree2Radian( __degree ) (M_PI / 180.0f * __degree)

#undef   MAX_DEPTH
#define MAX_DEPTH   (36)

#pragma mark -

@interface UIView(Capture)
- (UIImage *)capture;
@end

#pragma mark -

@implementation UIView(Capture)

- (UIImage *)capture
{
   NSMutableArray * temp = [NSMutableArray nonRetainingArray];
   
   for (UIView * subview in self.subviews)
   {
      if (NO == subview.hidden)
      {
         subview.hidden = YES;
         
         [temp addObject:subview];
      }
   }
   
   CGSize screenSize = [UIScreen mainScreen].bounds.size;
   CGRect captureBounds = CGRectZero;
   
   captureBounds.size = self.bounds.size;
   
   if (captureBounds.size.width > screenSize.width)
   {
      captureBounds.size.width = screenSize.width;
   }
   
   if (captureBounds.size.height > screenSize.height)
   {
      captureBounds.size.height = screenSize.height;
   }
   
   UIImage * image = nil;
   
   UIGraphicsBeginImageContextWithOptions(captureBounds.size, NO, [UIScreen mainScreen].scale);
   
   CGContextRef context = UIGraphicsGetCurrentContext();
   if (context)
   {
      CGContextTranslateCTM(context, -captureBounds.origin.x, -captureBounds.origin.y);
      
//      CGContextScaleCTM(context, 0.5, 0.5);
      [self.layer renderInContext:context];
      
//      if (self.renderer)
//      {
//         if (self.renderer.dom.domId)
//         {
//            NSString *      renderTips = [NSString stringWithFormat:@" #%@ ", self.renderer.dom.domId];
//            NSDictionary *   renderAttr = [NSDictionary dictionaryWithObjectsAndKeys:
//                                   [UIFont systemFontOfSize:12.0f], NSFontAttributeName,
//                                   [UIColor yellowColor], NSForegroundColorAttributeName,
//                                   [[UIColor blackColor] colorWithAlphaComponent:0.5f], NSBackgroundColorAttributeName,
//                                   nil];
//
//            [renderTips drawAtPoint:CGPointZero withAttributes:renderAttr];
//         }
//         else if (self.renderer.dom.domTag)
//         {
//            NSString *      renderTips = [NSString stringWithFormat:@" <%@/> ", self.renderer.dom.domTag];
//            NSDictionary *   renderAttr = [NSDictionary dictionaryWithObjectsAndKeys:
//                                   [UIFont systemFontOfSize:12.0f], NSFontAttributeName,
//                                   [UIColor whiteColor], NSForegroundColorAttributeName,
//                                   [[UIColor blackColor] colorWithAlphaComponent:0.5f], NSBackgroundColorAttributeName,
//                                   nil];
//
//            [renderTips drawAtPoint:CGPointZero withAttributes:renderAttr];
//         }
//      }
      
      image = UIGraphicsGetImageFromCurrentImageContext();
   }
   
   UIGraphicsEndImageContext();
   
   for (UIView * subview in temp)
   {
      subview.hidden = NO;
   }
   
   return image;
}

@end

#pragma mark -

@interface ServiceImageView : UIImageView

@prop_assign(NSUInteger,   depth);
@prop_assign(UIView *,      view);
@prop_assign(CGRect,         viewFrame);

@end

#pragma mark -

@implementation ServiceImageView

@def_prop_assign(NSUInteger,  depth);
@def_prop_assign(UIView *,      view);
@def_prop_assign(CGRect,      viewFrame);

- (id)initWithFrame:(CGRect)frame
{
   self = [super initWithFrame:frame];
   if (self)
   {
   }
   return self;
}

- (void)dealloc
{
}

@end

#pragma mark -

@implementation ServiceInspectorWindow
{
   BOOL                          _dragging;
   NSTimer                    * _timer;
   
   CGFloat                       _rotateX;
   CGFloat                       _rotateY;
   CGFloat                       _distance;
   BOOL                          _animating;
   CGPoint                       _panOffset;
   UIPanGestureRecognizer     * _panGesture;
   CGFloat                       _pinchOffset;
   UIPinchGestureRecognizer   * _pinchGesture;
}

- (id)init
{
   CGRect screenBound = [UIScreen mainScreen].bounds;
   
   self = [super initWithFrame:screenBound];
   if (self)
   {
      self.backgroundColor    = [UIColor blackColor];
      self.windowLevel        = UIWindowLevelStatusBar + 1.0f;
      self.rootViewController = [[ServiceRootController alloc] init];
      
      _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPan:)];
      [self addGestureRecognizer:_panGesture];
      
      _pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(didPinch:)];
      [self addGestureRecognizer:_pinchGesture];
   }
   return self;
}

- (void)dealloc
{
   [self removeLayers];
   
   [self removeGestureRecognizer:_panGesture];
   [self removeGestureRecognizer:_pinchGesture];
   
   _panGesture = nil;
   _pinchGesture = nil;
}

- (UIView *)findContainerView:(UIView *)view
{
   for (UIView * subview in view.subviews)
   {
      if ([subview isKindOfClass:NSClassFromString(@"UILayoutContainerView")])
      {
         return subview;
         
      } /* End if () */
      else
      {
         UIView * result = [self findContainerView:subview];
         if (result)
         {
            return result;
            
         } /* End if () */
         
      } /* End else */
      
   } /* End for () */
   
   return nil;
}

- (UIView *)findWrapperView:(UIView *)view
{
   for (UIView * subview in view.subviews)
   {
      if ([subview isKindOfClass:NSClassFromString(@"UIViewControllerWrapperView")])
      {
         return subview;
         
      } /* End if () */
      else
      {
         UIView * result = [self findWrapperView:subview];
         if (result)
         {
            return result;
            
         } /* End if () */
         
      } /* End else */
      
   } /* End for () */
   
   return nil;
}

- (UIView *)findNavigationBar:(UIView *)view
{
   for (UIView * subview in view.subviews)
   {
      if ([subview isKindOfClass:NSClassFromString(@"UINavigationBar")])
      {
         return subview;
         
      } /* End if () */
      else
      {
         UIView * result = [self findNavigationBar:subview];
         if (result)
         {
            return result;
            
         } /* End if () */
         
      } /* End if () */
      
   } /* End for () */
   
   return nil;
}

- (void)buildLayers
{
   int                            nErr                                     = EFAULT;
   
   UIView                        *stKeyWindow                              = nil;
   CGFloat                        fDepth                                   = 0;

//   NSArray<__kindof UIWindow *>  *stWindows                                = nil;
   
   __TRY;
   
   stKeyWindow = [UIApplication sharedApplication].delegate.window;

//   stWindows   = [UIApplication sharedApplication].windows;
//
//   for (UIWindow *stWindow in stWindows)
//   {
////      if ([stWindow conformsToProtocol:@protocol(UIApplicationDelegate)])
////      {
////         stRootView  = stWindow;
////
////         break;
////
////      } /* End if () */
//
//      if ([stWindow isMemberOfClass:[UIWindow class]])
//      {
//         stRootView  = stWindow;
//
//         break;
//
//      } /* End if () */
//
//   } /* End for () */
//
//   if (nil == stRootView)
//   {
//      stRootView  = [UIApplication sharedApplication].keyWindow;
//
//   } /* End if () */
   
//   UIView * container = [self findContainerView:rootView];
//   UIView * wrapperView = [self findWrapperView:container];
//   UIView * navigationBar = [self findNavigationBar:container];
   
   fDepth = [self buildSublayersForView:stKeyWindow origin:CGPointZero depth:fDepth];
//   depth = [self buildSublayersForView:container origin:CGPointZero depth:depth];
//   depth = [self buildSublayersForView:wrapperView origin:CGPointZero depth:depth];
//   depth = [self buildSublayersForView:navigationBar origin:CGPointZero depth:depth];
   
   [self transformLayers:YES];

   __CATCH(nErr);
   
   return;
}

- (CGFloat)buildSublayersForView:(UIView *)aView origin:(CGPoint)aOrigin depth:(CGFloat)aDepth
{
   if (aDepth >= MAX_DEPTH)
   {
      return aDepth;
      
   } /* End if () */
   
   if (aView.hidden)
   {
      return aDepth;
      
   } /* End if () */
   
   CGRect stScreenBound = [UIScreen mainScreen].bounds;
   CGRect stViewFrame   = CGRectZero;
   
   stViewFrame.origin.x    = aOrigin.x + aView.frame.origin.x;
   stViewFrame.origin.y    = aOrigin.y + aView.frame.origin.y;
   stViewFrame.size.width  = aView.frame.size.width;
   stViewFrame.size.height = aView.frame.size.height;
   
   if ([aView isKindOfClass:[UIScrollView class]])
   {
      __unsafe_unretained UIScrollView * scrollView = (UIScrollView *)aView;
      
      stViewFrame.origin.x -= scrollView.contentOffset.x;
      stViewFrame.origin.y -= scrollView.contentOffset.y;
      
   } /* End if () */
   
   CGFloat fNextDepth = aDepth;
   
   if (aView.frame.size.width && aView.frame.size.height)
   {
      ServiceImageView *stCapturedView = [[ServiceImageView alloc] init];
      
      stCapturedView.layer.cornerRadius   = aView.layer.cornerRadius;
      stCapturedView.layer.masksToBounds  = aView.layer.masksToBounds;
      
      CGPoint   stAnchor   = CGPointZero;
      
      stAnchor.x = (stScreenBound.size.width / 2.0f - stViewFrame.origin.x) / stViewFrame.size.width;
      stAnchor.y = (stScreenBound.size.height / 2.0f - stViewFrame.origin.y) / stViewFrame.size.height;
      
      stCapturedView.depth    = aDepth;
      stCapturedView.view     = aView;
      stCapturedView.viewFrame= stViewFrame;
      
      stCapturedView.image = [aView capture];
      stCapturedView.frame = stViewFrame;
      stCapturedView.layer.anchorPoint = stAnchor;
      stCapturedView.layer.anchorPointZ= aDepth * (-40.0f);
      
      if (aView.renderer)
      {
         if ([aView.renderer.childs count])
         {
            fNextDepth += 0.75f;
            
            stCapturedView.alpha = 0.5f;
            stCapturedView.backgroundColor = aView.backgroundColor;
            stCapturedView.layer.borderColor = [HEX_RGBA(0x999999, 0.75) CGColor];
            stCapturedView.layer.borderWidth = 1.0f;
            
         }  /* End if () */
         else
         {
            fNextDepth += 1.0f;
            
            stCapturedView.alpha = 1.0f;
            stCapturedView.backgroundColor = aView.backgroundColor;
            stCapturedView.layer.borderColor = [HEX_RGBA(0xd22042, 0.75) CGColor];
            stCapturedView.layer.borderWidth = 1.5f;
            
         } /* End else */
         
      } /* End if () */
      else
      {
         fNextDepth += 0.5f;
         
         stCapturedView.alpha = 1.0f;
         stCapturedView.backgroundColor = aView.backgroundColor;
         stCapturedView.layer.borderColor = [HEX_RGBA(0x999999, 0.5) CGColor];
         stCapturedView.layer.borderWidth = 1.0f;
         
      } /* End else */
      
      [self addSubview:stCapturedView];
      
      UITapGestureRecognizer  *stTapGesture  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClicked:)];
      if (stTapGesture)
      {
         [stCapturedView setUserInteractionEnabled:YES];
         [stCapturedView addGestureRecognizer:stTapGesture];
         
      } /* End if () */
   }
   
   CGFloat fMaxDepth    = aDepth;
   
   for (UIView *stSubview in [aView.subviews reverseObjectEnumerator])
   {
      CGFloat fSubDepth = [self buildSublayersForView:stSubview origin:stViewFrame.origin depth:fNextDepth];
      
      if (fSubDepth > fMaxDepth)
      {
         fMaxDepth = fSubDepth;
         
      } /* End if () */
      
   } /* End for () */
   
   return fMaxDepth;
}

- (void)removeLayers
{
   int                            nErr                                     = EFAULT;
   
   __TRY;
   
   NSArray * subviewsCopy = [NSArray arrayWithArray:self.subviews];
   
   for (UIView * subview in subviewsCopy)
   {
      if ([subview isKindOfClass:[ServiceImageView class]])
      {
         [subview removeFromSuperview];
         
      } /* End if () */
      
   } /* End for () */
   
   __CATCH(nErr);
   
   return;
}

- (void)transformLayers:(BOOL)setFrames
{
   CATransform3D   stTransform2  = CATransform3DIdentity;
   stTransform2.m34 = -0.002;
   stTransform2 = CATransform3DTranslate(stTransform2, _rotateY * -3.0f, 0, 0);
   stTransform2 = CATransform3DTranslate(stTransform2, 0, _rotateX * 3.0f, 0);
   
   CATransform3D   stTransform   = CATransform3DIdentity;
   stTransform = CATransform3DMakeTranslation(0, 0, _distance * 1000);
   stTransform = CATransform3DConcat(CATransform3DMakeRotation(Degree2Radian(_rotateX), 1, 0, 0), stTransform);
   stTransform = CATransform3DConcat(CATransform3DMakeRotation(Degree2Radian(_rotateY), 0, 1, 0), stTransform);
   stTransform = CATransform3DConcat(CATransform3DMakeRotation(Degree2Radian(0), 0, 0, 1), stTransform);
   stTransform = CATransform3DConcat(stTransform, stTransform2);
   
   NSArray * stSubviews = [NSArray arrayWithArray:self.subviews];
   
   for (ServiceImageView * stSubview in stSubviews)
   {
      if ([stSubview isKindOfClass:[ServiceImageView class]])
      {
         stSubview.frame = CGRectInset(stSubview.viewFrame, 1, 1);
         
         if (_animating)
         {
            stSubview.layer.transform = CATransform3DIdentity;
            
         } /* End if () */
         else
         {
            stSubview.layer.transform = stTransform;
            
         } /* End else */
         
         [stSubview setNeedsDisplay];
      }
   }
}

#pragma mark -

- (void)show
{
   int                            nErr                                     = EFAULT;
   
   __TRY;
   
   [self showStep1];
   
   __CATCH(nErr);
   
   return;
}

- (void)showStep1
{
   _rotateX    = 0.0f;
   _rotateY    = 0.0f;
   _distance   = 0.0f;
   _animating  = YES;
   
   self.hidden = NO;
   self.alpha  = 0.0f;
   
   [self removeLayers];
   [self buildLayers];
   
   [self transformLayers:YES];
   
   [UIView beginAnimations:@"showStep1" context:nil];
   [UIView setAnimationBeginsFromCurrentState:YES];
   [UIView setAnimationDuration:0.2f];
   [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
   [UIView setAnimationDelegate:self];
   [UIView setAnimationDidStopSelector:@selector(showStep2)];
   
   self.alpha = 1.0f;
   self.hidden = NO;
   
   [UIView commitAnimations];
}

- (void)showStep2
{
   int                            nErr                                     = EFAULT;
      
   __TRY;

   _rotateX    = -30.0f;
   _rotateY    = 0.0f;
   _distance   = -0.45f;
   _animating  = NO;
   
   [UIView beginAnimations:@"showStep2" context:nil];
   [UIView setAnimationBeginsFromCurrentState:YES];
   [UIView setAnimationDuration:0.75f];
   [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
   [UIView setAnimationDelegate:self];
   [UIView setAnimationDidStopSelector:@selector(showStep3)];
   
   [self transformLayers:NO];
   
   [UIView commitAnimations];

   __CATCH(nErr);
   
   return;
}

- (void)showStep3
{
   int                            nErr                                     = EFAULT;
      
   __TRY;

   _animating  = NO;
   
   if (nil == _timer)
   {
      _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                target:self
                                              selector:@selector(refreshLayers)
                                              userInfo:nil
                                               repeats:YES];
   }

   __CATCH(nErr);
   
   return;
}

#pragma mark -

- (void)hide
{
   int                            nErr                                     = EFAULT;
      
   __TRY;

   if (_timer)
   {
      [_timer invalidate];
      
      _timer = nil;
   }
   
   [self hideStep1];

   __CATCH(nErr);
   
   return;
}

- (void)hideStep1
{
   int                            nErr                                     = EFAULT;
      
   __TRY;

   _rotateX    = 0.0f;
   _rotateY    = 0.0f;
   _distance   = 0.0f;
   _animating  = YES;
   
   [UIView beginAnimations:@"hideStep1" context:nil];
   [UIView setAnimationBeginsFromCurrentState:YES];
   [UIView setAnimationDuration:0.75f];
   [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
   [UIView setAnimationDelegate:self];
   [UIView setAnimationDidStopSelector:@selector(hideStep2)];
   
   [self transformLayers:YES];
   
   [UIView commitAnimations];

   __CATCH(nErr);

   return;
}

- (void)hideStep2
{
   int                            nErr                                     = EFAULT;
      
   __TRY;

   _animating = NO;
   
   [UIView beginAnimations:@"showStep2" context:nil];
   [UIView setAnimationBeginsFromCurrentState:YES];
   [UIView setAnimationDuration:0.3f];
   [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
   [UIView setAnimationDelegate:self];
   [UIView setAnimationDidStopSelector:@selector(hideStep3)];
   
   self.alpha  = 0.0f;
   
   [UIView commitAnimations];

   __CATCH(nErr);
   
   return;
}

- (void)hideStep3
{
   int                            nErr                                     = EFAULT;
      
   __TRY;

   _rotateX    = 0.0f;
   _rotateY    = 0.0f;
   _distance   = 0.0f;
   _animating  = NO;
   
   self.alpha  = 0.0f;
   self.hidden = YES;
   
   [self removeLayers];

   __CATCH(nErr);
   
   return;
}

#pragma mark -

- (void)refreshLayers
{
   int                            nErr                                     = EFAULT;
   
   __TRY;
   
   if (_dragging)
   {
      return;
   }
   
   if (_animating)
   {
      return;
   }
   
   [self removeLayers];
   [self buildLayers];
   
   __CATCH(nErr);
   
   return;
}

#pragma mark -

- (void)didClicked:(UITapGestureRecognizer *)tapGesture
{
//   if (UIGestureRecognizerStateEnded == tapGesture.state)
//   {
//      if (tapGesture.view && [tapGesture.view isKindOfClass:[ServiceImageView class]])
//      {
//         ServiceImageView * view = (ServiceImageView *)tapGesture.view;
//      }
//   }

   return;
}

- (void)didPan:(UIPanGestureRecognizer *)panGesture
{
   if (UIGestureRecognizerStateBegan == panGesture.state)
   {
      _dragging = YES;
      
      _panOffset.x = _rotateY;
      _panOffset.y = _rotateX * -1.0f;
   }
   else if (UIGestureRecognizerStateChanged == panGesture.state)
   {
      _dragging = YES;
      
      CGPoint offset = [panGesture translationInView:self];
      
      _rotateY = _panOffset.x + offset.x * 0.5f;
      _rotateX = _panOffset.y * -1.0f - offset.y * 0.5f;
      
      [self transformLayers:NO];
   }
   else if (UIGestureRecognizerStateEnded == panGesture.state)
   {
      _dragging = NO;
      
      [self transformLayers:NO];
   }
   else if (UIGestureRecognizerStateCancelled == panGesture.state)
   {
      _dragging = NO;
      
      [self transformLayers:NO];
   }
}

- (void)didPinch:(UIPinchGestureRecognizer *)pinchGesture
{
   if (UIGestureRecognizerStateBegan == pinchGesture.state)
   {
      _dragging = YES;
      
      _pinchOffset = _distance;
   }
   else if (UIGestureRecognizerStateChanged == pinchGesture.state)
   {
      _dragging = YES;
      
      _distance = _pinchOffset + (pinchGesture.scale - 1.0f);
      _distance = (_distance < -5.0f ? -5.0f : (_distance > 0.5f ? 0.5f : _distance));
      
      [self transformLayers:NO];
   }
   else if (UIGestureRecognizerStateEnded == pinchGesture.state)
   {
      _dragging = NO;
      
      [self transformLayers:NO];
   }
   else if (UIGestureRecognizerStateCancelled == pinchGesture.state)
   {
      _dragging = NO;
      
      [self transformLayers:NO];
   }
}

@end
