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

#import "IDEAAppletAssert.h"
#import "IDEAAppletLog.h"
#import "IDEAAppletUnitTest.h"

#import "NSObject+Extension.h"

#import "__pragma_push.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation IDEAAppletAsserter

@def_singleton( IDEAAppletAsserter );

@def_prop_assign( BOOL,   enabled );

+ (void)classAutoLoad {
   
   [IDEAAppletAsserter sharedInstance];
   
   return;
}

- (id)init
{
   self = [super init];
   
   if ( self ) {
      
      _enabled = YES;
      
   } /* End if () */
   
   return self;
}

- (void)toggle {
   
   _enabled = _enabled ? NO : YES;
   
   return;
}

- (void)enable {
   
   _enabled = YES;
   
   return;
}

- (void)disable {
   
   _enabled = NO;
   
   return;
}

- (void)file:(const char *)file line:(NSUInteger)line func:(const char *)func flag:(BOOL)flag expr:(const char *)expr {
   
   if ( NO == _enabled ) {
      
      return;
      
   } /* End if () */
   
   if ( NO == flag ) {
      
#if __SAMURAI_DEBUG__
      
      fprintf( stderr,
              "                        \n"
              "    %s @ %s (#%lu)      \n"
              "    {                   \n"
              "        ASSERT( %s );   \n"
              "        ^^^^^^          \n"
              "        Assertion failed\n"
              "    }                   \n"
              "                        \n", func, [[@(file) lastPathComponent] UTF8String], (unsigned long)line, expr );
      
#endif
      
      abort();
   }
}

@end

#pragma mark -

#if __cplusplus
extern "C"
#endif
void IDEAAppletAssert( const char * file, NSUInteger line, const char * func, BOOL flag, const char * expr ) {
   
   [[IDEAAppletAsserter sharedInstance] file:file line:line func:func flag:flag expr:expr];
   
   return;
}

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( Core, Asserter ) {
   
}

DESCRIBE( enable/disable ) {
   
   [[IDEAAppletAsserter sharedInstance] enable];
   EXPECTED( [[IDEAAppletAsserter sharedInstance] enabled] );

   [[IDEAAppletAsserter sharedInstance] disable];
   EXPECTED( NO == [[IDEAAppletAsserter sharedInstance] enabled] );

   [[IDEAAppletAsserter sharedInstance] toggle];
   EXPECTED( [[IDEAAppletAsserter sharedInstance] enabled] );

   [[IDEAAppletAsserter sharedInstance] toggle];
   EXPECTED( NO == [[IDEAAppletAsserter sharedInstance] enabled] );

   [[IDEAAppletAsserter sharedInstance] enable];
   EXPECTED( [[IDEAAppletAsserter sharedInstance] enabled] );

   ASSERT( YES );

   [[IDEAAppletAsserter sharedInstance] disable];
   
   ASSERT( NO );
   
   [[IDEAAppletAsserter sharedInstance] enable];
}

TEST_CASE_END

#endif   // #if __SAMURAI_TESTING__

#import "__pragma_pop.h"
