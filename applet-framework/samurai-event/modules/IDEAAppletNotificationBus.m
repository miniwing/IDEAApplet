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

//#if __has_feature(objc_arc)
//
//#error "Please add compile option '-fno-objc-arc' for this file in 'Build phases'."
//
//#else

// ----------------------------------
// Private Head Files
#import "AppletCore.h"
// ----------------------------------

#import "IDEAAppletNotificationBus.h"

#import "__pragma_push.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation IDEAAppletNotificationBus {
   
   NSMutableDictionary  * _handlers;
}

@def_singleton( IDEAAppletNotificationBus )

- (id)init {
   
   self = [super init];
   if ( self ) {
      
      _handlers = [[NSMutableDictionary alloc] init];
      
   } /* End if () */
   
   return self;
}

- (void)dealloc {
   
   [_handlers removeAllObjects];
   _handlers = nil;
   
   __SUPER_DEALLOC;
   
   return;
}

- (void)routes:(IDEAAppletNotification *)aNotification target:(id)aTarget {
   
   if ( nil == aTarget ) {
      
      ERROR( @"No notification target" );
      
      return;
      
   } /* End if () */
   
   NSMutableArray *stClasses  = [NSMutableArray nonRetainingArray];
   
   for ( Class stClazz = [aTarget class]; nil != stClazz; stClazz = class_getSuperclass(stClazz) ) {
      
      [stClasses addObject:stClazz];
      
   } /* End if () */
   
   NSString *szNotificationClass    = nil;
   NSString *szNotificationMethod   = nil;
   
   if ( aNotification.name ) {
      
      if ( [aNotification.name hasPrefix:@"notification."] ) {
         
         NSArray  *stArray = [aNotification.name componentsSeparatedByString:@"."];
         
         szNotificationClass = (NSString *)[stArray safeObjectAtIndex:1];
         szNotificationMethod = (NSString *)[stArray safeObjectAtIndex:2];
         
      } /* End if () */
      else {
         
         NSArray  *stArray = [aNotification.name componentsSeparatedByString:@"/"];
         
         szNotificationClass  = (NSString *)[stArray safeObjectAtIndex:0];
         szNotificationMethod = (NSString *)[stArray safeObjectAtIndex:1];
         
         if ( szNotificationMethod ) {
            
            szNotificationMethod = [szNotificationMethod stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
            szNotificationMethod = [szNotificationMethod stringByReplacingOccurrencesOfString:@"." withString:@"_"];
            szNotificationMethod = [szNotificationMethod stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
            
         }  /* End if () */
         
      } /* End else */
      
   } /* End if () */
   
   for ( Class stTargetClass in stClasses ) {
      
      NSString *szCacheName            = [NSString stringWithFormat:@"%@/%@", aNotification.name, [stTargetClass description]];
      NSString *szCachedSelectorName   = [_handlers objectForKey:szCacheName];
      
      if ( szCachedSelectorName ) {
         
         SEL    stCachedSelector = NSSelectorFromString( szCachedSelectorName );
         
         if ( stCachedSelector ) {
            
            BOOL bHit = [self notification:aNotification perform:stCachedSelector class:stTargetClass target:aTarget];
            if ( bHit ) {
               
//               continue;
               break;
               
            } /* End if () */
            
         } /* End if () */
         
      } /* End if () */
      
      //      do
      {
         NSString *szSelectorName   = nil;
         SEL       stSelector       = nil;
         BOOL      bPerformed       = NO;
         
         // eg. handleNotification( Class, Motification )
         
         if ( szNotificationClass && szNotificationMethod ) {
            
            szSelectorName = [NSString stringWithFormat:@"handleNotification____%@____%@:", szNotificationClass, szNotificationMethod];
            stSelector     = NSSelectorFromString( szSelectorName );
            
            bPerformed     = [self notification:aNotification perform:stSelector class:stTargetClass target:aTarget];
            if ( bPerformed ) {
               
               [_handlers setObject:szSelectorName forKey:szCacheName];
               
               break;
               
            } /* End if () */
            
            // eg. handleNotification( Notification )
            
            if ( [[stTargetClass description] isEqualToString:szNotificationClass] ) {
               
               szSelectorName = [NSString stringWithFormat:@"handleNotification____%@:", szNotificationMethod];
               stSelector = NSSelectorFromString( szSelectorName );
               
               bPerformed = [self notification:aNotification perform:stSelector class:stTargetClass target:aTarget];
               if ( bPerformed ) {
                  
                  [_handlers setObject:szSelectorName forKey:szCacheName];
                  break;
                  
               } /* End if () */
               
            } /* End if () */
            
         } /* End if () */
         
         // eg. handleNotification( Class )
         
         if ( szNotificationClass ) {
            
            szSelectorName = [NSString stringWithFormat:@"handleNotification____%@:", szNotificationClass];
            stSelector = NSSelectorFromString( szSelectorName );
            
            bPerformed = [self notification:aNotification perform:stSelector class:stTargetClass target:aTarget];
            if ( bPerformed ) {
               
               [_handlers setObject:szSelectorName forKey:szCacheName];
               break;
               
            } /* End if () */
            
         } /* End if () */
         
         // eg. handleNotification( helloWorld )
         
         if ( [aNotification.name hasPrefix:@"notification____"] ) {
            
            szSelectorName = [aNotification.name stringByReplacingOccurrencesOfString:@"notification____" withString:@"handleNotification____"];
            
         } /* End if () */
         else {
            
            szSelectorName = [NSString stringWithFormat:@"handleNotification____%@:", aNotification.name];
            
         } /* End else */
         
         szSelectorName = [szSelectorName stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
         szSelectorName = [szSelectorName stringByReplacingOccurrencesOfString:@"." withString:@"_"];
         szSelectorName = [szSelectorName stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
         
         if ( NO == [szSelectorName hasSuffix:@":"] ) {
            
            szSelectorName = [szSelectorName stringByAppendingString:@":"];
            
         } /* End if () */
         
         stSelector = NSSelectorFromString( szSelectorName );
         
         bPerformed = [self notification:aNotification perform:stSelector class:stTargetClass target:aTarget];
         if ( bPerformed ) {
            
            [_handlers setObject:szSelectorName forKey:szCacheName];
            break;
            
         } /* End if () */
         
         // eg. handleNotification()
         
         if ( NO == bPerformed ) {
            
            szSelectorName = @"handleNotification____:";
            stSelector = NSSelectorFromString( szSelectorName );
            
            bPerformed = [self notification:aNotification perform:stSelector class:stTargetClass target:aTarget];
            if ( bPerformed ) {
               
               [_handlers setObject:szSelectorName forKey:szCacheName];
               break;
               
            } /* End if () */
            
         } /* End if () */
         
         // eg. handleNotification:
         
         if ( NO == bPerformed ) {
            
            szSelectorName = @"handleNotification:";
            stSelector = NSSelectorFromString( szSelectorName );
            
            bPerformed = [self notification:aNotification perform:stSelector class:stTargetClass target:aTarget];
            if ( bPerformed ) {
               
               [_handlers setObject:szSelectorName forKey:szCacheName];
               break;
               
            } /* End if () */
            
         } /* End if () */
      }
      //      while ( 0 );
   }
   
   return;
}

- (BOOL)notification:(IDEAAppletNotification *)aNotification perform:(SEL)aSEL class:(Class)aClazz target:(id)aTarget {
   
   ASSERT( nil != aNotification );
   ASSERT( nil != aTarget );
   ASSERT( nil != aSEL );
   ASSERT( nil != aClazz );
   
   BOOL   bPerformed       = NO;
   
   // try block
   
   if ( NO == bPerformed ) {
      
      IDEAAppletHandler *stHandler  = [aTarget blockHandler];
      if ( stHandler ) {
         
         BOOL found = [stHandler trigger:[NSString stringWithUTF8String:sel_getName(aSEL)] withObject:aNotification];
         if ( found ) {
            
            bPerformed = YES;
            
         } /* End if () */
         else {
            NSString *szName  = [aNotification.name copy];
            
            szName   = [szName stringByReplacingOccurrencesOfString:@"notification." withString:@"handleNotification____"];
            szName   = [szName stringByReplacingOccurrencesOfString:@"notification____" withString:@"handleNotification____"];
            szName   = [szName stringByReplacingOccurrencesOfString:@"-" withString:@"____"];
            szName   = [szName stringByReplacingOccurrencesOfString:@"." withString:@"____"];
            szName   = [szName stringByReplacingOccurrencesOfString:@"/" withString:@"____"];
            szName   = [szName stringByAppendingString:@":"];

            found = [stHandler trigger:szName withObject:aNotification];
            
            if ( found ) {
               
               bPerformed = YES;
               
            } /* End if () */
         }
         
      } /* End if () */
      
   } /* End if () */
   
   // try selector
   
   if ( NO == bPerformed ) {
      
      Method stMethod = class_getInstanceMethod( aClazz, aSEL );
      if ( stMethod ) {
         
         ImpFuncType stImp = (ImpFuncType)method_getImplementation( stMethod );
         if ( stImp ) {
            
            stImp( aTarget, aSEL, (__bridge void *)aNotification );
            
            bPerformed = YES;
            
         } /* End if () */
         
      } /* End if () */
      
   } /* End if () */
   
#if __SAMURAI_DEBUG__
#  if __NOTIFICATION_CALLSTACK__
   NSString *szSelName = [NSString stringWithUTF8String:sel_getName(aSEL)];
   NSString *szClassName = [aClazz description];
   
   if ( NSNotFound != [szSelName rangeOfString:@"____"].location ) {
      
      szSelName = [szSelName stringByReplacingOccurrencesOfString:@"handleNotification____" withString:@"handleNotification( "];
      szSelName = [szSelName stringByReplacingOccurrencesOfString:@"____" withString:@", "];
      szSelName = [szSelName stringByReplacingOccurrencesOfString:@":" withString:@""];
      szSelName = [szSelName stringByAppendingString:@" )"];
      
   } /* End if () */
   
   PERF( @"  %@ %@::%@", bPerformed ? @"✔" : @"✖", szClassName, szSelName );
#  endif
#endif
   
   return bPerformed;
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( Event, NotificationBus )

DESCRIBE( before ) {
   
}

DESCRIBE( after ) {
   
}

TEST_CASE_END

#endif   // #if __SAMURAI_TESTING__

#import "__pragma_pop.h"

//#endif
