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

#import "IDEAAppletHtmlDocumentWorklet_70BuildRenderTree.h"

#import "__pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "IDEAAppletHtmlRenderStyle.h"
#import "IDEAAppletHtmlRenderContainer.h"
#import "IDEAAppletHtmlRenderElement.h"
#import "IDEAAppletHtmlRenderText.h"
#import "IDEAAppletHtmlRenderViewport.h"

#import "IDEAAppletHtmlUserAgent.h"

#import "IDEAAppletCSSParser.h"
#import "IDEAAppletCSSStyleSheet.h"
#import "IDEAAppletCSSMediaQuery.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation IDEAAppletHtmlDocumentWorklet_70BuildRenderTree

- (BOOL)processWithContext:(IDEAAppletHtmlDocument *)document
{
   if ( document.domTree )
   {
      document.renderTree = [self renderDomNode:document.domTree forContainer:nil inDocument:document];

      if ( nil == document.renderTree )
      {
         ERROR( @"Failed to render document with root dom node '%@'", document.domTree.tag );
      }
      else
      {
         [document.renderTree dump];
      }
   }

   return YES;
}

- (IDEAAppletHtmlRenderObject *)renderDomNode:(IDEAAppletHtmlDomNode *)domNode forContainer:(IDEAAppletHtmlRenderObject *)container inDocument:(IDEAAppletHtmlDocument *)document
{
   IDEAAppletHtmlRenderObject * renderObject = nil;

   if ( DomNodeType_Document == domNode.type )
   {
      renderObject = [self renderDomNodeDocument:domNode forContainer:container inDocument:document];
   }
   else if ( DomNodeType_Element == domNode.type )
   {
      renderObject = [self renderDomNodeElement:domNode forContainer:container inDocument:document];
   }
   else if ( DomNodeType_Text == domNode.type )
   {
      renderObject = [self renderDomNodeText:domNode forContainer:container inDocument:document];
   }
   else if ( DomNodeType_Data == domNode.type )
   {
      renderObject = [self renderDomNodeData:domNode forContainer:container inDocument:document];
   }
   else if ( DomNodeType_Comment == domNode.type )
   {
      ERROR( @"Comment '%@'", domNode.text );
   }
   else
   {
      ERROR( @"Unsupport element type for dom node '%@'", domNode.tag );
   }

   return renderObject;
}

- (IDEAAppletHtmlRenderObject *)renderDomNodeDocument:(IDEAAppletHtmlDomNode *)domNode forContainer:(IDEAAppletHtmlRenderObject *)container inDocument:(IDEAAppletHtmlDocument *)document
{
   DEBUG_HTML_RENDER( domNode );

   IDEAAppletHtmlRenderObject * rootObject = [IDEAAppletHtmlRenderViewport renderObjectWithDom:nil andStyle:nil];
   
   if ( rootObject )
   {
      [rootObject renderWillLoad];

      [rootObject computeProperties];

      [self renderDomNodeElement:domNode forContainer:rootObject inDocument:document];
      
      [rootObject renderDidLoad];
   }
   
   return rootObject;
}

