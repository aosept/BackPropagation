//
//  MSDateUtils.m
//  MobiSentry
//
//  Created by tudou on 14-5-25.
//  Copyright (c) 2014年 MobiSentry. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "MSDateUtils.h"

@implementation MSDateUtils

//按照指定格式返回时间 (日期+具体时间",如"2月11日 20:19")
+(NSString *)swTimewithTimeStr:(NSNumber *)timeStr{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSTimeInterval timeInterval = [timeStr intValue];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSString *str =  [formatter stringFromDate:confromTimesp];
    return str;
}
+(NSString *)speTimewithTimeStr:(NSNumber *)timeStr{
  NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
  [formatter setDateFormat:@"MM月dd日 HH:mm:ss"];
  NSTimeInterval timeInterval = [timeStr intValue];
  NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timeInterval];
  NSString *str =  [formatter stringFromDate:confromTimesp];
  return str;
}

//返回时间所在日期当天的准确时间. (20:19)
+(NSString *)smallTimewithTimeStr:(NSNumber *)timeStr{
  NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
  [formatter setDateFormat:@" HH:mm:ss"];
  NSTimeInterval timeInterval = [timeStr intValue];
  NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timeInterval];
  NSString *str =  [formatter stringFromDate:confromTimesp];
  return str;
}

//判断两个日期是否是同一天
+(BOOL)isSameDay:(NSDate*)date1 date2:(NSDate*)date2
{
  NSCalendar* calendar = [NSCalendar currentCalendar];
  unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
  NSDateComponents* comp1 = [calendar components:unitFlags fromDate:date1];
  NSDateComponents* comp2 = [calendar components:unitFlags fromDate:date2];
  return [comp1 day]   == [comp2 day] &&
  [comp1 month] == [comp2 month] &&
  [comp1 year]  == [comp2 year];
}

//时间转时间戳
+ (NSString*)dateLongString
{
    NSDate *date = [NSDate date];
    return [MSDateUtils longStringFromDate:date];
}
+ (NSString*)dateString
{
    NSDate *date = [NSDate date];
    return [MSDateUtils stringFromDate:date];
}

