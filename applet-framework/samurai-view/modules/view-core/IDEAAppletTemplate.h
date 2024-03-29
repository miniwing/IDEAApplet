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

#import "IDEAAppletCore.h"
#import "IDEAAppletEvent.h"

//#import "IDEAAppletViewConfig.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "IDEAAppletDomNode.h"
#import "IDEAAppletDocument.h"
#import "IDEAAppletStyleSheet.h"
#import "IDEAAppletScript.h"
#import "IDEAAppletRenderObject.h"
#import "IDEAAppletRenderStyle.h"
#import "IDEAAppletResource.h"
#import "IDEAAppletResourceFetcher.h"

#pragma mark -

typedef enum
{
   TemplateState_Created = 0,
   TemplateState_Loading,
   TemplateState_Loaded,
   TemplateState_Failed,
   TemplateState_Cancelled
} TemplateState;

#pragma mark -

@class IDEAAppletTemplate;

@interface NSObject(TemplateResponder)

@prop_strong( IDEAAppletTemplate *, _template );

- (void)loadTemplate:(NSString *)urlOrFile;
- (void)loadTemplate:(NSString *)urlOrFile type:(NSString *)type;

- (void)loadTemplate:(NSString *)urlOrFile inBundle:(NSBundle *)aBundle;
- (void)loadTemplate:(NSString *)urlOrFile inBundle:(NSBundle *)aBundle type:(NSString *)type;

- (void)handleTemplate:(IDEAAppletTemplate *)_template;

@end

#pragma mark -

@interface IDEAAppletTemplate : NSObject

@joint( stateChanged );

@prop_strong( IDEAAppletDocument *,    document );

@prop_strong( NSBundle *,              bundle );

@prop_assign( NSTimeInterval,          timeoutSeconds );
@prop_assign( BOOL,                    timeout );

@prop_assign( BOOL,                    responderDisabled );
@prop_unsafe( id,                      responder );

@prop_copy( BlockType,                 stateChanged );
@prop_assign( TemplateState,           state );
@prop_readonly( BOOL,                  created );
@prop_readonly( BOOL,                  loading );
@prop_readonly( BOOL,                  loaded );
@prop_readonly( BOOL,                  failed );
@prop_readonly( BOOL,                  cancelled );

+ (IDEAAppletTemplate *)template;

- (void)loadClass:(Class)clazz;
- (void)loadFile:(NSString *)file;
- (void)loadURL:(NSString *)url type:(NSString *)type;

- (void)stopLoading;

@end

#endif   // #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
