--binary
--timing
-DUVM_NO_DPI
+UVM_NO_RELNOTES
--timescale 1ns/1ps
-Wall -Wno-fatal
-I${AF_VLT_UVM_HOME}/af_uvm_bcl/src
${AF_VLT_UVM_HOME}/af_uvm_bcl/src/uvm_pkg.sv
-I${AF_VLT_UVM_HOME}/af_uvm/src
${AF_VLT_UVM_HOME}/af_uvm/src/af_uvm_pkg.sv
