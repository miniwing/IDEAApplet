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

#import "IDEAAppletTemplate.h"
#import "IDEAAppletApp.h"
#import "IDEAAppletWatcher.h"

#import "__pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation NSObject(TemplateResponder)

@def_prop_dynamic_strong( IDEAAppletTemplate *, template, setTemplate );

- (void)loadTemplate:(NSString *)urlOrFile {
   
   [self loadTemplate:urlOrFile inBundle:nil type:nil];
}

- (void)loadTemplate:(NSString *)urlOrFile inBundle:(NSBundle *)aBundle {
   
   [self loadTemplate:urlOrFile inBundle:aBundle type:nil];
}

- (void)loadTemplate:(NSString *)urlOrFile type:(NSString *)type {
   
   [self loadTemplate:urlOrFile inBundle:nil type:type];
}

- (void)loadTemplate:(NSString *)urlOrFile inBundle:(NSBundle *)aBundle type:(NSString *)type {
   
   if ( nil == self.template ) {
      
      self.template = [[IDEAAppletTemplate alloc] init];
      
      self.template.responder = self;
      self.template.bundle    = aBundle;
   }
   
   if ( [urlOrFile hasPrefix:@"http://"] || [urlOrFile hasPrefix:@"https://"] ) {
      
      [self.template loadURL:urlOrFile type:type];
   }
   else if ( [urlOrFile hasPrefix:@"//"] ) {
      
      urlOrFile = [NSString stringWithFormat:@"http:%@", urlOrFile];
      
      [self.template loadURL:urlOrFile type:type];
   }
   else if ( [urlOrFile hasPrefix:@"file://"] ) {
      
      [self.template loadFile:[urlOrFile stringByReplacingOccurrencesOfString:@"file://" withString:@"/"]];
   }
   else if ( [urlOrFile hasPrefix:@"/"] ) {
      
      [self.template loadFile:urlOrFile];
   }
   else {
      
      Class classType = NSClassFromString( urlOrFile );
      if ( classType ) {
         
         [self.template loadClass:classType];
      }
      else {
         
         [self.template loadFile:urlOrFile];
      }
   }
}

- (void)handleTemplate:(IDEAAppletTemplate *)template {
   
}

@end

#pragma mark -

@implementation IDEAAppletTemplate {
   
   NSMutableArray             * _resourceQueue;
   IDEAAppletResourceFetcher  * _resourceFetcher;
}

@def_joint       ( stateChanged );

@def_prop_strong ( IDEAAppletDocument *,  document );
@def_prop_strong ( NSBundle *,            bundle );
@def_prop_assign ( BOOL ,                 responderDisabled );
@def_prop_unsafe ( id   ,                 responder );

@def_prop_copy   ( BlockType     ,        stateChanged );
@def_prop_assign ( TemplateState ,        state );
@def_prop_dynamic( BOOL,                  created );
@def_prop_dynamic( BOOL,                  loading );
@def_prop_dynamic( BOOL,                  loaded );
@def_prop_dynamic( BOOL,                  failed );
@def_prop_dynamic( BOOL,                  cancelled );

+ (IDEAAppletTemplate *)template {
   
   return [[IDEAAppletTemplate alloc] init];
}

- (id)init {
   
   self = [super init];
   if ( self ) {
      
      self.document           = nil;
      
      self.responderDisabled  = NO;
      self.responder          = nil;
      
      self.stateChanged       = nil;
      self.state              = TemplateState_Created;
      
      _resourceQueue    = [[NSMutableArray alloc] init];
      _resourceFetcher  = [IDEAAppletResourceFetcher resourceFetcher];
      
      _resourceFetcher.responder = self;
      
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFileChanged:) name:IDEAAppletWatcher.SourceFileDidChangedNotification object:nil];
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFileRemoved:) name:IDEAAppletWatcher.SourceFileDidRemovedNotification object:nil];
      
   } /* End if () */
   
   return self;
}

