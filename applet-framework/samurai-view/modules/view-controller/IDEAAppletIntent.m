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

#import "IDEAAppletIntent.h"
#import "IDEAAppletIntentBus.h"

#import "__pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation NSObject(IntentResponder)

@def_prop_dynamic( IDEAAppletIntentObserverBlock, onIntent );

#pragma mark -

- (IDEAAppletIntentObserverBlock)onIntent {
   
   @weakify( self );
   
   IDEAAppletIntentObserverBlock block = ^ NSObject * ( NSString * aAction, id aIntentBlock ) {
      
      @strongify( self );
      
      aAction = [aAction stringByReplacingOccurrencesOfString:@"intent." withString:@"handleIntent____"];
      aAction = [aAction stringByReplacingOccurrencesOfString:@"intent____" withString:@"handleIntent____"];
      aAction = [aAction stringByReplacingOccurrencesOfString:@"-" withString:@"____"];
      aAction = [aAction stringByReplacingOccurrencesOfString:@"." withString:@"____"];
      aAction = [aAction stringByReplacingOccurrencesOfString:@"/" withString:@"____"];
      aAction = [aAction stringByAppendingString:@":"];
      
      if ( aIntentBlock ) {
         
         [self addBlock:[aIntentBlock copy] forName:aAction];
      }
      else {
         
         [self removeBlockForName:aAction];
      }
      
      return self;
   };
   
   return [block copy];
}

- (void)handleIntent:(IDEAAppletIntent *)that {
   
   UNUSED( that );
   
   return;
}

- (void)broadcast:(NSString *)aAction {
   
   [self broadcast:aAction withParams:nil];
   
   return;
}

- (void)broadcast:(NSString *)aAction from:(id)aSource withParams:(NSDictionary *)aParams {
   
   IDEAAppletIntent  *stIntent   = [IDEAAppletIntent intent:aAction params:aParams];
   
   stIntent.source   = aSource ? aSource : self;
   stIntent.target   = self;
   
   [stIntent broadcast];

   return;
}

- (void)broadcast:(NSString *)aAction withParams:(NSDictionary *)aParams {
   
   [self broadcast:aAction from:nil withParams:aParams];

   return;
}


@end

#pragma mark -

@implementation IDEAAppletIntent

@def_joint        ( stateChanged );

@def_prop_strong  ( NSString              *, action );
@def_prop_strong  ( NSMutableDictionary   *, input );
@def_prop_strong  ( NSMutableDictionary   *, output );

@def_prop_unsafe  ( id, source );
@def_prop_unsafe  ( id, target );

@def_prop_copy    ( BlockType    ,  stateChanged );
@def_prop_assign  ( IntentState  ,  state );
@def_prop_dynamic ( BOOL         ,  arrived );
@def_prop_dynamic ( BOOL         ,  succeed );
@def_prop_dynamic ( BOOL         ,  failed );
@def_prop_dynamic ( BOOL         ,  cancelled );

#pragma mark -

+ (IDEAAppletIntent *)intent {
   
   return [[IDEAAppletIntent alloc] init];
}

+ (IDEAAppletIntent *)intent:(NSString *)aAction {
   
   IDEAAppletIntent  *stIntent = [[IDEAAppletIntent alloc] init];
   stIntent.action   = aAction;
   return stIntent;
}

+ (IDEAAppletIntent *)intent:(NSString *)aAction params:(NSDictionary *)aParams {
   
   IDEAAppletIntent  *stIntent   = [[IDEAAppletIntent alloc] init];
   stIntent.action = aAction;
   
   if ( aParams ) {
      
      [stIntent.input setDictionary:aParams];
      
   } /* End if () */
   
   return stIntent;
}

- (id)init {
   
   static NSUInteger __seed = 0;
   
   self = [super init];
   if ( self ) {
      
      self.action = [NSString stringWithFormat:@"intent-%lu", (unsigned long)__seed++];
      self.input  = [NSMutableDictionary dictionary];
      self.output = [NSMutableDictionary dictionary];
      
      _state = IntentState_Inited;
      
   } /* End if () */
   
   return self;
}

- (void)dealloc {
   
   self.stateChanged = nil;
   
   self.action = nil;
   self.input  = nil;
   self.output = nil;
   
   __SUPER_DEALLOC;
   
   return;
}

- (NSString *)prettyName {
   
   return [self.action stringByReplacingOccurrencesOfString:@"intent." withString:@""];
}

