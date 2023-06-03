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

#import "UIViewcontroller+TemplateLoading.h"

#import "__pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation UIViewController(TemplateLoading)

- (void)loadTemplate {
   
   self._template  = [[IDEAAppletTemplate alloc] init];
   self._template.responder = self;
   
   [self._template loadClass:[self class]];
   
   return;
}

- (void)unloadTemplate {
   
   [self._template stopLoading];
   [self._template.document.renderTree unbindOutletsFrom:self];
   
   self._template.responder = nil;
   self._template  = nil;
   
   return;
}

- (void)handleTemplate:(IDEAAppletTemplate *)aTemplate {
   
   ASSERT( aTemplate == self._template );
   
   if ( aTemplate.loading ) {
      
   #if __SAMURAI_UI_USE_CALLCHAIN__
      [self performCallChainWithSelector:@selector(onTemplateLoading) reversed:YES];
   #else   // #if __SAMURAI_UI_USE_CALLCHAIN__
      [self onTemplateLoading];
   #endif   // #if __SAMURAI_UI_USE_CALLCHAIN__
      
   } /* End if () */
   else if ( aTemplate.loaded ) {
      
      if ( aTemplate.document.renderTree ) {
         
         UIView   *stRootView = [self._template.document.renderTree createViewWithIdentifier:nil];
         
         if ( stRootView ) {
            
            if ( [self isViewLoaded] ) {
               
               stRootView.frame = self.view.frame;
               
               if ( [self.view isKindOfClass:[UIScrollView class]] ) {
                  
                  __unsafe_unretained UIScrollView *stLeftView    = (UIScrollView *)stRootView;
                  __unsafe_unretained UIScrollView *stRightView   = (UIScrollView *)self.view;
                  
                  stLeftView.bounces      = stRightView.bounces;
                  stLeftView.contentSize  = stRightView.contentSize;
                  stLeftView.contentInset = stRightView.contentInset;
                  stLeftView.contentOffset= stRightView.contentOffset;
                  stLeftView.alwaysBounceVertical  = stRightView.alwaysBounceVertical;
                  stLeftView.alwaysBounceHorizontal= stRightView.alwaysBounceHorizontal;
                  stLeftView.pagingEnabled   = stRightView.pagingEnabled;
                  stLeftView.scrollEnabled   = stRightView.scrollEnabled;
                  stLeftView.showsHorizontalScrollIndicator = stRightView.showsHorizontalScrollIndicator;
                  stLeftView.showsVerticalScrollIndicator   = stRightView.showsVerticalScrollIndicator;
                  stLeftView.scrollIndicatorInsets = stRightView.scrollIndicatorInsets;
                  stLeftView.indicatorStyle  = stRightView.indicatorStyle;
                  stLeftView.decelerationRate= stRightView.decelerationRate;
                  
               } /* End if () */
               
            } /* End if () */

            self.view = stRootView;
            
            [self._template.document.renderTree bindOutletsTo:self];
            
         } /* End if () */
         else {
            
            [self._template.document.renderTree unbindOutletsFrom:self];
            
         } /* End else */
      }
      else {
         
         if ( [self isViewLoaded] ) {
            
            self.view.renderer = nil;
            self.view = nil;
            
         } /* End if () */
         
      } /* End else */
      
      [self._template.document configureForViewController:self];
      [self._template.document.renderTree rechain];

   #if __SAMURAI_UI_USE_CALLCHAIN__
      [self performCallChainWithSelector:@selector(onTemplateLoaded) reversed:YES];
   #else   // #if __SAMURAI_UI_USE_CALLCHAIN__
      [self onTemplateLoaded];
   #endif   // #if __SAMURAI_UI_USE_CALLCHAIN__
   } /* End else if () */
   else if ( aTemplate.failed ) {
      
   #if __SAMURAI_UI_USE_CALLCHAIN__
      [self performCallChainWithSelector:@selector(onTemplateFailed) reversed:YES];
   #else   // #if __SAMURAI_UI_USE_CALLCHAIN__
      [self onTemplateFailed];
   #endif   // #if __SAMURAI_UI_USE_CALLCHAIN__
      
   } /* End else if () */
   else if ( aTemplate.cancelled ) {
      
   #if __SAMURAI_UI_USE_CALLCHAIN__
      [self performCallChainWithSelector:@selector(onTemplateCancelled) reversed:YES];
   #else   // #if __SAMURAI_UI_USE_CALLCHAIN__
      [self onTemplateCancelled];
   #endif   // #if __SAMURAI_UI_USE_CALLCHAIN__
      
   } /* End else if () */
   
   return;
}

#pragma mark -

- (void)onTemplateLoading {
   
   return;
}

- (void)onTemplateLoaded {
   
   [self relayout];

   return;
}

- (void)onTemplateFailed {
   
   [self relayout];

   return;
}

- (void)onTemplateCancelled {
   
   [self relayout];

   return;
}

#pragma mark -

- (void)rechain {
   
   if ( [self isViewLoaded] ) {
      
      if ( self._template ) {
         
         if ( self._template.document && self._template.document.renderTree ) {
            [self._template.document.renderTree rechain];
         }
      }
   }

   return;
}

- (void)relayout {
   
   if ( [self isViewLoaded] ) {
      
      CGSize viewSize = self.view.frame.size;
      
      if ( CGSizeEqualToSize( viewSize, CGSizeZero ) ) {
         
         self.view.layer.hidden = YES;
      }
      else {
         
         self.view.layer.hidden = NO;
         
         if ( self._template ) {
            
            if ( self._template.document && self._template.document.renderTree ) {
               
               [self._template.document.renderTree relayout];
            }
         }
      }
   }
   
   return;
}

- (void)restyle {
   
   if ( [self isViewLoaded] ) {
      
      if ( self._template ) {
         
         if ( self._template.document && self._template.document.renderTree ) {
            
            [self._template.document.renderTree restyle];
         }
      }
   }

   return;
}

#pragma mark -

- (NSArray*)keyCommands {
   
   UIKeyCommand   *stCommand  = [UIKeyCommand keyCommandWithInput:@"r"
                                                    modifierFlags:UIKeyModifierCommand
                                                           action:@selector(handleCommandR:)];
   return [NSArray arrayWithObject:stCommand];
}

- (void)handleCommandR:(UIKeyCommand *)aCommand {
   
   int __break = 0;
   
   return;
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( UI, UIViewController_TemplateLoading )

DESCRIBE( before ) {
}

DESCRIBE( after ) {
}

TEST_CASE_END

#endif   // #if __SAMURAI_TESTING__

#endif   // #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "__pragma_pop.h"
