//
//  SVGraphView.m
//  GraphDemo
//
//  Created by 威 沈 on 28/04/2018.
//  Copyright © 2018 ShenWei. All rights reserved.
//

#import "SVGraphView.h"

#define pi 3.14159265359
#define   DEGREES_TO_RADIANS(degrees)  ((pi * degrees)/ 180)

#define RefTime  0.02


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



@interface SVGraphView ()

@property (nonatomic,strong) NSTimer* timer;
@end

@implementation SVCoordinate

- (id)init
{
    self = [super init];
    if (self) {
        _stepx = 40;
        _stepy = 1;
        
        
        _maxy = 100;
        _miny = 0;
    
        
    }
    return self;
}
- (void)configCoordinateWithOffsetPoint:(CGPoint)offsetPoint
{
    _coordinateX = offsetPoint.x;
    _coordinateY = offsetPoint.y;
    
}
- (void)coculateAllValue
{
    self.west = 0-self.coordinateX/self.stepx;
    self.stepy = self.maxy/self.north; //north需要认为设置
}
@end


@implementation SVGraphView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _coordinateX = self.frame.size.width*0.1;
        _coordinateY = self.frame.size.height*0.9;
        
        _contentOffsetValue = 0;
        _stepx = 40;
        _stepy = 5;
        _up = YES;
        self.maxy = 0;
        self.miny = 0;
        moved = YES;
        indexValue = 0;

        
         self.r = MIN(self.frame.size.width,self.frame.size.height);
    }
    return self;
}

- (SVCoordinate*)extentCoorinate
{
    if (_extentCoorinate == nil) {
        _extentCoorinate = [[SVCoordinate alloc] init];
    }
    return _extentCoorinate;
}
- (void)drawBackGround:(CGContextRef) myContext rect:(CGRect)rect
{
    CGFloat x,y,w,h;
    x = 0;
    y = 0;
    w = rect.size.width;
    h = rect.size.height;
    
    CGContextSaveGState(myContext);

    CGContextSetRGBFillColor(myContext, 255.0/255.0, 255.0/255.0, 255.0/255.0, 1);
    CGContextFillRect(myContext, CGRectMake(x, y, w, h));
}
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    [self coculateAllValue];
    CGContextRef myContext = UIGraphicsGetCurrentContext();
    [self drawBackGround:myContext rect:rect];
}
- (UIColor*)randColor
{
    double r,g,b;
    r = (rand()%200 + 55)/255.0;
    g = (rand()%200 + 55)/255.0;
    b = (rand()%200 + 55)/255.0;
    return [UIColor colorWithRed:r green:g blue:b alpha:1.0];
}
- (void)setContentOffset
{
    
    
    CGFloat position = [self mostRightPosition];
    if(position > self.frame.size.width)
        _contentOffsetValue = position - self.frame.size.width;
    else
        _contentOffsetValue = 0;
}
- (CGFloat)mostRightPosition
{
    [self coculateAllValue];
    return self.east*self.stepx;
}
- (void)coculateAllValue
{
    self.coordinateX = 10;
    self.coordinateY = self.frame.size.height*0.618; //上下比例
    
    
    if (self.maxy > 0) {
        
        if ((self.maxy-self.miny) != 0) {
            self.stepy = (self.coordinateY-10)/(self.maxy-self.miny);
        }
        else
        {
            
        }
        
    }
    
    self.west = 0-self.coordinateX/self.stepx;
    self.east = 100;
    
    self.north = self.coordinateY/self.stepy;
    self.south = (self.coordinateY - self.frame.size.height)/self.stepy;
    
    CGPoint ppp;
    ppp.x = self.coordinateX;
    ppp.y = self.frame.size.height;
    [self.extentCoorinate configCoordinateWithOffsetPoint:ppp];
    self.extentCoorinate.east = self.east;
    
    [self.extentCoorinate coculateAllValue];
    
    self.extentCoorinate.north = self.extentCoorinate.maxy;
    self.extentCoorinate.stepy = (ppp.y-self.coordinateY)/self.extentCoorinate.maxy;
    
}
- (CGFloat)transY:(CGFloat)oy
{
    return (_coordinateY - oy);
}

- (CGFloat)transX:(CGFloat)ox   //逻辑
{
    return (self.coordinateX + ox) - self.contentOffsetValue;
}
- (CGFloat)StaticTransX:(CGFloat)ox // 屏幕
{
    return (self.coordinateX + ox);
}

- (CGFloat)transExCooY:(CGFloat)oy
{
    return (self.extentCoorinate.coordinateY - oy);
}