+ (NSString*) longStringFromDate:(NSDate*)date {
    
    if (date == nil) {
        return @"---";
    }
    static NSDateFormatter *dateFormatter;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
        [dateFormatter setTimeZone:timeZone];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    
    NSString * stringDate = [dateFormatter stringFromDate:date];
    return stringDate;
}
+ (NSString*) stringFromDate:(NSDate*)date {
    
    if (date == nil) {
        return @"---";
    }
    static NSDateFormatter *dateFormatter;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
        [dateFormatter setTimeZone:timeZone];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    }
    
    NSString * stringDate = [dateFormatter stringFromDate:date];
    return stringDate;
}
+ (NSDate*) dateFromShortString:(NSString*)date {
    static NSDateFormatter *dateFormatter;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    }
    NSDate * nsDate = [dateFormatter dateFromString:date];
    return nsDate;
}
+ (NSTimeInterval) timeIntervalFromDateString:(NSString*)date {
    static NSDateFormatter *dateFormatter;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    NSDate * nsDate = [dateFormatter dateFromString:date];
    return [nsDate timeIntervalSince1970];
}
+ (NSTimeInterval) timeIntervalFromShortString:(NSString*)date {
    static NSDateFormatter *dateFormatter;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    }
    NSDate * nsDate = [dateFormatter dateFromString:date];
    return [nsDate timeIntervalSince1970];
}
+ (NSDate*)dateByAddingDays:(NSInteger)days toDate:(NSDate *)date
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    comps.day = days;
    
    return [calendar dateByAddingComponents: comps toDate: date options: 0];
}
+(id)dayOfWeek:(NSString*)dateStr
{
    static NSDateFormatter *dateFormatter2;
    if (!dateFormatter2) {
        dateFormatter2 = [[NSDateFormatter alloc] init];
        [dateFormatter2 setDateFormat:@"EEEE"];
    }
    NSDate * nsDate = [MSDateUtils dateFromShortString:dateStr];
   return  [dateFormatter2 stringFromDate:nsDate];
    
}
+(id)hourOfWeek:(NSString*)dateStr
{
    static NSDateFormatter *dateFormatter2;
    if (!dateFormatter2) {
        dateFormatter2 = [[NSDateFormatter alloc] init];
        [dateFormatter2 setDateFormat:@"HH"];
    }
    NSDate * nsDate = [MSDateUtils dateFromShortString:dateStr];
    return  [dateFormatter2 stringFromDate:nsDate];
    
}
+ (NSString*)hourOfWeekFromDate:(NSDate*)date {
    
    if (date == nil) {
        return @"---";
    }
    static NSDateFormatter *dateFormatter;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
        [dateFormatter setTimeZone:timeZone];
        [dateFormatter setDateFormat:@"HH"];
    }
    
    NSString * stringDate = [dateFormatter stringFromDate:date];
    return stringDate;
}
+(NSString *)timeStrFromtimeStamp:(NSNumber*)timeStr{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSTimeInterval timeInterval = [timeStr intValue];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSString *str =  [formatter stringFromDate:confromTimesp];
    return str;
}
+(NSString *)timeStrTotimeStamp:(NSNumber*)timeStr{
  //获取当前时间时间串
  //与获得时间串进行对比
  //根据时间差显示不同内容
  //返回内容
  int nowTime = [[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970];
  int gapTime = nowTime - [timeStr intValue];
  NSString *timeStamp = nil;
  if (gapTime < 60) {
    //一分钟内显示刚刚
    timeStamp = [NSString stringWithFormat:@"刚刚"];
  }else if(60<=gapTime && gapTime<60*60){
    //一分钟以上且一个小时之内的，显示“多少分钟前”，例如“5分钟前”
    timeStamp = [NSString stringWithFormat:@"%i分钟前",gapTime/60];
  }else if (60*60<=gapTime && gapTime<60*60*24*3){
    //1小时以上三天以内的显示“今天/昨天/前天+具体时间”
    NSString *dayStr ;
    int gapDay = gapTime/(60*60*24) ;
    switch (gapDay) {
      case 0:
      {
        //在24小时内,存在跨天的现象. 判断两个时间是否在同一天内.
        NSDate *date1 = [NSDate date];
        NSTimeInterval timeInterval = [timeStr intValue];
        NSDate *date2 = [NSDate dateWithTimeIntervalSince1970:timeInterval];
        BOOL idSameDay = [MSDateUtils isSameDay:date1 date2:date2];
        if (idSameDay == YES) {
          dayStr = @"";[NSString stringWithFormat:@"今天"];
        }else{
          dayStr = [NSString stringWithFormat:@"昨天"];
        }
      }
        break;
      case 1:
        dayStr = [NSString stringWithFormat:@"昨天"];
        break;
      case 2:
        dayStr = [NSString stringWithFormat:@"前天"];
        break;
      default:
        break;
    }
    //        timeStamp = [dayStr stringByAppendingString:[DSUtils smallTimewithTimeStr:timeStrs]];
    timeStamp = [NSString stringWithFormat:@"%@%@",dayStr,[MSDateUtils smallTimewithTimeStr:timeStr]];
  }else{
    //前天以后的显示"日期+具体时间",如"2月11日 20:19"
    timeStamp = [NSString stringWithString:[MSDateUtils speTimewithTimeStr:timeStr]];
  }
  return [timeStamp copy];
}
+(NSString*)uuid
{
    CFUUIDRef uuidRef =CFUUIDCreate(NULL);
    
    CFStringRef uuidStringRef =CFUUIDCreateString(NULL, uuidRef);
    
    CFRelease(uuidRef);
    
     NSString *uniqueId = (__bridge NSString *)uuidStringRef;
    return uniqueId;
}
+ (NSString *)timeIntervalToSting:(double)timeInterval
{
    NSString *messageTimeStr = @"";
    
    NSTimeInterval messagetimeInter = timeInterval;
    NSString *currentTimeStr = [MSDateUtils dateLongString];
    NSTimeInterval currentTimeInter = [MSDateUtils timeIntervalFromDateString:currentTimeStr];
    
    int time = currentTimeInter - messagetimeInter;
    
    int limitTime = 60 *5;
    
    if (time > limitTime)
    {
        
        NSNumber *showTimeNumber = [NSNumber numberWithDouble:messagetimeInter];
        
        messageTimeStr = [MSDateUtils timeStrTotimeStamp: showTimeNumber];
    }
    else
    {
        
    }
    
    
    return messageTimeStr;
}
+(CGRect)relativeFrameForScreenWithView:(UIView *)v
{
    BOOL iOS7 = [[[UIDevice currentDevice] systemVersion] floatValue] >= 7;
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWeight = [UIScreen mainScreen].bounds.size.width;
    if (!iOS7) {
        screenHeight -= 20;
    }
    UIView *view = v;
    CGFloat x = .0;
    CGFloat y = .0;
    while (view.frame.size.width != screenWeight || view.frame.size.height != screenHeight) {
        x += view.frame.origin.x;
        y += view.frame.origin.y;
        view = view.superview;
        if ([view isKindOfClass:[UIScrollView class]]) {
            x -= ((UIScrollView *) view).contentOffset.x;
            y -= ((UIScrollView *) view).contentOffset.y;
        }
    }
    return CGRectMake(x, y, v.frame.size.width, v.frame.size.height);
}
+(UIColor *)hexStringToColor: (NSString *) stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return [UIColor blackColor];
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}
@end
