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

#import "IDEAAppletHtmlUserAgent.h"

#import "__pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "IDEAAppletCSSParser.h"
#import "IDEAAppletCSSStyleSheet.h"

#import "IDEAAppletHtmlElementArticle.h"
#import "IDEAAppletHtmlElementAside.h"
#import "IDEAAppletHtmlElementBlockquote.h"
#import "IDEAAppletHtmlElementBody.h"
#import "IDEAAppletHtmlElementBr.h"
#import "IDEAAppletHtmlElementButton.h"
#import "IDEAAppletHtmlElementCanvas.h"
#import "IDEAAppletHtmlElementCaption.h"
#import "IDEAAppletHtmlElementCode.h"
#import "IDEAAppletHtmlElementCol.h"
#import "IDEAAppletHtmlElementColGroup.h"
#import "IDEAAppletHtmlElementDatalist.h"
#import "IDEAAppletHtmlElementDd.h"
#import "IDEAAppletHtmlElementDir.h"
#import "IDEAAppletHtmlElementDiv.h"
#import "IDEAAppletHtmlElementDl.h"
#import "IDEAAppletHtmlElementDt.h"
#import "IDEAAppletHtmlElementElement.h"
#import "IDEAAppletHtmlElementFieldset.h"
#import "IDEAAppletHtmlElementFooter.h"
#import "IDEAAppletHtmlElementForm.h"
#import "IDEAAppletHtmlElementH1.h"
#import "IDEAAppletHtmlElementH2.h"
#import "IDEAAppletHtmlElementH3.h"
#import "IDEAAppletHtmlElementH4.h"
#import "IDEAAppletHtmlElementH5.h"
#import "IDEAAppletHtmlElementH6.h"
#import "IDEAAppletHtmlElementHeader.h"
#import "IDEAAppletHtmlElementHgroup.h"
#import "IDEAAppletHtmlElementHr.h"
#import "IDEAAppletHtmlElementHtml.h"
#import "IDEAAppletHtmlElementImg.h"
#import "IDEAAppletHtmlElementInputButton.h"
#import "IDEAAppletHtmlElementInputCheckbox.h"
#import "IDEAAppletHtmlElementInputFile.h"
#import "IDEAAppletHtmlElementInputHidden.h"
#import "IDEAAppletHtmlElementInputImage.h"
#import "IDEAAppletHtmlElementInputPassword.h"
#import "IDEAAppletHtmlElementInputRadio.h"
#import "IDEAAppletHtmlElementInputReset.h"
#import "IDEAAppletHtmlElementInputSubmit.h"
#import "IDEAAppletHtmlElementInputText.h"
#import "IDEAAppletHtmlElementLabel.h"
#import "IDEAAppletHtmlElementLegend.h"
#import "IDEAAppletHtmlElementLi.h"
#import "IDEAAppletHtmlElementMain.h"
#import "IDEAAppletHtmlElementMeter.h"
#import "IDEAAppletHtmlElementNav.h"
#import "IDEAAppletHtmlElementOl.h"
#import "IDEAAppletHtmlElementOutput.h"
#import "IDEAAppletHtmlElementP.h"
#import "IDEAAppletHtmlElementPre.h"
#import "IDEAAppletHtmlElementProgress.h"
#import "IDEAAppletHtmlElementSection.h"
#import "IDEAAppletHtmlElementSelect.h"
#import "IDEAAppletHtmlElementSpan.h"
#import "IDEAAppletHtmlElementSub.h"
#import "IDEAAppletHtmlElementSup.h"
#import "IDEAAppletHtmlElementTable.h"
#import "IDEAAppletHtmlElementTbody.h"
#import "IDEAAppletHtmlElementTd.h"
#import "IDEAAppletHtmlElementTemplate.h"
#import "IDEAAppletHtmlElementText.h"
#import "IDEAAppletHtmlElementTextarea.h"
#import "IDEAAppletHtmlElementTfoot.h"
#import "IDEAAppletHtmlElementTh.h"
#import "IDEAAppletHtmlElementThead.h"
#import "IDEAAppletHtmlElementTime.h"
#import "IDEAAppletHtmlElementTr.h"
#import "IDEAAppletHtmlElementUl.h"
#import "IDEAAppletHtmlElementViewport.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation SamuraiHtmlUserAgent

