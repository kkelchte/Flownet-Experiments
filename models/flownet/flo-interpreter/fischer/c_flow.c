/*
c_multiply.c

simple C function that alters data passed in via a pointer

    used to see how we can do this with Cython/numpy

*/
#include "math.h"

#define PI 3.1415926

static void cartesianToRGB(float x, float y, float* R, float* G, float* B)
{
    float radius = sqrt (x * x + y * y);
    if (radius > 1) radius = 1;
    float phi;
    if (x == 0.0)
        if (y >= 0.0) phi = 0.5 * PI;
        else phi = 1.5 * PI;
    else if (x > 0.0)
        if (y >= 0.0) phi = atan (y/x);
        else phi = 2.0 * PI + atan (y/x);
    else phi = PI + atan (y/x);
    float alpha, beta;    // weights for linear interpolation
    phi *= 0.5;
    // interpolation between red (0) and blue (0.25 * NPI)
    if ((phi >= 0.0) && (phi < 0.125 * PI)) {
        beta  = phi / (0.125 * PI);
        alpha = 1.0 - beta;
        *R = (int)(radius * (alpha * 255.0 + beta * 255.0));
        *G = (int)(radius * (alpha *   0.0 + beta *   0.0));
        *B = (int)(radius * (alpha *   0.0 + beta * 255.0));
    }
    if ((phi >= 0.125 * PI) && (phi < 0.25 * PI)) {
        beta  = (phi-0.125 * PI) / (0.125 * PI);
        alpha = 1.0 - beta;
        *R = (int)(radius * (alpha * 255.0 + beta *  64.0));
        *G = (int)(radius * (alpha *   0.0 + beta *  64.0));
        *B = (int)(radius * (alpha * 255.0 + beta * 255.0));
    }
    // interpolation between blue (0.25 * NPI) and green (0.5 * NPI)
    if ((phi >= 0.25 * PI) && (phi < 0.375 * PI)) {
        beta  = (phi - 0.25 * PI) / (0.125 * PI);
        alpha = 1.0 - beta;
        *R = (int)(radius * (alpha *  64.0 + beta *   0.0));
        *G = (int)(radius * (alpha *  64.0 + beta * 255.0));
        *B = (int)(radius * (alpha * 255.0 + beta * 255.0));
    }
    if ((phi >= 0.375 * PI) && (phi < 0.5 * PI)) {
        beta  = (phi - 0.375 * PI) / (0.125 * PI);
        alpha = 1.0 - beta;
        *R = (int)(radius * (alpha *   0.0 + beta *   0.0));
        *G = (int)(radius * (alpha * 255.0 + beta * 255.0));
        *B = (int)(radius * (alpha * 255.0 + beta *   0.0));
    }
    // interpolation between green (0.5 * NPI) and yellow (0.75 * NPI)
    if ((phi >= 0.5 * PI) && (phi < 0.75 * PI)) {
        beta  = (phi - 0.5 * PI) / (0.25 * PI);
        alpha = 1.0 - beta;
        *R = (int)(radius * (alpha * 0.0   + beta * 255.0));
        *G = (int)(radius * (alpha * 255.0 + beta * 255.0));
        *B = (int)(radius * (alpha * 0.0   + beta * 0.0));
    }
    // interpolation between yellow (0.75 * NPI) and red (Pi)
    if ((phi >= 0.75 * PI) && (phi <= PI)) {
        beta  = (phi - 0.75 * PI) / (0.25 * PI);
        alpha = 1.0 - beta;
        *R = (int)(radius * (alpha * 255.0 + beta * 255.0));
        *G = (int)(radius * (alpha * 255.0 + beta *   0.0));
        *B = (int)(radius * (alpha * 0.0   + beta *   0.0));
    }
    if (*R<0) *R=0;
    if (*G<0) *G=0;
    if (*B<0) *B=0;
    if (*R>255) *R=255;
    if (*G>255) *G=255;
    if (*B>255) *B=255;
}


void c_flow (float* xyflow, float *img, int m, int n) {

    int i, j ;
    int pixindex = 0;
    
    float R=0,G=0,B=0;
    float xflow, yflow;
    int pageoff = m*n;
    
    for (i = 0; i < m; i++) { //height rows
        for (j = 0; j < n; j++) { //width cols
                
                int index = pixindex*2;
                
                xflow = xyflow[index+0];
                yflow = xyflow[index+1];
                
                int imgindex = (j*m+i)*3;
                
                cartesianToRGB(xflow, yflow, &R, &G, &B);
                
                img[imgindex+0] = B / 255.0;
                img[imgindex+1] = G / 255.0;
                img[imgindex+2] = R / 255.0;
                
                pixindex++;            
        }
    }
    return ;
}
