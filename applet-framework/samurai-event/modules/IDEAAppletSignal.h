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

#import "IDEAAppletCore.h"
#import "IDEAAppletEventConfig.h"

#pragma mark -

#undef  signal
#define signal( name )                       \
        static_property( name )

#undef  def_signal
#define def_signal( name )                   \
        def_static_property2( name, @"signal", NSStringFromClass([self class]) )

#undef  def_signal_alias
#define def_signal_alias( name, alias )      \
        alias_static_property( name, alias )

#undef  makeSignal
#define makeSignal( ... )                    \
        macro_string( macro_join(signal, __VA_ARGS__) )

#undef  handleSignal
#define handleSignal( ... )                  \
        - (void) macro_join( handleSignal, __VA_ARGS__):(IDEAAppletSignal *)aSignal

#pragma mark -

#undef  IDEA_MAKE_SIGNAL
#define IDEA_MAKE_SIGNAL( ... )              \
        macro_string(macro_join(signal, __VA_ARGS__))

#undef  IDEA_SIGNAL
#define IDEA_SIGNAL( ... )                   \
        static_property(macro_join(signal, __VA_ARGS__))

#undef  IDEA_DEF_SIGNAL
#define IDEA_DEF_SIGNAL( ... )               \
        IDEA_DEF_STATIC_PROPERTY2(macro_join(signal, __VA_ARGS__), @"signal", NSStringFromClass([self class]))

#undef  IDEA_HANDLE_SIGNAL
#define IDEA_HANDLE_SIGNAL( ... )            \
        - (void) macro_join(handleSignal, macro_join(__VA_ARGS__)):(IDEAAppletSignal *)aSignal

#pragma mark -

typedef NSObject * (^ IDEAAppletSignalBlock )( NSString *aName, id aObject );

#pragma mark -

typedef enum {
   
   SignalState_Inited = 0,
   SignalState_Sending,
   SignalState_Arrived,
   SignalState_Dead
   
} SignalState;

#pragma mark -

@class IDEAAppletSignal;

@interface NSObject(SignalResponder)

@prop_readonly( IDEAAppletSignalBlock, onSignal );
@prop_readonly( NSMutableArray      *, userResponders );

- (id)signalResponders;          // override point
- (id)signalAlias;               // override point
- (NSString *)signalNamespace;   // override point
- (NSString *)signalTag;         // override point
- (NSString *)signalDescription; // override point

- (BOOL)hasSignalResponder:(id)aObj;
- (void)addSignalResponder:(id)aObj;
- (void)removeSignalResponder:(id)aObj;
- (void)removeAllSignalResponders;

- (void)handleSignal:(IDEAAppletSignal *)aThat;

@end

#pragma mark -

@interface NSObject(SignalSender)

- (IDEAAppletSignal *)sendSignal:(NSString *)aName;
- (IDEAAppletSignal *)sendSignal:(NSString *)aName withObject:(NSObject *)aObject;
- (IDEAAppletSignal *)sendSignal:(NSString *)aName from:(id)aSource;
- (IDEAAppletSignal *)sendSignal:(NSString *)aName from:(id)aSource withObject:(NSObject *)aObject;

//- (IDEAAppletSignal *)postSignal:(NSString *)aName;
//- (IDEAAppletSignal *)postSignal:(NSString *)aName withObject:(NSObject *)aObject;
//- (IDEAAppletSignal *)postSignal:(NSString *)aName from:(id)aSource;
//- (IDEAAppletSignal *)postSignal:(NSString *)aName from:(id)aSource withObject:(NSObject *)aObject;

- (void)postSignal:(NSString *)aName onQueue:(dispatch_queue_t)aQueue;
- (void)postSignal:(NSString *)aName withObject:(NSObject *)aObject onQueue:(dispatch_queue_t)aQueue;
- (void)postSignal:(NSString *)aName from:(id)aSource onQueue:(dispatch_queue_t)aQueue;
- (void)postSignal:(NSString *)aName from:(id)aSource withObject:(NSObject *)aObject onQueue:(dispatch_queue_t)aQueue;

@end

#pragma mark -

@interface IDEAAppletSignal : NSObject<NSDictionaryProtocol, NSMutableDictionaryProtocol>

@joint( stateChanged );

//@prop_unsafe   ( id                  , foreign );
//@prop_strong   ( NSString           *, prefix );

@prop_unsafe   ( id                  , source );
@prop_unsafe   ( id                  , target );
         
@prop_copy     ( BlockType           , stateChanged );
@prop_assign   ( SignalState         , state );
@prop_assign   ( BOOL                , sending );
@prop_assign   ( BOOL                , arrived );
@prop_assign   ( BOOL                , dead );
      
@prop_assign   ( BOOL                , hit );
@prop_assign   ( NSUInteger          , hitCount );
@prop_readonly ( NSString           *, prettyName );
      
@prop_copy     ( NSString           *, name );
@prop_strong   ( id                  , object );
@prop_strong   ( NSMutableDictionary*, input );
@prop_strong   ( NSMutableDictionary*, output );
   
@prop_assign   ( NSTimeInterval      , initTimeStamp );
@prop_assign   ( NSTimeInterval      , sendTimeStamp );
@prop_assign   ( NSTimeInterval      , arriveTimeStamp );

@prop_readonly ( NSTimeInterval      , timeElapsed );
@prop_readonly ( NSTimeInterval      , timeCostPending );
@prop_readonly ( NSTimeInterval      , timeCostExecution );

@prop_assign   ( NSInteger           , jumpCount );
@prop_strong   ( NSMutableArray     *, jumpPath );

+ (IDEAAppletSignal *)signal;
+ (IDEAAppletSignal *)signal:(NSString *)aName;

- (BOOL)is:(NSString *)aName;

- (BOOL)send;
- (BOOL)forward;
- (BOOL)forward:(id)aTarget;

- (void)log:(id)aSource;

- (BOOL)changeState:(SignalState)aNewState;

@end
