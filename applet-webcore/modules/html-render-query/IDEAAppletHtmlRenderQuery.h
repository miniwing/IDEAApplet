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

#import "IDEAAppletHtmlRenderObject.h"

#pragma mark -

@class  IDEAAppletHtmlRenderQuery;
typedef IDEAAppletHtmlRenderQuery * (^IDEAAppletHtmlRenderQueryBlockN)( id first, ... );

#pragma mark -

@interface IDEAAppletHtmlRenderQuery : NSObject<NSArrayProtocol>

@prop_strong( NSMutableArray *,               input );
@prop_strong( NSMutableArray *,               output );

@prop_readonly( NSArray *,                  views );
@prop_readonly( UIView *,                  lastView );
@prop_readonly( UIView *,                  firstView );

@prop_readonly( IDEAAppletHtmlRenderQueryBlockN,   ATTR );
@prop_readonly( IDEAAppletHtmlRenderQueryBlockN,   SET_CLASS );
@prop_readonly( IDEAAppletHtmlRenderQueryBlockN,   ADD_CLASS );
@prop_readonly( IDEAAppletHtmlRenderQueryBlockN,   REMOVE_CLASS );
@prop_readonly( IDEAAppletHtmlRenderQueryBlockN,   TOGGLE_CLASS );

+ (IDEAAppletHtmlRenderQuery *)renderQuery;
+ (IDEAAppletHtmlRenderQuery *)renderQuery:(NSArray *)array;

- (void)input:(IDEAAppletHtmlRenderObject *)object;
- (void)output:(IDEAAppletHtmlRenderObject *)object;
- (void)execute:(NSString *)condition;

@end

#pragma mark -

#undef   $
#define $   __dollar( self )

#if defined(__cplusplus)
extern "C"   IDEAAppletHtmlRenderQueryBlockN __dollar( id context );
#else   // #if defined(__cplusplus)
extern      IDEAAppletHtmlRenderQueryBlockN __dollar( id context );
#endif   // #if defined(__cplusplus)

#endif   // #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