- (BOOL)is:(NSString *)action {
   
   return [self.action isEqualToString:action];
}

- (IntentState)state {
   
   return _state;
}

- (void)setState:(IntentState)newState {
   
   [self changeState:newState];
   
   return;
}

- (BOOL)arrived {
   
   return IntentState_Arrived == _state ? YES : NO;
}

- (void)setArrived:(BOOL)flag {
   
   if ( flag ) {
      
      [self changeState:IntentState_Arrived];
      
   } /* End if () */
   
   return;
}

- (BOOL)succeed {
   
   return IntentState_Succeed == _state ? YES : NO;
}

- (void)setSucceed:(BOOL)flag {
   
   if ( flag ) {
      
      [self changeState:IntentState_Succeed];
      
   } /* End if () */
   
   return;
}

- (BOOL)failed {
   
   return IntentState_Failed == _state ? YES : NO;
}

- (void)setFailed:(BOOL)flag {
   
   if ( flag ) {
      
      [self changeState:IntentState_Failed];
      
   } /* End if () */
   
   return;
}

- (BOOL)cancelled {
   
   return IntentState_Cancelled == _state ? YES : NO;
}

- (void)setCancelled:(BOOL)aFlag {
   
   if ( aFlag ) {
      
      [self changeState:IntentState_Cancelled];
   } /* End if () */
   
   return;
}

- (BOOL)changeState:(IntentState)newState {
   
   //   static const char * __states[] = {
   //      "!Inited",
   //      "!Arrived",
   //      "!Succeed",
   //      "!Failed",
   //      "!Cancelled"
   //   };
   
   if ( newState == _state ) {
      
      return NO;
      
   } /* End if () */
   
   triggerBefore( self, stateChanged );
   
   PERF( @"Intent '%@', state %d -> %d", self.prettyName, _state, newState );
   
   _state = newState;
   
   if ( self.stateChanged ) {
      
      ((BlockTypeVarg)self.stateChanged)( self );
   }
   
   if ( IntentState_Arrived == _state ) {
      
      [[IDEAAppletIntentBus sharedInstance] routes:self target:self.target];
   }
   else if ( IntentState_Succeed == _state ) {
      
      [[IDEAAppletIntentBus sharedInstance] routes:self target:self.source];
   }
   else if ( IntentState_Failed == _state ) {
      
      [[IDEAAppletIntentBus sharedInstance] routes:self target:self.source];
   }
   else if ( IntentState_Cancelled == _state ) {
      
      [[IDEAAppletIntentBus sharedInstance] routes:self target:self.source];
   }
   
   triggerAfter( self, stateChanged );
   
   return YES;
}

- (void)broadcast {
   
   @autoreleasepool {
      
      [[IDEAAppletIntentBus sharedInstance] broadcast:self];
      
      return;
   };
}

#pragma mark -

- (NSMutableDictionary *)inputOrOutput {
   
   if ( IntentState_Inited == _state ) {
      
      if ( nil == self.input ) {
         
         self.input = [NSMutableDictionary dictionary];
      }
      
      return self.input;
   }
   else {
      
      if ( nil == self.output ) {
         
         self.output = [NSMutableDictionary dictionary];
      }
      
      return self.output;
   }
}

- (id)objectForKey:(id)key {
   
   NSMutableDictionary * objects = [self inputOrOutput];
   return [objects objectForKey:key];
}

- (BOOL)hasObjectForKey:(id)key {
   
   NSMutableDictionary * objects = [self inputOrOutput];
   return [objects objectForKey:key] ? YES : NO;
}

- (void)setObject:(id)value forKey:(id)key {
   
   NSMutableDictionary * objects = [self inputOrOutput];
   [objects setObject:value forKey:key];
}

- (void)removeObjectForKey:(id)key {
   
   NSMutableDictionary * objects = [self inputOrOutput];
   [objects removeObjectForKey:key];
}

- (void)removeAllObjects {
   
   NSMutableDictionary * objects = [self inputOrOutput];
   [objects removeAllObjects];
}

- (id)objectForKeyedSubscript:(id)key; {
   
   return [self objectForKey:key];
}

- (void)setObject:(id)obj forKeyedSubscript:(id)key {
   
   [self setObject:obj forKey:key];
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( UI, Intent )

DESCRIBE( before ) {
   
}

DESCRIBE( after ) {
   
}

TEST_CASE_END

#endif   // #if __SAMURAI_TESTING__

#endif   // #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "__pragma_pop.h"
