#!/usr/bin/env python
import os, sys
import subprocess

caffe_bin = '../../build/tools/caffe'

# =========================================================
# Add load library paths for python
os.environ['LD_LIBRARY_PATH'] = '$LD_LIBRARY_PATH:/usr/local/cuda-7.5/targets/x86_64-linux/lib:/users/visics/kkelchte/local/lib/cudnn-v3.0/lib64/'
print 'Success:', os.environ['LD_LIBRARY_PATH']
# =========================================================

my_dir = os.path.dirname(os.path.realpath(__file__))
os.chdir(my_dir)

if not os.path.isfile(caffe_bin):
    print('Caffe tool binaries not found. Did you compile caffe with tools (make all tools)?')
    sys.exit(1)

print(sys.argv[1:])

args = [caffe_bin, 'train', '-model', 'model/train.prototxt', '-solver', 'model/solver.prototxt', '-weights', 'model/flownet_firstversion.caffemodel', '-iterations',800] + sys.argv[1:]
cmd = str.join(' ', args)
print('Executing %s' % cmd)

subprocess.call(args)