- (CGFloat)transExCooX:(CGFloat)ox   //逻辑
{
    return (self.extentCoorinate.coordinateX + ox) - self.contentOffsetValue;
}
- (CGFloat)StaticTransExCooX:(CGFloat)ox // 屏幕
{
    return (self.extentCoorinate.coordinateX + ox) - self.contentOffsetValue;
}

- (void)drawPoint:(CGPoint)point
{
    
    CGFloat radius = 5.0;
    CGMutablePathRef cgPath = CGPathCreateMutable();
    
    CGFloat x,y,w,h;
    x = point.x-radius/2.0;
    y = point.y+radius/2.0;
    w = radius;
    h = radius;
    CGPathAddEllipseInRect(cgPath, NULL, CGRectMake([self transX:x],[self transY:y],w,h));
    x++;
    y--;
    w = w -2;
    h = h -2;
    

    UIBezierPath *aPath = [UIBezierPath bezierPath];
    aPath.CGPath = cgPath;
    aPath.usesEvenOddFillRule = YES;
    
    
    [aPath fill];
    CGPathRelease(cgPath);
}
- (void)drawCircleAtPoint:(CGPoint)p with:(UIColor*)color
{

    CGPoint point;
    point.x = p.x;
    point.y = p.y;
    point.x = point.x*_stepx;
    point.y = point.y*_stepy;
    
    
    CGContextRef myContext = UIGraphicsGetCurrentContext();
    CGContextBeginPath (myContext);
    
    
    CGContextSetLineWidth(myContext, 0.5);
    
    CGContextSetStrokeColorWithColor(myContext,color.CGColor);
    CGContextSetFillColorWithColor(myContext, color.CGColor);
    CGFloat x,y,w,h;
    x = [self transX:point.x]-1;
    y = [self transY:point.y]-1;
    w =2;
    h = 2;
    CGRect rect;
    rect = CGRectMake(x, y, w, h);
    
    CGContextFillEllipseInRect(myContext, rect);
    CGContextAddEllipseInRect(myContext,rect);
    CGContextStrokePath(myContext);
}
- (void)drawLineFrom:(CGPoint)point1 to:(CGPoint)point2 withColor:(UIColor*)color
{
    
    CGPoint from,to;
    from.x = [self transX:point1.x];
    from.y = [self transY:point1.y];
    
    to.x = [self transX:point2.x];
    to.y = [self transY:point2.y];
    
    
    CGContextRef myContext = UIGraphicsGetCurrentContext();
    CGContextBeginPath (myContext);
    
    CGContextSetStrokeColorWithColor(myContext, [UIColor yellowColor].CGColor);
    CGContextSetLineWidth(myContext, 1.0);
    if (_up) {
        CGContextSetStrokeColorWithColor(myContext, color.CGColor);
    }
    else{
        
        CGContextSetStrokeColorWithColor(myContext, [UIColor colorWithRed:0.0/255.0 green:255.0/255.0 blue:0.0/255.0 alpha:1.0].CGColor);
    }
    CGContextMoveToPoint(myContext,from.x,from.y);
    CGContextAddLineToPoint(myContext,to.x, to.y);
    CGContextStrokePath(myContext);
}

- (void)drawLogcalPoint:(CGPoint)point
{
    point.x = point.x*_stepx;
    point.y = point.y*_stepy;
    
    [self drawPoint:point];
}

