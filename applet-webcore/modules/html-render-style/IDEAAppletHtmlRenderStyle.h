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

#import "IDEAAppletCSSObject.h"
#import "IDEAAppletCSSArray.h"
#import "IDEAAppletCSSValue.h"

#import "IDEAAppletCSSColor.h"
#import "IDEAAppletCSSFunction.h"
#import "IDEAAppletCSSString.h"
#import "IDEAAppletCSSUri.h"

#import "IDEAAppletCSSNumberAutomatic.h"
#import "IDEAAppletCSSNumberChs.h"
#import "IDEAAppletCSSNumberCm.h"
#import "IDEAAppletCSSNumberDeg.h"
#import "IDEAAppletCSSNumberDpcm.h"
#import "IDEAAppletCSSNumberDpi.h"
#import "IDEAAppletCSSNumberDppx.h"
#import "IDEAAppletCSSNumberEm.h"
#import "IDEAAppletCSSNumberQem.h"
#import "IDEAAppletCSSNumberEx.h"
#import "IDEAAppletCSSNumberFr.h"
#import "IDEAAppletCSSNumberGRad.h"
#import "IDEAAppletCSSNumberHz.h"
#import "IDEAAppletCSSNumberIn.h"
#import "IDEAAppletCSSNumberKhz.h"
#import "IDEAAppletCSSNumberMm.h"
#import "IDEAAppletCSSNumberMs.h"
#import "IDEAAppletCSSNumberPc.h"
#import "IDEAAppletCSSNumberPercentage.h"
#import "IDEAAppletCSSNumberPt.h"
#import "IDEAAppletCSSNumberPx.h"
#import "IDEAAppletCSSNumberQem.h"
#import "IDEAAppletCSSNumberRad.h"
#import "IDEAAppletCSSNumberRems.h"
#import "IDEAAppletCSSNumberS.h"
#import "IDEAAppletCSSNumberTurn.h"
#import "IDEAAppletCSSNumberVh.h"
#import "IDEAAppletCSSNumberVmax.h"
#import "IDEAAppletCSSNumberVmin.h"
#import "IDEAAppletCSSNumberVw.h"
#import "IDEAAppletCSSNumberConstant.h"

#import "IDEAAppletCSSParser.h"
#import "IDEAAppletCSSStyleSheet.h"
#import "IDEAAppletCSSMediaQuery.h"

#pragma mark -

#undef   css_value
#define   css_value( name ) \
      property (nonatomic, strong) IDEAAppletCSSValue * name

#undef   def_css_value
#define   def_css_value( getter, setter, key ) \
      dynamic getter; \
      - (IDEAAppletCSSValue *)getter { return [self getCSSValueForKey:key]; } \
      - (void)setter:(IDEAAppletCSSValue *)value { [self setCSSValue:value forKey:key]; }

#undef   css_array
#define   css_array( name ) \
      property (nonatomic, strong) IDEAAppletCSSArray * name

#undef   def_css_array
#define   def_css_array( getter, setter, key ) \
      dynamic getter; \
      - (IDEAAppletCSSArray *)getter { return [self getCSSArrayForKey:key]; } \
      - (void)setter:(IDEAAppletCSSArray *)array { [self setCSSArray:array forKey:key]; }

#pragma mark -

typedef enum
{
   CSSDisplay_Inherit = 0,         /// ???????????????
   CSSDisplay_None,            /// ?????????
   CSSDisplay_Block,            /// ?????????
   CSSDisplay_Inline,            /// ?????????
   CSSDisplay_InlineBlock,         /// ???????????????
   CSSDisplay_Flex,            /// ????????????
   CSSDisplay_InlineFlex,         /// ??????????????????
   CSSDisplay_Grid,            /// ????????????
   CSSDisplay_InlineGrid,         /// ??????????????????
   CSSDisplay_ListItem,         /// ?????????
   CSSDisplay_Table,            /// ???????????????????????????????????????????????? <table>????????????????????????????????????
   CSSDisplay_InlineTable,         /// ???????????????????????????????????????????????? <table>????????????????????????????????????
   CSSDisplay_TableRowGroup,      /// ??????????????????????????????????????????????????????????????? <tbody>??????
   CSSDisplay_TableHeaderGroup,   /// ??????????????????????????????????????????????????????????????? <thead>??????
   CSSDisplay_TableFooterGroup,   /// ??????????????????????????????????????????????????????????????? <tfoot>??????
   CSSDisplay_TableRow,         /// ???????????????????????????????????????????????? <tr>??????
   CSSDisplay_TableColumnGroup,   /// ??????????????????????????????????????????????????????????????? <colgroup>??????
   CSSDisplay_TableColumn,         /// ??????????????????????????????????????????????????? <col>???
   CSSDisplay_TableCell,         /// ?????????????????????????????????????????????????????? <td> ??? <th>???
   CSSDisplay_TableCaption,      /// ??????????????????????????????????????????????????? <caption>???

} CSSDisplay;

