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

#import "IDEAAppletApp.h"
#import "IDEAAppletClassLoader.h"
#import "IDEAAppletService.h"
#import "IDEAAppletVendor.h"

#import "IDEAAppletActivity.h"
#import "IDEAAppletActivityRouter.h"
#import "IDEAAppletActivityStack.h"
#import "IDEAAppletActivityStackGroup.h"

#import "__pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

static __strong id __applicationInstance = nil;

#pragma mark -

@implementation IDEAAppletApp

@def_notification( PushEnabled );
@def_notification( PushError   );

@def_notification( LocalNotification  );
@def_notification( RemoteNotification );

@def_notification( EnterBackground );
@def_notification( EnterForeground );

@def_notification( Ready );

@def_prop_strong( UIWindow *, window);
@def_prop_strong( NSString *, pushToken);
@def_prop_strong( NSError  *, pushError);
@def_prop_strong( NSString *, sourceUrl);
@def_prop_strong( NSString *, sourceBundleId);

@def_prop_dynamic(BOOL,    active);
@def_prop_dynamic(BOOL,    inactive);
@def_prop_dynamic(BOOL,    background);

#pragma mark -

+ (instancetype)sharedInstance {
   
   return __applicationInstance;
}

- (instancetype)sharedInstance {
   
   return __applicationInstance;
}

#pragma mark -

- (id)init {
   
   int                            nErr                                     = EFAULT;
   
   __TRY;
   
   self = [super init];
   
   if (self) {
      
      [self load];
      
   } /* End if () */
   
   __CATCH(nErr);
   
   return self;
}

- (void)dealloc {
   
   [self unload];
   
   self.window          = nil;
   self.sourceUrl       = nil;
   self.sourceBundleId  = nil;
   self.pushToken       = nil;
   
   __applicationInstance= nil;
   
   __SUPER_DEALLOC;
   
   return;
}

#pragma mark -

- (void)load {
   
   int                            nErr                                     = EFAULT;
   
   __TRY;
   
   __CATCH(nErr);
   
   return;
}

- (void)unload {
   
   int                            nErr                                     = EFAULT;
   
   __TRY;
   
   __CATCH(nErr);
   
   return;
}

- (void)main {
   
   int                            nErr                                     = EFAULT;
   
   __TRY;
   
   __CATCH(nErr);
   
   return;
}

#pragma mark -

- (BOOL)active {
   
   return (UIApplicationStateActive == [UIApplication sharedApplication].applicationState) ? YES : NO;
}

- (BOOL)inactive {
   
   return (UIApplicationStateInactive == [UIApplication sharedApplication].applicationState) ? YES : NO;
}

- (BOOL)background {
   
   return (UIApplicationStateBackground == [UIApplication sharedApplication].applicationState) ? YES : NO;
}

#pragma mark -

- (IDEAAppletActivity *)activityFromString:(NSString *)aString {
   
   int                            nErr                                     = EFAULT;
   
   IDEAAppletActivity               *stActivity                               = nil;
   
   __TRY;
   
   aString = [aString trim];
   
   INFO(@"Application '%p', create activity '%@'", self, aString);
   
   stActivity = [[IDEAAppletActivityRouter sharedInstance] activityForURL:aString];
   
   if (nil == stActivity) {
      
      Class stRuntimeClass = NSClassFromString(aString);
      
      if (stRuntimeClass && [stRuntimeClass isSubclassOfClass:[IDEAAppletActivity class]]) {
         
         stActivity = (IDEAAppletActivity *)[[stRuntimeClass alloc] init];
         
      } /* End if () */
      
   } /* End if () */
   
   __CATCH(nErr);
   
   return stActivity;
}

