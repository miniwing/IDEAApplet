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

#import "ServiceMonitor.h"
#import "ServiceMonitorStatusBar.h"

#import "ServiceMonitorCPUModel.h"
#import "ServiceMonitorMemoryModel.h"
#import "ServiceMonitorNetworkModel.h"
#import "ServiceMonitorFPSModel.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation ServiceMonitor {
   
   NSTimer                    *     _timer;
   ServiceMonitorCPUModel     *     _cpuModel;
   ServiceMonitorMemoryModel  *     _memModel;
   ServiceMonitorNetworkModel *     _networkModel;
   ServiceMonitorFPSModel     *     _fpsModel;
   ServiceMonitorStatusBar    *     _bar;
}

#pragma mark - ManagedService

- (BOOL)isAutoLoad {
   
   return SERVICE_MONITOR;
}

#pragma mark -

- (void)install {
   
   int                            nErr                                     = EFAULT;
   
   __TRY;

   [[NSNotificationCenter defaultCenter] addObserver:self
                                            selector:@selector(didApplicationLaunched)
                                                name:UIApplicationDidFinishLaunchingNotification
                                              object:nil];
   [[NSNotificationCenter defaultCenter] addObserver:self
                                            selector:@selector(willApplicationTerminate)
                                                name:UIApplicationWillTerminateNotification
                                              object:nil];
   
   _cpuModel      = [ServiceMonitorCPUModel     sharedInstance];
   _memModel      = [ServiceMonitorMemoryModel  sharedInstance];
   _networkModel  = [ServiceMonitorNetworkModel sharedInstance];
   _fpsModel      = [ServiceMonitorFPSModel     sharedInstance];
   
   _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f / 10.0f
                                             target:self
                                           selector:@selector(didTimeout)
                                           userInfo:nil
                                            repeats:YES];
   
   [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
   
   __CATCH(nErr);
   
   return;
}

- (void)uninstall {
   
   int                            nErr                                     = EFAULT;
   
   __TRY;

   _bar           = nil;
   _cpuModel      = nil;
   _memModel      = nil;
   _networkModel  = nil;
   _fpsModel      = nil;
   
   [_timer invalidate];
   _timer   = nil;
   
   [[NSNotificationCenter defaultCenter] removeObserver:self];

   __CATCH(nErr);
   
   return;
}

- (void)powerOn {
   
   int                            nErr                                     = EFAULT;
   
   __TRY;

   __CATCH(nErr);
   
   return;
}

- (void)powerOff {
   
   int                            nErr                                     = EFAULT;
   
   __TRY;

   __CATCH(nErr);
   
   return;
}

#pragma mark -

- (void)didApplicationLaunched {
   
   int                            nErr                                     = EFAULT;
   
   __TRY;

   _bar = [[ServiceMonitorStatusBar alloc] init];
   [_bar show];

   __CATCH(nErr);
   
   return;
}

- (void)willApplicationTerminate {
   
   int                            nErr                                     = EFAULT;
   
   __TRY;

   _bar = nil;

   __CATCH(nErr);
   
   return;
}

- (void)didTimeout {
   
   [_cpuModel     update];
   [_memModel     update];
   [_networkModel update];
   [_fpsModel     update];
   
   [_bar update];

   return;
}

@end
