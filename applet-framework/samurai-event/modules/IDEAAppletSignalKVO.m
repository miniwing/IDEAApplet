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

#import "IDEAAppletSignalKVO.h"
#import "IDEAAppletSignalBus.h"
#import "IDEAAppletSignal.h"

#import "__pragma_push.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation IDEAAppletKVObserver {
   
   NSMutableDictionary * _properties;
}

@def_prop_unsafe( id, source );

- (id)init {
   
   self = [super init];
   if ( self ) {
      
      _properties = [[NSMutableDictionary alloc] init];
      
   } /* End if () */
   
   return self;
}

- (void)dealloc {
   
   [self unobserveAllProperties];
   
   [_properties removeAllObjects];
   _properties = nil;
   
   __SUPER_DEALLOC;
   
   return;
}

- (void)observeProperty:(NSString *)aProperty {
   
   if ( nil == aProperty ) {
      
      return;
      
   } /* End if () */
   
   if ( [_properties objectForKey:aProperty] ) {
      
      return;
      
   } /* End if () */
   
   NSKeyValueObservingOptions  eOptions         = 0;
   
   NSArray                    *stObserverValues = [self.source extentionForProperty:aProperty arrayValueWithKey:@"Observer"];
   
   if ( stObserverValues ) {
      
      for ( NSString *szValue in stObserverValues ) {
         
         if ( [szValue isEqualToString:@"old"] ) {
            
            eOptions |= NSKeyValueObservingOptionOld;
            
         } /* End if () */
         else if ( [szValue isEqualToString:@"new"] ) {
            
            eOptions |= NSKeyValueObservingOptionOld;
            
         } /* End else if () */
         
      } /* End for () */
      
   } /* End if () */
   
   if ( 0 == eOptions ) {
      
      eOptions = NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew;
      
   } /* End if () */
   
   [self.source addObserver:self forKeyPath:aProperty options:eOptions context:NULL];
   
   [_properties setObject:[NSNumber numberWithInt:(int)eOptions] forKey:aProperty];
   
   return;
}

- (void)unobserveProperty:(NSString *)aProperty {
   
   if ( [_properties objectForKey:aProperty] ) {
      
      [self.source removeObserver:self forKeyPath:aProperty];
      
      [_properties removeObjectForKey:aProperty];
      
   } /* End if () */
   
   return;
}

- (void)unobserveAllProperties {
   
   for ( NSString *szProperty in _properties.allKeys ) {
      
      [self.source removeObserver:self forKeyPath:szProperty];
      
   } /* End for () */
   
   [_properties removeAllObjects];
   
   return;
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)aKeyPath ofObject:(id)aObject change:(NSDictionary *)aChange context:(void *)aContext {
   
   NSObject *stOldValue = [aChange objectForKey:@"old"];
   NSObject *stNewValue = [aChange objectForKey:@"new"];
   
   if ( stOldValue ) {
      
      IDEAAppletSignal  *stSignal   = [IDEAAppletSignal signal];
      
      stSignal.name     = [NSString stringWithFormat:@"signal.%@.%@.valueChanging", [[aObject class] description], aKeyPath];
      stSignal.source   = aObject;
      stSignal.target   = self.source;
      stSignal.object   = [stOldValue isKindOfClass:[NSNull class]] ? nil : stOldValue;
      
      [stSignal send];
      
   } /* End if () */
   
   if ( stNewValue ) {
      
      IDEAAppletSignal  *stSignal   = [IDEAAppletSignal signal];
      
      stSignal.name = [NSString stringWithFormat:@"signal.%@.%@.valueChanged", [[aObject class] description], aKeyPath];
      stSignal.source = aObject;
      stSignal.target = self.source;
      stSignal.object = [stNewValue isKindOfClass:[NSNull class]] ? nil : stNewValue;
      
      [stSignal send];
      
   } /* End if () */
   
   return;
}

@end

#pragma mark -

@implementation NSObject(KVObserver)

@def_prop_dynamic( IDEAAppletKVOBlock, onValueChanging );
@def_prop_dynamic( IDEAAppletKVOBlock, onValueChanged );

- (IDEAAppletKVObserver *)KVObserverOrCreate {
   
   IDEAAppletKVObserver *stObserver = [self getAssociatedObjectForKey:"KVObserver"];
   
   if ( nil == stObserver ) {
      
      stObserver = [[IDEAAppletKVObserver alloc] init];
      stObserver.source = self;
      
      [self retainAssociatedObject:stObserver forKey:"KVObserver"];
      
   } /* End if () */
   
   return stObserver;
}

- (IDEAAppletKVObserver *)KVObserver {
   
   return [self getAssociatedObjectForKey:"KVObserver"];
}

#pragma mark -

