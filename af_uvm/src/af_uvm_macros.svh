//
// -------------------------------------------------------------
// Copyright 2010 AMD
// Copyright 2010-2018 Cadence Design Systems, Inc.
// Copyright 2010-2011 Mentor Graphics Corporation
// Copyright 2014-2024 NVIDIA Corporation
// Copyright 2014 Semifore
// Copyright 2004-2018 Synopsys, Inc.
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

`ifndef AF_UVM_MACROS_SVH
`define AF_UVM_MACROS_SVH

//----------------------------------------------------------------------
// Title: af_uvm macro library
//
// Simulator-agnostic UVM macro library for Verilator, VCS, Xcelium,
// and Icarus (ivl_uvm). All macros wrap standard UVM API only.
//
// Group: Reporting
//
//| `af_uvm_display   - UVM_INFO, verbosity-gated
//| `af_uvm_printf    - UVM_INFO with $sformatf format tuple
//| `af_uvm_warning   - UVM_WARNING
//| `af_uvm_error     - UVM_ERROR
//| `af_uvm_fatal     - UVM_FATAL
//
// Group: Randomization
//
//| `AF_UVM_RAND          - randomize() with warning on failure
//| `AF_UVM_RAND_WITH     - randomize() with inline constraint, warns on failure
//| `AF_UVM_RAND_STD      - std::randomize() for non-class variables
//| `AF_UVM_RAND_STD_WITH - std::randomize() with inline constraint
//
// Group: Watchdog
//
//| `AF_UVM_WAIT      - wait(condition) vs watchdog timeout, fork-safe
//| `AF_UVM_WAIT_EV   - @(event) vs watchdog timeout, fork-safe
//
// Group: Utility
//
//| `AF_UVM_CAST      - $cast wrapper, UVM_ERROR on type mismatch
//| `AF_UVM_VPL_INT   - plusarg integer parser with cover point
//| `AF_UVM_VPL_STR   - plusarg string parser
//
// Group: Test
//
//| `AF_UVM_TEST_BEGIN - open a uvm_test subclass with component_utils and new()
//| `AF_UVM_TEST_END   - close the test class (endclass)
//----------------------------------------------------------------------


//----------------------------------------------------------------------
// Group: Reporting
//----------------------------------------------------------------------

