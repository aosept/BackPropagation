
#import <UIKit/UIKit.h>


@class SVFunctionViewController;
@protocol SVFunctionViewControllerDelegate <NSObject>

-(void)updateSVFunctionViewController:(SVFunctionViewController*)vc WithDic:(NSDictionary*)dic;


@end
@interface SVFunctionViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>
{
    CGFloat offsetY;
    CGFloat keyBoardHieght;
}
@property (nonatomic,weak) id <SVFunctionViewControllerDelegate> delegate;

@property (nonatomic,strong) UITableView * tableView;
-(void)refreshFromDiction:(NSDictionary*)dic;
-(NSDictionary*)configSetting;
@end
