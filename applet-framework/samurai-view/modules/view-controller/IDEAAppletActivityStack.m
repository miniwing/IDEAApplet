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

- (IDEAAppletActivityStack *)rootStack
{
   if ( self.rootViewController && [self.rootViewController isKindOfClass:[IDEAAppletActivityStack class]] )
   {
      return (IDEAAppletActivityStack *)self.rootViewController;
   }
   
   return nil;
}

- (void)setRootStack:(IDEAAppletActivityStack *)activityStack
{
   self.rootViewController = activityStack;
}

@end

#pragma mark -

@implementation UIViewController(ActivityStack)

- (IDEAAppletActivityStack *)stack
{
   if ( [self isKindOfClass:[IDEAAppletActivityStack class]] )
   {
      return (IDEAAppletActivityStack *)self;
   }
   else
   {
      return (IDEAAppletActivityStack *)self.navigationController;
   }
}

#pragma mark -

- (void)startActivity:(IDEAAppletActivity *)activity
{
   if ( nil == activity )
      return;

   if ( self.navigationController )
   {
      [self.navigationController pushViewController:activity animated:YES];
   }
}

- (void)startActivity:(IDEAAppletActivity *)activity params:(NSDictionary *)params
{
   if ( nil == activity )
      return;
   
   if ( params && params.count )
   {
      IDEAAppletIntent * intent = [IDEAAppletIntent intent];
      [intent.input setDictionary:params];
      activity.intent = intent;
   }
   
   if ( self.navigationController )
   {
      [self.navigationController pushViewController:activity animated:YES];
   }
}

- (void)startActivity:(IDEAAppletActivity *)activity intent:(IDEAAppletIntent *)intent
{
   if ( nil == activity )
      return;
   
   if ( intent )
   {
      activity.intent = intent;
   }

   if ( self.navigationController )
   {
      [self.navigationController pushViewController:activity animated:YES];
   }
}

#pragma mark -

- (void)presentActivity:(IDEAAppletActivity *)activity
{
   if ( nil == activity )
      return;
   
   [self presentViewController:activity animated:YES completion:nil];
}

- (void)presentActivity:(IDEAAppletActivity *)activity params:(NSDictionary *)params
{
   if ( nil == activity )
      return;
   
   if ( params && params.count )
   {
      IDEAAppletIntent * intent = [IDEAAppletIntent intent];
      [intent.input setDictionary:params];
      activity.intent = intent;
   }
   
   [self presentViewController:activity animated:YES completion:nil];
}

- (void)presentActivity:(IDEAAppletActivity *)activity intent:(IDEAAppletIntent *)intent
{
   if ( nil == activity )
      return;
   
   if ( intent )
   {
      activity.intent = intent;
   }
   
   [self presentViewController:activity animated:YES completion:nil];
}

#pragma mark -

- (void)startURL:(NSString *)url, ...
{
   if ( url && url.length )
   {
      va_list args;
      va_start( args, url );
      
      url = [[NSString alloc] initWithFormat:url arguments:args];
      
      va_end( args );
   }
   
   [self startURL:url intent:nil callback:nil];
}

- (void)startURL:(NSString *)url callback:(IntentCallback)callback
{
   [self startURL:url intent:nil callback:callback];
}

- (void)startURL:(NSString *)url params:(NSDictionary *)params
{
   IDEAAppletIntent * intent = [IDEAAppletIntent intent:nil params:params];
   
   [self startURL:url intent:intent callback:nil];
}

- (void)startURL:(NSString *)url intent:(IDEAAppletIntent *)intent
{
   [self startURL:url intent:intent callback:nil];
}

- (void)startURL:(NSString *)urlString intent:(IDEAAppletIntent *)intent callback:(IntentCallback)callback
{
   IDEAAppletActivity * activity = [self makeActivityWithURL:urlString intent:intent callback:callback];
   
   if ( activity )
   {
      [self startActivity:activity intent:intent];
   }
}

#pragma mark -

- (void)presentURL:(NSString *)url, ...
{
   if ( url && url.length )
   {
      va_list args;
      va_start( args, url );
      
      url = [[NSString alloc] initWithFormat:url arguments:args];
      
      va_end( args );
   }
   
   [self presentURL:url intent:nil callback:nil];
}

