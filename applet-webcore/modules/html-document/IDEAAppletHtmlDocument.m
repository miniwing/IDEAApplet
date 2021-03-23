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

#import "IDEAAppletHtmlDocument.h"

#import "__pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "IDEAAppletHtmlDocumentWorkflow.h"

#import "IDEAAppletHtmlRenderStyle.h"
#import "IDEAAppletHtmlRenderObject.h"
#import "IDEAAppletHtmlRenderContainer.h"
#import "IDEAAppletHtmlRenderElement.h"
#import "IDEAAppletHtmlRenderText.h"
#import "IDEAAppletHtmlRenderViewport.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation IDEAAppletHtmlDocument
{
   IDEAAppletHtmlDocumentWorkflow_Parser *   _parserFlow;
   IDEAAppletHtmlDocumentWorkflow_Render *   _renderFlow;
}

@def_prop_dynamic( IDEAAppletHtmlDomNode *,      domTree );
@def_prop_dynamic( IDEAAppletCSSStyleSheet *,      styleTree );
@def_prop_dynamic( IDEAAppletHtmlRenderObject *,   renderTree );

@def_prop_strong( NSString *,   rootTag );
@def_prop_strong( NSString *,   headTag );
@def_prop_strong( NSString *,   bodyTag );

- (id)init
{
   self = [super init];
   if ( self )
   {
      self.rootTag = @"html";
      self.headTag = @"head";
      self.bodyTag = @"body";
   }
   return self;
}

- (void)dealloc
{
   self.rootTag = nil;
   self.headTag = nil;
   self.bodyTag = nil;
   
   _parserFlow = nil;
   _renderFlow = nil;
   
   __SUPER_DEALLOC;
   
   return;
}

#pragma mark -

+ (NSArray *)supportedExtensions
{
   return [NSArray arrayWithObjects:@"html", @"htm", nil];
}

+ (NSArray *)supportedTypes
{
   return [NSArray arrayWithObjects:@"text/html", nil];
}

+ (NSString *)baseDirectory
{
   return @"/www/html";
}

#pragma mark -

- (IDEAAppletHtmlDomNode *)getRootDomNode
{
   return (IDEAAppletHtmlDomNode *)[self.domTree getFirstElementByTagName:self.rootTag];
}

- (IDEAAppletHtmlDomNode *)getHeadDomNode
{
   return (IDEAAppletHtmlDomNode *)[self.domTree getFirstElementByTagName:self.headTag];
}

- (IDEAAppletHtmlDomNode *)getBodyDomNode
{
   return (IDEAAppletHtmlDomNode *)[self.domTree getFirstElementByTagName:self.bodyTag];
}

#pragma mark -

- (BOOL)parse
{
   if ( nil == _parserFlow )
   {
      _parserFlow = [IDEAAppletHtmlDocumentWorkflow_Parser workflowWithContext:self];
   }
   
   return [_parserFlow process];
}

- (BOOL)reflow
{
   if ( nil == _renderFlow )
   {
      _renderFlow = [IDEAAppletHtmlDocumentWorkflow_Render workflowWithContext:self];
   }
   
   return [_renderFlow process];
}

#pragma mark -

- (void)configureForView:(UIView *)view
{
   // TODO:
}

- (void)configureForViewController:(UIViewController *)viewController
{
   IDEAAppletHtmlDomNode * head = [self getHeadDomNode];
   
   UIImage *   navbarBgImage = nil;
   UIColor *   navbarBgColor = nil;
   UIColor *   navbarTintColor = nil;
   UIColor *   navbarTextColor = nil;
   NSString *   navbarTitle = nil;
   NSString *   navbarLogo = nil;
   
   if ( head )
   {
      for ( IDEAAppletHtmlDomNode * child in head.childs )
      {
         if ( NSOrderedSame == [child.tag compare:@"meta" options:NSCaseInsensitiveSearch] )
         {
            NSString * name = child.attrName;
            NSString * content = child.attrContent;
            
            if ( name && content )
            {
               if ( [name isEqualToString:@"navbar-bg-color"] )
               {
                  navbarBgColor = [IDEAAppletCSSColor parseColorString:content];
               }
               else if ( [name isEqualToString:@"navbar-bg-image"] )
               {
                  navbarBgImage = [UIImage imageNamed:content];
               }
               else if ( [name isEqualToString:@"navbar-tint-color"] )
               {
                  navbarTintColor = [IDEAAppletCSSColor parseColorString:content];
               }
               else if ( [name isEqualToString:@"navbar-text-color"] )
               {
                  navbarTextColor = [IDEAAppletCSSColor parseColorString:content];
               }
               else if ( [name isEqualToString:@"navbar-logo"] )
               {
                  NSString * prefix = @"url(";
                  NSString * suffix = @")";
                  
                  if ( [content hasPrefix:prefix] && [content hasSuffix:suffix] )
                  {
                     navbarLogo = [content substringWithRange:NSMakeRange(prefix.length, content.length - prefix.length - suffix.length)];
                  }
               }
            }
         }
         else if ( NSOrderedSame == [child.tag compare:@"title" options:NSCaseInsensitiveSearch] )
         {
            navbarTitle = [[child computeInnerText] normalize];
         }
      }
   }
   
   CGSize navigationBarSize = CGSizeMake( [UIScreen mainScreen].bounds.size.width, 64.0f );
   
   if ( navbarBgColor )
   {
      navbarBgImage = navbarBgImage ?: [UIImage applet_imageWithColor:navbarBgColor size:navigationBarSize];
   }
   
   UINavigationBar * navigationBar = viewController.navigationController.navigationBar;
   
   if ( navbarTintColor )
   {
      [navigationBar setTintColor:navbarTintColor];
   }
   
   if ( navbarTintColor )
   {
      [navigationBar setTitleTextAttributes:@{ NSForegroundColorAttributeName: navbarTintColor }];
   }
   
   if ( navbarBgColor )
   {
      [navigationBar setBackgroundColor:navbarBgColor];
   }
   
   if ( navbarBgImage )
   {
      [navigationBar setBackgroundImage:navbarBgImage forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];
   }
   
   if ( navbarLogo )
   {
      UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:navbarLogo]];
      imageView.contentMode = UIViewContentModeScaleAspectFit;
      imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
      
      viewController.navigationItem.title = nil;
      viewController.navigationItem.titleView = imageView;
   }
   else
   {
      if ( navbarTitle )
      {
         viewController.navigationItem.title = navbarTitle;
         viewController.navigationItem.titleView = nil;
      }
      else
      {
         viewController.navigationItem.title = nil;
         viewController.navigationItem.titleView = nil;
      }
   }
}

#pragma mark -

- (NSString *)uniqueIdentifier
{
   return [NSString stringWithFormat:@"%@-%@", self.domTree.tag, self.renderTree.id];
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( WebCore, HtmlDocument )

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