typedef enum
{
   CSSPosition_Inherit = 0,      /// ???????????????
   CSSPosition_Static,            /// ????????????
   CSSPosition_Relative,         /// ???????????????
   CSSPosition_Absolute,         /// ???????????????
   CSSPosition_Fixed            /// ???????????????
} CSSPosition;

typedef enum
{
   CSSFloating_Inherit = 0,      /// ???????????????
   CSSFloating_Left,            /// ?????????
   CSSFloating_None,            /// ?????????
   CSSFloating_Right            /// ?????????
} CSSFloating;

typedef enum
{
   CSSClear_Inherit = 0,         /// ???????????????
   CSSClear_None,               /// ????????????
   CSSClear_Left,               /// ???????????????
   CSSClear_Right,               /// ???????????????
   CSSClear_Both               /// ??????????????????
} CSSClear;

typedef enum
{
   CSSWrap_Inherit = 0,         /// ???????????????
   CSSWrap_NoWrap,               /// ?????????
   CSSWrap_Wrap,               /// ?????????
   CSSWrap_WrapReverse            /// ?????????
} CSSWrap;

typedef enum
{
   CSSWhiteSpace_Inherit = 0,      /// ???????????????
   CSSWhiteSpace_Normal,         /// ??????????????????
   CSSWhiteSpace_Pre,            /// ?????????????????????????????????????????? HTML ?????? <pre> ?????????
   CSSWhiteSpace_NoWrap,         /// ????????????????????????????????????????????????????????????????????? <br> ???????????????
   CSSWhiteSpace_PreWrap,         /// ??????????????????????????????????????????????????????
   CSSWhiteSpace_PreLine,         /// ????????????????????????????????????????????????
} CSSWhiteSpace;

typedef enum
{
   CSSAlign_Inherit = 0,         /// ???????????????
   CSSAlign_None,               /// ??????
   CSSAlign_Left,               /// ????????????
   CSSAlign_Right,               /// ????????????
   CSSAlign_Center               /// ????????????
} CSSAlign;

typedef enum
{
   CSSVerticalAlign_Inherit = 0,   /// ???????????????
   CSSVerticalAlign_None,         /// ??????
   CSSVerticalAlign_Baseline,      /// ?????????????????????????????????????????????
   CSSVerticalAlign_Sub,         /// ???????????????????????????
   CSSVerticalAlign_Super,         /// ???????????????????????????
   CSSVerticalAlign_Top,         /// ??????????????????????????????????????????????????????
   CSSVerticalAlign_TextTop,      /// ???????????????????????????????????????????????????
   CSSVerticalAlign_Middle,      /// ???????????????????????????????????????
   CSSVerticalAlign_Bottom,      /// ?????????????????????????????????????????????????????????
   CSSVerticalAlign_TextBottom      /// ???????????????????????????????????????????????????
} CSSVerticalAlign;

typedef enum
{
   CSSBorderStyle_Inherit = 0,
   CSSBorderStyle_None,
   CSSBorderStyle_Hidden,
   CSSBorderStyle_Dotted,
   CSSBorderStyle_Dashed,
   CSSBorderStyle_Solid,
   CSSBorderStyle_Double,
   CSSBorderStyle_Groove,
   CSSBorderStyle_Ridge,
   CSSBorderStyle_Inset,
   CSSBorderStyle_Outset
} CSSBorderStyle;

