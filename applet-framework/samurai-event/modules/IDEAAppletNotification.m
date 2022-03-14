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

// ----------------------------------
// Private Head Files
#import "AppletCore.h"
// ----------------------------------

#import "IDEAAppletNotification.h"
#import "IDEAAppletNotificationCenter.h"

#import "__pragma_push.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation NSNotification(Extension)

@def_prop_dynamic( NSString   *, prettyName );

#pragma mark -

- (NSString *)prettyName {
   
   return [self.name stringByReplacingOccurrencesOfString:@"notification." withString:@""];
}

- (BOOL)is:(NSString *)value {
   
   return [self.name isEqualToString:value];
}

@end

#pragma mark - 

@implementation NSObject(NotificationResponder)

@def_prop_dynamic( IDEAAppletEventBlock,  onNotification );

#pragma mark -

- (IDEAAppletNotificationBlock)onNotification {
   
   @weakify(self);
   
   IDEAAppletNotificationBlock stBlock = [^ NSObject * (NSString * aName, id aNotificationBlock) {
      
      @strongify(self);
      
      if (aNotificationBlock) {
         
         [[IDEAAppletNotificationCenter sharedInstance] addObserver:self forNotification:aName];
      }
      else {
         
         [[IDEAAppletNotificationCenter sharedInstance] removeObserver:self forNotification:aName];
      }
      
      aName = [aName stringByReplacingOccurrencesOfString:@"notification." withString:@"handleNotification____"];
      aName = [aName stringByReplacingOccurrencesOfString:@"notification____" withString:@"handleNotification____"];
      aName = [aName stringByReplacingOccurrencesOfString:@"-" withString:@"____"];
      aName = [aName stringByReplacingOccurrencesOfString:@"." withString:@"____"];
      aName = [aName stringByReplacingOccurrencesOfString:@"/" withString:@"____"];
      aName = [aName stringByAppendingString:@":"];
      
      if (aNotificationBlock) {
         
         [self addBlock:[aNotificationBlock copy] forName:aName];
         
      } /* End if () */
      else {
         
         [self removeBlockForName:aName];
         
      } /* End else */
      
      return self;
   } copy];
   
   return stBlock;
}

- (void)observeNotification:(NSString *)aName {
   
   [[IDEAAppletNotificationCenter sharedInstance] addObserver:self forNotification:aName];
   
   return;
}

- (void)unobserveNotification:(NSString *)aName {
   
   [[IDEAAppletNotificationCenter sharedInstance] removeObserver:self forNotification:aName];

   return;
}

- (void)observeAllNotifications {
   
   NSArray  *stMethods  = [[self class] methodsWithPrefix:@"handleNotification____" untilClass:[NSObject class]];
   
   if (stMethods && stMethods.count) {
      
      NSMutableArray *stNames = [NSMutableArray array];
      
      for (NSString *szMethod in stMethods) {
         
         NSString *szNotificationName  = szMethod;
         
         szNotificationName = [szNotificationName stringByReplacingOccurrencesOfString:@"handleNotification" withString:@"notification"];
         szNotificationName = [szNotificationName stringByReplacingOccurrencesOfString:@"____" withString:@"."];
         
         if ([szNotificationName hasSuffix:@":"]) {
            
            szNotificationName = [szNotificationName substringToIndex:(szNotificationName.length - 1)];
            
         } /* End if () */
         
         [[IDEAAppletNotificationCenter sharedInstance] addObserver:self forNotification:szNotificationName];
         
         [stNames addObject:szNotificationName];
         
      } /* End for () */
      
      [self retainAssociatedObject:stNames forKey:"notificationNames"];
      
   } /* End if () */
   
   return;
}

- (void)unobserveAllNotifications {
   
   NSArray  *stNames = [self getAssociatedObjectForKey:"notificationNames"];
   
   if (stNames && stNames.count) {
      
      for (NSString *szName in stNames) {
         
         [[IDEAAppletNotificationCenter sharedInstance] removeObserver:self forNotification:szName];
         
      } /* End for () */
      
      [self removeAssociatedObjectForKey:"notificationNames"];
      
   } /* End if () */
   
   [[IDEAAppletNotificationCenter sharedInstance] removeObserver:self];
   
   return;
}

- (void)handleNotification:(IDEAAppletNotification *)aNotification {
   
   UNUSED(aNotification);
   
   return;
}

@end

#pragma mark -

@implementation NSObject(NotificationSender)

+ (void)notify:(NSString *)aName {
   
   [self notify:aName withObject:nil];
   
   return;
}

- (void)notify:(NSString *)aName {
   
   [self notify:aName withObject:nil];

   return;
}

+ (void)notify:(NSString *)aName withObject:(NSObject *)aObject {
   
   @autoreleasepool {

      [[IDEAAppletNotificationCenter sharedInstance] postNotification:aName object:aObject];

   }; /* @autoreleasepool */
   
   return;
}

- (void)notify:(NSString *)aName withObject:(NSObject *)aObject {
   
   [NSObject notify:aName withObject:aObject];
   
   return;
}

