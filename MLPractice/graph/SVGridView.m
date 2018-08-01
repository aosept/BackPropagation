





#import "SVGridView.h"
#import "MSDateUtils.h"

@interface SVGridView () <UIScrollViewDelegate>
{
    NSString* lastName;
    CGFloat gW;
}
@property (nonatomic, strong) NSMutableDictionary* dataViewList;

@property (nonatomic,strong) UIScrollView * scrollView;

@end

@implementation SVGridView

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    debug_function_and_line_info;
    
    CGPoint offsetPoint = scrollView.contentOffset;
    offsetPoint.x = offsetPoint.x + self.scrollView.frame.size.width/2.0;
    offsetPoint.y = offsetPoint.y + self.scrollView.frame.size.height/2.0;
    
    for (NSString* keyname in self.dataViewList) {
        
        UIView* view = self.dataViewList[keyname];
        if ([view isKindOfClass:[UIView class]]) {
            
            CGRect itemRect = view.frame;
            
            if (CGRectContainsPoint(itemRect, offsetPoint)) {
                debug_function_and_line_info;
                if([self.delegate respondsToSelector:@selector(moveToFocus:Name:)])
                {
                    lastName = keyname;
                    [self.delegate moveToFocus:self Name:keyname];
                }
            }
        }
    }
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    debug_function_and_line_info;
    CGPoint offsetPoint = scrollView.contentOffset;
    offsetPoint.x = offsetPoint.x + self.scrollView.frame.size.width/2.0;
    offsetPoint.y = offsetPoint.y + self.scrollView.frame.size.height/2.0;
    
    BOOL hasDisplay = NO;
    for (NSString* keyname in self.dataViewList) {
        
        UIView* view = self.dataViewList[keyname];
        if ([view isKindOfClass:[UIView class]]) {
            
            CGRect itemRect = view.frame;
            
            if (CGRectContainsPoint(itemRect, offsetPoint)) {
                debug_function_and_line_info;
                if([self.delegate respondsToSelector:@selector(stopToFocus:Name:)])
                {
                    hasDisplay = YES;
                    [self.delegate stopToFocus:self Name:keyname];
                }
            }
        }
    }
    if (hasDisplay == NO && lastName == nil) {
        if([self.delegate respondsToSelector:@selector(stopToFocus:Name:)])
        {
            hasDisplay = YES;
            [self.delegate stopToFocus:self Name:lastName];
        }
    }
}
-(void)setDataList:(NSArray *)dataList
{
    if(self.delegate == nil)
    {
        return;
    }
    if ([self.delegate respondsToSelector:@selector(uiviewForGridView:ByName:)] == NO) {
        NSLog(@"uiviewByName: must be implemented.");
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(rectByForGridView:Name:)] == NO) {
        NSLog(@"rectByName: must be implemented.");
        return;
    }
    
    _dataList = dataList;
    if(dataList == nil)
    {
        for (NSString* keyName in self.dataViewList.allKeys) {
            UIView* subView = self.dataViewList[keyName];
            
            [subView removeFromSuperview];
        }
        [self.dataViewList removeAllObjects];
    }
    else
    {
        for (NSString* name in dataList) {
            UIView* subView = [self.delegate uiviewForGridView:self ByName:name];
            [self.scrollView addSubview:subView];
            self.dataViewList[name] = subView;
        }
        
        [self layoutSubviews];
    }
    
}

-(NSMutableDictionary*)dataViewList
{
    if(_dataViewList == nil)
    {
        _dataViewList = [NSMutableDictionary new];
    }
    return _dataViewList;
}

-(UIScrollView*)scrollView
{
    if (_scrollView == nil) {
        _scrollView = [UIScrollView new];
        _scrollView.delegate = self;
        _scrollView.backgroundColor = [UIColor whiteColor];
        //_scrollView.adjustsFontSizeToFitWidth = YES;
    }
    return _scrollView;
}

