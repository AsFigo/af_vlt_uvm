//
// -------------------------------------------------------------
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
