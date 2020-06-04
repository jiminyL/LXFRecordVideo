#import <Foundation/Foundation.h>

@interface NSDate (SSTooKitAddtions)

+ (NSDate *)localDateWithDate:(NSDate *)date;

+ (NSDate *)convertDateFromString:(NSString*)uiDate;
+ (NSDate *)converDateFromString2:(NSString *)uiDate;
+ (NSDate *)converDateFromString3:(NSString *)uiDate;
+ (NSDate *)converDateFromString4:(NSString *)uiDate;

+ (NSString *)dateToStrStyle1WithDate:(NSDate *)date;
+ (NSString *)dateToStrStyle2WithDate:(NSDate *)date;
+ (NSString *)dateToStrStyle3WithDate:(NSDate *)date;
+ (NSString *)dateToStrStyle4WithDate:(NSDate *)date;
+ (NSString *)dateToStrStyle5WithDate:(NSDate *)date;
+ (NSString *)dateToStrStyle6WithDate:(NSDate *)date;
+ (NSString *)dateToStrStyle7WithDate:(NSDate *)date;

+ (NSString *)dateToStrWithStartDate:(NSDate *)startDate andEndDate:(NSDate *)endDate;

//通过时间戳转换时间字符串
+ (NSString *)timeStrWithUnixTimeStamp:(NSInteger)unixTime;

@end