@def_prop_assign(CGFloat,               thinSize);
@def_prop_assign(CGFloat,               mediumSize);
@def_prop_assign(CGFloat,               thickSize);

@def_prop_strong(UIFont *,               defaultFont);
@def_prop_strong(NSMutableDictionary *,   defaultElements);
@def_prop_strong(NSMutableArray *,         defaultStyleSheets);
@def_prop_strong(NSMutableDictionary *,   defaultCSSValue);
@def_prop_strong(NSMutableArray *,         defaultCSSInherition);
@def_prop_strong(NSMutableArray *,         defaultDOMAttributedStyle);

@def_singleton(SamuraiHtmlUserAgent)

+ (void)load
{
   [SamuraiHtmlUserAgent sharedInstance];
   
   return;
}

- (id)init
{
   int                            nErr                                     = EFAULT;
   
   __TRY;

   self = [super init];
   
   if (self)
   {
      self.thinSize     = 1.0f;
      self.mediumSize   = 2.0f;
      self.thickSize    = 3.0f;
      self.defaultFont  = [UIFont systemFontOfSize:14.0f];
      
      [self loadStyleSheets];
      [self loadElements];
      [self loadCSSValue];
      [self loadCSSInheration];
      [self loadDOMAttributedStyle];
      
   } /* End if () */
   
   __CATCH(nErr);
   
   return self;
}

- (void)dealloc
{
   self.defaultFont        = nil;
   self.defaultElements    = nil;
   self.defaultStyleSheets = nil;
   self.defaultCSSValue    = nil;
   self.defaultCSSInherition        = nil;
   self.defaultDOMAttributedStyle   = nil;
   
   __SUPER_DEALLOC;
   
   return;
}

- (void)loadStyleSheets
{
   int                            nErr                                     = EFAULT;
   
   SamuraiCSSStyleSheet          *stStyleSheet                             = nil;;

   __TRY;

   self.defaultStyleSheets = [NSMutableArray array];
      
   stStyleSheet = [SamuraiCSSStyleSheet resourceAtPath:@"html.css" inBundle:@"IDEAApplet"];
   
   if (stStyleSheet && [stStyleSheet parse])
   {
      [self.defaultStyleSheets addObject:stStyleSheet];
      
   } /* End if () */
   
   stStyleSheet = [SamuraiCSSStyleSheet resourceAtPath:@"html+native.css" inBundle:@"IDEAApplet"];
   
   if (stStyleSheet && [stStyleSheet parse])
   {
      [self.defaultStyleSheets addObject:stStyleSheet];
      
   } /* End if () */
   
   stStyleSheet = [SamuraiCSSStyleSheet resourceAtPath:@"html+applet.css" inBundle:@"IDEAApplet"];
   
   if (stStyleSheet && [stStyleSheet parse])
   {
      [self.defaultStyleSheets addObject:stStyleSheet];
      
   } /* End if () */
   
   __CATCH(nErr);
   
   return;
}

- (void)loadElements
{
   self.defaultElements = [NSMutableDictionary dictionary];
   
   self.defaultElements[@"html"] = [IDEAAppletHtmlElementHtml class];
   
   return;
}

