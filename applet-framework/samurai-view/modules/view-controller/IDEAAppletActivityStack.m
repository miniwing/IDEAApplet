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

#import "IDEAAppletActivityStack.h"
#import "IDEAAppletActivityRouter.h"
#import "IDEAAppletActivity.h"
#import "IDEAAppletIntent.h"

#import "__pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation UIWindow(ActivityStack)

@def_prop_dynamic( IDEAAppletActivityStack *, rootStack );

- (IDEAAppletActivityStack *)rootStack {
   
   if ( self.rootViewController && [self.rootViewController isKindOfClass:[IDEAAppletActivityStack class]] ) {
      
      return (IDEAAppletActivityStack *)self.rootViewController;
      
   } /* End if () */
   
   return nil;
}

- (void)setRootStack:(IDEAAppletActivityStack *)aActivityStack {
   
   self.rootViewController = aActivityStack;
   
   return;
}

@end

#pragma mark -

@implementation UIViewController(ActivityStack)

- (IDEAAppletActivityStack *)stack {
   
   if ( [self isKindOfClass:[IDEAAppletActivityStack class]] ) {
      
      return (IDEAAppletActivityStack *)self;
      
   } /* End if () */
   else {
      
      return (IDEAAppletActivityStack *)self.navigationController;
      
   } /* End else */
}

#pragma mark -

- (void)startActivity:(IDEAAppletActivity *)aActivity {
   
   if ( nil == aActivity ) {
      
      return;
      
   }  /* End if () */
   
   if ( self.navigationController ) {
      
      [self.navigationController pushViewController:aActivity animated:YES];
      
   } /* End if () */
   
   return;
}

- (void)startActivity:(IDEAAppletActivity *)aActivity params:(NSDictionary *)aParams {
   
   if ( nil == aActivity ) {
      
         return;
      
   } /* End if () */

   if ( aParams && aParams.count ) {
      
      IDEAAppletIntent  *stIntent   = [IDEAAppletIntent intent];
      [stIntent.input setDictionary:aParams];
      aActivity.intent = stIntent;
      
   } /* End if () */
   
   if ( self.navigationController ) {
      
      [self.navigationController pushViewController:aActivity animated:YES];
      
   } /* End if () */
   
   return;
}

- (void)startActivity:(IDEAAppletActivity *)aActivity intent:(IDEAAppletIntent *)aIntent {
   
   if ( nil == aActivity ) {
      
      return;
      
   } /* End if () */
   
   if ( aIntent ) {
      
      aActivity.intent = aIntent;
      
   } /* End if () */
   
   if ( self.navigationController ) {
      
      [self.navigationController pushViewController:aActivity animated:YES];
      
   } /* End if () */
   
   return;
}

#pragma mark -

- (void)presentActivity:(IDEAAppletActivity *)aActivity {
   
   if ( nil == aActivity ) {
      
      return;
      
   } /* End if () */
   
   [self presentViewController:aActivity animated:YES completion:nil];
   
   return;
}

- (void)presentActivity:(IDEAAppletActivity *)aActivity params:(NSDictionary *)aParams {
   
   if ( nil == aActivity )
      return;
   
   if ( aParams && aParams.count ) {
      
      IDEAAppletIntent  *stIntent   = [IDEAAppletIntent intent];
      [stIntent.input setDictionary:aParams];
      aActivity.intent = stIntent;
      
   } /* End if () */
   
   [self presentViewController:aActivity animated:YES completion:nil];
   
   return;
}

- (void)presentActivity:(IDEAAppletActivity *)aActivity intent:(IDEAAppletIntent *)aIntent {
   
   if ( nil == aActivity ) {
      
      return;
      
   } /* End if () */
   
   if ( aIntent ) {
      
      aActivity.intent = aIntent;
      
   } /* End if () */
   
   [self presentViewController:aActivity animated:YES completion:nil];
   
   return;
}

#pragma mark -