- (void)presentURL:(NSString *)url params:(NSDictionary *)params
{
   IDEAAppletIntent * intent = [IDEAAppletIntent intent:nil params:params];
   
   [self presentURL:url intent:intent callback:nil];
}

- (void)presentURL:(NSString *)url intent:(IDEAAppletIntent *)intent
{
   [self presentURL:url intent:intent callback:nil];
}

- (void)presentURL:(NSString *)url callback:(IntentCallback)callback
{
   [self presentURL:url intent:nil callback:callback];
}

- (void)presentURL:(NSString *)urlString intent:(IDEAAppletIntent *)intent callback:(IntentCallback)callback
{
   IDEAAppletActivity * activity = [self makeActivityWithURL:urlString intent:intent callback:callback];
   
   if ( activity )
   {
      [self presentActivity:activity intent:intent];
   }
}

#pragma mark -

- (IDEAAppletActivity *)makeActivityWithURL:(NSString *)urlString intent:(IDEAAppletIntent *)intent callback:(IntentCallback)callback
{
   if ( nil == urlString || 0 == urlString.length )
   {
      ERROR( @"Activity stack, empty url" );
      return nil;
   }
   
   NSURL * url = [NSURL URLWithString:urlString];
   if ( nil == url )
   {
      ERROR( @"Activity stack, invalid url '%@'", urlString );
      return nil;
   }
   
   NSString * resource = url.path;
   NSString * fragment = url.fragment;
   NSString * query = url.query;
   
   resource = [resource hasPrefix:@"/"] ? [resource substringFromIndex:1] : resource;
   resource = [resource hasSuffix:@"/"] ? [resource substringToIndex:resource.length - 1] : resource;
   
   IDEAAppletActivity * activity = [[IDEAAppletActivityRouter sharedInstance] activityForURL:resource];
   if ( nil == activity )
   {
      resource = [NSString stringWithFormat:@"/%@", resource];
      activity = [[IDEAAppletActivityRouter sharedInstance] activityForURL:resource];
      
      ERROR( @"Activity router, invalid url '%@'", url );
      return nil;
   }
   
   if ( fragment )
   {
      if ( nil == intent )
      {
         intent = [IDEAAppletIntent intent];
      }
      
      intent.action = fragment;
   }
   
   if ( callback )
   {
      if ( nil == intent )
      {
         intent = [IDEAAppletIntent intent];
      }
      
      @weakify( intent );
      
      intent.stateChanged = ^
      {
         @strongify( intent );
         
         callback( intent );
      };
   }
   
   if ( query )
   {
      if ( nil == intent )
      {
         intent = [IDEAAppletIntent intent];
      }
      
      NSArray * pairs = [query componentsSeparatedByString:@"&"];
      
      for ( NSString * string in pairs )
      {
         NSArray * pair = [string componentsSeparatedByString:@"="];
         
         if ( pair && pair.count )
         {
            NSString * key = [pair safeObjectAtIndex:0];
            NSString * value = [pair safeObjectAtIndex:1];
            
            [intent setObject:value forKey:key];
         }
      }
   }
   
   return activity;
}

@end

#pragma mark -

@implementation IDEAAppletActivityStack
{
   BOOL _inited;
}

BASE_CLASS( IDEAAppletActivityStack )

@def_prop_dynamic( NSArray *,         activities );
@def_prop_dynamic( IDEAAppletActivity *,   activity );

#pragma mark -

- (NSArray *)activities
{
   NSMutableArray * array = [NSMutableArray nonRetainingArray];
   
   for ( UIViewController * activity in self.viewControllers )
   {
      if ( [activity isKindOfClass:[IDEAAppletActivity class]] )
      {
         [array addObject:activity];
      }
   }
   
   return array;
}

