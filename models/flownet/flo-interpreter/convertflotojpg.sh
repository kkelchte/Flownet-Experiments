# !/bin/bash

find /esat/qayd/kkelchte/simulation/smallset -maxdepth 3 -name "*.flo" -type f | parallel --gnu --no-notice ./build/flo_interpreter_jpg {}
