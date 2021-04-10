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

#import "IDEAAppletResource.h"
#import "IDEAAppletApp.h"
#import "IDEAAppletWatcher.h"

#import "__pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation IDEAAppletResource

@def_prop_assign  ( ResourcePolicy  , resPolicy);
@def_prop_strong  ( NSString  *, resPath);
@def_prop_strong  ( NSString  *, resType);
@def_prop_strong  ( NSString  *, resContent);

BASE_CLASS(IDEAAppletResource)

#pragma mark -

- (id)init {
   
   self = [super init];
   if (self) {
      
      self.resPolicy = ResourcePolicy_Default;
      
   } /* End if () */
   
   return self;
}

- (void)dealloc
{
   self.resPath   = nil;
   self.resType   = nil;
   self.resContent= nil;
   
   __SUPER_DEALLOC;
   
   return;
}

#pragma mark -

+ (Class)instanceClassForType:(NSString *)type {
   
   if (nil == type) {
      
      return self;
   }
   
   for (NSString * className in [IDEAAppletResource subClasses]) {
      
      Class classType = NSClassFromString(className);
      
      if (classType && [classType supportType:type]) {
         
         return classType;
      }
      
   }
   
   return nil;
}

+ (Class)instanceClassForExtension:(NSString *)extension {
   
   if (nil == extension) {
      
      return self;
   }
   
   for (NSString * className in [IDEAAppletResource subClasses]) {
      
      Class classType = NSClassFromString(className);
      
      if (classType && [classType supportExtension:extension]) {
         
         return classType;
      }
   }
   
   return nil;
}

#pragma mark -

+ (id)resource {
   
   return [[self alloc] init];
}

+ (id)resourceForType:(NSString *)type {
   
   Class resourceClass = [self instanceClassForType:type];
   
   if (nil == resourceClass) {
      return nil;
   }
   
   return [[resourceClass alloc] init];
}

+ (id)resourceForExtension:(NSString *)extension {
   
   Class resourceClass = [self instanceClassForExtension:extension];
   
   if (nil == resourceClass) {
      return nil;
   }
   
   return [[resourceClass alloc] init];
}

+ (id)resourceWithData:(NSData *)data type:(NSString *)type baseURL:(NSString *)baseURL {
   
   return [self resourceWithString:[data toString] type:type baseURL:baseURL];
}

+ (id)resourceWithString:(NSString *)string type:(NSString *)type baseURL:(NSString *)baseURL {
   
   if (nil == string || 0 == string.length) {
      return nil;
   }
   
   IDEAAppletResource * resource = [self resourceForType:type];
   if (nil == resource) {
      return nil;
   }
   
   resource.resPolicy = ResourcePolicy_Default;
   resource.resType = type;
   resource.resPath = baseURL;
   resource.resContent = string;
   
   BOOL succeed = [resource parse];
   if (NO == succeed) {
      return nil;
   }
   
   return resource;
}

+ (id)resourceWithURL:(NSString *)string {
   
   return [self resourceWithURL:string type:nil];
}

+ (id)resourceWithURL:(NSString *)string type:(NSString *)type {
   
   if (nil == string) {
      return nil;
   }
   
   IDEAAppletResource * resource = nil;
   
   if (nil == type)
   {
      NSURL * url = [NSURL URLWithString:string];
      if (nil == url) {
         return nil;
      }
      
      NSString * extension = [[url.path lastPathComponent] pathExtension];
      
      if (nil == extension || 0 == [extension length]) {
         
         resource = [self resourceForType:@"text/html"];
      }
      else {
         
         resource = [self resourceForExtension:extension];
      }
   }
   else {
      
      resource = [self resourceForType:type];
   }
   
   resource.resPolicy   = ResourcePolicy_Default;
   resource.resType     = nil;
   resource.resPath     = string;
   resource.resContent  = nil;
   
   return resource;
}