-(void)drawLogicalHistogram:(CGPoint)point1 with:(UIColor*)color
{
   
    
    CGRect rect;
    rect.origin.x = point1.x;
    rect.origin.y = point1.y;
    rect.size.height = point1.y;
    rect.size.width = 1;
    [self drawLogicalRect:rect with:color];
    
    
    CGPoint p1,p2,p3,p4;
    p1.x = point1.x;
    p1.y = point1.y;

    p2.x = point1.x + 1;
    p2.y = point1.y;

    p3.x = point1.x + 1;
    p3.y = 0;

    p4.x = point1.x;
    p4.y = 0;

    [self drawLogicalLineFrom:p1 to:p2 with:[UIColor blackColor]];
    [self drawLogicalLineFrom:p2 to:p3 with:[UIColor blackColor]];
    [self drawLogicalLineFrom:p3 to:p4 with:[UIColor blackColor]];
    [self drawLogicalLineFrom:p4 to:p1 with:[UIColor blackColor]];
    
    
    
}
-(void)drawLogicalRect:(CGRect)rect with:(UIColor*)color
{
    CGRect nRect;
    
    nRect.origin.x = [self transX:rect.origin.x*self.stepx];
    
    nRect.origin.y = [self transY:rect.origin.y*self.stepy];
    
    nRect.size.width = rect.size.width*self.stepx;
    nRect.size.height = rect.size.height*self.stepy;
    
    [self drawHistogram:nRect with:color];
}
-(void)drawHistogram:(CGRect)rect with:(UIColor*)color
{
    UIBezierPath *ap = [self createRectPathFor:rect];
    
    CGContextRef myContext = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(myContext);
    
    CGContextBeginPath (myContext);
    
    [color setStroke];
    [color setFill];
    
    CGContextTranslateCTM(myContext, 0, 0);
    
    ap.lineWidth = 1;
    [ap fill];
    [ap stroke];
    
    CGContextRestoreGState(myContext);
}
- (UIBezierPath *)createRectPathFor:(CGRect)rect
{
    UIBezierPath *aPath = [UIBezierPath bezierPath];
    
    CGPoint start;
    start.x = rect.origin.x;
    start.y = rect.origin.y;
    
    [aPath moveToPoint:start];
    
    start.x = rect.origin.x + rect.size.width;
    start.y = rect.origin.y;
    
    [aPath addLineToPoint:start];
   
    start.x = rect.origin.x + rect.size.width;
    start.y = rect.origin.y + rect.size.height;
    
    [aPath addLineToPoint:start];
    
    start.x = rect.origin.x;
    start.y = rect.origin.y + rect.size.height;
    
    [aPath addLineToPoint:start];
    
    start.x = rect.origin.x;
    start.y = rect.origin.y;
    
    [aPath addLineToPoint:start];
    
    
    return aPath;
}
-(void)drawlogicalRectFrom:(CGPoint)point1 to:(CGPoint)point2 withColor:(UIColor*)color //对角线的2个点
{
    CGPoint from,to;
    from.x = [self transX:point1.x];
    from.y = [self transY:point1.y];
    
    to.x = [self transX:point2.x];
    to.y = [self transY:point2.y];
    
    
    CGContextRef myContext = UIGraphicsGetCurrentContext();
    CGContextBeginPath (myContext);
    
    CGContextSetStrokeColorWithColor(myContext, [UIColor yellowColor].CGColor);
   
    CGFloat x,y,w,h;
    x = from.x;
    y = from.y;
    w = self.stepx;
    h = from.y - to.y;
    

    
    CGContextSetRGBFillColor(myContext, 15.0/255.0, 25.0/255.0, 25.0/255.0, 1);
    CGContextFillRect(myContext, CGRectMake(x, y, w, h));
    
    CGContextStrokePath(myContext);
}


- (void)drawLogicalLineFrom:(CGPoint)p1 to:(CGPoint)p2 with:(UIColor*)color
{
    p1.x = p1.x*_stepx;
    p1.y = p1.y*_stepy;
    
    p2.x = p2.x*_stepx;
    p2.y = p2.y*_stepy;
    
    [self drawLineFrom:p1 to:p2 withColor:color];
}

#pragma mark - 关于触摸操作的处理函数

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint p = [[touches anyObject] locationInView:self];
   
    
    _contentOffsetValue = _contentOffsetValue - (p.x - touchBeginPoint.x);
    if (_contentOffsetValue < self.west*_stepx) {
        _contentOffsetValue = self.west*_stepx;
    }
    
    else if (_contentOffsetValue> (self.east*_stepx - self.frame.size.width)) {
        _contentOffsetValue = (self.east*_stepx - self.frame.size.width);
    }
    
    
    double duration;
    duration = [NSDate timeIntervalSinceReferenceDate] - beginTimeinterval;
    
    v = (p.x - touchBeginPoint.x)/duration;
    
    beginTimeinterval = [NSDate timeIntervalSinceReferenceDate];
    touchBeginPoint.x = p.x;
    touchBeginPoint.y = p.y;
    moved = YES;
    
    fingerDown = YES;
    fingerUp = NO;
    NSLog(@"touchBeginPoint.x%.2f,touchBeginPoint.y:%.2f",touchBeginPoint.x,touchBeginPoint.y);
    [self setNeedsDisplay];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint p = [[touches anyObject] locationInView:self];
    
    [self.timer invalidate];
    self.timer = nil;
    
    
    beginTimeinterval = [NSDate timeIntervalSinceReferenceDate];
    touchBeginPoint.x = p.x;
    touchBeginPoint.y = p.y;
    moved = NO;
    fingerDown = YES;
    fingerUp = NO;
    
    [self setNeedsDisplay];
    
}

