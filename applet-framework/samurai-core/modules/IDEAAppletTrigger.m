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

//#if __has_feature(objc_arc)
//
//#error "Please add compile option '-fno-objc-arc' for this file in 'Build phases'."
//
//#else

#import "IDEAAppletTrigger.h"
#import "IDEAAppletRuntime.h"
#import "IDEAAppletUnitTest.h"
#import "IDEAAppletLog.h"

#import "NSObject+Extension.h"
#import "NSArray+Extension.h"
#import "NSMutableArray+Extension.h"

#import "__pragma_push.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation NSObject(Loader)

- (void)load {
   
   return;
}

- (void)unload {
   
   return;
}

- (void)performLoad {
   
   [self performCallChainWithPrefix:@"before_load" reversed:NO];
   [self performCallChainWithSelector:@selector(load) reversed:NO];
   [self performCallChainWithPrefix:@"after_load" reversed:NO];
   
   return;
}

- (void)performUnload {
   
   [self performCallChainWithPrefix:@"before_unload" reversed:YES];
   [self performCallChainWithSelector:@selector(unload) reversed:YES];
   [self performCallChainWithPrefix:@"after_unload" reversed:YES];
   
   return;
}

@end

#pragma mark -

@implementation NSObject(Trigger)

+ (void)performSelectorWithPrefix:(NSString *)aPrefixName {
   
   unsigned int    unMethodCount = 0;
   Method         *stMethodList  = class_copyMethodList(self, &unMethodCount);
   
   if (stMethodList && unMethodCount) {
      
      for (NSUInteger H = 0; H < unMethodCount; ++H) {
         
         SEL    stSEL   = method_getName(stMethodList[H]);
         
         const char  *cpcName    = sel_getName(stSEL);
         const char  *cpcPrefix  = [aPrefixName UTF8String];
         
         if (0 == strcmp(cpcPrefix, cpcName)) {
            
            continue;
            
         } /* End if () */
         
         if (0 == strncmp(cpcName, cpcPrefix, strlen(cpcPrefix))) {
            
            ImpFuncType stIMPL = (ImpFuncType)method_getImplementation(stMethodList[H]);
            
            if (stIMPL) {
               
               stIMPL(self, stSEL, nil);
               
            } /* End if () */
            
         } /* End if () */
         
      } /* End for () */
      
   } /* End if () */
   
   FREE_IF(stMethodList);
   
   return;
}

- (void)performSelectorWithPrefix:(NSString *)aPrefixName {
   
   unsigned int    unMethodCount = 0;
   Method         *stMethodList  = class_copyMethodList([self class], &unMethodCount);
   
   if (stMethodList && unMethodCount) {
      
      for (NSUInteger i = 0; i < unMethodCount; ++i) {
         
         SEL    stSEL   = method_getName(stMethodList[i]);
         
         const char *cpcName     = sel_getName(stSEL);
         const char *cpcPrefix   = [aPrefixName UTF8String];
         
         if (0 == strcmp(cpcPrefix, cpcName)) {
            
            continue;
            
         } /* End if () */
         
         if (0 == strncmp(cpcName, cpcPrefix, strlen(cpcPrefix))) {
            
            ImpFuncType stIMPL = (ImpFuncType)method_getImplementation(stMethodList[i]);
            if (stIMPL) {
               
               stIMPL(self, stSEL, nil);
               
            } /* End if () */
            
         } /* End if () */
         
      } /* End for () */
      
   } /* End if () */
   
   FREE_IF(stMethodList);
   
   return;
}

- (id)performCallChainWithSelector:(SEL)aSEL {
   
   return [self performCallChainWithSelector:aSEL reversed:NO];
}

