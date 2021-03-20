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

#import "IDEAAppletHtmlDocumentWorklet_30ParseResource.h"

#import "__pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "IDEAAppletHtmlDomNode.h"
#import "IDEAAppletHtmlDocument.h"
#import "IDEAAppletHtmlUserAgent.h"

#import "IDEAAppletCSSStyleSheet.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

typedef enum
{
   ParseDomain_Document = 0,
   ParseDomain_Head,
   ParseDomain_Body
   
} ParseDomain;

#pragma mark -

@implementation SamuraiHtmlDocumentWorklet_30ParseResource
{
   ParseDomain _domain;
}

- (id)init
{
   int                            nErr                                     = EFAULT;
   
   __TRY;
   
   self = [super init];
   
   if (self)
   {
      _domain = ParseDomain_Document;
      
   } /* End if () */
   
   __CATCH(nErr);
   
   return self;
}

- (void)dealloc
{
   __SUPER_DEALLOC;
   
   return;
}

- (BOOL)processWithContext:(SamuraiHtmlDocument *)aDocument
{
   int                            nErr                                     = EFAULT;
   
   __TRY;
   
   if (aDocument.domTree)
   {
      [aDocument.externalScripts removeAllObjects];
      [aDocument.externalStylesheets removeAllObjects];
      
      [self parseDomNode:aDocument.domTree forDocument:aDocument];
      
   } /* End if () */
   
   __CATCH(nErr);
   
   return YES;
}

#pragma mark -

- (void)parseDomNode:(SamuraiHtmlDomNode *)aDomNode forDocument:(SamuraiHtmlDocument *)aDocument
{
   int                            nErr                                     = EFAULT;
   
   ParseDomain                    ePrevDomain                              = ParseDomain_Document;
   
   __TRY;
   
   if (nil == aDomNode || nil == aDocument)
   {
      nErr  = EINVAL;
      
      break;
      
   } /* End if () */
   
   ePrevDomain = _domain;
   
   if (NSOrderedSame == [aDomNode.tag compare:aDocument.rootTag options:NSCaseInsensitiveSearch])
   {
      _domain  = ParseDomain_Document;
      
   }  /* End if () */
   else if (NSOrderedSame == [aDomNode.tag compare:aDocument.headTag options:NSCaseInsensitiveSearch])
   {
      _domain  = ParseDomain_Head;
      
   } /* End else if () */
   else if (NSOrderedSame == [aDomNode.tag compare:aDocument.bodyTag options:NSCaseInsensitiveSearch])
   {
      _domain  = ParseDomain_Body;
      
   } /* End else if () */
   
   if (DomNodeType_Document == aDomNode.type)
   {
      [self parseDomNodeDocument:aDomNode forDocument:aDocument];
      
   } /* End else if () */
   else if (DomNodeType_Element == aDomNode.type)
   {
      [self parseDomNodeElement:aDomNode forDocument:aDocument];
      
   } /* End else if () */
   else if (DomNodeType_Text == aDomNode.type)
   {
      [self parseDomNodeText:aDomNode forDocument:aDocument];
      
   } /* End else if () */
   else if (DomNodeType_Data == aDomNode.type)
   {
      [self parseDomNodeData:aDomNode forDocument:aDocument];
      
   } /* End else if () */
   
   _domain = ePrevDomain;
   
   __CATCH(nErr);
   
   return;
}

- (void)parseDomNodeDocument:(SamuraiHtmlDomNode *)aDomNode forDocument:(SamuraiHtmlDocument *)aDocument
{
   int                            nErr                                     = EFAULT;
   
   __TRY;
   
   for (SamuraiHtmlDomNode * childNode in aDomNode.childs)
   {
      [self parseDomNode:childNode forDocument:aDocument];
      
   } /* End for () */
   
   __CATCH(nErr);
   
   return;
}

