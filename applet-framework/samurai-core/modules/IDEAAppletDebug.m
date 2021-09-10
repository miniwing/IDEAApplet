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

#import "IDEAAppletDebug.h"
#import "IDEAAppletLog.h"
#import "IDEAAppletUnitTest.h"

#import "IDEAApplet/NSObject+Extension.h"
#import "IDEAApplet/NSArray+Extension.h"
#import "IDEAApplet/NSMutableArray+Extension.h"

#import "__pragma_push.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

#undef   MAX_CALLSTACK_DEPTH
#define MAX_CALLSTACK_DEPTH   (64)

#pragma mark -

@interface IDEAAppletCallFrame()
+ (NSUInteger)hexValueFromString:(NSString *)text;
+ (id)parseFormat1:(NSString *)line;
+ (id)parseFormat2:(NSString *)line;
@end

#pragma mark -

@implementation IDEAAppletCallFrame

@def_prop_assign( CallFrameType,   type );
@def_prop_strong( NSString *,      process );
@def_prop_assign( NSUInteger,      entry );
@def_prop_assign( NSUInteger,      offset );
@def_prop_strong( NSString *,      clazz );
@def_prop_strong( NSString *,      method );

- (id)init {
   
   self = [super init];
   if ( self ) {
      
      _type = CallFrameType_Unknown;
      
   } /* End if () */
   
   return self;
}

- (void)dealloc {
   
   self.process= nil;
   self.clazz  = nil;
   self.method = nil;
   
   __SUPER_DEALLOC;
   
   return;
}

#if APPLET_DESCRIPTION
- (NSString *)description {
   
   if ( CallFrameType_ObjectC == _type ) {
      
      return [NSString stringWithFormat:@"[O] %@(0x%08x + %llu) -> [%@ %@]", _process, (unsigned int)_entry, (unsigned long long)_offset, _clazz, _method];
   }
   else if ( CallFrameType_NativeC == _type ) {
      
      return [NSString stringWithFormat:@"[C] %@(0x%08x + %llu) -> %@", _process, (unsigned int)_entry, (unsigned long long)_offset, _method];
   }
   else {
      
      return [NSString stringWithFormat:@"[X] <unknown>(0x%08x + %llu)", (unsigned int)_entry, (unsigned long long)_offset];
   }
}
#endif /* APPLET_DESCRIPTION */

+ (NSUInteger)hexValueFromString:(NSString *)aText {
   
   unsigned int number = 0;
   [[NSScanner scannerWithString:aText] scanHexInt:&number];
   return (NSUInteger)number;
}

+ (id)parseFormat1:(NSString *)aLine {
   
   //   example: peeper  0x00001eca -[PPAppDelegate application:didFinishLaunchingWithOptions:] + 106
   
   static __strong NSRegularExpression * __regex = nil;
   
   if ( nil == __regex ) {
      
      NSError  *error = NULL;
      NSString *expr = @"^[0-9]*\\s*([a-z0-9_]+)\\s+(0x[0-9a-f]+)\\s+-\\[([a-z0-9_]+)\\s+([a-z0-9_:]+)]\\s+\\+\\s+([0-9]+)$";
      
      __regex = [NSRegularExpression regularExpressionWithPattern:expr options:NSRegularExpressionCaseInsensitive error:&error];
      
   } /* End if () */
   
   NSTextCheckingResult *stResult   = [__regex firstMatchInString:aLine options:0 range:NSMakeRange(0, [aLine length])];
   
   if ( stResult && (__regex.numberOfCaptureGroups + 1) == stResult.numberOfRanges ) {
      
      IDEAAppletCallFrame  *stFrame = [[IDEAAppletCallFrame alloc] init];
      if ( stFrame ) {
         
         stFrame.type      = CallFrameType_ObjectC;
         stFrame.process   = [aLine substringWithRange:[stResult rangeAtIndex:1]];
         stFrame.entry     = [self hexValueFromString:[aLine substringWithRange:[stResult rangeAtIndex:2]]];
         stFrame.clazz     = [aLine substringWithRange:[stResult rangeAtIndex:3]];
         stFrame.method    = [aLine substringWithRange:[stResult rangeAtIndex:4]];
         stFrame.offset    = (NSUInteger)[[aLine substringWithRange:[stResult rangeAtIndex:5]] intValue];
         
         return stFrame;
         
      } /* End if () */
      
   } /* End if () */
   
   return nil;
}

+ (id)parseFormat2:(NSString *)aLine {
   
   //   example: UIKit 0x0105f42e UIApplicationMain + 1160
   
   static __strong NSRegularExpression * __regex = nil;
   
   if ( nil == __regex ) {
      
      NSError  *error = NULL;
      NSString *expr = @"^[0-9]*\\s*([a-z0-9_]+)\\s+(0x[0-9a-f]+)\\s+([a-z0-9_]+)\\s+\\+\\s+([0-9]+)$";
      
      __regex = [NSRegularExpression regularExpressionWithPattern:expr options:NSRegularExpressionCaseInsensitive error:&error];
      
   } /* End if () */
   
   NSTextCheckingResult *stResult   = [__regex firstMatchInString:aLine options:0 range:NSMakeRange(0, [aLine length])];
   
   if ( stResult && (__regex.numberOfCaptureGroups + 1) == stResult.numberOfRanges ) {
      
      IDEAAppletCallFrame  *stFrame = [[IDEAAppletCallFrame alloc] init];
      if ( stFrame ) {
         
         stFrame.type = CallFrameType_NativeC;
         stFrame.process = [aLine substringWithRange:[stResult rangeAtIndex:1]];
         stFrame.entry = [self hexValueFromString:[aLine substringWithRange:[stResult rangeAtIndex:2]]];
         stFrame.clazz = nil;
         stFrame.method = [aLine substringWithRange:[stResult rangeAtIndex:3]];
         stFrame.offset = (NSUInteger)[[aLine substringWithRange:[stResult rangeAtIndex:4]] intValue];
         
         return stFrame;
         
      } /* End if () */
      
   } /* End if () */
   
   return nil;
}

