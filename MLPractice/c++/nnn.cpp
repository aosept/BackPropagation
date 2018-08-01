#include <iostream>


#include "SVNetWork.hpp"
using namespace std;
int main()
{
    SVNetWork* network;
    
    int countOfwconfig = 2;
    int wconfig[2] = {5,2};
    
    int inputCount = 2;
    int outputCount = 1;
    int trainingCount = 4;
    
    
    network = new SVNetWork(countOfwconfig,inputCount,outputCount,trainingCount,wconfig);
    
    
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
    network->dataListSet(*xx,*tt);

    
    network->trainWithMultiDataCount(10000, 0.001);
}
//g++  nnn.cpp -o nnn
