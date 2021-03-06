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

#import "IDEAAppletHtmlDocumentWorklet_60ApplyStyleTree.h"

#import "__pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "IDEAAppletHtmlRenderObject.h"
#import "IDEAAppletHtmlRenderContainer.h"
#import "IDEAAppletHtmlRenderElement.h"
#import "IDEAAppletHtmlRenderText.h"
#import "IDEAAppletHtmlRenderViewport.h"
#import "IDEAAppletHtmlRenderStyle.h"
#import "IDEAAppletHtmlUserAgent.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation IDEAAppletHtmlDocumentWorklet_60ApplyStyleTree

- (BOOL)processWithContext:(IDEAAppletHtmlDocument *)document
{
   if ( document.domTree )
   {
      [self mergeStyleForDomNode:document.domTree];
   }
   
   return YES;
}

- (NSMutableDictionary *)computeStyleForDomNode:(IDEAAppletHtmlDomNode *)domNode
{
   NSMutableDictionary * styleProperties = [[NSMutableDictionary alloc] init];
   
   [styleProperties addEntriesFromDictionary:[IDEAAppletHtmlUserAgent sharedInstance].defaultCSSValue];
   
   // style inherition
   
   if ( domNode.parent )
   {
      for ( NSString * key in [IDEAAppletHtmlUserAgent sharedInstance].defaultCSSInherition )
      {
         NSString * value = [domNode.parent.computedStyle objectForKey:key];
         
         if ( value )
         {
            [styleProperties setObject:value forKey:key];
         }
      }
   }
   
   // attributed style
   
   for ( NSArray * pair in [IDEAAppletHtmlUserAgent sharedInstance].defaultDOMAttributedStyle )
   {
      NSString * attrName1 = [pair objectAtIndex:0];
      NSString * attrName2 = [pair objectAtIndex:1];
      
      NSString * attrValue = [domNode.attr objectForKey:attrName1];
      
      if ( attrValue )
      {
         [styleProperties setObject:attrValue forKey:attrName2];
      }
   }
   
   // inline style
   
   if ( domNode.attrStyle )
   {
      NSDictionary * attrStyle = [[IDEAAppletCSSParser sharedInstance] parseDictionary:domNode.attrStyle];
      
      for ( NSString * key in attrStyle )
      {
         NSObject * value = [attrStyle objectForKey:key];
         
         if ( value )
         {
            [styleProperties setObject:value forKey:key];
         }
      }
   }
   
   // match style - tag {} / .class {} / #id {}
   
   NSDictionary * matchedStyle = [domNode.document.styleTree queryForObject:domNode];
   
   for ( NSString * key in matchedStyle )
   {
      NSObject * value = [matchedStyle objectForKey:key];
      
      if ( value )
      {
         [styleProperties setObject:value forKey:key];
      }
   }
   
   // style inherition
   
   if ( domNode.parent )
   {
      for ( NSString * key in styleProperties.allKeys )
      {
         BOOL      inherit = NO;
         NSObject *   object = [styleProperties objectForKey:key];
         
         if ( [object isKindOfClass:[NSString class]] )
         {
            inherit = (NSOrderedSame == [(NSString *)object compare:@"inherit"]) ? YES : NO;
         }
         else if ( [object isKindOfClass:[IDEAAppletCSSObject class]] )
         {
            inherit = [(IDEAAppletCSSObject *)object isInherit];
         }
         
         if ( inherit )
         {
            NSObject * inheritedValue = [domNode.parent.computedStyle objectForKey:key];
            
            if ( inheritedValue )
            {
               [styleProperties setObject:inheritedValue forKey:key];
            }
            else
            {
               [styleProperties removeObjectForKey:key];
            }
         }
      }
   }
   
   return styleProperties;
}

- (void)mergeStyleForDomNode:(IDEAAppletHtmlDomNode *)domNode
{
   DEBUG_HTML_STYLE( domNode );
   
   if ( nil == domNode.document )
      return;
   
   // dom
   
   NSMutableDictionary * domStyle = [self computeStyleForDomNode:domNode];
   
   [domNode.computedStyle removeAllObjects];
   [domNode.computedStyle addEntriesFromDictionary:domStyle];
   
   for ( IDEAAppletHtmlDomNode * childDom in domNode.childs )
   {
      [self mergeStyleForDomNode:childDom];
   }
   
   // shadow root
   
   if ( domNode.shadowRoot )
   {
      NSMutableDictionary * shadowStyle = [self computeStyleForDomNode:domNode.shadowRoot];
      
      [shadowStyle addEntriesFromDictionary:domStyle];
      
      [domNode.shadowRoot.computedStyle removeAllObjects];
      [domNode.shadowRoot.computedStyle addEntriesFromDictionary:shadowStyle];
      
      for ( IDEAAppletHtmlDomNode * childDom in domNode.shadowRoot.childs )
      {
         [self mergeStyleForDomNode:childDom];
      }
   }
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( WebCore, HtmlDocumentWorklet_60ApplyStyleTree )

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
