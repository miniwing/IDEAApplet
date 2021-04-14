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

#import "IDEAAppletConfig.h"
#import "IDEAAppletCoreConfig.h"

#pragma mark -

#undef  static_property
#define static_property( __name )                                 \
        property (nonatomic, readonly)   NSString * __name;       \
        - (NSString *)__name;                                     \
        + (NSString *)__name;

#undef  def_static_property
#define def_static_property( __name, ... )                  \
        macro_concat(def_static_property, macro_count(__VA_ARGS__))(__name, __VA_ARGS__)

#undef  class_property
#define class_property( __type, __name )                    \
        property (nonatomic, readonly, class) __type __name;

#undef  def_class_property
#define def_class_property( __type, __name )                \
        macro_concat(def_static_property, macro_count(__VA_ARGS__))(__name, __VA_ARGS__)

#undef  def_static_property0
#define def_static_property0( __name )                      \
        dynamic __name;                                     \
        - (NSString *)__name { return [NSString stringWithFormat:@"%s", #__name]; } \
        + (NSString *)__name { return [NSString stringWithFormat:@"%s", #__name]; }

#undef  def_static_property1
#define def_static_property1( __name, A )                   \
        dynamic __name;                                     \
        - (NSString *)__name { return [NSString stringWithFormat:@"%@.%s", A, #__name]; } \
        + (NSString *)__name { return [NSString stringWithFormat:@"%@.%s", A, #__name]; }

#undef  def_static_property2
#define def_static_property2( __name, A, B )                \
        dynamic __name;                                     \
        - (NSString *)__name { return [NSString stringWithFormat:@"%@.%@.%s", A, B, #__name]; } \
        + (NSString *)__name { return [NSString stringWithFormat:@"%@.%@.%s", A, B, #__name]; }

#undef  def_static_property3
#define def_static_property3( __name, A, B, C )             \
        dynamic __name;                                     \
        - (NSString *)__name { return [NSString stringWithFormat:@"%@.%@.%@.%s", A, B, C, #__name]; } \
        + (NSString *)__name { return [NSString stringWithFormat:@"%@.%@.%@.%s", A, B, C, #__name]; }

#undef  alias_static_property
#define alias_static_property( __name, __alias )            \
        dynamic __name;                                     \
        - (NSString *)__name { return __alias; }            \
        + (NSString *)__name { return __alias; }

#pragma mark -

#undef  integer
#define integer( __name )                                   \
        property (nonatomic, readonly) NSInteger __name;    \
        - (NSInteger)__name;                                \
        + (NSInteger)__name;

#undef  def_integer
#define def_integer( __name, __value )                      \
        dynamic __name;                                     \
        - (NSInteger)__name { return __value; }             \
        + (NSInteger)__name { return __value; }

#pragma mark -

#undef  unsigned_integer
#define unsigned_integer( __name )                          \
        property (nonatomic, readonly) NSUInteger __name;   \
        - (NSUInteger)__name;                               \
        + (NSUInteger)__name;

#undef  def_unsigned_integer
#define def_unsigned_integer( __name, __value )             \
        dynamic __name;                                     \
        - (NSUInteger)__name { return __value; }            \
        + (NSUInteger)__name { return __value; }

#pragma mark -

#undef  number
#define number( __name )                                    \
        property (nonatomic, readonly) NSNumber * __name;   \
        - (NSNumber *)__name;                               \
        + (NSNumber *)__name;

#undef  def_number
#define def_number( __name, __value )                       \
        dynamic __name;                                     \
        - (NSNumber *)__name { return @(__value); }         \
        + (NSNumber *)__name { return @(__value); }

#pragma mark -

#undef  string
#define string( __name )                                    \
        property (nonatomic, readonly) NSString * __name;   \
        - (NSString *)__name;                               \
        + (NSString *)__name;

#undef  def_string
#define def_string( __name, __value )                       \
        dynamic __name;                                     \
        - (NSString *)__name { return __value; }            \
        + (NSString *)__name { return __value; }

#pragma mark -

#if __has_feature(objc_arc)
#  define prop_readwrite( __type, __name )   property (nonatomic, readwrite)           __type __name;
#  define prop_readonly( __type, __name )    property (nonatomic, readonly)            __type __name;
#  define prop_dynamic( __type, __name )     property (nonatomic, strong)              __type __name;
#  define prop_assign( __type, __name )      property (nonatomic, assign)              __type __name;
#  define prop_strong( __type, __name )      property (nonatomic, strong)              __type __name;
#  define prop_weak( __type, __name )        property (nonatomic, weak)                __type __name;
#  define prop_copy( __type, __name )        property (nonatomic, copy)                __type __name;
#  define prop_unsafe( __type, __name )      property (nonatomic, unsafe_unretained)   __type __name;
#else
#  define prop_readwrite( __type, __name )   property (nonatomic, readwrite)           __type __name;
#  define prop_readonly( __type, __name )    property (nonatomic, readonly)            __type __name;
#  define prop_dynamic( __type, __name )     property (nonatomic, retain)              __type __name;
#  define prop_assign( __type, __name )      property (nonatomic, assign)              __type __name;
#  define prop_strong( __type, __name )      property (nonatomic, retain)              __type __name;
#  define prop_weak( __type, __name )        property (nonatomic, assign)              __type __name;
#  define prop_copy( __type, __name )        property (nonatomic, copy)                __type __name;
#  define prop_unsafe( __type, __name )      property (nonatomic, assign)              __type __name;
#endif

#define prop_retype( __type, __name )        property __type __name;

#pragma mark -
#define prop_class( __type, __name )         property (nonatomic, readonly, class)     __type __name;
#define impl_prop_class( __type, __name )    + (__type) __name

#pragma mark -

#define def_prop_readonly( type, name, ... ) \
        synthesize name = _##name;

#define def_prop_assign( type, name, ... )   \
        synthesize name = _##name;

#define def_prop_strong( type, name, ... )   \
        synthesize name = _##name;

#define def_prop_weak( type, name, ... )     \
        synthesize name = _##name;

#define def_prop_unsafe( type, name, ... )   \
        synthesize name = _##name;

#define def_prop_copy( type, name, ... )     \
        synthesize name = _##name;

#define def_prop_dynamic( type, name, ... )  \
        dynamic name;

#define def_prop_dynamic_copy( type, name, setName, ... )   \
        def_prop_custom( type, name, setName, copy )

#define def_prop_dynamic_strong( type, name, setName, ... ) \
        def_prop_custom( type, name, setName, retain )

#define def_prop_dynamic_unsafe( type, name, setName, ... ) \
        def_prop_custom( type, name, setName, assign )

#define def_prop_dynamic_weak( type, name, setName, ... )   \
        def_prop_custom( type, name, setName, assign )

#define def_prop_dynamic_pod( type, name, setName, pod_type ... ) \
        dynamic name;                                       \
        - (type)name { return (type)[[self getAssociatedObjectForKey:#name] pod_type##Value]; } \
        - (void)setName:(type)obj { [self assignAssociatedObject:@((pod_type)obj) forKey:#name]; }

#define def_prop_custom( type, name, setName, attr )        \
        dynamic name;                                       \
        - (type)name { return [self getAssociatedObjectForKey:#name]; } \
        - (void)setName:(type)obj { [self attr##AssociatedObject:obj forKey:#name]; }

#pragma mark -

#undef  IDEA_DEF_STATIC_PROPERTY0
#define IDEA_DEF_STATIC_PROPERTY0( __name )                 \
        dynamic __name;                                     \
        - (NSString *)__name { return [NSString stringWithFormat:@"%s", macro_cstr(__name)]; } \
        + (NSString *)__name { return [NSString stringWithFormat:@"%s", macro_cstr(__name)]; }

#undef  IDEA_DEF_STATIC_PROPERTY1
#define IDEA_DEF_STATIC_PROPERTY1( __name, A )              \
        dynamic __name;                                     \
        - (NSString *)__name { return [NSString stringWithFormat:@"%@.%s", A, macro_cstr(__name)]; } \
        + (NSString *)__name { return [NSString stringWithFormat:@"%@.%s", A, macro_cstr(__name)]; }

#undef  IDEA_DEF_STATIC_PROPERTY2
#define IDEA_DEF_STATIC_PROPERTY2( __name, A, B )           \
        dynamic __name;                                     \
        - (NSString *)__name { return [NSString stringWithFormat:@"%@.%@.%s", A, B, macro_cstr(__name)]; } \
        + (NSString *)__name { return [NSString stringWithFormat:@"%@.%@.%s", A, B, macro_cstr(__name)]; }

#undef  IDEA_DEF_STATIC_PROPERTY3
#define IDEA_DEF_STATIC_PROPERTY3( __name, A, B, C )        \
        dynamic __name;                                     \
        - (NSString *)__name { return [NSString stringWithFormat:@"%@.%@.%@.%s", A, B, C, macro_cstr(__name)]; } \
        + (NSString *)__name { return [NSString stringWithFormat:@"%@.%@.%@.%s", A, B, C, macro_cstr(__name)]; }

#pragma mark -

@interface NSObject(Property)

+ (const char *)attributesForProperty:(NSString *)aProperty;
- (const char *)attributesForProperty:(NSString *)aProperty;

+ (NSDictionary *)extentionForProperty:(NSString *)aProperty;
- (NSDictionary *)extentionForProperty:(NSString *)aProperty;

+ (NSString *)extentionForProperty:(NSString *)aProperty stringValueWithKey:(NSString *)aKey;
- (NSString *)extentionForProperty:(NSString *)aProperty stringValueWithKey:(NSString *)aKey;

+ (NSArray *)extentionForProperty:(NSString *)aProperty arrayValueWithKey:(NSString *)aKey;
- (NSArray *)extentionForProperty:(NSString *)aProperty arrayValueWithKey:(NSString *)aKey;

- (id)getAssociatedObjectForKey:(const char *)aKey;
- (id)copyAssociatedObject:(id)aObject   forKey:(const char *)aKey;
- (id)retainAssociatedObject:(id)aObject forKey:(const char *)aKey;
- (id)assignAssociatedObject:(id)aObject forKey:(const char *)aKey;
- (void)removeAssociatedObjectForKey:(const char *)aKey;
- (void)removeAllAssociatedObjects;

@end