// Macro: af_uvm_display
//
// Prints a UVM_INFO message, gated by ~VERBOSITY~.
// ~ID~ defaults to get_name() of the calling component.
// Override ~ID~ for module-level or non-component contexts.
//
// Parameters:
//   MSG       - string expression to print
//   VERBOSITY - uvm_verbosity level (default: UVM_MEDIUM)
//   ID        - report ID string (default: get_name())
//
// Example:
//| `af_uvm_display("Reset complete")
//| `af_uvm_display("Driving item", UVM_HIGH)
//| `af_uvm_display("TX done", UVM_NONE, "MY_DRV")
//
// See Also:
//   <af_uvm_printf>, <af_uvm_error>
`define af_uvm_display(MSG, VERBOSITY=UVM_MEDIUM, ID=get_name()) \
  begin \
    if (uvm_report_enabled(VERBOSITY, UVM_INFO, ID) != 0) \
      uvm_report_info(ID, MSG, VERBOSITY, `uvm_file, `uvm_line); \
  end

// Macro: af_uvm_printf
//
// Prints a UVM_INFO message using a $sformatf format tuple.
// Pass the format string and its arguments as a single parenthesised
// tuple so the preprocessor treats them as one argument.
//
// Parameters:
//   FORMAT_MSG - parenthesised $sformatf tuple, e.g. ("val=%0d", val)
//   VERBOSITY  - uvm_verbosity level (default: UVM_MEDIUM)
//   ID         - report ID string (default: get_name())
//
// Example:
//| `af_uvm_printf(("addr=0x%0h data=0x%0h", addr, data))
//| `af_uvm_printf(("errors=%0d", cnt), UVM_NONE, "SCBD")
//
// See Also:
//   <af_uvm_display>
`define af_uvm_printf(FORMAT_MSG, VERBOSITY=UVM_MEDIUM, ID=get_name()) \
  begin \
    if (uvm_report_enabled(VERBOSITY, UVM_INFO, ID) != 0) \
      uvm_report_info(ID, $sformatf FORMAT_MSG, VERBOSITY, `uvm_file, `uvm_line); \
  end

// Macro: af_uvm_warning
//
// Issues a UVM_WARNING. Severity is always-on; no verbosity gate.
// Does not stop simulation. Use <af_uvm_error> or <af_uvm_fatal>
// for conditions that should block forward progress.
//
// Parameters:
//   MSG - string expression
//   ID  - report ID string (default: get_name())
//
// Example:
//| `af_uvm_warning("No reset seen before stimulus")
//| `af_uvm_warning("Unexpected idle", "MON")
`define af_uvm_warning(MSG, ID=get_name()) \
  begin \
    if (uvm_report_enabled(UVM_NONE, UVM_WARNING, ID) != 0) \
      uvm_report_warning(ID, MSG, UVM_NONE, `uvm_file, `uvm_line); \
  end

// Macro: af_uvm_error
//
// Issues a UVM_ERROR. Increments the UVM error count; simulation
// continues unless the configured error limit is reached.
// Use <af_uvm_fatal> for unrecoverable conditions.
//
// Parameters:
//   MSG - string expression
//   ID  - report ID string (default: get_name())
//
// Example:
//| `af_uvm_error("Data mismatch")
//| `af_uvm_error($sformatf("Expected %0h got %0h", exp, got), "SCBD")
//
// See Also:
//   <af_uvm_fatal>, <af_uvm_warning>
`define af_uvm_error(MSG, ID=get_name()) \
  begin \
    if (uvm_report_enabled(UVM_NONE, UVM_ERROR, ID) != 0) \
      uvm_report_error(ID, MSG, UVM_NONE, `uvm_file, `uvm_line); \
  end

// Macro: af_uvm_fatal
//
// Issues a UVM_FATAL and terminates simulation after the current
// time step. Reserve for conditions where continuing would produce
// meaningless results.
//
// Parameters:
//   MSG - string expression
//   ID  - report ID string (default: get_name())
//
// Example:
//| `af_uvm_fatal("Virtual interface not connected")
//| `af_uvm_fatal("Config object missing", "ENV")
//
// See Also:
//   <af_uvm_error>
`define af_uvm_fatal(MSG, ID=get_name()) \
  begin \
    if (uvm_report_enabled(UVM_NONE, UVM_FATAL, ID) != 0) \
      uvm_report_fatal(ID, MSG, UVM_NONE, `uvm_file, `uvm_line); \
  end


//----------------------------------------------------------------------
// Group: Randomization
//----------------------------------------------------------------------

// Macro: AF_UVM_RAND
//
// Calls randomize() on ~XN~ and issues UVM_WARNING on failure.
// Prefer this over a bare randomize() to avoid silent failures
// that leave the object in an unpredictable state.
//
// Parameters:
//   XN - object handle; must have a randomize() method
//
// Example:
//| `AF_UVM_RAND(myTxn)
//
// See Also:
//   <AF_UVM_RAND_WITH>
`define AF_UVM_RAND(XN) \
  begin \
    if (XN.randomize() == 0) \
      uvm_report_warning("RNDFLD", $sformatf("Failed to randomize: %s", XN.sprint()), \
        UVM_NONE, `uvm_file, `uvm_line); \
  end

// Macro: AF_UVM_RAND_WITH
//
// Calls randomize() with an inline constraint block and issues
// UVM_WARNING on failure. Use when the constraint cannot be expressed
// as a class-level constraint block.
//
// Parameters:
//   XN   - object handle; must have a randomize() method
//   CNST - inline constraint block, e.g. { addr < 16'hFF; }
//
// Example:
//| `AF_UVM_RAND_WITH(myTxn, { addr inside {[0:255]}; })
//
// See Also:
//   <AF_UVM_RAND>, <AF_UVM_RAND_STD>
`define AF_UVM_RAND_WITH(XN, CNST) \
  begin \
    int afRandRslt; \
    afRandRslt = XN.randomize() with CNST; \
    if (afRandRslt == 0) \
      uvm_report_warning("RNDFLD", $sformatf("Failed to randomize: %s", XN.sprint()), \
        UVM_NONE, `uvm_file, `uvm_line); \
  end


// Macro: AF_UVM_RAND_STD
//
// Calls std::randomize() on non-class ~VARS~ and issues UVM_WARNING
// on failure. Avoids WIDTHTRUNC on Verilator by comparing return
// value to 0 explicitly.
//
// Parameters:
//   VARS - variable or comma-separated variable list to randomize
//
// Example:
//| int addr, data;
//| `AF_UVM_RAND_STD(addr)
//| `AF_UVM_RAND_STD(addr, data)
//
// See Also:
//   <AF_UVM_RAND_STD_WITH>, <AF_UVM_RAND>
`define AF_UVM_RAND_STD(VARS) \
  begin \
    if (std::randomize(VARS) == 0) \
      uvm_report_warning("RNDFLD", \
        $sformatf("Failed to std::randomize: %s", `AF_UVM_DISP_ARG(VARS)), \
        UVM_NONE, `uvm_file, `uvm_line); \
  end

