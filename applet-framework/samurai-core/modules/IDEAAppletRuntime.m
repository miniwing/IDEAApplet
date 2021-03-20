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

+ (NSArray *)loadedClassNames
{
   static dispatch_once_t   stOnceToken;
   static NSMutableArray   *stClassNames;
   
   dispatch_once(&stOnceToken, ^
                 {
      stClassNames = [[NSMutableArray alloc] init];
      
      unsigned int    unClassesCount   = 0;
      Class          *stClasses        = objc_copyClassList(&unClassesCount);
      
      for (unsigned int H = 0; H < unClassesCount; ++H)
      {
         Class  stClassType   = stClasses[H];
         
         if (class_isMetaClass(stClassType))
         {
            continue;
            
         } /* End if () */
         
         Class  stSuperClass  = class_getSuperclass(stClassType);
         
         if (nil == stSuperClass)
         {
            continue;
            
         } /* End if () */
         
         [stClassNames addObject:[NSString stringWithUTF8String:class_getName(stClassType)]];
         
      } /* End for () */
      
      [stClassNames sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
         return [obj1 compare:obj2];
      }];
      
      FREE_IF(stClasses);
   });
   
   return stClassNames;
}

+ (NSArray *)subClasses
{
   int                            nErr                                     = EFAULT;
 
   NSMutableArray                *stResults                                = [NSMutableArray array];

   __TRY;

   for (NSString *szClassName in [self loadedClassNames])
   {
      Class classType = NSClassFromString(szClassName);
      
      if (classType == self)
      {
         continue;
         
      } /* End if () */
      
      if (NO == [classType isSubclassOfClass:self])
      {
         continue;
         
      } /* End if () */
      
      [stResults addObject:[classType description]];
      
   } /* End for () */
   
   __CATCH(nErr);
   
   return stResults;
}

+ (NSArray *)methods
{
   return [self methodsUntilClass:[self superclass]];
}

+ (NSArray *)methodsUntilClass:(Class)aBaseClass
{
   int                            nErr                                     = EFAULT;
 
   NSMutableArray                *stMethodNames                            = [NSMutableArray array];

   Class                          stThisClass                              = self;

   __TRY;

   aBaseClass  = aBaseClass ?: [NSObject class];
   
   while (NULL != stThisClass)
   {
      unsigned int    unMethodCount = 0;
      Method         *stMethodList  = class_copyMethodList(stThisClass, &unMethodCount);
      
      for (unsigned int H = 0; H < unMethodCount; ++H)
      {
         SEL selector = method_getName(stMethodList[H]);
         if (selector)
         {
            const char *cstrName = sel_getName(selector);
            if (NULL == cstrName)
            {
               continue;
               
            } /* End if () */
            
            NSString    *szSelectorName   = [NSString stringWithUTF8String:cstrName];
            if (NULL == szSelectorName)
            {
               continue;
               
            } /* End if () */
            
            [stMethodNames addObject:szSelectorName];
            
         } /* End if () */
         
      } /* End for () */
      
      FREE_IF(stMethodList);
      
      stThisClass = class_getSuperclass(stThisClass);
      
      if (nil == stThisClass || aBaseClass == stThisClass)
      {
         break;
         
      } /* End if () */
      
   } /* End while () */
   
   __CATCH(nErr);

   return stMethodNames;
}

+ (NSArray *)methodsWithPrefix:(NSString *)prefix
{
   return [self methodsWithPrefix:prefix untilClass:[self superclass]];
}

+ (NSArray *)methodsWithPrefix:(NSString *)prefix untilClass:(Class)baseClass
{
   NSArray * methods = [self methodsUntilClass:baseClass];
   
   if (nil == methods || 0 == methods.count)
   {
      return nil;
   }
   
   if (nil == prefix)
   {
      return methods;
   }
   
   NSMutableArray * result = [[NSMutableArray alloc] init];
   
   for (NSString * selectorName in methods)
   {
      if (NO == [selectorName hasPrefix:prefix])
      {
         continue;
      }
      
      [result addObject:selectorName];
   }
   
   [result sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
      return [obj1 compare:obj2];
   }];
   
   return result;
}

+ (NSArray *)properties
{
   return [self propertiesUntilClass:[self superclass]];
}

+ (NSArray *)propertiesUntilClass:(Class)baseClass
{
   NSMutableArray * propertyNames = [[NSMutableArray alloc] init];
   
   Class thisClass = self;
   
   baseClass = baseClass ?: [NSObject class];
   
   while (NULL != thisClass)
   {
      unsigned int      propertyCount = 0;
      objc_property_t *   propertyList = class_copyPropertyList(thisClass, &propertyCount);
      
      for (unsigned int i = 0; i < propertyCount; ++i)
      {
         const char * cstrName = property_getName(propertyList[i]);
         if (NULL == cstrName)
            continue;
         
         NSString * propName = [NSString stringWithUTF8String:cstrName];
         if (NULL == propName)
            continue;
         
         [propertyNames addObject:propName];
      }
      
      FREE_IF(propertyList);
      
      thisClass = class_getSuperclass(thisClass);
      
      if (nil == thisClass || baseClass == thisClass)
      {
         break;
      }
   }
   
   return propertyNames;
}

+ (NSArray *)propertiesWithPrefix:(NSString *)prefix
{
   return [self propertiesWithPrefix:prefix untilClass:[self superclass]];
}

+ (NSArray *)propertiesWithPrefix:(NSString *)prefix untilClass:(Class)baseClass
{
   NSArray * properties = [self propertiesUntilClass:baseClass];
   
   if (nil == properties || 0 == properties.count)
   {
      return nil;
   }
   
   if (nil == prefix)
   {
      return properties;
   }
   
   NSMutableArray * result = [[NSMutableArray alloc] init];
   
   for (NSString * propName in properties)
   {
      if (NO == [propName hasPrefix:prefix])
      {
         continue;
      }
      
      [result addObject:propName];
   }
   
   [result sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
      return [obj1 compare:obj2];
   }];
   
   return result;
}

+ (NSArray *)classesWithProtocolName:(NSString *)protocolName
{
   NSMutableArray *results = [[NSMutableArray alloc] init];
   Protocol * protocol = NSProtocolFromString(protocolName);
   for (NSString *className in [self loadedClassNames])
   {
      Class classType = NSClassFromString(className);
      if (classType == self)
         continue;
      
      if (NO == [classType conformsToProtocol:protocol])
         continue;
      
      [results addObject:[classType description]];
   }
   
   return results;
}

+ (void *)replaceSelector:(SEL)sel1 withSelector:(SEL)sel2
{
   Method method = class_getInstanceMethod(self, sel1);
   
   IMP implement = (IMP)method_getImplementation(method);
   IMP implement2 = class_getMethodImplementation(self, sel2);
   
   method_setImplementation(method, implement2);
   
   return (void *)implement;
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE(Core, Runtime)

DESCRIBE(before)
{
}

DESCRIBE(after)
{
}

TEST_CASE_END

#endif // #if __SAMURAI_TESTING__

#import "__pragma_pop.h"
