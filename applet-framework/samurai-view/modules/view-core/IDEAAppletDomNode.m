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

#import "IDEAAppletDomNode.h"

#import "__pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "IDEAAppletStyleSheet.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation IDEAAppletDomNode

@def_prop_strong  ( NSNumber           *, id       );
@def_prop_strong  ( NSString           *, tag      );
@def_prop_strong  ( NSString           *, text     );
@def_prop_assign  ( DomNodeType         , type     );
@def_prop_strong  ( NSMutableDictionary*, attr     );

@def_prop_unsafe  ( IDEAAppletDocument *, document );
@def_prop_dynamic ( IDEAAppletDomNode  *, parent   );
@def_prop_dynamic ( IDEAAppletDomNode  *, prev     );
@def_prop_dynamic ( IDEAAppletDomNode  *, next     );

BASE_CLASS( IDEAAppletDomNode )

static NSUInteger __domSeed = 0;

#pragma mark -

+ (instancetype)domNode {
   
   return [[self alloc] init];
}

#pragma mark -

- (id)init {
   
   self = [super init];
   if ( self ) {
      
      self.id  = [NSNumber numberWithUnsignedInteger:__domSeed++];
      self.tag = nil;
      self.text= nil;
      self.type= DomNodeType_Unknown;
      self.attr= [[NSMutableDictionary alloc] init];
      
   } /* End if () */
   
   return self;
}

- (void)dealloc {
   
   self.id     = nil;
   self.tag    = nil;
   self.text   = nil;
   self.attr   = nil;

   self.document  = nil;
   self.parent    = nil;
   self.prev      = nil;
   self.next      = nil;
   
   __SUPER_DEALLOC;
   
   return;
}

#pragma mark -

- (void)deepCopyFrom:(IDEAAppletDomNode *)right {
   
//   [super deepCopyFrom:right];

   self.tag = right.tag;
   self.text = right.text;
   self.type = right.type;
   self.document = right.document;

   [self.attr setDictionary:right.attr];

   return;
}

#pragma mark -

- (void)attach:(IDEAAppletDocument *)document {
   
   self.document = document;
   
   for ( IDEAAppletDomNode * child in self.childs ) {
      
      [child attach:document];
   }

   return;
}

- (void)detach
{
   self.document = nil;
   
   for ( IDEAAppletDomNode * child in self.childs ) {
      
      [child detach];
   }

   return;
}

#pragma mark -

- (id)objectForKey:(id)key {
   
   return [self.attr objectForKey:key];
}

- (BOOL)hasObjectForKey:(id)key {
   
   return [self.attr hasObjectForKey:key];
}

- (id)objectForKeyedSubscript:(id)key {
   
   return [self objectForKey:key];
}

#pragma mark -

- (void)setObject:(id)object forKey:(id)key {
   
   [self.attr setObject:object forKey:key];

   return;
}

- (void)removeObjectForKey:(id)key {
   
   [self.attr removeObjectForKey:key];

   return;
}

- (void)removeAllObjects {
   
   [self.attr removeAllObjects];

   return;
}

- (void)setObject:(id)obj forKeyedSubscript:(id)key {
   
   [self setObject:obj forKey:key];

   return;
}

#pragma mark -

- (NSString *)description {
   
   return [self.attr description];
}

- (void)dump {
   
   return;
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( UI, DomNode )

DESCRIBE( before ) {
}

DESCRIBE( after ) {
}

TEST_CASE_END

#endif   // #if __SAMURAI_TESTING__

#endif   // #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "__pragma_pop.h"
