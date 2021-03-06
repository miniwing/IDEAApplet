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
#import "IDEAAppletView.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#pragma mark -

@interface IDEAAppletApp : UIResponder<UIApplicationDelegate>

@notification( PushEnabled )
@notification( PushError   )

@notification( Local  )
@notification( Remote )

@notification( EnterBackground );
@notification( EnterForeground );
@notification( Ready )

@prop_strong( UIWindow  *,    window );
@prop_strong( NSString  *,    pushToken );
@prop_strong( NSError   *,    pushError );
@prop_strong( NSString  *,    sourceUrl );
@prop_strong( NSString  *,    sourceBundleId );

@prop_readonly( BOOL ,  active );
@prop_readonly( BOOL ,  inactive );
@prop_readonly( BOOL ,  background );

+ (instancetype)sharedInstance;
- (instancetype)sharedInstance;

- (void)load;
- (void)unload;

- (void)main;

- (IDEAAppletActivity *)activityFromString:(NSString *)aString;
- (IDEAAppletActivityStack *)activityStackFromArray:(NSArray *)aArray;
- (IDEAAppletActivityStackGroup *)activityStackGroupFromDictionary:(NSDictionary *)aDict;

@end

#endif   // #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
