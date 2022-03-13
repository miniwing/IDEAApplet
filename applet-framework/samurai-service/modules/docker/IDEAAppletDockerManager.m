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

#import "IDEAApplet.h"

#import "IDEAAppletDockerManager.h"
#import "IDEAAppletDockerView.h"
#import "IDEAAppletDockerWindow.h"

#import "__pragma_push.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation IDEAAppletService(Docker)

- (void)openDocker {
   
   int                            nErr                                     = EFAULT;
   
   __TRY;
   
   if ([self conformsToProtocol:@protocol(ManagedDocker)]) {
      
      [[IDEAAppletDockerManager sharedInstance] openDockerForService:(IDEAAppletService<ManagedDocker> *)self];
      
   } /* End if () */
   
   __CATCH(nErr);
   
   return;
}

- (void)closeDocker {
   
   int                            nErr                                     = EFAULT;
   
   __TRY;
   
   if ([self conformsToProtocol:@protocol(ManagedDocker)]) {
      
      [[IDEAAppletDockerManager sharedInstance] closeDockerForService:(IDEAAppletService<ManagedDocker> *)self];
      
   } /* End if () */
   
   __CATCH(nErr);
   
   return;
}

@end

#pragma mark -

@implementation IDEAAppletDockerManager {
   
   IDEAAppletDockerWindow * _dockerWindow;
}

@def_singleton ( IDEAAppletDockerManager )

- (id)init {
   
   int                            nErr                                     = EFAULT;
   
   __TRY;
   
   self = [super init];
   if (self) {
      
   } /* End if () */
   
   __CATCH(nErr);
   
   return self;
}


- (void)dealloc {
   
   __RELEASE(_dockerWindow);
   
   __SUPER_DEALLOC;
   
   return;
}


- (void)installDockers {
   
   int                            nErr                                     = EFAULT;
   
   NSArray<IDEAAppletService *>  *stServices                               = nil;
   
   __TRY;
   
   stServices  = [IDEAAppletServiceLoader sharedInstance].services;
   
   for (IDEAAppletService *stService in stServices) {
      
      LogDebug((@"-[IDEAAppletService installDockers] : Service : %@", stService.name));
      
      if ([stService conformsToProtocol:@protocol(ManagedDocker)]) {
         
         if (NO == [stService respondsToSelector:@selector(isAutoLoad)]) {
            
            continue;
            
         } /* End if () */
         
         if (NO == [stService performSelector:@selector(isAutoLoad)]) {
            
            continue;
            
         } /* End if () */
         
         IDEAAppletDockerView *stDockerView = [[IDEAAppletDockerView alloc] init];
         [stDockerView setImageOpened:[stService.bundle imageForResource:@"docker-open.png"]];
         [stDockerView setImageClosed:[stService.bundle imageForResource:@"docker-close.png"]];
         [stDockerView setService:(IDEAAppletService<ManagedDocker> *)stService];
         
         if (nil == _dockerWindow) {
            
            _dockerWindow = [[IDEAAppletDockerWindow alloc] init];
            _dockerWindow.alpha  = 0.0f;
            _dockerWindow.hidden = NO;
                        
         } /* End if () */
         
         [_dockerWindow addDockerView:stDockerView];
         
      } /* End if () */
      
   } /* End for () */
   
   if (_dockerWindow) {
      
      [_dockerWindow relayoutAllDockerViews];
      //   [_dockerWindow setHidden:NO];
      
//      [UIView beginAnimations:nil context:nil];
//      [UIView setAnimationDuration:0.5f];
//      [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
//      [UIView commitAnimations];
      
      [UIView animateWithDuration:0.25f
                       animations:^(void) {
         _dockerWindow.alpha  = 1.0f;
      }
                       completion:^(BOOL aFinished) {
         
         [[IDEAApplet sharedExtensionApplication].delegate.window makeKeyAndVisible];
         [[IDEAApplet sharedExtensionApplication].delegate.window.rootViewController setNeedsFocusUpdate];
//         [[IDEAApplet sharedExtensionApplication] setStatusBarStyle:UIStatusBarStyleDefault];
         [[IDEAApplet sharedExtensionApplication].delegate.window.rootViewController setNeedsStatusBarAppearanceUpdate];
      }];
            
   } /* End if () */
   
   __CATCH(nErr);
   
   return;
}


- (void)uninstallDockers {
   
   int                            nErr                                     = EFAULT;
   
   __TRY;
   
   _dockerWindow = nil;
   
   __CATCH(nErr);
   
   return;
}


- (void)openDockerForService:(IDEAAppletService<ManagedDocker> *)aService {
   
   int                            nErr                                     = EFAULT;
   
   __TRY;
   
   for (UIView * stSubview in _dockerWindow.subviews) {
      
      if ([stSubview isKindOfClass:[IDEAAppletDockerView class]]) {
         
         IDEAAppletDockerView * stDockerView = (IDEAAppletDockerView *)stSubview;
         if (stDockerView.service == aService) {
            
            [stDockerView open];
            
         } /* End if () */
         
      } /* End if () */
      
   } /* End for () */
   
   __CATCH(nErr);
   
   return;
}


- (void)closeDockerForService:(IDEAAppletService<ManagedDocker> *)aService {
   
   int                            nErr                                     = EFAULT;
   
   __TRY;
   
   for (UIView * stSubview in _dockerWindow.subviews) {
      
      if ([stSubview isKindOfClass:[IDEAAppletDockerView class]]) {
         
         IDEAAppletDockerView * stDockerView = (IDEAAppletDockerView *)stSubview;
         if (stDockerView.service == aService) {
            
            [stDockerView close];
            
         } /* End if () */
         
      } /* End if () */
      
   } /* End for () */
   
   __CATCH(nErr);
   
   return;
}


@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE(Service, DockerManager)

DESCRIBE(before) {
}

DESCRIBE(after) {
}

TEST_CASE_END

#endif   // #if __SAMURAI_TESTING__

#import "__pragma_pop.h"
