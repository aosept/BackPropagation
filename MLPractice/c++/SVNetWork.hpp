//
//  SVNetWork.hpp
//  MLPractice
//
//  Created by 威 沈 on 26/07/2018.
//  Copyright © 2018 ShenWei. All rights reserved.
//

#ifndef SVNetWork_hpp
#define SVNetWork_hpp

#include <stdio.h>
#include <iostream>
#include <mutex>
#include <atomic>
#include <sstream>
#include <thread>
#include <stdlib.h>
#include "SVNNLayer.hpp"
using namespace std;

class SVNetWork
{
    std::thread training_thread;
public:
    SVNNLayer **layers;
    int countOfLayer;
    int inputNumber;
    int outNumber;
    int countOfcase;
    double* trainingdata;
    double* targetdata;
    
    double** trainingdataList;
    double** targetdataList;
    double step;
    bool isDebug;
    
    int trainloopCount;
    double sheldhold;
    bool isTraining;
    
    void (*didRecieveDataCallback)(const void* callback,const char* key, const char* value, double delta);
    void *callbackNSObject;
    SVNetWork()
    {
        step = 0.5;
        isDebug = false;
    };
    
    SVNetWork(int _countOfLayer,int _inputNumber,int _outNumber,int _countOfCase,int hidden_layer_sizes[])
    {
        countOfLayer = _countOfLayer;
        inputNumber = _inputNumber;
        outNumber = _outNumber;
        isDebug = false;
        layers = new SVNNLayer*[countOfLayer];
        countOfcase = _countOfCase;
        for(int i=0; i<countOfLayer; i++) {
            int input_size;
            if(i == 0) {
                input_size = inputNumber;
            } else {
                input_size = hidden_layer_sizes[i-1];
            }
            
            layers[i] = new SVNNLayer(input_size,hidden_layer_sizes[i]);
            layers[i]->index = i;
            printf(" line: %d ok\n",__LINE__);
        }
        step = 0.5;
    };
    void logArray(double* list,int count)
    {
        
        for(int i = 0;i < count ;i++)
        {
        
                printf("%.17f\t",list[i]);

        }
        printf("\n");
    }
    void logMartrix(double** martrix,int m,int n)
    {
        for(int i = 0;i < m ;i++)
        {
            for (int j = 0; j<n; j++) {
                printf("%.17f\t",martrix[i][j]);
            }
            printf("\n");
        }
    }
    void dataListSet(double *_trainingData,double *_targetData)
    {
        
        trainingdataList = new double*[countOfcase];
        for(int i = 0;i < countOfcase; i++)
        {
            trainingdataList[i] = new double[inputNumber];
            for(int j=0; j< inputNumber;j++)
                trainingdataList[i][j] = _trainingData[inputNumber*i+j];
        }
       
        
        targetdataList = new double*[countOfcase];
        for(int i = 0;i < countOfcase; i++)
        {
            targetdataList[i] = new double[outNumber];
            for(int j=0; j< outNumber;j++)
                targetdataList[i][j] = _targetData[outNumber*i+j];
        }
        
    }
    void dataset(double *_trainingData,double*_targetData)
    {
        
        trainingdata = _trainingData;
        targetdata = _targetData;
        
    }

