//
//  SVNNLayer.hpp
//  MLPractice
//
//  Created by 威 沈 on 26/07/2018.
//  Copyright © 2018 ShenWei. All rights reserved.
//

#ifndef SVNNLayer_hpp
#define SVNNLayer_hpp

#include <stdio.h>
#include <iostream>
#include <math.h>
#include <stdlib.h>
using namespace std;
class SVNNLayer
{
public:
    int countOfIn;
    int countOfOut;
    int index;
    double *b;
    double **w;//[cH0][cH1]
    double **dw;//[cH0][cH1]
    double **finalDw;
    double *net;//[countOfcase][cH1];
    double *out;//[countOfcase][cH1];
    double *input;
    double *delta;
    
    //for training
    
    double *dETotal_dOut;//[layer->countOfOut];
    double *dhout_dnet;//[layer->countOfOut];
    double **dnet_dw;//[layer->countOfOut][layer->countOfIn];//略

   
    double uniform(double min, double max) {
        
        return rand() / (RAND_MAX + 1.0) * (max - min) + min;
    }
    SVNNLayer(int _countOfIn,int _countOfOut)
    {
        countOfIn = _countOfIn;
        countOfOut = _countOfOut;
       
        try {
            net = new double[countOfOut];
            for (int j = 0; j<countOfOut; j++) {
                net[j] =  0;
            }
            out = new double[countOfOut];
            for (int j = 0; j<countOfOut; j++) {
                out[j] =  0;
            }
            delta = new double[countOfOut];
            for (int j = 0; j<countOfOut; j++) {
                delta[j] =  0;
            }
//
            w = new double*[countOfOut];
            
            for(int i=0; i<countOfOut; i++)
            {
                double a = 1.0 / countOfIn;
                w[i] = new double[countOfIn];
                
                for (int j = 0; j<countOfIn; j++) {
                    w[i][j] =  uniform(-a, a);
                }
            }
            
            finalDw = new double*[countOfOut];
            
            for(int i=0; i<countOfOut; i++)
            {
                finalDw[i] = new double[countOfIn];
                for (int j = 0; j<countOfIn; j++) {
                    finalDw[i][j] =  0;
                }
            }
            
            dw = new double*[countOfOut];
            
            for(int i=0; i<countOfOut; i++)
            {
                dw[i] = new double[countOfIn];
                for (int j = 0; j<countOfIn; j++) {
                    dw[i][j] =  0;
                }
            }
            
            b = new double[countOfOut];
            for (int j = 0; j<countOfOut; j++) {
                b[j] =  1;
            }
            
            dETotal_dOut = new double[countOfOut];
            for (int j = 0; j<countOfOut; j++) {
                dETotal_dOut[j] =  0;
            }
            dhout_dnet = new double[countOfOut];
            for (int j = 0; j<countOfOut; j++) {
                dhout_dnet[j] =  0;
            }
            dnet_dw = new double*[countOfOut];
            for (int j = 0; j<countOfOut; j++) {
                dnet_dw[j] = new double[countOfIn];
                for (int i = 0; i<countOfIn; i++) {
                    dnet_dw[j][i] =  0;
                }
            }
        

        } catch (...) {
            printf("out of memory\n");
        }
        
        return;
    };
    void saveDw()
    {
        for (int j = 0; j<countOfOut ; j++) {
            for (int i = 0; i < countOfIn; i++) {
                finalDw[j][i] += dw[j][i];
            }
        }
        
        
    }
    void cleanDw()
    {
        for (int j = 0; j<countOfOut ; j++) {
            for (int i = 0; i < countOfIn; i++) {
                finalDw[j][i] =0;
            }
        }
    }
    void updateWbyFinalDW(double step)
    {
        for (int j = 0; j<countOfOut ; j++) {
            for (int i = 0; i < countOfIn; i++) {
                double dv  = 0;
                
                dv = finalDw[j][i];
                w[j][i] = w[j][i] - dv*step;//w5 = w5 - step*dw5;
            }
        }
    }
    
    double deltaError(double *targetdata)
    {
        double d =0;
        for (int i = 0; i < countOfOut; i++) {
            d += dETotal_dOut[i]*dETotal_dOut[i];
        }
        return d;
    }
    void dErrordout(double *targetdata)
    {
        
        for (int i = 0; i < countOfOut; i++) {
            dETotal_dOut[i]= -1*(targetdata[i] - out[i]);
        }
    }
    
