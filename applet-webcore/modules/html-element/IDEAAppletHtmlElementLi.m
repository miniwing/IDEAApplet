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

#import "IDEAAppletHtmlElementLi.h"

#import "__pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "IDEAAppletHtmlRenderStyle.h"
#import "IDEAAppletHtmlRenderObject.h"
#import "IDEAAppletHtmlRenderStoreScope.h"
#import "IDEAAppletHtmlUserAgent.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation IDEAAppletHtmlElementLi

@def_prop_strong( UILabel *,   listIcon )
@def_prop_assign( HtmlListType,   listType )
@def_prop_assign( NSUInteger,   listIndex )

- (id)initWithFrame:(CGRect)frame
{
   self = [super initWithFrame:frame];
   if ( self )
   {
      self.listType = HtmlListType_None;
      self.listIndex = 0;
   }
   return self;
}

- (void)dealloc
{
   [self.listIcon removeFromSuperview];
   self.listIcon = nil;
}

#pragma mark -

- (void)html_applyDom:(IDEAAppletHtmlDomNode *)dom
{
   [super html_applyDom:dom];
   
   self.listIndex = 0;

   if ( dom.parent )
   {
      for ( IDEAAppletHtmlDomNode * sibling in dom.parent.childs )
      {
         if ( sibling == dom )
            break;

         if ( NSOrderedSame == [sibling.tag compare:dom.tag] )
         {
            self.listIndex += 1;
         }
      }
   }
}

- (void)html_applyStyle:(IDEAAppletHtmlRenderStyle *)style
{
   [super html_applyStyle:style];
   
   IDEAAppletCSSValue * listStyleType = style.listStyleType;
//   IDEAAppletCSSValue * listStyleImage = style.listStyleImage;
//   IDEAAppletCSSValue * listStylePosition = style.listStylePosition;

   TODO( "list-style-image" );
   TODO( "list-style-position" );
   
   if ( listStyleType )
   {
      if ( [listStyleType isString:@"disc"] )
      {
         self.listType = HtmlListType_Disc;
      }
      else if ( [listStyleType isString:@"circle"] )
      {
         self.listType = HtmlListType_Circle;
      }
      else if ( [listStyleType isString:@"square"] )
      {
         self.listType = HtmlListType_Square;
      }
      else if ( [listStyleType isString:@"decimal"] )
      {
         self.listType = HtmlListType_Decimal;
      }
      else if ( [listStyleType isString:@"decimal-leading-zero"] )
      {
         self.listType = HtmlListType_Decimal;
      }
      else if ( [listStyleType isString:@"lower-roman"] )
      {
         // ??????????????????(i, ii, iii, iv, v, ??????)
         
         self.listType = HtmlListType_Decimal;
      }
      else if ( [listStyleType isString:@"upper-roman"] )
      {
         // ??????????????????(I, II, III, IV, V, ??????)
         
         self.listType = HtmlListType_Decimal;
      }
      else if ( [listStyleType isString:@"lower-alpha"] )
      {
         // ??????????????????The marker is lower-alpha (a, b, c, d, e, ??????)
         
         self.listType = HtmlListType_Decimal;
      }
      else if ( [listStyleType isString:@"upper-alpha"] )
      {
         // ??????????????????The marker is upper-alpha (A, B, C, D, E, ??????)
         
         self.listType = HtmlListType_Decimal;
      }
      else if ( [listStyleType isString:@"lower-greek"] )
      {
         // ??????????????????(alpha, beta, gamma, ??????)
         
         self.listType = HtmlListType_Decimal;
      }
      else if ( [listStyleType isString:@"lower-latin"] )
      {
         // ??????????????????(a, b, c, d, e, ??????)
         
         self.listType = HtmlListType_Decimal;
      }
      else if ( [listStyleType isString:@"upper-latin"] )
      {
         // ??????????????????(A, B, C, D, E, ??????)
         
         self.listType = HtmlListType_Decimal;
      }
      else if ( [listStyleType isString:@"hebrew"] )
      {
         // ??????????????????????????????
         
         self.listType = HtmlListType_Decimal;
      }
      else if ( [listStyleType isString:@"armenian"] )
      {
         // ?????????????????????????????????
         
         self.listType = HtmlListType_Decimal;
      }
      else if ( [listStyleType isString:@"georgian"] )
      {
         // ??????????????????????????????(an, ban, gan, ??????)
         
         self.listType = HtmlListType_Decimal;
      }
      else if ( [listStyleType isString:@"cjk-ideographic"] )
      {
         // ?????????????????????
         
         self.listType = HtmlListType_Decimal;
      }
      else if ( [listStyleType isString:@"hiragana"] )
      {
         // ????????????a, i, u, e, o, ka, ki, ???????????????????????????
         
         self.listType = HtmlListType_Decimal;
      }
      else if ( [listStyleType isString:@"katakana"] )
      {
         // ????????????A, I, U, E, O, KA, KI, ???????????????????????????
         
         self.listType = HtmlListType_Decimal;
      }
      else if ( [listStyleType isString:@"hiragana-iroha"] )
      {
         // ????????????i, ro, ha, ni, ho, he, to, ???????????????????????????
         
         self.listType = HtmlListType_Decimal;
      }
      else if ( [listStyleType isString:@"katakana-iroha"] )
      {
         // ????????????I, RO, HA, NI, HO, HE, TO, ???????????????????????????
         
         self.listType = HtmlListType_Decimal;
      }
      else if ( [listStyleType isString:@"none"] )
      {
         self.listType = HtmlListType_None;
      }
      else
      {
         self.listType = HtmlListType_None;
      }
   }
   else
   {
      self.listType = HtmlListType_None;
   }
}

