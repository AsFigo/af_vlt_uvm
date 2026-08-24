//
// -------------------------------------------------------------
// Copyright 2010 AMD
// Copyright 2010-2018 Cadence Design Systems, Inc.
// Copyright 2010-2011 Mentor Graphics Corporation
// Copyright 2014-2024 NVIDIA Corporation
// Copyright 2014 Semifore
// Copyright 2004-2018 Synopsys, Inc.
// Copyright 2004-2017 VerifWorks, Bangalore, India (Go2UVM)
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

`define af_uvm_display(MSG, VERBOSITY=UVM_MEDIUM, ID=get_name()) \
  begin \
    if (uvm_report_enabled(VERBOSITY, UVM_INFO, ID) != 0) \
      uvm_report_info(ID, MSG, VERBOSITY, `uvm_file, `uvm_line); \
  end

`define af_uvm_printf(FORMAT_MSG, VERBOSITY=UVM_MEDIUM, ID=get_name()) \
  begin \
    if (uvm_report_enabled(VERBOSITY, UVM_INFO, ID) != 0) \
      uvm_report_info(ID, $sformatf FORMAT_MSG, VERBOSITY, `uvm_file, `uvm_line); \
  end

`define af_uvm_warning(MSG, ID=get_name()) \
  begin \
    if (uvm_report_enabled(UVM_NONE, UVM_WARNING, ID) != 0) \
      uvm_report_warning(ID, MSG, UVM_NONE, `uvm_file, `uvm_line); \
  end

`define af_uvm_error(MSG, ID=get_name()) \
  begin \
    if (uvm_report_enabled(UVM_NONE, UVM_ERROR, ID) != 0) \
      uvm_report_error(ID, MSG, UVM_NONE, `uvm_file, `uvm_line); \
  end

`define af_uvm_fatal(MSG, ID=get_name()) \
  begin \
    if (uvm_report_enabled(UVM_NONE, UVM_FATAL, ID) != 0) \
      uvm_report_fatal(ID, MSG, UVM_NONE, `uvm_file, `uvm_line); \
  end

`define AF_UVM_RAND(XN) \
  begin \
    if (XN.randomize() == 0) \
      uvm_report_warning("RNDFLD", $sformatf("Failed to randomize: %s", XN.sprint()), \
        UVM_NONE, `uvm_file, `uvm_line); \
  end

