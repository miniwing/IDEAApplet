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

#import "IDEAAppletCSSNumber.h"
#import "IDEAAppletCSSParser.h"

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

#import "__pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation IDEAAppletCSSObject(Function)

- (BOOL)isNumber
{
   return NO;
}

- (BOOL)isNumber:(CGFloat)value
{
   return NO;
}

- (BOOL)isAbsolute
{
   return NO;
}

- (CGFloat)value
{
   return 0.0f;
}

- (CGFloat)computeValue:(CGFloat)value
{
   return INVALID_VALUE;
}

@end

#pragma mark -

@implementation IDEAAppletCSSNumber

@def_prop_assign( CGFloat,      value );
@def_prop_strong( NSString *,   unit );

+ (instancetype)parseValue:(KatanaValue *)value
{
   if ( NULL == value )
      return nil;
   
   static dispatch_once_t   once;
   static NSArray *      classes;
   
   dispatch_once( &once, ^
   {
      classes = [NSArray arrayWithObjects:
               [IDEAAppletCSSNumberAutomatic class],
               [IDEAAppletCSSNumberPercentage class],
               [IDEAAppletCSSNumberPx class],
                [IDEAAppletCSSNumberChs class],
               [IDEAAppletCSSNumberCm class],
                [IDEAAppletCSSNumberDeg class],
                [IDEAAppletCSSNumberDpcm class],
                [IDEAAppletCSSNumberDpi class],
                [IDEAAppletCSSNumberDppx class],
               [IDEAAppletCSSNumberEm class],
               [IDEAAppletCSSNumberEx class],
                [IDEAAppletCSSNumberFr class],
                [IDEAAppletCSSNumberGRad class],
                [IDEAAppletCSSNumberHz class],
               [IDEAAppletCSSNumberIn class],
                [IDEAAppletCSSNumberKhz class],
               [IDEAAppletCSSNumberMm class],
                [IDEAAppletCSSNumberMs class],
               [IDEAAppletCSSNumberPc class],
               [IDEAAppletCSSNumberPt class],
                [IDEAAppletCSSNumberRad class],
                [IDEAAppletCSSNumberRems class],
                [IDEAAppletCSSNumberS class],
                [IDEAAppletCSSNumberTurn class],
                [IDEAAppletCSSNumberVh class],
                [IDEAAppletCSSNumberVmax class],
                [IDEAAppletCSSNumberVmin class],
                [IDEAAppletCSSNumberVw class],
               [IDEAAppletCSSNumberQem class],
               [IDEAAppletCSSNumberConstant class],
               nil];
   });
   
   IDEAAppletCSSNumber * result = nil;

   for ( Class valueClass in classes )
   {
      result = [valueClass parseValue:value];
      
      if ( result )
         break;
   }

   return result;
}

#pragma mark -

- (id)init
{
   self = [super init];
   if ( self )
   {
   }
   return self;
}

- (void)dealloc
{
   self.unit = nil;
}

#pragma mark -

- (NSString *)description
{
   return [NSString stringWithFormat:@"Number( %.2f%@ )", self.value, self.unit];
}

- (BOOL)isNumber
{
   return YES;
}

- (BOOL)isNumber:(CGFloat)value
{
   return self.value == value ? YES : NO;
}

- (CGFloat)computeValue:(CGFloat)value
{
   return INVALID_VALUE;
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( WebCore, CSSNumber )

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