// Macro: AF_UVM_RAND_STD_WITH
//
// Calls std::randomize() with an inline constraint on non-class ~VARS~
// and issues UVM_WARNING on failure.
//
// Parameters:
//   VARS - variable or comma-separated variable list to randomize
//   CNST - inline constraint block, e.g. { addr < 16'hFF; }
//
// Example:
//| `AF_UVM_RAND_STD_WITH(addr, { addr inside {[0:255]}; })
//
// See Also:
//   <AF_UVM_RAND_STD>, <AF_UVM_RAND_WITH>
`define AF_UVM_RAND_STD_WITH(VARS, CNST) \
  begin \
    int afRandRslt; \
    afRandRslt = std::randomize(VARS) with CNST; \
    if (afRandRslt == 0) \
      uvm_report_warning("RNDFLD", \
        $sformatf("Failed to std::randomize: %s", `AF_UVM_DISP_ARG(VARS)), \
        UVM_NONE, `uvm_file, `uvm_line); \
  end


//----------------------------------------------------------------------
// Group: Watchdog
//----------------------------------------------------------------------

// Macro: AF_UVM_DISP_ARG
//
// Internal helper — stringifies a macro argument for watchdog
// message formatting. Not intended for direct use.
`define AF_UVM_DISP_ARG(arg) `"arg`"

// Macro: AF_UVM_WAIT
//
// Waits for ~END_SIG~ to become true, guarded by a watchdog timeout.
//
// Two levels of fork are used to isolate the disable fork: the outer
// fork..join creates a scope boundary so the inner disable fork
// cannot kill threads outside this macro's scope.
//
// If the watchdog fires before ~END_SIG~ is met, a UVM_ERROR is
// issued. The macro blocks the calling thread until one outcome occurs.
// The default timeout comes from <AF_UVM_WDOG_DEL_IN_NS> in af_uvm_pkg.
//
// Parameters:
//   END_SIG  - wait() condition expression
//   WDOG_VAL - timeout in nanoseconds (default: AF_UVM_WDOG_DEL_IN_NS)
//
// Example:
//| `AF_UVM_WAIT(vif.ready == 1'b1)
//| `AF_UVM_WAIT(dut_idle, 5000)
//
// See Also:
//   <AF_UVM_WAIT_EV>
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

// Macro: AF_UVM_WAIT_EV
//
// Waits for event expression ~EV_SPEC~, guarded by a watchdog timeout.
// Identical in fork structure to <AF_UVM_WAIT> but uses @(event)
// instead of wait(condition). Use for edge-sensitive events where
// a level-sensitive wait() would not trigger.
//
// Parameters:
//   EV_SPEC  - event expression for @(), e.g. posedge vif.clk
//   WDOG_VAL - timeout in nanoseconds (default: AF_UVM_WDOG_DEL_IN_NS)
//
// Example:
//| `AF_UVM_WAIT_EV(posedge vif.done)
//| `AF_UVM_WAIT_EV(myEvent, 2000)
//
// See Also:
//   <AF_UVM_WAIT>
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


//----------------------------------------------------------------------
// Group: Utility
//----------------------------------------------------------------------

