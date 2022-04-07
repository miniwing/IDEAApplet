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

#include <mach-o/getsect.h>
#include <mach-o/loader.h>
#include <mach-o/dyld.h>
#include <dlfcn.h>
#include <objc/runtime.h>
#include <objc/message.h>
#include <mach-o/ldsyms.h>

#import "IDEAAppletServiceLoader.h"
#import "IDEAAppletService.h"

#import "__pragma_push.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation IDEAAppletServiceLoader {
   
   NSMutableDictionary * _services;
}

@def_singleton    ( IDEAAppletServiceLoader );

@def_prop_dynamic ( NSArray *, services     );

/******************************************************************************************************************************/

- (id)init {
   
   int                            nErr                                     = EFAULT;
   
   __TRY;

   self = [super init];
   
   if (self) {
      
      _services = [[NSMutableDictionary alloc] init];
      
   } /* End if () */
   
   __CATCH(nErr);
   
   return self;
}

- (void)dealloc {
   
   [_services removeAllObjects];
   _services = nil;
   
   __SUPER_DEALLOC;
   
   return;
}

- (void)installServices {
   
   int                            nErr                                     = EFAULT;
   
   __TRY;

#if __SAMURAI_SERVICE__
   
   for (NSString *szClassName in [IDEAAppletService subClasses]) {
      
      Class stClassType = NSClassFromString(szClassName);
      if (nil == stClassType) {
         
         continue;
         
      } /* End if () */
      
//      fprintf(stderr, "  Loading service '%s'\n", [[classType description] UTF8String]);
      LogDebug((@"Loading service '%s'", [[stClassType description] UTF8String]));
      
//      if ([[stClassType description] isEqualToString:@"ServiceMonitor"]) {
//      
//         LogDebug((@"Loading service '%s'", [[stClassType description] UTF8String]));
//
//      } /* End if () */
      
      IDEAAppletService *stService = [self service:stClassType];
      if (stService) {
         
         if (NO == [stService respondsToSelector:@selector(isAutoLoad)]) {
            
            continue;
            
         } /* End if () */
         
         if (NO == [stService performSelector:@selector(isAutoLoad)]) {
            
            continue;
            
         } /* End if () */
         
//         if ([stService isAutoLoad]) {
  
         [stService install];

//         } /* End if () */
         
      } /* End if () */
      
   } /* End for () */
   
//   fprintf(stderr, "\n");
   LogDebug((@"\n"));
   
#endif /* __SAMURAI_SERVICE__ */
   
   __CATCH(nErr);
   
   return;
}

- (void)uninstallServices {
   
   for (IDEAAppletService * service in _services) {
      
      [service uninstall];
   }
   
   [_services removeAllObjects];
   
   return;
}

- (NSArray<IDEAAppletService *> *)services {
   
   return [_services allValues];
}

- (id)service:(Class)aClassType {
   
   IDEAAppletService * stService = [_services objectForKey:[aClassType description]];
   
   if (nil == stService) {
      
      stService = [[aClassType alloc] init];
      if (stService) {
         
         [_services setObject:stService forKey:[aClassType description]];
      }
      
      if ([stService conformsToProtocol:@protocol(ManagedService)]) {
         
         [stService powerOn];
      }
   }
   
   return stService;
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE(Service, Loader)

DESCRIBE(before) {
}

DESCRIBE(after) {
}

TEST_CASE_END

#endif  // #if __SAMURAI_TESTING__

#import "__pragma_pop.h"