+ (id)resourceAtPath:(NSString *)aPath inBundle:(NSString *)aBundleName {
   
   if (nil == aPath) {
      
      return nil;
      
   } /* End if () */
   
   aPath = [aPath stringByStandardizingPath];
   
   NSString    *szPathComponent  = [aPath lastPathComponent];
   NSUInteger   nPathDotIndex    = [szPathComponent rangeOfString:@"."].location;
   
   if (NSNotFound == nPathDotIndex) {
      
      ERROR(@"Unknown resource type");
      
      return nil;
      
   } /* End if () */
   
   NSString    *szFileName    = [szPathComponent substringToIndex:nPathDotIndex];
   NSString    *szFileExt     = [szPathComponent substringFromIndex:(nPathDotIndex + 1)];
   NSString    *szFilePath    = nil;
   NSString    *szFileContent = nil;
   
   if (nil == szFileExt) {
      
      ERROR(@"Unknown resource type");
      
      return nil;
      
   } /* End if () */
   
   IDEAAppletResource   *stResource = [self resourceForExtension:szFileExt];
   if (nil == stResource) {
      
      ERROR(@"Unknown resource type");
      
      return nil;
      
   } /* End if () */
   
   NSError *stError = nil;
   
   do {
      
#if TARGET_IPHONE_SIMULATOR
      
      if ([IDEAAppletWatcher sharedInstance].sourcePath) {
         
         NSString *srcPath = nil;
         
         if ([aPath hasPrefix:[IDEAAppletWatcher sharedInstance].sourcePath]) {
            
            srcPath = aPath;
         }
         else {
            
            srcPath = [[[IDEAAppletWatcher sharedInstance].sourcePath stringByAppendingPathComponent:aPath] stringByStandardizingPath];
         }
         
         if (srcPath) {
            
            szFileContent = [NSString stringWithContentsOfFile:srcPath encoding:NSUTF8StringEncoding error:&stError];
            
            if (nil == szFileContent) {
               
               szFileContent = [NSString stringWithContentsOfFile:aPath encoding:NSISOLatin2StringEncoding error:&stError];
               
            } /* End if () */
            
            if (szFileContent) {
               
               szFilePath  = srcPath;
               
               break;
               
            } /* End if () */
            
         } /* End if () */
         
      } /* End if () */
      
#endif   // #if TARGET_IPHONE_SIMULATOR
      
      //      NSString       *szDocPath     = [[[NSBundle mainBundle] pathForResource:szFileName ofType:szFileExt inDirectory:[aPath stringByDeletingLastPathComponent]] stringByStandardizingPath];
      //      NSString       *szResPath     = [[[NSBundle mainBundle] pathForResource:szFileName ofType:szFileExt] stringByStandardizingPath];
      //      NSString       *szWWWPath     = [[[NSBundle mainBundle] pathForResource:szFileName ofType:szFileExt inDirectory:[[stResource class] baseDirectory]] stringByStandardizingPath];
      
      BOOL            bDir          = NO;
      NSFileManager  *stFileManager = [NSFileManager defaultManager];
      
      NSURL          *stBundleURL   = [[NSBundle bundleForClass:[self class]] URLForResource:aBundleName withExtension:@"bundle"];
      
      NSBundle       *stBundle      = nil;
      
      if (nil == stBundleURL) {
         
         stBundle = [NSBundle mainBundle];
         
      } /* End if () */
      else {
         
         stBundle = [NSBundle bundleWithURL:stBundleURL];
         
      } /* End else */
      
      NSString       *szDocPath     = [[stBundle pathForResource:szFileName ofType:szFileExt inDirectory:[aPath stringByDeletingLastPathComponent]] stringByStandardizingPath];
      NSString       *szResPath     = [[stBundle pathForResource:szFileName ofType:szFileExt] stringByStandardizingPath];
      NSString       *szWWWPath     = [[stBundle pathForResource:szFileName ofType:szFileExt inDirectory:[[stResource class] baseDirectory]] stringByStandardizingPath];
      
      if ((NO == [stFileManager fileExistsAtPath:szDocPath isDirectory:&bDir]) || (YES == bDir)) {
         
         szDocPath   = [[[NSBundle mainBundle] pathForResource:szFileName
                                                        ofType:szFileExt inDirectory:[aPath stringByDeletingLastPathComponent]] stringByStandardizingPath];
         
      } /* End if () */
      
      if (szDocPath) {
         
         szFileContent = [NSString stringWithContentsOfFile:szDocPath encoding:NSUTF8StringEncoding error:&stError];
         
         if (nil == szFileContent) {
            
            szFileContent = [NSString stringWithContentsOfFile:aPath encoding:NSISOLatin2StringEncoding error:&stError];
            
         } /* End if () */
         
         if (szFileContent) {
            
            szFilePath = szDocPath;
            
            break;
            
         } /* End if () */
         
      } /* End if () */
      
      bDir  = NO;
      if ((NO == [stFileManager fileExistsAtPath:szResPath isDirectory:&bDir]) || (YES == bDir)) {
         
         szResPath   = [[[NSBundle mainBundle] pathForResource:szFileName ofType:szFileExt] stringByStandardizingPath];
         
      } /* End if () */
      
      if (szResPath) {
         
         szFileContent = [NSString stringWithContentsOfFile:szResPath encoding:NSUTF8StringEncoding error:&stError];
         
         if (nil == szFileContent) {
            
            szFileContent = [NSString stringWithContentsOfFile:aPath encoding:NSISOLatin2StringEncoding error:&stError];
            
         } /* End if () */
         
         if (szFileContent) {
            
            szFilePath = szResPath;
            
            break;
            
         } /* End if () */
         
      } /* End if () */
      
      bDir  = NO;
      if ((NO == [stFileManager fileExistsAtPath:szWWWPath isDirectory:&bDir]) || (YES == bDir)) {
         
         szResPath   = [[[NSBundle mainBundle] pathForResource:szFileName ofType:szFileExt inDirectory:[[stResource class] baseDirectory]] stringByStandardizingPath];
         
      } /* End if () */
      
      if (szWWWPath) {
         
         szFileContent = [NSString stringWithContentsOfFile:szWWWPath encoding:NSUTF8StringEncoding error:&stError];
         
         if (nil == szFileContent) {
            
            szFileContent = [NSString stringWithContentsOfFile:aPath encoding:NSISOLatin2StringEncoding error:&stError];
            
         } /* End if () */
         
         if (szFileContent) {
            
            szFilePath = szWWWPath;
            
            break;
            
         } /* End if () */
         
      } /* End if () */
      
      if (aPath) {
         
         szFileContent = [NSString stringWithContentsOfFile:aPath encoding:NSUTF8StringEncoding error:&stError];
         
         if (nil == szFileContent) {
            
            szFileContent = [NSString stringWithContentsOfFile:aPath encoding:NSISOLatin2StringEncoding error:&stError];
            
         } /* End if () */
         
         if (szFileContent) {
            
            szFilePath = aPath;
            
            break;
            
         } /* End if () */
         
      } /* End if () */
      
   } while (0); /* End do while (0) */
   
   if (nil == szFileContent) {
      
      ERROR(@"Failed to resource\n%@", [stError description]);
      
      return nil;
      
   } /* End if () */
   
   stResource.resPolicy    = ResourcePolicy_Default;
   stResource.resContent   = szFileContent;
   stResource.resPath      = szFilePath;
   stResource.resType      = nil;
   
   return stResource;
}

