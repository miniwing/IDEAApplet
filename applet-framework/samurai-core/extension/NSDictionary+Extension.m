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

#import "NSDictionary+Extension.h"
#import "NSMutableDictionary+Extension.h"
#import "NSObject+Extension.h"

#import "IDEAAppletRuntime.h"
#import "IDEAAppletUnitTest.h"

#import "__pragma_push.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation NSDictionary(Extension)

- (BOOL)hasObjectForKey:(id)aKey {
   
   return [self objectForKey:aKey] ? YES : NO;
}

- (id)objectForOneOfKeys:(NSArray *)aArray {
   
   for ( NSString * szKey in aArray ) {
      
      NSObject *stObject   = [self objectForKey:szKey];
      
      if ( stObject ) {
         
         return stObject;
         
      } /* End if () */
      
   } /* End for () */
   
   return nil;
}

- (NSNumber *)numberForOneOfKeys:(NSArray *)aArray {
   
   NSObject *stObject = [self objectForOneOfKeys:aArray];
   
   if ( nil == stObject ) {
      
      return nil;
      
   } /* End if () */
   
   return [stObject toNumber];
}

- (NSString *)stringForOneOfKeys:(NSArray *)aArray {
   
   NSObject *stObject   = [self objectForOneOfKeys:aArray];
   
   if ( nil == stObject ) {
      
      return nil;
      
   } /* End if () */
   
   return [stObject toString];
}

- (id)objectAtPath:(NSString *)aPath {
   
   return [self objectAtPath:aPath separator:nil];
}

- (id)objectAtPath:(NSString *)aPath separator:(NSString *)aSeparator {
   
   if ( nil == aSeparator ) {
      
      aPath = [aPath stringByReplacingOccurrencesOfString:@"." withString:@"/"];
      aSeparator = @"/";
      
   } /* End if () */
   
   NSArray * stArray = [aPath componentsSeparatedByString:aSeparator];
   if ( 0 == [stArray count] ) {
      
      return nil;
      
   } /* End if () */
   
   NSObject       *stResult   = nil;
   NSDictionary   *stDict     = self;
   
   for ( NSString * szSubPath in stArray ) {
      
      if ( 0 == [szSubPath length] ) {
         
         continue;
         
      } /* End if () */
      
      stResult = [stDict objectForKey:szSubPath];
      if ( nil == stResult ) {
         
         return nil;
         
      } /* End if () */
      
      if ( [stArray lastObject] == szSubPath ) {
         
         return stResult;
         
      } /* End if () */
      else if ( NO == [stResult isKindOfClass:[NSDictionary class]] ) {
         
         return nil;
         
      } /* End else if () */
      
      stDict = (NSDictionary *)stResult;
      
   } /* End for ( NSString * szSubPath in stArray ) */
   
   return (stResult == [NSNull null]) ? nil : stResult;
}

- (id)objectAtPath:(NSString *)aPath otherwise:(NSObject *)aOther {
   
   NSObject *stObject   = [self objectAtPath:aPath];
   
   return stObject ? stObject : aOther;
}

- (id)objectAtPath:(NSString *)aPath otherwise:(NSObject *)aOther separator:(NSString *)aSeparator {
   
   NSObject *stObject   = [self objectAtPath:aPath separator:aSeparator];
   
   return stObject ? stObject : aOther;
}

- (id)objectAtPath:(NSString *)aPath withClass:(Class)aClazz {
   
   return [self objectAtPath:aPath withClass:aClazz otherwise:nil];
}

- (id)objectAtPath:(NSString *)path withClass:(Class)clazz otherwise:(NSObject *)other {
   
   NSObject * obj = [self objectAtPath:path];
   
   if ( obj && [obj isKindOfClass:[NSDictionary class]] ) {
      
      obj = [clazz unserialize:obj];
   }
   
   return obj ? obj : other;
}

- (BOOL)boolAtPath:(NSString *)path {
   
   return [self boolAtPath:path otherwise:NO];
}

- (BOOL)boolAtPath:(NSString *)path otherwise:(BOOL)other {
   
   NSObject * obj = [self objectAtPath:path];
   
   if ( [obj isKindOfClass:[NSNull class]] ) {
      
      return NO;
   }
   else if ( [obj isKindOfClass:[NSNumber class]] ) {
      
      return [(NSNumber *)obj intValue] ? YES : NO;
   }
   else if ( [obj isKindOfClass:[NSString class]] ) {
      
      if ( [(NSString *)obj hasPrefix:@"y"] || [(NSString *)obj hasPrefix:@"Y"] ||
          [(NSString *)obj hasPrefix:@"T"] || [(NSString *)obj hasPrefix:@"t"] ||
          [(NSString *)obj isEqualToString:@"1"] ) {
         
         return YES;
      }
      else {
         
         return NO;
      }
   }
   
   return other;
}

- (NSNumber *)numberAtPath:(NSString *)path {
   
   NSObject * obj = [self objectAtPath:path];
   
   if ( [obj isKindOfClass:[NSNull class]] ) {
      
      return nil;
   }
   else if ( [obj isKindOfClass:[NSNumber class]] ) {
      
      return (NSNumber *)obj;
   }
   else if ( [obj isKindOfClass:[NSString class]] ) {
      
      return [NSNumber numberWithDouble:[(NSString *)obj doubleValue]];
   }
   
   return nil;
}

