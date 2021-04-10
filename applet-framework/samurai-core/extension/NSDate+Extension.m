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

#import "NSDate+Extension.h"

#import "IDEAAppletUnitTest.h"

#import "__pragma_push.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation NSDate(Extension)

@def_prop_dynamic ( NSInteger ,   apple_year    );
@def_prop_dynamic ( NSInteger ,   apple_month   );
@def_prop_dynamic ( NSInteger ,   apple_day     );
@def_prop_dynamic ( NSInteger ,   apple_hour    );
@def_prop_dynamic ( NSInteger ,   apple_minute  );
@def_prop_dynamic ( NSInteger ,   apple_second  );
@def_prop_dynamic ( NSInteger ,   apple_weekday );

- (NSInteger)apple_year {
   
#ifdef __IPHONE_8_0
   return [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:self].year;
#else
   return [[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:self].year;
#endif
}

- (NSInteger)apple_month {
   
#ifdef __IPHONE_8_0
   return [[NSCalendar currentCalendar] components:NSCalendarUnitMonth fromDate:self].month;
#else
   return [[NSCalendar currentCalendar] components:NSMonthCalendarUnit fromDate:self].month;
#endif
}

- (NSInteger)apple_day {
   
#ifdef __IPHONE_8_0
   return [[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:self].day;
#else
   return [[NSCalendar currentCalendar] components:NSDayCalendarUnit fromDate:self].day;
#endif
}

- (NSInteger)apple_hour {
   
#ifdef __IPHONE_8_0
   return [[NSCalendar currentCalendar] components:NSCalendarUnitHour fromDate:self].hour;
#else
   return [[NSCalendar currentCalendar] components:NSHourCalendarUnit fromDate:self].hour;
#endif
}

- (NSInteger)apple_minute {
   
#ifdef __IPHONE_8_0
   return [[NSCalendar currentCalendar] components:NSCalendarUnitMinute fromDate:self].minute;
#else
   return [[NSCalendar currentCalendar] components:NSMinuteCalendarUnit fromDate:self].minute;
#endif
}

- (NSInteger)apple_second {
   
#ifdef __IPHONE_8_0
   return [[NSCalendar currentCalendar] components:NSCalendarUnitSecond fromDate:self].second;
#else
   return [[NSCalendar currentCalendar] components:NSSecondCalendarUnit fromDate:self].second;
#endif
}

- (WeekdayType)apple_weekday {
   
#ifdef __IPHONE_8_0
   return (WeekdayType)[[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:self].weekday;
#else
   return (WeekdayType)[[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:self].weekday;
#endif
}

+ (NSTimeInterval)unixTime {
   
   return [[NSDate date] timeIntervalSince1970];
}

+ (NSString *)unixDate {
   
   return [[NSDate date] toString:@"yyyy/MM/dd HH:mm:ss z"];
}

+ (NSDate *)fromString:(NSString *)aString {
   
   if (nil == aString || 0 == aString.length) {
      
      return nil;
      
   } /* End if () */
   
   NSDate   *stDate = [[NSDate format:@"yyyy/MM/dd HH:mm:ss z"] dateFromString:aString];
   if (nil == stDate) {
      
      stDate = [[NSDate format:@"yyyy-MM-dd HH:mm:ss z"] dateFromString:aString];
      if (nil == stDate) {
         
         stDate = [[NSDate format:@"yyyy-MM-dd HH:mm:ss"] dateFromString:aString];
         if (nil == stDate) {
            
            stDate = [[NSDate format:@"yyyy/MM/dd HH:mm:ss"] dateFromString:aString];
            
         } /* End if () */
         
      } /* End if () */
      
   } /* End if () */
   
   return stDate;
}

+ (NSDateFormatter *)format {
   
   return [self format:@"yyyy/MM/dd HH:mm:ss z"];
}

+ (NSDateFormatter *)format:(NSString *)aFormat {
   
   return [self format:aFormat timeZoneGMT:[[NSTimeZone defaultTimeZone] secondsFromGMT]];
}

+ (NSDateFormatter *)format:(NSString *)aFormat timeZoneGMT:(NSInteger)aSeconds {
   
   static __strong NSMutableDictionary * __formatters = nil;
   
   if (nil == __formatters) {
      
      __formatters = [[NSMutableDictionary alloc] init];
      
   } /* End if () */
   
   NSString          *szKey      = [NSString stringWithFormat:@"%@ %ld", aFormat, (long)aSeconds];
   NSDateFormatter   *stFormatter= [__formatters objectForKey:szKey];
   if (nil == stFormatter) {
      
      stFormatter = [[NSDateFormatter alloc] init];
      [stFormatter setDateFormat:aFormat];
      [stFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:aSeconds]];
      [__formatters setObject:stFormatter forKey:szKey];
      
   } /* End if () */
   
   return stFormatter;
}

+ (NSDateFormatter *)format:(NSString *)aFormat timeZoneName:(NSString *)aName {
   
   static __strong NSMutableDictionary * __formatters = nil;
   
   if (nil == __formatters) {
      
      __formatters = [[NSMutableDictionary alloc] init];
      
   } /* End if () */
   
   NSString          *szKey         = [NSString stringWithFormat:@"%@ %@", aFormat, aName];
   NSDateFormatter   *stFormatter   = [__formatters objectForKey:szKey];
   
   if (nil == stFormatter) {
      
      stFormatter = [[NSDateFormatter alloc] init];
      [stFormatter setDateFormat:aFormat];
      [stFormatter setTimeZone:[NSTimeZone timeZoneWithName:aName]];
      [__formatters setObject:stFormatter forKey:szKey];
      
   } /* End if () */
   
   return stFormatter;
}

- (NSString *)toString:(NSString *)aFormat {
   
   return [self toString:aFormat timeZoneGMT:[[NSTimeZone defaultTimeZone] secondsFromGMT]];
}

- (NSString *)toString:(NSString *)aFormat timeZoneGMT:(NSInteger)aSeconds {
   
   return [[NSDate format:aFormat timeZoneGMT:aSeconds] stringFromDate:self];
}

- (NSString *)toString:(NSString *)aFormat timeZoneName:(NSString *)aName {
   
   return [[NSDate format:aFormat timeZoneName:aName] stringFromDate:self];
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE(Core, NSDate_Extension) {
   
   
}

DESCRIBE(before) {
   
}

DESCRIBE(Format1) {
   
   NSDate * date = [NSDate fromString:@"1983/08/15 15:15:00 GMT+8"];
   EXPECTED(date.year == 1983);
   EXPECTED(date.month == 8);
   EXPECTED(date.day == 15);
   EXPECTED(date.hour == 15);
   EXPECTED(date.minute == 15);
   EXPECTED(date.second == 0);
   EXPECTED(date.weekday == WeekdayType_Monday);
   
   NSString * string = [date toString:@"yyyy/MM/dd HH:mm:ss z" timeZoneGMT:8 * HOUR];
   EXPECTED([string isEqualToString:@"1983/08/15 15:15:00 GMT+8"]);
}

DESCRIBE(Format2) {
   
   NSDate * date = [NSDate fromString:@"1983-08-15 15:15:00 GMT+8"];
   EXPECTED(date.year == 1983);
   EXPECTED(date.month == 8);
   EXPECTED(date.day == 15);
   EXPECTED(date.hour == 15);
   EXPECTED(date.minute == 15);
   EXPECTED(date.second == 0);
   EXPECTED(date.weekday == WeekdayType_Monday);
   
   NSString * string = [date toString:@"yyyy-MM-dd HH:mm:ss z" timeZoneGMT:8 * HOUR];
   EXPECTED([string isEqualToString:@"1983-08-15 15:15:00 GMT+8"]);
}

DESCRIBE(Format3) {
   
   NSDate * date = [NSDate fromString:@"1983/08/15 15:15:00"];
   EXPECTED(date.year == 1983);
   EXPECTED(date.month == 8);
   EXPECTED(date.day == 15);
   EXPECTED(date.hour == 15);
   EXPECTED(date.minute == 15);
   EXPECTED(date.second == 0);
   EXPECTED(date.weekday == WeekdayType_Monday);
   
   NSString * string = [date toString:@"yyyy/MM/dd HH:mm:ss" timeZoneGMT:8 * HOUR];
   EXPECTED([string isEqualToString:@"1983/08/15 15:15:00"]);
}

DESCRIBE(Format4) {
   
   NSDate * date = [NSDate fromString:@"1983-08-15 15:15:00"];
   EXPECTED(date.year == 1983);
   EXPECTED(date.month == 8);
   EXPECTED(date.day == 15);
   EXPECTED(date.hour == 15);
   EXPECTED(date.minute == 15);
   EXPECTED(date.second == 0);
   EXPECTED(date.weekday == WeekdayType_Monday);
   
   NSString * string = [date toString:@"yyyy-MM-dd HH:mm:ss" timeZoneGMT:8 * HOUR];
   EXPECTED([string isEqualToString:@"1983-08-15 15:15:00"]);
}

DESCRIBE(Unix format) {
   
   NSTimeInterval unixTime = [NSDate unixTime];
   EXPECTED(unixTime >= NSTimeIntervalSince1970);
   
   NSString * unixDateString = [NSDate unixDate];
   EXPECTED(unixDateString);
   
   NSDate * unixDate = [NSDate fromString:unixDateString];
   EXPECTED(nil != unixDate);
   
   NSString * unixDateString2 = [unixDate toString:@"yyyy/MM/dd HH:mm:ss z" timeZoneGMT:8 * HOUR];
   EXPECTED([unixDateString2 isEqualToString:unixDateString]);
}

DESCRIBE(after) {
   
}

TEST_CASE_END

#endif   // #if __SAMURAI_TESTING__

#import "__pragma_pop.h"
