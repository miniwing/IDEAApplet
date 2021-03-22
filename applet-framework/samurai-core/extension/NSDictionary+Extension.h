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

#pragma mark -

@protocol NSDictionaryProtocol <NSObject>
@required
- (id)objectForKey:(id)key;
- (BOOL)hasObjectForKey:(id)key;
@optional
- (id)objectForKeyedSubscript:(id)key;
@end

#pragma mark -

@interface NSDictionary(Extension) <NSDictionaryProtocol>

- (id)objectForOneOfKeys:(NSArray *)aArray;

- (NSNumber *)numberForOneOfKeys:(NSArray *)aArray;
- (NSString *)stringForOneOfKeys:(NSArray *)aArray;

- (id)objectAtPath:(NSString *)aPath;
- (id)objectAtPath:(NSString *)aPath otherwise:(NSObject *)aOther;

- (id)objectAtPath:(NSString *)aPath separator:(NSString *)aSeparator;
- (id)objectAtPath:(NSString *)aPath otherwise:(NSObject *)aOther separator:(NSString *)aSeparator;

- (id)objectAtPath:(NSString *)aPath withClass:(Class)aClass;
- (id)objectAtPath:(NSString *)aPath withClass:(Class)aClass otherwise:(NSObject *)aOther;

- (BOOL)boolAtPath:(NSString *)aPath;
- (BOOL)boolAtPath:(NSString *)aPath otherwise:(BOOL)aOther;

- (NSNumber *)numberAtPath:(NSString *)aPath;
- (NSNumber *)numberAtPath:(NSString *)aPath otherwise:(NSNumber *)aOther;

- (NSString *)stringAtPath:(NSString *)aPath;
- (NSString *)stringAtPath:(NSString *)aPath otherwise:(NSString *)aOther;

- (NSArray *)arrayAtPath:(NSString *)aPath;
- (NSArray *)arrayAtPath:(NSString *)aPath otherwise:(NSArray *)aOther;

- (NSArray *)arrayAtPath:(NSString *)aPath withClass:(Class)aClass;
- (NSArray *)arrayAtPath:(NSString *)aPath withClass:(Class)aClass otherwise:(NSArray *)aOther;

- (NSMutableArray *)mutableArrayAtPath:(NSString *)aPath;
- (NSMutableArray *)mutableArrayAtPath:(NSString *)aPath otherwise:(NSMutableArray *)aOther;

- (NSDictionary *)dictAtPath:(NSString *)aPath;
- (NSDictionary *)dictAtPath:(NSString *)aPath otherwise:(NSDictionary *)aOther;

- (NSMutableDictionary *)mutableDictAtPath:(NSString *)aPath;
- (NSMutableDictionary *)mutableDictAtPath:(NSString *)aPath otherwise:(NSMutableDictionary *)aOther;

@end
