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

#import "ServiceBorderHook.h"
#import "ServiceBorderLayer.h"

// ----------------------------------
// Source code
// ----------------------------------

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#pragma mark -

@implementation NSObject(Border)

@def_notification ( BorderShow );
@def_notification ( BorderHide );

static void (*__layoutSubviews)  (id, SEL) = NULL;
static void (*__setNeedsLayout)  (id, SEL) = NULL;
static void (*__setNeedsDisplay) (id, SEL) = NULL;

static BOOL __enabled = NO;

+ (void)borderEnable {
   
   __enabled = YES;
   
   [[NSNotificationCenter defaultCenter] postNotificationName:NSObject.BorderShowNotification object:nil];
   
   return;
}

+ (void)borderDisable {
   
   __enabled = NO;
   
   [[NSNotificationCenter defaultCenter] postNotificationName:NSObject.BorderHideNotification object:nil];
   
   return;
}

+ (void)borderHook {
   
   __layoutSubviews  = [UIView replaceSelector:@selector(layoutSubviews) withSelector:@selector(__layoutSubviews)];
   __setNeedsLayout  = [UIView replaceSelector:@selector(setNeedsLayout) withSelector:@selector(__setNeedsLayout)];
   __setNeedsDisplay = [UIView replaceSelector:@selector(setNeedsDisplay) withSelector:@selector(__setNeedsDisplay)];
   
   return;
}

- (void)__layoutSubviews {
   
   if ([self isKindOfClass:[UIView class]]) {
      
      for (UIView *stSubview in [(UIView *)self subviews]) {
         
         [self borderPresent:stSubview];
         
      } /* End for () */
      
      //      [self borderPresent:(UIView *)self];
   }
   
   if (__layoutSubviews) {
      
      __layoutSubviews(self, _cmd);
      
   } /* End if () */
   
   return;
}

- (void)__setNeedsLayout {
   
   if ([self isKindOfClass:[UIView class]]) {
      
      for (UIView *stSubview in [(UIView *)self subviews]) {
         
         [self borderPresent:stSubview];
         
      } /* End for () */
      
      //      [self borderPresent:(UIView *)self];
      
   } /* End if () */
   
   if (__setNeedsLayout) {
      
      __setNeedsLayout(self, _cmd);
      
   } /* End if () */
   
   return;
}

- (void)__setNeedsDisplay {
   
   if ([self isKindOfClass:[UIView class]]) {
      
      for (UIView *stSubview in [(UIView *)self subviews]) {
         
         [self borderPresent:stSubview];
         
      } /* End for () */
      
      //      [self borderPresent:(UIView *)self];
   }
   
   if (__setNeedsDisplay) {
      
      __setNeedsDisplay(self, _cmd);
      
   } /* End if () */
   
   return;
}

- (void)borderPresent:(UIView *)aContainer {
   
   if (nil == aContainer.renderer) {
      
      return;
      
   } /* End if () */
   
   ServiceBorderLayer   *stBorderLayer    = nil;
   
   for (CALayer *stSublayer in aContainer.layer.sublayers) {
      
      if ([stSublayer isKindOfClass:[ServiceBorderLayer class]]) {
         
         stBorderLayer = (ServiceBorderLayer *)stSublayer;
         
         break;
         
      } /* End if () */
      
   } /* End for () */
   
   if (nil == stBorderLayer) {
      
      stBorderLayer  = [[ServiceBorderLayer alloc] init];
      stBorderLayer.container = aContainer;
      
      stBorderLayer.hidden    = __enabled ? NO : YES;
      stBorderLayer.frame     = CGRectInset(CGRectMake(0, 0, aContainer.bounds.size.width, aContainer.bounds.size.height), 0.1f, 0.1f);
      
      stBorderLayer.masksToBounds = YES;
//   borderLayer.cornerRadius = container.layer.cornerRadius;
      
      [aContainer.layer insertSublayer:stBorderLayer atIndex:0];
      
   } /* End if () */
   
   IDEAAppletRenderObject  *stRenderer = aContainer.renderer;
   
   if (stRenderer) {
      
      if (DomNodeType_Document == stRenderer.dom.type) {
         
         stBorderLayer.borderColor = [HEX_RGBA(0x000000, 1.0f) CGColor];
         stBorderLayer.borderWidth = 2.0f;
      }
      else if (DomNodeType_Element == stRenderer.dom.type) {
         
         stBorderLayer.borderColor = [HEX_RGBA(0xd22042, 1.0f) CGColor];
         stBorderLayer.borderWidth = 2.0f;
      }
      else if (DomNodeType_Text == stRenderer.dom.type) {
         
         stBorderLayer.borderColor = [HEX_RGBA(0x666666, 1.0f) CGColor];
         stBorderLayer.borderWidth = 2.0f;
      }
      else {
         
         stBorderLayer.borderColor = [HEX_RGBA(0xcccccc, 1.0f) CGColor];
         stBorderLayer.borderWidth = 2.0f;
      }
      
      if ([stRenderer.childs count]) {
         
         stBorderLayer.backgroundColor = [UIColor.clearColor CGColor];
      }
      else {
         
         stBorderLayer.backgroundColor = [HEX_RGBA(0x00bff3, 0.2f) CGColor];
      }
   }
   else {
      
      stBorderLayer.backgroundColor = [UIColor.clearColor CGColor];
      stBorderLayer.borderColor = [HEX_RGBA(0xcccccc, 1.0f) CGColor];
      stBorderLayer.borderWidth = 2.0f;
   }
   
   [stBorderLayer setNeedsDisplay];
   
   return;
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#endif   // #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