    ~SVNetWork()
    {
        if(training_thread.joinable())
            training_thread.join();
        if(layers != NULL)
        {
            for(int i=0; i<countOfLayer; i++)
                delete layers[i];
            
            delete [] layers;
        }

    };
    void trainWithCount(int count,double sheldholdValue)
    {

//         if( training_thread.joinable())
//             training_thread.join();
//
            trainloopCount = count;
            sheldhold = sheldholdValue;
//          training_thread = std::thread([this]() {
        
        
            int loop = 0;
            double delta =  1;
            while (loop < trainloopCount && delta > sheldhold)
            {
                run();
                delta = training();
                printf("%d delta:\t%.10f\n",loop,delta);
                
                loop++;
            
            }
              printf("finished");

//        });
        
        
        
    }
    void showResult()
    {
        for(int c = 0; c < countOfcase; c++)
        {
            double *input = new double[inputNumber];
            
            printf("in:\n");
          
            for (int i  = 0; i<inputNumber; i++) {
                input[i] = trainingdataList[c][i];
            }
            
            logArray(input, inputNumber);
            
            double *target = new double[outNumber];
            for (int i  = 0; i<outNumber; i++) {
                input[i] = targetdataList[c][i];
            }
            
            dataset(input, target);
            run();
            
            
            
                
                SVNNLayer* lastlayer =  layers[countOfLayer-1];
            
            
                printf("out:\n");
                logArray(lastlayer->out, lastlayer->countOfOut);
                
            
            printf("\n");
            
            delete [] input;
            delete [] target;
        }
    }
    double trainWithMultiData()
    {
        double subDelta = 0;
        for(int c = 0; c < countOfcase; c++)
        {
            double *input = new double[inputNumber];
            
            
            
            for (int i  = 0; i<inputNumber; i++) {
                input[i] = trainingdataList[c][i];
            }
            
//            logArray(input, inputNumber);
            double *target = new double[outNumber];
            for (int i  = 0; i<outNumber; i++) {
                input[i] = targetdataList[c][i];
            }
            
            dataset(input, target);
            run();
            subDelta += training();
            
            delete [] input;
            delete [] target;
        }
        
        return subDelta;
    }
    void trainWithMultiDataCount(int count,double sheldholdValue)
    {
    
        trainloopCount = count;
        sheldhold = sheldholdValue;
        
        
        int loop = 0;
        double delta =  1;
        while (loop < trainloopCount && delta > sheldhold)
        {
            if(loop > 100000)
            {
                step = step*1.00001;
            }
            delta = trainWithMultiData();
            
            
            
            
            updateMultiCaseDw();
            clearMultiCaseDw();
            if(loop%10000 ==0)
            {
                printf("%d delta:\t%.10f\n",loop,delta);
            
                if (didRecieveDataCallback != NULL) {
                    didRecieveDataCallback(callbackNSObject,"resultOf","delta",delta);
                }
            }
            
            loop++;
            
        }
        
        printf("finished");
        
        
        
    }
    void run()
    {
        for (int m=0; m< countOfLayer; m++) {
            if(m == 0)
            {
                SVNNLayer* layer =  layers[m];
                layer->productWith(trainingdata,inputNumber);
            }
            else
            {
                SVNNLayer* prelayer =  layers[m-1];
                SVNNLayer* layer =  layers[m];
                layer->productWith(prelayer->out,prelayer->countOfOut);
            }
        }
    };
    
    double training()
    {
        double d = 0;
 
        for (int m=countOfLayer-1; m >= 0 ; m--) {
            
            SVNNLayer* layer =  layers[m];
           
            
            if(m == countOfLayer-1)
            {
                layer->dErrordout(trainingdata);
                
                d += layer->deltaError(trainingdata);
            }
            else
            {
                SVNNLayer* nextlayer =  layers[m+1];
                layer->dErrordout(nextlayer);
            }
            
            layer->doutdnet();
            layer->deltaRule();
            layer->dnetdw();
            layer->dwv();
            
            layer->saveDw();
        
        }
        
         return sqrt(d);
    };
    void updateMultiCaseDw()
    {
        for (int m=countOfLayer-1; m >= 0 ; m--) {
            
            SVNNLayer* layer =  layers[m];
            layer->updateWbyFinalDW(step);
            
        }
    }
    void clearMultiCaseDw()
    {
        for (int m=countOfLayer-1; m >= 0 ; m--) {
            
            SVNNLayer* layer =  layers[m];
            layer->cleanDw();
            
        }
    }
    void updateSingleDw()
    {
        for (int m=countOfLayer-1; m >= 0 ; m--) {
            
            SVNNLayer* layer =  layers[m];
            layer->updateWeight(step);
            
        }
    }
   
};
#endif /* SVNetWork_hpp */
