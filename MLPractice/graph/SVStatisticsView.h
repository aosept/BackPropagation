//
//  SVStatisticsView.h
//  GraphDemo
//
//  Created by 威 沈 on 28/04/2018.
//  Copyright © 2018 ShenWei. All rights reserved.
//

/*
 
 SVStatisticsView* graphView =  [SVStatisticsView new]
 [self.view addSubView:graphView];
 graphView.dataMartix = @[@[],
                              @[],
                              ];
 graphView.style = SVStatisticsViewLine;//SVStatisticsViewPie
 [graphView setNeedsDisplay];
 

*/
#import "SVGraphView.h"

typedef enum : NSUInteger {
    SVStatisticsViewPie,
    SVStatisticsViewLine,
    SVStatisticsViewLine2,
    SVStatisticsViewMath2d,
    SVStatisticsViewSolidPie,
} SVStatisticsViewStyle;

@interface SVStatisticsView : SVGraphView
{
    
}
//@property (nonatomic,strong) NSArray* dataList;
@property (nonatomic,strong) NSArray* colorArray;
@property (nonatomic,strong) NSArray* dataMartix;
@property (nonatomic,assign) SVStatisticsViewStyle style;

@end
