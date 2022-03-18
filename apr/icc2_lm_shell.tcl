#setup library
#
set TSMC_PATH "/home/lab.apps/vlsiapps/kits/tsmc/N65RF/1.0c/digital"
set TARGETCELLLIB_PATH "$TSMC_PATH/Front_End/timing_power_noise/NLDM/tcbn65gplus_140b"
set TECH_NDM "$TSMC_PATH/Back_End/milkyway/tcbn65gplus_200a/techfiles/tsmcn65_9lmT2.tf"
set STDCELL_LEF "$TSMC_PATH/Back_End/lef/tcbn65gplus_200a/lef/tcbn65gplus_9lmT2.lef"

create_workspace -technology $TECH_NDM Project
set_app_options -name file.lib.library_compiler_exec_script -value /home/lab.apps/vlsiapps/library_compiler/H-2013.03-SP5-2/bin/lc_shell
set_app_options -name lib.workspace.allow_commit_workspace_overwrite -value true
set_app_options -name lib.workspace.save_layout_views -value true
set_app_options -name lib.workspace.save_design_views -value true



set search_path "$TSMC_PATH/Back_End/milkyway/tcbn65gplus_200a/cell_frame/tcbn65gplus/LM/"
read_db tcbn65gplustc0d8.db
read_db tcbn65gplusbc0d88.db
read_lef $STDCELL_LEF

read_parasitic_tech -tlup $TSMC_PATH//Back_End/milkyway/tcbn65gplus_200a/techfiles/tluplus/cln65g+_1p09m+alrdl_rcworst_top2.tluplus -name LATE
read_parasitic_tech -tlup $TSMC_PATH//Back_End/milkyway/tcbn65gplus_200a/techfiles/tluplus/cln65g+_1p09m+alrdl_rcbest_top2.tluplus -name EARLY  
read_parasitic_tech -tlup $TSMC_PATH//Back_End/milkyway/tcbn65gplus_200a/techfiles/tluplus/cln65g+_1p09m+alrdl_typical_top2.tluplus

check_workspace -allow_missing
commit_workspace  -force -output  ./Project.ndm
