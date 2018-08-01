//
//  SVMathView.h
//  GraphDemo
//
//  Created by 威 沈 on 28/04/2018.
//  Copyright © 2018 ShenWei. All rights reserved.
//

/*
 
 SVMathView* graphView =  [SVMathView new]
 [self.view addSubView:graphView];
 graphView.dataMartix = @[@[],
 @[],
 ];
 graphView.style = SVMathViewLine;//SVMathViewPie
 [graphView setNeedsDisplay];
 
 
 */
#import "SVGraphView.h"

typedef enum : NSUInteger {
    SVMathViewPie,
    SVMathViewLine,
    SVMathViewMath2d,
    SVMathViewSolidPie,
} SVMathViewStyle;

@interface SVMathView : SVGraphView
{
    
}
//@property (nonatomic,strong) NSArray* dataList;
@property (nonatomic,strong) NSArray* colorArray;
@property (nonatomic,strong) NSArray* dataMartix;
@property (nonatomic,assign) SVMathViewStyle style;

@end
