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
#import "IDEAAppletEvent.h"

//#import "IDEAAppletViewConfig.h"

#import "IDEAAppletViewCore.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "IDEAAppletActivity.h"

#pragma mark -

@class IDEAAppletActivityStack;

@interface UIWindow(ActivityStack)

@prop_strong( IDEAAppletActivityStack *,  rootStack );

@end

#pragma mark -

typedef void (^ IntentCallback )( IDEAAppletIntent * aIntent );

#pragma mark -

@interface UIViewController(ActivityStack)

- (IDEAAppletActivityStack *)stack;

- (void)startActivity:(IDEAAppletActivity *)aActivity;
- (void)startActivity:(IDEAAppletActivity *)aActivity params:(NSDictionary *)aParams;
- (void)startActivity:(IDEAAppletActivity *)aActivity intent:(IDEAAppletIntent *)intent;

- (void)presentActivity:(IDEAAppletActivity *)aActivity;
- (void)presentActivity:(IDEAAppletActivity *)aActivity params:(NSDictionary *)aParams;
- (void)presentActivity:(IDEAAppletActivity *)aActivity intent:(IDEAAppletIntent *)intent;

- (void)startURL:(NSString *)aURL, ...;
- (void)startURL:(NSString *)aURL params:(NSDictionary *)aParams;
- (void)startURL:(NSString *)aURL intent:(IDEAAppletIntent *)intent;
- (void)startURL:(NSString *)aURL callback:(IntentCallback)callback;

- (void)presentURL:(NSString *)aURL, ...;
- (void)presentURL:(NSString *)aURL params:(NSDictionary *)aParams;
- (void)presentURL:(NSString *)aURL intent:(IDEAAppletIntent *)intent;
- (void)presentURL:(NSString *)aURL callback:(IntentCallback)callback;

@end

#pragma mark -

@interface IDEAAppletActivityStack : UINavigationController

@prop_readonly( NSArray             *, activities );
@prop_readonly( IDEAAppletActivity  *, activity );

+ (IDEAAppletActivityStack *)stack;
+ (IDEAAppletActivityStack *)stackWithActivity:(IDEAAppletActivity *)aActivity;

- (IDEAAppletActivityStack *)initWithActivity:(IDEAAppletActivity *)aActivity;

- (void)pushActivity:(IDEAAppletActivity *)aActivity animated:(BOOL)aAnimated;
- (void)popActivityAnimated:(BOOL)aAnimated;
- (void)popToActivity:(IDEAAppletActivity *)aActivity animated:(BOOL)aAnimated;
- (void)popToFirstActivityAnimated:(BOOL)aAnimated;
- (void)popAllActivities;

@end

#endif   // #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
