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

@implementation UIView(IDEAApplet)

+ (id)createInstanceWithRenderer:(IDEAAppletRenderObject *)aRenderer identifier:(NSString *)aIdentifier {
   
   LogDebug((@"%s :: identifier : %@", __func__, aIdentifier));
   
   UIView   *stView  = [[self alloc] initWithFrame:CGRectZero];
   stView.renderer   = aRenderer;
   return stView;
}

#pragma mark -

+ (BOOL)supportTapGesture {
   
   return YES;
}

+ (BOOL)supportSwipeGesture {
   
   return YES;
}

+ (BOOL)supportPinchGesture {
   
   return YES;
}

+ (BOOL)supportPanGesture {
   
   return YES;
}

#pragma mark -

- (CGSize)computeSizeBySize:(CGSize)aSize {
   
   return aSize;
}

- (CGSize)computeSizeByWidth:(CGFloat)aWidth {
   
   return CGSizeMake(aWidth, self.frame.size.height);
}

- (CGSize)computeSizeByHeight:(CGFloat)aHeight {
   
   return CGSizeMake(self.frame.size.width, aHeight);
}

#pragma mark -

- (void)applyDom:(IDEAAppletDomNode *)aDom {
   
   return;
}

- (void)applyStyle:(IDEAAppletRenderStyle *)aStyle {
   
   return;
}

- (void)applyFrame:(CGRect)aNewFrame {
   
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

- (BOOL)isCell {
   
   return NO;
}

- (BOOL)isCellContainer {
   
   return NO;
}

- (NSIndexPath *)computeIndexPath {
   
   return nil;
}

#pragma mark -

//- (NSString *)description
//{
//   [[IDEAAppletLogger sharedInstance] outputCapture];
//   
//   [self dump];
//   
//   [[IDEAAppletLogger sharedInstance] outputRelease];
//   
//   return [IDEAAppletLogger sharedInstance].output;
//}

- (void)dump {
   
   SEL stSelector = NSSelectorFromString( @"recursiveDescription" );
   
   if ( stSelector && [self respondsToSelector:stSelector] ) {
      
      NSMethodSignature *stSignature   = [self methodSignatureForSelector:stSelector];
      NSInvocation      *stInvocation  = [NSInvocation invocationWithMethodSignature:stSignature];
      
      [stInvocation setTarget:self];
      [stInvocation setSelector:stSelector];
      [stInvocation invoke];
      
   } /* End if () */
   
   return;
}


#pragma mark -

- (id)serialize {
   
   return nil;
}

- (void)unserialize:(id)obj {
   
   return;
}

- (void)zerolize {
   
   return;
}

#if (__has_include(<UIKitExtension/UIKitExtension-umbrella.h>) || __has_include("UIKitExtension/UIKitExtension-umbrella.h") || __has_include("UIKitExtension.h"))
#else
- (void)setHidden:(BOOL)hidden animated:(BOOL)animated {
   
   if (!animated || self.hidden == hidden) {
      
      self.hidden = hidden;
      
      return;
   }
   
   CGFloat backupAlpha = self.alpha;
   CGFloat endAlpha;
   
   if (hidden) {
      endAlpha = .0;
   } else {
      self.alpha = .0;
      endAlpha = backupAlpha;
      self.hidden = NO;
   }
   
   [[self class] animateWithDuration:0.25 animations:^(void) {
      self.alpha = endAlpha;
   }
                          completion:^(BOOL finished) {
      if (hidden) {
         self.alpha = backupAlpha;
         self.hidden = YES; // value compatibility - this delayed action may be cause of unknown strange behavior.
      }
   }];
}

#endif

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
