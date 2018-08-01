
#import "SVChartView.h"
//#import "MSDateUtils.h"

@interface SVChartView()
{
  
}
@property (nonatomic,strong) NSMutableDictionary* uiDictionary;
@property (nonatomic,strong) NSMutableDictionary* colorDicnary;
@property (nonatomic,strong) NSMutableArray* uikeyArray;

@end
@implementation SVChartView

-(NSMutableArray*)uikeyArray
{
    if(_uikeyArray == nil)
    {
        _uikeyArray = [NSMutableArray new];
    }
    return _uikeyArray;
}
-(NSMutableDictionary*)dataDic
{
    if (_dataDic == nil) {
        _dataDic = [NSMutableDictionary new];
    }
    return _dataDic;
}
-(NSMutableDictionary*)uiDictionary
{
    if(_uiDictionary == nil)
    {
        _uiDictionary = [NSMutableDictionary new];
    }
    return _uiDictionary;
}
-(NSMutableDictionary*)colorDicnary
{
    if(_colorDicnary == nil)
    {
        _colorDicnary = [NSMutableDictionary new];
    }
    return _colorDicnary;
}
-(void)refreshUIAsSheet
{
    for (NSString* key in self.uiDictionary) {
        UIView* view = self.uiDictionary[key];
        [view removeFromSuperview];
    }
    [self.uikeyArray removeAllObjects];
    self.chartView.colorArray = @[];
    NSMutableArray* dataArray = [NSMutableArray new];
    NSInteger c = self.dataDic.count;
    self.chartView.maxy = 0;
    self.chartView.miny = FLT_MAX;
    for (NSString* key in self.dataDic.allKeys) {
        @autoreleasepool {
            id valueObj = self.dataDic[key];
            if([valueObj isKindOfClass:[NSNumber class]])
            {
                
            }
            else if([valueObj isKindOfClass:[NSArray class]])
            {
                
                
                [dataArray addObject:valueObj];
                
                NSString* pointKey = SafeStringExt(key,@"point");
                NSString* titleKey = SafeStringExt(key,@"title");
                NSString* valueKey = SafeStringExt(key,@"value");
                NSString* colorKey = SafeStringExt(key,@"color");
                
                UIColor* color = self.colorDicnary[colorKey];
                if(color == nil)
                {
                    color = [self.chartView randColor];
                    self.colorDicnary[colorKey] = color;
                }
                
                self.chartView.colorArray = [self.chartView.colorArray arrayByAddingObject:color];
                
                UIView *pointView = [self buildViewWithKey:pointKey andColor:color];
                UILabel *titleLabel = [self buildLabelWithKey:titleKey andColor:[UIColor colorWithWhite:86.0/255.0 alpha:1.0]
                                                      andText:key];
                titleLabel.textAlignment = NSTextAlignmentLeft;
                
                
                
                [self addSubview:pointView];
                [self addSubview:titleLabel];
                
            }
            else
            {
                
            }
            
            [self.uikeyArray addObject:key];
        }
        
        
    }
    self.chartView.dataMartix = dataArray;
    
   
    [self.chartView setNeedsDisplay];
    [self.chartView layoutSubviews];
}
-(void)refreshUI
{

    for (NSString* key in self.uiDictionary) {
        UIView* view = self.uiDictionary[key];
        [view removeFromSuperview];
    }
    CGFloat rate = [self rateOfHeight];
    [self.uikeyArray removeAllObjects];
    self.chartView.colorArray = @[];
    NSMutableArray* dataArray = [NSMutableArray new];
    NSInteger c = self.dataDic.count;
    
    for (NSString* key in self.dataDic.allKeys) {
        
        @autoreleasepool {
            id valueObj = self.dataDic[key];
            if([valueObj isKindOfClass:[NSNumber class]])
            {
                NSNumber* value = valueObj;
                NSNumber* number = [NSNumber numberWithDouble:[value doubleValue]];
                [dataArray addObject:number];
                
                NSString* pointKey = SafeStringExt(key,@"point");
                NSString* titleKey = SafeStringExt(key,@"title");
                NSString* valueKey = SafeStringExt(key,@"value");
                NSString* colorKey = SafeStringExt(key,@"color");
                
                UIColor* color = self.colorDicnary[colorKey];
                if(color == nil)
                {
                    color = [self.chartView randColor];
                    self.colorDicnary[colorKey] = color;
                }
                
                self.chartView.colorArray = [self.chartView.colorArray arrayByAddingObject:color];
                
                UIView *pointView = [self buildViewWithKey:pointKey andColor:color];
                UILabel *titleLabel = [self buildLabelWithKey:titleKey andColor:[UIColor colorWithWhite:86.0/255.0 alpha:1.0]
                                                      andText:key];
                titleLabel.textAlignment = NSTextAlignmentLeft;
                NSString* valueString = [NSString stringWithFormat:@"%.4f",value.doubleValue];
                UILabel *valueLabel =  [self buildLabelWithKey:valueKey andColor:color andText:valueString];
                
                valueLabel.font = [UIFont systemFontOfSize:13.0*rate];
                valueLabel.textAlignment = NSTextAlignmentRight;
                
                [self addSubview:pointView];
                [self addSubview:titleLabel];
                [self addSubview:valueLabel];
            }
            else if([valueObj isKindOfClass:[NSNumber class]])
            {
                [dataArray addObject:valueObj];
            }
            else
            {
                
            }
            
            
            [self.uikeyArray addObject:key];
        }
        
        
    }
    self.chartView.dataMartix = @[dataArray];
    
    
}