- (IDEAAppletActivityStack *)activityStackFromArray:(NSArray *)aArray {
   
   int                            nErr                                     = EFAULT;
   
   IDEAAppletActivityStack       *stStack                                  = nil;
   
   __TRY;
   
   INFO(@"Application '%p', create stack", self, [[self class] description]);
   
   stStack  = [IDEAAppletActivityStack stack];
   
   for (NSString * name in aArray) {
      
      IDEAAppletActivity   *stActivity = [self activityFromString:name];
      if (stActivity) {
         
         [stStack pushActivity:stActivity animated:NO];
         
      } /* End if () */
      
   } /* End for () */
   
   __CATCH(nErr);
   
   return stStack;
}

- (IDEAAppletActivityStackGroup *)activityStackGroupFromDictionary:(NSDictionary *)aDictionary {
   
   int                            nErr                                     = EFAULT;
   
   IDEAAppletActivityStackGroup  *stStackGroup                             = nil;
   
   __TRY;
   
   INFO(@"Application '%p', create stack-group", self, [[self class] description]);
   
   stStackGroup   = [IDEAAppletActivityStackGroup stackGroup];
   
   for (NSString *szKey in aDictionary.allKeys) {
      
      NSObject *stValue = [aDictionary objectForKey:szKey];
      if (nil == stValue) {
         
         continue;
         
      } /* End if () */
      
      INFO(@"Application '%p', create stackGroup item '%@'", self, [[self class] description], szKey);
      
      if ([stValue isKindOfClass:[NSString class]]) {
         
         IDEAAppletActivity   *stActivity = [self activityFromString:(NSString *)stValue];
         
         if (stActivity) {
            
            [stStackGroup map:(NSString *)szKey forActivity:stActivity];
            
         }  /* End if () */
         
      }  /* End if () */
      else if ([stValue isKindOfClass:[NSArray class]]) {
         
         IDEAAppletActivityStack * activityStack = [self activityStackFromArray:(NSArray *)stValue];
         if (activityStack) {
            
            [stStackGroup map:(NSString *)szKey forActivityStack:activityStack];
            
         }  /* End if () */
         
      }  /* End else if () */
      
   } /* End for () */
   
   __CATCH(nErr);
   
   return stStackGroup;
}

#pragma mark -

- (void)loadWindow {
   
   int                            nErr                                     = EFAULT;
   
   __TRY;
   
   if (nil == self.window) {
      
      self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
      self.window.alpha = 1.0f;
      self.window.backgroundColor   = [UIColor whiteColor];
      
   } /* End if () */
   
   NSString *szFileName       = [NSString stringWithFormat:@"%@.manifest", [[self class] description]];
   
   NSString *szFileExt        = @"json";
   
   NSString *szManifestPath   = [[NSBundle mainBundle] pathForResource:szFileName ofType:szFileExt];
   NSString *szManifestData   = [NSString stringWithContentsOfFile:szManifestPath encoding:NSUTF8StringEncoding error:NULL];
   
   if (nil == szManifestData) {
      
      szFileName     = @"app.manifest";
      szFileExt      = @"json";
      
      szManifestPath = [[NSBundle mainBundle] pathForResource:szFileName ofType:szFileExt];
      szManifestData = [NSString stringWithContentsOfFile:szManifestPath encoding:NSUTF8StringEncoding error:NULL];
      
   } /* End if () */
   
   if (szManifestData) {
      
      NSDictionary      *stManifest          = [szManifestData JSONDecoded];
      
      if (stManifest) {
         
         NSDictionary   *stApplicationRoutes = [stManifest objectAtPath:@"application.routes"];
         NSObject       *stApplicationMain   = [stManifest objectAtPath:@"application.main"];
         
         if (stApplicationRoutes) {
            
            for (NSString *szKey in stApplicationRoutes.allKeys) {
               
               Class  stClassType   = NSClassFromString([stApplicationRoutes objectForKey:szKey]);
               
               if (stClassType) {
                  
                  [[IDEAAppletActivityRouter sharedInstance] mapURL:szKey toActivityClass:stClassType];
                  
               } /* End if () */
               
            } /* End for () */
            
         } /* End if () */
         
         if (stApplicationMain) {
            
            if ([stApplicationMain isKindOfClass:[NSString class]]) {
               
               self.window.rootViewController   = [self activityFromString:(NSString *)stApplicationMain];
               
            } /* End if () */
            else if ([stApplicationMain isKindOfClass:[NSArray class]]) {
               
               self.window.rootViewController   = [self activityStackFromArray:(NSArray *)stApplicationMain];
               
            } /* End else if () */
            else if ([stApplicationMain isKindOfClass:[NSDictionary class]]) {
               
               self.window.rootViewController   = [self activityStackGroupFromDictionary:(NSDictionary *)stApplicationMain];
               
            } /* End else if () */
            
         } /* End if () */
         else {
            
            self.window.rootViewController = [IDEAAppletActivityStack stackWithActivity:[self activityFromString:@"/"]];
            
         } /* End else () */
         
      } /* End if () */
      
   } /* End if () */
   
   if (self.window.rootViewController) {
      
      UNUSED(self.window.rootViewController.view);
      
   } /* End if () */
   
   [self.window makeKeyAndVisible];
   
   __CATCH(nErr);
   
   return;
}

