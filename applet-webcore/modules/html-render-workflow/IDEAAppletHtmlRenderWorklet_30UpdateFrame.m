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

#import "IDEAAppletHtmlRenderWorklet_30UpdateFrame.h"

#import "__pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "IDEAAppletHtmlRenderObject.h"
#import "IDEAAppletHtmlRenderStyle.h"
#import "IDEAAppletHtmlUserAgent.h"

#import "IDEAAppletCSSParser.h"
#import "IDEAAppletCSSStyleSheet.h"
#import "IDEAAppletCSSMediaQuery.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation IDEAAppletHtmlRenderWorklet_30UpdateFrame

- (BOOL)processWithContext:(IDEAAppletHtmlRenderObject *)aRenderObject {
   
   if ( NO == CGSizeEqualToSize( aRenderObject.view.frame.size, CGSizeZero ) ) {
      
      aRenderObject.layout.bounds   = aRenderObject.view.frame.size,
      aRenderObject.layout.origin   = aRenderObject.view.frame.origin;
      aRenderObject.layout.stretch  = CGSizeMake( INVALID_VALUE, INVALID_VALUE );
      aRenderObject.layout.collapse = UIEdgeInsetsZero;
      
      if ( [aRenderObject.layout begin:YES] ) {
         
         [aRenderObject.layout layout];
         [aRenderObject.layout finish];
         
      } // if ( [aRenderObject.layout begin:YES] )
      
      if ( NO == CGRectEqualToRect( aRenderObject.layout.computedBounds, CGRectZero ) ) {
         
         [self applyViewFrameForRender:aRenderObject];
         
      } // if ( NO == CGRectEqualToRect( aRenderObject.layout.computedBounds, CGRectZero ) )
      else {
         
         [self clearViewFrameForRender:aRenderObject];
         
      } /* End else */
      
#if __SAMURAI_DEBUG__
      [renderObject dump];
#endif   // #if __SAMURAI_DEBUG__
      
   } // if ( NO == CGSizeEqualToSize( aRenderObject.view.frame.size, CGSizeZero ) )
   
   return YES;
}

#pragma mark -

- (void)applyViewFrameForRender:(IDEAAppletHtmlRenderObject *)aRenderObject {
   
   if ( aRenderObject.view ) {
      
      DEBUG_RENDERER_FRAME( aRenderObject );

      [aRenderObject.view html_applyFrame:aRenderObject.layout.frame];
      
      DEBUG_RENDERER_STYLE( aRenderObject );

      [aRenderObject.view html_applyStyle:aRenderObject.style];
      
   } // if ( aRenderObject.view )
   
   for ( IDEAAppletHtmlRenderObject * childRender in aRenderObject.childs ) {
      
      [self applyViewFrameForRender:childRender];
      
   } // for ( IDEAAppletHtmlRenderObject * childRender in aRenderObject.childs )
   
   return;
}

- (void)clearViewFrameForRender:(IDEAAppletHtmlRenderObject *)aRenderObject {
   
   if ( aRenderObject.view ) {
      
      [aRenderObject.view html_applyFrame:CGRectZero];
      [aRenderObject.view html_applyStyle:aRenderObject.style];
   }
   
   for ( IDEAAppletHtmlRenderObject * childRender in aRenderObject.childs ) {
      
      [self applyViewFrameForRender:childRender];
   }
   
   return;
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( WebCore, HtmlRenderWorklet_30UpdateFrame )

DESCRIBE( before ) {
   
}

DESCRIBE( after ) {
   
}

TEST_CASE_END

#endif   // #if __SAMURAI_TESTING__

#endif   // #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "__pragma_pop.h"