typedef enum
{
   CSSBorderCollapse_Inherit = 0,
   CSSBorderCollapse_Separate,
   CSSBorderCollapse_Collapse,
} CSSBorderCollapse;

typedef enum
{
   CSSBoxOrient_Inherit = 0,
   CSSBoxOrient_Horizontal,
   CSSBoxOrient_Vertical,
   CSSBoxOrient_InlineAxis,
   CSSBoxOrient_BlockAxis
} CSSBoxOrient;

typedef enum
{
   CSSBoxAlign_Inherit = 0,
   CSSBoxAlign_Start,
   CSSBoxAlign_End,
   CSSBoxAlign_Center,
   CSSBoxAlign_Baseline,
   CSSBoxAlign_Stretch
} CSSBoxAlign;

typedef enum
{
   CSSBoxDirection_Inherit = 0,
   CSSBoxDirection_Normal,
   CSSBoxDirection_Reverse
} CSSBoxDirection;

typedef enum
{
   CSSBoxLines_Inherit = 0,
   CSSBoxLines_Single,
   CSSBoxLines_Multiple
} CSSBoxLines;

typedef enum
{
   CSSBoxPack_Inherit = 0,
   CSSBoxPack_Start,
   CSSBoxPack_End,
   CSSBoxPack_Center,
   CSSBoxPack_Justify
} CSSBoxPack;

typedef enum
{
   CSSFlexWrap_Inherit = 0,
   CSSFlexWrap_Nowrap,
   CSSFlexWrap_Wrap,
   CSSFlexWrap_WrapReverse
} CSSFlexWrap;

typedef enum
{
   CSSFlexDirection_Inherit = 0,
   CSSFlexDirection_Row,
   CSSFlexDirection_RowReverse,
   CSSFlexDirection_Column,
   CSSFlexDirection_ColumnReverse
} CSSFlexDirection;

typedef enum
{
   CSSAlignContent_Inherit = 0,
   CSSAlignContent_FlexStart,
   CSSAlignContent_FlexEnd,
   CSSAlignContent_Center,
   CSSAlignContent_SpaceBetween,
   CSSAlignContent_SpaceAround,
   CSSAlignContent_Stretch
} CSSAlignContent;

typedef enum
{
   CSSAlignItems_Inherit = 0,
   CSSAlignItems_FlexStart,
   CSSAlignItems_FlexEnd,
   CSSAlignItems_Center,
   CSSAlignItems_Baseline,
   CSSAlignItems_Stretch
} CSSAlignItems;

typedef enum
{
   CSSAlignSelf_Inherit = 0,
   CSSAlignSelf_Auto,
   CSSAlignSelf_FlexStart,
   CSSAlignSelf_FlexEnd,
   CSSAlignSelf_Center,
   CSSAlignSelf_Baseline,
   CSSAlignSelf_Stretch
} CSSAlignSelf;

typedef enum
{
   CSSJustifyContent_Inherit = 0,
   CSSJustifyContent_FlexStart,
   CSSJustifyContent_FlexEnd,
   CSSJustifyContent_Center,
   CSSJustifyContent_SpaceBetween,
   CSSJustifyContent_SpaceAround
} CSSJustifyContent;

typedef enum
{
   CSSViewHierarchy_Inherit = 0,         /// ???????????????
   CSSViewHierarchy_Tree,               /// ???
   CSSViewHierarchy_Branch,            /// ??????
   CSSViewHierarchy_Leaf,               /// ??????
   CSSViewHierarchy_Hidden               /// ??????
} CSSViewHierarchy;

#pragma mark -

@interface NSObject(RenderStyle)

+ (CSSViewHierarchy)style_viewHierarchy;

@end

#pragma mark -

@interface IDEAAppletHtmlRenderStyle : IDEAAppletRenderStyle

@css_value( top );
@css_value( left );
@css_value( right );
@css_value( bottom );

@css_value( width );
@css_value( minWidth );
@css_value( maxWidth );

@css_value( height );
@css_value( minHeight );
@css_value( maxHeight );

@css_value( position );
@css_value( floating );
@css_value( clear );

@css_value( order );
@css_value( zIndex );