- (IDEAAppletKVOBlock)onValueChanging {
   
   @weakify( self );
   
   IDEAAppletKVOBlock   stBlock  = ^ NSObject * ( id aNameOrObject, id aPropertyOrBlock, ... ) {
      
      @strongify( self );
      
      EncodingType eEncoding = [IDEAAppletEncoding typeOfObject:aNameOrObject];
      
      if ( EncodingType_String == eEncoding ) {
         
         NSString *szName  = aNameOrObject;
         
         ASSERT( nil != szName );
         
         szName = [szName stringByReplacingOccurrencesOfString:@"signal." withString:@"handleSignal____"];
         szName = [szName stringByReplacingOccurrencesOfString:@"signal____" withString:@"handleSignal____"];
         szName = [szName stringByReplacingOccurrencesOfString:@"-" withString:@"____"];
         szName = [szName stringByReplacingOccurrencesOfString:@"." withString:@"____"];
         szName = [szName stringByReplacingOccurrencesOfString:@"/" withString:@"____"];
         szName = [szName stringByAppendingString:@"____valueChanging:"];
         
         if ( aPropertyOrBlock ) {
            
            [self addBlock:aPropertyOrBlock forName:szName];
            
         } /* End if () */
         else {
            
            [self removeBlockForName:szName];
            
         } /* End else */
         
      } /* End if () */
      else {
         
         va_list   stArgs;
         va_start( stArgs, aPropertyOrBlock );
         
         NSObject *stObject   = (NSObject *)aNameOrObject;
         NSString *szProperty = (NSString *)aPropertyOrBlock;
         
         ASSERT( nil != stObject );
         ASSERT( nil != szProperty );
         
         [stObject observeProperty:szProperty];
         [stObject addSignalResponder:self];
         
         NSString *szSignalName  = [NSString stringWithFormat:@"handleSignal____%@____%@____valueChanging:", [[stObject class] description], szProperty ];
         id        stSignalBlock = va_arg( stArgs, id );
         
         if ( stSignalBlock ) {
            
            [self addBlock:stSignalBlock forName:szSignalName];
            
         } /* End if () */
         else {
            
            [self removeBlockForName:szSignalName];
            
         } /* End else */
         
      } /* End else */
      
      return self;
   };
   
   return [stBlock copy];
}

- (IDEAAppletKVOBlock)onValueChanged {
   
   @weakify( self );
   
   IDEAAppletKVOBlock   stBlock     = ^ NSObject * ( id aNameOrObject, id aPropertyOrBlock, ... ) {
      
      @strongify( self );
      
      EncodingType       eEncoding  = [IDEAAppletEncoding typeOfObject:aNameOrObject];
      if ( EncodingType_String == eEncoding ) {
         
         NSString *szName  = aNameOrObject;
         
         ASSERT( nil != szName );
         
         szName = [szName stringByReplacingOccurrencesOfString:@"signal." withString:@"handleSignal____"];
         szName = [szName stringByReplacingOccurrencesOfString:@"signal____" withString:@"handleSignal____"];
         szName = [szName stringByReplacingOccurrencesOfString:@"-" withString:@"____"];
         szName = [szName stringByReplacingOccurrencesOfString:@"." withString:@"____"];
         szName = [szName stringByReplacingOccurrencesOfString:@"/" withString:@"____"];
         szName = [szName stringByAppendingString:@"____valueChanged:"];
         
         if ( aPropertyOrBlock ) {
            
            [self addBlock:aPropertyOrBlock forName:szName];
            
         } /* End if () */
         else {
            
            [self removeBlockForName:szName];
            
         } /* End else */
         
      } /* End if () */
      else {
         
         va_list   stArgs;
         va_start( stArgs, aPropertyOrBlock );
         
         NSObject *stObject   = (NSObject *)aNameOrObject;
         NSString *szProperty = (NSString *)aPropertyOrBlock;
         
         ASSERT( nil != stObject );
         ASSERT( nil != szProperty );
         
         [stObject observeProperty:szProperty];
         [stObject addSignalResponder:self];
         
         NSString *szSignalName  = [NSString stringWithFormat:@"handleSignal____%@____%@____valueChanged:", [[stObject class] description], szProperty ];
         id        stSignalBlock = va_arg( stArgs, id );
         
         if ( stSignalBlock ) {
            
            [self addBlock:stSignalBlock forName:szSignalName];
            
         } /* End if () */
         else {
            
            [self removeBlockForName:szSignalName];
            
         } /* End else */
      }
      
      return self;
   };
   
   return [stBlock copy];
}

#pragma mark -

- (void)observeProperty:(NSString *)aProperty {
   
   IDEAAppletKVObserver *stObserver = [self KVObserverOrCreate];
   if ( stObserver ) {
      
      [stObserver observeProperty:aProperty];
      
   } /* End if () */
   
   return;
}