- (void)loadCSSValue
{
   self.defaultCSSValue = [NSMutableDictionary dictionary];
   
   //   self.defaultCSSValue[@"animation"]               = @"none 0 ease 0 1 normal";
   //   self.defaultCSSValue[@"animation-name"]            = @"none";
   //   self.defaultCSSValue[@"animation-duration"]         = @"0";
   //   self.defaultCSSValue[@"animation-timing-function"]   = @"ease";
   //   self.defaultCSSValue[@"animation-delay"]         = @"0";
   //   self.defaultCSSValue[@"animation-iteration-count"]   = @"1";
   //   self.defaultCSSValue[@"animation-direction"]      = @"normal";
   //   self.defaultCSSValue[@"animation-play-state"]      = @"running";
   //   self.defaultCSSValue[@"animation-fill-mode"]      = @"none";
   
   //   self.defaultCSSValue[@"background-attachment"]      = @"scroll";
   //   self.defaultCSSValue[@"background-color"]         = @"transparent";
   //   self.defaultCSSValue[@"background-image"]         = @"none";
   //   self.defaultCSSValue[@"background-position"]      = @"0% 0%";
   //   self.defaultCSSValue[@"background-repeat"]         = @"repeat";
   //   self.defaultCSSValue[@"background-clip"]         = @"border-box";
   //   self.defaultCSSValue[@"background-origin"]         = @"padding-box";
   //   self.defaultCSSValue[@"background-size"]         = @"auto";
   
   //   self.defaultCSSValue[@"border-width"]            = @"medium";
   //   self.defaultCSSValue[@"border-top-width"]         = @"medium";
   //   self.defaultCSSValue[@"border-left-width"]         = @"medium";
   //   self.defaultCSSValue[@"border-right-width"]         = @"medium";
   //   self.defaultCSSValue[@"border-bottom-width"]      = @"medium";
   
   //   self.defaultCSSValue[@"border-image"]            = @"none 100% 1 0 stretch";
   //   self.defaultCSSValue[@"border-image-outset"]      = @"0";
   //   self.defaultCSSValue[@"border-image-repeat"]      = @"stretch";
   //   self.defaultCSSValue[@"border-image-slice"]         = @"100%";
   //   self.defaultCSSValue[@"border-image-source"]      = @"none";
   //   self.defaultCSSValue[@"border-image-width"]         = @"none";
   
   self.defaultCSSValue[@"border-radius"]    = @"0";
   
   self.defaultCSSValue[@"box-shadow"]       = @"none";
   
//   self.defaultCSSValue[@"outline"]        = @"invert none medium";
//   self.defaultCSSValue[@"outline-color"]  = @"invert";
//   self.defaultCSSValue[@"outline-style"]  = @"none";
//   self.defaultCSSValue[@"outline-width"]  = @"medium";

//   self.defaultCSSValue[@"overflow-x"]     = @"visible";
//   self.defaultCSSValue[@"overflow-y"]     = @"visible";
//   self.defaultCSSValue[@"overflow-style"] = @"auto";
//   self.defaultCSSValue[@"rotation"]       = @"0";
//   self.defaultCSSValue[@"rotation-point"] = @"50% 50%";
   
   self.defaultCSSValue[@"opacity"]          = @"1";
   
   self.defaultCSSValue[@"width"]            = @"auto";
   self.defaultCSSValue[@"height"]           = @"auto";
   self.defaultCSSValue[@"max-width"]        = @"none";
   self.defaultCSSValue[@"max-height"]       = @"none";
   self.defaultCSSValue[@"min-width"]        = @"none";
   self.defaultCSSValue[@"min-height"]       = @"none";
   
//   self.defaultCSSValue[@"box-align"]         = @"stretch";
//   self.defaultCSSValue[@"box-direction"]     = @"normal";
//   self.defaultCSSValue[@"box-flex"]          = @"0.0";
//   self.defaultCSSValue[@"box-flex-group"]    = @"1";
//   self.defaultCSSValue[@"box-lines"]         = @"single";
//   self.defaultCSSValue[@"box-ordinal-group"] = @"1";
//   self.defaultCSSValue[@"box-orient"]        = @"inline-axis";
//   self.defaultCSSValue[@"box-pack"]          = @"start";
   
   self.defaultCSSValue[@"font-size"]        = @"medium";
   self.defaultCSSValue[@"font-size-adjust"] = @"none";
   self.defaultCSSValue[@"font-stretch"]     = @"normal";
   self.defaultCSSValue[@"font-style"]       = @"normal";
   self.defaultCSSValue[@"font-variant"]     = @"normal";
   self.defaultCSSValue[@"font-weight"]      = @"normal";
   
//   self.defaultCSSValue[@"content"]           = @"normal";
//   self.defaultCSSValue[@"counter-increment"] = @"none";
//   self.defaultCSSValue[@"counter-reset"]     = @"none";

//   self.defaultCSSValue[@"grid-columns"]      = @"none";
//   self.defaultCSSValue[@"grid-rows"]         = @"none";

//   self.defaultCSSValue[@"target"]            = @"current window above";
//   self.defaultCSSValue[@"target-name"]       = @"current";
//   self.defaultCSSValue[@"target-new"]        = @"window";
//   self.defaultCSSValue[@"target-position"]   = @"above";

//   self.defaultCSSValue[@"list-style"]           = @"disc outside none";
//   self.defaultCSSValue[@"list-style-image"]     = @"none";
//   self.defaultCSSValue[@"list-style-position"]  = @"outside";
//   self.defaultCSSValue[@"list-style-type"]      = @"disc";

//   self.defaultCSSValue[@"margin"]         = @"0";
//   self.defaultCSSValue[@"margin-top"]     = @"0";
//   self.defaultCSSValue[@"margin-left"]    = @"0";
//   self.defaultCSSValue[@"margin-right"]   = @"0";
//   self.defaultCSSValue[@"margin-bottom"]  = @"0";

//   self.defaultCSSValue[@"column-count"]      = @"auto";
//   self.defaultCSSValue[@"column-fill"]       = @"balance";
//   self.defaultCSSValue[@"column-gap"]        = @"normal";
//   self.defaultCSSValue[@"column-rule"]       = @"medium none black";
//   self.defaultCSSValue[@"column-rule-color"] = @"black";
//   self.defaultCSSValue[@"column-rule-style"] = @"none";
//   self.defaultCSSValue[@"column-rule-width"] = @"medium";
//   self.defaultCSSValue[@"column-span"]       = @"1";
//   self.defaultCSSValue[@"column-width"]      = @"auto";
//   self.defaultCSSValue[@"columns"]           = @"auto auto";

//   self.defaultCSSValue[@"padding"]        = @"0";
//   self.defaultCSSValue[@"padding-top"]    = @"0";
//   self.defaultCSSValue[@"padding-left"]   = @"0";
//   self.defaultCSSValue[@"padding-right"]  = @"0";
//   self.defaultCSSValue[@"padding-bottom"] = @"0";

//   self.defaultCSSValue[@"top"]   = @"auto";
//   self.defaultCSSValue[@"left"]  = @"auto";
//   self.defaultCSSValue[@"right"] = @"auto";
//   self.defaultCSSValue[@"bottom"]= @"auto";
   
   self.defaultCSSValue[@"clear"]            = @"none";
   self.defaultCSSValue[@"clip"]             = @"auto";
   self.defaultCSSValue[@"cursor"]           = @"auto";
   self.defaultCSSValue[@"display"]          = @"inline";
   self.defaultCSSValue[@"float"]            = @"none";
   self.defaultCSSValue[@"overflow"]         = @"visible";
   self.defaultCSSValue[@"position"]         = @"static";
   self.defaultCSSValue[@"vertical-align"]   = @"baseline";
   self.defaultCSSValue[@"visibility"]       = @"visible";
   self.defaultCSSValue[@"z-index"]          = @"auto";
   
   self.defaultCSSValue[@"border-collapse"]  = @"separate";
//   self.defaultCSSValue[@"caption-side"]   = @"top";
//   self.defaultCSSValue[@"empty-cells"]    = @"show";
//   self.defaultCSSValue[@"table-layout"]   = @"auto";
   
//   self.defaultCSSValue[@"direction"]      = @"ltr";
//   self.defaultCSSValue[@"letter-spacing"] = @"normal";
//   self.defaultCSSValue[@"line-height"]    = @"normal";
   self.defaultCSSValue[@"text-align"]       = @"left";
   self.defaultCSSValue[@"text-decoration"]  = @"none";
   self.defaultCSSValue[@"text-transform"]   = @"none";
//   self.defaultCSSValue[@"white-space"]          = @"normal";
//   self.defaultCSSValue[@"word-spacing"]         = @"normal";
//   self.defaultCSSValue[@"hanging-punctuation"]  = @"none";
//   self.defaultCSSValue[@"punctuation-trim"]     = @"none";
//   self.defaultCSSValue[@"text-emphasis"]        = @"none";
//   self.defaultCSSValue[@"text-justify"]         = @"auto";
//   self.defaultCSSValue[@"text-outline"]         = @"none";
//   self.defaultCSSValue[@"text-overflow"]        = @"clip";
//   self.defaultCSSValue[@"text-shadow"]          = @"none";
   self.defaultCSSValue[@"text-wrap"]  = @"normal";
   self.defaultCSSValue[@"word-break"] = @"normal";
   self.defaultCSSValue[@"word-wrap"]  = @"normal";
   
//   self.defaultCSSValue[@"transform"]            = @"none";
//   self.defaultCSSValue[@"transform-origin"]     = @"50% 50% 0";
//   self.defaultCSSValue[@"transform-style"]      = @"flat";
//   self.defaultCSSValue[@"perspective"]          = @"none";
//   self.defaultCSSValue[@"perspective-origin"]   = @"50% 50%";
//   self.defaultCSSValue[@"backface-visibility"]  = @"visible";

//   self.defaultCSSValue[@"transition"]                 = @"all 0 ease 0";
//   self.defaultCSSValue[@"transition-property"]        = @"all";
//   self.defaultCSSValue[@"transition-duration"]        = @"0";
//   self.defaultCSSValue[@"transition-timing-function"] = @"ease";
//   self.defaultCSSValue[@"transition-delay"]           = @"0";

//   self.defaultCSSValue[@"appearance"]     = @"normal";
   self.defaultCSSValue[@"box-sizing"]       = @"content-box";
//   self.defaultCSSValue[@"outline-offset"] = @"0";
//   self.defaultCSSValue[@"resize"]         = @"none";
   
   return;
}

