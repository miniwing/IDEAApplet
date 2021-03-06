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

#import "UIWebView+IDEAApplet.h"

#import "__pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

#if __UIWebView__
@implementation UIWebView(IDEAApplet)

+ (id)createInstanceWithRenderer:(IDEAAppletRenderObject *)aRenderer identifier:(NSString *)aIdentifier {
   
   UIWebView   *stWebView = [[self alloc] initWithFrame:CGRectZero];
   
   stWebView.renderer = aRenderer;
   stWebView.scalesPageToFit = NO;
   stWebView.allowsInlineMediaPlayback = YES;
   
   return stWebView;
}

#pragma mark -

+ (BOOL)supportTapGesture {
   
   return NO;
}

+ (BOOL)supportSwipeGesture {
   
   return NO;
}

+ (BOOL)supportPinchGesture {
   
   return NO;
}

+ (BOOL)supportPanGesture {
   
   return NO;
}

#pragma mark -

- (id)serialize {
   
   return [self.request.URL absoluteString];
}

- (void)unserialize:(id)obj {
   
   NSString * path = [obj toString];
   if ( nil == path )
      return;
   
   if ( NO == [path hasPrefix:@"http://"] && NO == [path hasPrefix:@"https://"] ) {
      
      path = [NSString stringWithFormat:@"http://%@", path];
   }
   
   NSArray * cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
   
   for ( NSHTTPCookie * cookie in cookies ) {
      
      [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
   }
   
   [self loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:path]]];
}

- (void)zerolize {
   
   [self stopLoading];
}

#pragma mark -

#pragma mark -

- (void)applyDom:(IDEAAppletDomNode *)dom {
   
   [super applyDom:dom];
}

- (void)applyStyle:(IDEAAppletRenderStyle *)style {
   
   [super applyStyle:style];
}

- (void)applyFrame:(CGRect)frame {
   
   [super applyFrame:frame];
}

#pragma mark -

- (CGSize)computeSizeBySize:(CGSize)size {
   
   return [super computeSizeBySize:size];
}

- (CGSize)computeSizeByWidth:(CGFloat)width {
   
   return [super computeSizeByWidth:width];
}

- (CGSize)computeSizeByHeight:(CGFloat)height {
   
   return [super computeSizeByHeight:height];
}

@end

#endif /* __UIWebView__ */

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( UI, UIWebView )

DESCRIBE( before ) {
   
}

DESCRIBE( after ) {
   
}

TEST_CASE_END

#endif   // #if __SAMURAI_TESTING__

#endif   // #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "__pragma_pop.h"