#pragma mark -

- (void)applicationDidFinishLaunching:(UIApplication *)application {
   
   [self application:application didFinishLaunchingWithOptions:nil];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
   
   int                            nErr                                     = EFAULT;
   
   UILocalNotification           *stLocalNotification                      = nil;
   NSDictionary                  *stRemoteNotification                     = nil;
   
   __TRY;
   
   __applicationInstance = self;
   
   UNUSED(application);
   
   [self loadWindow];
   
   [self main];
   
   if (nil != launchOptions) { // 从通知启动
      
      self.sourceUrl       = [launchOptions objectForKey:UIApplicationLaunchOptionsURLKey];
      self.sourceBundleId  = [launchOptions objectForKey:UIApplicationLaunchOptionsSourceApplicationKey];
      
      stLocalNotification  = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
      stRemoteNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
      
   } /* End if () */
   
   [self notify:IDEAAppletApp.Ready];
   
   if (stLocalNotification) {
      
      [self notify:IDEAAppletApp.LocalNotification withObject:stLocalNotification.userInfo];
      
   } /* End if () */
   
   if (stRemoteNotification) {
      
      [self notify:IDEAAppletApp.RemoteNotification withObject:stRemoteNotification];
      
   } /* End if () */
   
   __CATCH(nErr);
   
   return YES;
}

// Will be deprecated at some point, please replace with application:openURL:sourceApplication:annotation:
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
   
   return [self application:application openURL:url sourceApplication:nil annotation:nil];
}

// no equiv. notification. return NO if the application can't open for some reason
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
   
   return [self application:application openURL:url options:nil];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary *)options {
   
   self.sourceUrl = url.absoluteString;
   //   self.sourceBundleId = sourceApplication;
   
   [self notify:IDEAAppletApp.Ready];
   
   return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
   
   int                            nErr                                     = EFAULT;
   
   __TRY;
   
   UNUSED(application);
   
   //   [self.window.rootViewController viewWillAppear:NO];
   //   [self.window.rootViewController viewDidAppear:NO];
   
   __CATCH(nErr);
   
   return;
}

- (void)applicationWillResignActive:(UIApplication *)application {
   
   int                            nErr                                     = EFAULT;
   
   __TRY;
   
   UNUSED(application);
   
   //   [self.window.rootViewController viewWillDisappear:NO];
   //   [self.window.rootViewController viewDidDisappear:NO];
   
   __CATCH(nErr);
   
   return;
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
   
   int                            nErr                                     = EFAULT;
   
   __TRY;
   
   UNUSED(application);
   
   __CATCH(nErr);
   
   return;
}

