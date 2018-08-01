//
//  NSString+Expand.m
//  MysqlManager
//
//  Created by 威 沈 on 10/05/2017.
//  Copyright © 2017 SV. All rights reserved.
//

#import "NSString+Expand.h"
#define IOS7LATER 7.0<=[[UIDevice currentDevice].systemVersion doubleValue]

@implementation NSString (Expand)
-(CGSize)getSizeoffont:(UIFont *)font withMaxWidth:(double)maxWidth
{
    CGSize size;
    if (IOS7LATER) {
        NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil];
        size= [self  boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    }
    else
    {
        size=[self
              sizeWithFont:font constrainedToSize:CGSizeMake(maxWidth,MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
    }
    return size;
}

@end