    void dErrordout(SVNNLayer* nextlayer)
    {
        
        for (int i =0; i< nextlayer->countOfOut; i++) {
            for(int j = 0; j< countOfOut; j++)
            {
                dETotal_dOut[i] += nextlayer->delta[i]*nextlayer->w[i][j];
            }
        }
    }
    void deltaRule()
    {
//        delta = new double[countOfOut];
        for (int i = 0; i<  countOfOut; i++) {
            delta[i] = dETotal_dOut[i]*dhout_dnet[i];
        }
    }
    void doutdnet()
    {

        for (int i = 0; i < countOfOut; i++) {
            
            dhout_dnet[i] = out[i]*(1- out[i]);
        }
    }
    
    void dnetdw()
    {
       
        for (int j = 0; j< countOfOut; j++)
        {
            
            for (int i = 0; i < countOfIn; i++)
            {
                dnet_dw[j][i] = input[i];
            }
        }
        
    }
    void dwv()
    {
        for(int j = 0; j< countOfOut; j++)
        {
            for (int i =0; i< countOfIn; i++) {
                dw[j][i] = delta[j]*dnet_dw[j][i];
            }
            
        }
    }
    void productWith(double* inData,int inputNumber)
    {
        countOfIn = inputNumber;
        input = inData;

        for(int j = 0; j < countOfOut;j++){
            net[j] = 0;
            for (int i = 0; i < countOfIn; i++) {
                net[j] += inData[i]*w[j][i];
            }
            net[j]+=b[j];
        }
        
        for(int j = 0; j < countOfOut;j++){
            out[j] = sigmoid(net[j]);
        }
    }
    double sigmoid(double x) {
        return 1.0 / (1.0 + exp(-x));
    }
    void loadWeight()
    {
        double a = 1.0 / countOfIn;
        for(int i = 0;i < countOfOut;i++)
            for (int j = 0; j<countOfIn; j++) {
                w[i][j] =  uniform(-a, a);
            }
        
        for(int i = 0;i < countOfOut;i++)
            for (int j = 0; j<countOfIn; j++) {
                dw[i][j] = 0;
            }
        
        for (int i = 0; i<countOfOut; i++) {
            b[i] = 1;
        }
        
        for (int i = 0; i<countOfOut; i++) {
            delta[i] = 0;
        }
    }
    void logDW()
    {
        for(int i = 0;i < countOfOut;i++)
        {
            for (int j = 0; j<countOfIn; j++) {
                printf("%.17f\t",dw[i][j]);
            }
            printf("\n");
        }
         printf("\n");
    }
    void logW()
    {
        for(int i = 0;i < countOfOut;i++)
        {
            for (int j = 0; j<countOfIn; j++) {
                printf("%.17f\t",this->w[i][j]);
            }
            printf("\n");
        }
         printf("\n");
    }
    void updateWeight(double step)
    {
        
        for (int j = 0; j<countOfOut ; j++) {
            for (int i = 0; i < countOfIn; i++) {
                double dv  = 0;
                
                dv = dw[j][i];
                w[j][i] = w[j][i] - dv*step;//w5 = w5 - step*dw5;
            }
        }
    }
    
    SVNNLayer()
    {
        b = 0;
        countOfIn = 0;
        countOfOut = 0;
        w = NULL;
        net = NULL;
        out = NULL;
    }
    ~SVNNLayer()
    {
        
        if(b != NULL)
            delete[] b;
        if(w != NULL)
        {
            for(int i=0; i<countOfOut; i++)
                delete w[i];

            delete [] w;
        }
        
        if(dw != NULL)
        {
            for(int i=0; i<countOfOut; i++)
                delete dw[i];
            
            delete [] dw;
        }
        
        if(dnet_dw != NULL)
        {
            for(int i=0; i<countOfOut; i++)
                delete dnet_dw[i];
            
            delete [] dnet_dw;
        }
        
        
        if(net != NULL)
            delete [] net;
        if(out != NULL)
            delete [] out;
        
        
        
        if(delta != NULL)
            delete [] delta;
        
        if(dETotal_dOut != NULL)
            delete [] dETotal_dOut;
        
        if(dhout_dnet != NULL)
            delete [] dhout_dnet;
    };
};
#endif /* SVNNLayer_hpp */