- (void)addAllViews
{
    
    [self addSubview:self.scrollView];
    
}
-(CGFloat)imageItemHeight
{
    CGFloat h;
    if(self.col == 0)
    {
        h = self.frame.size.height;
    }
    else
    {
        h = self.frame.size.width/self.col;
    }
    return h;
}
-(void)layoutSubviews
{
    if(self.delegate == nil)
    {
        return;
    }
    if ([self.delegate respondsToSelector:@selector(uiviewForGridView:ByName:)] == NO) {
        NSLog(@"uiviewByName: must be implemented.");
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(rectByForGridView:Name:)] == NO) {
        NSLog(@"rectByName: must be implemented.");
        return;
    }
    
    if(gW == 0)
    {
        if(self.col != 0)
            gW = self.frame.size.width/self.col;
    }
    else
    {
        if(self.col != 0 )
        {
            self.col = self.frame.size.width/gW;
        }
    }
    CGFloat x,y,w,h;
    
    x = 0; y = 0;
    
    
    x = self.left;
    y = self.top;
    h = [self imageItemHeight];
    w = h*self.rate;
    CGFloat itemH = [self imageItemHeight];
    if(self.col == 0)
    {
       
    }
    else
    {
        itemH = itemH/self.rate;
    }
    CGFloat aglinX = 0,aglinY = 0;
    int i = 0;
    if(h == 0)
        return;
    
    for (NSString* name in self.dataList) {
        
        UIView* subView = self.dataViewList[name];
        
        CGFloat imgW,imgH;
        CGRect subViewRect = [self.delegate rectByForGridView:self Name:name];
        
        imgH = subViewRect.size.height;
        imgW = subViewRect.size.width;
        
        
        h = [self imageItemHeight];
        if(self.col == 0)
            w = h*self.rate;
        else
        {
            w = h;
            h = w/self.rate;
        }
        if(imgW > imgH)
        {
            h =  imgH*( w/imgW);
        }
        else if(imgW < imgH)
        {
            w =  imgW*( h/imgH);
        }
        
        aglinX = (itemH*self.rate - w)/2.0;
        aglinY = (itemH - h)/2.0;
        subView.frame = CGRectMake(x+aglinX, y+aglinY, w, h);
        
        if(self.col == 0)
        {
            x = x + self.wgap + itemH*self.rate;
        }
        else
        {
            i++;
            if(i%self.col != 0)
            {
                x = x + self.wgap + itemH*self.rate;
            }
           else
           {
               y = y + self.hgap + itemH;
               x = self.left;
           }
            
        }
       
    }
    
    if(self.col == 0)
    {
            y = y + h;
    }
    CGSize size = CGSizeMake(x+self.left, y+self.top);
    [self.scrollView setContentSize:size];
    
   
    x = 0;
    y = 0;
    w = self.frame.size.width;
    h = self.frame.size.height;
    self.scrollView.frame = CGRectMake(x, y, w, h);
    
}
-(void)buttonDidClicked:(UIButton*)button
{
    
}

-(void)refreshFromDiction:(NSDictionary*)dic // defaultColor,hightlightColor
{
    
    /*
     
     */
    
    
    if(dic[kGridViewName] && dic[kGridViewDefaultColor] && dic[kGridViewHightlightColor])
    {
        NSString* currentName = dic[@"name"];
        for (NSString* keyname in self.dataViewList) {
            
            UIView* view = self.dataViewList[keyname];
            if ([view isKindOfClass:[UIView class]]) {
                if([keyname isEqualToString:currentName])
                {
                    view.backgroundColor = dic[kGridViewHightlightColor];
                }
                else
                {
                    view.backgroundColor = dic[kGridViewDefaultColor];
                }
            }
        }
    }
}


-(id)init
{
    self = [super init];
    if(self)
    {
        gW = 0;
        self.rate = 1;
        self.wgap = 0;
        self.top = 0;
        self.hgap = 0;
        [self addAllViews];
    }
    return self;
}
-(id)initWith:(NSInteger)col and:(id<SVGridViewDelegate>)delegate
{
    self = [super init];
    if(self)
    {
        self.delegate = delegate;
        self.col = col;
        gW = 0;
        self.rate = 1;
        self.wgap = 0;
        self.top = 0;
        self.hgap = 0;
        [self addAllViews];
    }
    return self;
}

-(NSDictionary*)configSetting
{
    NSDictionary * dic = @{
                           };
    return dic;
}
-(void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:backgroundColor];
    self.scrollView.backgroundColor = backgroundColor;
}
@end


@implementation SVGridViewDelegateObject
-(UIView*)uiviewForGridView:(SVGridView *)gridView ByName:(NSString *)name
{
    UIView* view = [UIView new];
    return view;
}
-(CGRect)rectByForGridView:(SVGridView *)gridView Name:(NSString *)name
{
    CGFloat x,y,w,h;
    x = 0;
    y = 0;
    h = 100;
    w = 100;
    return CGRectMake(x,y,w,h);
}

- (void)updateSVGridView:(SVGridView *)gridView WithDic:(NSDictionary *)dic
{
    
}

@end






