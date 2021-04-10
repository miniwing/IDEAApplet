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

#import "UIViewController+NavigationBar.h"

#import "__pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#pragma mark -

@implementation UIViewController(NavigationBar)

@def_prop_dynamic( BOOL ,  navigationBarShown );
@def_prop_dynamic( id   ,  navigationBarTitle );
@def_prop_dynamic( id   ,  navigationBarBackButton );
@def_prop_dynamic( id   ,  navigationBarDoneButton );

#pragma mark -

- (void)onBackPressed {
   
   return;
}

- (void)onDonePressed {
   
   return;
}

#pragma mark -

- (void)showNavigationBar {
   
   [self.navigationController setNavigationBarHidden:NO animated:YES];
   
   return;
}

- (void)showNavigationBarAnimated:(BOOL)animated {
   
   [self.navigationController setNavigationBarHidden:NO animated:animated];
   
   return;
}

- (void)hideNavigationBar {
   
   [self.navigationController setNavigationBarHidden:YES animated:YES];
   
   return;
}

- (void)hideNavigationBarAnimated:(BOOL)animated {
   
   [self.navigationController setNavigationBarHidden:YES animated:animated];
   
   return;
}

- (BOOL)navigationBarShown {
   
   return self.navigationController.navigationBarHidden ? NO : YES;
}

- (void)setNavigationBarShown:(BOOL)flag {
   
   if ( [self isViewLoaded] && self.view.window ) {
      
      if ( flag ) {
         
         [self showNavigationBarAnimated:YES];
      }
      else {
         
         [self hideNavigationBarAnimated:YES];
      }
   }
   else {
      
      if ( flag ) {
         
         [self showNavigationBarAnimated:NO];
      }
      else {
         
         [self hideNavigationBarAnimated:NO];
      }
   }
   
   return;
}

#pragma mark -

- (id)navigationBarTitle {
   
   return self.navigationItem.titleView ?: self.navigationItem.title;
}

- (void)setNavigationBarTitle:(id)content {
   
   if ( content ) {
      
      if ( [content isKindOfClass:[NSString class]] ) {
         
         self.navigationItem.titleView = nil;
         self.navigationItem.title = content;
      }
      else if ( [content isKindOfClass:[UIImage class]] ) {
         
         UIImageView * imageView = [[UIImageView alloc] initWithImage:content];
         imageView.contentMode = UIViewContentModeScaleAspectFit;
         imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

         self.navigationItem.title = nil;
         self.navigationItem.titleView = imageView;
      }
      else if ( [content isKindOfClass:[UIView class]] ) {
         
         self.navigationItem.title = nil;
         self.navigationItem.titleView = content;
      }
      else {
         
         self.navigationItem.titleView = nil;
         self.navigationItem.title = nil;         
      }
   }
   else {
      self.navigationItem.titleView = nil;
      self.navigationItem.title = nil;
   }
   
   return;
}

- (id)navigationBarBackButton {
   
    return self.navigationItem.leftBarButtonItem.customView;
}

- (void)setNavigationBarBackButton:(id)content {
   
   self.navigationItem.leftBarButtonItem = [self createBarButtonItemForContent:content action:@selector(onBackPressed)];
   
   return;
}

- (id)navigationBarDoneButton {
   
    return self.navigationItem.rightBarButtonItem;
}

- (void)setNavigationBarDoneButton:(id)content {
   
   self.navigationItem.rightBarButtonItem = [self createBarButtonItemForContent:content action:@selector(onDonePressed)];
   
   return;
}

#pragma mark -

- (UIBarButtonItem *)createBarButtonItemForContent:(id)aContent action:(SEL)aAction {
   
   UIBarButtonItem   *stBarButtonItem  = nil;
   
   if ( aContent ) {
      
      if ( [aContent isKindOfClass:[NSString class]] ) {
         
         stBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:aContent style:UIBarButtonItemStylePlain target:self action:aAction];
      }
      else if ( [aContent isKindOfClass:[UIImage class]] ) {
         
         stBarButtonItem = [[UIBarButtonItem alloc] initWithImage:aContent style:UIBarButtonItemStylePlain target:self action:aAction];
      }
      else if ( [aContent isKindOfClass:[NSNumber class]] ) {
         
         stBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:[aContent intValue] target:self action:aAction];
      }
      else if ( [aContent isKindOfClass:[UIView class]] ) {
         
         stBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:aContent];
      }
   }
   
   if ( stBarButtonItem ) {
      
      if ( stBarButtonItem.width < 64.0f ) {
         
         stBarButtonItem.width = 64.0f;
      }
   }
   
   return stBarButtonItem;
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( UI, UIViewController_NavigationBar )

DESCRIBE( before ) {
}

DESCRIBE( after ) {
}

TEST_CASE_END

#endif   // #if __SAMURAI_TESTING__

#endif   // #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