- (id)performCallChainWithSelector:(SEL)aSEL reversed:(BOOL)aFlag {
   
   NSMutableArray *stClassStack  = [NSMutableArray nonRetainingArray];
   
   for (Class stThisClass = [self class]; nil != stThisClass; stThisClass = class_getSuperclass(stThisClass)) {
      
      if (aFlag) {
         
         [stClassStack addObject:stThisClass];
         
      } /* End if () */
      else {
         
         [stClassStack insertObject:stThisClass atIndex:0];
         
      } /* End if () */
      
   } /* End for () */
   
   ImpFuncType  stPrevImpl    = NULL;
   
   for (Class stThisClass in stClassStack) {
      
      Method    stMethod   = class_getInstanceMethod(stThisClass, aSEL);
      if (stMethod) {
         
         ImpFuncType stIMPL = (ImpFuncType)method_getImplementation(stMethod);
         
         if (stIMPL) {
            
            if (stIMPL == stPrevImpl) {
               
               continue;
               
            } /* End if () */
            
            stIMPL(self, aSEL, nil);
            
            stPrevImpl = stIMPL;
            
         } /* End if () */
         
      } /* End if () */
      
   } /* End for () */
   
   return self;
}

- (id)performCallChainWithPrefix:(NSString *)aPrefix {
   
   return [self performCallChainWithPrefix:aPrefix reversed:YES];
}

- (id)performCallChainWithPrefix:(NSString *)aPrefixName reversed:(BOOL)aFlag {
   
   NSMutableArray *stClassStack  = [NSMutableArray nonRetainingArray];
   
   for (Class stThisClass = [self class]; nil != stThisClass; stThisClass = class_getSuperclass(stThisClass)) {
      
      if (aFlag) {
         
         [stClassStack addObject:stThisClass];
         
      } /* End if () */
      else {
         
         [stClassStack insertObject:stThisClass atIndex:0];
         
      } /* End else */
      
   } /* End for () */
   
   for (Class stThisClass in stClassStack) {
      
      unsigned int    unMethodCount = 0;
      Method         *stMethodList  = class_copyMethodList(stThisClass, &unMethodCount);
      
      if (stMethodList && unMethodCount) {
         
         for (NSUInteger H = 0; H < unMethodCount; ++H) {
            
            SEL    stSEL   = method_getName(stMethodList[H]);
            
            const char  *cpcName    = sel_getName(stSEL);
            const char  *cpcPrefix  = [aPrefixName UTF8String];
            
            if (0 == strcmp(cpcPrefix, cpcName)) {
               
               continue;
               
            } /* End if () */
            
            if (0 == strncmp(cpcName, cpcPrefix, strlen(cpcPrefix))) {
               
               ImpFuncType stIMPL = (ImpFuncType)method_getImplementation(stMethodList[H]);
               if (stIMPL) {
                  
                  stIMPL(self, stSEL, nil);
                  
               } /* End if () */
               
            } /* End if () */
            
         } /* End for () */
         
      } /* End if () */
      
      FREE_IF(stMethodList);
      
   } /* End for () */
   
   return self;
}

- (id)performCallChainWithName:(NSString *)aName {
   
   return [self performCallChainWithName:aName reversed:NO];
}

- (id)performCallChainWithName:(NSString *)aName reversed:(BOOL)aFlag {
   
   SEL    stSelector = NSSelectorFromString(aName);
   if (stSelector) {
      
      NSString *szPrefix1  = [NSString stringWithFormat:@"before_%@", aName];
      NSString *szPrefix2  = [NSString stringWithFormat:@"after_%@", aName];
      
      [self performCallChainWithPrefix:szPrefix1 reversed:aFlag];
      [self performCallChainWithSelector:stSelector reversed:aFlag];
      [self performCallChainWithPrefix:szPrefix2 reversed:aFlag];
      
   } /* End if () */
   
   return self;
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE(Core, Object) {
   
}

DESCRIBE(before) {
   
}

DESCRIBE(after) {
   
}

TEST_CASE_END

#endif   // #if __SAMURAI_TESTING__

#import "__pragma_pop.h"

//#endif
