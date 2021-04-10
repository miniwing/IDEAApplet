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

#import "IDEAAppletWatcher.h"

#import "__pragma_push.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation IDEAAppletWatcher

@def_prop_strong  ( NSMutableArray  *,    sourceFiles );
@def_prop_strong  ( NSString        *,    sourcePath  );

@def_notification ( SourceFileDidChanged );
@def_notification ( SourceFileDidRemoved );

@def_singleton    ( IDEAAppletWatcher );

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
   
   [self.sourceFiles removeAllObjects];
   self.sourceFiles = nil;
   
   __SUPER_DEALLOC;
   
   return;
}

#pragma mark -

- (void)watch:(NSString *)aPath {
   
   self.sourcePath = [[NSString stringWithFormat:@"%@/../", aPath] stringByStandardizingPath];
   
#if (TARGET_IPHONE_SIMULATOR)
   [self scanSourceFiles];
#endif // #if (TARGET_IPHONE_SIMULATOR)
   
   return;
}

#if (TARGET_IPHONE_SIMULATOR)

- (void)scanSourceFiles {
   
   int                            nErr                                     = EFAULT;
   
   __TRY;
   
   if (nil == self.sourceFiles) {
      
      self.sourceFiles  = [[NSMutableArray alloc] init];
      
   } /* End if () */
   
   [self.sourceFiles removeAllObjects];
   
   NSString *szBasePath = [[self.sourcePath stringByStandardizingPath] copy];
   if (nil == szBasePath) {
      
      return;
      
   } /* End if () */
   
   NSDirectoryEnumerator   *stEnumerator = [[NSFileManager defaultManager] enumeratorAtPath:szBasePath];
   if (stEnumerator) {
      
      for (;;) {
         
         NSString *szFilePath = [stEnumerator nextObject];
         if (nil == szFilePath) {
            
            break;
            
         } /* End if () */
         
         NSString *szFileName    = [szFilePath lastPathComponent];
         NSString *szFileExt     = [szFileName pathExtension];
         NSString *szFullPath    = [szBasePath stringByAppendingPathComponent:szFilePath];
         
         BOOL      bIsDirectory  = NO;
         BOOL      bExists       = [[NSFileManager defaultManager] fileExistsAtPath:szFullPath isDirectory:&bIsDirectory];
         
         if (bExists && NO == bIsDirectory) {
            
            BOOL isValid = NO;
            
            for (NSString *szExtension in @[ @"xml", @"html", @"htm", @"css" ]) {
               
               if (NSOrderedSame == [szFileExt compare:szExtension]) {
                  
                  isValid = YES;
                  break;
                  
               } /* End if (NSOrderedSame == [szFileExt compare:szExtension]) */
               
            } /* End for (NSString *szExtension in @[ @"xml", @"html", @"htm", @"css" ]) */
            
            if (isValid) {
               
               [self.sourceFiles addObject:szFullPath];
               
            } /* End if (isValid) */
            
         } /* End if (bExists && NO == bIsDirectory) */
         
      } /* End for (;;) */
      
   } /* End if (stEnumerator) */
   
   for (NSString *szFile in self.sourceFiles) {
      
      [self watchSourceFile:szFile];
      
   } /* End for (NSString *szFile in self.sourceFiles) */
   
   __CATCH(nErr);
   
   return;
}

- (void)watchSourceFile:(NSString *)aFilePath {
   
   int    nFileHandle   = open([aFilePath UTF8String], O_EVTONLY);
   if (nFileHandle) {
      
      unsigned long               ulMask  = DISPATCH_VNODE_DELETE | DISPATCH_VNODE_WRITE | DISPATCH_VNODE_EXTEND;
      __block dispatch_queue_t    stQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
      __block dispatch_source_t   stSource= dispatch_source_create(DISPATCH_SOURCE_TYPE_VNODE, nFileHandle, ulMask, stQueue);
      
      @weakify(self)
      
      __block id stEventHandler = ^ {
         
         @strongify(self)
         
         unsigned long ulFlags = dispatch_source_get_data(stSource);
         if (ulFlags) {
            
            dispatch_source_cancel(stSource);
            dispatch_async(dispatch_get_main_queue(), ^ {
               
               BOOL bExists = [[NSFileManager defaultManager] fileExistsAtPath:aFilePath isDirectory:NULL];
               if (bExists) {
                  
                  [IDEAAppletWatcher notify:IDEAAppletWatcher.SourceFileDidChanged withObject:aFilePath];
                  
               } /* End if (bExists) */
               else {
                  
                  [IDEAAppletWatcher notify:IDEAAppletWatcher.SourceFileDidRemoved withObject:aFilePath];
                  
               } /* End else (!bExists) */
            });
            
            [self watchSourceFile:aFilePath];
            
         } /* End if () */
      };
      
      __block id   stCancelHandler  = ^ {
         
         close(nFileHandle);
      };
      
      dispatch_source_set_event_handler(stSource, stEventHandler);
      dispatch_source_set_cancel_handler(stSource, stCancelHandler);
      dispatch_resume(stSource);
      
   } /* End if () */
   
   return;
}

#endif // #if (TARGET_IPHONE_SIMULATOR)

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#import "__pragma_pop.h"
