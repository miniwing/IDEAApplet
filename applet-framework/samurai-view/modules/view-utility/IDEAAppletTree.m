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

#import "IDEAAppletTree.h"

#import "__pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation IDEAAppletTreeNode

@def_prop_readonly( IDEAAppletTreeNode *, root );

@def_prop_unsafe  ( IDEAAppletTreeNode *, parent );
@def_prop_unsafe  ( IDEAAppletTreeNode *, prev );
@def_prop_unsafe  ( IDEAAppletTreeNode *, next );
@def_prop_strong  ( NSMutableArray     *, childs );

#pragma mark -

- (id)init {
   
   self = [super init];
   if ( self ) {
      
      self.childs = [NSMutableArray array];
   }
   return self;
}

- (void)dealloc {
   
   self.parent = nil;
   self.prev   = nil;
   self.next   = nil;
   
   [self.childs removeAllObjects];
   self.childs = nil;
   
   __SUPER_DEALLOC;
   
   return;
}

- (id)clone {
   
   id newObject = [super clone];
   
   for ( id child in self.childs ) {
      
      id newChild = [child clone];
      
      if ( newChild ) {
         
         [newObject appendNode:newChild];
      }
   }
   
   return newObject;
}

#pragma mark -

+ (instancetype)treeNode {
   
   return [[self alloc] init];
}

- (IDEAAppletTreeNode *)root {
   
   IDEAAppletTreeNode * object = self;
   
   for ( ;; ) {
      
      if ( nil == object.parent )
         break;
      
      object = object.parent;
   }
   
   return object;
}

#pragma mark -

- (instancetype)createChild {
   
   return [self createChild:[self class]];
}

- (instancetype)createChild:(Class)nodeClass {
   
   IDEAAppletTreeNode * node = [[nodeClass alloc] init];
   
   [self appendNode:node];
   
   return node;
}

- (instancetype)createSibling {
   
   return [self createSibling:[self class]];
}

- (instancetype)createSibling:(Class)nodeClass {
   
   IDEAAppletTreeNode * node = [[nodeClass alloc] init];
   
   node.parent = self.parent;
   node.prev = self;
   node.next = nil;
   
   //   [node relation]
   //   prev self -> *node
   
   self.next = node;
   
   [self.parent.childs addObject:node];
   
   return node;
}

#pragma mark -

- (void)appendNode:(IDEAAppletTreeNode *)node {
   
   if ( nil == node )
      return;
   
   if ( [self.childs containsObject:node] )
      return;
   
   node.parent = self;
   node.prev = [self.childs lastObject];
   node.next = nil;
   
   //    [node relation]
   //         self
   //   /       |        \
   // ...   node.prev -> *node
   
   node.prev.next = node;
   
   [self.childs addObject:node];
}

- (void)insertNode:(IDEAAppletTreeNode *)node beforeNode:(IDEAAppletTreeNode *)oldNode {
   
   if ( nil == node || nil == oldNode )
      return;
   
   if ( [self.childs containsObject:node] )
      return;
   
   if ( NO == [self.childs containsObject:oldNode] )
      return;
   
   node.prev = oldNode.prev;
   node.next = oldNode;
   node.parent = self;
   
   oldNode.prev.next = node;
   oldNode.prev = node;
   
   [self.childs addObject:node];
}

- (void)insertNode:(IDEAAppletTreeNode *)node afterNode:(IDEAAppletTreeNode *)oldNode {
   
   if ( nil == node )
      return;
   
   if ( [self.childs containsObject:node] )
      return;
   
   if ( NO == [self.childs containsObject:oldNode] )
      return;
   
   node.prev = oldNode;
   node.next = oldNode.next;
   node.parent = self;
   
   oldNode.next.prev = node;
   oldNode.next = node;
   
   [self.childs addObject:node];
}

- (void)changeNode:(IDEAAppletTreeNode *)node withNode:(IDEAAppletTreeNode *)newNode {
   
   if ( nil == node || nil == newNode )
      return;
   
   if ( NO == [self.childs containsObject:node] )
      return;
   
   newNode.parent = node.parent;
   newNode.prev = node.prev;
   newNode.next = node.next;
   
   node.parent = nil;
   node.prev = nil;
   node.next = nil;
   
   [self.childs replaceObjectAtIndex:[self.childs indexOfObject:node] withObject:newNode];
}

- (void)removeNode:(IDEAAppletTreeNode *)node {
   
   if ( nil == node )
      return;
   
   if ( NO == [self.childs containsObject:node] )
      return;
   
   if ( node.prev ) {
      
      node.prev.next = node.next;
   }
   
   if ( node.next ) {
      
      node.next.prev = node.prev;
   }
   
   node.parent = nil;
   node.prev = nil;
   node.next = nil;
   
   [self.childs removeObject:node];
}

- (void)removeAllNodes {
   
   for ( IDEAAppletTreeNode * node in self.childs ) {
      
      node.parent = nil;
      node.prev = nil;
      node.next = nil;
   }
   
   [self.childs removeAllObjects];
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( UI, Tree )

DESCRIBE( before ) {
   
}

DESCRIBE( after ) {
   
}

TEST_CASE_END

#endif   // #if __SAMURAI_TESTING__

#endif   // #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "__pragma_pop.h"