- (void)applicationWillTerminate:(UIApplication *)application {
   
   int                            nErr                                     = EFAULT;
   
   __TRY;
   
   UNUSED(application);
   
   __CATCH(nErr);
   
   return;
}

#pragma mark -

- (void)application:(UIApplication *)application willChangeStatusBarOrientation:(UIInterfaceOrientation)newStatusBarOrientation duration:(NSTimeInterval)duration {
   
   int                            nErr                                     = EFAULT;
   
   __TRY;
   
   UNUSED(application);
   
   __CATCH(nErr);
   
   return;
}

- (void)application:(UIApplication *)application didChangeStatusBarOrientation:(UIInterfaceOrientation)oldStatusBarOrientation {
   
   int                            nErr                                     = EFAULT;
   
   __TRY;
   
   UNUSED(application);
   
   __CATCH(nErr);
   
   return;
}

- (void)application:(UIApplication *)application willChangeStatusBarFrame:(CGRect)newStatusBarFrame {
   
   int                            nErr                                     = EFAULT;
   
   __TRY;
   
   UNUSED(application);
   
   __CATCH(nErr);
   
   return;
}

- (void)application:(UIApplication *)application didChangeStatusBarFrame:(CGRect)oldStatusBarFrame {
   
   int                            nErr                                     = EFAULT;
   
   __TRY;
   
   UNUSED(application);
   
   __CATCH(nErr);
   
   return;
}

#pragma mark -

// one of these will be called after calling -registerForRemoteNotifications
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)aDeviceToken {
   
   int                            nErr                                     = EFAULT;
   
   NSString                      *szToken                                  = [aDeviceToken description];
   
   __TRY;
   
   UNUSED(application)
   
   szToken = [aDeviceToken description];
   szToken = [szToken stringByReplacingOccurrencesOfString:@"<" withString:@""];
   szToken = [szToken stringByReplacingOccurrencesOfString:@">" withString:@""];
   szToken = [szToken stringByReplacingOccurrencesOfString:@" " withString:@""];
   
   self.pushToken = szToken;
   
   [self notify:IDEAAppletApp.PushEnabled];
   
   __CATCH(nErr);
   
   return;
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)aError {
   
   int                            nErr                                     = EFAULT;
   
   __TRY;
   
   UNUSED(application)
   
   self.pushError = aError;
   
   [self notify:IDEAAppletApp.PushError];
   
   __CATCH(nErr);
   
   return;
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
   
   int                            nErr                                     = EFAULT;
   
   __TRY;
   
   UNUSED(application)
   
   [self notify:IDEAAppletApp.RemoteNotification withObject:userInfo];
   
   __CATCH(nErr);
   
   return;
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
   
   int                            nErr                                     = EFAULT;
   
   __TRY;
   
   UNUSED(application)
   
   [self notify:IDEAAppletApp.RemoteNotification withObject:notification.userInfo];
   
   __CATCH(nErr);
   
   return;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
   
   int                            nErr                                     = EFAULT;
   
   __TRY;
   
   UNUSED(application)
   
   [self notify:IDEAAppletApp.EnterBackground];
   
   __CATCH(nErr);
   
   return;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
   
   int                            nErr                                     = EFAULT;
   
   __TRY;
   UNUSED(application)
   
   [self notify:IDEAAppletApp.EnterForeground];
   
   __CATCH(nErr);
   
   return;
}

- (void)applicationProtectedDataWillBecomeUnavailable:(UIApplication *)application {
   
   int                            nErr                                     = EFAULT;
   
   __TRY;
   
   UNUSED(application);
   
   __CATCH(nErr);
   
   return;
}

- (void)applicationProtectedDataDidBecomeAvailable:(UIApplication *)application {
   
   int                            nErr                                     = EFAULT;
   
   __TRY;
   
   UNUSED(application);
   
   __CATCH(nErr);
   
   return;
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#endif   // #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "__pragma_pop.h"
