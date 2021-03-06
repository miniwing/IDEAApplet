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

#import "IDEAApplet.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#pragma mark -

@protocol IDEAAppletCSSProtocol <NSObject>

- (NSString *)cssId;
- (NSString *)cssTag;
- (NSString *)cssPseudos;
- (NSString *)cssShadowPseudoId;

- (NSArray *)cssClasses;
- (NSDictionary *)cssAttributes;

- (id<IDEAAppletCSSProtocol>)cssParent;
- (id<IDEAAppletCSSProtocol>)cssPreviousSibling;
- (id<IDEAAppletCSSProtocol>)cssFollowingSibling;
- (id<IDEAAppletCSSProtocol>)cssSiblingAtIndex:(NSInteger)index;

- (NSArray *)cssChildren;
- (NSArray *)cssPreviousSiblings;
- (NSArray *)cssFollowingSiblings;

@end

#pragma mark -

FOUNDATION_EXPORT NSString * NSStringFromIDEAAppletCSSProtocolElement(id<IDEAAppletCSSProtocol>);

#pragma mark -

@interface IDEAAppletCSSCondition : NSObject<IDEAAppletCSSProtocol>

@prop_strong( NSString *,      cssId );
@prop_strong( NSString *,      cssTag );
@prop_strong( NSString *,      cssPseudos );
@prop_strong( NSString *,      cssShadowPseudoId );
@prop_strong( NSArray *,      cssClasses );
@prop_strong( NSDictionary *,   cssAttributes );

@end

#endif   // #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
