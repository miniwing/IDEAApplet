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

#import "IDEAAppletClassLoader.h"

#import "__pragma_push.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation NSObject(ClassLoader)

+ (void)classAutoLoad
{
}

@end

#pragma mark -

@implementation SamuraiClassLoader

+ (instancetype)classLoader
{
   return [[SamuraiClassLoader alloc] init];
}

- (void)loadClasses:(NSArray *)classNames
{
   for ( NSString * className in classNames )
   {
      Class classType = NSClassFromString( className );
      if ( classType )
      {
         fprintf( stderr, "  Loading class '%s'\n", [[classType description] UTF8String] );
         
         NSMethodSignature * signature = [classType methodSignatureForSelector:@selector(classAutoLoad)];
         NSInvocation * invocation = [NSInvocation invocationWithMethodSignature:signature];
         
         [invocation setTarget:classType];
         [invocation setSelector:@selector(classAutoLoad)];
         [invocation invoke];
         
         //         [classType classAutoLoad];
      }
   }
   
   fprintf( stderr, "\n" );
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#import "__pragma_pop.h"
