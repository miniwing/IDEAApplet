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

#import "IDEAAppletRuntime.h"
#import "IDEAAppletEncoding.h"
#import "IDEAAppletLog.h"
#import "IDEAAppletUnitTest.h"

#import "NSArray+Extension.h"
#import "NSMutableArray+Extension.h"

#import "__pragma_push.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation NSObject(Runtime)

+ (NSArray *)loadedClassNames {
   
   static dispatch_once_t   stOnceToken;
   static NSMutableArray   *stClassNames  = nil;
   
   dispatch_once(&stOnceToken, ^ {
      
      stClassNames = [NSMutableArray array];
      
      unsigned int    unClassesCount   = 0;
      Class          *stClasses        = objc_copyClassList(&unClassesCount);
      
      for (unsigned int H = 0; H < unClassesCount; ++H) {
         
         Class  stClassType   = stClasses[H];
         
         if (class_isMetaClass(stClassType)) {
            
            continue;
            
         } /* End if () */
         
         Class  stSuperClass  = class_getSuperclass(stClassType);
         
         if (nil == stSuperClass) {
            
            continue;
            
         } /* End if () */
         
         [stClassNames addObject:[NSString stringWithUTF8String:class_getName(stClassType)]];
         
      } /* End for () */
      
      [stClassNames sortUsingComparator:^NSComparisonResult(id aObject1, id aObject2) {
         return [aObject1 compare:aObject2];
      }];
      
      FREE_IF(stClasses);
   });
   
   return stClassNames;
}

+ (NSArray *)subClasses {
   
   int                            nErr                                     = EFAULT;
   
   NSMutableArray                *stResults                                = [NSMutableArray array];
   
   __TRY;
   
#if __Debug__
   NSArray<NSString *>           *stClazzes                                = @[
                                                                                 @"ServiceBorder",
                                                                                 @"ServiceConsole",
                                                                                 @"ServiceGesture",
                                                                                 @"ServiceGrids",
                                                                                 @"ServiceInspector",
                                                                                 @"ServiceMonitor",
                                                                                 @"ServiceTapspot",
                                                                                 @"ServiceTheme"
                                                                              ];
   
   for (NSString *szClazz in stClazzes) {
      
      if (NSClassFromString(szClazz)) {
         
         [stResults addObject:szClazz];
         
      } /* End if () */
      
   } /* End for () */
#else /* __Debug__ */
   for (NSString *szClassName in [self loadedClassNames]) {
      
      Class stClassType = NSClassFromString(szClassName);
      
      if (stClassType == self) {
         
         continue;
         
      } /* End if () */
      
//      if ([NSStringFromClass(stClassType) isEqualToString:@"WKNSError"]) {
//
//         continue;
//
//      } /* End if () */

      if ([NSStringFromClass(stClassType) hasPrefix:@"WKNS"]) {
         
         continue;

      } /* End if () */

      if ([stClassType isKindOfClass:[NSProxy class]]) {
         
         continue;
         
      } /* End if () */
      
      if (NO == [stClassType isSubclassOfClass:self]) {
         
         continue;
         
      } /* End if () */
   
//      Harry FIXED :
      [stResults addObject:[stClassType description]];
//      [stResults addObject:[stClassType class]];

   } /* End for () */
#endif /* !__Debug__ */
   
   LogDebug((@"+[NSObject subClasses] : %@", stResults));
   
   __CATCH(nErr);
   
   return stResults;
}

+ (NSArray *)methods {
   
   return [self methodsUntilClass:[self superclass]];
}

+ (NSArray *)methodsUntilClass:(Class)aBaseClass {
   
   int                            nErr                                     = EFAULT;
   
   NSMutableArray                *stMethodNames                            = [NSMutableArray array];
   
   Class                          stThisClass                              = self;
   
   __TRY;
   
   aBaseClass  = aBaseClass ?: [NSObject class];
   
   while (NULL != stThisClass) {
      
      unsigned int    unMethodCount = 0;
      Method         *stMethodList  = class_copyMethodList(stThisClass, &unMethodCount);
      
      for (unsigned int H = 0; H < unMethodCount; ++H) {
         
         SEL selector = method_getName(stMethodList[H]);
         if (selector) {
            
            const char *cstrName = sel_getName(selector);
            if (NULL == cstrName) {
               
               continue;
               
            } /* End if () */
            
            NSString    *szSelectorName   = [NSString stringWithUTF8String:cstrName];
            if (NULL == szSelectorName) {
               
               continue;
               
            } /* End if () */
            
            [stMethodNames addObject:szSelectorName];
            
         } /* End if () */
         
      } /* End for () */
      
      FREE_IF(stMethodList);
      
      stThisClass = class_getSuperclass(stThisClass);
      
      if (nil == stThisClass || aBaseClass == stThisClass) {
         
         break;
         
      } /* End if () */
      
   } /* End while () */
   
   __CATCH(nErr);
   
   return stMethodNames;
}

+ (NSArray *)methodsWithPrefix:(NSString *)prefix {
   
   return [self methodsWithPrefix:prefix untilClass:[self superclass]];
}