@css_value( display );
@css_value( overflow );
@css_value( visibility );
@css_value( opacity );

@css_value( boxSizing );
@css_array( boxShadow );

@css_value( baseline );
@css_value( wordWrap );
@css_value( contentMode );

@css_value( color );
@css_value( direction );
@css_value( letterSpacing );
@css_value( lineHeight );
@css_value( align );
@css_value( verticalAlign );
@css_value( textAlign );
@css_value( textDecoration );
@css_value( textIndent );
@css_array( textShadow );
@css_value( textTransform );
@css_value( textOverflow );
@css_value( unicodeBidi );
@css_value( whiteSpace );
@css_value( wordSpacing );

// list

@css_array( listStyle );
@css_value( listStyleType );
@css_value( listStyleImage );
@css_value( listStylePosition );

// background

@css_array( background );
@css_value( backgroundColor );
@css_value( backgroundImage );

// flex box

@css_array( flex );            // new
@css_value( flexGrow );         // new
@css_value( flexShrink );      // new
@css_value( flexBasis );      // new
@css_value( flexWrap );         // new
@css_array( flexFlow );         // new
@css_value( flexDirection );   // new

@css_value( alignSelf );      // new
@css_value( alignItems );      // new
@css_value( alignContent );      // new
@css_value( justifyContent );   // new

@css_value( boxAlign );         // old
@css_value( boxDirection );      // old
@css_value( boxFlex );         // old
@css_value( boxFlexGroup );      // old
@css_value( boxLines );         // old
@css_value( boxOrdinalGroup );   // old
@css_value( boxOrient );      // old
@css_value( boxPack );         // old

// font

@css_array( font );
@css_array( fontFamily );
@css_value( fontVariant );
@css_value( fontStyle );
@css_value( fontSize );
@css_value( fontWeight );

// border

@css_value( borderCollapse );
@css_value( borderSpacing );

@css_value( cellSpacing );
@css_value( cellPadding );

@css_array( border );
@css_array( borderWidth );
@css_array( borderStyle );
@css_array( borderColor );

@css_array( borderRadius );
@css_array( borderTopLeftRadius );
@css_array( borderTopRightRadius );
@css_array( borderBottomLeftRadius );
@css_array( borderBottomRightRadius );

@css_array( borderTop );
@css_value( borderTopColor );
@css_value( borderTopStyle );
@css_value( borderTopWidth );

@css_array( borderLeft );
@css_value( borderLeftColor );
@css_value( borderLeftStyle );
@css_value( borderLeftWidth );

@css_array( borderRight );
@css_value( borderRightColor );
@css_value( borderRightStyle );
@css_value( borderRightWidth );

@css_array( borderBottom );
@css_value( borderBottomColor );
@css_value( borderBottomStyle );
@css_value( borderBottomWidth );

// margin

@css_array( margin );
@css_value( marginTop );
@css_value( marginLeft );
@css_value( marginRight );
@css_value( marginBottom );

// padding

@css_array( padding );
@css_value( paddingTop );
@css_value( paddingLeft );
@css_value( paddingRight );
@css_value( paddingBottom );

// inset

@css_array( inset );
@css_value( insetTop );
@css_value( insetLeft );
@css_value( insetRight );
@css_value( insetBottom );

// custom

@css_value( webkitMarginBefore );
@css_value( webkitMarginAfter );
@css_value( webkitMarginStart );
@css_value( webkitMarginEnd );

@css_value( webkitPaddingBefore );
@css_value( webkitPaddingAfter );
@css_value( webkitPaddingStart );
@css_value( webkitPaddingEnd );

@css_value( appletViewHierarchy );
@css_value( appletViewClass );

#pragma mark -

- (IDEAAppletCSSValue *)getCSSValueForKey:(NSString *)key;
- (IDEAAppletCSSArray *)getCSSArrayForKey:(NSString *)key;

- (void)setCSSValue:(IDEAAppletCSSValue *)value forKey:(NSString *)key;
- (void)setCSSArray:(IDEAAppletCSSArray *)array forKey:(NSString *)key;

#pragma mark -

- (BOOL)isAutoWidth;
- (BOOL)isAutoHeight;

