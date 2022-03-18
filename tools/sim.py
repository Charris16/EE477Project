#!/bin/tcsh
echo $0
setenv EDA_TOOLS_PATH /home/lab.apps/vlsiapps_new/
setenv USE_CALIBRE_VCO aoj
set path = (/home/lab.apps/vlsiapps_new/icc2/current/bin $path)
source /home/lab.apps/vlsiapps_new/cshrc/general.cshrc
python3 runsim.py