+ (NSArray *)methodsWithPrefix:(NSString *)aPrefix untilClass:(Class)baseClass {
   
   int                            nErr                                     = EFAULT;
   
   NSArray                       *stMethods                                = nil;
   NSMutableArray                *stResult                                 = nil;
   
   __TRY;
   
   stMethods = [self methodsUntilClass:baseClass];
   
   if (nil == stMethods || 0 == stMethods.count) {
      
      break;
      
   } /* End if () */
   
   if (nil == aPrefix) {
      
      nErr  = noErr;
      
      break;
      
   } /* End if () */
   
   stResult = [NSMutableArray array];
   
   for (NSString *szSelectorName in stMethods) {
      
      if (NO == [szSelectorName hasPrefix:aPrefix]) {
         
         continue;
         
      } /* End if () */
      
      [stResult addObject:szSelectorName];
      
   } /* End for () */
   
   [stResult sortUsingComparator:^NSComparisonResult(id aObject1, id aObject2) {
      return [aObject1 compare:aObject2];
   }];
   
   stMethods   = stResult;
   
   __CATCH(nErr);
   
   return stMethods;
}

+ (NSArray *)properties {
   
   return [self propertiesUntilClass:[self superclass]];
}

+ (NSArray *)propertiesUntilClass:(Class)aBaseClass {
   
   int                            nErr                                     = EFAULT;
   
   NSMutableArray                *stPropertyNames                          = [NSMutableArray array];
   Class                          stThisClass                              = self;
   
   __TRY;
   
   aBaseClass = aBaseClass ?: [NSObject class];
   
   while (NULL != stThisClass) {
      
      unsigned int       nPropertyCount   = 0;
      objc_property_t   *pstPropertyList  = class_copyPropertyList(stThisClass, &nPropertyCount);
      
      for (unsigned int i = 0; i < nPropertyCount; ++i) {
         
         const char * cstrName = property_getName(pstPropertyList[i]);
         if (NULL == cstrName) {
            
            continue;
            
         } /* End if () */
         
         NSString * propName = [NSString stringWithUTF8String:cstrName];
         if (NULL == propName) {
            
            continue;
            
         } /* End if () */
         
         [stPropertyNames addObject:propName];
         
      } /* End for () */
      
      FREE_IF(pstPropertyList);
      
      stThisClass = class_getSuperclass(stThisClass);
      
      if (nil == stThisClass || aBaseClass == stThisClass) {
         
         break;
         
      } /* End if () */
      
   } /* End while () */
   
   __CATCH(nErr);
   
   return stPropertyNames;
}

+ (NSArray *)propertiesWithPrefix:(NSString *)prefix {
   
   return [self propertiesWithPrefix:prefix untilClass:[self superclass]];
}

+ (NSArray *)propertiesWithPrefix:(NSString *)aPrefix untilClass:(Class)aBaseClass {
   
   int                            nErr                                     = EFAULT;
   
   NSArray                       *stProperties                             = nil;
   
   __TRY;
   
   stProperties   = [self propertiesUntilClass:aBaseClass];
   
   if (nil == stProperties || 0 == stProperties.count) {
      
      nErr  = noErr;
      
      break;
      
   } /* End if () */
   
   if (nil == aPrefix) {
      
      nErr  = noErr;
      
      break;
      
   } /* End if () */
   
   NSMutableArray *stResult = [NSMutableArray array];
   
   for (NSString *szPropName in stProperties) {
      
      if (NO == [szPropName hasPrefix:aPrefix]) {
         
         continue;
         
      } /* End if () */
      
      [stResult addObject:szPropName];
      
   } /* End for () */
   
   [stResult sortUsingComparator:^NSComparisonResult(id aObject1, id aObject2) {
      return [aObject1 compare:aObject2];
   }];
   
   stProperties   = stResult;
   
   __CATCH(nErr);
   
   return stProperties;
}

+ (NSArray *)classesWithProtocolName:(NSString *)aProtocolName {
   
   NSMutableArray *results = [[NSMutableArray alloc] init];
   Protocol * protocol = NSProtocolFromString(aProtocolName);
   for (NSString *szClassName in [self loadedClassNames]) {
      
      Class classType = NSClassFromString(szClassName);
      if (classType == self) {
         
         continue;
         
      } /* End if () */
      
      if (NO == [classType conformsToProtocol:protocol]) {
         
         continue;
         
      } /* End if () */
      
      [results addObject:[classType description]];
      
   } /* End for () */
   
   return results;
}

+ (void *)replaceSelector:(SEL)aSEL1 withSelector:(SEL)aSEL2 {
   
   Method    stMethod   = class_getInstanceMethod(self, aSEL1);
   
   IMP       stImplement   = (IMP)method_getImplementation(stMethod);
   IMP       stImplement2  = class_getMethodImplementation(self, aSEL2);
   
   method_setImplementation(stMethod, stImplement2);
   
   return (void *)stImplement;
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE(Core, Runtime)

DESCRIBE(before) {
   
}

DESCRIBE(after) {
   
}

TEST_CASE_END

#endif // #if __SAMURAI_TESTING__

#import "__pragma_pop.h"