+ (id)unknown {
   
   return [[IDEAAppletCallFrame alloc] init];
}

+ (id)parse:(NSString *)aLine {
   
   if ( 0 == [aLine length] )
      return nil;
   
   id frame1 = [IDEAAppletCallFrame parseFormat1:aLine];
   if ( frame1 ) {
      return frame1;
   }
   
   id frame2 = [IDEAAppletCallFrame parseFormat2:aLine];
   if ( frame2 ) {
      return frame2;
   }
   
   return nil;
}

@end

#pragma mark -

@implementation IDEAAppletDebugger

@def_singleton( IDEAAppletDebugger )

@def_prop_readonly( NSArray *,   callstack );

#if __SAMURAI_DEBUG__
static void __uncaughtExceptionHandler( NSException * exception ) {
   
   fprintf( stderr, "\nUncaught exception: %s\n%s",
           [[exception description] UTF8String],
           [[[exception callStackSymbols] description] UTF8String] );
   
   TRAP();
}
#endif   // #if __SAMURAI_DEBUG__

#if __SAMURAI_DEBUG__
static void __uncaughtSignalHandler( int signal ) {
   
   fprintf( stderr, "\nUncaught signal: %d", signal );
   
   TRAP();
}
#endif   // #if __SAMURAI_DEBUG__

+ (void)classAutoLoad {
   
#if __SAMURAI_DEBUG__
   NSSetUncaughtExceptionHandler( &__uncaughtExceptionHandler );
   
   signal( SIGABRT,   &__uncaughtSignalHandler );
   signal( SIGILL,      &__uncaughtSignalHandler );
   signal( SIGSEGV,   &__uncaughtSignalHandler );
   signal( SIGFPE,      &__uncaughtSignalHandler );
   signal( SIGBUS,      &__uncaughtSignalHandler );
   signal( SIGPIPE,   &__uncaughtSignalHandler );
#endif
   
   [IDEAAppletDebugger sharedInstance];
}

- (NSArray *)callstack {
   
   return [[IDEAAppletDebugger sharedInstance] callstack:MAX_CALLSTACK_DEPTH];
}

- (NSArray *)callstack:(NSInteger)depth; {
   
   NSMutableArray * array = [[NSMutableArray alloc] init];
   
   void * stacks[MAX_CALLSTACK_DEPTH] = { 0 };
   
   int frameCount = backtrace( stacks, MIN((int)depth, MAX_CALLSTACK_DEPTH) );
   if ( frameCount ) {
      
      char ** symbols = backtrace_symbols( stacks, (int)frameCount );
      if ( symbols ) {
         
         for ( int i = 0; i < frameCount; ++i ) {
            
            NSString * line = [NSString stringWithUTF8String:(const char *)symbols[i]];
            if ( 0 == [line length] )
               continue;
            
            IDEAAppletCallFrame * frame = [IDEAAppletCallFrame parse:line];
            if ( frame ) {
               
               [array addObject:frame];
            }
         }
         
         free( symbols );
      }
   }
   
   return array;
}

- (void)trap {
   
#if __SAMURAI_DEBUG__
#if defined(__ppc__)
   asm("trap");
#elif defined(__i386__) ||  defined(__amd64__)
   asm("int3");
#endif
#endif
}

- (void)trace {
   
   [self trace:MAX_CALLSTACK_DEPTH];
}

- (void)trace:(NSInteger)depth {
   
   NSArray * callstack = [self callstack:depth];
   
   if ( callstack && callstack.count ) {
      
      PRINT( [callstack description] );
   }
}

@end

#pragma mark -

@implementation NSObject(Debug)

//- (id)debugQuickLookObject {
//   
//#if __SAMURAI_DEBUG__
//   
//   IDEAAppletLogger  *stLogger   = [IDEAAppletLogger sharedInstance];
//   
//   [stLogger outputCapture];
//   
//   [self dump];
//   
//   [stLogger outputRelease];
//   
//   return stLogger.output;
//   
//#else   // #if __SAMURAI_DEBUG__
//   
//   return nil;
//   
//#endif   // #if __SAMURAI_DEBUG__
//}

- (void)dump {
   
   return;
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( Core, Debug ) {
   
}

DESCRIBE( before ) {
   
}

DESCRIBE( backtrace ) {
   
   NSArray * emptyFrames = [[IDEAAppletDebugger sharedInstance] callstack:0];
   EXPECTED( emptyFrames );
   EXPECTED( emptyFrames.count == 0 );
   
   NSArray * maxFrames = [[IDEAAppletDebugger sharedInstance] callstack:100000];
   EXPECTED( maxFrames );
   EXPECTED( maxFrames.count );
   
   NSArray * frames = [[IDEAAppletDebugger sharedInstance] callstack:1];
   EXPECTED( frames && frames.count );
   EXPECTED( [[frames objectAtIndex:0] isKindOfClass:[IDEAAppletCallFrame class]] );
   
   TRACE();
   
   [[IDEAAppletDebugger sharedInstance] trace];
   [[IDEAAppletDebugger sharedInstance] trace:0];
   [[IDEAAppletDebugger sharedInstance] trace:1];
   [[IDEAAppletDebugger sharedInstance] trace:100000];
}

DESCRIBE( after ) {
   
}

TEST_CASE_END

#endif   // #if __SAMURAI_TESTING__

#import "__pragma_pop.h"