- (void)html_applyFrame:(CGRect)newFrame
{
   [super html_applyFrame:newFrame];

   IDEAAppletHtmlRenderObject * renderer = (IDEAAppletHtmlRenderObject *)self.renderer;
   
   if ( renderer && CSSDisplay_ListItem != renderer.display )
   {
      self.listIcon.hidden = YES;
      return;
   }
   
   if ( HtmlListType_None == self.listType )
   {
      self.listIcon.hidden = YES;
      return;
   }

   if ( nil == self.listIcon )
   {
      self.listIcon = [[UILabel alloc] init];
      
      [self addSubview:self.listIcon];
      [self bringSubviewToFront:self.listIcon];
   }
   
   if ( HtmlListType_Disc == self.listType )
   {
      CGRect iconFrame;
      
      iconFrame.size.width = 6.0f;
      iconFrame.size.height = 6.0f;
      iconFrame.origin.x = -iconFrame.size.width - 10.0f;
      iconFrame.origin.y = 6.0f; // (newFrame.size.height - iconFrame.size.height) / 2.0f;
      
      self.listIcon.frame = iconFrame;
      self.listIcon.hidden = NO;
      self.listIcon.layer.borderColor = [[UIColor clearColor] CGColor];
      self.listIcon.layer.borderWidth = 0.0f;
      self.listIcon.layer.cornerRadius = 3.0f;
      self.listIcon.layer.masksToBounds = YES;
      self.listIcon.backgroundColor = [UIColor darkGrayColor];
      
      self.listIcon.text = nil;
   }
   else if ( HtmlListType_Circle == self.listType )
   {
      CGRect iconFrame;
      
      iconFrame.size.width = 6.0f;
      iconFrame.size.height = 6.0f;
      iconFrame.origin.x = -iconFrame.size.width - 10.0f;
      iconFrame.origin.y = 6.0f; // (newFrame.size.height - iconFrame.size.height) / 2.0f;

      self.listIcon.frame = iconFrame;
      self.listIcon.hidden = NO;
      self.listIcon.layer.borderColor = [[UIColor clearColor] CGColor];
      self.listIcon.layer.borderWidth = 3.0f;
      self.listIcon.layer.cornerRadius = 3.0f;
      self.listIcon.layer.masksToBounds = YES;
      self.listIcon.backgroundColor = [UIColor darkGrayColor];
      
      self.listIcon.text = nil;
   }
   else if ( HtmlListType_Square == self.listType )
   {
      CGRect iconFrame;
      
      iconFrame.size.width = 6.0f;
      iconFrame.size.height = 6.0f;
      iconFrame.origin.x = -iconFrame.size.width - 10.0f;
      iconFrame.origin.y = 6.0f; // (newFrame.size.height - iconFrame.size.height) / 2.0f;
      
      self.listIcon.frame = iconFrame;
      self.listIcon.hidden = NO;
      self.listIcon.layer.borderColor = [[UIColor clearColor] CGColor];
      self.listIcon.layer.borderWidth = 0.0f;
      self.listIcon.layer.cornerRadius = 0.0f;
      self.listIcon.layer.masksToBounds = YES;
      self.listIcon.backgroundColor = [UIColor darkGrayColor];
      
      self.listIcon.text = nil;
   }
   else if ( HtmlListType_Decimal == self.listType )
   {
      CGRect iconFrame;
      
      iconFrame.size.width = 40.0f;
      iconFrame.size.height = 12.0f;
      iconFrame.origin.x = -iconFrame.size.width - 10.0f;
      iconFrame.origin.y = 4.0f; // (newFrame.size.height - iconFrame.size.height) / 2.0f;
      
      self.listIcon.frame = iconFrame;
      self.listIcon.hidden = NO;
      self.listIcon.layer.borderColor = [[UIColor clearColor] CGColor];
      self.listIcon.layer.borderWidth = 0.0f;
      self.listIcon.layer.cornerRadius = 0.0f;
      self.listIcon.layer.masksToBounds = YES;
      self.listIcon.backgroundColor = [UIColor clearColor];

      self.listIcon.font = [IDEAAppletHtmlUserAgent sharedInstance].defaultFont;
      self.listIcon.textColor = [UIColor darkGrayColor];
      self.listIcon.textAlignment = NSTextAlignmentRight;
      self.listIcon.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
      self.listIcon.lineBreakMode = NSLineBreakByClipping;
      self.listIcon.numberOfLines = 1;

      self.listIcon.text = [NSString stringWithFormat:@"%lu.", (unsigned long)self.listIndex + 1];
   }
   else
   {
      self.listIcon.hidden = YES;
   }
}

#pragma mark -

- (id)store_serialize
{
   return [super store_serialize];
}

- (void)store_unserialize:(id)obj
{
   [super store_unserialize:obj];
}

- (void)store_zerolize
{
   [super store_zerolize];
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( WebCore, HtmlElementLi )

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
