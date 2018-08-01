
#import "SVChartBaseView.h"

@interface SVChartView : SVChartBaseView
@property (nonatomic,strong) NSMutableDictionary* dataDic;

-(void)refreshUI;
-(void)refreshUIAsSheet;
@end