- (IDEAAppletHtmlRenderObject *)renderDomNodeElement:(IDEAAppletHtmlDomNode *)domNode forContainer:(IDEAAppletHtmlRenderObject *)container inDocument:(IDEAAppletHtmlDocument *)document
{
   DEBUG_HTML_RENDER( domNode );

   if ( domNode.shadowRoot )
   {
      PERF( @"tag '%@', shadow element", domNode.tag );

      IDEAAppletHtmlRenderStyle *   thisStyle = [IDEAAppletHtmlRenderStyle renderStyle:domNode.shadowRoot.computedStyle];
      IDEAAppletHtmlRenderObject *   thisObject = [IDEAAppletHtmlRenderContainer renderObjectWithDom:domNode andStyle:thisStyle];

      if ( thisObject )
      {
         [thisObject renderWillLoad];

         if ( container )
         {
            [container appendNode:thisObject];
         }
         
         [thisObject computeProperties];
         
         for ( IDEAAppletHtmlDomNode * childDom in domNode.shadowRoot.childs )
         {
            [self renderDomNode:childDom forContainer:thisObject inDocument:document];
         }
         
         [thisObject renderDidLoad];
      }
      
      return thisObject;
   }
   else
   {
        IDEAAppletHtmlRenderStyle *   thisStyle = [IDEAAppletHtmlRenderStyle renderStyle:domNode.computedStyle];
      IDEAAppletHtmlRenderObject *   thisObject = nil;

      CSSViewHierarchy   viewHierarchy = [thisStyle computeViewHierarchy:CSSViewHierarchy_Inherit];
      Class            viewClassType = nil;
      
      if ( CSSViewHierarchy_Inherit == viewHierarchy )
      {
         viewClassType = viewClassType ?: NSClassFromString( [thisStyle.appletViewClass string] );
         viewClassType = viewClassType ?: NSClassFromString( domNode.tag );
         
         if ( [viewClassType isSubclassOfClass:[UIView class]] )
         {
            Class superClass = class_getSuperclass( viewClassType );
            
            for ( ; superClass && superClass != [UIView class]; )
            {
               NSDictionary * defaultProperties = [document.styleTree queryForString:[superClass description]];
               
               if ( defaultProperties && [defaultProperties count] )
               {
                  IDEAAppletHtmlRenderStyle * defaultStyle = [IDEAAppletHtmlRenderStyle renderStyle:defaultProperties];
                  
                  viewHierarchy = [defaultStyle computeViewHierarchy:CSSViewHierarchy_Inherit];
               }
               
               if ( CSSViewHierarchy_Inherit != viewHierarchy )
               {
                  break;
               }

               superClass = class_getSuperclass( superClass );
            }
         }
      }
      
      if ( CSSViewHierarchy_Inherit == viewHierarchy )
      {
         viewHierarchy = CSSViewHierarchy_Leaf;
      }

      switch ( viewHierarchy )
      {
         case CSSViewHierarchy_Hidden:
         {
         }
         break;

         case CSSViewHierarchy_Branch:
         {
            for ( IDEAAppletHtmlDomNode * childDom in domNode.childs )
            {
               [self renderDomNode:childDom forContainer:container inDocument:document];
            }
         }
         break;
            
         case CSSViewHierarchy_Leaf:
         {
            thisObject = [IDEAAppletHtmlRenderElement renderObjectWithDom:domNode andStyle:thisStyle];
            
            if ( thisObject )
            {
               [thisObject renderWillLoad];
               
               if ( container )
               {
                  [container appendNode:thisObject];
               }
               
               [thisObject computeProperties];
               
               [thisObject renderDidLoad];
            }
         }
         break;
            
         case CSSViewHierarchy_Tree:
         {
            thisObject = [IDEAAppletHtmlRenderContainer renderObjectWithDom:domNode andStyle:thisStyle];
            
            if ( thisObject )
            {
               [thisObject renderWillLoad];
               
               if ( container )
               {
                  [container appendNode:thisObject];
               }
               
               [thisObject computeProperties];
               
               for ( IDEAAppletHtmlDomNode * childDom in domNode.childs )
               {
                  [self renderDomNode:childDom forContainer:thisObject inDocument:document];
               }
               
               [thisObject renderDidLoad];
            }
         }
         break;

         default:
            break;
      }

      return thisObject;
   }
}

- (IDEAAppletHtmlRenderObject *)renderDomNodeText:(IDEAAppletHtmlDomNode *)domNode forContainer:(IDEAAppletHtmlRenderObject *)container inDocument:(IDEAAppletHtmlDocument *)document
{
   DEBUG_HTML_RENDER( domNode );

   IDEAAppletHtmlRenderStyle *   thisStyle = [IDEAAppletHtmlRenderStyle renderStyle:domNode.computedStyle];
   IDEAAppletHtmlRenderObject *   thisObject = [IDEAAppletHtmlRenderText renderObjectWithDom:domNode andStyle:thisStyle];

   if ( thisObject )
   {
      [thisObject renderWillLoad];

      if ( container )
      {
         [container appendNode:thisObject];
      }

      [thisObject computeProperties];
      
      [thisObject renderDidLoad];
   }
   
   return thisObject;
}

- (IDEAAppletHtmlRenderObject *)renderDomNodeData:(IDEAAppletHtmlDomNode *)domNode forContainer:(IDEAAppletHtmlRenderObject *)container inDocument:(IDEAAppletHtmlDocument *)document
{
   DEBUG_HTML_RENDER( domNode );

   // TODO:
   
   return nil;
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( WebCore, HtmlDocumentWorklet_70BuildRenderTree )

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
