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

#import "IDEAAppletConfig.h"
#import "IDEAAppletProperty.h"

#import "IDEAApplet/NSArray+Extension.h"

#pragma mark -

@protocol NSMutableArrayProtocol <NSObject>
@required
- (void)addObject:(id)aObject;
@optional
- (void)insertObject:(id)aObject atIndex:(NSUInteger)index;
- (void)removeLastObject;
- (void)removeObjectAtIndex:(NSUInteger)index;
- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject;
@end

#pragma mark -

@interface NSMutableArray(Extension)<NSMutableArrayProtocol>

+ (NSMutableArray *)nonRetainingArray;         // copy from Three20

- (void)addUniqueObject:(id)aObject compare:(NSArrayCompareBlock)aCompare;
- (void)addUniqueObjects:(const id [])aObjects count:(NSUInteger)aCount compare:(NSArrayCompareBlock)aCompare;
- (void)addUniqueObjectsFromArray:(NSArray *)aArray compare:(NSArrayCompareBlock)aCompare;

- (void)unique;
- (void)unique:(NSArrayCompareBlock)aCompare;

- (void)sort;
- (void)sort:(NSArrayCompareBlock)aCompare;

- (void)shrink:(NSUInteger)aCount;
- (void)append:(id)aObject;

- (NSMutableArray *)pushHead:(NSObject *)aObject;
- (NSMutableArray *)pushHeadN:(NSArray *)all;
- (NSMutableArray *)popTail;
- (NSMutableArray *)popTailN:(NSUInteger)n;

- (NSMutableArray *)pushTail:(NSObject *)aObject;
- (NSMutableArray *)pushTailN:(NSArray *)all;
- (NSMutableArray *)popHead;
- (NSMutableArray *)popHeadN:(NSUInteger)n;

- (NSMutableArray *)keepHead:(NSUInteger)n;
- (NSMutableArray *)keepTail:(NSUInteger)n;

@end
