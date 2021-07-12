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

#import "IDEAAppletService.h"
#import "IDEAAppletServiceLoader.h"

#import "__pragma_push.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation IDEAAppletService

@def_prop_strong( NSString *,      name );
@def_prop_strong( NSBundle *,      bundle );
@def_prop_assign( BOOL,            running );

+ (instancetype)instance {
   
   return [[IDEAAppletServiceLoader sharedInstance] service:[self class]];
}

- (id)init {
   
   int                            nErr                                     = EFAULT;

   __TRY;

   self = [super init];
   if ( self ) {
      
      self.name   = NSStringFromClass([self class]);
//      self.bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:[[self class] description] ofType:@"bundle"] ];
      self.bundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[self class]]
                                              pathForResource:[[self class] description]
                                              ofType:@"bundle"] ];
      
   } /* End if () */
   
   LogDebug((@"-[IDEAAppletService init] : Bundle : %@", self.bundle));
   
   __CATCH(nErr);
   
   return self;
}

- (void)dealloc {
   
   if ( _running ) {
      
      [self powerOff];
   }

   self.bundle = nil;
   self.name   = nil;
   
   __SUPER_DEALLOC;
   
   return;
}

- (void)install {
   
   int                            nErr                                     = EFAULT;

   __TRY;

   __CATCH(nErr);

   return;
}

- (void)uninstall {
   
   int                            nErr                                     = EFAULT;

   __TRY;

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

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( Service, ServiceInstance )

DESCRIBE( before ) {
}

DESCRIBE( after ) {
}

TEST_CASE_END

#endif  // #if __SAMURAI_TESTING__

#import "__pragma_pop.h"