- (void)loadCSSInheration
{
   self.defaultCSSInherition = [NSMutableArray arrayWithObjects:
                                @"border-collapse",
                                @"border-spacing",
                                @"caption-side",
                                
                                @"cursor",
                                
                                @"direction",
                                @"text-align",
                                @"text-indent",
                                @"text-overflow",
                                @"text-transform",
                                @"text-decoration",
                                @"white-space",
                                
                                @"empty-cells",
                                
                                @"color",
                                @"font",
                                @"font-family",
                                @"font-size",
                                @"font-style",
                                @"font-variant",
                                @"font-weight",
                                @"letter-spacing",
                                @"line-height",
                                @"word-spacing",
                                @"word-wrap",
                                
                                @"list-style",
                                @"list-style-image",
                                @"list-style-position",
                                @"list-style-type",
                                
                                @"orphans",
                                @"widows",
                                
                                @"quotes",
                                
                                @"azimuth",
                                @"elevation",
                                @"pitch-range",
                                @"pitch",
                                @"richness",
                                @"speak-header",
                                @"speak-numeral",
                                @"speak-punctuation",
                                @"speak",
                                @"speech-rate",
                                @"stress",
                                @"voice-family",
                                @"volume",
                                
                                @"visibility",
                                
                                @"whitespace",
                                
                                nil];
   
   return;
}

