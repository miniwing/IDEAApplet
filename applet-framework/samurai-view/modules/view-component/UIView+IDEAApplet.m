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

// ----------------------------------
// Private Head Files
#import "AppletCore.h"
// ----------------------------------

#import "UIView+IDEAApplet.h"

#import "__pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation UIView(Samurai)

+ (id)createInstanceWithRenderer:(SamuraiRenderObject *)renderer identifier:(NSString *)identifier
{
   UIView * newView = [[self alloc] initWithFrame:CGRectZero];
   newView.renderer = renderer;
   return newView;
}

#pragma mark -

+ (BOOL)supportTapGesture
{
   return YES;
}

+ (BOOL)supportSwipeGesture
{
   return YES;
}

+ (BOOL)supportPinchGesture
{
   return YES;
}

+ (BOOL)supportPanGesture
{
   return YES;
}

#pragma mark -

- (CGSize)computeSizeBySize:(CGSize)aSize
{
   return aSize;
}

- (CGSize)computeSizeByWidth:(CGFloat)aWidth
{
   return CGSizeMake(aWidth, self.frame.size.height);
}

- (CGSize)computeSizeByHeight:(CGFloat)aHeight
{
   return CGSizeMake(self.frame.size.width, aHeight);
}

#pragma mark -

- (void)applyDom:(SamuraiDomNode *)aDom
{
   return;
}

- (void)applyStyle:(SamuraiRenderStyle *)aStyle
{
   return;
}

- (void)applyFrame:(CGRect)aNewFrame
{
   // TODO: if animation
   
   aNewFrame.origin.x    = isnan(aNewFrame.origin.x) ? 0.0f : aNewFrame.origin.x;
   aNewFrame.origin.y    = isnan(aNewFrame.origin.y) ? 0.0f : aNewFrame.origin.y;
   aNewFrame.size.width  = isnan(aNewFrame.size.width) ? 0.0f : aNewFrame.size.width;
   aNewFrame.size.height = isnan(aNewFrame.size.height) ? 0.0f : aNewFrame.size.height;

   [UIView performWithoutAnimation:^{
      [self setFrame:aNewFrame];
   }];
}

#pragma mark -

- (BOOL)isCell
{
   return NO;
}

- (BOOL)isCellContainer
{
   return NO;
}

- (NSIndexPath *)computeIndexPath
{
   return nil;
}

#pragma mark -

//- (NSString *)description
//{
//   [[SamuraiLogger sharedInstance] outputCapture];
//   
//   [self dump];
//   
//   [[SamuraiLogger sharedInstance] outputRelease];
//   
//   return [SamuraiLogger sharedInstance].output;
//}

- (void)dump
{
   SEL    stSelector    = NSSelectorFromString(@"recursiveDescription");
//   printf("%p\n", stSelector);
   SEL    stSelector1   = NSSelectorFromString(@"description");
//   printf("%p\n", stSelector1);

//   IMP    stIMP         = [self methodForSelector:stSelector];
//   printf("%p\n", stIMP);
//   IMP    stIMP1        = [self methodForSelector:stSelector1];
//   printf("%p\n", stIMP1);
//
//   Method   stMethod    = class_getClassMethod(self, stSelector);
//   printf("%p\n", stMethod);
//   Method   stMethod1   = class_getClassMethod(self, stSelector1);
//   printf("%p\n", stMethod1);
//
//   if (stIMP == stIMP1)
//   {
//      return;
//
//   } /* End if () */

   NSMethodSignature *stSignature   = nil;
   NSMethodSignature *stSignature1  = nil;

   if (stSelector && [self respondsToSelector:stSelector])
   {
      stSignature = [self methodSignatureForSelector:stSelector];
      
   } /* End if () */
   
   if (stSelector1 && [self respondsToSelector:stSelector1])
   {
      stSignature1   = [self methodSignatureForSelector:stSelector];
      
   } /* End if () */

   if (stSignature == stSignature1)
   {
      return;
      
   } /* End if () */
   
   if (stSelector)
   {
      stSignature = [self methodSignatureForSelector:stSelector];
      NSInvocation   *stInvocation  = [NSInvocation invocationWithMethodSignature:stSignature];
      
      [stInvocation setTarget:self];
      [stInvocation setSelector:stSelector];
      [stInvocation invoke];
      
   } /* End if () */
   
   return;
}

#pragma mark -

- (id)serialize
{
   return nil;
}

- (void)unserialize:(id)obj
{
   return;
}

- (void)zerolize
{
   return;
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE(UI, UIView)

DESCRIBE(before)
{
}

DESCRIBE(after)
{
}

TEST_CASE_END

#endif   // #if __SAMURAI_TESTING__

#endif   // #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "__pragma_pop.h"
