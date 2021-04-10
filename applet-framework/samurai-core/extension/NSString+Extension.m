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

#import "NSString+Extension.h"
#import "NSData+Extension.h"
#import "NSObject+Extension.h"

#import "IDEAAppletEncoding.h"
#import "IDEAAppletSystem.h"
#import "IDEAAppletUnitTest.h"

#import "__pragma_push.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation NSString(Extension)

@def_prop_dynamic ( NSString  *, MD5String );
@def_prop_dynamic ( NSData    *, MD5Data );

@def_prop_dynamic ( NSString  *, SHA1String );
@def_prop_dynamic ( NSData    *, SHA1Data );

@def_prop_dynamic ( NSData    *, BASE64Decrypted );

- (NSString *)MD5String {
   
   return [[NSData dataWithBytes:[self UTF8String] length:[self length]] MD5String];
}

- (NSData *)MD5Data {
   
   return [[NSData dataWithBytes:[self UTF8String] length:[self length]] MD5Data];
}

- (NSString *)SHA1String {
   
   return [[NSData dataWithBytes:[self UTF8String] length:[self length]] SHA1String];
}

- (NSData *)SHA1Data {
   
   return [[NSData dataWithBytes:[self UTF8String] length:[self length]] SHA1Data];
}

- (NSData *)BASE64Decrypted {
   
   static char * __base64EncodingTable = (char *)"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
   static char * __base64DecodingTable = nil;
   
   // copy from THREE20
   
   if ( 0 == [self length] ) {
      
      return [NSData data];
      
   } /* End if () */
   
   if ( NULL == __base64DecodingTable ) {
      
      __base64DecodingTable = (char *)malloc( 256 );
      
      if ( NULL == __base64DecodingTable ) {
         
         return nil;
         
      } /* End if () */
      
      memset( __base64DecodingTable, CHAR_MAX, 256 );
      
      for ( int H = 0; H < 64; H++) {
         
         __base64DecodingTable[(short)__base64EncodingTable[H]] = (char)H;
         
      } /* End for () */
      
   } /* End if () */
   
   const char  *cpcCharacters = [self cStringUsingEncoding:NSASCIIStringEncoding];
   if ( NULL == cpcCharacters ) { //  Not an ASCII string!
      
      return nil;
      
   } /* End if () */
   
   char  *pcBytes = (char *)malloc( ([self length] + 3) * 3 / 4 );
   if ( NULL == pcBytes ) {
      
      return nil;
      
   } /* End if () */
   
   memset(pcBytes, 0, ([self length] + 3) * 3 / 4 );
   
   NSUInteger   unLength   = 0;
   NSUInteger   H          = 0;
   
   while ( 1 ) {
      
      char   acBuffer[4]   = { 0 };
      short  sBufferLength = 0;
      
      for ( sBufferLength = 0; sBufferLength < 4; H++ ) {
         
         if ( cpcCharacters[H] == '\0' ) {
            
            break;
            
         } /* End if () */
         
         if ( isspace(cpcCharacters[H]) || cpcCharacters[H] == '=' ) {
            
            continue;
            
         } /* End if () */
         
         acBuffer[sBufferLength] = __base64DecodingTable[(short)cpcCharacters[H]];
         if ( CHAR_MAX == acBuffer[sBufferLength++] ) {
            
            free(pcBytes);
            return nil;
            
         } /* End if () */
         
      } /* End for () */
      
      if ( 0 == sBufferLength ) {
         
         break;
      }
      
      if ( 1 == sBufferLength ) {
         
         // At least two characters are needed to produce one byte!
         
         free(pcBytes);
         
         return nil;
         
      } /* End if () */
      
      //  Decode the characters in the buffer to bytes.
      
      pcBytes[unLength++] = (char)((acBuffer[0] << 2) | (acBuffer[1] >> 4));
      
      if (sBufferLength > 2) {
         
         pcBytes[unLength++] = (char)((acBuffer[1] << 4) | (acBuffer[2] >> 2));
         
      } /* End if () */
      
      if (sBufferLength > 3) {
         
         pcBytes[unLength++] = (char)((acBuffer[2] << 6) | acBuffer[3]);
         
      } /* End if () */
      
   } /* End while ( 1 ) */
   
   realloc( pcBytes, unLength );
   
   return [NSData dataWithBytesNoCopy:pcBytes length:unLength];
}