// Macro: AF_UVM_CAST
//
// Wraps $cast with a UVM_ERROR on type mismatch. Use wherever a
// polymorphic downcast is needed to avoid silent null handles from
// a failed bare $cast.
//
// Parameters:
//   dst - destination handle (subclass type)
//   src - source handle (base class type)
//
// Example:
//| `AF_UVM_CAST(myDrvTxn, baseTxn)
`define AF_UVM_CAST(dst, src) \
  begin \
    bit retVal; \
    retVal = $cast(dst, src); \
    if (!retVal) \
      uvm_report_error("AF_UVM_CAST", "Unable to $cast — check datatype compatibility", \
        UVM_NONE, `uvm_file, `uvm_line); \
  end

// Macro: AF_UVM_VPL_INT
//
// Reads an integer plusarg (+~ARG_NAME~=<val>) into ~ARG_NAME~,
// pushes the argument name onto plusArgsInCode for audit, and adds
// an anonymous cover point so plusarg usage is visible in coverage.
//
// Requires plusArgsInCode to be in scope — provided by <af_uvm_pkg>.
//
// Parameters:
//   ARG_NAME - integer variable; populated from +ARG_NAME=<val>
//
// Example:
//| int numPkts;
//| `AF_UVM_VPL_INT(numPkts)   // reads +numPkts=<val>
//
// See Also:
//   <AF_UVM_VPL_STR>
`define AF_UVM_VPL_INT(ARG_NAME) \
  begin \
    string fmtStr, str; \
    str = `AF_UVM_DISP_ARG(ARG_NAME); \
    fmtStr = {str, "=%0d"}; \
    void'($value$plusargs(fmtStr, ARG_NAME)); \
    plusArgsInCode.push_back(str); \
    cover (ARG_NAME); \
  end

// Macro: AF_UVM_VPL_STR
//
// Reads a string plusarg (+~ARG_NAME~=<val>) into ~ARG_NAME~ and
// pushes the argument name onto plusArgsInCode for audit.
//
// Requires plusArgsInCode to be in scope — provided by <af_uvm_pkg>.
//
// Parameters:
//   ARG_NAME - string variable; populated from +ARG_NAME=<val>
//
// Example:
//| string testMode;
//| `AF_UVM_VPL_STR(testMode)   // reads +testMode=<val>
//
// See Also:
//   <AF_UVM_VPL_INT>
`define AF_UVM_VPL_STR(ARG_NAME) \
  begin \
    string fmtStr, str; \
    str = `AF_UVM_DISP_ARG(ARG_NAME); \
    fmtStr = {str, "=%0s"}; \
    void'($value$plusargs(fmtStr, ARG_NAME)); \
    plusArgsInCode.push_back(str); \
  end


//----------------------------------------------------------------------
// Group: Test
//----------------------------------------------------------------------

// Macro: AF_UVM_TEST_BEGIN
//
// Opens a uvm_test subclass with `uvm_component_utils` and a standard
// new() constructor. Close the class with <AF_UVM_TEST_END>.
//
// Parameters:
//   TEST_NAME - class name for the test
//
// Example:
//| `AF_UVM_TEST_BEGIN(myFifoTest)
//|   virtual fifo_if vif;
//|   extern virtual function void build_phase(uvm_phase phase);
//|   extern virtual task         main_phase(uvm_phase phase);
//| `AF_UVM_TEST_END
//
// See Also:
//   <AF_UVM_TEST_END>
`define AF_UVM_TEST_BEGIN(TEST_NAME) \
  class TEST_NAME extends uvm_test; \
    `uvm_component_utils(TEST_NAME) \
    function new(string name, uvm_component parent); \
      super.new(name, parent); \
    endfunction : new

// Macro: AF_UVM_TEST_END
//
// Closes the test class opened by <AF_UVM_TEST_BEGIN>.
// Takes the same TEST_NAME so the endclass label matches.
//
// Parameters:
//   TEST_NAME - class name, must match the corresponding AF_UVM_TEST_BEGIN
//
// Example:
//| `AF_UVM_TEST_BEGIN(myFifoTest)
//|   // ... class body ...
//| `AF_UVM_TEST_END(myFifoTest)
//
// See Also:
//   <AF_UVM_TEST_BEGIN>
`define AF_UVM_TEST_END(TEST_NAME) \
  endclass : TEST_NAME

`endif // AF_UVM_MACROS_SVH
