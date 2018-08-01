//
//  SVNNNViewController.m
//  MLPractice
//
//  Created by 威 沈 on 02/07/2018.
//  Copyright © 2018 ShenWei. All rights reserved.
//
#import <objc/NSObjCRuntime.h>
#import "SVNNNViewController.h"

#import "MSDateUtils.h"
#import "SVChartView.h"
#import "SVNetWork.hpp"


static void didRecieveData_t(const void*callback,const char *key, const char *value,double delta);
static void didRecieveData(const void*callback,const char *key, const char *value,double delta)
{

    std::thread loop;
    loop = std::thread(didRecieveData_t,callback,key,value,delta);
    if (loop.joinable()) {
        loop.join();
    }

}
static void didRecieveData_t(const void*callback,const char *key, const char *value,double delta)
{
    NSLog(@"--->%.9f",delta);
    void *point = &delta;
    if(point == NULL)
    {
        NSLog(@"Nan");
    }
    else
    {
        SVNNNViewController* vc = (__bridge SVNNNViewController*)callback;
        [vc dataRecived:delta];
    }
}
@interface SVNNNViewController ()
{
//    __block nnbp* innbp;
    SVNetWork* network;
    NSArray* array;
}

@end

@implementation SVNNNViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    network = NULL;
    self.dataChartView.chartView.style = SVStatisticsViewLine;
    self.dataChartView.chartView.colorArray = @[[UIColor greenColor],[UIColor blueColor],[UIColor redColor]];

    array  = @[];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        int countOfwconfig = 2;
        int wconfig[2] = {5,2};
        
        int inputCount = 2;
        int outputCount = 1;
        int trainingCount = 4;
        
        
        self->network = new SVNetWork(countOfwconfig,inputCount,outputCount,trainingCount,wconfig);
        
        
        double xx[4][2] = { {1,0,},
            {0,1},
            {1,1},
            {0,0},
        };
        double tt[4][1] = { {1,},
            {1,},
            {0,},
            {0,},
        };
        self->network->dataListSet(*xx,*tt);
    
        self->network->didRecieveDataCallback = didRecieveData;
        self->network->callbackNSObject = (__bridge void*)self;
    });
    
    
    
    NSLog(@"");
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [self.dataChartView refreshUIAsSheet];
    
   
    array = @[];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)dealloc
{
    if(network != NULL)
        delete network;
    network = NULL;
}


-(void)runButtonClicked
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{

        [self goNNN];
    });
    NSLog(@"");
    return;
}

-(void)goNNN
{
    
    network->trainWithMultiDataCount(1000, 0.001);
    
    
}
-(void)dataRecived:(CGFloat)delta
{
    static int count = 0;
    
    array = [array arrayByAddingObject:[NSNumber numberWithDouble:delta]];
    if(count%100 == 0)
    {
    
        [self updateGraph:array];
    }
}
-(void)updateGraph:(NSArray*)array
{
    __weak __typeof__(self) weakSelf = self;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        runOnMainQueueWithoutDeadlocking(^{
            
            strongSelf.dataChartView.dataDic[@"r"] = array;
            //            strongSelf.dataChartView.dataDic[@"w2"] = w;
            [strongSelf.dataChartView refreshUIAsSheet];
        });
        
    });
    
    
}
@end