- (NSArray *)allURLs {
   
   NSMutableArray *stArray    = [NSMutableArray array];
   NSCharacterSet *stCharSet  = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789$-_.+!*'():/"] invertedSet];
   
   for ( NSUInteger nStringIndex = 0; nStringIndex < self.length; ) {
      
      NSRange   stSearchRange = NSMakeRange(nStringIndex, self.length - nStringIndex);
      NSRange   stHttpRange   = [self rangeOfString:@"http://" options:NSCaseInsensitiveSearch range:stSearchRange];
      NSRange   stHttpsRange  = [self rangeOfString:@"https://" options:NSCaseInsensitiveSearch range:stSearchRange];
      
      NSRange   stStartRange;
      
      if ( stHttpRange.location == NSNotFound ) {
         
         stStartRange = stHttpsRange;
         
      } /* End if () */
      else if ( stHttpsRange.location == NSNotFound ) {
         
         stStartRange = stHttpRange;
         
      } /* End else if () */
      else {
         
         stStartRange = (stHttpRange.location < stHttpsRange.location) ? stHttpRange : stHttpsRange;
         
      } /* End else */
      
      if (stStartRange.location == NSNotFound) {
         
         break;
         
      } /* End if () */
      else {
         
         NSRange   stBeforeRange    = NSMakeRange( stSearchRange.location, stStartRange.location - stSearchRange.location );
         if ( stBeforeRange.length ) {
            
//            NSString * text = [string substringWithRange:beforeRange];
//            [array addObject:text];
            
         } /* End if () */
         
         NSRange   stSubSearchRange = NSMakeRange(stStartRange.location, self.length - stStartRange.location);
//         NSRange endRange = [self rangeOfString:@" " options:NSCaseInsensitiveSearch range:subSearchRange];
         NSRange   stEndRange       = [self rangeOfCharacterFromSet:stCharSet options:NSCaseInsensitiveSearch range:stSubSearchRange];
         if ( stEndRange.location == NSNotFound) {
            
            NSString * url = [self substringWithRange:stSubSearchRange];
            [stArray addObject:url];
            break;
            
         } /* End if () */
         else {
            
            NSRange   stURLRange = NSMakeRange(stStartRange.location, stEndRange.location - stStartRange.location);
            NSString *szURL      = [self substringWithRange:stURLRange];
            [stArray addObject:szURL];
            
            nStringIndex = stEndRange.location;
            
         } /* End else */
         
      } /* End else */
      
   } /* End for ( NSUInteger nStringIndex = 0; nStringIndex < self.length; ) */
   
   return stArray;
}

+ (NSString *)queryStringFromDictionary:(NSDictionary *)aDict {
   
   return [self queryStringFromDictionary:aDict encoding:YES];
}

+ (NSString *)queryStringFromDictionary:(NSDictionary *)aDict encoding:(BOOL)aEncoding {
   
   NSMutableArray *stPairs = [NSMutableArray array];
   for ( NSString *szKey in aDict.allKeys ) {
      
      NSString *szValue       = [((NSObject *)[aDict objectForKey:szKey]) toString];
      NSString *szURLEncoding = aEncoding ? [szValue URLEncoding] : szValue;
      [stPairs addObject:[NSString stringWithFormat:@"%@=%@", szKey, szURLEncoding]];
      
   } /* End for ( NSString *szKey in aDict.allKeys ) */
   
   return [stPairs componentsJoinedByString:@"&"];
}

+ (NSString *)queryStringFromArray:(NSArray *)aArray {
   
   return [self queryStringFromArray:aArray encoding:YES];
}

