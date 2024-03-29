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

#import "IDEAAppletCore.h"

#import "IDEAAppletEventConfig.h"

#pragma mark -

#undef  notification
#define notification( name )                          \
        static_property( name##Notification )

#undef  def_notification
#define def_notification( name )                      \
        def_static_property2( name##Notification, @"notification", NSStringFromClass([self class]) )

#undef  def_notification_alias
#define def_notification_alias( name, alias )         \
        alias_static_property( name##Notification, alias )

#undef  notificationName
#define notificationName( name )                      \
        name##Notification

#undef  makeNotification
#define makeNotification( ... )                       \
        macro_string( macro_join(notification, __VA_ARGS__) )

#undef  handleNotification
#define handleNotification( ... )                     \
        - (void) macro_join( handleNotification, __VA_ARGS__):(NSNotification *)aNotification

#pragma mark -

// typedef NSObject * (^ IDEAAppletNotificationBlock )( NSString * name, id object );
// typedef NSObject * (^ IDEAAppletNotificationBlock )( NSString * name, HandlerBlockType object );
typedef NSObject * (^ IDEAAppletNotificationBlock )( NSString * name, HandlerNotificationBlockType object );

#pragma mark -

@protocol ManagedNotification <NSObject>
@end

typedef NSNotification IDEAAppletNotification;

#pragma mark -

@interface NSNotification(Extension)

@prop_readonly( NSString *,   prettyName );

- (BOOL)is:(NSString *)aName;

@end

#pragma mark -

@interface NSObject(NotificationResponder)

@prop_readonly( IDEAAppletNotificationBlock, onNotification );

- (void)observeNotification:(NSString *)aName;
- (void)unobserveNotification:(NSString *)aName;
- (void)unobserveAllNotifications;

- (void)handleNotification:(IDEAAppletNotification *)aNotification;
- (void)setOnNotification:(IDEAAppletNotificationBlock)aAppletNotificationBlock;

@end

#pragma mark -

@interface NSObject(NotificationSender)

/**
 Synchronous
 */
+ (void)notify:(NSString *)aName;
- (void)notify:(NSString *)aName;

+ (void)notify:(NSString *)aName withObject:(NSObject *)aObject;
- (void)notify:(NSString *)aName withObject:(NSObject *)aObject;

/**
 Asynchronous
 */
+ (void)postNotify:(NSString *)aName;
- (void)postNotify:(NSString *)aName;

+ (void)postNotify:(NSString *)aName completion:(void (^)(void))aCompletion;
- (void)postNotify:(NSString *)aName completion:(void (^)(void))aCompletion;

+ (void)postNotify:(NSString *)aName onQueue:(dispatch_queue_t)aQueue;
- (void)postNotify:(NSString *)aName onQueue:(dispatch_queue_t)aQueue;

+ (void)postNotify:(NSString *)aName onQueue:(dispatch_queue_t)aQueue completion:(void (^)(void))aCompletion;
- (void)postNotify:(NSString *)aName onQueue:(dispatch_queue_t)aQueue completion:(void (^)(void))aCompletion;

+ (void)postNotify:(NSString *)aName withObject:(NSObject *)aObject onQueue:(dispatch_queue_t)aQueue;
- (void)postNotify:(NSString *)aName withObject:(NSObject *)aObject onQueue:(dispatch_queue_t)aQueue;

+ (void)postNotify:(NSString *)aName withObject:(NSObject *)aObject onQueue:(dispatch_queue_t)aQueue completion:(void (^)(void))aCompletion;
- (void)postNotify:(NSString *)aName withObject:(NSObject *)aObject onQueue:(dispatch_queue_t)aQueue completion:(void (^)(void))aCompletion;

@end
