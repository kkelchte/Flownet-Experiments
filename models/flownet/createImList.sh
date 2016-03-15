# !/bin/bash
# This script checks whether wget is still busy
# If it has stopped restart it and continue
# If you have tried 3 times, stop and mail me

dest1="img1.txt"
dest2="img2.txt"

rm $dest1
rm $dest2


# create list of image names
# loop over list and add names to each file accordingly

OBJECT="ragdoll"
FILES="/esat/qayd/kkelchte/simulation/data/$OBJECT/*.jpg"

for f in $FILES
do
echo ${f} >> $dest1
echo ${f} >> $dest2
done

sed -i '$ d' $dest1
sed -i '1d' $dest2

mkdir "data/simulation/$OBJECT/flownets"
