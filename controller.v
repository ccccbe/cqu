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
	input wire[5:0] opD,functD,
	output wire pcsrcD,branchD,
	input wire equalD,
	output wire jumpD,
	
	//execute stage
	input wire flushE,
	output wire memtoregE,alusrcE,
	output wire regdstE,regwriteE,	
	output wire[7:0] alucontrolE,
	output wire[3:0] memwriteE,
	//mem stage
	output wire memtoregM,
	output wire [3:0]memwriteM,
	output wire regwriteM,
	//write back stage
	output wire memtoregW,regwriteW

    );
	
	//decode stage
	//wire[1:0] aluopD;
	wire memtoregD,alusrcD,
		regdstD,regwriteD;
	wire [3:0]memwriteD;
	wire[7:0] alucontrolD;

	//execute stage
	//wire memwriteE;
	maindec md(
		opD,
		functD,
		memtoregD,
		memwriteD,
		branchD,
		alusrcD,
		regdstD,
		regwriteD,
		jumpD
		);
	aludec ad(opD,functD,alucontrolD);

	assign pcsrcD = branchD & equalD;

	//pipeline registers
	floprc #(16) regE(
		clk,
		rst,
		flushE,
		{memtoregD,memwriteD,alusrcD,regdstD,regwriteD,alucontrolD},
		{memtoregE,memwriteE,alusrcE,regdstE,regwriteE,alucontrolE}
		);
	flopr #(6) regM(
		clk,rst,
		{memtoregE,memwriteE,regwriteE},
		{memtoregM,memwriteM,regwriteM}
		);
	flopr #(2) regW(
		clk,rst,
		{memtoregM,regwriteM},
		{memtoregW,regwriteW}
		);
endmodule
