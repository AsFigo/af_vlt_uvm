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

import af_uvm_pkg::*;

module af_hello_world_uvm;

  initial begin
    `uvm_info("AsFigo", "Hello from uvm_info!", UVM_MEDIUM)
    `af_uvm_display("Hello from af_uvm_display!")
    `af_uvm_printf(("Hello from af_uvm_printf — sim time: %0t", $time))
    #10;
    $finish;
  end

endmodule : af_hello_world_uvm
