//
//  SVPaintView.m
//  MLPractice
//
//  Created by 威 沈 on 10/07/2018.
//  Copyright © 2018 ShenWei. All rights reserved.
//

#import "SVPaintView.h"
#define downColor [UIColor colorWithRed:63.0/255.0 green:217.0/255.0 blue:163.0/255.0 alpha:1.0]


#define upColorCGColor [UIColor colorWithRed:246.0/255.0 green:80.0/255.0 blue:77.0/255.0 alpha:1.0].CGColor
#define downColorCGColor [UIColor colorWithRed:62.0/255.0 green:217.0/255.0 blue:163.0/255.0 alpha:1.0].CGColor

#define lineColorCGColor [UIColor colorWithRed:92.0/255.0 green:75.0/255.0 blue:118.0/255.0 alpha:1.0].CGColor

#define fillDownColor2 CGContextSetRGBFillColor(myContext, 62.0/255.0, 217.0/255.0, 163.0/255.0, 0)

#define fillUpColor2 CGContextSetRGBFillColor(myContext, 246.0/255.0, 80.0/255.0, 77.0/255.0, 0)
#define fillUpColor CGContextSetRGBFillColor(myContext, 246.0/255.0, 80.0/255.0, 77.0/255.0, 1)
#define fillSelectedColor CGContextSetRGBFillColor(myContext, 244.0/255.0, 230.0/255.0, 227.0/255.0, 1)
#define fillDownColor CGContextSetRGBFillColor(myContext, 62.0/255.0, 217.0/255.0, 163.0/255.0, 1)
#define fillRectBorderColor CGContextSetRGBFillColor(myContext, 53.0/255.0, 50.0/255.0, 58.0/255.0, 1)
#define fillLineColor CGContextSetRGBFillColor(myContext, 114.0/255.0, 126.0/255.0, 190.0/255.0, 1)
#define watchColor [UIColor whiteColor]
#define fillOpenPriceColor CGContextSetRGBFillColor(myContext, 150.0/255.0, 126.0/255.0, 217.0/255.0, 1)
#define fillWhiteColor CGContextSetRGBFillColor(myContext, 255.0/255.0, 255.0/255.0, 255.0/255.0, 1)
#define fillBlueColor CGContextSetRGBFillColor(myContext, 0.0/255.0, 0.0/255.0, 255.0/255.0, 1)

@implementation SVPaintView
-(void)drawFuntion
{
    if([self.delegate respondsToSelector:@selector(valueOfYByX:)] == NO )
    {
        return;
    }
    CGFloat deltaX = 0.5;
    CGFloat y;
    CGPoint p = CGPointMake(0, 0);
    int j = 0;
    for (CGFloat i = self.west;i < self.east; i=i+0.01) {
        
        CGPoint p2;
        p2.x = i;
        p2.y =  [self.delegate valueOfYByX:i];
        
        if(j>0)
        {
            [self drawLogicalLineFrom:p to:p2 with:[UIColor redColor]];
        }
        p = p2;
        
        j++;
    }
    [self drawXline];
    [self drawYline];
}
- (CGFloat)transY:(CGFloat)oy
{
    return (self.coordinateY + oy);
}
-(void)coculateAllValue
{
    NSInteger countOfData = 0;
    
    
    self.maxy = 1000;
    self.miny = 0;
    
    
    self.coordinateX = 0;
    self.coordinateY = 0;
    
    
    
    
    self.maxy = self.frame.size.height;
    

    self.stepx = 1.0;
    
    
    self.stepy = 1.0;
    
    self.west = (self.coordinateX - self.frame.size.width)/self.stepx;
    self.east =  (self.coordinateX)/self.stepx;
    
    
    self.north = (self.coordinateY)/self.stepy;
    self.south = (self.coordinateY - self.frame.size.height)/self.stepy;
}
-(void)drawArrayData:(NSArray*)dataArray
{
    if(dataArray.count < 2)
    {
        return;
    }
    
    NSDictionary* startDic = dataArray[0];
    CGPoint startpoint = CGPointZero;
    CGPoint endPoint = CGPointZero;
    for (NSInteger i = 0; i< dataArray.count ;i++) {
        
        NSDictionary* dic = dataArray[i];
        double x = [dic[@"x"] doubleValue];
        double y = [dic[@"y"] doubleValue];
        
        endPoint.x = x;
        endPoint.y = y;
        if(i==0)
        {

        }
        else
        {
           
             [self drawLineFrom:startpoint to:endPoint withColor:[UIColor blackColor]];
        }
       
        
        startpoint = endPoint;
//        [self drawCircleAtPoint:CGPointMake(x, y) with:[UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1]];
    }
}
-(void)drawArrayData:(NSArray*)dataArray withColor:(UIColor*)color
{
    if(dataArray.count < 2)
    {
        return;
    }
    
    NSDictionary* startDic = dataArray[0];
    CGPoint startpoint = CGPointZero;
    CGPoint endPoint = CGPointZero;
    for (NSInteger i = 0; i< dataArray.count ;i++) {
        
        NSDictionary* dic = dataArray[i];
        double x = [dic[@"x"] doubleValue];
        double y = [dic[@"y"] doubleValue];
        
        endPoint.x = x;
        endPoint.y = y;
        if(i==0)
        {
            
        }
        else
        {
            
            [self drawLineFrom:startpoint to:endPoint withColor:color];
        }
        
        
        startpoint = endPoint;
        //        [self drawCircleAtPoint:CGPointMake(x, y) with:[UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1]];
    }
}
-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    if (self.contentOffsetValue < 0) {
        self.contentOffsetValue = 0;
    }
    [self coculateAllValue];
    
    for (NSArray* dataArray in self.dataList) {
        if([dataArray isKindOfClass:[NSArray class]])
        {
            [self drawArrayData:dataArray];
        }
    }

    for (NSArray* dataArray  in self.lineList) {
        if([dataArray isKindOfClass:[NSArray class]])
        {
            [self drawArrayData:dataArray withColor:[UIColor blueColor]];
        }
       
    }
    [self drawXline];
    [self drawYline];
    
}
@end
