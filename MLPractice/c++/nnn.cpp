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
//    double xx[6][4] = { {1,1,1,1,},
//        {1,1,1,1,},
//        {1,1,1,1,},
//        {1,1,1,1,},
//        {1,1,1,1,},
//        {1,1,1,1,},
//    };
//    double tt[6][1] = { {0.165,},
//        {0.33,},
//        {0.495,},
//        {0.66,},
//        {0.825,},
//        {1,},
//    };
//
//    network = new SVNetWork(countOfwconfig,inputCount,outputCount,trainingCount,wconfig);
//
//
//
//    network->dataListSet(*xx,*tt);

    int countOfwconfig = 2;
    int wconfig[2] = {17,4};
    
    int inputCount = 4;
    int outputCount = 4;
    int trainingCount = 8;
    
    double xx[16][4] = {
        {1,1,1,1},
        {1,1,1,0},
        {1,1,0,0},
        {1,0,0,0},
        {0,0,0,0},
        {0,1,1,1},
        {0,0,1,1},
        {0,0,0,1},
        {0,0,1,1},
        {1,0,0,1},
        {1,1,0,0},
        {1,0,1,1},
        {1,1,0,1},
        {1,0,1,0},
        {0,1,0,1},
        {0,1,1,0},

    };
    double tt[16][4] = {
        {1,1,1,1},
        {1,1,1,0},
        {1,1,0,0},
        {1,0,0,0},
        {0,0,0,0},
        {0,1,1,1},
        {0,0,1,1},
        {0,0,0,1},
        {0,0,1,1},
        {1,0,0,1},
        {1,1,0,0},
        {1,0,1,1},
        {1,1,0,1},
        {1,0,1,0},
        {0,1,0,1},
        {0,1,1,0},
        
    };

    
    
    network = new SVNetWork(countOfwconfig,inputCount,outputCount,trainingCount,wconfig);
    
    
    
    network->dataListSet(*xx,*tt);
    
    network->trainWithMultiDataCount(10000000, 0.00000001,0.5);
    
    network->showResult();
    
}
//g++  nnn.cpp -o nnn