- (void)startURL:(NSString *)aURL, ... {
   
   if ( aURL && aURL.length ) {
      
      va_list stArgs;
      va_start( stArgs, aURL );
      
      aURL = [[NSString alloc] initWithFormat:aURL arguments:stArgs];
      
      va_end( stArgs );
      
   } /* End if () */
   
   [self startURL:aURL intent:nil callback:nil];
   
   return;
}

- (void)startURL:(NSString *)aURL callback:(IntentCallback)aCallback {
   
   [self startURL:aURL intent:nil callback:aCallback];
   
   return;
}

- (void)startURL:(NSString *)aURL params:(NSDictionary *)aParams {
   
   IDEAAppletIntent  *stIntent   = [IDEAAppletIntent intent:nil params:aParams];
   
   [self startURL:aURL intent:stIntent callback:nil];
   
   return;
}

- (void)startURL:(NSString *)aURL intent:(IDEAAppletIntent *)aIntent {
   
   [self startURL:aURL intent:aIntent callback:nil];
   
   return;
}

- (void)startURL:(NSString *)aURL intent:(IDEAAppletIntent *)aIntent callback:(IntentCallback)aCallback {
   
   IDEAAppletActivity   *stActivity = [self makeActivityWithURL:aURL intent:aIntent callback:aCallback];
   
   if ( stActivity ) {
      
      [self startActivity:stActivity intent:aIntent];
      
   } /* End if () */
   
   return;
}

#pragma mark -

- (void)presentURL:(NSString *)aURL, ... {
   
   if ( aURL && aURL.length ) {
      
      va_list stArgs;
      va_start( stArgs, aURL );
      
      aURL = [[NSString alloc] initWithFormat:aURL arguments:stArgs];
      
      va_end( stArgs );
      
   } /* End if () */
   
   [self presentURL:aURL intent:nil callback:nil];
   
   return;
}

- (void)presentURL:(NSString *)aURL params:(NSDictionary *)aParams {
   
   IDEAAppletIntent  *stIntent   = [IDEAAppletIntent intent:nil params:aParams];
   
   [self presentURL:aURL intent:stIntent callback:nil];
   
   return;
}

- (void)presentURL:(NSString *)aURL intent:(IDEAAppletIntent *)aIntent {
   
   [self presentURL:aURL intent:aIntent callback:nil];
   
   return;
}

- (void)presentURL:(NSString *)aURL callback:(IntentCallback)aCallback {
   
   [self presentURL:aURL intent:nil callback:aCallback];
   
   return;
}

- (void)presentURL:(NSString *)aURL intent:(IDEAAppletIntent *)aIntent callback:(IntentCallback)aCallback {
   
   IDEAAppletActivity * activity = [self makeActivityWithURL:aURL intent:aIntent callback:aCallback];
   
   if ( activity ) {
      
      [self presentActivity:activity intent:aIntent];
      
   } /* End if () */
   
   return;
}

#pragma mark -

