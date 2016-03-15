# !/bin/bash

declare -a OBJECTS=("ragdoll" "wooden_case" "box" "dumpster")
MESSAGE=("State of reading is: ")

for object in "${OBJECTS[@]}"
do
echo ${object}
FILES="/esat/qayd/kkelchte/simulation/data/${object}/flownets/*.jpg"
COUNT=$(ls $FILES | wc -l)
FILESFLO="/esat/qayd/kkelchte/simulation/data/${object}/flownets/*.txt"
COUNTTOT=$(ls $FILESFLO | wc -l)
if [ $COUNT -ge 1 ]
then
    REL=$(echo "$COUNT/$COUNTTOT"|bc)
    MESSAGE="${MESSAGE}: For object ${object}: ${REL} or $COUNT/$COUNTTOT. "
fi
done

echo $MESSAGE | mailx -s "txt_to_jpg conversion" klaas.kelchtermans@esat.kuleuven.be