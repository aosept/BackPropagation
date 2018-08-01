//
//  SVMathView.m
//  GraphDemo
//
//  Created by 威 沈 on 28/04/2018.
//  Copyright © 2018 ShenWei. All rights reserved.
//

#import "SVMathView.h"
@interface SVMathView()
{
    
    CGPoint defaultCenter;
    double defaultRadius;
    double defaultLineWidth;
    double defaultHistogramWidth;
    CGContextRef* selfcontext;
    NSInteger index;
    CGFloat hStep;
    
}
@property (nonatomic,strong) NSArray* statistDataArray;

@end


@implementation SVMathView
-(NSArray*)colorArray
{
    if (_colorArray == nil) {
        _colorArray = @[];
    }
    return _colorArray;
}
- (void)drawScreenLineFrom:(CGPoint)point1 to:(CGPoint)point2 withColor:(UIColor*)color
{
    
    CGPoint from,to;
    from.x = point1.x;
    from.y = point1.y;
    
    to.x = point2.x;
    to.y = point2.y;
    
    //    NSLog(@"point1.x:%f,point1.y:%f,point2.x:%f,point2.y:%f",point1.x,point1.y,point2.x,point2.y);
    CGContextRef myContext = UIGraphicsGetCurrentContext();
    CGContextBeginPath (myContext);
    
    CGContextSetStrokeColorWithColor(myContext, [UIColor yellowColor].CGColor);
    CGContextSetLineWidth(myContext, 1.0);
    
    CGContextSetStrokeColorWithColor(myContext, color.CGColor);
    
    CGContextMoveToPoint(myContext,from.x,from.y);
    CGContextAddLineToPoint(myContext,to.x, to.y);
    CGContextStrokePath(myContext);
}
-(void)drawHistogramValue
{
    if([self.dataMartix count] > 0)
    {
        int lineNumber = 0;
        for (NSArray* dataList in self.dataMartix) {
            
            CGPoint p1;
            p1.x = 0;
            p1.y = 0;
            
            unsigned long step = [dataList count]/19;
            if (step < 1) {
                step = 1;
            }
            
            for (unsigned long i = 0; i< [dataList count]; i = i+ step) {
                
                NSNumber* number = dataList[i];
                
                p1.x = i*self.stepx;
                p1.y = 0;
                
                UIColor* color;
                if(lineNumber < self.colorArray.count)
                {
                    color = self.colorArray[lineNumber];
                }
                else
                {
                    color = [self randColor];
                    self.colorArray = [self.colorArray arrayByAddingObject:color];
                }
                [self drawNumber:i*(self.hStep) atPoint:p1];

            }
            
            
            lineNumber++;
        }
    }
}
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    [self coculateAllValue];
    
    defaultCenter.x = self.frame.size.width/2.0 -53;
    defaultCenter.y = self.frame.size.width/2.0 -50;
    defaultLineWidth = 5.0;
    defaultRadius = 80.0;
    defaultHistogramWidth = self.stepx;
    if(self.style == SVMathViewPie || self.style == SVMathViewSolidPie)
    {
        self.r = MIN(self.frame.size.width, self.frame.size.height);
        self.r = self.r/2.0;
        [self drawDataAsPieChart];
    }
    else if(self.style == SVMathViewMath2d)
    {
        if (self.contentOffsetValue  < 0) {
            self.contentOffsetValue = 0;
        }
        
        self.r = MIN(self.frame.size.width, self.frame.size.height);
        self.r = self.r/2.0;
        [self drawHistogram];
        [self drawHistogramValue];
        
        [self drawQline];
        
        if (fingerDown) {
            [self drawTouchValue];
        }
    }
    else
    {
        if (self.contentOffsetValue  < 0) {
            self.contentOffsetValue = 0;
        }
        
        
        
        [[UIColor grayColor] set];
        
        [self drawMoneyFlow];
        
        [self drawXline];
        [self drawYline];
    }
    
    
    
    
    
    
}
-(void)drawTouchValue
{
    CGPoint p1,p2,p3,p4;
    p1.x = 0;
    p1.y = (self.coordinateY - touchBeginPoint.y)/self.stepy;
    
    p2.x = (self.frame.size.width - self.coordinateX)/self.stepx;
    p2.y = p1.y;
    
    
    [self drawLogicalLineFrom:p1 to:p2 with:[UIColor redColor]];
    
    p1.x = (touchBeginPoint.x - self.coordinateX)/self.stepx;
    p1.y = 0;
    
    p2.x = p1.x;
    p2.y = self.north;
    
    
    [self drawLogicalLineFrom:p1 to:p2 with:[UIColor blackColor]];
    
    if (touchBeginPoint.x > self.frame.size.width/2) {
        p3.x = ((touchBeginPoint.x - self.coordinateX)/self.stepx)/2.0;
    }
    else
    {
        CGFloat x = (self.frame.size.width - touchBeginPoint.x)/2.0 + touchBeginPoint.x;
        p3.x = ((x - self.coordinateX)/self.stepx);
    }
    
    p3.y = (self.coordinateY - touchBeginPoint.y)/self.stepy;;
    [self drawArrowBox:p3];
    
    p4.x = (touchBeginPoint.x - self.coordinateX)/self.stepx;
    p4.y = 0;
    
    [self drawArrowBox2:p4];
    
}
-(void)drawQline
{
    CGPoint p1,p2;
    p1.x = (self.vq1-self.vMin)/self.hStep;
    p1.y = 0;
    
    p2.x = (self.vq1-self.vMin)/self.hStep;
    p2.y = self.maxy;
    
    [self drawLogicalLineFrom:p1 to:p2 with:[UIColor greenColor]];
    
    p1.x = (self.vq2-self.vMin)/self.hStep;
    p1.y = 0;
    
    p2.x = (self.vq2-self.vMin)/self.hStep;
    p2.y = self.maxy;
    
    [self drawLogicalLineFrom:p1 to:p2 with:[UIColor redColor]];
    
    p1.x = (self.vq3-self.vMin)/self.hStep;
    p1.y = 0;
    
    p2.x = (self.vq3-self.vMin)/self.hStep;
    p2.y = self.maxy;
    
    [self drawLogicalLineFrom:p1 to:p2 with:[UIColor blueColor]];
}
-(void)drawHistogram
{
    if([self.dataMartix count] > 0)
    {
        int lineNumber = 0;
        
        for (NSArray* dataList in self.dataMartix) {
            
            CGPoint p1;
            p1.x = 0;
            p1.y = 0;
            
            for (int i = 0; i< [dataList count]; i++) {
                
                NSNumber* number = dataList[i];
               
                p1.x = i;
                p1.y = [number doubleValue];
                
                UIColor* color;
                if(lineNumber < self.colorArray.count)
                {
                    color = self.colorArray[lineNumber];
                }
                else
                {
                    color = [self randColor];
                    self.colorArray = [self.colorArray arrayByAddingObject:color];
                }
                [self drawLogicalHistogram:p1 with:color];
                
                
                
            }
        
            
            lineNumber++;
        }
    }
    NSLog(@"self.vq1:%.2f,self.vq2:%.2f,self.vq3:%.2f",self.vq1,self.vq2,self.vq3);
    [self drawYlineValue];
}

