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

#import "NSArray+Extension.h"
#import "NSObject+Extension.h"

#import "IDEAAppletUnitTest.h"

#import "__pragma_push.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation NSArray(Extension)

- (id)serialize
{
   if (0 == [self count])
   {
      return nil;
      
   } /* End if () */
   
   NSMutableArray *stArray = [NSMutableArray array];
   
   for (NSObject * element in self)
   {
      [stArray addObject:[element serialize]];
      
   } /* End for () */
   
   return stArray;
}

- (void)unserialize:(id)aObject
{
   return;
}

- (void)zerolize
{
   return;
}

- (NSArray *)head:(NSUInteger)aCount
{
   if (0 == self.count || 0 == aCount)
   {
      return nil;
      
   } /* End if () */
   
   if (self.count < aCount)
   {
      return self;
      
   } /* End if () */
   
   NSRange   stRange;
   stRange.location  = 0;
   stRange.length    = aCount;
   
   return [self subarrayWithRange:stRange];
}

- (NSArray *)tail:(NSUInteger)aCount
{   
   if (0 == self.count || 0 == aCount)
   {
      return nil;
      
   } /* End if () */
   
   if (self.count < aCount)
   {
      return self;
      
   } /* End if () */
   
   NSRange   stRange;
   stRange.location  = self.count - aCount;
   stRange.length    = aCount;
   
   return [self subarrayWithRange:stRange];
}

- (NSString *)join
{
   return [self join:nil];
}

- (NSString *)join:(NSString *)aDelimiter
{
   if (0 == self.count)
   {
      return @"";
      
   } /* End if () */
   else if (1 == self.count)
   {
      return [[self objectAtIndex:0] description];
      
   } /* End else if () */
   else
   {
      NSMutableString   *stResult   = [NSMutableString string];
      
      for (NSUInteger H = 0; H < self.count; ++H)
      {
         [stResult appendString:[[self objectAtIndex:H] description]];
         
         if (aDelimiter)
         {
            if (H + 1 < self.count)
            {
               [stResult appendString:aDelimiter];
               
            }  /* End if () */
            
         } /* End if () */
         
      } /* End for () */
      
      return stResult;
   }
}

#pragma mark -

- (id)safeObjectAtIndex:(NSUInteger)index
{
   if (index >= self.count)
   {
      return nil;
      
   } /* End if () */
   
   return [self objectAtIndex:index];
}

- (id)safeSubarrayWithRange:(NSRange)aRange
{
   if (0 == self.count)
   {
      return [NSArray array];
      
   } /* End if () */
   
   if (aRange.location >= self.count)
   {
      return [NSArray array];
      
   } /* End if () */
   
   aRange.length = MIN(aRange.length, self.count - aRange.location);
   if (0 == aRange.length)
   {
      return [NSArray array];
      
   } /* End if () */
   
   return [self subarrayWithRange:NSMakeRange(aRange.location, aRange.length)];
}

- (id)safeSubarrayFromIndex:(NSUInteger)aIndex
{
   if (0 == self.count)
   {
      return [NSArray array];
      
   } /* End if () */
   
   if (aIndex >= self.count)
   {
      return [NSArray array];
      
   } /* End if () */
   
   return [self safeSubarrayWithRange:NSMakeRange(aIndex, self.count - aIndex)];
}