-(UILabel*)buildLabelWithKey:(NSString*)keyName andColor:(UIColor*)color andText:(NSString*)text
{
    UILabel *label = self.uiDictionary[keyName];
    if (label == nil) {
        label = [UILabel new];
        self.uiDictionary[keyName] = label;
        
    }
    CGFloat rate = [self rateOfHeight];
    label.text = SafeString(text);
    label.textColor = color;
    label.font = [UIFont systemFontOfSize:17.0*rate];
    label.adjustsFontSizeToFitWidth = YES;
    label.backgroundColor = [UIColor clearColor];
    return label;
}
-(UIView*)buildViewWithKey:(NSString*)keyName andColor:(UIColor*)color
{
    UIView *view = self.uiDictionary[keyName];
    if (view == nil) {
        view = [UILabel new];
        self.uiDictionary[keyName] = view;
        
    }

    view.backgroundColor = color;
    return view;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat left,top;
    CGFloat x,y,w,h;
    CGFloat rate = [self rateOfwidth];
    CGFloat rateH = [self rateOfHeight];
    CGFloat xInterval = 10.0,yInterval = 10.0;
    left = 10.00*rate;
    top = 20.00*rateH;
    CGFloat sw = [self screenW];
    CGFloat wr = sw/375.0;
    CGFloat wh = [self screenH];
    CGFloat nomalR = wh - 667.0*wr;
    CGFloat fixTop = 0;
    CGFloat fixLeft = 0;
    if (@available(iOS 11.0, *)) {
        fixTop = self.safeAreaInsets.top;//remove this line if has error
    } else {
        fixTop = 0;
    }
    if (@available(iOS 11.0, *)) {
        fixLeft = self.safeAreaInsets.left;//remove this line if has error
    } else {
        fixLeft = 0;
    }
    left += fixLeft;
    top += fixTop;
    top += offsetY;
    
    
    y = 5*rateH;
    x = 50*rate;
    w = self.frame.size.width - 2*x;
    h = 20*rateH;
    self.titleLabel.frame =  CGRectMake(x, y, w, h);
    
    CGFloat    chartView_Width = 105.00*rateH;
    CGFloat    chartView_Height = 105.00*rateH;
    
    x =  left;
    y =  top;
    
    if (self.chartView.style == SVStatisticsViewLine || self.chartView.style == SVStatisticsViewLine2) {
        left = 0;

        top = 30*rateH;
        x =  left;
        y =  top;
        w =  self.frame.size.width - 2*x;
        h =  self.frame.size.height - y - 50*rateH;
        
        y =  top;
        
        self.chartView.frame = CGRectMake(x, y, w, h);
        
        
        
        y = y + h + yInterval;
        
        CGFloat vh  = 18*rateH;
        
        yInterval = 10*rateH;
        CGFloat xstep = 15*rate;
        xInterval = 10*rateH;
        left = 20*rate;
        x = left;
        
        for (NSString* key in self.uikeyArray) {
            NSString* titleKey = SafeStringExt(key,@"title");
            NSString* pointKey = SafeStringExt(key,@"point");

            
            UIView *pointView = self.uiDictionary[pointKey];
            UILabel *titleLabel = self.uiDictionary[titleKey];

            h = vh*0.6;
            w = h;
            
            CGFloat fixY = (vh - h)/2.0;
            pointView.layer.cornerRadius = h/2.0;
            pointView.clipsToBounds = YES;
            
            y = y + fixY;
            pointView.frame = CGRectMake(x, y, w, h);
            
            y = y- fixY;
            x = x + w + xInterval;
            h = vh;
            w = xstep*titleLabel.text.length;
            titleLabel.frame = CGRectMake(x, y, w, h);
           
            x = x + w + xInterval;
            if(x + 100 > self.frame.size.width)
            {
                x = left;
                y = y + h + yInterval;
            }
        }
    }
    else
    {
        w = chartView_Width;
        h = chartView_Height;
        
        y =  (self.frame.size.height - h)/2.0;
        
        self.chartView.frame = CGRectMake(x, y, w, h);
        
        
        
        
        CGFloat vh  = 18*rateH;
        yInterval = 10*rateH;
        xInterval = 10*rate;
        
        
        
        left = (self.chartView.frame.origin.x)*2 + self.chartView.frame.size.width;
        NSInteger c =  [self.dataDic count];
        top = (self.frame.size.height - c*vh - (c-1)*yInterval)/2.0;
        if( top  < 10)
        {
            top  = 10;
            CGFloat ystep = (self.frame.size.height - 2*top)/ ((c- 1)*2 + c*3);
            vh = ystep *3;
            yInterval = ystep*2;
        }
        x = left;
        y = top;
        
        for (NSString* key in self.uikeyArray) {
            NSString* titleKey = SafeStringExt(key,@"title");
            NSString* valueKey = SafeStringExt(key,@"value");
            NSString* pointKey = SafeStringExt(key,@"point");
            
            UIView *pointView = self.uiDictionary[pointKey];
            UILabel *titleLabel = self.uiDictionary[titleKey];
            UILabel *valueLabel =  self.uiDictionary[valueKey];
            h = vh*0.6;
            w = h;
            
            CGFloat fixY = (vh - h)/2.0;
            pointView.layer.cornerRadius = h/2.0;
            pointView.clipsToBounds = YES;
            
            y = y + fixY;
            pointView.frame = CGRectMake(x, y, w, h);
            
            y = y- fixY;
            x = x + w + xInterval;
            h = vh;
            w = 110*rate;
            titleLabel.frame = CGRectMake(x, y, w, h);
            w = 50*rate;
            x = self.frame.size.width - w - 30*rate;
            h = vh*0.6;
            
            fixY = (vh - h)/2.0;
            y = y + fixY;
            valueLabel.frame = CGRectMake(x, y, w, h);
            
            y = y - fixY;
            
            y = y + h + yInterval + 2*fixY;
            x = left;
        }
    }
    
}
-(CGFloat)rateOfHeight
{
    CGFloat rate = [UIScreen mainScreen].bounds.size.height/667.0;
    return rate;
}
-(CGFloat)rateOfWidth
{
    CGFloat rate = self.frame.size.width/375.0;
    return rate;
}
@end
