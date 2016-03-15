/*
 * Copyright (C) 2012-2015 Open Source Robotics Foundation
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
*/

#include <iostream>
#include <fstream>
#include <omp.h>
#include <sys/dir.h>
#include <string>
#include <stdlib.h> 
#include <math.h> 
#include "opencv2/opencv.hpp"
#include <opencv2/core/core.hpp>
#include <opencv2/highgui/highgui.hpp>

using namespace std;
using namespace cv;
/////////////////////////////////////////////////
int main(int _argc, char* argv[])
{
    int xSize, ySize;
    string filename = "";
    if(argv[1] == NULL){
        filename = "../flownets-pred-0000000.flo";
        cout << filename << endl;
    }else{
        filename = argv[1];
    }
    FILE *stream = fopen(filename.c_str(), "rb");
    
    if (stream == 0)
    {
        cerr << "Could not open or find file " << filename;
    }
    try {
      float help;
      if(0 == fread(&help,sizeof(float),1,stream) || help != 202021.25) throw 0;
      if(0 == fread(&xSize,sizeof(int),1,stream)) throw 0;
      if(0 == fread(&ySize,sizeof(int),1,stream)) throw 0;
      
      float max_flow = 8;
      float scalef = 128/max_flow;
      
      float *data=new float[xSize*ySize*3];
      
      Mat dataMat (ySize, xSize,  CV_32FC3);
      
      for (int y = 0; y < ySize; y++)
        for (int x = 0; x < xSize; x++) {
            
	Vec3f& pix = dataMat.at<Vec3f>(y,x);
            if(0 == fread(&pix[2],sizeof(float),1,stream)) throw 0;
            if(0 == fread(&pix[1],sizeof(float),1,stream)) throw 0;
            pix[3] = sqrt(pow(pix[2],2)+pow(pix[1],2));
            
	    
            pix[0] = pix[0]*scalef+128;
            pix[1] = pix[1]*scalef+128;
            pix[2] = pix[2]*scalef+128;
            
            if(pix[0]<0) pix[0] = 0;
            if(pix[0]>255) pix[0] = 255;
            if(pix[1]<0) pix[1] = 0;
            if(pix[1]>255) pix[1]= 255;
            if(pix[2]<0) pix[2] = 0;
            if(pix[2]>255) pix[2]= 255;
            
            //cout << pix[2] << ";" << pix[1] << ";" << pix[0] << endl;
            
            //dataMat.at<Vec3b>(x,y) = pix;
            
            
        }
        //cv::FileStorage file("../my_image.jpg", cv::FileStorage::WRITE);
        //file << data;
        //Mat img = Mat(ySize, xSize, CV_32F, data);
	
	string location = filename.replace(filename.end()-3,filename.end(),"jpg");
	cout<<"saved: "<<location<<endl;
        imwrite(location, dataMat);
        //file << image;
        
        fclose(stream);
 
     
    }catch(int err) {
      fclose(stream);
      cerr << "File corrupted: " << filename << " "<<err<<endl;
    }
    
    return 0;
}

