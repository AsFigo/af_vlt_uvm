#!/bin/bash
# Source this file to set up af_vlt_uvm environment variables.
# Usage: source setup.sh

export AF_VLT_UVM_HOME="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export UVM_HOME="${AF_VLT_UVM_HOME}/af_uvm_bcl"
export AF_UVM_HOME="${AF_VLT_UVM_HOME}/af_uvm"

echo "AF_VLT_UVM_HOME : ${AF_VLT_UVM_HOME}"
echo "UVM_HOME        : ${UVM_HOME}"
echo "AF_UVM_HOME     : ${AF_UVM_HOME}"
