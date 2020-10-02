#!/bin/bash
# 
# Run compiled SPM in virtual X.
# 
# Usage for cersuit pipeline:
#       xwrapper.sh function cersuit "$@"
#
# Usage for warping:
#       xwrapper.sh function transform_native_to_SUIT "$@"

xvfb-run --server-num=$(($$ + 99)) \
--server-args='-screen 0 1600x1200x24 -ac +extension GLX' \
/opt/cersuit/bin/run_spm12.sh \
/usr/local/MATLAB/MATLAB_Runtime/v97 \
"$@"