+ (NSString *)queryStringFromArray:(NSArray *)aArray encoding:(BOOL)aEncoding {
   
   NSMutableArray *stPairs = [NSMutableArray array];
   
   for ( NSUInteger H = 0; H < [aArray count]; H += 2 ) {
      
      NSObject *stObj1  = [aArray objectAtIndex:H];
      NSObject *stObj2  = [aArray objectAtIndex:H + 1];
      
      NSString *szKey   = nil;
      NSString *szValue = nil;
      
      if ( [stObj1 isKindOfClass:[NSNumber class]] ) {
         
         szKey = [(NSNumber *)stObj1 stringValue];
         
      } /* End if ( [stObj1 isKindOfClass:[NSNumber class]] ) */
      else if ( [stObj1 isKindOfClass:[NSString class]] ) {
         
         szKey = (NSString *)stObj1;
         
      } /* End else if ( [stObj1 isKindOfClass:[NSString class]] ) */
      else {
         
         continue;
         
      } /* End else */
      
      if ( [stObj2 isKindOfClass:[NSNumber class]] ) {
         
         szValue = [(NSNumber *)stObj2 stringValue];
         
      } /* End if ( [stObj2 isKindOfClass:[NSNumber class]] ) */
      else if ( [stObj1 isKindOfClass:[NSString class]] ) {
         
         szValue = (NSString *)stObj2;
         
      } /* End else if ( [stObj1 isKindOfClass:[NSString class]] ) */
      else {
         
         continue;
         
      } /* End else */
      
      NSString *szURLEncoding = aEncoding ? [szValue URLEncoding] : szValue;
      [stPairs addObject:[NSString stringWithFormat:@"%@=%@", szKey, szURLEncoding]];
      
   } /* End for ( NSUInteger H = 0; H < [aArray count]; H += 2 ) */
   
   return [stPairs componentsJoinedByString:@"&"];
}

+ (NSString *)queryStringFromKeyValues:(id)aFirst, ... {
   
   NSMutableDictionary     *stDict  = [NSMutableDictionary dictionary];
   
   va_list   stArgs;
   va_start( stArgs, aFirst );
   
   for ( ;; ) {
      
      NSObject<NSCopying>  *stKey   = [stDict count] ? va_arg( stArgs, NSObject * ) : aFirst;
      if ( nil == stKey ) {
         
         break;
         
      } /* End if ( nil == stKey ) */
      
      NSObject *stValue = va_arg( stArgs, NSObject * );
      if ( nil == stValue ) {
         
         break;
         
      } /* End if ( nil == stValue ) */
      
      [stDict setObject:stValue forKey:stKey];
      
   } /* End for ( ;; ) */
   
   va_end( stArgs );
   
   return [NSString queryStringFromDictionary:stDict];
}

- (NSString *)urlByAppendingDict:(NSDictionary *)aParams {
   
   return [self urlByAppendingDict:aParams encoding:YES];
}

- (NSString *)urlByAppendingDict:(NSDictionary *)aParams encoding:(BOOL)aEncoding {
   
   NSURL    *stParsedURL   = [NSURL URLWithString:self];
   NSString *szQueryPrefix = stParsedURL.query ? @"&" : @"?";
   NSString *szQuery       = [NSString queryStringFromDictionary:aParams encoding:aEncoding];
   
   return [NSString stringWithFormat:@"%@%@%@", self, szQueryPrefix, szQuery];
}

- (NSString *)urlByAppendingArray:(NSArray *)aParams {
   
   return [self urlByAppendingArray:aParams encoding:YES];
}

- (NSString *)urlByAppendingArray:(NSArray *)aParams encoding:(BOOL)aEncoding {
   
   NSURL    *stParsedURL   = [NSURL URLWithString:self];
   NSString *szQueryPrefix = stParsedURL.query ? @"&" : @"?";
   NSString *szQuery       = [NSString queryStringFromArray:aParams encoding:aEncoding];
   
   return [NSString stringWithFormat:@"%@%@%@", self, szQueryPrefix, szQuery];
}

- (NSString *)urlByAppendingKeyValues:(id)aFirst, ... {
   
   NSMutableDictionary     *stDict  = [NSMutableDictionary dictionary];
   
   va_list   stArgs;
   va_start( stArgs, aFirst );
   
   for ( ;; ) {
      
      NSObject<NSCopying>  *stKey   = [stDict count] ? va_arg( stArgs, NSObject * ) : aFirst;
      if ( nil == stKey ) {
         break;
         
      } /* End if ( nil == stKey ) */
      
      NSObject *stValue = va_arg( stArgs, NSObject * );
      if ( nil == stValue ) {
         
         break;
         
      } /* End if ( nil == stValue ) */
      
      [stDict setObject:stValue forKey:stKey];
      
   } /* End for ( ;; ) */
   
   va_end( stArgs );
   
   return [self urlByAppendingDict:stDict];
}