- (void)parseDomNodeElement:(SamuraiHtmlDomNode *)aDomNode forDocument:(SamuraiHtmlDocument *)aDocument
{
   int                            nErr                                     = EFAULT;
   
   __TRY;
   
   if ([aDomNode.tag isEqualToString:@"link"])
   {
      NSString *szAttrRel = aDomNode.attrRel;
      
      if ([szAttrRel isEqualToString:@"stylesheet"])
      {
         // <link rel="stylsheet" href="" media=""/>
         
         SamuraiResource   *stResource = [self parseStyleSheet:aDomNode basePath:aDocument.resPath];
         if (stResource)
         {
            [aDocument.externalStylesheets addObject:stResource];
            
         } /* End if () */
      }
      else if ([szAttrRel isEqualToString:@"import"])
      {
         // <link rel="import" href=""/>
         
         SamuraiResource   *stResource = [self parseImport:aDomNode basePath:aDocument.resPath];
         if (stResource)
         {
            [aDocument.externalImports addObject:stResource];
            
         } /* End if () */
      }
   }
   else if ([aDomNode.tag isEqualToString:@"style"])
   {
      // <style type="text/css"></style>
      
      SamuraiStyleSheet *stResource = [self parseStyleSheet:aDomNode basePath:aDocument.resPath];
      if (stResource)
      {
         [aDocument.externalStylesheets addObject:stResource];
         
      } /* End if () */
   }
   
   for (SamuraiHtmlDomNode * childNode in aDomNode.childs)
   {
      [self parseDomNode:childNode forDocument:aDocument];
      
   } /* End for () */
   
   __CATCH(nErr);
   
   return;
}

- (void)parseDomNodeText:(SamuraiHtmlDomNode *)aDomNode forDocument:(SamuraiHtmlDocument *)aDocument
{
   int                            nErr                                     = EFAULT;
   
   __TRY;
   
   __CATCH(nErr);
   
   return;
}

- (void)parseDomNodeData:(SamuraiHtmlDomNode *)aDomNode forDocument:(SamuraiHtmlDocument *)aDocument
{
   int                            nErr                                     = EFAULT;
   
   __TRY;
   
   __CATCH(nErr);
   
   return;
}

#pragma mark -

- (SamuraiStyleSheet *)parseStyleSheet:(SamuraiHtmlDomNode *)aNode basePath:(NSString *)aBasePath
{
   int                            nErr                                     = EFAULT;
   
   SamuraiCSSStyleSheet          *stStyleSheet                             = nil;
   
   NSString                      *szType                                   = aNode.attrType;
   NSString                      *szHref                                   = aNode.attrHref;
   NSString                      *szMedia                                  = aNode.attrMedia;
   NSString                      *szContent                                = [aNode computeInnerText];
   
   __TRY;
   
   if (nil == szType || 0 == [szType length])
   {
      szType = @"text/css";
   }
   
   if ([szType isEqualToString:@"text/css"])
   {
      if (szHref && szHref.length)
      {
         NSString    *szFileName = [[szHref lastPathComponent] stringByDeletingPathExtension];
         NSString    *szFileExt  = [[szHref lastPathComponent] pathExtension];
         NSString    *szFilePath = [[NSBundle mainBundle] pathForResource:szFileName ofType:szFileExt];
         
         if (szFilePath && [[NSFileManager defaultManager] fileExistsAtPath:szFilePath])
         {
            stStyleSheet = [SamuraiCSSStyleSheet resourceAtPath:szFilePath inBundle:nil];
            
         } /* End if () */
         else if ([szHref hasPrefix:@"http://"] || [szHref hasPrefix:@"https://"])
         {
            stStyleSheet = [SamuraiCSSStyleSheet resourceWithURL:szHref];
            
         } /* End else if () */
         else if ([szHref hasPrefix:@"//"])
         {
            stStyleSheet = [SamuraiCSSStyleSheet resourceWithURL:[@"http:" stringByAppendingString:szHref]];
            
         } /* End else if () */
         else if ([aBasePath hasPrefix:@"http://"] || [aBasePath hasPrefix:@"https://"])
         {
            NSURL    *szURL   = [NSURL URLWithString:szHref relativeToURL:[NSURL URLWithString:aBasePath]];
            
            stStyleSheet = [SamuraiCSSStyleSheet resourceWithURL:[szURL absoluteString]];
            
         } /* End else if () */
         else
         {
            NSString * cssPath;
            cssPath = [aBasePath stringByDeletingLastPathComponent];
            cssPath = [cssPath stringByAppendingPathComponent:szHref];
            cssPath = [cssPath stringByStandardizingPath];
            
            stStyleSheet = [SamuraiCSSStyleSheet resourceAtPath:cssPath inBundle:nil];
            
         }  /* End else */
         
      } /* End if () */
      else if (szContent && szContent.length)
      {
         stStyleSheet = [SamuraiCSSStyleSheet resourceWithString:szContent type:szType baseURL:aBasePath];
         
      } /* End else if () */
      else
      {
         WARN(@"Failed to load css stylesheet");
         
      } /* End else */
   }
   else
   {
      TODO("Support more style type");
      
   } /* End else */
   
   if (nil == stStyleSheet)
   {
      //      return nil;
      
      nErr  = EFAULT;
      
      break;
      
   } /* End if () */
   
   stStyleSheet.href    = szHref;
   stStyleSheet.type    = szType;
   stStyleSheet.media   = szMedia;
   
   if (ParseDomain_Document == _domain)
   {
      stStyleSheet.resPolicy  = ResourcePolicy_Preload;
      
   } /* End else if () */
   else if (ParseDomain_Head == _domain)
   {
      stStyleSheet.resPolicy  = ResourcePolicy_Preload;
      
   } /* End else if () */
   else if (ParseDomain_Body == _domain)
   {
      stStyleSheet.resPolicy  = ResourcePolicy_Lazyload;
      
   } /* End else if () */
   else
   {
      stStyleSheet.resPolicy  = ResourcePolicy_Default;
      
   } /* End else */
   
   __CATCH(nErr);
   
   return stStyleSheet;
}