-(void)drawDataAsPieChart
{
    if([self.dataMartix count] > 0)
    {
        self.sectorLineWidth = 0.5;
        for (NSArray* dataList in self.dataMartix) {
            NSArray* statistDataArray;
            CGFloat total = 0;
            
            for (id number in dataList) {
                if([number isKindOfClass:[NSNumber class]] || [number isKindOfClass:[NSString class]])
                {
                    total = total + [number doubleValue];
                }
            }
            if(total > 0)
            {
                statistDataArray = [NSArray new];
                for (id number in dataList) {
                    if([number isKindOfClass:[NSNumber class]] || [number isKindOfClass:[NSString class]])
                    {
                        CGFloat sValue = [number doubleValue]/total;
                        sValue = sValue*360.0;
                        statistDataArray = [statistDataArray arrayByAddingObject:[NSNumber numberWithDouble:sValue]];
                    }
                }
            }
            if (self.colorArray == nil) {
                self.colorArray = [NSArray new];
            }
            
            NSInteger c = [statistDataArray count] - self.colorArray.count;
            if(c == 1)
            {
                self.sectorLineWidth = 0;
            }
            
            if(self.style == SVMathViewSolidPie)
            {
                self.sectorLineWidth = 0;
            }
            
            for (NSInteger i = 0; i < c ; i++) {
                UIColor * color = [self randColor];
                self.colorArray = [self.colorArray arrayByAddingObject:color];
            }
            
            if([statistDataArray count] > 0)
            {
                
                double start = 0;
                double end = 0;
                int i = 0;
                for (id number in statistDataArray) {
                    if([number isKindOfClass:[NSNumber class]] || [number isKindOfClass:[NSString class]])
                    {
                        end += [number doubleValue];
                        UIColor * color ;
                        if(i < [self.colorArray count])
                            color= self.colorArray[i];
                        else
                            color = [self randColor];
                        
                        [self drawSectorFrom:start to:end withColor:color];
                        
                        //                    NSLog(@"start:%f,end:%f",start,end);
                        start = end;
                    }
                    i++;
                }
                
                
            }
            
            self.r = self.r * 0.66;
        }
        if(self.style != SVMathViewSolidPie)
            [self drawMiniSectorFrom:0 to:360 withColor:[UIColor whiteColor]];
    }
}


