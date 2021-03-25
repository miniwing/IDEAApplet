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

#import "IDEAAppletIntentBus.h"

#import "__pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation IDEAAppletIntentBus {
   
   NSMutableDictionary * _handlers;
}

@def_singleton( IDEAAppletIntentBus )

- (id)init {
   
   self = [super init];
   
   if ( self ) {
      
      _handlers = [[NSMutableDictionary alloc] init];
      
   } /* End if () */
   
   return self;
}

- (void)dealloc {
   
   [_handlers removeAllObjects];
   _handlers   = nil;
   
   __SUPER_DEALLOC;
   
   return;
}

- (void)routes:(IDEAAppletIntent *)aIntent target:(id)aTarget {
   
   if ( nil == aTarget ) {
      
      //      ERROR( @"No intent target" );
      
      return;
      
   } /* End if () */
   
   NSMutableArray *stClasses  = [NSMutableArray nonRetainingArray];
   
   for ( Class stClass = [aTarget class]; nil != stClass; stClass = class_getSuperclass(stClass) ) {
      
      [stClasses addObject:stClass];
      
   } /* End if () */
   
   NSString *szIntentClass    = nil;
   NSString *szIntentMethod   = nil;
   
   if ( aIntent.action ) {
      
      if ( [aIntent.action hasPrefix:@"intent."] ) {
         
         NSArray * array = [aIntent.action componentsSeparatedByString:@"."];
         
         szIntentClass = (NSString *)[array safeObjectAtIndex:1];
         szIntentMethod = (NSString *)[array safeObjectAtIndex:2];
         
      } /* End if () */
      else {
         
         NSArray  *stArray = [aIntent.action componentsSeparatedByString:@"/"];
         
         szIntentClass  = (NSString *)[stArray safeObjectAtIndex:0];
         szIntentMethod = (NSString *)[stArray safeObjectAtIndex:1];
         
         if ( szIntentMethod ) {
            
            szIntentMethod = [szIntentMethod stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
            szIntentMethod = [szIntentMethod stringByReplacingOccurrencesOfString:@"." withString:@"_"];
            szIntentMethod = [szIntentMethod stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
            
         } /* End if () */
         
      } /* End else */
      
   } /* End if () */
   
   for ( Class targetClass in stClasses ) {
      
      NSString *szCacheName            = [NSString stringWithFormat:@"%@/%@", aIntent.action, [targetClass description]];
      NSString *szCachedSelectorName   = [_handlers objectForKey:szCacheName];
      
      if ( szCachedSelectorName ) {
         
         SEL    stCachedSelector = NSSelectorFromString( szCachedSelectorName );
         if ( stCachedSelector ) {
            
            BOOL   bHit    = [self intent:aIntent perform:stCachedSelector class:targetClass target:aTarget];
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
         
         // eg. handleIntent( Class, Intent )
         
         if ( szIntentClass && szIntentMethod ) {
            
            szSelectorName = [NSString stringWithFormat:@"handleIntent____%@____%@:", szIntentClass, szIntentMethod];
            stSelector = NSSelectorFromString( szSelectorName );
            
            bPerformed = [self intent:aIntent perform:stSelector class:targetClass target:aTarget];
            if ( bPerformed ) {
               
               [_handlers setObject:szSelectorName forKey:szCacheName];
               break;
            }
            
            // eg. handleIntent( intent )
            
            if ( [[targetClass description] isEqualToString:szIntentClass] ) {
               
               szSelectorName = [NSString stringWithFormat:@"handleIntent____%@:", szIntentMethod];
               stSelector = NSSelectorFromString( szSelectorName );
               
               bPerformed = [self intent:aIntent perform:stSelector class:targetClass target:aTarget];
               if ( bPerformed ) {
                  
                  [_handlers setObject:szSelectorName forKey:szCacheName];
                  break;
               }
            }
         }
         
         // eg. handleIntent( Class )
         
         if ( szIntentClass ) {
            
            szSelectorName = [NSString stringWithFormat:@"handleIntent____%@:", szIntentClass];
            stSelector = NSSelectorFromString( szSelectorName );
            
            bPerformed = [self intent:aIntent perform:stSelector class:targetClass target:aTarget];
            if ( bPerformed ) {
               
               [_handlers setObject:szSelectorName forKey:szCacheName];
               
               break;
               
            } /* End if () */
            
         } /* End if () */
         
         // eg. handleIntent( helloWorld )
         
         if ( [aIntent.action hasPrefix:@"intent____"] ) {
            
            szSelectorName = [aIntent.action stringByReplacingOccurrencesOfString:@"intent____" withString:@"handleIntent____"];
            
         } /* End if () */
         else {
            
            szSelectorName = [NSString stringWithFormat:@"handleIntent____%@:", aIntent.action];
            
         } /* End if () */
         
         szSelectorName = [szSelectorName stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
         szSelectorName = [szSelectorName stringByReplacingOccurrencesOfString:@"." withString:@"_"];
         szSelectorName = [szSelectorName stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
         
         if ( NO == [szSelectorName hasSuffix:@":"] ) {
            
            szSelectorName = [szSelectorName stringByAppendingString:@":"];
            
         } /* End if () */
         
         stSelector = NSSelectorFromString( szSelectorName );
         
         bPerformed = [self intent:aIntent perform:stSelector class:targetClass target:aTarget];
         if ( bPerformed ) {
            
            [_handlers setObject:szSelectorName forKey:szCacheName];
            break;
            
         } /* End if () */
         
         // eg. handleIntent()
         
         if ( NO == bPerformed ) {
            
            szSelectorName = @"handleIntent____:";
            stSelector     = NSSelectorFromString( szSelectorName );
            
            bPerformed     = [self intent:aIntent perform:stSelector class:targetClass target:aTarget];
            
            if ( bPerformed ) {
               
               [_handlers setObject:szSelectorName forKey:szCacheName];
               break;
               
            } /* End if () */
            
         } /* End if () */
         
         // eg. handleIntent:
         
         if ( NO == bPerformed ) {
            
            szSelectorName = @"handleIntent:";
            stSelector = NSSelectorFromString( szSelectorName );
            
            bPerformed = [self intent:aIntent perform:stSelector class:targetClass target:aTarget];
            if ( bPerformed ) {
               
               [_handlers setObject:szSelectorName forKey:szCacheName];
               
               break;
               
            } /* End if () */
            
         } /* End if () */
         
      }
      //      while ( 0 );
   }  /* End for () */
   
   return;
}

- (BOOL)intent:(IDEAAppletIntent *)aIntent perform:(SEL)aSEL class:(Class)aClass target:(id)aTarget {
   
   ASSERT( nil != aIntent );
   ASSERT( nil != aTarget );
   ASSERT( nil != aSEL );
   ASSERT( nil != aClass );
   
   BOOL   bPerformed    = NO;
   
   // try block
   
   if ( NO == bPerformed ) {
      
      IDEAAppletHandler *stHandler  = [aTarget blockHandler];
      if ( stHandler ) {
         
         BOOL bFound = [stHandler trigger:[NSString stringWithUTF8String:sel_getName(aSEL)] withObject:aIntent];
         
         if ( bFound ) {
            
            bPerformed = YES;
            
         } /* End if () */
         
      } /* End if () */
      
   } /* End if () */
   
   // try selector
   
   if ( NO == bPerformed ) {
      
      Method stMethod = class_getInstanceMethod( aClass, aSEL );
      if ( stMethod ) {
         
         ImpFuncType stIMP = (ImpFuncType)method_getImplementation( stMethod );
         if ( stIMP ) {
            
            stIMP( aTarget, aSEL, (__bridge void *)aIntent );
            
            bPerformed = YES;
            
         } /* End if () */
         
      } /* End if () */
      
   } /* End if () */
   
   return bPerformed;
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( UI, IntentBus )

DESCRIBE( before ) {
   
}

DESCRIBE( after ) {
   
}

TEST_CASE_END

#endif   // #if __SAMURAI_TESTING__

#endif   // #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "__pragma_pop.h"

//#endif
