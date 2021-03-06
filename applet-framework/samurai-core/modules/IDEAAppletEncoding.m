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

#import "IDEAAppletEncoding.h"
#import "IDEAAppletAssert.h"
#import "IDEAAppletUnitTest.h"
#import "IDEAAppletRuntime.h"

#import "NSObject+Extension.h"
#import "NSDate+Extension.h"
#import "NSDictionary+Extension.h"
#import "NSMutableDictionary+Extension.h"

#import "__pragma_push.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation NSObject(Encoding)

- (NSObject *)converToType:(EncodingType)aType {
   
   if ( EncodingType_Null == aType ) {
      
      return [NSNull null];
   }
   else if ( EncodingType_Number == aType ) {
      
      return [self toNumber];
   }
   else if ( EncodingType_String == aType ) {
      
      return [self toString];
   }
   else if ( EncodingType_Date == aType ) {
      
      return [self toDate];
   }
   else if ( EncodingType_Data == aType ) {
      
      return [self toData];
   }
   else if ( EncodingType_Url == aType ) {
      
      return [self toURL];
   }
   else if ( EncodingType_Array == aType ) {
      
      return nil;
   }
   else if ( EncodingType_Dict == aType ) {
      
      return nil;
   }
   else {
      
      return nil;
   }
}

@end

#pragma mark -

@implementation IDEAAppletEncoding

+ (BOOL)isReadOnly:(const char *)aAttr {
   
   if ( strstr(aAttr, "_ro") || strstr(aAttr, ",R") ) {
      
      return YES;
   }
   
   return NO;
}

#pragma mark -

+ (EncodingType)typeOfAttribute:(const char *)aAttr {
   
   if ( NULL == aAttr ) {
      
      return EncodingType_Unknown;
   }
   
   if ( aAttr[0] != 'T' ) {
      return EncodingType_Unknown;
   }
   
   const char * type = &aAttr[1];
   if ( type[0] == '@' ) {
      
      if ( type[1] != '"' ) {
         return EncodingType_Unknown;
      }
      
      char typeClazz[128] = { 0 };
      
      const char * clazzBegin = &type[2];
      const char * clazzEnd = strchr( clazzBegin, '"' );
      
      if ( clazzEnd && clazzBegin != clazzEnd ) {
         
         unsigned int size = (unsigned int)(clazzEnd - clazzBegin);
         strncpy( &typeClazz[0], clazzBegin, size );
         
      } /* End if () */
      
      return [self typeOfClassName:typeClazz];
      
   } /* End if () */
   else if ( type[0] == '[' ) {
      
      return EncodingType_Unknown;
      
   } /* End else if () */
   else if ( type[0] == '{' ) {
      
      return EncodingType_Unknown;
      
   } /* End else if () */
   else {
      
      if ( type[0] == 'c' || type[0] == 'C' ) {
         
         return EncodingType_Unknown;
      }
      else if ( type[0] == 'i' || type[0] == 's' || type[0] == 'l' || type[0] == 'q' ) {
         
         return EncodingType_Unknown;
      }
      else if ( type[0] == 'I' || type[0] == 'S' || type[0] == 'L' || type[0] == 'Q' ) {
         
         return EncodingType_Unknown;
      }
      else if ( type[0] == 'f' ) {
         
         return EncodingType_Unknown;
      }
      else if ( type[0] == 'd' ) {
         
         return EncodingType_Unknown;
      }
      else if ( type[0] == 'B' ) {
         
         return EncodingType_Unknown;
      }
      else if ( type[0] == 'v' ) {
         
         return EncodingType_Unknown;
      }
      else if ( type[0] == '*' ) {
         
         return EncodingType_Unknown;
      }
      else if ( type[0] == ':' ) {
         
         return EncodingType_Unknown;
      }
      else if ( 0 == strcmp(type, "bnum") ) {
         
         return EncodingType_Unknown;
      }
      else if ( type[0] == '^' ) {
         
         return EncodingType_Unknown;
      }
      else if ( type[0] == '?' ) {
         
         return EncodingType_Unknown;
      }
      else {
         
         return EncodingType_Unknown;
      }
   }
   
   return EncodingType_Unknown;
}

+ (EncodingType)typeOfClass:(Class)aTypeClazz {
   
   if ( nil == aTypeClazz ) {
      
      return EncodingType_Unknown;
   }
   
   const char * className = [[aTypeClazz description] UTF8String];
   return [self typeOfClassName:className];
}

