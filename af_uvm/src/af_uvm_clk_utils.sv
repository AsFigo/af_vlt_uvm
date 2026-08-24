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

// Module: af_uvm_clk_gen
//
// Generates a clock output at a given frequency.
// Period is computed from ~FREQUENCY_MHZ~ so the module stays
// correct across parameter changes without manual half-period
// arithmetic at the instantiation site.
//
// Parameters:
//   FREQUENCY_MHZ - clock frequency in MHz (default: 100)
//   INIT_VAL      - initial clock value: 0 starts low, 1 starts high (default: 0)
//
// Ports:
//   clk - generated clock output
//
// Example:
//| af_uvm_clk_gen #(.FREQUENCY_MHZ(50)) u_clk (.clk(clk));
module af_uvm_clk_gen #(
  parameter FREQUENCY_MHZ = 100,
  parameter INIT_VAL      = 0
) (
  output logic clk
);

  timeunit      1ns;
  timeprecision 1fs;

  real clkPeriod;
  real clkHalfPeriod;
  real freqMhzReal;

  initial begin : genClkBlk
    freqMhzReal   = FREQUENCY_MHZ;
    clkPeriod     = 1000.0 / freqMhzReal;
    clkHalfPeriod = clkPeriod / 2.0;

    if (INIT_VAL == 0) begin
      clk = 1'b0;
      #clkHalfPeriod;
    end

    forever begin : clkToggle
      clk = 1'b1;
      #clkHalfPeriod;
      clk = 1'b0;
      #clkHalfPeriod;
    end : clkToggle
  end : genClkBlk

endmodule : af_uvm_clk_gen


// Module: af_uvm_clk_div
//
// Divides an input clock into ~NUM_DIV~ slower clocks.
// Output vector o_clk_vec[0] is the same frequency as i_clk
// (with a half-cycle phase offset); higher bits are divided-down clocks.
//
// Parameters:
//   NUM_DIV - number of divided clocks (default: 1)
//
// Ports:
//   i_clk     - input clock
//   o_clk_vec - divided clock outputs [NUM_DIV:0]
//
// Example:
//| af_uvm_clk_div #(.NUM_DIV(2)) u_div (.i_clk(clk), .o_clk_vec(div_clks));
module af_uvm_clk_div #(
  parameter NUM_DIV = 1
) (
  input  logic              i_clk,
  output logic [NUM_DIV:0]  o_clk_vec
);

  initial begin : divide
    o_clk_vec = '0;
    forever begin : toggle
      @(i_clk);
      o_clk_vec = {o_clk_vec[NUM_DIV:1], i_clk} - (NUM_DIV+1)'(1);
    end : toggle
  end : divide

endmodule : af_uvm_clk_div
