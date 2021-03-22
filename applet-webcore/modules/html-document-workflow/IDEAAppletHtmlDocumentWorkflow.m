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

#import "IDEAAppletHtmlDocumentWorkflow.h"
#import "IDEAAppletHtmlDocumentWorklet_10Begin.h"
#import "IDEAAppletHtmlDocumentWorklet_20ParseDomTree.h"
#import "IDEAAppletHtmlDocumentWorklet_30ParseResource.h"
#import "IDEAAppletHtmlDocumentWorklet_40MergeStyleTree.h"
#import "IDEAAppletHtmlDocumentWorklet_50MergeDomTree.h"
#import "IDEAAppletHtmlDocumentWorklet_60ApplyStyleTree.h"
#import "IDEAAppletHtmlDocumentWorklet_70BuildRenderTree.h"
#import "IDEAAppletHtmlDocumentWorklet_80Finish.h"

#import "__pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation IDEAAppletHtmlDocumentWorklet
@end

#pragma mark -

@implementation IDEAAppletHtmlDocumentWorkflow_All

- (id)init
{
   self = [super init];
   if ( self )
   {
      [self.worklets addObject:[IDEAAppletHtmlDocumentWorklet_10Begin worklet]];
      [self.worklets addObject:[IDEAAppletHtmlDocumentWorklet_20ParseDomTree worklet]];
      [self.worklets addObject:[IDEAAppletHtmlDocumentWorklet_30ParseResource worklet]];
      [self.worklets addObject:[IDEAAppletHtmlDocumentWorklet_40MergeStyleTree worklet]];
      [self.worklets addObject:[IDEAAppletHtmlDocumentWorklet_50MergeDomTree worklet]];
      [self.worklets addObject:[IDEAAppletHtmlDocumentWorklet_60ApplyStyleTree worklet]];
      [self.worklets addObject:[IDEAAppletHtmlDocumentWorklet_70BuildRenderTree worklet]];
      [self.worklets addObject:[IDEAAppletHtmlDocumentWorklet_80Finish worklet]];
   }
   return self;
}

- (void)dealloc
{
}

@end

#pragma mark -

@implementation IDEAAppletHtmlDocumentWorkflow_Parser

- (id)init
{
   self = [super init];
   if ( self )
   {
      [self.worklets addObject:[IDEAAppletHtmlDocumentWorklet_10Begin worklet]];
      [self.worklets addObject:[IDEAAppletHtmlDocumentWorklet_20ParseDomTree worklet]];
      [self.worklets addObject:[IDEAAppletHtmlDocumentWorklet_30ParseResource worklet]];
   }
   return self;
}

- (void)dealloc
{
}

@end

#pragma mark -

@implementation IDEAAppletHtmlDocumentWorkflow_Render

- (id)init
{
   self = [super init];
   if ( self )
   {
      [self.worklets addObject:[IDEAAppletHtmlDocumentWorklet_40MergeStyleTree worklet]];
      [self.worklets addObject:[IDEAAppletHtmlDocumentWorklet_50MergeDomTree worklet]];
      [self.worklets addObject:[IDEAAppletHtmlDocumentWorklet_60ApplyStyleTree worklet]];
      [self.worklets addObject:[IDEAAppletHtmlDocumentWorklet_70BuildRenderTree worklet]];
      [self.worklets addObject:[IDEAAppletHtmlDocumentWorklet_80Finish worklet]];
   }
   return self;
}

- (void)dealloc
{
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( WebCore, HtmlDocumentWorkflow )

DESCRIBE( before )
{
}

DESCRIBE( after )
{
}

TEST_CASE_END

#endif   // #if __SAMURAI_TESTING__

#endif   // #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "__pragma_pop.h"