- (id)safeSubarrayWithCount:(NSUInteger)aCount
{
   if (0 == self.count)
   {
      return [NSArray array];
      
   } /* End if () */
   
   return [self safeSubarrayWithRange:NSMakeRange(0, aCount)];
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE(Core, NSArray_Extension)
{
   NSArray * _testArray;
}

DESCRIBE(before)
{
   _testArray = @[ @"1", @"2", @"3", @"4", @"5", @"6" ];
}

DESCRIBE(head/tail)
{
   NSArray * head4 = [_testArray head:4];
   
   EXPECTED(head4.count == 4);
   EXPECTED([head4[0] isEqualToString:@"1"]);
   EXPECTED([head4[1] isEqualToString:@"2"]);
   EXPECTED([head4[2] isEqualToString:@"3"]);
   EXPECTED([head4[3] isEqualToString:@"4"]);
   
   NSArray * tail4 = [_testArray tail:4];
   
   EXPECTED(tail4.count == 4);
   EXPECTED([tail4[0] isEqualToString:@"3"]);
   EXPECTED([tail4[1] isEqualToString:@"4"]);
   EXPECTED([tail4[2] isEqualToString:@"5"]);
   EXPECTED([tail4[3] isEqualToString:@"6"]);
}

DESCRIBE(join)
{
   NSString * string = [_testArray join];
   
   EXPECTED(string.length == 6);
   EXPECTED([string isEqualToString:@"123456"]);
   
   NSString * string2 = [_testArray join:@"_"];
   
   EXPECTED(string2.length == 11);
   EXPECTED([string2 isEqualToString:@"1_2_3_4_5_6"]);
}

DESCRIBE(empty)
{
   NSArray * empty = [NSArray array];
   
   EXPECTED(nil == [empty safeObjectAtIndex:0]);
   EXPECTED(nil == [empty safeObjectAtIndex:99]);
}

DESCRIBE(sub array)
{
   EXPECTED(nil != [_testArray safeObjectAtIndex:0]);
   EXPECTED(nil != [_testArray safeObjectAtIndex:1]);
   EXPECTED(nil != [_testArray safeObjectAtIndex:2]);
   EXPECTED(nil != [_testArray safeObjectAtIndex:3]);
   EXPECTED(nil != [_testArray safeObjectAtIndex:4]);
   EXPECTED(nil != [_testArray safeObjectAtIndex:5]);
   
   EXPECTED(nil == [_testArray safeObjectAtIndex:6]);
   EXPECTED(nil == [_testArray safeObjectAtIndex:7]);
   
   NSArray * subArray = [_testArray safeSubarrayWithRange:NSMakeRange(0, 6)];
   
   EXPECTED(subArray.count == 6);
   EXPECTED([subArray[0] isEqualToString:@"1"]);
   EXPECTED([subArray[1] isEqualToString:@"2"]);
   EXPECTED([subArray[2] isEqualToString:@"3"]);
   EXPECTED([subArray[3] isEqualToString:@"4"]);
   EXPECTED([subArray[4] isEqualToString:@"5"]);
   EXPECTED([subArray[5] isEqualToString:@"6"]);
   
   NSArray * subArray2 = [_testArray safeSubarrayWithRange:NSMakeRange(0, 99)];
   
   EXPECTED(subArray2.count == 6);
   EXPECTED([subArray2[0] isEqualToString:@"1"]);
   EXPECTED([subArray2[1] isEqualToString:@"2"]);
   EXPECTED([subArray2[2] isEqualToString:@"3"]);
   EXPECTED([subArray2[3] isEqualToString:@"4"]);
   EXPECTED([subArray2[4] isEqualToString:@"5"]);
   EXPECTED([subArray2[5] isEqualToString:@"6"]);
   
   NSArray * subArray3 = [_testArray safeSubarrayWithRange:NSMakeRange(5, 99)];
   
   EXPECTED(subArray3.count == 1);
   EXPECTED([subArray3[0] isEqualToString:@"6"]);
   
   NSArray * subArray4 = [_testArray safeSubarrayWithRange:NSMakeRange(6, 99)];
   
   EXPECTED(subArray4.count == 0);
   
   NSArray * subArray5 = [_testArray safeSubarrayWithRange:NSMakeRange(99, 99)];
   
   EXPECTED(subArray5.count == 0);
}

DESCRIBE(after)
{
   _testArray = nil;
}

TEST_CASE_END

#endif   // #if __SAMURAI_TESTING__

#import "__pragma_pop.h"
