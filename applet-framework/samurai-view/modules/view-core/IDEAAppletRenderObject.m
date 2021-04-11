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

#import "IDEAAppletRenderObject.h"

#import "__pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "IDEAAppletEventInput.h"
#import "IDEAAppletEventPanGesture.h"
#import "IDEAAppletEventPinchGesture.h"
#import "IDEAAppletEventSwipeGesture.h"
#import "IDEAAppletEventTapGesture.h"

#import "IDEAAppletDomNode.h"

#import "IDEAAppletRenderObject.h"
#import "IDEAAppletRenderStyle.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation NSObject(Renderer)

@def_prop_dynamic_strong(IDEAAppletRenderObject *, renderer, setRenderer);

+ (id)createInstanceWithRenderer:(IDEAAppletRenderObject *)aRenderer {
   
   UNUSED(aRenderer);
   
   return nil;
}

+ (id)createInstanceWithRenderer:(IDEAAppletRenderObject *)aRenderer identifier:(NSString *)aIdentifier {

   UNUSED(aRenderer);
   UNUSED(aIdentifier);

   return nil;
}

- (void)prepareForRendering {
   
   return;
}

- (CGSize)computeSizeBySize:(CGSize)aSize {
   
//   UNUSED(aSize);

   return CGSizeZero;
}

- (CGSize)computeSizeByWidth:(CGFloat)aWidth {
   
//   UNUSED(aWidth);

   return CGSizeZero;
}

- (CGSize)computeSizeByHeight:(CGFloat)aHeight {
   
//   UNUSED(aHeight);

   return CGSizeZero;
}

- (void)applyDom:(IDEAAppletDomNode *)aDom {
   
   UNUSED(aDom);

   return;
}

- (void)applyStyle:(IDEAAppletRenderStyle *)aStyle {
   
   UNUSED(aStyle);

   return;
}

- (void)applyFrame:(CGRect)aFrame {
   
//   UNUSED(aFrame);

   return;
}

@end

#pragma mark -

@implementation IDEAAppletRenderObject

@def_prop_strong( NSNumber                *, id);
@def_prop_unsafe( IDEAAppletDomNode       *, dom);
@def_prop_strong( IDEAAppletRenderStyle   *, style);

@def_prop_strong( UIView   *, view);
@def_prop_strong( Class     , viewClass);

@def_prop_dynamic( IDEAAppletRenderObject *, root);
@def_prop_dynamic( IDEAAppletRenderObject *, parent);
@def_prop_dynamic( IDEAAppletRenderObject *, prev);
@def_prop_dynamic( IDEAAppletRenderObject *, next);

BASE_CLASS(IDEAAppletRenderObject)

static NSUInteger __objectSeed = 0;

#pragma mark -

+ (instancetype)renderObject {
   
   return [[self alloc] init];
}

+ (instancetype)renderObjectWithDom:(IDEAAppletDomNode *)aDom andStyle:(IDEAAppletRenderStyle *)aStyle {
   
   IDEAAppletRenderObject  *stRenderObject   = [[self alloc] init];
   
   [stRenderObject bindDom:aDom];
   [stRenderObject bindStyle:aStyle];

   return stRenderObject;
}

#pragma mark -

- (id)init {
   
   self = [super init];
   if (self) {
      
      self.id = [NSNumber numberWithUnsignedInteger:__objectSeed++];      
   }
   
   return self;
}

- (void)dealloc {
   
   [NSObject cancelPreviousPerformRequestsWithTarget:self];

   self.viewClass = nil;
   self.view      = nil;
   
   self.style  = nil;
   self.dom    = nil;
   self.id     = nil;
   
   __SUPER_DEALLOC;
   
   return;
}

#pragma mark -

- (void)deepCopyFrom:(IDEAAppletRenderObject *)right {
   
//   [super deepCopyFrom:right];
   
   [self bindDom:right.dom];
   [self bindStyle:[right.style clone]];

   self.viewClass = right.viewClass;
   
   return;
}

#pragma mark -

- (CGSize)computeSize:(CGSize)bound {
   
   return CGSizeZero;
}

- (CGFloat)computeWidth:(CGFloat)height {
   
   return [self computeSize:CGSizeMake(INVALID_VALUE, height)].width;
}

- (CGFloat)computeHeight:(CGFloat)width {
   
   return [self computeSize:CGSizeMake(width, INVALID_VALUE)].width;
}

#pragma mark -

- (IDEAAppletRenderObject *)prevObject {
   
   return nil;
}

- (IDEAAppletRenderObject *)nextObject {
   
   return nil;
}

