//
//  SVFunctionGraphView.h
//  MLPractice
//
//  Created by 威 沈 on 01/06/2018.
//  Copyright © 2018 ShenWei. All rights reserved.
//

#import "SVGraphView.h"
typedef enum : NSUInteger {
    SVFunctionGraphStyleByFunction,
    SVFunctionGraphStyleByDataList,
} SVFunctionGraphStyle;
@interface SVFunctionGraphView : SVGraphView
@property (nonatomic,strong) NSArray* dataList;// @[@{x:1,y:1},...,];
@property (nonatomic,assign) SVFunctionGraphStyle style;
@end