- (BOOL)isFixedWidth;
- (BOOL)isFixedHeight;

- (BOOL)isWidthEqualsToHeight;
- (BOOL)isHeightEqualsToWidth;

- (BOOL)isAutoMarginTop;
- (BOOL)isAutoMarginLeft;
- (BOOL)isAutoMarginRight;
- (BOOL)isAutoMarginBottom;

- (UIFont *)computeFont:(UIFont *)defaultFont;
- (UIColor *)computeColor:(UIColor *)defaultColor;
- (NSTextAlignment)computeTextAlignment:(NSTextAlignment)defaultMode;
- (NSLineBreakMode)computeLineBreakMode:(NSLineBreakMode)defaultMode;
- (UIViewContentMode)computeContentMode:(UIViewContentMode)defaultMode;
- (UIBaselineAdjustment)computeBaselineAdjustment:(UIBaselineAdjustment)defaultMode;
- (UITextDecoration)computeTextDecoration:(UITextDecoration)defaultDecoration;

- (CSSWrap)computeWrap:(CSSWrap)defaultValue;
- (CSSAlign)computeAlign:(CSSAlign)defaultValue;
- (CSSClear)computeClear:(CSSClear)defaultValue;
- (CSSDisplay)computeDisplay:(CSSDisplay)defaultValue;
- (CSSFloating)computeFloating:(CSSFloating)defaultValue;
- (CSSPosition)computePosition:(CSSPosition)defaultValue;
- (CSSWhiteSpace)computeWhiteSpace:(CSSWhiteSpace)defaultValue;
- (CSSVerticalAlign)computeVerticalAlign:(CSSVerticalAlign)defaultValue;
- (CSSViewHierarchy)computeViewHierarchy:(CSSViewHierarchy)defaultValue;
- (CSSBorderCollapse)computeBorderCollapse:(CSSBorderCollapse)defaultValue;

- (CSSBoxPack)computeBoxPack:(CSSBoxPack)defaultValue;
- (CSSBoxAlign)computeBoxAlign:(CSSBoxAlign)defaultValue;
- (CSSBoxLines)computeBoxLines:(CSSBoxLines)defaultValue;
- (CSSBoxOrient)computeBoxOrient:(CSSBoxOrient)defaultValue;
- (CSSBoxDirection)computeBoxDirection:(CSSBoxDirection)defaultValue;

- (CSSFlexWrap)computeFlexWrap:(CSSFlexWrap)defaultValue;
- (CSSFlexDirection)computeFlexDirection:(CSSFlexDirection)defaultValue;

- (CSSAlignSelf)computeAlignSelf:(CSSAlignSelf)defaultValue;
- (CSSAlignItems)computeAlignItems:(CSSAlignItems)defaultValue;
- (CSSAlignContent)computeAlignContent:(CSSAlignContent)defaultValue;
- (CSSJustifyContent)computeJustifyContent:(CSSJustifyContent)defaultValue;

- (CGFloat)computeTop:(CGFloat)bounds defaultSize:(CGFloat)defaultSize;
- (CGFloat)computeLeft:(CGFloat)bounds defaultSize:(CGFloat)defaultSize;
- (CGFloat)computeRight:(CGFloat)bounds defaultSize:(CGFloat)defaultSize;
- (CGFloat)computeBottom:(CGFloat)bounds defaultSize:(CGFloat)defaultSize;

- (CGFloat)computeWidth:(CGFloat)bounds defaultSize:(CGFloat)defaultSize;
- (CGFloat)computeHeight:(CGFloat)bounds defaultSize:(CGFloat)defaultSize;

- (CGFloat)computeMinWidth:(CGFloat)bounds defaultSize:(CGFloat)defaultSize;
- (CGFloat)computeMaxWidth:(CGFloat)bounds defaultSize:(CGFloat)defaultSize;
- (CGFloat)computeMinHeight:(CGFloat)bounds defaultSize:(CGFloat)defaultSize;
- (CGFloat)computeMaxHeight:(CGFloat)bounds defaultSize:(CGFloat)defaultSize;

