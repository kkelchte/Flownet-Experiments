# !/bin/bash

object="dumpster"
FILES="/esat/qayd/kkelchte/simulation/data/$object/flownets/*.flo"


for f in $FILES
do
echo ${f}
./build/flo_interpreter ${f}
done