- (void)loadDOMAttributedStyle
{
   self.defaultDOMAttributedStyle = [NSMutableArray arrayWithObjects:
                                     //   DOM               CSS
                                     @[   @"width",         @"width"                ],
                                     @[   @"height",        @"height"               ],
                                     @[   @"background",    @"background"           ],
                                     @[   @"bgcolor",       @"background-color"     ],
                                     @[   @"direction",     @"rtl"                  ],
                                     @[   @"align",         @"float"                ],
                                     @[   @"clear",         @"clear"                ],
                                     @[   @"border",        @"border"               ],
//                                     @[   @"border",        @"border-top-width"     ],
//                                     @[   @"border",        @"border-left-width"    ],
//                                     @[   @"border",        @"border-right-width"   ],
//                                     @[   @"border",        @"border-bottom-width"  ],
                                     @[   @"cellspacing",   @"cell-spacing"         ],
                                     @[   @"cellpadding",   @"cell-padding"         ],
                                     
                                     nil];
   
   return;
}

- (void)importStyleSheet:(NSString *)aPath
{
   int                            nErr                                     = EFAULT;
   
   SamuraiCSSStyleSheet          *stStyleSheet                             = nil;
   
   __TRY;

   if (nil == aPath)
   {
      nErr  = noErr;
      
      break;
      
   } /* End if () */
   
   stStyleSheet = [SamuraiCSSStyleSheet resourceAtPath:aPath inBundle:nil];
   
   if (stStyleSheet && [stStyleSheet parse])
   {
      [self.defaultStyleSheets addObject:stStyleSheet];
      
   } /* End if () */
   
   __CATCH(nErr);
   
   return;
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE(WebCore, HtmlUserAgent)

DESCRIBE(before)
{
}

DESCRIBE(after)
{
}

TEST_CASE_END

#endif   // #if __SAMURAI_TESTING__

#endif   // #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "__pragma_pop.h"
