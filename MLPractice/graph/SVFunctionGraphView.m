//
//  SVFunctionGraphView.m
//  MLPractice
//
//  Created by 威 沈 on 01/06/2018.
//  Copyright © 2018 ShenWei. All rights reserved.
//

#import "SVFunctionGraphView.h"

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

@implementation SVFunctionGraphView

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

-(void)drawDistributionGraph
{
    
}
-(void)coculateAllValue
{
    NSInteger countOfData = 0;
    
   
    self.maxy = 1000;
    self.miny = 0;
    
    
    self.coordinateX = self.frame.size.width/2.0;
    self.coordinateY = self.frame.size.height/2.0;
    
    
    
    if(self.style == SVFunctionGraphStyleByFunction)
    {
        countOfData = 10;
        
        if(countOfData > 1)
        {
            CGFloat edge = 10;
            self.stepx = (self.frame.size.width - self.coordinateX - 2*edge)/(countOfData-1);
        }
        else
        {
            self.stepx = self.frame.size.width - self.coordinateX;
        }
        
        self.maxy = 2;
    }
    else
    {
        double maxx = -999,maxy = -999;
        for (NSDictionary* dic in self.dataList) {
            
            double x = [dic[@"x"] doubleValue];
            double y = [dic[@"y"] doubleValue];
            
            if (fabs(x) > maxx) {
                maxx = fabs(x);
            }
            
            if (fabs(y) > maxy) {
                maxy = fabs(y);
            }
            
        }
        self.maxy = maxy;
        
        CGFloat edge = 10;
        self.stepx = (self.frame.size.width - self.coordinateX - 2*edge)/(maxx+1);
    }
    
    self.stepy = self.coordinateY/self.maxy;
    
    self.west = (self.coordinateX - self.frame.size.width)/self.stepx;
    self.east =  (self.coordinateX)/self.stepx;
    
    
    self.north = (self.coordinateY)/self.stepy;
    self.south = (self.coordinateY - self.frame.size.height)/self.stepy;
}
-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    if (self.contentOffsetValue < 0) {
        self.contentOffsetValue = 0;
    }
    [self coculateAllValue];
    if(self.style == SVFunctionGraphStyleByFunction)
    {
        [self drawFuntion];
    }
    else
    {
        for (NSDictionary* dic in self.dataList) {
            double x = [dic[@"x"] doubleValue];
            double y = [dic[@"y"] doubleValue];
            double z = [dic[@"z"] doubleValue];
//            z = z+10;
//            [self drawCircleAtPoint:CGPointMake(x, y) with:[UIColor colorWithRed:z/20.0 green:0.0 blue:0.0 alpha:1]];
            if(z < 0)
                [self drawCircleAtPoint:CGPointMake(x, y) with:[UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:1]];
            else if(z == 0)
                [self drawCircleAtPoint:CGPointMake(x, y) with:[UIColor colorWithRed:0.0 green:0.0 blue:1.0 alpha:1]];
            else
                [self drawCircleAtPoint:CGPointMake(x, y) with:[UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1]];
        }
        
       
    }
//    [self drawYlineValue];
//    [self drawXlineValue];
    [self drawXline];
    [self drawYline];

}

@end
