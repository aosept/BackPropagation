





#import "NNN.h"
#import "SVChartView.h"
@interface NNN ()

@end

@implementation NNN

-(SVChartView*)dataChartView
{
    if (_dataChartView == nil) {
        _dataChartView = [SVChartView new];
        _dataChartView.backgroundColor = [UIColor whiteColor];
        _dataChartView.layer.borderWidth = 0;
        _dataChartView.layer.borderColor = [UIColor clearColor].CGColor;
    }
    return _dataChartView;
}


-(UIButton*)runButton
{
    if (_runButton == nil) {
        _runButton = [self buildButtonWith:@"runButton" andAction:@selector(buttonDidClicked:)];
    }
    return _runButton;
}

-(UIScrollView*)scrollView
{
    if (_scrollView == nil) {
        _scrollView = [UIScrollView new];
        _scrollView.backgroundColor = [UIColor whiteColor];
        
    }
    return _scrollView;
}


- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    
    [self.view addSubview:self.scrollView];
    if (@available(iOS 11.0, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.automaticallyAdjustsScrollViewInsets = YES;
    }
    
    [self.scrollView addSubview:self.dataChartView];
    
    [self.scrollView addSubview:self.runButton];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat rate = [self rateOfwidth];
    if(rate == 0)
    {
        rate = [self screenW]/667.0;
    }
    
    self.dataChartView.backgroundColor = [UIColor clearColor];
    
}

-(void)viewDidLayoutSubviews
{
    CGFloat left,top;
    CGFloat x,y,w,h;
    CGFloat rate = [self rateOfwidth];
    CGFloat rateH = [self rateOfHeight];
    CGFloat xInterval = 10.0,yInterval = 10.0;
    left = 0.00*rate;
    top = 0.00;
    CGFloat sw = [self screenW];
    CGFloat wr = sw/375.0;
    CGFloat wh = [self screenH];
    CGFloat nomalR = wh - 667.0*wr;
    CGFloat fixTop = 0;
    CGFloat fixLeft = 0;
    if (@available(iOS 11.0, *)) {
        fixTop = self.view.safeAreaInsets.top;//remove this line if has error
    } else {
        fixTop = 0;
    }
    if (@available(iOS 11.0, *)) {
        fixLeft = self.view.safeAreaInsets.left;//remove this line if has error
    } else {
        fixLeft = 0;
    }
    left += fixLeft;
    top += fixTop;
    top += offsetY;
    CGFloat contentw,contenth;
    
    CGFloat    dataChartView_Width = 375.00*rate;
    CGFloat    dataChartView_Height = 300.00*rateH;
    CGFloat    runButton_xInterval = 293.00*rate;
    CGFloat    runButton_yInterval = 5.00*rateH;
    CGFloat    runButton_Width = 60.90*rate;
    CGFloat    runButton_Height = 31.00*rateH;
    
    x =  left;
    y =  top;
    w = dataChartView_Width;
    h = dataChartView_Height;
    self.dataChartView.frame = CGRectMake(x, y, w, h);
    
    yInterval = runButton_yInterval;
    xInterval = runButton_xInterval;
    x =  left + xInterval;
    y =  y + h + yInterval;
    w = runButton_Width;
    h = runButton_Height;
    self.runButton.frame = CGRectMake(x, y, w, h);
    
    contenth = y+h+keyBoardHieght;
    
    x = 0;
    y = 0;
    w = [UIScreen mainScreen].bounds.size.width;
    h = [UIScreen mainScreen].bounds.size.height;
    
    self.scrollView.frame = CGRectMake(x, y, w, h);
    contentw = w;
    self.scrollView.contentSize = CGSizeMake(contentw, contenth);
    
}
-(void)buttonDidClicked:(UIButton*)button

{
    
    if(button == self.runButton)
    {
        NSLog(@"self.runButton is clicked");
        [self runButtonClicked];
        
        if([self.delegate respondsToSelector:@selector(buttonOfNNN:DidClickedWithName:)])
        {
            [self.delegate buttonOfNNN:self DidClickedWithName:@"run"];
        }
        else
        {
            NSLog(@"Method buttonOfNNN:self DidClickedWithName: not implemented");
        }
    }
    
}

-(void)runButtonClicked
{
    
    NSLog(@"self.runButton is clicked");
}

-(void)refreshFromDiction:(NSDictionary*)dic
{
    
    /*
     
     */
    if(dic)
    {
        
    }
}

-(void)keyboardShow:(NSNotification *)note
{
    CGRect keyBoardRect=[note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyBoardHieght=keyBoardRect.size.height;
    
    
}

-(void)keyboardHide:(NSNotification *)note
{
    keyBoardHieght = 0;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(UIButton*)buildButtonWith:(NSString*)title andAction:(SEL)action
{
    UIButton * button = [UIButton new];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor whiteColor];
    button.layer.borderColor = [UIColor blackColor].CGColor;
    button.layer.borderWidth = 1.0;
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:0.9 green:0.7 blue:0.8 alpha:1.0] forState:UIControlStateHighlighted];
    button.titleLabel.adjustsFontSizeToFitWidth = YES;
    return button;
}


-(CGFloat)screenH
{
    
    if (self.view.bounds.size.width < self.view.bounds.size.height) {
        return self.view.bounds.size.height;
    }
    else
        return self.view.bounds.size.width;
}

-(CGFloat)screenW
{
    
    if (self.view.bounds.size.width < self.view.bounds.size.height) {
        return self.view.bounds.size.width;
    }
    else
        return self.view.bounds.size.height;
}
-(CGFloat)rateOfwidth
{
    CGFloat rate = self.view.bounds.size.width/375.0;
    return rate;
}
-(CGFloat)rateOfHeight
{
    CGFloat rate = self.view.bounds.size.height/667.0;
    return rate;
}
-(BOOL)islandScape
{
    if (self.view.bounds.size.width < self.view.bounds.size.height) {
        return NO;
    }
    else
        return YES;
}
@end















//the end

