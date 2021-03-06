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

#import "ServiceTapspotView.h"

// ----------------------------------
// Source code
// ----------------------------------

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#pragma mark -

@implementation ServiceTapspotView

- (id)initWithFrame:(CGRect)aFrame {
   
   self = [super initWithFrame:aFrame];
   if ( self ) {
      
      self.backgroundColor          = UIColor.clearColor;
      self.userInteractionEnabled   = NO;
      self.contentMode              = UIViewContentModeCenter;
      
   }
   
   return self;
}

- (void)dealloc {
   
   __SUPER_DEALLOC;
   
   return;
}

- (void)didAppearingAnimationStopped {
   
   [self removeFromSuperview];
   
   return;
}

- (void)startAnimation {
   
   self.alpha     = 1.0f;
   self.transform = CGAffineTransformMakeScale( 0.5f, 0.5f );
   
   [UIView beginAnimations:nil context:nil];
   [UIView setAnimationCurve:UIViewAnimationCurveLinear];
   [UIView setAnimationDuration:0.6f];
   [UIView setAnimationDelegate:self];
   [UIView setAnimationDidStopSelector:@selector(didAppearingAnimationStopped)];
   
   self.alpha = 0.0f;
   self.transform = CGAffineTransformIdentity;
   
   [UIView commitAnimations];
   
   return;
}

- (void)stopAnimation {
   
   return;
}

- (void)drawRect:(CGRect)aRect {
   
   CGContextRef stContext = UIGraphicsGetCurrentContext();
   
   if ( stContext ) {
      
      CGContextSaveGState( stContext );
      
      CGContextSetFillColorWithColor( stContext, [UIColor.clearColor CGColor] );
      CGContextFillRect( stContext, aRect );
      
      CGRect stBound;
      stBound.origin = CGPointZero;
      stBound.size   = aRect.size;
      
      CGContextAddEllipseInRect( stContext, stBound );
      CGContextSetFillColorWithColor( stContext, [[UIColor lightGrayColor] CGColor] );
      CGContextFillPath( stContext );

      CGContextAddEllipseInRect( stContext, CGRectInset(stBound, 5, 5) );
      CGContextSetFillColorWithColor( stContext, [UIColor.whiteColor CGColor] );
      CGContextFillPath( stContext );

      CGContextRestoreGState( stContext );
      
   }
   
   [super drawRect:aRect];
   
   return;
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#endif   // #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