- (NSString *)URLEncoding {
   
   return [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"!*'();:@&=+$,/?%#[]"]];
}

- (NSString *)URLDecoding {
   
   NSMutableString   *stString   = [NSMutableString stringWithString:self];
   
   [stString replaceOccurrencesOfString:@"+"
                             withString:@" "
                                options:NSLiteralSearch
                                  range:NSMakeRange(0, [stString length])];
   
   return [stString stringByRemovingPercentEncoding];
}

- (NSString *)trim {
   
   return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)flat {
   
   return [self stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
}

- (NSString *)unwrap {
   
   if ( self.length >= 2 ) {
      
      if ( [self hasPrefix:@"\""] && [self hasSuffix:@"\""] ) {
         
         return [self substringWithRange:NSMakeRange(1, self.length - 2)];
      }
      
      if ( [self hasPrefix:@"'"] && [self hasSuffix:@"'"] ) {
         
         return [self substringWithRange:NSMakeRange(1, self.length - 2)];
      }
   }
   
   return self;
}

- (NSString *)normalize {
   
   //   return [self stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
   //   return [self stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
   
   NSArray  *stLines = [self componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
   
   if ( stLines && stLines.count ) {
      
      NSMutableString   *stMergedString   = [NSMutableString string];
      
      for ( NSString *szLine in stLines ) {
         
         NSString *szTrimed = [szLine stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
         
         if ( szTrimed && szTrimed.length ) {
            
            [stMergedString appendString:szTrimed];
            
         } /* End if ( szTrimed && szTrimed.length ) */
         
      } /* End for ( NSString *szLine in stLines ) */
      
      return stMergedString;
      
   } /* End if ( stLines && stLines.count ) */
   
   return nil;
}

- (NSString *)repeat:(NSUInteger)aCount {
   
   if ( 0 == aCount ) {
      
      return @"";
      
   } /* End if ( 0 == aCount ) */
   
   NSMutableString   *aText   = [NSMutableString string];
   
   for ( NSUInteger H = 0; H < aCount; ++H ) {
      
      [aText appendString:self];
      
   } /* End for ( NSUInteger H = 0; H < aCount; ++H ) */
   
   return aText;
}

- (NSString *)strongify {
   
   return [self stringByReplacingOccurrencesOfString:@"//" withString:@"/"];
}

- (BOOL)match:(NSString *)aExpression {
   
   NSRegularExpression  *stRegex = [NSRegularExpression regularExpressionWithPattern:aExpression
                                                                             options:NSRegularExpressionCaseInsensitive
                                                                               error:nil];
   if ( nil == stRegex ) {
      
      return NO;
      
   } /* End for ( nil == stRegex ) */
   
   NSUInteger   nNumberOfMatches = [stRegex numberOfMatchesInString:self
                                                            options:0
                                                              range:NSMakeRange(0, self.length)];
   if ( 0 == nNumberOfMatches ) {
      
      return NO;
      
   } /* End if ( 0 == numberOfMatches ) */
   
   return YES;
}

- (BOOL)matchAnyOf:(NSArray *)aArray {
   
   for ( NSString * szString in aArray ) {
      
      if ( NSOrderedSame == [self compare:szString options:NSCaseInsensitiveSearch] ) {
         
         return YES;
         
      } /* End if ( NSOrderedSame == [self compare:szString options:NSCaseInsensitiveSearch] ) */
      
   } /* End fo ( NSString * szString in aArray ) */
   
   return NO;
}

- (BOOL)empty {
   
   return [self length] > 0 ? NO : YES;
}

- (BOOL)notEmpty {
   
   return [self length] > 0 ? YES : NO;
}

- (BOOL)eq:(NSString *)aOther {
   
   return [self isEqualToString:aOther];
}

- (BOOL)equal:(NSString *)aOther {
   
   return [self isEqualToString:aOther];
}

- (BOOL)is:(NSString *)aOther {
   
   return [self isEqualToString:aOther];
}

- (BOOL)isNot:(NSString *)aOther {
   
   return NO == [self isEqualToString:aOther];
}

- (BOOL)isValueOf:(NSArray *)aArray {
   
   return [self isValueOf:aArray caseInsens:NO];
}

- (BOOL)isValueOf:(NSArray *)aArray caseInsens:(BOOL)aCaseInsens {
   
   NSStringCompareOptions   eOption = aCaseInsens ? NSCaseInsensitiveSearch : 0;
   
   for ( NSObject *stObject in aArray ) {
      
      if ( NO == [stObject isKindOfClass:[NSString class]] ) {
         
         continue;
         
      } /* End if ( NO == [stObject isKindOfClass:[NSString class]] ) */
      
      if ( NSOrderedSame == [(NSString *)stObject compare:self options:eOption] ) {
         
         return YES;
         
      } /* End if ( NSOrderedSame == [(NSString *)stObject compare:self options:eOption] ) */
      
   } /* End for ( NSObject *stObject in aArray ) */
   
   return NO;
}

- (BOOL)isNumber {
   
   NSString    *szRegex       = @"-?[0-9.]+";
   NSPredicate *stPredicate   = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", szRegex];
   
   return [stPredicate evaluateWithObject:self];
}

- (BOOL)isNumberWithUnit:(NSString *)aUnit {
   
   NSString    *szRegex       = [NSString stringWithFormat:@"-?[0-9.]+%@", aUnit];
   NSPredicate *stPredicate   = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", szRegex];
   
   return [stPredicate evaluateWithObject:self];
}

- (BOOL)isEmail {
   
   NSString    *szRegex       = @"[A-Z0-9a-z._\%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}";
   NSPredicate *stPredicate   = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", szRegex];
   
   return [stPredicate evaluateWithObject:[self lowercaseString]];
}

- (BOOL)isUrl {
   
   return ([self hasPrefix:@"http://"] || [self hasPrefix:@"https://"]) ? YES : NO;
}

- (BOOL)isIPAddress {
   
   NSArray        *stComponents        = [self componentsSeparatedByString:@"."];
   NSCharacterSet *stInvalidCharacters = [[NSCharacterSet characterSetWithCharactersInString:@"1234567890"] invertedSet];
   
   if ( [stComponents count] == 4 ) {
      
      NSString *szPart1 = [stComponents objectAtIndex:0];
      NSString *szPart2 = [stComponents objectAtIndex:1];
      NSString *szPart3 = [stComponents objectAtIndex:2];
      NSString *szPart4 = [stComponents objectAtIndex:3];
      
      if ( 0 == [szPart1 length] ||
           0 == [szPart2 length] ||
           0 == [szPart3 length] ||
           0 == [szPart4 length] ) {
         
         return NO;
         
      } /* End if () */
      
      if ( [szPart1 rangeOfCharacterFromSet:stInvalidCharacters].location == NSNotFound &&
           [szPart2 rangeOfCharacterFromSet:stInvalidCharacters].location == NSNotFound &&
           [szPart3 rangeOfCharacterFromSet:stInvalidCharacters].location == NSNotFound &&
           [szPart4 rangeOfCharacterFromSet:stInvalidCharacters].location == NSNotFound ) {
         
         if ( [szPart1 intValue] <= 255 &&
              [szPart2 intValue] <= 255 &&
              [szPart3 intValue] <= 255 &&
              [szPart4 intValue] <= 255 ) {
            
            return YES;
            
         } /* End if () */
         
      } /* End if () */
      
   } /* End if () */
   
   return NO;
}

- (NSString *)substringFromIndex:(NSUInteger)aFrom untilString:(NSString *)aString {
   
   return [self substringFromIndex:aFrom untilString:aString endOffset:NULL];
}

- (NSString *)substringFromIndex:(NSUInteger)aFrom untilString:(NSString *)aString endOffset:(NSUInteger *)aEndOffset {
   
   if ( 0 == self.length ) {
      
      return nil;
      
   } /* End if () */
   
   if ( aFrom >= self.length ) {
      
      return nil;
      
   } /* End if () */
   
   NSRange   stRange    = NSMakeRange( aFrom, self.length - aFrom );
   NSRange   stRange2   = [self rangeOfString:aString options:NSCaseInsensitiveSearch range:stRange];
   
   if ( NSNotFound == stRange2.location ) {
      
      if ( aEndOffset ) {
         
         *aEndOffset = stRange.location + stRange.length;
         
      } /* End if () */
      
      return [self substringWithRange:stRange];
      
   } /* End if () */
   else {
      
      if ( aEndOffset ) {
         
         *aEndOffset = stRange2.location + stRange2.length;
         
      } /* End if () */
      
      return [self substringWithRange:NSMakeRange(aFrom, stRange2.location - aFrom)];
      
   }  /* End else */
}

- (NSString *)substringFromIndex:(NSUInteger)aFrom untilCharset:(NSCharacterSet *)aCharset {
   
   return [self substringFromIndex:aFrom untilCharset:aCharset endOffset:NULL];
}

- (NSString *)substringFromIndex:(NSUInteger)aFrom untilCharset:(NSCharacterSet *)aCharset endOffset:(NSUInteger *)aEndOffset {
   
   if ( 0 == self.length ) {
      
      return nil;
      
   } /* End if () */
   
   if ( aFrom >= self.length ) {
      
      return nil;
      
   }  /* End if () */
   
   NSRange   stRange    = NSMakeRange( aFrom, self.length - aFrom );
   NSRange   stRange2   = [self rangeOfCharacterFromSet:aCharset options:NSCaseInsensitiveSearch range:stRange];
   
   if ( NSNotFound == stRange2.location ) {
      
      if ( aEndOffset ) {
         
         *aEndOffset = stRange.location + stRange.length;
         
      } /* End if () */
      
      return [self substringWithRange:stRange];
      
   } /* End if () */
   else {
      
      if ( aEndOffset ) {
         
         *aEndOffset = stRange2.location + stRange2.length;
         
      } /* End if () */
      
      return [self substringWithRange:NSMakeRange(aFrom, stRange2.location - aFrom)];
      
   }  /* End else */
}

- (NSUInteger)countFromIndex:(NSUInteger)aFrom inCharset:(NSCharacterSet *)aCharset {
   
   if ( 0 == self.length ) {
      
      return 0;
      
   } /* End if () */
   
   if ( aFrom >= self.length ) {
      
      return 0;
      
   } /* End if () */
   
   NSCharacterSet *stReversedCharset   = [aCharset invertedSet];
   
   NSRange   stRange    = NSMakeRange( aFrom, self.length - aFrom );
   NSRange   stRange2   = [self rangeOfCharacterFromSet:stReversedCharset options:NSCaseInsensitiveSearch range:stRange];
   
   if ( NSNotFound == stRange2.location ) {
      
      return self.length - aFrom;
      
   } /* End if () */
   else {
      
      return stRange2.location - aFrom;
      
   } /* End else */
}

- (NSArray *)pairSeparatedByString:(NSString *)aSeparator {
   
   if ( nil == aSeparator ) {
      
      return nil;
      
   } /* End if () */
   
   NSUInteger   nOffset = 0;
   NSString    *szKey   = [self substringFromIndex:0
                                      untilCharset:[NSCharacterSet characterSetWithCharactersInString:aSeparator]
                                         endOffset:&nOffset];
   NSString    *szVal   = nil;
   
   if ( nil == szKey || nOffset >= self.length ) {
      
      return nil;
      
   }  /* End if () */
   
   szVal = [self substringFromIndex:nOffset];
   if ( nil == szVal ) {
      
      return nil;
      
   }  /* End if () */
   
   return [NSArray arrayWithObjects:szKey, szVal, nil];
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( Core, NSString_Extension )

DESCRIBE( before ) {
   
}

DESCRIBE( after ) {
   
}

TEST_CASE_END

#endif   // #if __SAMURAI_TESTING__

#import "__pragma_pop.h"
