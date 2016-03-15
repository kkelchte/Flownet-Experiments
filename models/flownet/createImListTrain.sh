# !/bin/bash
# This script checks whether wget is still busy
# If it has stopped restart it and continue
# If you have tried 3 times, stop and mail me

dest1="img1_list.txt"
dest2="img2_list.txt"
dest3="flo_list.txt"

rm $dest1
rm $dest2
rm $dest3

# create list of image names
# loop over list and add names to each file accordingly

SET="data" #smallset
declare -a OBJECTS=("box" "dumpster" "ragdoll" "wooden_case")

for object in "${OBJECTS[@]}"
do 
	echo ${object}

	IMAGES="/esat/qayd/kkelchte/simulation/$SET/${object}/resizedRGB/*.jpg"
	arrFiles=($IMAGES)
	num=$(ls $IMAGES | wc -l)
	FLOFILES="/esat/qayd/kkelchte/simulation/$SET/${object}/resizedbroxOF/*.flo"
	arrFloFiles=($FLOFILES)
	numflo=$(ls $FLOFILES | wc -l)

	numflo=$(($numflo+1))

	#check if all flo files are created from the images
	if [[ "$num" -ne "$numflo" ]]
	then
	echo "number of images and flo files are not correct: $num != $numflo+1 for object ${object} in $SET"
	exit
	fi

	for (( i=0;i<$num-1;i++))
	do
		#echo $i
		echo ${arrFiles[$i]} >> $dest1
		echo ${arrFiles[$i+1]} >> $dest2
		echo ${arrFloFiles[$i]} >> $dest3
	
	done

done

# ./train_flownets.py
