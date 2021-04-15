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

#import "IDEAAppletCSSParser.h"
#import "IDEAAppletCSSArray.h"
#import "IDEAAppletCSSValue.h"

#import "__pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "katana-parser/katana.h"
#import "katana-parser/katana_parser.h"
#import "katana-parser/katana_selector.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation IDEAAppletCSSParser

@def_singleton( IDEAAppletCSSParser )

- (id)init {
   
   self = [super init];
   if ( self ) {
      
   }
   return self;
}

- (void)dealloc {
   
   __SUPER_DEALLOC;
   
   return;
}

#pragma mark -

- (KatanaOutput *)parseStylesheet:(NSString *)text {
   
   return katana_parse(text.UTF8String, text.length, KatanaParserModeStylesheet);
}

- (KatanaOutput *)parseMedia:(NSString *)text {
   
   return katana_parse(text.UTF8String, text.length, KatanaParserModeMediaList);
}

- (KatanaOutput *)parseValue:(NSString *)text {
   
   return katana_parse(text.UTF8String, text.length, KatanaParserModeValue);
}

- (KatanaOutput *)parseSelector:(NSString *)text {
   
   return katana_parse(text.UTF8String, text.length, KatanaParserModeSelector);
}

- (KatanaOutput *)parseDeclaration:(NSString *)text {
   
   return katana_parse(text.UTF8String, text.length, KatanaParserModeDeclarationList);
}

- (NSDictionary *)parseDictionary:(NSString *)text {
   
   if ( nil == text || 0 == text.length )
      return nil;
   
   NSDictionary * result = nil;
   KatanaOutput * output = [[IDEAAppletCSSParser sharedInstance] parseDeclaration:text];
   
   if ( NULL != output ) {
      
      result = [self buildDictionary:output->declarations];
      
      katana_destroy_output( output );
   }
   
   return result;
}

- (NSDictionary *)parseImportants:(NSString *)text {
   
   if ( nil == text || 0 == text.length )
      return nil;
   
   NSDictionary * result = nil;
   KatanaOutput * output = [[IDEAAppletCSSParser sharedInstance] parseDeclaration:text];
   
   if ( NULL != output ) {
      
      result = [self buildImportants:output->declarations];
      
      katana_destroy_output( output );
   }
   
   return result;
}

- (NSDictionary *)buildDictionary:(KatanaArray *)declarations {
   
   if ( NULL == declarations || 0 == declarations->length )
      return nil;
   
   NSMutableDictionary * result = nil;
   
   for ( size_t i = 0; i < declarations->length; i++ ) {
      
      KatanaDeclaration * decl = declarations->data[i];
      
      if ( NULL == decl->property )
         continue;
      
      NSString * key = [NSString stringWithUTF8String:decl->property];
      NSObject * val = [IDEAAppletCSSArray parseArray:decl->values];
      
      if ( key && val ) {
         
         if ( nil == result ) {
            
            result = [[NSMutableDictionary alloc] init];
         }
         
         [result setValue:val forKey:key];
      }
   }
   
   return result;
}

- (NSDictionary *)buildImportants:(KatanaArray *)declarations {
   
   if ( NULL == declarations || 0 == declarations->length )
      return nil;
   
   NSMutableDictionary * result = nil;
   
   for ( size_t i = 0; i < declarations->length; i++ ) {
      
      KatanaDeclaration * decl = declarations->data[i];
      
      if ( NULL == decl->property )
         continue;
      
      if ( decl->important ) {
         
         NSString * key = [NSString stringWithUTF8String:decl->property];
         NSObject * val = [IDEAAppletCSSArray parseArray:decl->values];
         
         if ( key && val ) {
            
            if ( nil == result ) {
               
               result = [[NSMutableDictionary alloc] init];
            }
            
            [result setValue:val forKey:key];
         }
      }
   }
   
   return result;
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( WebCore, CSSParser )

DESCRIBE( before ) {
   
}

DESCRIBE( after ) {
   
}

TEST_CASE_END

#endif   // #if __SAMURAI_TESTING__

#endif   // #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "__pragma_pop.h"