- (void) timeUpdate
{
    _contentOffsetValue = _contentOffsetValue - v*(RefTime);
    if (_contentOffsetValue  < 0) {
        _contentOffsetValue = 0;
    }
    static CGFloat vp = 1.3;
    
    if (v > 0) {
        v = v*0.96;
        if (v <= 10) {
            [self.timer invalidate];
            self.timer = nil;
        }
        
    }
    else
    {
        v = v*0.96;
        if (v >= -10) {
            [self.timer invalidate];
            self.timer = nil;
        }
    }
    vp = vp*vp;
    if (_contentOffsetValue  < self.west*_stepx) {
        _contentOffsetValue = self.west*_stepx;
        
        [self.timer invalidate];
        self.timer = nil;
    }
    
    else if (_contentOffsetValue > (self.east*_stepx - self.frame.size.width)) {
        _contentOffsetValue = (self.east*_stepx - self.frame.size.width);
        
        [self.timer invalidate];
        self.timer = nil;
    }
    else
    {
        NSLog(@"%s,%d",__func__,__LINE__);
    }
    
  
    [self setNeedsDisplay];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    CGPoint p = [[touches anyObject] locationInView:self];
    touchEndPoint.x = p.x;
    touchEndPoint.y = p.y;
    
    if (moved == NO) {
        indexValue = touchEndPoint.x;
        [self setNeedsDisplay];
    }
    else
    {
        endTimeinterval = [NSDate timeIntervalSinceReferenceDate];
        
        self.timer= [NSTimer timerWithTimeInterval:RefTime target:self selector:@selector(timeUpdate) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
    fingerDown = NO;
    fingerUp = YES;
    
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%s",__func__);
    NSLog(@"cancel all!!!!!!!!!!!!");
    fingerDown = NO;
    fingerUp = YES;
}

- (void) drawXline
{
    
    CGPoint westPointOfX;
    CGPoint easePointOfX;
    
    westPointOfX.y = self.south;
    westPointOfX.x = self.west;
    
    easePointOfX.y = self.south;
    easePointOfX.x = self.east;
    
    [self drawLogicalLineFrom:westPointOfX to:easePointOfX with:[UIColor grayColor]];
    
    
    westPointOfX.y = self.north;
    westPointOfX.x = self.west;
    
    easePointOfX.y = self.north;
    easePointOfX.x = self.east;
    
    [self drawLogicalLineFrom:westPointOfX to:easePointOfX with:[UIColor grayColor]];
    
    
    westPointOfX.y = 0;
    westPointOfX.x = self.west;
    
    easePointOfX.y = 0;
    easePointOfX.x = self.east;
    
    [self drawLogicalLineFrom:westPointOfX to:easePointOfX with:[UIColor grayColor]];
    
    
}
- (void) drawYlineValue
{
    int c = 10;
    CGFloat ys = self.maxy/c;
    CGPoint p;
    for (int i = -10; i< 10; i++) {
        p.y = ys*i*self.stepy;
        p.x = 0;
        [self drawNumber:ys*i atPoint:p];
    }
}
- (void) drawXlineValue
{
    int c = 10;
    CGFloat ys = self.east/c;
    CGPoint p;
    for (int i = -10; i< 10; i++) {
        p.x = ys*i*self.stepx;
        p.y = 0;
        [self drawNumber:ys*i atPoint:p];
    }
}
- (void) drawYline
{
    
    CGPoint northPointOfY;
    CGPoint southPointOfY;
    
    northPointOfY.y = self.north;
    northPointOfY.x = self.west;
    
    southPointOfY.y = self.south;
    southPointOfY.x = self.west;
    
    [self drawLogicalLineFrom:northPointOfY to:southPointOfY with:[UIColor grayColor]];
    
    northPointOfY.y = self.north;
    northPointOfY.x = self.east;
    
    southPointOfY.y = self.south;
    southPointOfY.x = self.east ;
    
    [self drawLogicalLineFrom:northPointOfY to:southPointOfY with:[UIColor grayColor]];
    
    northPointOfY.y = self.north;
    northPointOfY.x = 0;
    
    southPointOfY.y = self.south;
    southPointOfY.x = 0;
    
    [self drawLogicalLineFrom:northPointOfY to:southPointOfY with:[UIColor grayColor]];
   
    
}
- (UIBezierPath *)createArcPath
{
    UIBezierPath *aPath = [UIBezierPath bezierPath];
    
    CGPoint ccenter =  CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0);
    [aPath moveToPoint:ccenter];
    CGFloat r = self.frame.size.width/2;
    [aPath addLineToPoint:CGPointMake(ccenter.x+r, ccenter.y)];
    
    [aPath addArcWithCenter:ccenter radius:r startAngle:0 endAngle:DEGREES_TO_RADIANS(135) clockwise:YES];
    [aPath addLineToPoint:ccenter];
    [aPath closePath];
    
    
    return aPath;
}

- (UIBezierPath *)createArcPath2
{
    UIBezierPath *aPath = [UIBezierPath bezierPath];
    
    CGPoint ccenter =  CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0);
    [aPath moveToPoint:ccenter];
    CGFloat r = self.frame.size.width/2;
    [aPath addLineToPoint:CGPointMake(ccenter.x+r, ccenter.y)];
    
    [aPath addArcWithCenter:ccenter radius:r startAngle:0 endAngle:DEGREES_TO_RADIANS(135) clockwise:YES];
    [aPath addLineToPoint:ccenter];
    [aPath closePath];
    
    
    return aPath;
}
- (void)drawPath
{
    UIBezierPath *ap = [self createArcPath];
    
    CGContextRef myContext = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(myContext);
    
    CGContextBeginPath (myContext);
    
    [[UIColor clearColor] setStroke];
    [[UIColor redColor] setFill];
    
    CGContextTranslateCTM(myContext, 0, 0);
    
    ap.lineWidth = 0;
    
    [ap fill];
    [ap stroke];
    
    CGContextRestoreGState(myContext);
}
- (void)drawPath2
{
    UIBezierPath *ap = [self createArcPath2];
    
    CGContextRef myContext = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(myContext);
    
    CGContextBeginPath (myContext);
    
    [[UIColor clearColor] setStroke];
    [[UIColor greenColor] setFill];
    
    CGContextTranslateCTM(myContext, 0, 0);
    
    ap.lineWidth = 0;
    
    [ap fill];
    [ap stroke];
    
    CGContextRestoreGState(myContext);
}
- (UIBezierPath *)createArcPathFrom:(CGFloat)start toEnd:(CGFloat)end withradius:(CGFloat)radius atPoint:(CGPoint)center
{
    UIBezierPath *aPath = [UIBezierPath bezierPath];
    
    [aPath moveToPoint:center];
    
    double startarc = DEGREES_TO_RADIANS(start);
    double endarc = DEGREES_TO_RADIANS(end);

    [aPath addArcWithCenter:center radius:radius startAngle:startarc endAngle:endarc clockwise:YES];
    [aPath addLineToPoint:center];
    
    return aPath;
}
- (void)drawMiniSectorFrom:(CGFloat)start to:(CGFloat)end withColor:(UIColor*)color
{
    
    CGFloat minr = self.r*0.66;
    self.sectorLineWidth = 0;
    [self drawSectorWithR:minr From:start to:end withColor:color];
}
- (void)drawSectorFrom:(CGFloat)start to:(CGFloat)end withColor:(UIColor*)color
{
   
    [self drawSectorWithR:self.r From:start to:end withColor:color];
}
- (void)drawSectorWithR:(CGFloat)r From:(CGFloat)start to:(CGFloat)end withColor:(UIColor*)color
{
    CGPoint center = CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0);
    [self drawSectorAtPoint:center withR:r From:start to:end withColor:color];
}

