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
      LogDebug((@"Loading service '%s'\n", [[stClassType description] UTF8String]));
      
      IDEAAppletService *stService = [self service:stClassType];
      if (stService) {
         
         if (NO == [stService respondsToSelector:@selector(isAutoLoad)]) {
            
            continue;
            
         } /* End if () */
         
         if (NO == [stService performSelector:@selector(isAutoLoad)]) {
            
            continue;
            
         } /* End if () */
         
//         if ([stService isAutoLoad])
         {
            [stService install];
            
         } /* End if () */
         
      } /* End if () */
      
   } /* End for () */
   
   fprintf(stderr, "\n");
   
#endif
   
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

- (NSArray *)services {
   
   return [_services allValues];
}

- (id)service:(Class)classType {
   
   IDEAAppletService * service = [_services objectForKey:[classType description]];
   
   if (nil == service) {
      
      service = [[classType alloc] init];
      if (service) {
         
         [_services setObject:service forKey:[classType description]];
      }
      
      if ([service conformsToProtocol:@protocol(ManagedService)]) {
         
         [service powerOn];
      }
   }
   
   return service;
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
