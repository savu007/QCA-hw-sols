// DETECTOR ////////////////////////////////////////////////////////////////
// 
// Description: Pattern Detector.
// Author: Anjelica Bian
// 
// SPECIFICATION .........................................................
// Given a stream of input bits, pulse a 1 on the output (dout) whenever 
// a b1010 sequence is detected on the input (din).
//
// When the reset signal (rst) goes high, all previously seen bits 
// on the input are no longer considered when searching for b1010.
// We are using synchronous reset, so the reset signal only takes effect
// on the positive clock edge.
//
// Input Signals
// - clk:    Clock signal
// - rst:    Active high reset signal
// - din:    Input bits
//
// Output signals
// - dout:   1 if a b1010 was detected, 0 otherwise
// - dout:   0 when resetn is active
// 
///////////////////////////////////////////////////////////////////////////

`ifndef DETECTOR_SV
`define DETECTOR_SV

module detector (
  input clk,
  input rst,
  input din,
  output logic dout
);

logic [2:0] Scurr, Snext;

parameter [2:0] Init = 3'b000,
                Got1 = 3'b001,
                Got10 = 3'b010,
                Got101 = 3'b011,
                Got1010 = 3'b100;

always @(din, Scurr)
begin
  case (Scurr)
    Init: if(din == 1) Snext = Got1; else Snext = Init;
    Got1: if(din == 1) Snext = Got1; else Snext = Got10;
    Got10: if(din == 1) Snext = Got101; else Snext = Init;
    Got101: if(din == 1) Snext = Got1; else Snext = Got1010;
    Got1010: if(din == 1) Snext = Got101; else Snext = Init;
    default: Snext = Init;
  endcase
end

always @(Scurr)
  if (Scurr == Got1010) dout = 1; else dout = 0;

always @(posedge clk)
  if (rst) Scurr <= Init; else Scurr <= Snext;


endmodule

`endif /* DETECTOR_SV */