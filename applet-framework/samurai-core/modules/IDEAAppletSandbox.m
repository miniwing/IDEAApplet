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

#import "IDEAAppletSandbox.h"
#import "IDEAAppletUnitTest.h"

#import "__pragma_push.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation IDEAAppletSandbox

@def_prop_strong( NSString *,   appPath );
@def_prop_strong( NSString *,   docPath );
@def_prop_strong( NSString *,   libPrefPath );
@def_prop_strong( NSString *,   libCachePath );
@def_prop_strong( NSString *,   tmpPath );

@def_singleton( IDEAAppletSandbox )

+ (void)classAutoLoad {
   
   [IDEAAppletSandbox sharedInstance];
}

- (id)init {
   
   self = [super init];
   
   if ( self ) {
      
      NSString *szExecName = [[NSBundle mainBundle] infoDictionary][@"CFBundleExecutable"];
      NSString *szExecPath = [[NSHomeDirectory() stringByAppendingPathComponent:szExecName] stringByAppendingPathExtension:@"app"];
      
      NSArray  *stDocPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
      NSArray  *stLibPaths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
      NSString *szPrefPath = [[stLibPaths objectAtIndex:0] stringByAppendingFormat:@"/Preference"];
      NSString *szCachePath= [[stLibPaths objectAtIndex:0] stringByAppendingFormat:@"/Caches"];
      NSString *szTmpPath  = [[stLibPaths objectAtIndex:0] stringByAppendingFormat:@"/tmp"];
      
      self.appPath   = szExecPath;
      self.docPath   = [stDocPaths objectAtIndex:0];
      self.tmpPath   = szTmpPath;
      
      self.libPrefPath  = szPrefPath;
      self.libCachePath = szCachePath;
      
      [self touch:self.docPath];
      [self touch:self.tmpPath];
      [self touch:self.libPrefPath];
      [self touch:self.libCachePath];
      
   } /* End if () */
   
   return self;
}

- (BOOL)touch:(NSString *)aPath {
   
   if ( NO == [[NSFileManager defaultManager] fileExistsAtPath:aPath] ) {
      
      return [[NSFileManager defaultManager] createDirectoryAtPath:aPath
                                       withIntermediateDirectories:YES
                                                        attributes:nil
                                                             error:NULL];
   }
   
   return YES;
}

- (BOOL)touchFile:(NSString *)aFile {
   
   if ( NO == [[NSFileManager defaultManager] fileExistsAtPath:aFile] ) {
      
      return [[NSFileManager defaultManager] createFileAtPath:aFile
                                                     contents:[NSData data]
                                                   attributes:nil];
      
   } /* End if () */
   
   return YES;
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( Core, Sandbox ) {
   
}

DESCRIBE( paths ) {
   
   EXPECTED( nil != [[IDEAAppletSandbox sharedInstance] appPath] );
   EXPECTED( nil != [[IDEAAppletSandbox sharedInstance] docPath] );
   EXPECTED( nil != [[IDEAAppletSandbox sharedInstance] libPrefPath] );
   EXPECTED( nil != [[IDEAAppletSandbox sharedInstance] libCachePath] );
   EXPECTED( nil != [[IDEAAppletSandbox sharedInstance] tmpPath] );
}

TEST_CASE_END

#endif   // #if __SAMURAI_TESTING__

#import "__pragma_pop.h"