- (IDEAAppletActivity *)activity
{
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

+ (IDEAAppletActivityStack *)stack
{
   return [[IDEAAppletActivityStack alloc] init];
}

+ (IDEAAppletActivityStack *)stackWithActivity:(IDEAAppletActivity *)activity
{
   return [[IDEAAppletActivityStack alloc] initWithActivity:activity];
}

- (IDEAAppletActivityStack *)initWithActivity:(IDEAAppletActivity *)activity
{
   self = [super initWithNavigationBarClass:nil toolbarClass:nil];
   if ( self )
   {
      self.navigationBarHidden = NO;
      self.view.backgroundColor = [UIColor whiteColor];
      self.viewControllers = [NSArray arrayWithObject:activity];
   }
   return self;
}

- (void)pushActivity:(IDEAAppletActivity *)activity animated:(BOOL)animated
{
   if ( nil == activity )
      return;

//   if ( activity.view )
//   {
      [self pushViewController:activity animated:animated];
//   }
}

- (void)popActivityAnimated:(BOOL)animated
{
   [self popViewControllerAnimated:animated];
}

- (void)popToActivity:(IDEAAppletActivity *)activity animated:(BOOL)animated
{
   if ( nil == activity )
      return;
   
   [self popToViewController:activity animated:animated];
}

- (void)popToFirstActivityAnimated:(BOOL)animated
{
   [self popToViewController:self.topViewController animated:animated];
}

- (void)popAllActivities
{
   self.viewControllers = [NSArray array];
}

#pragma mark -

- (void)setView:(UIView *)newView
{
   [super setView:newView];
   
   if ( IOS7_OR_LATER )
   {
      self.edgesForExtendedLayout = UIRectEdgeNone;
      self.extendedLayoutIncludesOpaqueBars = NO;
      self.modalPresentationCapturesStatusBarAppearance = NO;
      self.automaticallyAdjustsScrollViewInsets = YES;
   }
   
   self.view.userInteractionEnabled = YES;
   self.view.backgroundColor = [UIColor whiteColor];
   self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

- (void)loadView
{
   [super loadView];
   
   self.view.backgroundColor = [UIColor whiteColor];
//   self.navigationController.navigationBar.clipsToBounds = YES;
}

- (void)viewDidLoad
{
   [super viewDidLoad];
}

- (void)viewWillLayoutSubviews
{
   [super viewWillLayoutSubviews];
}

- (void)viewDidLayoutSubviews
{
   [super viewDidLayoutSubviews];
   
   if ( self.topViewController )
   {
//      if ( [self.topViewController isViewLoaded] )
//      {
//         self.topViewController.view.frame = self.view.bounds;
//      }

      [self.topViewController viewDidLayoutSubviews];
   }
}

- (void)viewWillAppear:(BOOL)animated
{
   [super viewWillAppear:animated];
   
   if ( self.topViewController )
   {
//      if ( [self.topViewController isViewLoaded] )
//      {
//         self.topViewController.view.frame = self.view.bounds;
//      }

      [self.topViewController viewWillAppear:animated];
   }
   
   [self setNeedsStatusBarAppearanceUpdate];
}

- (void)viewDidAppear:(BOOL)animated
{
   [super viewDidAppear:animated];
   
   if ( self.topViewController )
   {
//      if ( [self.topViewController isViewLoaded] )
//      {
//         self.topViewController.view.frame = self.view.bounds;
//      }

      [self.topViewController viewDidAppear:animated];
   }
}

- (void)viewWillDisappear:(BOOL)animated
{
   [super viewWillDisappear:animated];
   
   if ( self.topViewController )
   {
      [self.topViewController viewWillDisappear:animated];
   }
}

// Called after the view was dismissed, covered or otherwise hidden. Default does nothing
- (void)viewDidDisappear:(BOOL)animated
{
   [super viewDidDisappear:animated];
   
   if ( self.topViewController )
   {
      [self.topViewController viewDidDisappear:animated];
   }
}

#pragma mark -

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
   return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
   return UIInterfaceOrientationMaskAll;
}

- (BOOL)shouldAutorotate
{
   return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
   if ( self.topViewController )
   {
//      if ( [self.topViewController isViewLoaded] )
//      {
//         self.topViewController.view.frame = self.view.bounds;
//      }
      
      [self.topViewController willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
   }
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
   if ( self.topViewController )
   {
//      if ( [self.topViewController isViewLoaded] )
//      {
//         self.topViewController.view.frame = self.view.bounds;
//      }

      [self.topViewController didRotateFromInterfaceOrientation:fromInterfaceOrientation];
   }
}

#pragma mark -

- (BOOL)prefersStatusBarHidden
{
   return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
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

DESCRIBE( before )
{
}

DESCRIBE( after )
{
}

TEST_CASE_END

#endif   // #if __SAMURAI_TESTING__

#endif   // #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "__pragma_pop.h"
