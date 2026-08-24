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

/* verilator lint_off IMPORTSTAR */
import af_uvm_pkg::*;
/* verilator lint_on IMPORTSTAR */

`AF_UVM_TEST_BEGIN(afFifoTest)

  virtual fifo_if vif;

  extern virtual function void build_phase(uvm_phase phase);
  extern virtual task         reset_phase(uvm_phase phase);
  extern virtual task         main_phase(uvm_phase phase);

`AF_UVM_TEST_END(afFifoTest)

function void afFifoTest::build_phase(uvm_phase phase);
  super.build_phase(phase);
  if (!uvm_config_db#(virtual fifo_if)::get(this, "", "fifo_if", vif))
    `af_uvm_fatal("Virtual interface fifo_if not found in config_db")
endfunction : build_phase

task afFifoTest::reset_phase(uvm_phase phase);
  phase.raise_objection(this);
  `af_uvm_display("Start of reset")
  vif.cb.push    <= 1'b0;
  vif.cb.pop     <= 1'b0;
  vif.cb.data_in <= '0;
  vif.cb.rst_n   <= 1'b0;
  repeat (5) @(vif.cb);
  vif.cb.rst_n <= 1'b1;
  repeat (1) @(vif.cb);
  `af_uvm_display("End of reset")
  phase.drop_objection(this);
endtask : reset_phase

task afFifoTest::main_phase(uvm_phase phase);
  logic [7:0] expQ[$];
  logic [7:0] pushData;
  logic [7:0] expData;
  int         numItems = 6;

  phase.raise_objection(this);
  `af_uvm_display("Start of main")

  repeat (numItems) begin
    pushData = 8'($urandom_range(0, 255));
    expQ.push_back(pushData);
    vif.cb.push    <= 1'b1;
    vif.cb.data_in <= pushData;
    `af_uvm_printf(("Push 0x%0h", pushData))
    @(vif.cb);
  end
  vif.cb.push <= 1'b0;
  @(vif.cb);

  repeat (numItems) begin
    vif.cb.pop <= 1'b1;
    @(vif.cb);
    vif.cb.pop <= 1'b0;
    @(vif.cb);
    expData = expQ.pop_front();
    if (vif.cb.data_out !== expData)
      `af_uvm_error($sformatf("Mismatch: got 0x%0h exp 0x%0h", vif.cb.data_out, expData))
    else
      `af_uvm_printf(("Match 0x%0h", vif.cb.data_out))
  end

  `af_uvm_display("End of main")
  phase.drop_objection(this);
endtask : main_phase
