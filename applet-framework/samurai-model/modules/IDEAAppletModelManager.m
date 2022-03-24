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

#import "IDEAAppletModelManager.h"
#import "IDEAAppletModel.h"

#import "__pragma_push.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation IDEAAppletModelManager
{
   NSMutableArray * _models;
}

@def_singleton( IDEAAppletModelManager )

+ (void)classAutoLoad {
   
   [IDEAAppletModelManager sharedInstance];
   
   for (NSString *szClassName in [IDEAAppletModel subClasses]) {
      
      Class  stClassType   = NSClassFromString(szClassName);
      
      if (nil == stClassType) {
         
         continue;
         
      } /* End if () */
      
      if ([stClassType instancesRespondToSelector:@selector(sharedInstance)]) {
         
         [stClassType sharedInstance];
         
      } /* End if () */
      
   } /* End for () */
   
   return;
}

- (id)init {
   
   self = [super init];
   
   if (self) {
      
      _models = [NSMutableArray nonRetainingArray];
      
   } /* End if () */
   
   return self;
}

- (void)dealloc {
   
   [_models removeAllObjects];
   _models = nil;
   
   __SUPER_DEALLOC;
   
   return;
}

- (NSArray *)loadedModels {
   
   NSMutableArray *stArray = [NSMutableArray nonRetainingArray];
   [stArray addObjectsFromArray:_models];
   return stArray;
}

- (NSArray *)loadedModelsByClass:(Class)clazz {
   
   if (0 == _models.count) {
      
      return nil;
      
   } /* End if () */
   
   NSMutableArray *stArray = [NSMutableArray nonRetainingArray];
   
   for (IDEAAppletModel *stModel in _models) {
      
      if ([stModel isKindOfClass:clazz]) {
         
         [stArray addObject:stModel];
         
      } /* End if () */
      
   } /* End for () */
   
   return stArray;
}

- (void)addModel:(id)model {
   
   if (NO == [_models containsObject:model]) {
      
      [_models addObject:model];
      
   } /* End if () */
   
   return;
}

- (void)removeModel:(id)model {
   
   [_models removeObject:model];
   
   return;
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE(Model, ModelManager)

DESCRIBE(before) {
}

DESCRIBE(after) {
}

TEST_CASE_END

#endif   // #if __SAMURAI_TESTING__

#import "__pragma_pop.h"
