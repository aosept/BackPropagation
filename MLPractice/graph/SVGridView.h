
#import <UIKit/UIKit.h>

#define kGridViewName @"name"
#define kGridViewDefaultColor @"defaultColor"
#define kGridViewHightlightColor @"hightlightColor"

@class SVGridView;
@protocol SVGridViewDelegate <NSObject>

-(void)updateSVGridView:(SVGridView*)gridView WithDic:(NSDictionary*)dic;
-(UIView*)uiviewForGridView:(SVGridView*)gridView ByName:(NSString*)name;
-(CGRect)rectByForGridView:(SVGridView*)gridView Name:(NSString*)name;
-(void)moveToFocus:(SVGridView*)gridView Name:(NSString*)name;
-(void)stopToFocus:(SVGridView *)gridView Name:(NSString *)name;

@end
@interface SVGridView : UIView

@property (nonatomic, strong) NSArray* dataList; // strings array


@property (nonatomic,weak) id <SVGridViewDelegate> delegate;
@property (nonatomic,assign) NSInteger col; //为0 的时候显示一排
@property (nonatomic,assign) CGFloat rate; // 宽与高的比例
@property (nonatomic,assign) CGFloat wgap;
@property (nonatomic,assign) CGFloat hgap;
@property (nonatomic,assign) CGFloat top;
@property (nonatomic,assign) CGFloat left;

-(id)initWith:(NSInteger)col and:(id<SVGridViewDelegate>)delegate;
-(void)refreshFromDiction:(NSDictionary*)dic;
-(NSDictionary*)configSetting;
@end

@interface SVGridViewDelegateObject : NSObject <SVGridViewDelegate>
@end
