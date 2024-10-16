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

#import "IDEAAppletDockerView.h"

#import "__pragma_push.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation IDEAAppletDockerView {
   
   UIButton    * _open;
   UIButton    * _close;
}

@def_prop_unsafe  ( IDEAAppletService<ManagedDocker>  *,   service );

- (id)init {
   
   int                            nErr                                     = EFAULT;
   
   __TRY;
   
   self = [super init];
   
   if (self) {
      
      self.backgroundColor = UIColor.clearColor;
      
      _open = [[UIButton alloc] initWithFrame:CGRectZero];
      _open.hidden                        = NO;
      _open.backgroundColor               = UIColor.clearColor;
      _open.adjustsImageWhenHighlighted   = YES;
      [_open addTarget:self action:@selector(open) forControlEvents:UIControlEventTouchUpInside];
      [self addSubview:_open];
            
      _close = [[UIButton alloc] initWithFrame:CGRectZero];
      _close.hidden                       = YES;
      _close.backgroundColor              = UIColor.clearColor;
      _close.adjustsImageWhenHighlighted  = YES;
      [_close addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
      [self addSubview:_close];
      
   } /* End if () */
   
   __CATCH(nErr);
   
   return self;
}

- (void)dealloc {
   
   [_open removeFromSuperview];
   _open    = nil;
   
   [_close removeFromSuperview];
   _close   = nil;
   
   __SUPER_DEALLOC;
   
   return;
}

- (void)setFrame:(CGRect)frame {
   
   [super setFrame:frame];
   
   CGRect buttonFrame;
   
   buttonFrame.origin   = CGPointZero;
   buttonFrame.size     = frame.size;
   
   _open.frame    = buttonFrame;
   _close.frame   = buttonFrame;
   
   return;
}

- (void)setImageOpened:(UIImage *)aImage {
   
   [_open setImage:aImage forState:UIControlStateNormal];
   
   return;
}

- (void)setImageClosed:(UIImage *)aImage {
   
   [_close setImage:aImage forState:UIControlStateNormal];
   
   return;
}

- (void)open {
   
   int                            nErr                                     = EFAULT;
   
   __TRY;

   _open.hidden   = YES;
   _close.hidden  = NO;
   
   if ([self.service respondsToSelector:@selector(didDockerOpen)]) {
      
      [self.service didDockerOpen];
      
   } /* End if () */
   
   __CATCH(nErr);
   
   return;
}

- (void)close {
   
   int                            nErr                                     = EFAULT;
   
   __TRY;

   _open.hidden   = NO;
   _close.hidden  = YES;
   
   if ([self.service respondsToSelector:@selector(didDockerClose)]) {
      
      [self.service didDockerClose];
      
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

TEST_CASE(Service, DockerView)

DESCRIBE(before) {
}

DESCRIBE(after) {
}

TEST_CASE_END

#endif  // #if __SAMURAI_TESTING__

#import "__pragma_pop.h"
