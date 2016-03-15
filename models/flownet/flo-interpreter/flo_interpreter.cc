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

using namespace std;

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
    string outputfilename = filename;
    outputfilename = outputfilename.replace(outputfilename.end()-3,outputfilename.end(),"txt");
    FILE *stream = fopen(filename.c_str(), "rb");
    ofstream outputfile;
    outputfile.open(outputfilename.c_str());
    
    if (stream == 0)
    {
        cerr << "Could not open or find file " << filename;
    }
    try {
      float help;
      if(0 == fread(&help,sizeof(float),1,stream) || help != 202021.25) throw 0;
      if(0 == fread(&xSize,sizeof(int),1,stream)) throw 0;
      if(0 == fread(&ySize,sizeof(int),1,stream)) throw 0;
      
      cout << xSize*ySize*2 << endl << flush;
      float *data=new float[xSize*ySize*2];
    
      outputfile<< xSize <<";"<<ySize << endl;
      
      for (int y = 0; y < ySize; y++)
        for (int x = 0; x < xSize; x++) {
            if(0 == fread(&data[y*xSize+x],sizeof(float),1,stream)) throw 0;
            if(0 == fread(&data[y*xSize+x+xSize*ySize],sizeof(float),1,stream)) throw 0;
            //xdata[y*xSize+x] = data[y*xSize+x];
            //ydata[y*xSize+x] = data[y*xSize+x+xSize*ySize];
            //cout << xdata[y*xSize+x] << ";" << ydata[y*xSize+x]<<endl;
            outputfile << data[y*xSize+x] << ";" << data[y*xSize+x+xSize*ySize]<<endl;
            
            
            
        }
        
        fclose(stream);
        outputfile.close();
 
     
    }catch(int err) {
      fclose(stream);
      cerr << "File corrupted: " << filename << " "<<err<<endl;
      outputfile.close();
    }
    
    return 0;
}

