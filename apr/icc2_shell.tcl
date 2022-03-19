set DESIGN_NAME "CPU_TopLevel"


#tech related
set TSMC_PATH "/home/lab.apps/vlsiapps/kits/tsmc/N65RF/1.0c/digital"
set TARGETCELLLIB_PATH "$TSMC_PATH/Front_End/timing_power_noise/NLDM/tcbn65gplus_140b"
set TECH_NDM "$TSMC_PATH/Back_End/milkyway/tcbn65gplus_200a/techfiles/tsmcn65_9lmT2.tf"
set STDCELL_LEF "$TSMC_PATH/Back_End/lef/tcbn65gplus_200a/lef/tcbn65gplus_9lmT2.lef"

#source file
set SYN_VERILOG "../syn/results/CPU_TopLevel.syn.v"




# Configure design, libraries
# ==========================================================================
create_lib -technology $TECH_NDM -ref_libs {./Project.ndm} ./CPU_TopLevel
save_lib

read_verilog $SYN_VERILOG

set_attribute [get_layers {M1 M3 M5 M7 M9 }]  -name routing_direction -value vertical
set_attribute [get_layers {M1 M3 M5 M7 M9}] track_offset 0.1

set_attribute [get_layers {M2 M4 M6 M8 AP}] -name routing_direction -value horizontal


set_app_options -name file.gds.text_all_pins -value true
set_app_options -name place.coarse.continue_on_missing_scandef -value true

set_voltage 1.2

# FLOORPLAN CREATION
# # =========================================================================
# TODO: item 1 - set block as 3:2 aspect ratio (vertical:horizontal)
initialize_floorplan -core_utilization 0.8 -side_ratio {3 2}

# TIMING CONSTRAINTS
# ==========================================================================
read_sdc ../syn/results/$DESIGN_NAME.syn.sdc -version 1.7

#1. Placement

create_placement -congestion
#create_placement -floorplan -incremental
legalize_placement
create_stdcell_fillers -lib_cells {DCAP64 DCAP32 DCAP16 DCAP8 DCAP4 DCAP} 
connect_pg_net -automatic
remove_stdcell_fillers_with_violation
#create_stdcell_fillers -lib_cells {FILL64 FILL32 FILL16 FILL8 FILL4 FILL2 FILL1}
#connect_pg_net -automatic
#remove_stdcell_fillers_with_violation
check_legality
legalize_placement
set_fixed_objects [get_cells "*"]


#2. Route
connect_pg_net -net VDD [get_pins -physical_context *VDD]
connect_pg_net -net VSS [get_pins -physical_context *VSS]
create_pg_std_cell_conn_pattern std_pattern -layers M1
set_pg_strategy std_cell_strategy -core -pattern {{pattern: std_pattern} {nets: {VDD VSS} }}
compile_pg -strategies {std_cell_strategy}
create_pg_mesh_pattern mesh_pattern   -layers {{{vertical_layer: M5} {width: 0.6}  {pitch: 30} {offset: 0.6}}}
set_pg_strategy M4M5_mesh    -pattern {{name: mesh_pattern}       {nets: VDD VSS}}  -core
compile_pg -strategies M4M5_mesh

# TODO: item 2 - set inputs on the left edge and outputs on the right edge
# Hint: create_pin_constraint
#create_bundle -name inpins [get_nets {Clock Reset A B}]
#create_bundle -name outpins [get_nets {Status[0] Status[1] Status[2] Output1 Output2}]
#create_pin_constraint -type bundle -bundles inpins -sides 1
#create_pin_constraint -type bundle -bundles outpins -sides 3
#create_rp_group -name in -columns 1 -rows 4
place_pins -use_existing_routing -self
set_ignored_layers -min_routing_layer M2 -max_routing_layer M7
route_auto
check_lvs


#3 Export
write_sdf ./$DESIGN_NAME.apr.sdf
write_verilog ./$DESIGN_NAME.apr.v -include {all} 
write_gds -bus_delimiters <> -units 1000  ./$DESIGN_NAME.gds
save_block  
