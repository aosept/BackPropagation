//
//  MSDateUtils.h
//  MobiSentry
//
//  Created by tudou on 14-5-25.
//  Copyright (c) 2014年 MobiSentry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#define SafeString(text)            [NSString stringWithFormat:@"%@", text]
#define SafeStringExt(text,ext)     [NSString stringWithFormat:@"%@.%@", text,ext]
#define SafeStringJoin(text,ext)    [NSString stringWithFormat:@"%@%@", text,ext]
#define SafeStringLog(text,ext)     [NSString stringWithFormat:@"%@\n%@", text,ext]
#define SafeStringConfig(text)      [NSString stringWithFormat:@"%@.Config", text]
#define DailyContentFont @"Helvetica" //@"CTXingKaiSJ"//@"TrebuchetMS" ///@"AaWanWan" //
#define DailyTitleFont @"Arial-BoldMT"// @"AaWanWan"//
#define _mDatilContentWidth 355.0

#define kaipan 1
#define shoupan 2
#define zuidi 4
#define zuigao 3
#define huanshou 5


//#define helpForUIDesignAlways @"helpForUIDesignAlways"
#define debug_function_and_line_info NSLog(@"%s:%d",__func__,__LINE__)
#ifdef DEBUG
#define SVLog(format, ...) NSLog(format, ## __VA_ARGS__)
#else
#define SVLog(format, ...)
#endif

#import "AppDelegate.h"

static void runOnMainQueueWithoutDeadlocking(void (^block)(void))
{
    if ([NSThread isMainThread])
    {
        block();
    }
    else
    {
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}

@interface MSDateUtils: NSObject
+(NSTimeInterval)timeIntervalFromDateString:(NSString*)date;
+(NSString*)timeStrTotimeStamp:(NSNumber*)timeStr;
+(BOOL)isSameDay:(NSDate*)date1 date2:(NSDate*)date2;
+(NSString*)speTimewithTimeStr:(NSNumber *)timeStr;
+(NSString*)swTimewithTimeStr:(NSNumber *)timeStr;
+(NSString*)stringFromDate:(NSDate*)date ;
+(id)dayOfWeek:(NSString*)dateStr;
+(id)hourOfWeek:(NSString*)dateStr;
+(NSString*)longStringFromDate:(NSDate*)date;
+(NSString*)hourOfWeekFromDate:(NSDate*)date;
+(NSTimeInterval)timeIntervalFromShortString:(NSString*)date;
+(NSString*)timeStrFromtimeStamp:(NSNumber*)timeStr;
+(NSString*)uuid;
+(NSString*)dateString;
+(NSString*)dateLongString;
+(CGRect)relativeFrameForScreenWithView:(UIView *)v;
+ (NSString *)timeIntervalToSting:(double)timeInterval;
+(UIColor *) hexStringToColor: (NSString *) stringToConvert;
@end
