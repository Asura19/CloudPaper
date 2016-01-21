//
//  NSDate+CP.m
//  CloudPaper
//
//  Created by Phoenix on 16/1/21.
//  Copyright © 2016年 Phoenix. All rights reserved.
//

#import "NSDate+CP.h"

@implementation NSDate (CP)

+ (NSString *)showDate:(NSDate *)date {
    // 时间处理
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
//    [fmt setDateFormat:@"EEE MMM dd HH:mm:ss Z yyyy"];
                     //星期四 1月 21 01:08:03 +0800 2016
    [fmt setDateFormat:@"EEE HH:mm yyyy年MMMdd日"];
    NSString *dateString;
    dateString = [fmt stringFromDate:date];
    
    if ([date isToday]) {
        dateString = [dateString stringByReplacingCharactersInRange:NSMakeRange(0, 2) withString:@"今天"];
    } else if ([date isYesterday]) {
        dateString = [dateString stringByReplacingCharactersInRange:NSMakeRange(0, 2) withString:@"昨天"];
    } else {
        dateString = [dateString stringByReplacingOccurrencesOfString:@"周" withString:@"星期"];
    }
    return dateString;
}

/**
 *  是否为今天
 */
- (BOOL)isToday
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitDay | NSCalendarUnitMonth |  NSCalendarUnitYear;
    
    // 1.获得当前时间的年月日
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    
    // 2.获得self的年月日
    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];
    
    return
    (selfCmps.year == nowCmps.year) &&
    (selfCmps.month == nowCmps.month) &&
    (selfCmps.day == nowCmps.day);
}

/**
 *  是否为昨天
 */
- (BOOL)isYesterday
{
    NSDate *now = [NSDate date];
    NSDate *nowDate = [now dateToYMD];
    NSDate *selfDate = [self dateToYMD];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *cmps = [calendar components:NSCalendarUnitDay fromDate:selfDate toDate:nowDate options:0];
    return cmps.day == 1;
}

- (NSDate *)dateToYMD
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSString *dateStr = [fmt stringFromDate:self];
    return [fmt dateFromString:dateStr];
}
@end