- (SamuraiDocument *)parseImport:(SamuraiHtmlDomNode *)aNode basePath:(NSString *)aBasePath
{
   int                            nErr                                     = EFAULT;
   
   NSString                      *szHref                                   = aNode.attrHref;
   SamuraiHtmlDocument           *stDocument                               = nil;
   
   __TRY;
   
   if (szHref && szHref.length)
   {
      if ([szHref hasPrefix:@"http://"] || [szHref hasPrefix:@"https://"])
      {
         stDocument = [SamuraiHtmlDocument resourceWithURL:szHref];
         
      } /* End if () */
      else if ([szHref hasPrefix:@"//"])
      {
         stDocument = [SamuraiHtmlDocument resourceWithURL:[@"http:" stringByAppendingString:szHref]];
         
      } /* End if () */
      else
      {
         if ([aBasePath hasPrefix:@"http://"] || [aBasePath hasPrefix:@"https://"])
         {
            NSURL *szURL   = [NSURL URLWithString:szHref relativeToURL:[NSURL URLWithString:aBasePath]];
            
            stDocument = [SamuraiHtmlDocument resourceWithURL:[szURL absoluteString]];
            
         } /* End if () */
         else
         {
            NSString *szHtmlPath = [aBasePath stringByDeletingLastPathComponent];
            szHtmlPath = [szHtmlPath stringByAppendingPathComponent:szHref];
            szHtmlPath = [szHtmlPath stringByStandardizingPath];
            
            stDocument = [SamuraiHtmlDocument resourceAtPath:szHtmlPath inBundle:nil];
            
         } /* End else */
         
      } /* End else */
      
   } /* End if() */
   
   if (nil == stDocument)
   {
      nErr  = noErr;
      
      //      return nil;
      
      break;
      
   } /* End else */
   
   stDocument.href      = szHref;
   stDocument.type      = @"text/html";
   stDocument.media     = nil;
   
   stDocument.rootTag   = @"element";
   stDocument.headTag   = nil;
   stDocument.bodyTag   = @"template";
   
   if (ParseDomain_Document == _domain)
   {
      stDocument.resPolicy = ResourcePolicy_Preload;
      
   }  /* End if () */
   else if (ParseDomain_Head == _domain)
   {
      stDocument.resPolicy = ResourcePolicy_Preload;
      
   } /* End else if () */
   else if (ParseDomain_Body == _domain)
   {
      stDocument.resPolicy = ResourcePolicy_Lazyload;
   } /* End else if () */
   else
   {
      stDocument.resPolicy = ResourcePolicy_Default;
      
   } /* End else */
   
   __CATCH(nErr);
   
   return stDocument;
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE(WebCore, HtmlDocumentWorklet_30ParseResource)

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
