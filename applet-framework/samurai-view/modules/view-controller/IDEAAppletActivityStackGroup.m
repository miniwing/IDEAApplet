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

#import "IDEAAppletActivityStackGroup.h"
#import "IDEAAppletIntent.h"

#import "__pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation UIWindow(ActivityStackGroup)

@def_prop_dynamic( IDEAAppletActivityStackGroup *, rootStackGroup );

- (IDEAAppletActivityStackGroup *)rootStackGroup {
   
   if ( self.rootViewController && [self.rootViewController isKindOfClass:[IDEAAppletActivityStackGroup class]] ) {
      
      return (IDEAAppletActivityStackGroup *)self.rootViewController;
   }
   
   return nil;
}

- (void)setRootStackGroup:(IDEAAppletActivityStackGroup *)group {
   
   self.rootViewController = group;

   return;
}

@end

#pragma mark -

@interface IDEAAppletActivityStackGroupItem : NSObject

@prop_assign( NSUInteger          , order    );
@prop_strong( NSString           *, name     );
@prop_strong( UIViewController   *, instance );
@prop_strong( Class               , classType);

- (id)createInstance;

@end

#pragma mark -

@implementation IDEAAppletActivityStackGroupItem

@def_prop_assign( NSUInteger         , order    );
@def_prop_strong( NSString          *, name     );
@def_prop_strong( UIViewController  *, instance );
@def_prop_strong( Class              , classType);

- (id)init {
   
   self = [super init];
   if ( self ) {
      
   }
   
   return self;
}

- (void)dealloc {
   
   self.name      = nil;
   self.instance  = nil;
   self.classType = nil;
   
   __SUPER_DEALLOC;
   
   return;
}

- (id)createInstance {
   
   if ( nil == self.instance ) {
      
      self.instance = [[self.classType alloc] init];
      
   }
   
   return self.instance;
}

@end

#pragma mark -

@implementation IDEAAppletActivityStackGroup {
   
   NSString             * _name;
   NSMutableDictionary  * _mapping;
}

BASE_CLASS( IDEAAppletActivityStackGroup )

@def_prop_dynamic( IDEAAppletActivity *,      activity );
@def_prop_dynamic( IDEAAppletActivityStack *,   stack );

+ (IDEAAppletActivityStackGroup *)stackGroup {
   
   return [[self alloc] init];
}

- (id)init {
   
   self = [super init];
   if ( self ) {
      
      _name = nil;
      _mapping = [[NSMutableDictionary alloc] init];
      
   } /* End if () */
   
   return self;
}

- (void)dealloc {
   
   _name    = nil;
   
   [_mapping removeAllObjects];
   _mapping = nil;
   
   __SUPER_DEALLOC;
   
   return;
}

#pragma mark -

- (IDEAAppletActivity *)activity {
   
   if ( nil == _name ) {
      return nil;
   }
   
   IDEAAppletActivityStackGroupItem * item = [_mapping objectForKey:_name];
   if ( nil == item || nil == item.instance ) {
      return nil;
   }
   
   if ( NO == [item.instance isKindOfClass:[IDEAAppletActivity class]] ) {
      return nil;
   }
   
   return (IDEAAppletActivity *)item.instance;
}

- (IDEAAppletActivityStack *)stack {
   
   if ( nil == _name ) {
      return nil;
   }
   
   IDEAAppletActivityStackGroupItem * item = [_mapping objectForKey:_name];
   if ( nil == item || nil == item.instance ) {
      return nil;
   }
   
   if ( NO == [item.instance isKindOfClass:[IDEAAppletActivityStack class]] ) {
      return nil;
   }
   
   return (IDEAAppletActivityStack *)item.instance;
}

#pragma mark -

- (void)map:(NSString *)name forClass:(Class)classType {
   
   INFO( @"StackGroup '%p', map '%@'", self, name );
   
   if ( nil == name || nil == classType ) {
      return;
   }
   
   IDEAAppletActivityStackGroupItem * item = [_mapping objectForKey:name];
   if ( nil == item ) {
      
      item = [[IDEAAppletActivityStackGroupItem alloc] init];
      
      item.order = _mapping.count;
      item.name = name;
      item.classType = classType;
      
      [_mapping setObject:item forKey:name];
      
   } /* End if () */
   
   return;
}

- (void)map:(NSString *)name forActivity:(IDEAAppletActivity *)activity {
   
   INFO( @"StackGroup '%p', map '%@'", self, name );
   
   if ( nil == name || nil == activity ) {
      return;
   }
   
   IDEAAppletActivityStackGroupItem * item = [_mapping objectForKey:name];
   if ( nil == item ) {
      
      item = [[IDEAAppletActivityStackGroupItem alloc] init];
      
      item.order = _mapping.count;
      item.name = name;
      item.instance = activity;
      
      [_mapping setObject:item forKey:name];
   }
   
   return;
}

- (void)map:(NSString *)name forActivityStack:(IDEAAppletActivityStack *)activityStack {
   
   INFO( @"StackGroup '%p', map '%@'", self, name );
   
   if ( nil == name || nil == activityStack ) {
      return;
   }
   
   IDEAAppletActivityStackGroupItem * item = [_mapping objectForKey:name];
   if ( nil == item ) {
      
      item = [[IDEAAppletActivityStackGroupItem alloc] init];
      
      item.order = _mapping.count;
      item.name = name;
      item.instance = activityStack;
      
      [_mapping setObject:item forKey:name];
   }
   
   return;
}