#pragma mark - Line
- (void)drawMoneyFlow
{
    if([self.dataMartix count] > 0)
    { int lineNumber = 0;
        for (NSArray* dataList in self.dataMartix) {
            
            CGPoint p1,p2,p3;
            p1.x = 0;
            p1.y = 0;
            
            for (int i = 0; i< [dataList count]; i++) {
                
                NSNumber* number = dataList[i];
                p3.x = i;
                p3.y = 0;
                
                p2.x = i;
                p2.y = [number doubleValue];
                
                
                if (i >0) {
                    
                    UIColor* color;
                    if(lineNumber < self.colorArray.count)
                    {
                        color = self.colorArray[lineNumber];
                    }
                    else
                    {
                        color = [self randColor];
                        self.colorArray = [self.colorArray arrayByAddingObject:color];
                    }
                    [self drawLogicalLineFrom:p1 to:p2 with:color];
                }
                
                p1.x = i;
                p1.y = [number doubleValue];
                
            }
            
            
            //            for (int i = 0; i< [dataList count]; i++) {
            //
            //                NSNumber* mo = dataList[i];
            //
            //                p2.x = i;
            //                p2.y = [mo doubleValue];
            //
            //                [self drawIndexName:p2];
            //
            //
            //            }
            
            lineNumber++;
        }
    }
    
    
}

- (CGFloat)transX:(CGFloat)ox   //逻辑
{
    return (self.coordinateX + ox) - self.contentOffsetValue;
}
- (CGFloat)transY:(CGFloat)oy
{
    return (self.coordinateY - oy);
}
- (void)drawArrowBox:(CGPoint) p
{
    CGRect box;
    CGFloat x,y,w,h;
    
    x = p.x*self.stepx;
    y = p.y*self.stepy + 3;
    w = 40;
    h = 15;
    x = x - w/2.0;
    y = y + h;
    
    x =[self transX:x];
    y =[self transY:y];
    box = CGRectMake(x, y, w, h);
    [self drawPath:box];
    
    NSString* pstr = [NSString stringWithFormat:@"%.2f",p.y];
    
    CGSize contentSize;
    
    UIFont *font = [UIFont systemFontOfSize:10.0];
    
    NSDictionary *attributes = @{NSFontAttributeName: font,NSForegroundColorAttributeName:[UIColor grayColor]};
    
    contentSize = [pstr sizeWithAttributes:attributes];
    
    h = contentSize.height;
    x = x+(w - contentSize.width)/2.0;
    w = contentSize.width;
    [[UIColor grayColor] set];
    [pstr drawInRect:CGRectMake(x, y, w, h) withAttributes:(attributes)];
    
}

- (void)drawArrowBox2:(CGPoint) p
{
    CGRect box;
    CGFloat x,y,w,h;
    
    x = p.x*self.stepx;
    y = p.y*self.stepy + 3;
    w = 40;
    h = 15;
    x = x - w/2.0;
    y = y + h;
    
    x =[self transX:x];
    y =[self transY:y];
    box = CGRectMake(x, y, w, h);
    [self drawPath:box];
    
    NSString* pstr ;
    if (self.style == SVMathViewMath2d) {
        pstr = [NSString stringWithFormat:@"%.2f",p.x*self.hStep + self.vMin];
    }
    else
        pstr = [NSString stringWithFormat:@"%.2f",p.x];
    
    CGSize contentSize;
    
    UIFont *font = [UIFont systemFontOfSize:10.0];
    
    NSDictionary *attributes = @{NSFontAttributeName: font,NSForegroundColorAttributeName:[UIColor grayColor]};
    
    contentSize = [pstr sizeWithAttributes:attributes];
    
    h = contentSize.height;
    x = x+(w - contentSize.width)/2.0;
    w = contentSize.width;
    [[UIColor grayColor] set];
    [pstr drawInRect:CGRectMake(x, y, w, h) withAttributes:(attributes)];
    
}

