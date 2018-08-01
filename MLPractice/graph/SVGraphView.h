//
//  SVGraphView.h
//  GraphDemo
//
//  Created by 威 沈 on 28/04/2018.
//  Copyright © 2018 ShenWei. All rights reserved.
//



#import <UIKit/UIKit.h>

#define SafeString(text)    [NSString stringWithFormat:@"%@", text]
#define SafeStringExt(text,ext)    [NSString stringWithFormat:@"%@.%@", text,ext]
#define SafeStringCon(text,ext)    [NSString stringWithFormat:@"%@%@", text,ext]
#define SafeStringConfig(text)    [NSString stringWithFormat:@"%@.Config", text]



@protocol SVGraphViewDelegate <NSObject>

- (void)dosomething;
@optional
- (void)requestStockMinute:(NSString*)StockName;
-(CGFloat)valueOfYByX:(CGFloat)x;
@end


@interface SVCoordinate : NSObject
@property(nonatomic,assign)CGFloat coordinateX;
@property(nonatomic,assign)CGFloat coordinateY;
@property(nonatomic,assign)CGFloat stepy;
@property(nonatomic,assign)CGFloat stepx;

@property(nonatomic,assign)CGFloat west;
@property(nonatomic,assign)CGFloat east;
@property(nonatomic,assign)CGFloat north;
@property(nonatomic,assign)CGFloat south;
@property(nonatomic,assign) CGFloat maxy;
@property(nonatomic,assign) CGFloat miny;

@property(nonatomic,assign) CGFloat hStep;
- (void)configCoordinateWithOffsetPoint:(CGPoint)offsetPoint;
- (void)coculateAllValue;
- (CGFloat)transY:(CGFloat)oy;
- (CGFloat)transX:(CGFloat)ox;
@end

@interface SVGraphView : UIView
{
    CGPoint touchBeginPoint;
    CGPoint touchEndPoint;
    NSTimeInterval beginTimeinterval;
    NSTimeInterval endTimeinterval;
    __block CGFloat v;
    __block BOOL moved;
    CGFloat indexValue;
    
    __block BOOL fingerDown;
    __block BOOL fingerUp;
    
}
@property(nonatomic,strong)SVCoordinate* extentCoorinate;
@property(nonatomic,assign)CGFloat coordinateX;
@property(nonatomic,assign)CGFloat coordinateY;
@property(nonatomic,assign)CGFloat coordinateZ;
@property(nonatomic,assign)CGFloat stepy;
@property(nonatomic,assign)CGFloat stepx;
@property(nonatomic,assign)CGFloat stepz;
@property(nonatomic,assign)CGFloat west;
@property(nonatomic,assign)CGFloat east;
@property(nonatomic,assign)CGFloat near;
@property(nonatomic,assign)CGFloat far;
@property(nonatomic,assign)CGFloat north;
@property(nonatomic,assign)CGFloat south;
@property(nonatomic,assign) CGFloat hStep;
@property(nonatomic,assign) CGFloat vMax;
@property(nonatomic,assign) CGFloat vMin;
@property(nonatomic,assign) CGFloat vq1;
@property(nonatomic,assign) CGFloat vq2;
@property(nonatomic,assign) CGFloat vq3;
//@property(nonatomic,assign)CGFloat edge;
@property(nonatomic,assign) BOOL up;
@property(nonatomic,assign) CGFloat maxy;
@property(nonatomic,assign) CGFloat maxz;
@property(nonatomic,assign) CGFloat miny;
@property(nonatomic,assign) CGFloat minz;
@property(nonatomic,assign)CGFloat contentWidth;
@property(nonatomic,assign)CGFloat r;
@property(nonatomic,assign)__block CGFloat contentOffsetValue;
@property(nonatomic,weak) id <SVGraphViewDelegate> delegate;
@property(nonatomic,assign)CGFloat sectorLineWidth;
@property(nonatomic,assign)CGFloat histogramWidth;
- (UIColor*)randColor;
-(void)drawPoint:(CGPoint)point;
- (void)drawLogcalPoint:(CGPoint)point;
- (void)drawLineFrom:(CGPoint)point1 to:(CGPoint)point2 withColor:(UIColor*)color;
//-(void)drawLineFrom:(CGPoint)point1 to:(CGPoint)point2 with:(UIColor*)color;
- (void)drawLogicalLineFrom:(CGPoint)p1 to:(CGPoint)p2 with:(UIColor*)color;
- (void)coculateAllValue;
- (CGFloat)mostRightPosition;
- (void)setContentOffset;
- (void) drawYline;
- (void) drawXline;
- (void)drawPath;
-(void)drawHistogram:(CGRect)rect with:(UIColor*)color;
- (void)drawCircleAtPoint:(CGPoint)p with:(UIColor*)color;
- (void)drawSectorFrom:(CGFloat)start to:(CGFloat)end withColor:(UIColor*)color;
- (void)drawMiniSectorFrom:(CGFloat)start to:(CGFloat)end withColor:(UIColor*)color;
-(void)drawLogicalHistogram:(CGPoint)point1 with:(UIColor*)color;
-(void)drawNumber:(double)number atPoint:(CGPoint)p;
- (void) drawYlineValue;
- (void) drawXlineValue;
@end
