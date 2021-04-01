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

#import "IDEAAppletNotificationCenter.h"
#import "IDEAAppletNotificationBus.h"

#import "__pragma_push.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark - 

@implementation IDEAAppletNotificationCenter {
   
   NSMutableDictionary * _map;
}

@def_singleton( IDEAAppletNotificationCenter )

- (id)init {
   
   self = [super init];
   if ( self ) {
      
      _map = [[NSMutableDictionary alloc] init];
      
   } /* End if () */
   
   return self;
}

- (void)dealloc {
   
   [_map removeAllObjects];
   _map = nil;
   
   __SUPER_DEALLOC;
   
   return;
}

#pragma mark -

- (void)postNotification:(NSString *)aName {
   
   [self postNotification:aName object:nil];
   
   return;
}

- (void)postNotification:(NSString *)aName object:(id)aObject {
   
   INFO( @"Notification '%@'", [name stringByReplacingOccurrencesOfString:@"notification." withString:@""] );
   
   [[NSNotificationCenter defaultCenter] postNotificationName:aName object:aObject];
   
   return;
}

- (void)addObserver:(id)aObserver forNotification:(NSString *)aName {
   
   if ( nil == aObserver ) {
      
      return;
      
   } /* End if () */
   
   [[NSNotificationCenter defaultCenter] removeObserver:self name:aName object:nil];
   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:aName object:nil];
   
   NSMutableArray *stObservers   = [_map objectForKey:aName];
   
   if ( nil == stObservers ) {
      
      stObservers = [NSMutableArray nonRetainingArray];
      
      [_map setObject:stObservers forKey:aName];
      
   } /* End if () */
   
   if ( NO == [stObservers containsObject:aObserver] ) {
      
      [stObservers addObject:aObserver];
      
   } /* End if () */
   
   return;
}

- (void)removeObserver:(id)aObserver forNotification:(NSString *)aName {
   
   NSMutableArray * observers = [_map objectForKey:aName];
   
   if ( observers ) {
      
      [observers removeObject:aObserver];
      
   } /* End if () */
   
   if ( nil == observers || 0 == observers.count ) {
      
      [_map removeObjectForKey:aName];
      
      [[NSNotificationCenter defaultCenter] removeObserver:self name:aName object:nil];
      
   } /* End if () */
   
   return;
}

- (void)removeObserver:(id)aObserver {
   
   for ( NSMutableArray * observers in _map.allValues ) {
      
      [observers removeObject:aObserver];
      
   } /* End for () */
   
   [[NSNotificationCenter defaultCenter] removeObserver:aObserver];
   
   return;
}

- (void)handleNotification:(AppletNotification *)aNotification {
   
   NSMutableArray *stObservers   = [_map objectForKey:aNotification.name];
   
   if ( stObservers && stObservers.count ) {
      
      for ( NSObject * observer in stObservers ) {
         
         [[IDEAAppletNotificationBus sharedInstance] routes:aNotification target:observer];
         
      } /* End for () */
      
   } /* End if () */
   
   return;
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( Event, NotificationCenter )

DESCRIBE( before ) {
   
}

DESCRIBE( after ) {
   
}

TEST_CASE_END

#endif   // #if __SAMURAI_TESTING__

#import "__pragma_pop.h"
