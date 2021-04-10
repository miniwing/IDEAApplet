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

#import "NSData+Extension.h"

#import "IDEAAppletUnitTest.h"

#import "__pragma_push.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation NSData(Extension)

@def_prop_dynamic( NSString   *, MD5String );
@def_prop_dynamic( NSData     *, MD5Data );

@def_prop_dynamic( NSString   *, SHA1String );
@def_prop_dynamic( NSData     *, SHA1Data );

@def_prop_dynamic( NSString   *, BASE64Encrypted );

- (NSString *)MD5String {
   
   uint8_t   abyDigest[CC_MD5_DIGEST_LENGTH + 1]   = { 0 };
   
   CC_MD5( [self bytes], (CC_LONG)[self length], abyDigest );
   
   char acTemp[16]   = { 0 };
   char acHex[256]   = { 0 };
   
   for ( CC_LONG H = 0; H < CC_MD5_DIGEST_LENGTH; ++H ) {
      
      sprintf( acTemp, "%02X", abyDigest[H] );
      strcat( (char *)acHex, acTemp );
      
   }  /* End if ( CC_LONG H = 0; H < CC_MD5_DIGEST_LENGTH; ++H ) */
   
   return [NSString stringWithUTF8String:(const char *)acHex];
}

- (NSData *)MD5Data {
   
   uint8_t   abyDigest[CC_MD5_DIGEST_LENGTH + 1]   = { 0 };
   
   CC_MD5( [self bytes], (CC_LONG)[self length], abyDigest );
   
   return [NSData dataWithBytes:abyDigest length:CC_MD5_DIGEST_LENGTH];
}

- (NSString *)SHA1String {
   
   uint8_t  abyDigest[CC_SHA1_DIGEST_LENGTH + 1]  = { 0 };
   
   CC_SHA1( self.bytes, (CC_LONG)self.length, abyDigest );
   
   char acTemp [16]  = { 0 };
   char aHex   [256] = { 0 };
   
   for ( CC_LONG H = 0; H < CC_SHA1_DIGEST_LENGTH; ++H ) {
      
      sprintf( acTemp, "%02X", abyDigest[H] );
      strcat( (char *)aHex, acTemp );
      
   } /* End fo ( CC_LONG H = 0; H < CC_SHA1_DIGEST_LENGTH; ++H ) */
   
   return [NSString stringWithUTF8String:(const char *)aHex];
}

- (NSData *)SHA1Data {
   
   uint8_t  abyDigest[CC_SHA1_DIGEST_LENGTH + 1]  = { 0 };
   
   CC_SHA1( self.bytes, (CC_LONG)self.length, abyDigest );
   
   return [NSData dataWithBytes:abyDigest length:CC_SHA1_DIGEST_LENGTH];
}

- (NSString *)BASE64Encrypted {
   
   static char * __base64EncodingTable = (char *)"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
   
   // copy from THREE20
   
   if ( 0 == [self length] ) {
      
      return @"";
      
   } /* End if () */
   
   char  *pcCharacters  = (char *)malloc((([self length] + 2) / 3) * 4);
   if ( NULL == pcCharacters ) {
      
      return nil;
      
   } /* End if () */
   
   memset(pcCharacters, 0, (([self length] + 2) / 3) * 4);
   
   NSUInteger nLength   = 0;
   NSUInteger H         = 0;
   
   while ( H < [self length] ) {
      
      char   acBuffer[3]   = { 0 };
      short  sBufferLength = 0;
      
      while ( sBufferLength < 3 && H < [self length] ) {
         
         acBuffer[sBufferLength++] = ((char *)[self bytes])[H++];
         
      } /* End while () */
      
      // Encode the bytes in the buffer to four characters,
      // including padding "=" characters if necessary.
      pcCharacters[nLength++] = __base64EncodingTable[(acBuffer[0] & 0xFC) >> 2];
      pcCharacters[nLength++] = __base64EncodingTable[((acBuffer[0] & 0x03) << 4) | ((acBuffer[1] & 0xF0) >> 4)];
      
      if ( sBufferLength > 1 ) {
         
         pcCharacters[nLength++] = __base64EncodingTable[((acBuffer[1] & 0x0F) << 2) | ((acBuffer[2] & 0xC0) >> 6)];
         
      } /* End if () */
      else {
         
         pcCharacters[nLength++] = '=';
         
      } /* End else */
      
      if ( sBufferLength > 2 ) {
         
         pcCharacters[nLength++] = __base64EncodingTable[acBuffer[2] & 0x3F];
         
      } /* End if () */
      else {
         
         pcCharacters[nLength++] = '=';
         
      } /* End else */
      
   } /* End while () */
   
   return [[NSString alloc] initWithBytesNoCopy:pcCharacters length:nLength encoding:NSASCIIStringEncoding freeWhenDone:YES];
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( Core, NSData_Extension ) {
   
   NSData * _testData;
}

DESCRIBE( before ) {
   
   _testData = [NSData dataWithBytes:"123456" length:6];
   
   EXPECTED( nil != _testData );
   EXPECTED( 6 == [_testData length] );
}

DESCRIBE( MD5 ) {
   
   NSString *   MD5String = _testData.MD5String;
   NSData *   MD5Data = _testData.MD5Data;
   
   EXPECTED( nil != MD5String );
   EXPECTED( nil != MD5Data );
}

DESCRIBE( SHA1 ) {
   
   NSString *   SHA1String = _testData.SHA1String;
   NSData *   SHA1Data = _testData.SHA1Data;
   
   EXPECTED( nil != SHA1String );
   EXPECTED( nil != SHA1Data );
}

DESCRIBE( BASE64 ) {
   
   NSString *   BASE64String = _testData.BASE64Encrypted;
   
   EXPECTED( nil != BASE64String );
}

DESCRIBE( after ) {
   
}

TEST_CASE_END

#endif   // #if __SAMURAI_TESTING__

#import "__pragma_pop.h"
