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

`ifndef AF_UVM_PKG_SV
`define AF_UVM_PKG_SV

package af_uvm_pkg;

  import uvm_pkg::*;
  export uvm_pkg::*;
  `include "uvm_macros.svh"

  string logId = "AF_UVM";

  parameter string AF_UVM_COPYRIGHT =
    "Copyright 2026 AsFigo Technologies, UK — Licensed under Apache 2.0";

  parameter int AF_UVM_WDOG_DEL_IN_NS = 10000;

  `include "af_uvm_macros.svh"

  string plusArgsInCode  [$];
  string plusArgsFromUser [string];

  function string get_name();
    return logId;
  endfunction : get_name

  function void set_name(string s);
    logId = s;
  endfunction : set_name

  function void printAfBanner();
    uvm_report_info("AF_VLT_UVM", AF_UVM_COPYRIGHT, UVM_NONE);
  endfunction : printAfBanner

endpackage : af_uvm_pkg

`endif // AF_UVM_PKG_SV
