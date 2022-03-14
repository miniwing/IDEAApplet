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

#import "IDEAAppletHandler.h"
#import "IDEAAppletTrigger.h"
#import "IDEAAppletUnitTest.h"

#import "__pragma_push.h"

// ----------------------------------
// Source code
// ----------------------------------

//#pragma mark -
//
//typedef void (^ HandlerBlockType )( id object );

#pragma mark -

@implementation NSObject(BlockHandler)

- (IDEAAppletHandler *)blockHandlerOrCreate {
   
   IDEAAppletHandler * stHandler = [self getAssociatedObjectForKey:"blockHandler"];
   
   if ( nil == stHandler ) {
      
      stHandler = [[IDEAAppletHandler alloc] init];
      
      [self retainAssociatedObject:stHandler forKey:"blockHandler"];
      
   } /* End if () */
   
   return stHandler;
}

- (IDEAAppletHandler *)blockHandler {
   
   return [self getAssociatedObjectForKey:"blockHandler"];
}

- (void)addBlock:(id)aBlock forName:(NSString *)aName {
   
   IDEAAppletHandler *stHandler  = [self blockHandlerOrCreate];
   
   if ( stHandler ) {
      
      [stHandler addHandler:aBlock forName:aName];
      
   } /* End if () */
   
   return;
}

- (void)removeBlockForName:(NSString *)aName {
   
   IDEAAppletHandler * handler = [self blockHandler];
   
   if ( handler ) {
      
      [handler removeHandlerForName:aName];
   }
}

- (void)removeAllBlocks {
   
   IDEAAppletHandler *stHandler  = [self blockHandler];
   
   if ( stHandler ) {
      
      [stHandler removeAllHandlers];
      
   } /* End if () */
   
   [self removeAssociatedObjectForKey:"blockHandler"];
   
   return;
}

@end

#pragma mark -

@interface IDEAAppletHandler ()
@property (nonatomic, strong)    NSMutableDictionary * blocks;
@end

@implementation IDEAAppletHandler {
   
}

- (id)init {
   
   self = [super init];
   if ( self ) {
      
      self.blocks = [[NSMutableDictionary alloc] init];
   }
   return self;
}

- (void)dealloc {
   
   [self.blocks removeAllObjects];
   _blocks = nil;
}

- (BOOL)trigger:(NSString *)name {
   
   return [self trigger:name withObject:nil];
}

- (BOOL)trigger:(NSString *)name withObject:(id)object {
   
   if ( nil == name ) {
      
      return NO;
   }
   
   HandlerBlockType   stBlock = (HandlerBlockType)[self.blocks objectForKey:name];
   
   if ( nil == stBlock ) {
      
      return NO;
   }
   
   stBlock( object );
   
   return YES;
}

- (void)addHandler:(id)aHandler forName:(NSString *)aName {
   
   if ( nil == aName ) {
      return;
   }
   
   if ( nil == aHandler ) {
      
      [self.blocks removeObjectForKey:aName];
      
   } /* End if () */
   else {
      
      [self.blocks setObject:aHandler forKey:aName];
      
   } /* End else */
   
   return;
}

- (void)removeHandlerForName:(NSString *)aName {
   
   if ( nil == aName ) {
      
      return;
      
   } /* End if () */
   
   [self.blocks removeObjectForKey:aName];
   
   return;
}

- (void)removeAllHandlers {
   
   [self.blocks removeAllObjects];
   
   return;
}

- (NSMutableDictionary *)blocks {
   
   if (nil == _blocks) {
      
      _blocks  = [NSMutableDictionary dictionary];
      
   } /* End if () */
   
   return _blocks;
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( Core, Handler )

DESCRIBE( before ) {
   
}

DESCRIBE( after ) {
   
}

TEST_CASE_END

#endif   // #if __SAMURAI_TESTING__

#import "__pragma_pop.h"
