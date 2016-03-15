#include "math.h"
#include "stdio.h"

#define PI 3.1415926

typedef unsigned char uchar;

static int ncols = 0;
#define MAXCOLS 60
static int colorwheel[MAXCOLS][3];

static void setcols(int r, int g, int b, int k)
{
    colorwheel[k][0] = r;
    colorwheel[k][1] = g;
    colorwheel[k][2] = b;
}

static void makecolorwheel(void)
{
    // relative lengths of color transitions:
    // these are chosen based on perceptual similarity
    // (e.g. one can distinguish more shades between red and yellow 
    //  than between yellow and green)
    int RY = 15;
    int YG = 6;
    int GC = 4;
    int CB = 11;
    int BM = 13;
    int MR = 6;
    ncols = RY + YG + GC + CB + BM + MR;
    //printf("ncols = %d\n", ncols);
    if (ncols > MAXCOLS)
  exit(1);
    int i;
    int k = 0;
    for (i = 0; i < RY; i++) setcols(255,    255*i/RY,   0,        k++);
    for (i = 0; i < YG; i++) setcols(255-255*i/YG, 255,    0,        k++);
    for (i = 0; i < GC; i++) setcols(0,      255,    255*i/GC,     k++);
    for (i = 0; i < CB; i++) setcols(0,      255-255*i/CB, 255,        k++);
    for (i = 0; i < BM; i++) setcols(255*i/BM,     0,    255,        k++);
    for (i = 0; i < MR; i++) setcols(255,    0,    255-255*i/MR, k++);
}

static void sintelCartesianToRGB(float fx, float fy, float* pix)
{
    if (ncols == 0) makecolorwheel();

    float rad = sqrt(fx * fx + fy * fy);
    float a = atan2(-fy, -fx) / M_PI;
    float fk = (a + 1.0) / 2.0 * (ncols-1);
    int k0 = (int)fk;
    int k1 = (k0 + 1) % ncols;
    float f = fk - k0;
    //f = 0; // uncomment to see original color wheel
    int b;
    for (b = 0; b < 3; b++) {
      float col0 = colorwheel[k0][b] / 255.0;
      float col1 = colorwheel[k1][b] / 255.0;
      float col = (1 - f) * col0 + f * col1;
      if (rad <= 1)
          col = 1 - rad * (1 - col); // increase saturation with radius
      //else
      //    col *= .75; // out of range
          
      //pix[2 - b] = (int)(255.0 * col);
      pix[b] = col;
    }
}

void c_sintelflow (float* xyflow, float *img, int m, int n) {

    int i, j ;
    int pixindex = 0;
    
    //float R=0,G=0,B=0;
    float xflow, yflow;
    //int pageoff = m*n;
    
    for (i = 0; i < m; i++) { //height rows
        for (j = 0; j < n; j++) { //width cols
                
                int index = pixindex*2;
                
                yflow = -xyflow[index+0];
                xflow = -xyflow[index+1];
                
                int imgindex = (j*m+i)*3; 
                
                sintelCartesianToRGB(xflow, yflow, &(img[imgindex]));
                
                //img[imgindex+0] = B / 255.0;
                //img[imgindex+1] = G / 255.0;
                //img[imgindex+2] = R / 255.0;
                
                pixindex++;            
        }
    }
    
    return ;
}