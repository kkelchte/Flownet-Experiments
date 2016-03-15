 # !/bin/bash
# This script loops over 4 objects
# It reads in each .flo file and translates it into a .txt file

# create list of object names
# loop over list and add names to each file accordingly
declare -a OBJECTS=("ragdoll" "wooden_case" "box" "dumpster")

for object in "${OBJECTS[@]}"
do 
echo ${object}

FILES="/esat/qayd/kkelchte/simulation/data/${object}/flownets/*.flo"

for f in $FILES
do
echo ${f}
#create the txt file
./build/flo_interpreter ${f}
done

echo "${object} is done."

done
	
