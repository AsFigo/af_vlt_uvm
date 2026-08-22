# Source this file to set up af_vlt_uvm environment variables.
# Usage: cd /path/to/af_vlt_uvm && source setup.csh

setenv AF_VLT_UVM_HOME `pwd`
setenv UVM_HOME        "${AF_VLT_UVM_HOME}/af_uvm_bcl"
setenv AF_UVM_HOME     "${AF_VLT_UVM_HOME}/af_uvm"

echo "AF_VLT_UVM_HOME : ${AF_VLT_UVM_HOME}"
echo "UVM_HOME        : ${UVM_HOME}"
echo "AF_UVM_HOME     : ${AF_UVM_HOME}"