+ (void)postNotify:(NSString *)aName {
   
   [self postNotify:aName withObject:nil onQueue:NULL];
      
   return;
}

- (void)postNotify:(NSString *)aName {

   [self postNotify:aName withObject:nil onQueue:NULL];

   return;
}

+ (void)postNotify:(NSString *)aName completion:(void (^)(void))aCompletion {
   
   [self postNotify:aName withObject:nil onQueue:NULL completion:aCompletion];
      
   return;
}

- (void)postNotify:(NSString *)aName completion:(void (^)(void))aCompletion {
   
   [self postNotify:aName withObject:nil onQueue:NULL completion:aCompletion];
      
   return;
}

+ (void)postNotify:(NSString *)aName onQueue:(dispatch_queue_t)aQueue {
   
   [self postNotify:aName withObject:nil onQueue:aQueue];

   return;
}

- (void)postNotify:(NSString *)aName onQueue:(dispatch_queue_t)aQueue {
   
   [self postNotify:aName withObject:nil onQueue:aQueue];

   return;
}

+ (void)postNotify:(NSString *)aName onQueue:(dispatch_queue_t)aQueue completion:(void (^)(void))aCompletion {

   [self postNotify:aName withObject:nil onQueue:aQueue completion:aCompletion];

   return;
}

- (void)postNotify:(NSString *)aName onQueue:(dispatch_queue_t)aQueue completion:(void (^)(void))aCompletion {

   [self postNotify:aName withObject:nil onQueue:aQueue completion:aCompletion];

   return;
}

+ (void)postNotify:(NSString *)aName withObject:(NSObject *)aObject onQueue:(dispatch_queue_t)aQueue {
   
   if (NULL == aQueue) {
      
      aQueue   = [IDEAAppletQueue sharedInstance].concurrent;
      
   } /* End if () */
   
   dispatch_async(aQueue, ^{
      
      @autoreleasepool {

         [[IDEAAppletNotificationCenter sharedInstance] postNotification:aName object:aObject];

      }; /* @autoreleasepool */

   });

   return;
}

- (void)postNotify:(NSString *)aName withObject:(NSObject *)aObject onQueue:(dispatch_queue_t)aQueue {
   
   [NSObject postNotify:aName withObject:aObject onQueue:aQueue];

   return;
}

+ (void)postNotify:(NSString *)aName withObject:(NSObject *)aObject onQueue:(dispatch_queue_t)aQueue completion:(void (^)(void))aCompletion {

   if (NULL == aQueue) {

      aQueue   = [IDEAAppletQueue sharedInstance].concurrent;

   } /* End if () */

   dispatch_async(aQueue, ^{

      @autoreleasepool {

         [[IDEAAppletNotificationCenter sharedInstance] postNotification:aName object:aObject];

         if (aCompletion) {

            aCompletion();

         } /* End if () */

      }; /* @autoreleasepool */

   });

   return;
}

- (void)postNotify:(NSString *)aName withObject:(NSObject *)aObject onQueue:(dispatch_queue_t)aQueue completion:(void (^)(void))aCompletion {

   [NSObject postNotify:aName withObject:aObject onQueue:aQueue completion:aCompletion];

   return;
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

static NSInteger __value = 0;

@interface __TestNotification : NSObject

@notification(TEST)

@end

@implementation __TestNotification

@def_notification(TEST)

@end

TEST_CASE(Event, Notification) {
   
}

DESCRIBE(before) {
   
   [self observeAllNotifications];
   
   EXPECTED(0 == __value);
}

DESCRIBE(Send notification) {
   
   __TestNotification * obj = [[__TestNotification alloc] init];
   
   EXPECTED(0 == __value);
   
   TIMES(100) {
      
      [obj notify:__TestNotification.TEST];
   }
   
   EXPECTED(100 == __value);
   
   TIMES(100) {
      
      [obj notify:obj.TEST];
   }
   
   EXPECTED(200 == __value);
}

handleNotification(__TestNotification, TEST) {
   
   EXPECTED([notification.name isEqualToString:__TestNotification.TEST]);
   
   __value += 1;
}

DESCRIBE(Handle notification) {
   
   TIMES(100) {
      
      __block BOOL block1Executed = NO;
      __block BOOL block2Executed = NO;
      
      self.onNotification(__TestNotification.TEST, ^(IDEAAppletNotification * notification){
         UNUSED(notification);
         block1Executed = YES;
      });
      
      self.onNotification(makeNotification(__TestNotification,xxx), ^(IDEAAppletNotification * notification){
         UNUSED(notification);
         block2Executed = YES;
      });
      
      [self notify:__TestNotification.TEST];
      [self notify:makeNotification(__TestNotification,xxx)];
      
      EXPECTED(block1Executed == YES);
      EXPECTED(block2Executed == YES);
   }
}

DESCRIBE(after) {
   
   [self unobserveAllNotifications];
}

TEST_CASE_END

#endif   // #if __SAMURAI_TESTING__

#import "__pragma_pop.h"
