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

interface fifo_if (input logic clk);

  logic [7:0] data_in;
  logic       pop;
  logic       push;
  logic       rst_n;
  logic [7:0] data_out;
  logic       empty;
  logic       full;
  logic       pop_err_on_empty;
  logic       push_err_on_full;

  /* verilator lint_off UNUSEDSIGNAL */
  clocking cb @(posedge clk);
    output data_in;
    output pop;
    output push;
    output rst_n;
    input  data_out;
    input  empty;
    input  full;
    input  pop_err_on_empty;
    input  push_err_on_full;
  endclocking : cb
  /* verilator lint_on UNUSEDSIGNAL */

endinterface : fifo_if
