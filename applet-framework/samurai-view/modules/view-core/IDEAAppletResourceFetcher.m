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

#import "IDEAAppletResourceFetcher.h"
#import "IDEAAppletApp.h"

#import "__pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation NSObject(ResourceFetcher)

- (void)handleResourceLoaded:(IDEAAppletResource *)aResource {
   
   int                            nErr                                     = EFAULT;
   
   __TRY;

   __CATCH(nErr);
   
   return;
}

- (void)handleResourceFailed:(IDEAAppletResource *)aResource {
   
   int                            nErr                                     = EFAULT;
   
   __TRY;

   __CATCH(nErr);
   
   return;
}

- (void)handleResourceCancelled:(IDEAAppletResource *)aResource {
   
   int                            nErr                                     = EFAULT;
   
   __TRY;

   __CATCH(nErr);
   
   return;
}

@end

#pragma mark -

@implementation IDEAAppletResourceFetcher {
   
   NSMutableArray       * _operations;
   AFURLSessionManager  * _sessionManager;
}

@def_prop_unsafe(id,   responder);

+ (IDEAAppletResourceFetcher *)resourceFetcher {
   
   return [[IDEAAppletResourceFetcher alloc] init];
}

- (id)init {
   
   int                            nErr                                     = EFAULT;
   
   __TRY;

   self = [super init];
   
   if (self) {
      
      _operations       = [NSMutableArray nonRetainingArray];
      _sessionManager   = [[AFURLSessionManager alloc] initWithSessionConfiguration:nil];
      
      self.responder = nil;
   }
   
   __CATCH(nErr);
   
   return self;
}

- (void)dealloc {
   
   [self cancel];
   
   self.responder = nil;
   
   [_sessionManager.operationQueue cancelAllOperations];
   
   [_operations removeAllObjects];
   _operations = nil;
   
   __SUPER_DEALLOC;
   
   return;
}

- (void)queue:(IDEAAppletResource *)aResource {
   
   int                            nErr                                     = EFAULT;
   
   NSURL                         *stURL                                    = nil;
   NSURLRequest                  *stRequest                                = nil;
   
   NSURLSessionDataTask          *stSessionDataTask                        = nil;
   
//   - (NSURLSessionDataTask *)dataTaskWithRequest
   
   __TRY;
   
   stURL = [NSURL URLWithString:aResource.resPath];
   if (nil == stURL) {
      
      break;
      
   } /* End if () */
   
   stRequest = [NSURLRequest requestWithURL:stURL];
   if (nil == stRequest) {
      
      break;

   } /* End if () */
   
   @weakify(self);
   
   _sessionManager   = [[AFURLSessionManager alloc] initWithSessionConfiguration:nil];
   stSessionDataTask = [_sessionManager dataTaskWithRequest:stRequest
                                             uploadProgress:nil
                                           downloadProgress:nil
                                          completionHandler:^(NSURLResponse *aResponse, id aResponseObject, NSError *aError)
                        {
      LogDebug((@"-[IDEAAppletResourceFetcher queue] : Error : %@", aError));
      
      if (nil == aError) {
         
         @strongify(self);

         //   NSString *   requestURL = nil;
         NSData   *stResponseData = aResponseObject;
         //   NSString *   responseType = nil;

         [aResource clear];

         //   resource.resType = responseType ?: resource.resType;
         //   resource.resPath = requestURL ?: resource.resPath;
         aResource.resContent = [stResponseData toString];

         BOOL succeed = [aResource parse];
         if (NO == succeed) {
            
            if (self.responder) {
               
               [self.responder handleResourceFailed:aResource];

            }  /* End if () */

         }  /* End if () */
         else {
            
            if (self.responder) {
               
               [self.responder handleResourceLoaded:aResource];

            }  /* End if () */

         } /* End else */

//         [_operations removeObject:operation];
         
      } /* End if () */
      else {
         
         @strongify(self);

         [self handleResourceFailed:aResource];

//         [_operations removeObject:operation];

      } /* End else */
   }];
   
   [stSessionDataTask resume];
      
//   //   AF_NETWORKING
//   AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//
//   [_operations addObject:operation];
//
//   [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * operation, id responseObject)
//   {
//
//      @strongify(self);
//
//      //   NSString *   requestURL = nil;
//      NSData *   responseData = operation.responseData;
//      //   NSString *   responseType = nil;
//
//      [resource clear];
//
//      //   resource.resType = responseType ?: resource.resType;
//      //   resource.resPath = requestURL ?: resource.resPath;
//      resource.resContent = [responseData toString];
//
//      BOOL succeed = [resource parse];
//      if (NO == succeed)
//      {
//         if (self.responder)
//         {
//            [self.responder handleResourceFailed:resource];
//
//         }  /* End if () */
//
//      }  /* End if () */
//      else
//      {
//         if (self.responder)
//         {
//            [self.responder handleResourceLoaded:resource];
//
//         }  /* End if () */
//
//      } /* End else */
//
//      [_operations removeObject:operation];
//
//   }
//                                    failure:^(AFHTTPRequestOperation * operation, NSError * error)
//    {
//
//      @strongify(self);
//
//      [self handleResourceFailed:resource];
//
//      [_operations removeObject:operation];
//   }];
//
//   [operation start];
   
   __CATCH(nErr);
   
   return;
}

- (void)cancel {
   
//   for (AFHTTPRequestOperation * operation in [_operations copy])
//   {
//      [operation cancel];
//
//   } /* End for () */
   
   [_operations removeAllObjects];
   
   [_sessionManager.operationQueue cancelAllOperations];
   
   return;
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE(UI, ResourceFetcher)

DESCRIBE(before)
{
}

DESCRIBE(after)
{
}

TEST_CASE_END

#endif   // #if __SAMURAI_TESTING__

#endif   // #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "__pragma_pop.h"
