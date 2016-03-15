# !/bin/bash

find /esat/qayd/kkelchte/simulation/smallset -maxdepth 3 -name "*.txt" -type f | parallel --gnu --no-notice ./run_convert_txt_jpg.sh /software/matlab/2015b {}