- (void)dealloc {
   
   [[NSNotificationCenter defaultCenter] removeObserver:self];
   
   if ( self.document.renderTree && self.document.renderTree.view ) {
      
      [self.document.renderTree.view removeFromSuperview];
   }
   
   self.document = nil;
   self.responder = nil;
   
   self.stateChanged = nil;
   
   _resourceFetcher.responder = nil;
   [_resourceFetcher cancel];
   _resourceFetcher = nil;
   
   [_resourceQueue removeAllObjects];
   _resourceQueue = nil;
   
   __SUPER_DEALLOC;
   
   return;
}

#pragma mark -

- (BOOL)created {
   
   return _state == TemplateState_Created ? YES : NO;
}

- (BOOL)loading {
   
   return _state == TemplateState_Loading ? YES : NO;
}

- (BOOL)loaded {
   
   return _state == TemplateState_Loaded ? YES : NO;
}

- (BOOL)failed {
   
   return _state == TemplateState_Failed ? YES : NO;
}

- (BOOL)cancelled {
   
   return _state == TemplateState_Cancelled ? YES : NO;
}

#pragma mark -

- (BOOL)changeState:(TemplateState)newState {
   
   //   static const char * __states[] = {
   //      "!Created",
   //      "!Loading",
   //      "!Loaded",
   //      "!Failed",
   //      "!Cancelled"
   //   };
   
   if ( newState == self.state )
      return NO;
   
   triggerBefore( self, stateChanged );
   
   PERF( @"Template '%p', state %d -> %d", self, _state, newState );
   
   self.state = newState;
   
   if ( TemplateState_Loading == _state ) {
      
      PERF( @"Template '%p', loading", self );
   }
   else if ( TemplateState_Loaded == _state ) {
      
      PERF( @"Template '%p', loaded", self );
   }
   else if ( TemplateState_Failed == _state ) {
      
      ERROR( @"Template '%p', failed", self );
   }
   else if ( TemplateState_Cancelled == _state ) {
      
      ERROR( @"Template '%p', cancelled", self );
   }
   
   if ( NO == self.responderDisabled ) {
      
      if ( self.responder ) {
         
         [self.responder handleTemplate:self];
      }
      
      if ( self.stateChanged ) {
         
         ((BlockTypeVarg)self.stateChanged)( self );
      }
   }
   
   triggerAfter( self, stateChanged );
   
   return YES;
}

#pragma mark -

- (void)loadClass:(Class)clazz {
   
   ASSERT( nil != clazz );
   
   self.state = TemplateState_Created;
   self.document = [IDEAAppletDocument resourceForClass:clazz];
   
   [self loadMainResource:self.document];
}

- (void)loadFile:(NSString *)aFile {
   
   ASSERT( nil != aFile );
   
   self.state     = TemplateState_Created;
   self.document  = [IDEAAppletDocument resourceAtPath:aFile inBundle:self.bundle];
   
   [self loadMainResource:self.document];
   
   return;
}

- (void)loadURL:(NSString *)url type:(NSString *)type {
   
   ASSERT( nil != url );
   
   self.state     = TemplateState_Created;
   self.document  = [IDEAAppletDocument resourceWithURL:url type:type];
   
   [self loadMainResource:self.document];
}

- (void)stopLoading {
   
   [_resourceFetcher cancel];
   
   if ( TemplateState_Loading == self.state ) {
      
      [self changeState:TemplateState_Cancelled];
   }
}

#pragma mark -

- (void)loadMainResource:(IDEAAppletResource *)resource {
   
   [_resourceFetcher cancel];
   
   if ( nil == resource ) {
      
      [self changeState:TemplateState_Failed];
   }
   else {
      
      [self changeState:TemplateState_Loading];
      
      [_resourceQueue removeAllObjects];
      [_resourceQueue addObject:resource];
      
      [self loadResource:resource];
   }
}

