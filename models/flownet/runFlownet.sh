# !/bin/bash
# This script runs over a list of objects found on hard drive and creates .flo from flownet OF descriptors
declare -a OBJECTS=("cookingset_step10")
DATASET=("flowrangeset") 

for object in "${OBJECTS[@]}"
do  
	echo ${object}
	# RUN FLOWNET --> create flo files
	dest1="img1.txt"
	dest2="img2.txt"
	rm $dest1
	rm $dest2
	FILES="/esat/qayd/kkelchte/simulation/$DATASET/${object}/RGB/*.jpg"
	listfiles=($FILES)
	num=$(ls $FILES | wc -l)
	
	for (( i=0;i<$num;i=i+2))
	do
		echo $i
		echo ${listfiles[$i]} >> $dest1
		echo ${listfiles[$i+1]} >> $dest2
	done

	python ./demo_flownets.py img1.txt img2.txt
	echo "move files"
	mv *.flo "/esat/qayd/kkelchte/simulation/$DATASET/${object}/flownets"

	# CONVERT FLO TO JPG 
	
	find /esat/qayd/kkelchte/simulation/$DATASET/${object}/flownets -maxdepth 3 -name "*.flo" -type f | parallel --gnu --no-notice /esat/qayd/kkelchte/simulation/flo-interpreter/build/flo_interpreter_jpg {}	
	echo "${object} is done."

done

echo ".flo are finished" | mailx -s "all flownets are calculated" klaas.kelchtermans@esat.kuleuven.be

