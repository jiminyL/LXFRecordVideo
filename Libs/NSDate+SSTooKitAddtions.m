#import "NSDate+SSTooKitAddtions.h"

@implementation NSDate (SSTooKitAddtions)

+ (NSDate *)localDateWithDate:(NSDate *)date
{    
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    
    NSInteger interval = [zone secondsFromGMTForDate: date];
    
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    
    return localeDate;
}

+ (NSDate*)convertDateFromString:(NSString*)uiDate
{
    if (uiDate.length > 0) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
        [formatter setDateFormat:@"yy-MM-dd HH:mm"];
        NSDate *date=[formatter dateFromString:uiDate];
        return date;
    }else {
        return nil;
    }
}

+ (NSDate *)converDateFromString2:(NSString *)uiDate
{
    if (uiDate.length > 0) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *date=[formatter dateFromString:uiDate];
        return date;
    }else {
        return nil;
    }
}

+ (NSDate *)converDateFromString3:(NSString *)uiDate
{
    if (uiDate.length > 0) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *date=[formatter dateFromString:uiDate];
        return date;
    }else {
        return nil;
    }
}

+ (NSDate *)converDateFromString4:(NSString *)uiDate
{
    if (uiDate.length > 0) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
        [formatter setDateFormat:@"yyyy-MM-dd HH"];
        NSDate *date=[formatter dateFromString:uiDate];
        return date;
    }else {
        return nil;
    }
}

+ (NSString *)dateToStrStyle1WithDate:(NSDate *)date
{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
    [dateFormat setDateFormat:@"MM-dd HH:mm"];//设定时间格式
    
    NSString *dateString = [dateFormat stringFromDate:date]; //求出当天的时间字符串，当更改时间格式时，时间字符串也能随之改变
    return dateString;
}

+ (NSString *)dateToStrStyle2WithDate:(NSDate *)date
{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
    [dateFormat setDateFormat:@"yyyy/MM/dd"];//设定时间格式
    
    NSString *dateString = [dateFormat stringFromDate:date]; //求出当天的时间字符串，当更改时间格式时，时间字符串也能随之改变
    return dateString;
}

+ (NSString *)dateToStrStyle3WithDate:(NSDate *)date
{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
    [dateFormat setDateFormat:@"yyyy/MM/dd HH:mm"];//设定时间格式
    
    NSString *dateString = [dateFormat stringFromDate:date]; //求出当天的时间字符串，当更改时间格式时，时间字符串也能随之改变
    return dateString;
}

+ (NSString *)dateToStrStyle4WithDate:(NSDate *)date
{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];//设定时间格式
    
    NSString *dateString = [dateFormat stringFromDate:date]; //求出当天的时间字符串，当更改时间格式时，时间字符串也能随之改变
    return dateString;
}

+ (NSString *)dateToStrStyle5WithDate:(NSDate *)date
{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
    [dateFormat setDateFormat:@"yyyy-MM-dd"];//设定时间格式
    
    NSString *dateString = [dateFormat stringFromDate:date]; //求出当天的时间字符串，当更改时间格式时，时间字符串也能随之改变
    return dateString;
}

+ (NSString *)dateToStrStyle6WithDate:(NSDate *)date
{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
    [dateFormat setDateFormat:@"MM-dd"];//设定时间格式
    
    NSString *dateString = [dateFormat stringFromDate:date]; //求出当天的时间字符串，当更改时间格式时，时间字符串也能随之改变
    return dateString;
}

+ (NSString *)dateToStrStyle7WithDate:(NSDate *)date
{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
    [dateFormat setDateFormat:@"yyyy_MM_dd_HH_mm_ss"];//设定时间格式
    
    NSString *dateString = [dateFormat stringFromDate:date]; //求出当天的时间字符串，当更改时间格式时，时间字符串也能随之改变
    return dateString;
}

+ (NSString *)dateToStrWithStartDate:(NSDate *)startDate andEndDate:(NSDate *)endDate
{
    NSDateFormatter* startDateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
    [startDateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];//设定时间格式
    
    NSDateFormatter* endDateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
    [endDateFormat setDateFormat:@"HH:mm"];//设定时间格式
    
    NSString *startStr = [startDateFormat stringFromDate:startDate];
    NSString *endStr = [endDateFormat stringFromDate:endDate];
    
    NSString *resultStr = [NSString stringWithFormat:@"%@ - %@", startStr, endStr];
    return resultStr;
}
//通过时间戳转换时间字符串
+ (NSString *)timeStrWithUnixTimeStamp:(NSInteger)unixTime
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:unixTime];
    return [self dateToStrStyle2WithDate:date];
}

@end
