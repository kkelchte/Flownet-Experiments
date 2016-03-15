# !/bin/bash
# This script runs over a list of objects found on hard drive and creates .flo from flownet OF descriptors

# create list of object names
# loop over list and add names to each file accordingly
# RUN FLOWNET --> create flo files
imagefolder="/esat/qayd/kkelchte/cooking_set/data/images"

flownetfolder="$imagefolder/../flownets"

mkdir $flownetfolder

dest1="$flownetfolder/img1.txt"
dest2="$flownetfolder/img2.txt"

rm $dest1
rm $dest2

FILES="$imagefolder/*.jpg"

for f in $FILES
do
	echo ${f} >> $dest1
	echo ${f} >> $dest2
done
sed -i '$ d' $dest1
sed -i '1d' $dest2



#calculate the .flo from the images in both lists and
#save the files in the current directory
python ./demo_flownets.py $dest1 $dest2

#move the files to a better directory
echo "move files"
mv *.flo $flownetfolder

# CONVERT FLO TO JPG 	
find $flownetfolder -maxdepth 1 -name "*.flo" -type f | parallel --gnu --no-notice /users/visics/kkelchte/caffe-projects/flownet-release/models/flownet/flo-interpreter/build/flo_interpreter_jpg {}	

echo "flownet on cookingset is done."
echo ".flo are finished and can be found in: $flownetfolder" | mailx -s "flownets" klaas.kelchtermans@esat.kuleuven.be

