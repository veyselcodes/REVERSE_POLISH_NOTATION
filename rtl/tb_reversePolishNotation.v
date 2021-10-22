`timescale 1ns/1ps

module tb_reversePolishNotation;

// gap between commands
parameter GAP = 10;

reg  clk = 1;
reg  rst = 1;
reg  dIn = 0;
wire dOut;

reg  [7:0] data8 = 0;
reg  [7:0] refData[0:7];
reg  [7:0] dataCaptured;

integer errorCnt = 0;
integer checkCnt = 0;

// dut
reversePolishNotation dut(.clk(clk), .rst(rst), .dIn(dIn), .dOut(dOut));

// input
initial begin : feed_input
   repeat(10) @(posedge clk);
   rst = 0;
   repeat(10) @(posedge clk);
   repeat(5) begin
      data8 = data8 + 1;
      push(data8);
   end
   enter();
   add();
   enter();
   mult();
   enter();
   clear();
   data8 = 6;
   repeat(8) begin
      push(data8);
      data8 = data8 + 2;
   end
   repeat(4) add();
   enter();
   push(8'd2);
   mult();
   enter();
   push(8'd0);
   mult();
   enter();
   push(8'd254);
   push(8'd1);
   add();
   enter();
   clear();
   push(8'd7);
   push(8'd9);
   push(8'd2);
   repeat(2) mult();
   enter();
   repeat(100) @(posedge clk);
   if(checkCnt!==8)
      $display("!!! ERROR !!! Simulation finished at time=%0d -> missed or redundant output, must be 8 checks", $time);
   else if(errorCnt==0)
      $display("*** SUCCESS *** Simulation finished at time=%0d -> no error", $time);
   else
      $display("!!! ERROR !!! Simulation finished at time=%0d -> %d error(s)", $time, errorCnt);
   $stop;
end

// output check
initial begin : check_output
   integer ii;
   integer jj;
   ii = 0;
   forever begin
      wait(dOut);
      @(posedge clk);
      @(negedge clk);
      if(dOut) begin
         errorCnt = errorCnt + 1;
         $display("ERROR!!! at time=%0d -> Unknown output protocol", $time);
      end
      for(jj=0; jj<8; jj=jj+1) begin
         @(negedge clk);
         dataCaptured[7-jj] = dOut;
      end
      @(posedge clk);
      if(dataCaptured==refData[ii]) begin
         checkCnt = checkCnt + 1;
         //$display("SUCCESS: at time=%0d -> Output=%d, Reference=%d", $time, dataCaptured, refData[ii]);
      end else begin
         checkCnt = checkCnt + 1;
         errorCnt = errorCnt + 1;
         $display("ERROR!!! at time=%0d -> Output=%d, Reference=%d", $time, dataCaptured, refData[ii]);
      end
      ii = ii + 1;
      @(posedge clk);
      repeat(GAP) @(posedge clk);
   end
end

// push data
task push;
   input [7:0] data;
   integer ii;
   begin
      @(posedge clk);
      dIn = 1;
      @(posedge clk);
      dIn = 0;
      for(ii=0; ii<8; ii=ii+1) begin
         @(posedge clk);
         dIn = data[7-ii];
      end
      @(posedge clk);
      dIn = 0;
      repeat(GAP) @(posedge clk);
   end
endtask

// clear
task clear;
   begin
      @(posedge clk);
      dIn = 1;
      repeat(2) @(posedge clk);
      dIn = 0;
      repeat(2) @(posedge clk);
      repeat(GAP) @(posedge clk);
   end
endtask

// add
task add;
   begin
      @(posedge clk);
      dIn = 1;
      repeat(2) @(posedge clk);
      dIn = 0;
      @(posedge clk);
      dIn = 1;
      @(posedge clk);
      dIn = 0;
      repeat(GAP) @(posedge clk);
   end
endtask

// multiply
task mult;
   begin
      @(posedge clk);
      dIn = 1;
      repeat(3) @(posedge clk);
      dIn = 0;
      @(posedge clk);
      repeat(GAP) @(posedge clk);
   end
endtask

// pop latest data
task enter;
   begin
      @(posedge clk);
      dIn = 1;
      repeat(4) @(posedge clk);
      dIn = 0;
      repeat(10) @(posedge clk);
      repeat(GAP) @(posedge clk);
   end
endtask

// reference output
initial begin
   refData[0] = 5;
   refData[1] = 9;
   refData[2] = 27;
   refData[3] = 80;
   refData[4] = 160;
   refData[5] = 0;
   refData[6] = 255;
   refData[7] = 126;
end

// clock
always #5 clk = !clk;

endmodule


/******************************************/
