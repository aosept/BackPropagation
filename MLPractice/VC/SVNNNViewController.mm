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
#import "NNManager.h"

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
    
    SVNNNViewController* vc = (__bridge SVNNNViewController*)callback;
    [vc dataRecived:delta];
}
@interface SVNNNViewController ()
{
//    __block nnbp* innbp;
    SVNetWork* network;
    NSArray* array;
    __block int displayStep;
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
        
        [self autoencoderInit];
    });
    
    
    
    NSLog(@"");
}
-(void)autoencoderInit
{
    int countOfwconfig = 2;
    int wconfig[2] = {5,2};
    
    int inputCount = 2;
    int outputCount = 2;
    int trainingCount = 4;
    
    double xx[4][2] = {
        {1,1,},
        {1,0,},
        {0,1,},
        {0,0,},
        
    };
    double tt[4][2] = {
        {1,1,},
        {1,0,},
        {0,1,},
        {0,0,},
        
    };
    
    self->network = new SVNetWork(countOfwconfig,inputCount,outputCount,trainingCount,wconfig);
    
    
    
    self->network->dataListSet(*xx,*tt);
    
    self->network->didRecieveDataCallback = didRecieveData;
    self->network->callbackNSObject = (__bridge void*)self;
}
-(void)n66init
{
    int countOfwconfig = 3;
    int wconfig[3] = {5,5,1};
    
    int inputCount = 4;
    int outputCount = 1;
    int trainingCount = 6;
    
    double xx[6][4] = { {1,1,0,0,},
        {1,0,0,1,},
        {1,0,1,0,},
        {0,1,0,1,},
        {0,0,1,1,},
        {0,1,1,0,},
    };
    double tt[6][1] = { {0.165,},
        {0.33,},
        {0.495,},
        {0.66,},
        {0.825,},
        {1,},
    };
    
    self->network = new SVNetWork(countOfwconfig,inputCount,outputCount,trainingCount,wconfig);
    
    
    
    self->network->dataListSet(*xx,*tt);
    
    self->network->didRecieveDataCallback = didRecieveData;
    self->network->callbackNSObject = (__bridge void*)self;
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
    
    network->trainWithMultiDataCount(1000000000, 0.001);
    network->showResult();
    
    displayStep = 1;
    
}
-(void)dataRecived:(CGFloat)delta
{
    
    if(delta < 5000 && delta > 0)
    {
        @autoreleasepool {
            NSNumber* number = [NSNumber numberWithDouble:delta];
            if ([number isKindOfClass:[NSNumber class]]) {
                array = [array arrayByAddingObject:number];
                
                [self updateGraph:array];
            }
        }
    }

}
-(void)updateGraph:(NSArray*)array
{
    __weak __typeof__(self) weakSelf = self;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        runOnMainQueueWithoutDeadlocking(^{
            @autoreleasepool {
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                strongSelf.dataChartView.dataDic[@"r"] = array;
                //            strongSelf.dataChartView.dataDic[@"w2"] = w;
                [strongSelf.dataChartView refreshUIAsSheet];
            }
            
        });
        
    });
    
    
}
@end
