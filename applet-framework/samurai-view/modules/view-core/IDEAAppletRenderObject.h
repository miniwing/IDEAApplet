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

//#import "IDEAAppletViewConfig.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "IDEAAppletTree.h"

#pragma mark -

#undef  INVALID_VALUE
#define INVALID_VALUE            (HUGE_VALF)

#undef  NORMALIZE_VALUE
#define NORMALIZE_VALUE( __x )   ((__x == INVALID_VALUE) ? 0.0f : __x)

#pragma mark -

#if __has_feature(objc_arc)

#undef  outlet
#define outlet( type, name ) \
        property (nonatomic, unsafe_unretained) type name

#undef  def_outlet
#define def_outlet( type, name, ... ) \
        synthesize name = _##name;

#else

#undef  outlet
#define outlet( type, name ) \
        property (nonatomic, assign) type name

#undef  def_outlet
#define def_outlet( type, name, ... ) \
      synthesize name = _##name;

#endif

#pragma mark -

@class IDEAAppletDomNode;
@class IDEAAppletDocument;
@class IDEAAppletRenderObject;
@class IDEAAppletRenderStyle;
@class IDEAAppletLayoutObject;

@interface NSObject(Renderer)

@prop_strong( IDEAAppletRenderObject *, renderer );   // memory leak, but no crash

+ (id)createInstanceWithRenderer:(IDEAAppletRenderObject *)aRenderer;   // override point
+ (id)createInstanceWithRenderer:(IDEAAppletRenderObject *)aRenderer identifier:(NSString *)aIdentifier;   // override point

- (void)prepareForRendering;                          // override point

- (CGSize)computeSizeBySize   :(CGSize) aSize;        // override point
- (CGSize)computeSizeByWidth  :(CGFloat)aWidth;       // override point
- (CGSize)computeSizeByHeight :(CGFloat)aHeight;      // override point

- (void)applyDom  :(IDEAAppletDomNode *)aDom;         // override point
- (void)applyStyle:(IDEAAppletRenderStyle *)aStyle;   // override point
- (void)applyFrame:(CGRect)aFrame;                    // override point

@end

#pragma mark -

@interface IDEAAppletRenderObject : IDEAAppletTreeNode

@prop_strong( NSNumber              *,    id );
@prop_unsafe( IDEAAppletDomNode     *,    dom );
@prop_strong( IDEAAppletRenderStyle *,    style );

@prop_strong( UIView                *,    view );
@prop_strong( Class                  ,    viewClass );

@prop_readonly( IDEAAppletRenderObject *, root );
@prop_unsafe( IDEAAppletRenderObject   *, parent );
@prop_unsafe( IDEAAppletRenderObject   *, prev );
@prop_unsafe( IDEAAppletRenderObject   *, next );

+ (instancetype)renderObject;
+ (instancetype)renderObjectWithDom:(IDEAAppletDomNode *)dom andStyle:(IDEAAppletRenderStyle *)style;

- (UIView *)createViewWithIdentifier:(NSString *)identifier;      // override point

- (void)bindOutletsTo:(NSObject *)container;                  // override point
- (void)unbindOutletsFrom:(NSObject *)container;               // override point

- (void)bindView:(UIView *)view;                           // override point
- (void)unbindView;                                       // override point

- (void)bindDom:(IDEAAppletDomNode *)newDom;                     // override point
- (void)unbindDom;                                       // override point

- (void)bindStyle:(IDEAAppletRenderStyle *)newStyle;               // override point
- (void)unbindStyle;                                    // override point

- (void)relayout;                                       // override point
- (void)restyle;                                       // override point
- (void)rechain;                                       // override point

- (CGSize)computeSize:(CGSize)bound;                        // override point
- (CGFloat)computeWidth:(CGFloat)height;                     // override point
- (CGFloat)computeHeight:(CGFloat)width;                     // override point

- (IDEAAppletRenderObject *)prevObject;                        // override point
- (IDEAAppletRenderObject *)nextObject;                        // override point

@end

#endif   // #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
