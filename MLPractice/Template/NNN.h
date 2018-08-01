
#import <UIKit/UIKit.h>


@class NNN;
@class SVChartView;
@protocol NNNDelegate <NSObject>

-(void)updateNNN:(NNN*)vc WithDic:(NSDictionary*)dic;


-(void)buttonOfNNN:(NNN*)vc DidClickedWithName:(NSString*)name;

@end
@interface NNN : UIViewController
{
    CGFloat offsetY;
    CGFloat keyBoardHieght;
}
@property (nonatomic,weak) id <NNNDelegate> delegate;

@property (nonatomic,strong) __block SVChartView * dataChartView;

@property (nonatomic,strong) UIButton * runButton;

@property (nonatomic,strong) UIScrollView * scrollView;
-(void)refreshFromDiction:(NSDictionary*)dic;
-(NSDictionary*)configSetting;
@end

