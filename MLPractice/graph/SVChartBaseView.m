





#import "SVChartBaseView.h"
   
@interface SVChartBaseView ()
@end
                       
@implementation SVChartBaseView

-(void)setTitle:(NSString*)title
{
    self.titleLabel.text = title;
}
-(UILabel*)titleLabel
{
    if(_titleLabel == nil)
    {
        _titleLabel = [UILabel new];
        
        CGFloat rate = [self rateOfHeight];
        _titleLabel.textColor = [UIColor colorWithWhite:86.0/255.0 alpha:1.0];
        _titleLabel.font = [UIFont systemFontOfSize:17.0*rate];
        _titleLabel.adjustsFontSizeToFitWidth = YES;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _titleLabel;
}
-(SVStatisticsView*)chartView
{
    if (_chartView == nil) {
        _chartView = [SVStatisticsView new];
        _chartView.backgroundColor = [UIColor whiteColor];
        _chartView.style = SVStatisticsViewPie;
    }
    return _chartView;
}
        
- (void)addAllViews
{


    
    [self addSubview:self.chartView];
    [self addSubview:self.titleLabel];
    
    CGFloat rate = [self rateOfwidth];
    if(rate == 0)
    {
        rate = [self screenW]/667.0;
    }



}

-(void)layoutSubviews
{
	
                                   
}
-(void)buttonDidClicked:(UIButton*)button

{

}

-(void)refreshFromDiction:(NSDictionary*)dic
{

    /*
    
    */
    if(dic)
    {
        
    }
}
    

-(UIButton*)buildButtonWith:(NSString*)title andAction:(SEL)action
{
    UIButton * button = [UIButton new];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor whiteColor];
    button.layer.borderColor = [UIColor blackColor].CGColor;
    button.layer.borderWidth = 0.0;
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:0.9 green:0.7 blue:0.8 alpha:1.0] forState:UIControlStateHighlighted];
    button.titleLabel.adjustsFontSizeToFitWidth = YES;
    return button;
}
    
-(id)init
{
    self = [super init];
    if(self)
    {
        self.backgroundColor = [UIColor whiteColor];
        [self addAllViews];
    }
    return self;
}
-(CGFloat)screenH
{
    
    if ([UIScreen mainScreen].bounds.size.width < [UIScreen mainScreen].bounds.size.height) {
        return self.frame.size.height;
    }
    else
        return self.frame.size.width;
}

-(CGFloat)screenW
{
    if (self.frame.size.width < self.frame.size.height)
    {
        return self.frame.size.height;
    }
    else
    return self.frame.size.width;
    
}

-(CGFloat)rateOfwidth
{
    CGFloat rate = self.frame.size.width/375.0;
    if(rate == 0)
        rate = [UIScreen mainScreen].bounds.size.width/375.0;
        
    return rate;
}

-(CGFloat)rateOfHeight
{
    CGFloat rate = self.frame.size.height/667.0;
    return rate;
}

-(BOOL)islandScape
{
    return NO;
}
    
-(NSDictionary*)configSetting
{
    NSDictionary * dic = @{
    };
    return dic;
}
@end
    
    
    
    
    
    
    
    
    
    
//the end
    
