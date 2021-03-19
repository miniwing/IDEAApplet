//
//     ____    _                        __     _      _____
//    / ___\  /_\     /\/\    /\ /\    /__\   /_\     \_   \
//    \ \    //_\\   /    \  / / \ \  / \//  //_\\     / /\/
//  /\_\ \  /  _  \ / /\/\ \ \ \_/ / / _  \ /  _  \ /\/ /_
//  \____/  \_/ \_/ \/    \/  \___/  \/ \_/ \_/ \_/ \____/
//
//	Copyright Samurai development team and other contributors
//
//	http://www.samurai-framework.com
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights
//	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//	copies of the Software, and to permit persons to whom the Software is
//	furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//	THE SOFTWARE.
//

#import "Samurai_DockerManager.h"
#import "Samurai_DockerView.h"
#import "Samurai_DockerWindow.h"

#import "_pragma_push.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation SamuraiService(Docker)

- (void)openDocker
{
   if ( [self conformsToProtocol:@protocol(ManagedDocker)] )
   {
      [[SamuraiDockerManager sharedInstance] openDockerForService:(SamuraiService<ManagedDocker> *)self];
   }
}

- (void)closeDocker
{
   if ( [self conformsToProtocol:@protocol(ManagedDocker)] )
   {
      [[SamuraiDockerManager sharedInstance] closeDockerForService:(SamuraiService<ManagedDocker> *)self];
   }
}

@end

#pragma mark -

@implementation SamuraiDockerManager
{
   SamuraiDockerWindow * _dockerWindow;
}

@def_singleton( SamuraiDockerManager )

- (id)init
{
   int                            nErr                                     = EFAULT;
   
   __TRY;
   
   self = [super init];
   if ( self )
   {
   }
   
   __CATCH(nErr);
   
   return self;
}


- (void)dealloc
{
   _dockerWindow  = nil;
   
   __SUPER_DEALLOC;
   
   return;
}


- (void)installDockers
{
   int                            nErr                                     = EFAULT;
   
   NSArray                       *stServices                               = nil;

   __TRY;

   stServices  = [SamuraiServiceLoader sharedInstance].services;
   
   for ( SamuraiService * stService in stServices )
   {
      if ( [stService conformsToProtocol:@protocol(ManagedDocker)] )
      {
         if (NO == [stService respondsToSelector:@selector(isAutoLoad)])
         {
            continue;
            
         } /* End if () */
         
         if (NO == [stService performSelector:@selector(isAutoLoad)])
         {
            continue;
            
         } /* End if () */
         
         SamuraiDockerView * stDockerView = [[SamuraiDockerView alloc] init];
         [stDockerView setImageOpened:[stService.bundle imageForResource:@"docker-open.png"]];
         [stDockerView setImageClosed:[stService.bundle imageForResource:@"docker-close.png"]];
         [stDockerView setService:(SamuraiService<ManagedDocker> *)stService];
         
         if ( nil == _dockerWindow )
         {
            _dockerWindow = [[SamuraiDockerWindow alloc] init];
            _dockerWindow.alpha  = 0.0f;
            _dockerWindow.hidden = NO;
            
         } /* End if () */
         
         [_dockerWindow addDockerView:stDockerView];
         
      } /* End if () */
      
   } /* End for () */

    if ( _dockerWindow )
    {
        [_dockerWindow relayoutAllDockerViews];
    //   [_dockerWindow setHidden:NO];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5f];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];

        _dockerWindow.alpha   = 1.0f;

        [UIView commitAnimations];
       
    } /* End if () */

   __CATCH(nErr);
   
   return;
}


- (void)uninstallDockers
{
   int                            nErr                                     = EFAULT;

   __TRY;

   _dockerWindow = nil;
   
   __CATCH(nErr);
   
   return;
}


- (void)openDockerForService:(SamuraiService<ManagedDocker> *)aService
{
   int                            nErr                                     = EFAULT;

   __TRY;

   for ( UIView * stSubview in _dockerWindow.subviews )
   {
      if ( [stSubview isKindOfClass:[SamuraiDockerView class]] )
      {
         SamuraiDockerView * stDockerView = (SamuraiDockerView *)stSubview;
         if ( stDockerView.service == aService )
         {
            [stDockerView open];
            
         } /* End if () */
         
      } /* End if () */
      
   } /* End for () */
   
   __CATCH(nErr);
   
   return;
}


- (void)closeDockerForService:(SamuraiService<ManagedDocker> *)aService
{
   int                            nErr                                     = EFAULT;

   __TRY;

   for ( UIView * stSubview in _dockerWindow.subviews )
   {
      if ( [stSubview isKindOfClass:[SamuraiDockerView class]] )
      {
         SamuraiDockerView * stDockerView = (SamuraiDockerView *)stSubview;
         if ( stDockerView.service == aService )
         {
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

TEST_CASE( Service, DockerManager )

DESCRIBE( before )
{
}

DESCRIBE( after )
{
}

TEST_CASE_END

#endif	// #if __SAMURAI_TESTING__

#import "_pragma_pop.h"
