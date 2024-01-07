`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/10/23 15:21:30
// Design Name: 
// Module Name: controller
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


module controller(
	input wire clk,rst,
	//decode stage
	input wire[31:0] instrD,
	output wire pcsrcD,branchD,jumpD,jrD,
	
	//execute stage
	input wire flushE,equalD,stallD,stallE,
	output wire memtoregE,alusrcE,
	output wire regdstE,regwriteE,	
	output wire[7:0] alucontrolE,

	
	//mem stage
	input wire stallM,
	output wire memtoregM,memwriteM,
				regwriteM,
	//write back stage
	output wire memtoregW,regwriteW,
	output wire[1:0] hregwriteE,
	output wire[1:0] hregwriteM,
	output wire[1:0] hregwriteW

    );
	
	//decode stage
	wire[1:0] hregwriteD;
	wire memtoregD,memwriteD,alusrcD,
		regdstD,regwriteD;
	wire[7:0] alucontrolD;


	//execute stage
	wire memwriteE;
	maindec md(
		stallD,
		instrD,
		memtoregD,
		memwriteD,
		branchD,
		alusrcD,
		regdstD,
		regwriteD,
		jumpD,jrD,
		hregwriteD
		);
	aludec ad(stallD,instrD,alucontrolD);

	assign pcsrcD = branchD & equalD;

	//pipeline registers
	flopenrc #(15) regE(
		clk,
		rst,~stallE,
		flushE,
		{memtoregD,memwriteD,alusrcD,regdstD,regwriteD,alucontrolD,hregwriteD},
		{memtoregE,memwriteE,alusrcE,regdstE,regwriteE,alucontrolE,hregwriteE}
		);
	flopenr #(8) regM(
		clk,rst,~stallM,
		{memtoregE,memwriteE,regwriteE,hregwriteE},
		{memtoregM,memwriteM,regwriteM,hregwriteM}
		);
	flopr #(8) regW(
		clk,rst,
		{memtoregM,regwriteM,hregwriteM},
		{memtoregW,regwriteW,hregwriteW}
		);
endmodule
