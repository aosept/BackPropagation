#include <iostream>


#include "SVNetWork.hpp"
using namespace std;
int main()
{
    SVNetWork* network;
    
//    int countOfwconfig = 3;
//    int wconfig[3] = {4,4,1};
//
//    int inputCount = 4;
//    int outputCount = 1;
//    int trainingCount = 6;
//
//    double xx[6][4] = { {0.99,0.99,0.01,0.01,},
//        {0.99,0.01,0.01,0.99,},
//        {0.99,0.01,0.99,0.01,},
//        {0.01,0.99,0.01,0.99,},
//        {0.01,0.01,0.99,0.99,},
//        {0.01,0.99,0.99,0.01,},
//    };
//    double tt[6][1] = { {0.165,},
//        {0.33,},
//        {0.495,},
//        {0.66,},
//        {0.825,},
//        {0.99,},
//    };
//
//    network = new SVNetWork(countOfwconfig,inputCount,outputCount,trainingCount,wconfig);
//
//
//
//    network->dataListSet(*xx,*tt);

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
    
    network = new SVNetWork(countOfwconfig,inputCount,outputCount,trainingCount,wconfig);
    
    
    
    network->dataListSet(*xx,*tt);
    
    network->trainWithMultiDataCount(1400000000, 0.000000001);
    
    network->showResult();
    
}
//g++  nnn.cpp -o nnn
