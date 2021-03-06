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

#import "IDEAAppletPredefine.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
#pragma clang diagnostic ignored "-Wundeclared-selector"
#pragma clang diagnostic ignored "-Wunreachable-code"

// ----------------------------------
// Macro
// ----------------------------------

#pragma mark -

@class IDEAAppletNamespace;
extern IDEAAppletNamespace    * APPLET;

#pragma mark -

@interface IDEAAppletNamespace : NSObject
@end

#pragma mark -

#define namespace( ... )            macro_concat( namespace_, macro_count(__VA_ARGS__) )( __VA_ARGS__ )
#define namespace_0( ... )
#define namespace_1( _parent, ... )                               \
        interface IDEAAppletNamespace_##_parent : IDEAAppletNamespace   \
        @end                                                      \
        @interface IDEAAppletNamespace (IDEAAppletNamespace_##_parent)  \
        @prop_readonly( IDEAAppletNamespace_##_parent *, _parent );  \
        @end

#define namespace_2( ... )
#define namespace_3( _parent, _child, _class, ... )                        \
        interface IDEAAppletNamespace_##_parent (IDEAAppletNamespace_##_child)   \
        @prop_readonly( _class *, _child );                                \
        @end

#define namespace_4( ... )
#define namespace_5( _parent, _child, _class, _subchild, _subclass, ... )  \
        interface _class (IDEAAppletNamespace_##_subchild)                    \
        @prop_readonly( _subclass *, _subchild );                          \
        @end

#pragma mark -

#define def_namespace( ... )        macro_concat( def_namespace_, macro_count(__VA_ARGS__) )( __VA_ARGS__ )
#define def_namespace_0( ... )
#define def_namespace_1( _parent, ... )                                 \
        implementation IDEAAppletNamespace_##_parent                       \
        @end                                                            \
        @implementation IDEAAppletNamespace (IDEAAppletNamespace_##_parent)   \
        @def_prop_dynamic( IDEAAppletNamespace_##_parent *, _parent );     \
        - (IDEAAppletNamespace_##_parent *)_parent                         \
        {                                                               \
           static __strong id __instance = nil;                         \
           if ( nil == __instance )                                     \
           {                                                            \
              __instance = [[IDEAAppletNamespace_##_parent alloc] init];   \
           }                                                            \
           return __instance;                                           \
        }                                                               \
        @end

#define def_namespace_2( ... )
#define def_namespace_3( _parent, _child, _class, ... )                       \
        implementation IDEAAppletNamespace_##_parent (IDEAAppletNamespace_##_child) \
        @def_prop_dynamic( _class *, _child );                                \
        - (_class *)_child                                                    \
        {                                                                     \
           static __strong id __instance = nil;                               \
           if ( nil == __instance )                                           \
           {                                                                  \
              if ( [_class respondsToSelector:@selector(sharedInstance)] )    \
              {                                                               \
                 __instance = [_class sharedInstance];                        \
              }                                                               \
              else                                                            \
              {                                                               \
                 __instance = [[_class alloc] init];                          \
              }                                                               \
           }                                                                  \
           return __instance;                                                 \
        }                                                                     \
        @end

#define def_namespace_4( ... )
#define def_namespace_5( _parent, _child, _class, _subchild, _subclass, ... ) \
        implementation _class (IDEAAppletNamespace_##_subchild)                  \
        @def_prop_dynamic( _subclass *, _subchild );                          \
        - (_subclass *)_subchild                                              \
        {                                                                     \
           static __strong id __instance = nil;                               \
           if ( nil == __instance )                                           \
           {                                                                  \
              if ( [_class respondsToSelector:@selector(sharedInstance)] )    \
              {                                                               \
                 __instance = [_class sharedInstance];                        \
              }                                                               \
              else                                                            \
              {                                                               \
                 __instance = [[_class alloc] init];                          \
              }                                                               \
           }                                                                  \
           return __instance;                                                 \
        }                                                                     \
        @end

#pragma clang diagnostic pop
