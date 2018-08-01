
#import <UIKit/UIKit.h>
#import "SVStatisticsView.h"


@class SVChartBaseView;
@protocol SVChartBaseViewDelegate <NSObject>

-(void)updateSVChartBaseView:(SVChartBaseView*)vc WithDic:(NSDictionary*)dic;


@end
@interface SVChartBaseView : UIView  
{
    CGFloat offsetY;
    CGFloat keyBoardHieght;
}
@property (nonatomic,weak) id <SVChartBaseViewDelegate> delegate;
@property (nonatomic,strong) UILabel* titleLabel;
@property (nonatomic,strong) SVStatisticsView * chartView;

-(void)setTitle:(NSString*)title;
-(void)refreshFromDiction:(NSDictionary*)dic;
-(NSDictionary*)configSetting;
-(CGFloat)screenH;
-(CGFloat)screenW;
-(CGFloat)rateOfwidth;
-(CGFloat)rateOfHeight;
-(BOOL)islandScape;
@end
