





#import "SVFunctionViewController.h"
#import "SVNNNViewController.h"
@interface SVFunctionViewController ()

@end

@implementation SVFunctionViewController

-(UITableView*)tableView
{
    if (_tableView == nil) {
        _tableView = [UITableView new];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.layer.borderWidth = 0.5;
        _tableView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    }
    return _tableView;
}
-(NSArray*)dataSource
{
    return @[
             
             @{@"desc":@"NNN",
               @"vc":@"SVNNNViewController"
               },
            
             ];
}
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat rate = [self rateOfwidth];
    if(rate == 0)
    {
        rate = [self screenW]/667.0;
    }
    
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
    
    CGFloat    tableView_Width = 375.00*rate;
    CGFloat    tableView_Height = 607.00*rateH;
    
    x =  left;
    y =  top;
    w = tableView_Width;
    h = tableView_Height;
    self.tableView.frame = CGRectMake(x, y, w, h);
    
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


#pragma mark - TableView Delegate & Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self dataSource].count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"ListCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSArray* array = [self dataSource];
    NSDictionary* dic  = array[indexPath.row];
    
    cell.textLabel.text = dic[@"desc"];
    cell.backgroundColor = [UIColor whiteColor];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray* array = [self dataSource];
    NSDictionary* dic  = array[indexPath.row];
    NSString* vcName = dic[@"vc"];
    UIViewController * vc = [NSClassFromString(vcName) new];
    vc.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:vc animated:YES];
    
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