- (void)drawSectorAtPoint:(CGPoint)p withR:(CGFloat)r From:(CGFloat)start to:(CGFloat)end withColor:(UIColor*)color
{
    CGPoint center = p;
    CGFloat radius = r;
    
    UIBezierPath *ap = [self createArcPathFrom:start toEnd:end withradius:radius atPoint:center];
    
    CGContextRef myContext = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(myContext);
    
    CGContextBeginPath (myContext);
    
    [[UIColor colorWithWhite:0.88 alpha:1.0] setStroke];
    [color setFill];

    CGContextTranslateCTM(myContext, 0, 0);
   
    ap.lineWidth = self.sectorLineWidth;
    [ap fill];
    [ap stroke];
    
    CGContextRestoreGState(myContext);
}
- (void)drawNumber:(double)number atPoint:(CGPoint) p
{
    
    CGFloat x,y,w,h;
    
    CGFloat fontsize = 9;
    NSDictionary* dic = @{(NSString *)NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:fontsize]};
    
    NSString *content = [NSString stringWithFormat:@"%.2f",number+self.vMin];

    CGSize size = [content  sizeWithAttributes:dic];
    

    CGContextRef myContext = UIGraphicsGetCurrentContext();
    CGContextBeginPath (myContext);
    
    
    fillRectBorderColor;
    y = [self transY:p.y];
    x = [self transX:p.x];
    
    if (self.up) {
        fillUpColor2;
    }
    else{
        fillDownColor2;
    }
    
    CGContextStrokePath(myContext);
    
    
    w = size.width;
    h = size.height;
    
    [content drawInRect:CGRectMake(x,y, w, h) withAttributes:dic];
    

    
}

#pragma mark -
@end