- (void)unobserveProperty:(NSString *)aProperty {
   
   IDEAAppletKVObserver *stObserver = [self KVObserver];
   if ( stObserver ) {
      
      [stObserver unobserveProperty:aProperty];
      
   } /* End if () */
   
   return;
}

- (void)unobserveAllProperties {
   
   IDEAAppletKVObserver *stObserver = [self getAssociatedObjectForKey:"KVObserver"];
   
   if ( stObserver ) {
      
      [stObserver unobserveAllProperties];
      
      [self removeAssociatedObjectForKey:"KVObserver"];
      
   } /* End if () */
   
   return;
}

- (void)signalValueChanging:(NSString *)aProperty {
   
   [self signalValueChanging:aProperty value:nil];
   
   return;
}

- (void)signalValueChanging:(NSString *)aProperty value:(id)aValue {
   
   IDEAAppletSignal  *stSignal   = [IDEAAppletSignal signal];
   
   stSignal.name     = [NSString stringWithFormat:@"signal.%@.%@.valueChanging", [[self class] description], aProperty];
   stSignal.source   = self;
   stSignal.target   = self;
   stSignal.object   = [aValue isKindOfClass:[NSNull class]] ? nil : aValue;
   
   [stSignal send];
   
   return;
}

- (void)signalValueChanged:(NSString *)aProperty {
   
   [self signalValueChanged:aProperty value:nil];
   
   return;
}

- (void)signalValueChanged:(NSString *)aProperty value:(id)aValue {
   
   IDEAAppletSignal  *stSignal   = [IDEAAppletSignal signal];
   
   stSignal.name     = [NSString stringWithFormat:@"signal.%@.%@.valueChanged", [[self class] description], aProperty];
   stSignal.source   = self;
   stSignal.target   = self;
   stSignal.object   = [aValue isKindOfClass:[NSNull class]] ? nil : aValue;
   
   [stSignal send];
   
   return;
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

static int __value = 0;
static int __value2 = 0;

@interface __TestKVObject : NSObject

@prop_strong( NSString *,         text );
@prop_strong( NSArray *,         array );
@prop_strong( NSDictionary *,      dict );

@end

@implementation __TestKVObject

@def_prop_strong( NSString *,      text );
@def_prop_strong( NSArray *,      array );
@def_prop_strong( NSDictionary *,   dict );

@end

@interface __TestKVObserver : NSObject
@end

@implementation __TestKVObserver
@end

TEST_CASE( Event, KVObserver ) {
   
}

DESCRIBE( before ) {
   
}

DESCRIBE( Manually ) {
   
   @autoreleasepool {
      
      __TestKVObject *   object = [[__TestKVObject alloc] init];
      __TestKVObserver *   observer = [[__TestKVObserver alloc] init];
      
      [object observeProperty:@"text"];
      [object observeProperty:@"array"];
      [object observeProperty:@"dict"];
      [object addSignalResponder:observer];
      
      observer
      
      .onValueChanging( makeSignal(__TestKVObject, text),   ^{ __value += 1; })
      .onValueChanging( makeSignal(__TestKVObject, array),   ^{ __value += 1; })
      .onValueChanging( makeSignal(__TestKVObject, dict),   ^{ __value += 1; })
      
      .onValueChanged( makeSignal(__TestKVObject, text),   ^{ __value += 1; })
      .onValueChanged( makeSignal(__TestKVObject, array),   ^{ __value += 1; })
      .onValueChanged( makeSignal(__TestKVObject, dict),   ^{ __value += 1; });
      
      object.text = @"123";
      object.array = @[];
      object.dict = @{};
      
      EXPECTED( 6 == __value );
      
      [object unobserveAllProperties];
   };
}

DESCRIBE( Automatic ) {
   
   @autoreleasepool {
      
      __TestKVObject *   object = [[__TestKVObject alloc] init];
      __TestKVObserver *   observer = [[__TestKVObserver alloc] init];
      
      observer
      
      .onValueChanging( object, @"text",   ^{ __value2 += 1; })
      .onValueChanging( object, @"array",   ^{ __value2 += 1; })
      .onValueChanging( object, @"dict",   ^{ __value2 += 1; })
      
      .onValueChanged( object, @"text",   ^{ __value2 += 1; })
      .onValueChanged( object, @"array",   ^{ __value2 += 1; })
      .onValueChanged( object, @"dict",   ^{ __value2 += 1; });
      
      object.text = @"123";
      object.array = @[];
      object.dict = @{};
      
      EXPECTED( 6 == __value2 );
      
      [object unobserveAllProperties];
   };
}

DESCRIBE( after ) {
   
}

TEST_CASE_END

#endif   // #if __SAMURAI_TESTING__

#import "__pragma_pop.h"
