`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/11/07 10:58:03
// Design Name: 
// Module Name: mips
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module mips(
	input wire clk,rst,
	output wire[31:0] pcF,
	input wire[31:0] instrF,
	output wire memwriteM,
	output wire[31:0] aluoutM,writedataM,
	input wire[31:0] readdataM 
    );
	
	wire [31:0] instrD;
	wire regdstE,alusrcE,pcsrcD,memtoregE,memtoregM,memtoregW,branchD,jumpD,jrD,
			regwriteE,regwriteM,regwriteW;
	wire [7:0] alucontrolE;
	wire flushE,equalD,stallD,stallE,stallM;
	wire [1:0] hregwriteE,hregwriteM,hregwriteW;
	controller c(
		clk,rst,
		//decode stage
		instrD,
		pcsrcD,branchD,jumpD,jrD,
		
		//execute stage
		flushE,equalD,stallD,stallE,
		memtoregE,alusrcE,
		regdstE,regwriteE,	
		alucontrolE,

		//mem stage
		stallM,memtoregM,memwriteM,
		regwriteM,
		//write back stage
		memtoregW,regwriteW,
		hregwriteE,hregwriteM,hregwriteW
		);
	datapath dp(
		clk,rst,
		//fetch stage
		pcF,
		instrF,
		//decode stage
		pcsrcD,branchD,
		jumpD,jrD,
		equalD,stallD,
		instrD,
		//execute stage
		memtoregE,
		alusrcE,regdstE,
		regwriteE,
		alucontrolE,
		flushE,stallE,
		//mem stage
		stallM,memtoregM,
		regwriteM,
		aluoutM,writedataM,
		readdataM,
		//writeback stage
		memtoregW,
		regwriteW,
		hregwriteE,hregwriteM,hregwriteW
	    );
	
endmodule
