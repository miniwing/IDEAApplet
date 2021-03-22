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

#import "IDEAAppletHtmlDocumentWorklet_40MergeStyleTree.h"

#import "__pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "IDEAAppletHtmlRenderObject.h"
#import "IDEAAppletHtmlRenderContainer.h"
#import "IDEAAppletHtmlRenderElement.h"
#import "IDEAAppletHtmlRenderText.h"
#import "IDEAAppletHtmlRenderViewport.h"
#import "IDEAAppletHtmlRenderStyle.h"

#import "IDEAAppletHtmlUserAgent.h"

#import "IDEAAppletCSSParser.h"
#import "IDEAAppletCSSStyleSheet.h"
#import "IDEAAppletCSSMediaQuery.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation IDEAAppletHtmlDocumentWorklet_40MergeStyleTree

- (BOOL)processWithContext:(IDEAAppletHtmlDocument *)document
{
   if ( document.domTree )
   {
      [self parseDocument:document];
   }

   return YES;
}

- (void)parseDocument:(IDEAAppletHtmlDocument *)document
{
   document.styleTree = [IDEAAppletCSSStyleSheet styleSheet];
   
// load default stylesheets

   for ( IDEAAppletStyleSheet * styleSheet in [IDEAAppletHtmlUserAgent sharedInstance].defaultStyleSheets )
   {
      BOOL isCompatible = [[IDEAAppletCSSMediaQuery sharedInstance] test:styleSheet.media];
      if ( isCompatible )
      {
         [document.styleTree merge:styleSheet];
      }
   }

// load document stylesheets

   for ( IDEAAppletHtmlDocument * thisDocument = document; nil != thisDocument; thisDocument = (IDEAAppletHtmlDocument *)thisDocument.parent )
   {
      for ( IDEAAppletStyleSheet * styleSheet in [thisDocument.externalStylesheets copy] )
      {
         BOOL isCompatible = [[IDEAAppletCSSMediaQuery sharedInstance] test:styleSheet.media];
         if ( isCompatible )
         {
            [document.styleTree merge:styleSheet];
         }
      }
   }

// parse sub documents

   for ( IDEAAppletResource * resource in [document.externalImports copy] )
   {
      if ( [resource isKindOfClass:[IDEAAppletHtmlDocument class]] )
      {
         [self parseDocument:(IDEAAppletHtmlDocument *)resource];
      }
   }
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( WebCore, HtmlDocumentWorklet_40MergeStyleTree )

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
