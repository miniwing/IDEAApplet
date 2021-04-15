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

#import "IDEAAppletCSSMediaQuery.h"
#import "IDEAAppletCSSParser.h"

#import "__pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation IDEAAppletCSSMediaQuery

@def_singleton( IDEAAppletCSSMediaQuery )

- (BOOL)test:(NSString *)aCondition {
   
   if ( nil == aCondition ) {
      
      return YES;
      
   } /* End if () */
   
   KatanaOutput   *stOutput   = [[IDEAAppletCSSParser sharedInstance] parseMedia:aCondition];
   
   if ( NULL != stOutput ) {
      
      BOOL bPassed = [self testMediaQueries:stOutput->medias];
      
      katana_destroy_output(stOutput);
      
      return bPassed;
      
   } /* End if () */
   
   return NO;
}

- (BOOL)testMediaQueries:(KatanaArray *)aMedias {
   
   if ( aMedias == NULL ) {
      
      return YES;
      
   } /* End if () */
   
   BOOL bPassed = YES;
   
   for ( int H = 0; H < aMedias->length; H++ ) {
      
      KatanaMediaQuery  *stMediaQuery = aMedias->data[H];
      
      if ( NULL == stMediaQuery->expressions || 0 == stMediaQuery->expressions->length ) {
         
         if ( stMediaQuery->type ) {
            
            BOOL bMatches = [self testMediaQueryType:stMediaQuery->type];
            
            if ( KatanaMediaQueryRestrictorNot == stMediaQuery->restrictor ) {
               
               bPassed = bPassed && !bMatches;
               
            } /* End if () */
            else {
               
               bPassed = bPassed && bMatches;
               
            } /* End else */
            
            if ( NO == bPassed ) {
               
               return NO;
               
            } /* End if () */
            
         } /* End if () */
         else {
            
            return YES;
            
         } /* End else */
         
      } /* End if () */
      else {
         
         for ( int H = 0; H < stMediaQuery->expressions->length; H++ ) {
            
            BOOL matches = [self testMediaQueryExpression:stMediaQuery->expressions->data[H]];
            
            if ( KatanaMediaQueryRestrictorNot == stMediaQuery->restrictor ) {
               
               bPassed = bPassed && !matches;
            }
            else {
               
               bPassed = bPassed && matches;
            }
            
            if ( NO == bPassed ) {
               
               return NO;
               
            } /* End if () */
            
         } /* End for ( int H = 0; H < stMediaQuery->expressions->length; H++ ) */
         
      } /* End else */
      
   } /* End for ( int H = 0; H < aMedias->length; H++ ) */
   
   return YES;
}

- (BOOL)testMediaQueryType:(const char *)aMediaQueryType {
   
   if ( NULL == aMediaQueryType ) {
      
      return YES;
   }
   
   if ( 0 == strcasecmp( aMediaQueryType, "all" ) ) {
      
      return YES;
   }
   else if ( 0 == strcasecmp( aMediaQueryType, "aural" ) ) {
      
      return NO;
   }
   else if ( 0 == strcasecmp( aMediaQueryType, "braille" ) ) {
      
      return NO;
   }
   else if ( 0 == strcasecmp( aMediaQueryType, "handheld" ) ) {
      
      return YES;
   }
   else if ( 0 == strcasecmp( aMediaQueryType, "print" ) ) {
      
      return NO;
   }
   else if ( 0 == strcasecmp( aMediaQueryType, "projection" ) ) {
      
      return NO;
   }
   else if ( 0 == strcasecmp( aMediaQueryType, "screen" ) ) {
      
      return YES;
   }
   else if ( 0 == strcasecmp( aMediaQueryType, "tty" ) ) {
      
      return NO;
   }
   else if ( 0 == strcasecmp( aMediaQueryType, "tv" ) ) {
      
      return NO;
   }
   else if ( 0 == strcasecmp( aMediaQueryType, "embossed" ) ) {
      
      return NO;
   }
   else {
      
      return NO;
   }
}

- (BOOL)testMediaQueryExpression:(KatanaMediaQueryExp *)aMediaQueryExp {
   
   if ( NULL == aMediaQueryExp ) {
      return YES;
   }
   
   KatanaValue *stValue = aMediaQueryExp->values->length ? aMediaQueryExp->values->data[0] : NULL;
   
   if ( NULL == stValue )
      return NO;
   
   if ( 0 == strcasecmp( aMediaQueryExp->feature, "device-width" ) ) {
      
      return [[UIScreen mainScreen] bounds].size.width == stValue->fValue;
   }
   else if ( 0 == strcasecmp( aMediaQueryExp->feature, "min-device-width" ) ) {
      
      return [[UIScreen mainScreen] bounds].size.width >= stValue->fValue;
   }
   else if ( 0 == strcasecmp( aMediaQueryExp->feature, "max-device-width" ) ) {
      
      return [[UIScreen mainScreen] bounds].size.width <= stValue->fValue;
   }
   else if ( 0 == strcasecmp( aMediaQueryExp->feature, "device-height" ) ) {
      
      return [[UIScreen mainScreen] bounds].size.height == stValue->fValue;
   }
   else if ( 0 == strcasecmp( aMediaQueryExp->feature, "min-device-height" ) ) {
      
      return [[UIScreen mainScreen] bounds].size.height >= stValue->fValue;
   }
   else if ( 0 == strcasecmp( aMediaQueryExp->feature, "max-device-height" ) ) {
      
      return [[UIScreen mainScreen] bounds].size.height <= stValue->fValue;
   }
   else if ( 0 == strcasecmp( aMediaQueryExp->feature, "scale" ) ) {
      
      return [[UIScreen mainScreen] scale] == stValue->fValue;
   }
   else if ( 0 == strcasecmp( aMediaQueryExp->feature, "min-scale" ) ) {
      
      return [[UIScreen mainScreen] scale] >= stValue->fValue;
   }
   else if ( 0 == strcasecmp( aMediaQueryExp->feature, "max-scale" ) ) {
      
      return [[UIScreen mainScreen] scale] <= stValue->fValue;
   }
   else if ( 0 == strcasecmp( aMediaQueryExp->feature, "orientation" ) ) {
      
      if ( NULL == stValue->string ) {
         return NO;
      }
      
      UIInterfaceOrientation   eOrientation  = [[UIApplication sharedApplication] statusBarOrientation];
      
      if ( UIInterfaceOrientationLandscapeLeft == eOrientation || UIInterfaceOrientationLandscapeRight == eOrientation ) {
         
         return (0 == strcasecmp(stValue->string, "landscape")) ? YES : NO;
      }
      else if ( UIInterfaceOrientationPortrait == eOrientation || UIDeviceOrientationPortraitUpsideDown == eOrientation ) {
         
         return (0 == strcasecmp(stValue->string, "portrait")) ? YES : NO;
      }
      else {
         
         return NO;
      }
   }
   // else if ( 0 == strcasecmp( mediaQueryExp->feature, "device"] )
   // {
   //     return NO;
   // }
   
   return NO;
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( WebCore, CSSMediaQuery )

DESCRIBE( before ) {
   
}

DESCRIBE( after ) {
   
}

TEST_CASE_END

#endif   // #if __SAMURAI_TESTING__

#endif   // #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "__pragma_pop.h"