+ (EncodingType)typeOfClassName:(const char *)className {
   
   if ( nil == className ) {
      
      return EncodingType_Unknown;
   }
   
#undef  __MATCH_CLASS
#define __MATCH_CLASS( X )    \
                              0 == strcmp((const char *)className, "NS" #X)          || \
                              0 == strcmp((const char *)className, "NSMutable" #X)   || \
                              0 == strcmp((const char *)className, "_NSInline" #X)   || \
                              0 == strcmp((const char *)className, "__NS" #X)        || \
                              0 == strcmp((const char *)className, "__NSMutable" #X) || \
                              0 == strcmp((const char *)className, "__NSCF" #X)      || \
                              0 == strcmp((const char *)className, "__NSCFConstant" #X)
   
   if ( __MATCH_CLASS( Number ) ) {
      
      return EncodingType_Number;
   }
   else if ( __MATCH_CLASS( String ) ) {
      
      return EncodingType_String;
   }
   else if ( __MATCH_CLASS( Date ) ) {
      
      return EncodingType_Date;
   }
   else if ( __MATCH_CLASS( Array ) ) {
      
      return EncodingType_Array;
   }
   else if ( __MATCH_CLASS( Set ) ) {
      
      return EncodingType_Array;
   }
   else if ( __MATCH_CLASS( Dictionary ) ) {
      
      return EncodingType_Dict;
   }
   else if ( __MATCH_CLASS( Data ) ) {
      
      return EncodingType_Data;
   }
   else if ( __MATCH_CLASS( URL ) ) {
      
      return EncodingType_Url;
   }
   
   return EncodingType_Unknown;
}

+ (EncodingType)typeOfObject:(id)aObject {
   
   if ( nil == aObject ) {
      
      return EncodingType_Unknown;
   }
   
   if ( [aObject isKindOfClass:[NSNumber class]] ) {
      
      return EncodingType_Number;
   }
   else if ( [aObject isKindOfClass:[NSString class]] ) {
      
      return EncodingType_String;
   }
   else if ( [aObject isKindOfClass:[NSDate class]] ) {
      
      return EncodingType_Date;
   }
   else if ( [aObject isKindOfClass:[NSArray class]] ) {
      
      return EncodingType_Array;
   }
   else if ( [aObject isKindOfClass:[NSSet class]] ) {
      
      return EncodingType_Array;
   }
   else if ( [aObject isKindOfClass:[NSDictionary class]] ) {
      
      return EncodingType_Dict;
   }
   else if ( [aObject isKindOfClass:[NSData class]] ) {
      
      return EncodingType_Data;
   }
   else if ( [aObject isKindOfClass:[NSURL class]] ) {
      
      return EncodingType_Url;
   }
   else {
      
      const char * className = [[[aObject class] description] UTF8String];
      return [self typeOfClassName:className];
   }
}

#pragma mark -

+ (NSString *)classNameOfAttribute:(const char *)attr {
   
   if ( NULL == attr ) {
      
      return nil;
   }
   
   if ( attr[0] != 'T' )
      return nil;
   
   const char * type = &attr[1];
   if ( type[0] == '@' ) {
      
      if ( type[1] != '"' )
         return nil;
      
      char typeClazz[128] = { 0 };
      
      const char * clazz = &type[2];
      const char * clazzEnd = strchr( clazz, '"' );
      
      if ( clazzEnd && clazz != clazzEnd ) {
         
         unsigned int size = (unsigned int)(clazzEnd - clazz);
         strncpy( &typeClazz[0], clazz, size );
      }
      
      return [NSString stringWithUTF8String:typeClazz];
   }
   
   return nil;
}

+ (NSString *)classNameOfClass:(Class)clazz {
   
   if ( nil == clazz ) {
      
      return nil;
   }
   
   const char * className = class_getName( clazz );
   if ( className ) {
      
      return [NSString stringWithUTF8String:className];
   }
   
   return nil;
}

+ (NSString *)classNameOfObject:(id)obj {
   
   if ( nil == obj ) {
      
      return nil;
   }
   
   return [[obj class] description];
}

#pragma mark -

+ (Class)classOfAttribute:(const char *)attr {
   
   if ( NULL == attr ) {
      
      return nil;
   }
   
   NSString * className = [self classNameOfAttribute:attr];
   if ( nil == className )
      return nil;
   
   return NSClassFromString( className );
}

#pragma mark -

+ (BOOL)isAtomObject:(id)obj {
   
   if ( nil == obj ) {
      
      return NO;
   }
   
   return [self isAtomClass:[obj class]];
}

+ (BOOL)isAtomAttribute:(const char *)attr {
   
   if ( NULL == attr ) {
      
      return NO;
   }
   
   NSInteger encoding = [self typeOfAttribute:attr];
   
   if ( EncodingType_Unknown != encoding ) {
      
      return YES;
   }
   else {
      
      return NO;
   }
}

+ (BOOL)isAtomClassName:(const char *)clazz {
   
   if ( NULL == clazz ) {
      
      return NO;
   }
   
   NSInteger encoding = [self typeOfClassName:clazz];
   
   if ( EncodingType_Unknown != encoding ) {
      
      return YES;
   }
   else {
      
      return NO;
   }
}

+ (BOOL)isAtomClass:(Class)clazz {
   
   if ( nil == clazz ) {
      
      return NO;
   }
   
   NSInteger encoding = [self typeOfClass:clazz];
   
   if ( EncodingType_Unknown != encoding ) {
      
      return YES;
   }
   else {
      
      return NO;
   }
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( Core, Encoding )

DESCRIBE( before ) {
   
}

DESCRIBE( after ) {
   
}

TEST_CASE_END

#endif   // #if __SAMURAI_TESTING__

#import "__pragma_pop.h"