+ (id)resourceForClass:(Class)aClass {
   
   if (nil == aClass) {
      
      return nil;
      
   } /* End if () */
   
   Class stBaseClass = [self baseClass];
   
   if (nil == stBaseClass) {
      
      stBaseClass = [NSObject class];
      
   } /* End if () */
   
   for (Class stThisClass = self; stThisClass != stBaseClass; ) {
      
      NSArray  *stExtensions = [self supportedExtensionsForClass:stThisClass];
      
      for (NSString *szExtension in stExtensions) {
         
         NSString          *szFileName = [NSString stringWithFormat:@"%s.%@", class_getName(stThisClass), szExtension];
         
         IDEAAppletResource   *stResource = [self resourceAtPath:szFileName inBundle:nil];
         
         if (stResource) {
            
            return stResource;
            
         } /* End if () */
         
      } /* End for () */
      
      stThisClass = class_getSuperclass(stThisClass);
      
      if (nil == stThisClass) {
         
         break;
         
      } /* End if () */
      
   } /* End for () */
   
   return nil;
}

#pragma mark -

+ (NSArray *)supportedTypesForClass:(Class)clazz {
   
   NSMutableArray * types = [NSMutableArray array];
   
   Class baseClass = [self baseClass];
   
   if (nil == baseClass) {
      
      baseClass = [NSObject class];
   }
   
   for (Class thisClass = self; thisClass != baseClass; ) {
      
      [types addObjectsFromArray:[thisClass supportedTypes]];
      
      thisClass = class_getSuperclass(thisClass);
      if (nil == thisClass) {
         break;
      }
      
   } /* End for () */
   
   return types;
}

+ (NSArray *)supportedExtensionsForClass:(Class)clazz {
   
   NSMutableArray * types = [NSMutableArray array];
   
   Class baseClass = [self baseClass];
   
   if (nil == baseClass) {
      
      baseClass = [NSObject class];
   }
   
   for (Class thisClass = self; thisClass != baseClass;) {
      
      [types addObjectsFromArray:[thisClass supportedExtensions]];
      
      thisClass = class_getSuperclass(thisClass);
      if (nil == thisClass) {
         break;
      }
   }
   
   return types;
}

+ (BOOL)supportType:(NSString *)type {
   
   if (nil == type) {
      return NO;
   }
   
   NSArray * supportedTypes = [self supportedTypes];
   
   for (NSString * supportedType in supportedTypes) {
      
      if (NSOrderedSame == [type compare:supportedType options:NSCaseInsensitiveSearch]) {
         
         return YES;
      }
   }
   
   return NO;
}

+ (BOOL)supportExtension:(NSString *)extension {
   
   if (nil == extension) {
      return NO;
   }
   
   NSArray * supportedExtensions = [self supportedExtensions];
   
   for (NSString * supportedExtension in supportedExtensions) {
      
      if (NSOrderedSame == [extension compare:supportedExtension options:NSCaseInsensitiveSearch]) {
         
         return YES;
      }
   }
   
   return NO;
}

#pragma mark -

+ (NSArray *)supportedTypes {
   
   return @[];
}

+ (NSArray *)supportedExtensions {
   
   return @[];
}

+ (NSString *)baseDirectory {
   
   return nil;
}

- (BOOL)isRemote {
   
   if (self.resPath) {
      
      if ([self.resPath hasPrefix:@"http://"] || [self.resPath hasPrefix:@"https://"]) {
         
         return YES;
      }
   }
   
   return NO;
}

- (BOOL)parse {
   
   return NO;
}

- (void)merge:(IDEAAppletResource *)another {
   
   return;
}

- (void)clear {

   return;
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE(UI, Resource)

DESCRIBE(before) {
}

DESCRIBE(after) {
}

TEST_CASE_END

#endif   // #if __SAMURAI_TESTING__

#endif   // #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "__pragma_pop.h"
