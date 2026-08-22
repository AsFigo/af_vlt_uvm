//
// -------------------------------------------------------------
// Copyright 2023-2026 AsFigo Technologies, UK
//    All Rights Reserved Worldwide
//
//    Licensed under the Apache License, Version 2.0 (the
//    "License"); you may not use this file except in
//    compliance with the License.  You may obtain a copy of
//    the License at
//
//        http://www.apache.org/licenses/LICENSE-2.0
//
//    Unless required by applicable law or agreed to in
//    writing, software distributed under the License is
//    distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
//    CONDITIONS OF ANY KIND, either express or implied.  See
//    the License for the specific language governing
//    permissions and limitations under the License.
// -------------------------------------------------------------
//

module af_hello_world_uvm;

  import af_uvm_pkg::*;

  int addr, data;

  initial begin
    `af_uvm_display("Welcome to UVM + Verilator!")
    #10;
    /* verilator lint_off WIDTHTRUNC */
    `uvm_info("AsFigo", "Hello from uvm_info!", UVM_MEDIUM)
    /* verilator lint_on WIDTHTRUNC */
    #10;
    `af_uvm_display("Hello from af_uvm_display!")
    `AF_UVM_RAND_STD(addr)
    `AF_UVM_RAND_STD_WITH(data, { data inside {[0:255]}; })
    `af_uvm_printf(("addr=0x%0h data=0x%0h", addr, data))
    #10;
    $finish;
  end

endmodule : af_hello_world_uvm
