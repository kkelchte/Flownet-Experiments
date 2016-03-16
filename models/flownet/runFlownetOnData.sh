# !/bin/bash
# This script runs over a list of objects found on hard drive and creates .flo from flownet OF descriptors

# create list of object names
# loop over list and add names to each file accordingly
#declare -a OBJECTS=("ragdoll_one_cw" "wooden_case_one_cw" "dumpster_one_cw" "cafe_table_one_cw" "polaris_ranger_one_cw")
declare -a OBJECTS=("box_one_cw")

#switch between smallset and data
DATASET=("data") 

DESTINATION="flownets"

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

	mkdir "/esat/qayd/kkelchte/simulation/$DATASET/${object}/$DESTINATION"

	python ./demo_flownets.py img1.txt img2.txt
	echo "move files"
	mv *.flo /esat/qayd/kkelchte/simulation/$DATASET/${object}/$DESTINATION

	# CONVERT FLO TO JPG 
	
	find /esat/qayd/kkelchte/simulation/$DATASET/${object} -maxdepth 3 -name "*.flo" -type f | parallel --gnu --no-notice /esat/qayd/kkelchte/simulation/flo-interpreter/build/flo_interpreter_jpg {}	
	echo "${object} is done."
	
	rm -rf /esat/qayd/kkelchte/simulation/$DATASET/${object}/$DESTINATION/*.txt

done

echo "Optical Flow from flownets are finished of the objects:${OBJECTS[@]} \n And saved in /esat/qayd/kkelchte/simulation/$DATASET/*/$DESTINATION.\n Be aware that only the odd numbers are convenient." | mailx -s "${OBJECTS[@]} of $DATASET flownets are calculated" klaas.kelchtermans@esat.kuleuven.be

