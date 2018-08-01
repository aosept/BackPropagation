//
//  SVLineView.m
//  MLPractice
//
//  Created by 威 沈 on 08/06/2018.
//  Copyright © 2018 ShenWei. All rights reserved.
//

#import "SVLineView.h"

@implementation SVLineView

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
  
    CGContextRef myContext = UIGraphicsGetCurrentContext();
    [self drawBackGround:myContext rect:rect];
    
    CGFloat x,y,w,h;
    x = 0;
    w = self.frame.size.width;
    h = 0.5;
    y = (self.frame.size.height-h)/2.0;
    
    [self drawDashLineFrom:CGPointMake(x, y) to:CGPointMake(w, y)];
}
- (void)drawDashLineFrom:(CGPoint)point1 to:(CGPoint)point2
{
    
    CGPoint from,to;
    
    //    BOOL coor = NO;
    
   
    CGFloat x,y;
    x = point1.x;
    y = point1.y;
   
    from.x = x;
    from.y = y;
    
    x = point2.x;
    y = point2.y;
    
    to.x = x;
    to.y = y;
    
    
    CGContextRef myContext = (CGContextRef)UIGraphicsGetCurrentContext();
    CGContextBeginPath (myContext);
    
    CGContextSetLineWidth(myContext, 0.5);
    
    CGContextSetLineCap(myContext,kCGLineCapButt);
    //1.3  虚实切换
    CGFloat length[] = {2,2,2};
    CGContextSetLineDash(myContext, 0, length, 3);
    
    CGContextSetStrokeColorWithColor(myContext, [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:255.0/255.0 alpha:1.0].CGColor);
    
    
    CGContextMoveToPoint(myContext,from.x,from.y);
    CGContextAddLineToPoint(myContext,to.x, to.y);
    CGContextStrokePath(myContext);
}
- (void)drawBackGround:(CGContextRef) myContext rect:(CGRect)rect
{
//    CGFloat x,y,w,h;
//    x = 0;
//    y = 0;
//    w = rect.size.width;
//    h = rect.size.height;
//    
//    CGContextSaveGState(myContext);
//    
//    CGContextSetRGBFillColor(myContext, 255.0/255.0, 255.0/255.0, 255.0/255.0, 1);
//    CGContextFillRect(myContext, CGRectMake(x, y, w, h));
}
@end
