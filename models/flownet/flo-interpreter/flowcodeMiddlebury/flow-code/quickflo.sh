 # !/bin/bash

for num in 143 144 145 146
do
	echo $num
	cp /esat/qayd/kkelchte/simulation/data/dumpster/flownets/flownets-pred-0000$num.flo /users/visics/kkelchte/caffe-projects/flownet-release/models/flownet/flo-interpreter/flowcodeMiddlebury/flow-code/
	./color_flow flownets-pred-0000$num.flo $num.png
done
echo 'finished conversion'