- (IDEAAppletActivity *)makeActivityWithURL:(NSString *)aURL intent:(IDEAAppletIntent *)aIntent callback:(IntentCallback)aCallback {
   
   if ( nil == aURL || 0 == aURL.length ) {
      
      ERROR( @"Activity stack, empty url" );
      
      return nil;
      
   } /* End if () */
   
   NSURL *stURL   = [NSURL URLWithString:aURL];
   if ( nil == stURL ) {
      
      ERROR( @"Activity stack, invalid url '%@'", aURL );
      
      return nil;
      
   } /* End if () */
   
   NSString *szResource = stURL.path;
   NSString *szFragment = stURL.fragment;
   NSString *szQuery    = stURL.query;
   
   szResource = [szResource hasPrefix:@"/"] ? [szResource substringFromIndex:1] : szResource;
   szResource = [szResource hasSuffix:@"/"] ? [szResource substringToIndex:szResource.length - 1] : szResource;
   
   IDEAAppletActivity   *stActivity = [[IDEAAppletActivityRouter sharedInstance] activityForURL:szResource];
   
   if ( nil == stActivity ) {
      
      szResource = [NSString stringWithFormat:@"/%@", szResource];
      stActivity = [[IDEAAppletActivityRouter sharedInstance] activityForURL:szResource];
      
      ERROR( @"Activity router, invalid url '%@'", aURL );
      
      return nil;
      
   } /* End if () */
   
   if ( szFragment ) {
      
      if ( nil == aIntent ) {
         
         aIntent = [IDEAAppletIntent intent];
         
      } /* End if () */
      
      aIntent.action = szFragment;
      
   } /* End if () */
   
   if ( aCallback ) {
      
      if ( nil == aIntent ) {
         
         aIntent = [IDEAAppletIntent intent];
         
      } /* End if () */
      
      @weakify( aIntent );
      
      aIntent.stateChanged = ^ {
         
         @strongify( aIntent );
         
         aCallback( aIntent );
      };
   }
   
   if ( szQuery ) {
      
      if ( nil == aIntent ) {
         
         aIntent = [IDEAAppletIntent intent];
         
      } /* End if () */
      
      NSArray  *stPairs = [szQuery componentsSeparatedByString:@"&"];
      
      for ( NSString *szString in stPairs ) {
         
         NSArray  *stPair = [szString componentsSeparatedByString:@"="];
         
         if ( stPair && stPair.count ) {
            
            NSString *szKey   = [stPair safeObjectAtIndex:0];
            NSString *szValue = [stPair safeObjectAtIndex:1];
            
            [aIntent setObject:szValue forKey:szKey];
            
         } /* End if () */
         
      } /* End for () */
      
   } /* End if () */
   
   return stActivity;
}

@end

#pragma mark -

@implementation IDEAAppletActivityStack {
   
   BOOL _inited;
}

BASE_CLASS( IDEAAppletActivityStack )

@def_prop_dynamic( NSArray *,         activities );
@def_prop_dynamic( IDEAAppletActivity *,   activity );

#pragma mark -

- (NSArray *)activities {
   
   NSMutableArray * array = [NSMutableArray nonRetainingArray];
   
   for ( UIViewController * activity in self.viewControllers ) {
      
      if ( [activity isKindOfClass:[IDEAAppletActivity class]] ) {
         
         [array addObject:activity];
      }
   }
   
   return array;
}

- (IDEAAppletActivity *)activity {
   
   UIViewController * controller = self.topViewController;
   
   if ( nil == controller )
      return nil;
   
   if ( NO == [controller isKindOfClass:[IDEAAppletActivity class]] )
      return nil;
   
   IDEAAppletActivity * board = (IDEAAppletActivity *)controller;
   UNUSED( board.view );
   return board;
}

#pragma mark -

+ (IDEAAppletActivityStack *)stack {
   
   return [[IDEAAppletActivityStack alloc] init];
}

+ (IDEAAppletActivityStack *)stackWithActivity:(IDEAAppletActivity *)activity {
   
   return [[IDEAAppletActivityStack alloc] initWithActivity:activity];
}

- (IDEAAppletActivityStack *)initWithActivity:(IDEAAppletActivity *)activity {
   
   self = [super initWithNavigationBarClass:nil toolbarClass:nil];
   
   if ( self ) {
      
      self.navigationBarHidden = NO;
      self.view.backgroundColor = [UIColor whiteColor];
      self.viewControllers = [NSArray arrayWithObject:activity];
   }
   
   return self;
}

- (void)pushActivity:(IDEAAppletActivity *)activity animated:(BOOL)animated {
   
   if ( nil == activity )
      return;
   
   //   if ( activity.view )
   //   {
   [self pushViewController:activity animated:animated];
   //   }
   
   return;
}

- (void)popActivityAnimated:(BOOL)animated {
   
   [self popViewControllerAnimated:animated];

   return;
}

- (void)popToActivity:(IDEAAppletActivity *)activity animated:(BOOL)animated {
   
   if ( nil == activity ) {
      
      return;
      
   } /* End if () */
   
   [self popToViewController:activity animated:animated];

   return;
}

- (void)popToFirstActivityAnimated:(BOOL)animated {
   
   [self popToViewController:self.topViewController animated:animated];
   
   return;
}

