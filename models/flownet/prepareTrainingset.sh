# !/bin/bash
# This script runs over a list of objects found on hard drive and creates .flo from flownet OF descriptors

# create list of object names
# loop over list and add names to each file accordingly
declare -a OBJECTS=("ragdoll" "wooden_case" "box" "dumpster")
#declare -a OBJECTS=("wooden_case")

#switch between smallset and data
DATASET=("data") 

for object in "${OBJECTS[@]}"
do 
	echo ${object}
	# RUN FLOWNET --> create flo files
	dest1="img1.txt"
	dest2="img2.txt"
	rm $dest1
	rm $dest2
	FILES="/esat/qayd/kkelchte/simulation/$DATASET/${object}/RGB/*.jpg"

		for f in $FILES
		do
		echo ${f} >> $dest1
		echo ${f} >> $dest2
		done
	echo ${object}

	sed -i '$ d' $dest1
	sed -i '1d' $dest2

	mkdir "/esat/qayd/kkelchte/simulation/$DATASET/${object}/flownets"

	python ./demo_flownets.py img1.txt img2.txt
	echo "move files"
	mv *.flo /esat/qayd/kkelchte/simulation/$DATASET/${object}/flownets

	# CONVERT FLO TO JPG 
	
	find /esat/qayd/kkelchte/simulation/$DATASET/${object} -maxdepth 3 -name "*.flo" -type f | parallel --gnu --no-notice /esat/qayd/kkelchte/simulation/flo-interpreter/build/flo_interpreter_jpg {}	
	echo "${object} is done."

done

echo ".flo are finished" | mailx -s "all flownets are calculated" klaas.kelchtermans@esat.kuleuven.be

