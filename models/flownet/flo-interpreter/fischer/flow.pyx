"""
flow.pyx

"""

import cython

# import both numpy and the Cython declarations for numpy
import numpy as np
cimport numpy as np

# declare the interface to the C code
cdef extern void c_flow (float* xyflow, float* image, int m, int n)
cdef extern void c_sintelflow (float* xyflow, float* image, int m, int n)

@cython.boundscheck(False)
@cython.wraparound(False)
#def multiply(np.ndarray[float, ndim=2, mode="c"] input not None, double value):
    #"""
    #multiply (arr, value)

    #Takes a numpy arry as input, and multiplies each elemetn by value, in place

    #param: array -- a 2-d numpy array of np.float64
    #param: value -- a number that will be multiplied by each element in the array

    #"""
    #cdef int m, n

    #m, n = input.shape[0], input.shape[1]

    ##c_multiply (&input[0,0], value, m, n)
    #c_flow (&input[0,0], &output[0,0], m, n)

    #return None

def flow(np.ndarray[float, ndim=3, mode="c"] input not None, np.ndarray[float, ndim=3, mode="c"] output not None):
    cdef int m, n

    m, n = input.shape[0], input.shape[1]

    #c_flow (<float *>input[0,0], <float *>output[0,0], m, n)
    c_flow (&input[0,0,0], &output[0,0,0], m, n)

    return None

def sintelflow(np.ndarray[float, ndim=3, mode="c"] input not None, np.ndarray[float, ndim=3, mode="c"] output not None):
    cdef int m, n

    m, n = input.shape[0], input.shape[1]

    c_sintelflow (&input[0,0,0], &output[0,0,0], m, n)

    return None
