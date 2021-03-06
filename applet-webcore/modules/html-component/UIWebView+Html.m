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

#import "UIWebView+Html.h"

#import "__pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "IDEAAppletHtmlRenderStyle.h"
#import "IDEAAppletHtmlRenderObject.h"
#import "IDEAAppletHtmlRenderStoreScope.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

#if __UIWebView__
@implementation UIWebView(Html)

+ (CSSViewHierarchy)style_viewHierarchy
{
   return CSSViewHierarchy_Leaf;
}

#pragma mark -

- (void)html_applyDom:(IDEAAppletHtmlDomNode *)dom
{
   [super html_applyDom:dom];
}

- (void)html_applyStyle:(IDEAAppletHtmlRenderStyle *)style
{
   [super html_applyStyle:style];
}

- (void)html_applyFrame:(CGRect)newFrame
{
   [super html_applyFrame:newFrame];
}

#pragma mark -

- (id)store_serialize
{
   id data = [super store_serialize];
   if ( nil != data )
      return data;

   return [self.request.URL absoluteString];
}

- (void)store_unserialize:(id)obj
{
   [super store_unserialize:obj];
   
   [self stopLoading];
   
   NSString * path = [obj toString];
   if ( nil == path )
      return;
   
   if ( NO == [path hasPrefix:@"http://"] && NO == [path hasPrefix:@"https://"] )
   {
      path = [NSString stringWithFormat:@"http://%@", path];
   }

   NSArray * cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
   
   for ( NSHTTPCookie * cookie in cookies )
   {
      [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
   }
   
   [self loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:path]]];
}

- (void)store_zerolize
{
   [super store_zerolize];
   
   [self stopLoading];
}

@end
#endif /* __UIWebView__ */

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( WebCore, UIWebView_Html )

DESCRIBE( before )
{
}

DESCRIBE( after )
{
}

TEST_CASE_END

#endif   // #if __SAMURAI_TESTING__

#endif   // #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "__pragma_pop.h"
