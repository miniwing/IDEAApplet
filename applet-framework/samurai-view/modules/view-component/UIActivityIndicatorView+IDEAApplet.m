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

#import "UIActivityIndicatorView+IDEAApplet.h"

#import "__pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation UIActivityIndicatorView(IDEAApplet)

+ (id)createInstanceWithRenderer:(IDEAAppletRenderObject *)renderer identifier:(NSString *)identifier {
   
   UIActivityIndicatorView * indicator = [[self alloc] initWithFrame:CGRectZero];
   
   indicator.renderer = renderer;
   indicator.hidesWhenStopped = YES;
   
   return indicator;
}

#pragma mark -

+ (BOOL)supportTapGesture {
   
   return NO;
}

+ (BOOL)supportSwipeGesture {
   
   return NO;
}

+ (BOOL)supportPinchGesture {
   
   return NO;
}

+ (BOOL)supportPanGesture {
   
   return NO;
}

#pragma mark -

- (id)serialize {
   
   return [NSNumber numberWithBool:[self isAnimating]];
}

- (void)unserialize:(id)obj {
   
   if ( [obj boolValue] ) {
      
      [self startAnimating];
   }
   else {
      
      [self stopAnimating];
   }
}

- (void)zerolize {
   
   [self stopAnimating];
}

#pragma mark -

- (void)applyDom:(IDEAAppletDomNode *)dom {
   
   [super applyDom:dom];
}

- (void)applyStyle:(IDEAAppletRenderStyle *)style {
   
   [super applyStyle:style];
}

- (void)applyFrame:(CGRect)frame {
   
   [super applyFrame:frame];
}

#pragma mark -

- (CGSize)computeSizeBySize:(CGSize)size {
   
   return [super computeSizeBySize:size];
}

- (CGSize)computeSizeByWidth:(CGFloat)width {
   
   return [super computeSizeByWidth:width];
}

- (CGSize)computeSizeByHeight:(CGFloat)height {
   
   return [super computeSizeByHeight:height];
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( UI, UIActivityIndicatorView )

DESCRIBE( before ) {
   
}

DESCRIBE( after ) {
   
}

TEST_CASE_END

#endif   // #if __SAMURAI_TESTING__

#endif   // #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "__pragma_pop.h"
