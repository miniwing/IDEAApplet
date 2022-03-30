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

// ----------------------------------
// Private Head Files
#import "AppletCore.h"
// ----------------------------------

#import "IDEAAppletHtmlRenderWorklet_20UpdateStyle.h"

#import "__pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "IDEAAppletHtmlRenderObject.h"
#import "IDEAAppletHtmlRenderStyle.h"
#import "IDEAAppletHtmlUserAgent.h"

#import "IDEAAppletCSSParser.h"
#import "IDEAAppletCSSStyleSheet.h"
#import "IDEAAppletCSSMediaQuery.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation IDEAAppletHtmlRenderWorklet_20UpdateStyle

- (BOOL)processWithContext:(IDEAAppletHtmlRenderObject *)aRenderObject {
   
   [self updateStyleForRenderObject:aRenderObject];
   
   return YES;
}

- (NSMutableSet *)diffStyle:(NSDictionary *)aStyle1 withStyle:(NSDictionary *)aStyle2
{
   NSMutableSet   *stDiffKeys = [NSMutableSet set];
   NSMutableSet   *stAllKeys  = [NSMutableSet set];
   
   [stAllKeys addObjectsFromArray:aStyle1.allKeys];
   [stAllKeys addObjectsFromArray:aStyle2.allKeys];
   
   for ( NSString *szKey in stAllKeys ) {
      
      NSString *szValue1   = [aStyle1 objectForKey:szKey];
      NSString *szValue2   = [aStyle2 objectForKey:szKey];
      
      if ( NO == [[szValue1 description] isEqualToString:[szValue2 description]] ) {
         
         [stDiffKeys addObject:szKey];
         
      } // if ( NO == [[value1 description] isEqualToString:[value2 description]] )
      
   } // for ( NSString * key in stAllKeys )
   
   return stDiffKeys;
}

- (void)updateStyleForRenderObject:(IDEAAppletHtmlRenderObject *)aRenderObject {
   
   if ( aRenderObject.view ) {
      
      NSDictionary   *stMergedStyle = [self computeStyleForForRenderObject:aRenderObject];

      [aRenderObject.style clearProperties];
      [aRenderObject.style mergeProperties:stMergedStyle];

      [aRenderObject computeProperties];

      DEBUG_RENDERER_STYLE( aRenderObject );

      [aRenderObject.view html_applyStyle:aRenderObject.style];
      
   } // if ( aRenderObject.view )

   for ( IDEAAppletHtmlRenderObject *stChild in aRenderObject.childs ) {
      
      [self updateStyleForRenderObject:stChild];
      
   } // for ( IDEAAppletHtmlRenderObject * child in aRenderObject.childs )
   
   return;
}

#pragma mark -

- (NSMutableDictionary *)computeStyleForForRenderObject:(IDEAAppletHtmlRenderObject *)aRenderObject {
   
   NSMutableDictionary  *stStyleProperties = [[NSMutableDictionary alloc] init];

// default dom style

   [stStyleProperties addEntriesFromDictionary:aRenderObject.dom.computedStyle];
   
// match style - tag {} / .class {} / #id {}
   
   NSDictionary   *stMatchedStyle   = [aRenderObject.dom.document.styleTree queryForObject:aRenderObject];
   
   for ( NSString * szKey in stMatchedStyle ) {
      
      NSObject * stValue = [stMatchedStyle objectForKey:szKey];
      
      if ( stValue ) {
         
         [stStyleProperties setObject:stValue forKey:szKey];
      }
      
   } // for ( NSString * szKey in stMatchedStyle )

// inherits from parent

   if ( aRenderObject.parent ) {
      
      for ( NSString *szKey in [IDEAAppletHtmlUserAgent sharedInstance].defaultCSSInherition ) {
         
         NSString *szValue = [aRenderObject.parent.customStyle objectForKey:szKey];

         if ( szValue ) {
            
            [stStyleProperties setObject:szValue forKey:szKey];
            
         }
         
      } // for ( NSString * key in [IDEAAppletHtmlUserAgent sharedInstance].defaultCSSInherition )
   }

// custom style properties

   for ( NSString * szKey in aRenderObject.customStyle.properties ) {
      
      NSObject *stValue = [aRenderObject.customStyle.properties objectForKey:szKey];
      
      if ( stValue ) {
         
         [stStyleProperties setObject:stValue forKey:szKey];
         
      } /* End if () */
      
   } // for ( NSString * szKey in aRenderObject.customStyle.properties )

   return stStyleProperties;
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( WebCore, HtmlRenderWorklet_20UpdateStyle )

DESCRIBE( before ) {
   
}

DESCRIBE( after ) {
   
}

TEST_CASE_END

#endif   // #if __SAMURAI_TESTING__

#endif   // #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "__pragma_pop.h"