- (void)popAllActivities {
   
   self.viewControllers = [NSArray array];
   
   return;
}

#pragma mark -

- (void)setView:(UIView *)newView {
   
   [super setView:newView];
   
   if ( IOS7_OR_LATER ) {
      
      self.edgesForExtendedLayout                        = UIRectEdgeNone;
      self.extendedLayoutIncludesOpaqueBars              = NO;
      self.modalPresentationCapturesStatusBarAppearance  = NO;
      self.automaticallyAdjustsScrollViewInsets          = YES;
      
   } /* End if () */
   
   self.view.userInteractionEnabled = YES;
   self.view.backgroundColor        = [UIColor whiteColor];
   self.view.autoresizingMask       = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
   
   return;
}

- (void)loadView {
   
   [super loadView];
   
   self.view.backgroundColor = [UIColor whiteColor];
   //   self.navigationController.navigationBar.clipsToBounds = YES;
   
   return;
}

- (void)viewDidLoad {
   
   [super viewDidLoad];
   
   return;
}

- (void)viewWillLayoutSubviews {
   
   [super viewWillLayoutSubviews];
   
   return;
}

- (void)viewDidLayoutSubviews {
   
   [super viewDidLayoutSubviews];
   
   if ( self.topViewController ) {
      
      //      if ( [self.topViewController isViewLoaded] )
      //      {
      //         self.topViewController.view.frame = self.view.bounds;
      //      }
      
      [self.topViewController viewDidLayoutSubviews];
   }

   return;
}

- (void)viewWillAppear:(BOOL)animated {
   
   [super viewWillAppear:animated];
   
   if ( self.topViewController ) {
      
      //      if ( [self.topViewController isViewLoaded] )
      //      {
      //         self.topViewController.view.frame = self.view.bounds;
      //      }
      
      [self.topViewController viewWillAppear:animated];
   }
   
   [self setNeedsStatusBarAppearanceUpdate];

   return;
}

- (void)viewDidAppear:(BOOL)animated {
   
   [super viewDidAppear:animated];
   
   if ( self.topViewController ) {
      
      //      if ( [self.topViewController isViewLoaded] )
      //      {
      //         self.topViewController.view.frame = self.view.bounds;
      //      }
      
      [self.topViewController viewDidAppear:animated];
   }

   return;
}

- (void)viewWillDisappear:(BOOL)animated {
   
   [super viewWillDisappear:animated];
   
   if ( self.topViewController ) {
      
      [self.topViewController viewWillDisappear:animated];
   }

   return;
}

// Called after the view was dismissed, covered or otherwise hidden. Default does nothing
- (void)viewDidDisappear:(BOOL)animated {
   
   [super viewDidDisappear:animated];
   
   if ( self.topViewController ) {
      
      [self.topViewController viewDidDisappear:animated];
   }

   return;
}

#pragma mark -

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
   
   return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
   
   return UIInterfaceOrientationMaskAll;
}

- (BOOL)shouldAutorotate {
   
   return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
   
   if ( self.topViewController ) {
      
      //      if ( [self.topViewController isViewLoaded] )
      //      {
      //         self.topViewController.view.frame = self.view.bounds;
      //      }
      
      [self.topViewController willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
   }

   return;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
   
   if ( self.topViewController ) {
      
      //      if ( [self.topViewController isViewLoaded] )
      //      {
      //         self.topViewController.view.frame = self.view.bounds;
      //      }
      
      [self.topViewController didRotateFromInterfaceOrientation:fromInterfaceOrientation];
   }

   return;
}

#pragma mark -

- (BOOL)prefersStatusBarHidden {
   
   return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
   
   return UIStatusBarStyleLightContent;
}

#pragma mark -

//- (void)handleSignal:(IDEAAppletSignal *)signal
//{
//   [signal forward:self.topViewController];
//}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( UI, ActivityStack )

DESCRIBE( before ) {
   
}

DESCRIBE( after ) {
   
}

TEST_CASE_END

#endif   // #if __SAMURAI_TESTING__

#endif   // #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "__pragma_pop.h"