- (CGFloat)computeInsetTopSize:(CGFloat)bounds defaultSize:(CGFloat)defaultSize;
- (CGFloat)computeInsetLeftSize:(CGFloat)bounds defaultSize:(CGFloat)defaultSize;
- (CGFloat)computeInsetRightSize:(CGFloat)bounds defaultSize:(CGFloat)defaultSize;
- (CGFloat)computeInsetBottomSize:(CGFloat)bounds defaultSize:(CGFloat)defaultSize;

- (CGFloat)computePaddingTopSize:(CGFloat)bounds defaultSize:(CGFloat)defaultSize;
- (CGFloat)computePaddingLeftSize:(CGFloat)bounds defaultSize:(CGFloat)defaultSize;
- (CGFloat)computePaddingRightSize:(CGFloat)bounds defaultSize:(CGFloat)defaultSize;
- (CGFloat)computePaddingBottomSize:(CGFloat)bounds defaultSize:(CGFloat)defaultSize;

- (CGFloat)computeMarginTopSize:(CGFloat)bounds defaultSize:(CGFloat)defaultSize;
- (CGFloat)computeMarginLeftSize:(CGFloat)bounds defaultSize:(CGFloat)defaultSize;
- (CGFloat)computeMarginRightSize:(CGFloat)bounds defaultSize:(CGFloat)defaultSize;
- (CGFloat)computeMarginBottomSize:(CGFloat)bounds defaultSize:(CGFloat)defaultSize;

- (UIColor *)computeBorderTopColor:(UIColor *)defaultColor;
- (UIColor *)computeBorderLeftColor:(UIColor *)defaultColor;
- (UIColor *)computeBorderRightColor:(UIColor *)defaultColor;
- (UIColor *)computeBorderBottomColor:(UIColor *)defaultColor;

- (CGFloat)computeBorderTopSize:(CGFloat)bounds defaultSize:(CGFloat)defaultSize;
- (CGFloat)computeBorderLeftSize:(CGFloat)bounds defaultSize:(CGFloat)defaultSize;
- (CGFloat)computeBorderRightSize:(CGFloat)bounds defaultSize:(CGFloat)defaultSize;
- (CGFloat)computeBorderBottomSize:(CGFloat)bounds defaultSize:(CGFloat)defaultSize;

- (CSSBorderStyle)computeBorderTopStyle:(CSSBorderStyle)style;
- (CSSBorderStyle)computeBorderLeftStyle:(CSSBorderStyle)style;
- (CSSBorderStyle)computeBorderRightStyle:(CSSBorderStyle)style;
- (CSSBorderStyle)computeBorderBottomStyle:(CSSBorderStyle)style;

- (CGFloat)computeBorderTopLeftRadius:(CGFloat)bounds defaultRadius:(CGFloat)defaultRadius;
- (CGFloat)computeBorderTopRightRadius:(CGFloat)bounds defaultRadius:(CGFloat)defaultRadius;
- (CGFloat)computeBorderBottomLeftRadius:(CGFloat)bounds defaultRadius:(CGFloat)defaultRadius;
- (CGFloat)computeBorderBottomRightRadius:(CGFloat)bounds defaultRadius:(CGFloat)defaultRadius;

- (CGFloat)computeBorderSpacing:(CGFloat)bounds defaultSize:(CGFloat)defaultSize;
- (CGFloat)computeCellSpacing:(CGFloat)bounds defaultSize:(CGFloat)defaultSize;
- (CGFloat)computeCellPadding:(CGFloat)bounds defaultSize:(CGFloat)defaultSize;

- (CGFloat)computeTextIndent:(CGFloat)defaultSize;
- (CGFloat)computeLineHeight:(CGFloat)fontHeight defaultSize:(CGFloat)defaultSize;
- (CGFloat)computeLetterSpacing:(CGFloat)defaultSize;

- (CGFloat)computeOrder:(CGFloat)defaultOrder;
- (CGFloat)computeZIndex:(CGFloat)defaultIndex;

- (CGFloat)computeFlexGrow:(CGFloat)defaultValue;
- (CGFloat)computeFlexShrink:(CGFloat)defaultValue;
- (CGFloat)computeFlexBasis:(CGFloat)defaultValue;

@end

#endif   // #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