- (void)drawIndexName:(CGPoint) p
{
    CGRect box;
    CGFloat x,y,w,h;
    CGFloat gapWidth = 0;
    static CGFloat oldX = 0;
    
    gapWidth = (p.x - oldX);
    
    if(gapWidth < 30)
    {
        return;
    }
    oldX = p.x;
    x = p.x*self.stepx;
    
    y = -20;
    w = 40;
    h = 15;
    x = x - w/2.0;
    y = y + h;
    
    x =[self transX:x];
    y =[self transY:y];
    box = CGRectMake(x, y, w, h);
    //    [self drawPath:box];
    
    int index = p.x;
    
    NSString* pstr = [NSString stringWithFormat:@"%d",index];
    
    CGSize contentSize;
    
    UIFont *font = [UIFont systemFontOfSize:10.0];
    
    NSDictionary *attributes = @{NSFontAttributeName: font,NSForegroundColorAttributeName:[UIColor grayColor]};
    
    contentSize = [pstr sizeWithAttributes:attributes];
    
    h = contentSize.height;
    x = x+(w - contentSize.width)/2.0;
    w = contentSize.width;
    [[UIColor grayColor] set];
    [pstr drawInRect:CGRectMake(x, y, w, h) withAttributes:(attributes)];
    
}

- (void)coculateAllValue
{
    
    NSInteger countOfData = 0;
    
    if([self.dataMartix count] > 0)
    {
        for (NSArray* dataList in self.dataMartix) {
            
            countOfData = MAX(countOfData,[dataList count]);
            
            for (NSNumber* mo in dataList) {
                double mov = [mo doubleValue];
                if (self.maxy < fabs(mov)) {
                    self.maxy = fabs(mov);
                }
                if (self.miny > fabs(mov)) {
                    self.miny = fabs(mov);
                }
            }
        }
    }
    
    if(self.style == SVMathViewMath2d || self.style == SVMathViewLine )
    {
        self.coordinateX = 10;
        self.coordinateY = self.frame.size.height -10 ; //上下比例
    }
    else
    {
        self.coordinateX = self.frame.size.width/2.0;
        self.coordinateY = self.frame.size.height/2.0;
    }
    
    
    
    
    if (self.maxy > 0) {
        
        if ((self.maxy-self.miny) != 0) {
            self.stepy = (self.coordinateY)/(self.maxy);
        }
        else
        {
            
        }
        
    }
    
    
    if(countOfData > 1)
    {
        CGFloat edge = 2;
        if(self.style == SVMathViewMath2d)
        {
            self.stepx = (self.frame.size.width - self.coordinateX - 2*edge)/(countOfData);
        }
        else
        {
            self.stepx = (self.frame.size.width - self.coordinateX - 2*edge)/(countOfData-1);
        }
        if (self.stepx < 0.5) {
            //            self.stepx = 0.5;
        }
        else
        {
            
        }
    }
    else
    {
        self.stepx = self.frame.size.width - self.coordinateX;
    }
    
    self.west = (self.coordinateX - self.frame.size.width)/self.stepx;
    self.east =  (self.coordinateX)/self.stepx;;
    
    
    self.north = (self.coordinateY)/self.stepy;
    self.south = (self.coordinateY - self.frame.size.height)/self.stepy;
    
    
}

- (UIBezierPath *)createArcPath:(CGRect)rect
{
    UIBezierPath *aPath = [UIBezierPath bezierPath];
    CGFloat x,y,w,h;
    x = rect.origin.x;
    y = rect.origin.y;
    w = rect.size.width;
    h = rect.size.height;
    
    CGFloat cx,cy;
    CGFloat delta;
    delta = 3.0;
    cx = x+w/2.0;
    cy = y - delta;
    h =  h - delta;
    CGPoint targetP = CGPointMake(x, y);
    [aPath moveToPoint:targetP];
    
    
    targetP = CGPointMake(x, y+h);
    [aPath addLineToPoint:targetP];
    
    targetP = CGPointMake(cx-delta, y+h);
    [aPath addLineToPoint:targetP];
    
    targetP = CGPointMake(cx , y+h+delta);
    [aPath addLineToPoint:targetP];
    
    targetP = CGPointMake(cx+delta , y+h);//CGPointMake(cx+delta, h)
    [aPath addLineToPoint:targetP];
    
    targetP = CGPointMake(x+w , y+h);
    [aPath addLineToPoint:targetP];
    
    targetP = CGPointMake(x+w , y);
    [aPath addLineToPoint:targetP];
    
    
    
    
    [aPath closePath];
    
    return aPath;
}

- (void)drawPath:(CGRect)rect
{
    UIBezierPath *ap = [self createArcPath:rect];
    
    CGContextRef myContext = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(myContext);
    
    CGContextBeginPath (myContext);
    
    [[UIColor grayColor] setStroke];
    [[UIColor colorWithRed:249.0/255.0 green:249.0/255.0 blue:239.0/255.0 alpha:1.0] setFill];
    
    //    CGContextTranslateCTM(myContext, 50, 50);
    
    ap.lineWidth = 1;
    
    [ap fill];
    [ap stroke];
    
    CGContextRestoreGState(myContext);
}
@end
