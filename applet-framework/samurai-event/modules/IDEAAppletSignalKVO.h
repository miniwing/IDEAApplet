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

typedef NSObject *   (^ IDEAAppletKVOBlock )( id nameOrObject, id propertyOrBlock, ... );

#pragma mark -

@interface IDEAAppletKVObserver : NSObject

@prop_unsafe( id, source );

- (void)observeProperty:(NSString *)aProperty;
- (void)unobserveProperty:(NSString *)aProperty;
- (void)unobserveAllProperties;

@end

#pragma mark -

@interface NSObject(KVObserver)

@prop_readonly( IDEAAppletKVOBlock, onValueChanging );
@prop_readonly( IDEAAppletKVOBlock, onValueChanged );

- (IDEAAppletKVObserver *)KVObserverOrCreate;
- (IDEAAppletKVObserver *)KVObserver;

- (void)observeProperty:(NSString *)aProperty;
- (void)unobserveProperty:(NSString *)aProperty;
- (void)unobserveAllProperties;

- (void)signalValueChanging:(NSString *)aProperty;
- (void)signalValueChanging:(NSString *)aProperty value:(id)aValue;

- (void)signalValueChanged:(NSString *)aProperty;
- (void)signalValueChanged:(NSString *)aProperty value:(id)aValue;

@end