- (BOOL)open:(NSString *)name {
   
   INFO( @"StackGroup '%p', open '%@'", self, name );
   
   if ( 0 == name.length ) {
      return NO;
   }
   
   if ( _name && [_name isEqualToString:name] ) {
      return NO;
   }
   
   IDEAAppletActivityStackGroupItem * prevItem = _name ? [_mapping objectForKey:_name] : nil;
   IDEAAppletActivityStackGroupItem * currItem = [_mapping objectForKey:name];
   
   if ( prevItem == currItem ) {
      return NO;
   }
   
   CATransition * transition = [CATransition animation];
   [transition setDuration:0.3f];
   [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
   [transition setType:kCATransitionFade];
   [self.view.layer addAnimation:transition forKey:nil];
   
   for ( IDEAAppletActivityStackGroupItem * item in _mapping.allValues ) {
      
      if ( NO == [item.name isEqualToString:name] ) {
         
         UIViewController * controller = (UIViewController *)item.instance;
         if ( controller ) {
            
            [controller.view setHidden:YES];
         }
      }
   }
   
   //   if ( prevItem )
   //   {
   //      UIViewController * prevController = (UIViewController *)prevItem.instance;
   //      if ( prevController )
   //      {
   //         [prevController viewWillDisappear:NO];
   //         [prevController viewDidDisappear:NO];
   //      }
   //   }
   
   _name = name;
   
   if ( currItem ) {
      
      UIViewController * currController = (UIViewController *)[currItem createInstance];
      if ( currController ) {
         
         if ( currController.view != self.view ) {
            
            //            [currController.view removeFromSuperview];
            [self.view addSubview:currController.view];
         }
         
         //         [currController viewWillAppear:NO];
         //         [currController viewDidAppear:NO];
      }
   }
   
   //   [self viewWillAppear:NO];
   //   [self viewDidAppear:NO];
   
   return YES;
}

#pragma mark -

- (void)setView:(UIView *)newView {
   
   [super setView:newView];
   
   if ( IOS7_OR_LATER ) {
      
      self.edgesForExtendedLayout                        = UIRectEdgeNone;
      self.extendedLayoutIncludesOpaqueBars              = NO;
      self.modalPresentationCapturesStatusBarAppearance  = NO;
      self.automaticallyAdjustsScrollViewInsets          = YES;
   }
   
   self.view.userInteractionEnabled = YES;
   self.view.backgroundColor        = UIColor.whiteColor;
   self.view.autoresizingMask       = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
   
   return;
}

- (void)loadView {
   
   [super loadView];
   
   self.view.backgroundColor = UIColor.whiteColor;
   
   return;
}

- (void)viewDidLoad {
   
   [super viewDidLoad];
   
   return;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
   
   [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
   
   for ( IDEAAppletActivityStackGroupItem * item in _mapping.allValues ) {
      
      UIViewController * controller = (UIViewController *)item.instance;
      if ( controller ) {
         
         controller.view.frame = self.view.bounds;
         [controller willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
      }
   }

   return;
}

- (void)viewWillLayoutSubviews {
   
   [super viewWillLayoutSubviews];

   return;
}

- (void)viewDidLayoutSubviews {
   
   [super viewDidLayoutSubviews];
   
   for ( IDEAAppletActivityStackGroupItem * item in _mapping.allValues ) {
      
      UIViewController * controller = (UIViewController *)item.instance;
      if ( controller && [controller isViewLoaded] ) {
         
         controller.view.frame = self.view.bounds;
         [controller viewDidLayoutSubviews];
      }
   }

   return;
}

- (void)viewWillAppear:(BOOL)animated {
   
   [super viewWillAppear:animated];
   
   for ( IDEAAppletActivityStackGroupItem * item in _mapping.allValues ) {
      
      UIViewController * controller = (UIViewController *)item.instance;
      if ( controller && [controller isViewLoaded] ) {
         
         [controller viewWillAppear:animated];
      }
   }

   return;
}

- (void)viewDidAppear:(BOOL)animated {
   
   [super viewDidAppear:animated];
   
   for ( IDEAAppletActivityStackGroupItem * item in _mapping.allValues ) {
      
      UIViewController * controller = (UIViewController *)item.instance;
      if ( controller && [controller isViewLoaded] ) {
         
         [controller viewDidAppear:animated];
      }
   }

   return;
}

- (void)viewWillDisappear:(BOOL)animated {
   
   [super viewWillDisappear:animated];
   
   for ( IDEAAppletActivityStackGroupItem * item in _mapping.allValues ) {
      
      UIViewController * controller = (UIViewController *)item.instance;
      if ( controller && [controller isViewLoaded] ) {
         
         [controller viewWillDisappear:animated];
      }
   }

   return;
}

- (void)viewDidDisappear:(BOOL)animated {
   
   [super viewDidDisappear:animated];
   
   for ( IDEAAppletActivityStackGroupItem * item in _mapping.allValues ) {
      
      UIViewController * controller = (UIViewController *)item.instance;
      if ( controller && [controller isViewLoaded] ) {
         
         [controller viewDidDisappear:animated];
      }
   }

   return;
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( UI, ActivityStackGroup )

DESCRIBE( before ) {
   
}

DESCRIBE( after ) {
   
}

TEST_CASE_END

#endif   // #if __SAMURAI_TESTING__

#endif   // #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "__pragma_pop.h"
