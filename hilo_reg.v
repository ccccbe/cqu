`timescale 1ns / 1ps

module hilo_reg(
	input  wire clk,rst,
	input  wire [1:0] we,
	input  wire [31:0] hi_i,lo_i,
	output wire [31:0] hi_o,lo_o
    );
	
	reg [31:0] hi, lo;
	always @(negedge clk) begin
		if(rst) begin
			hi <= 0;
			lo <= 0;
		end else if (we==2'b11) begin
			hi <= hi_i;
			lo <= lo_i;
		end else if (we==2'b10) begin
			hi <= hi_i;
		end else if (we==2'b01) begin
			lo <= lo_i;
		end
	end

	assign hi_o = hi;
	assign lo_o = lo;
endmodule