- (void)loadResource:(IDEAAppletResource *)resource {
   
   ASSERT( nil != resource );
   
   INFO( @"Template '%p', loading '%@'", self, resource.resPath );
   
   if ( [resource isRemote] ) {
      
      [self fetchRemoteResource:resource];
   }
   else {
      
      [self fetchLocalResource:resource];
   }
}

- (void)fetchRemoteResource:(IDEAAppletResource *)resource {
   
   [_resourceFetcher queue:resource];
}

- (void)fetchLocalResource:(IDEAAppletResource *)resource {
   
   BOOL succeed = [resource parse];
   if ( succeed ) {
      
      [self handleResourceLoaded:resource];
   }
   else {
      
      [self handleResourceFailed:resource];
   }
}

#pragma mark -

- (void)handleResourceLoaded:(IDEAAppletResource *)resource {
   
   if ( [resource isKindOfClass:[IDEAAppletDocument class]] ) {
      
      IDEAAppletDocument * document = (IDEAAppletDocument *)resource;
      
      // Load sub-resources in document
      
      NSMutableArray * array = [NSMutableArray array];
      
      [array addObjectsFromArray:document.externalStylesheets];
      [array addObjectsFromArray:document.externalScripts];
      [array addObjectsFromArray:document.externalImports];
      
      [_resourceQueue addObjectsFromArray:array];
      
      for ( IDEAAppletResource * resource in array ) {
         
         [self loadResource:resource];
      }
   }
   
   [_resourceQueue removeObject:resource];
   
   if ( 0 == [_resourceQueue count] ) {
      
      BOOL succeed = [self.document reflow];
      if ( succeed ) {
         
         [self changeState:TemplateState_Loaded];
      }
      else {
         
         [_resourceFetcher cancel];
         
         [self changeState:TemplateState_Failed];
      }
   }
}

- (void)handleResourceFailed:(IDEAAppletResource *)resource {
   
   [_resourceFetcher cancel];
   
   [self changeState:TemplateState_Failed];
}

- (void)handleResourceCancelled:(IDEAAppletResource *)resource {
   
   [_resourceFetcher cancel];
   
   [self changeState:TemplateState_Cancelled];
}

#pragma mark -

- (BOOL)document:(IDEAAppletDocument *)document includeResourceOfPath:(NSString *)path {
   
   path = [path lastPathComponent];
   
   if ( [path isEqualToString:[document.resPath lastPathComponent]] ) {
      
      return YES;
   }
   
   for ( IDEAAppletStyleSheet * styleSheet in [document.externalStylesheets copy] ) {
      
      if ( [path isEqualToString:[styleSheet.resPath lastPathComponent]] ) {
         
         return YES;
      }
   }
   
   for ( IDEAAppletScript * script in [document.externalScripts copy] ) {
      
      if ( [path isEqualToString:[script.resPath lastPathComponent]] ) {
         
         return YES;
      }
   }
   
   for ( IDEAAppletResource * resource in [document.externalImports copy] ) {
      
      if ( [resource isKindOfClass:[IDEAAppletDocument class]] ) {
         
         BOOL included = [self document:(IDEAAppletDocument *)resource includeResourceOfPath:path];
         if ( included ) {
            
            return YES;
         }
      }
   }
   
   return NO;
}

- (void)didFileChanged:(NSNotification *)notification {
   
   NSString * path = notification.object;
   
   if ( self.document ) {
      
      BOOL needReload = [self document:self.document includeResourceOfPath:path];
      if ( needReload ) {
         
         [self loadFile:self.document.resPath];
      }
   }
}

- (void)didFileRemoved:(NSNotification *)notification {
   
   NSString * path = notification.object;
   
   if ( self.document ) {
      
      BOOL needReload = [self document:self.document includeResourceOfPath:path];
      if ( needReload ) {
         
         [self loadFile:self.document.resPath];
      }
   }
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( UI, Template )

DESCRIBE( before ) {
   
}

DESCRIBE( after ) {
   
}

TEST_CASE_END

#endif   // #if __SAMURAI_TESTING__

#endif   // #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "__pragma_pop.h"