- (NSNumber *)numberAtPath:(NSString *)path otherwise:(NSNumber *)other {
   
   NSNumber * obj = [self numberAtPath:path];
   
   return obj ? obj : other;
}

- (NSString *)stringAtPath:(NSString *)path {
   
   NSObject * obj = [self objectAtPath:path];
   
   if ( [obj isKindOfClass:[NSNull class]] ) {
      
      return nil;
   }
   else if ( [obj isKindOfClass:[NSNumber class]] ) {
      
      return [NSString stringWithFormat:@"%d", [(NSNumber *)obj intValue]];
   }
   else if ( [obj isKindOfClass:[NSString class]] ) {
      
      return (NSString *)obj;
   }
   
   return nil;
}

- (NSString *)stringAtPath:(NSString *)path otherwise:(NSString *)other {
   
   NSString * obj = [self stringAtPath:path];
   
   return obj ? obj : other;
}

- (NSArray *)arrayAtPath:(NSString *)path {
   
   NSObject * obj = [self objectAtPath:path];
   
   return [obj isKindOfClass:[NSArray class]] ? (NSArray *)obj : nil;
}

- (NSArray *)arrayAtPath:(NSString *)path otherwise:(NSArray *)other {
   
   NSArray * obj = [self arrayAtPath:path];
   
   return obj ? obj : other;
}

- (NSArray *)arrayAtPath:(NSString *)path withClass:(Class)clazz {
   
   return [self arrayAtPath:path withClass:clazz otherwise:nil];
}

- (NSArray *)arrayAtPath:(NSString *)path withClass:(Class)clazz otherwise:(NSArray *)other {
   
   NSArray * array = [self arrayAtPath:path otherwise:nil];
   
   if ( array ) {
      
      NSMutableArray * results = [NSMutableArray array];
      
      for ( NSObject * obj in array ) {
         
         if ( [obj isKindOfClass:[NSDictionary class]] ) {
            
            [results addObject:[clazz unserialize:obj]];
         }
      }
      
      return results;
   }
   
   return other;
}

- (NSMutableArray *)mutableArrayAtPath:(NSString *)path {
   
   NSObject * obj = [self objectAtPath:path];
   
   return [obj isKindOfClass:[NSMutableArray class]] ? (NSMutableArray *)obj : nil;
}

- (NSMutableArray *)mutableArrayAtPath:(NSString *)path otherwise:(NSMutableArray *)other {
   
   NSMutableArray * obj = [self mutableArrayAtPath:path];
   
   return obj ? obj : other;
}

- (NSDictionary *)dictAtPath:(NSString *)path {
   
   NSObject * obj = [self objectAtPath:path];
   
   return [obj isKindOfClass:[NSDictionary class]] ? (NSDictionary *)obj : nil;
}

- (NSDictionary *)dictAtPath:(NSString *)path otherwise:(NSDictionary *)other {
   
   NSDictionary * obj = [self dictAtPath:path];
   
   return obj ? obj : other;
}

- (NSMutableDictionary *)mutableDictAtPath:(NSString *)path {
   
   NSObject * obj = [self objectAtPath:path];
   
   return [obj isKindOfClass:[NSMutableDictionary class]] ? (NSMutableDictionary *)obj : nil;
}

- (NSMutableDictionary *)mutableDictAtPath:(NSString *)path otherwise:(NSMutableDictionary *)other {
   
   NSMutableDictionary * obj = [self mutableDictAtPath:path];
   
   return obj ? obj : other;
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( Core, NSDictionary_Extension ) {
   
   NSDictionary * _testDict;
}

DESCRIBE( before ) {
   
   _testDict = @{ @"k1": @"v1", @"k2": @"v2", @"k3": @3, @"k4": @{ @"a": @4 } };
}

DESCRIBE( objectAtPath ) {
   
   id value1 = [_testDict objectForOneOfKeys:@[@"k1", @"k2"]];
   id value2 = [_testDict objectForOneOfKeys:@[@"k2"]];
   
   EXPECTED( [value1 isEqualToString:@"v1"] );
   EXPECTED( [value2 isEqualToString:@"v2"] );
   
   id value3 = [_testDict numberForOneOfKeys:@[@"k3"]];
   
   EXPECTED( [value3 isEqualToNumber:@3] );
   
   id value4 = [_testDict stringForOneOfKeys:@[@"k1"]];
   
   EXPECTED( [value4 isEqualToString:@"v1"] );
   
   id obj1 = [_testDict objectAtPath:@"k4.a"];
   
   EXPECTED( [obj1 isEqualToNumber:@4] );
   
   id obj2 = [_testDict objectAtPath:@"k4.b"];
   
   EXPECTED( nil == obj2 );
   
   obj2 = [_testDict objectAtPath:@"k4.b" otherwise:@"b"];
   
   EXPECTED( obj2 && [obj2 isEqualToString:@"b"] );
   
   id obj3 = [_testDict objectAtPath:@"k4"];
   
   EXPECTED( obj3 && [obj3 isKindOfClass:[NSDictionary class]] );
}

DESCRIBE( after ) {
   
   _testDict = nil;
}

TEST_CASE_END

#endif   // #if __SAMURAI_TESTING__

#import "__pragma_pop.h"