#pragma mark -

- (NSString *)signalNamespace {
   
   return nil;
}

- (NSString *)signalTag {
   
   return nil;
}

- (NSString *)signalDescription {
   
   return nil;
}

- (id)signalResponders {
   
   return nil;
}

- (id)signalAlias {
   
   return nil;
}

#pragma mark -

- (void)relayout {
   
   return;
}

- (void)restyle {

   return;
}

- (void)rechain {

   return;
}

#pragma mark -

- (UIView *)createViewWithIdentifier:(NSString *)aIdentifier {
   
//   if (nil == self.dom)
//      return nil;
   
   if (nil == self.viewClass) {
      return nil;
   }

   self.view = [self.viewClass createInstanceWithRenderer:self identifier:aIdentifier];

   if (self.view) {
      
      self.view.renderer = self;

      UIView * contentView = nil;

      if ([self.view respondsToSelector:@selector(contentView)]) {
         
         contentView = [self.view performSelector:@selector(contentView) withObject:nil];
      }
      else {
         
         contentView = self.view;
      }
      
      for (IDEAAppletRenderObject * child in [self.childs reverseObjectEnumerator]) {
         
         if (nil == child.view) {
            
            UIView * childView = [child createViewWithIdentifier:nil];
            
            if (childView) {
               
               [contentView addSubview:childView];
            }

         //   [child bindOutletsTo:self.view];
         }
      }

      self.view.exclusiveTouch = YES;
      self.view.multipleTouchEnabled = YES;
      
      [self.view prepareForRendering];
   }

   return self.view;
}


#pragma mark -

- (void)bindOutletsTo:(NSObject *)container {
   
   return;
}

- (void)unbindOutletsFrom:(NSObject *)container {

   return;
}

- (void)bindView:(UIView *)view {
   
   if (nil == view) {
      
      [self unbindView];
   }
   else {
      
      self.view = view;
      self.viewClass = [view class];
      
      if (self.view) {
         
         self.view.renderer = self;
         
         UIView * contentView = nil;
         
         if ([self.view respondsToSelector:@selector(contentView)]) {
            
            contentView = [self.view performSelector:@selector(contentView) withObject:nil];
         }
         else {
            
            contentView = self.view;
         }
         
         for (IDEAAppletRenderObject * child in [self.childs reverseObjectEnumerator]) {
            
            if (nil == child.view) {
               
               UIView * childView = [child createViewWithIdentifier:nil];
               
               if (childView) {
                  
                  [contentView addSubview:childView];
               }
               
//               [child bindOutletsTo:self.view];
            }
         }
         
         [self.view prepareForRendering];
      }
   }

   return;
}

- (void)unbindView {
   
   self.view = nil;

   return;
}

- (void)bindDom:(IDEAAppletDomNode *)newDom {
   
   self.dom = newDom;

   return;
}

- (void)unbindDom {
   
   self.dom = nil;

   return;
}

- (void)bindStyle:(IDEAAppletRenderStyle *)newStyle {
   
   self.style = newStyle;

   return;
}

- (void)unbindStyle {
   
   self.style = nil;

   return;
}

#pragma mark -

- (id)serialize {
   
   return nil;
}

- (void)unserialize:(id)obj {
   
   UNUSED(obj);

   return;
}

- (void)zerolize {
   
   return;
}

#pragma mark -

#if APPLET_DESCRIPTION
- (NSString *)description {
   
   [[IDEAAppletLogger sharedInstance] outputCapture];
   
   [self dump];
   
   [[IDEAAppletLogger sharedInstance] outputRelease];
   
   return [IDEAAppletLogger sharedInstance].output;
}
#endif /* APPLET_DESCRIPTION */

- (void)dump {
   
   if (DomNodeType_Text == self.dom.type) {
      
      PRINT(@"\"%@ ...\", [%@]", self.dom.text, [self.viewClass description]);
   }
   else {
      
      PRINT(@"<%@>, [%@]", self.dom.tag ?: @"", [self.viewClass description]);
      
      [[IDEAAppletLogger sharedInstance] indent];
      
      for (IDEAAppletRenderObject * child in self.childs) {
         
         [child dump];
      }
      
      [[IDEAAppletLogger sharedInstance] unindent];

      PRINT(@"</%@>", self.dom.tag ?: @"");
   }

   return;
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE(UI, RenderObject)

DESCRIBE(before) {
   
}

DESCRIBE(after) {
   
}

TEST_CASE_END

#endif   // #if __SAMURAI_TESTING__

#endif   // #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "__pragma_pop.h"