`define AF_UVM_RAND_WITH(XN, CNST) \
  begin \
    int afRandRslt; \
    afRandRslt = XN.randomize() with CNST; \
    if (afRandRslt == 0) \
      uvm_report_warning("RNDFLD", $sformatf("Failed to randomize: %s", XN.sprint()), \
        UVM_NONE, `uvm_file, `uvm_line); \
  end

`define AF_UVM_RAND_STD(VARS) \
  begin \
    if (std::randomize(VARS) == 0) \
      uvm_report_warning("RNDFLD", \
        $sformatf("Failed to std::randomize: %s", `AF_UVM_DISP_ARG(VARS)), \
        UVM_NONE, `uvm_file, `uvm_line); \
  end

`define AF_UVM_RAND_STD_WITH(VARS, CNST) \
  begin \
    int afRandRslt; \
    afRandRslt = std::randomize(VARS) with CNST; \
    if (afRandRslt == 0) \
      uvm_report_warning("RNDFLD", \
        $sformatf("Failed to std::randomize: %s", `AF_UVM_DISP_ARG(VARS)), \
        UVM_NONE, `uvm_file, `uvm_line); \
  end

`define AF_UVM_DISP_ARG(arg) `"arg`"

`define AF_UVM_WAIT(END_SIG, WDOG_VAL=AF_UVM_WDOG_DEL_IN_NS) \
  fork \
    begin \
      fork \
      begin \
        string msg; \
        wait (END_SIG); \
        msg = $sformatf("Wait condition met: %s", `AF_UVM_DISP_ARG(END_SIG)); \
        `af_uvm_display(msg) \
      end \
      begin \
        string msg; \
        #(WDOG_VAL * 1ns); \
        msg = $sformatf("WDOG expired after %0d ns, condition: %s", \
          WDOG_VAL, `AF_UVM_DISP_ARG(END_SIG)); \
        `af_uvm_error(msg) \
      end \
      join_any \
      disable fork; \
    end \
  join

`define AF_UVM_WAIT_EV(EV_SPEC, WDOG_VAL=AF_UVM_WDOG_DEL_IN_NS) \
  fork \
    begin \
      fork \
      begin \
        string msg; \
        @(EV_SPEC); \
        msg = $sformatf("Event seen: @(%s)", `AF_UVM_DISP_ARG(EV_SPEC)); \
        `af_uvm_display(msg) \
      end \
      begin \
        string msg; \
        #(WDOG_VAL * 1ns); \
        msg = $sformatf("WDOG expired after %0d ns, event: @(%s)", \
          WDOG_VAL, `AF_UVM_DISP_ARG(EV_SPEC)); \
        `af_uvm_error(msg) \
      end \
      join_any \
      disable fork; \
    end \
  join

`define AF_UVM_CAST(dst, src) \
  begin \
    bit retVal; \
    retVal = $cast(dst, src); \
    if (!retVal) \
      uvm_report_error("AF_UVM_CAST", "Unable to $cast — check datatype compatibility", \
        UVM_NONE, `uvm_file, `uvm_line); \
  end

`define AF_UVM_VPL_INT(ARG_NAME) \
  begin \
    string fmtStr, str; \
    str = `AF_UVM_DISP_ARG(ARG_NAME); \
    fmtStr = {str, "=%0d"}; \
    void'($value$plusargs(fmtStr, ARG_NAME)); \
    plusArgsInCode.push_back(str); \
    cover (ARG_NAME); \
  end

`define AF_UVM_VPL_STR(ARG_NAME) \
  begin \
    string fmtStr, str; \
    str = `AF_UVM_DISP_ARG(ARG_NAME); \
    fmtStr = {str, "=%0s"}; \
    void'($value$plusargs(fmtStr, ARG_NAME)); \
    plusArgsInCode.push_back(str); \
  end

`define AF_UVM_TEST_BEGIN(TEST_NAME) \
  class TEST_NAME extends uvm_test; \
    `uvm_component_utils(TEST_NAME) \
    function new(string name, uvm_component parent); \
      super.new(name, parent); \
    endfunction : new

`define AF_UVM_TEST_END(TEST_NAME) \
  endclass : TEST_NAME

/* verilator lint_off MODDUP */
package af_uvm_pkg;

  import uvm_pkg::*;
  export uvm_pkg::*;
  `include "uvm_macros.svh"

  string logId = "AF_UVM";

  parameter string AF_UVM_COPYRIGHT =
    "Copyright 2023-2026 AsFigo Technologies, UK — Licensed under Apache 2.0";

  /* verilator lint_off UNUSEDPARAM */
  parameter int AF_UVM_WDOG_DEL_IN_NS = 10000;
  /* verilator lint_on UNUSEDPARAM */

  string plusArgsInCode  [$];
  string plusArgsFromUser [string];

  function string get_name();
    return logId;
  endfunction : get_name

  function void set_name(string s);
    logId = s;
  endfunction : set_name

  function void printAfBanner();
    uvm_report_info("AF_VLT_UVM", AF_UVM_COPYRIGHT);
  endfunction : printAfBanner

endpackage : af_uvm_pkg
/* verilator lint_on MODDUP */

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

`define DATA_WIDTH 8
`define ADDR_WIDTH 4

module fifo #(parameter DEPTH = 2**`ADDR_WIDTH-1)
             (input                    clk, rst_n, push, pop,
              input  [`DATA_WIDTH-1:0] data_in,
              output reg               push_err_on_full, pop_err_on_empty,
              output                   full, empty,
              output reg [`DATA_WIDTH-1:0] data_out);

  reg [`ADDR_WIDTH-1:0] w_ptr, r_ptr;
  reg [`DATA_WIDTH-1:0] mem [0:2**`ADDR_WIDTH-1];
  reg [1:0] wrap_wr, wrap_re;

  assign full  = ((wrap_wr != wrap_re) && (w_ptr == r_ptr)) ? 1'b1 : 1'b0;
  assign empty = ((wrap_wr == wrap_re) && (w_ptr == r_ptr)) ? 1'b1 : 1'b0;

  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) wrap_wr <= 0;
    else if (w_ptr == DEPTH) wrap_wr <= wrap_wr + 1'b1;
  end

  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) wrap_re <= 0;
    else if (r_ptr == DEPTH) wrap_re <= wrap_re + 1'b1;
  end

  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
      data_out <= {`DATA_WIDTH{1'b0}};
      w_ptr    <= 0;
      r_ptr    <= 0;
    end else begin
      if (push) begin
        if (!full) begin
          mem[w_ptr] <= data_in;
          w_ptr      <= w_ptr + 1'b1;
        end
      end else if (pop) begin
        if (!empty) begin
          data_out <= mem[r_ptr];
          r_ptr    <= r_ptr + 1'b1;
        end
      end
    end
  end

  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
      push_err_on_full  <= 0;
      pop_err_on_empty  <= 0;
    end else begin
      push_err_on_full  <= push && full;
      pop_err_on_empty  <= pop  && empty;
    end
  end

endmodule

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

/* verilator lint_off IMPORTSTAR */
import af_uvm_pkg::*;
/* verilator lint_on IMPORTSTAR */

/* verilator lint_off DECLFILENAME */
`AF_UVM_TEST_BEGIN(afFifoTest)

  virtual fifo_if vif;

  extern virtual function void build_phase(uvm_phase phase);
  extern virtual task         reset_phase(uvm_phase phase);
  extern virtual task         main_phase(uvm_phase phase);

`AF_UVM_TEST_END(afFifoTest)
/* verilator lint_on DECLFILENAME */

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
