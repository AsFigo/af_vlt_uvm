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

`include "fifo_if.sv"
`include "af_fifo_test.sv"

module af_fifo_top;

  logic clk;
  af_uvm_clk_gen #(.FREQUENCY_MHZ(100)) u_clk (.clk(clk));

  fifo_if fifo_if_0 (clk);

  fifo fifo_0 (
    .clk              (fifo_if_0.clk),
    .rst_n            (fifo_if_0.rst_n),
    .push             (fifo_if_0.push),
    .pop              (fifo_if_0.pop),
    .data_in          (fifo_if_0.data_in),
    .push_err_on_full (fifo_if_0.push_err_on_full),
    .pop_err_on_empty (fifo_if_0.pop_err_on_empty),
    .full             (fifo_if_0.full),
    .empty            (fifo_if_0.empty),
    .data_out         (fifo_if_0.data_out)
  );

  initial begin
    uvm_config_db#(virtual fifo_if)::set(null, "*", "fifo_if", fifo_if_0);
    run_test("afFifoTest");
  end

endmodule : af_fifo_top
