`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/11/22 10:23:13
// Design Name: 
// Module Name: hazard
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
`include "defines.vh"


module hazard(
	//fetch stage
	output wire stallF,
	//decode stage
	input wire[4:0] rsD,rtD,
	input wire branchD,
	output wire forwardaD,forwardbD,
	output wire stallD,
	//execute stage
	output wire forwardajalE,

	input wire [1:0] hilo_weE,
	output wire[1:0] forwardhiloE,

	output wire stallE,

	input wire[4:0] rsE,rtE,
	input wire[4:0] writeregE,
	input wire regwriteE,
	input wire memtoregE,
	output reg[1:0] forwardaE,forwardbE,
	output wire flushE,


	output wire div_start,
	input wire div_ready,//start and ready should exchange
	input wire[7:0] alucontrolE,
	//mem stage
	output wire stallM,
	input wire [1:0] hilo_weM,

	input wire[4:0] writeregM,
	input wire regwriteM,
	input wire memtoregM,

	//write back stage

	input wire [1:0] hilo_weW,

	input wire[4:0] writeregW,
	input wire regwriteW
    );

	wire lwstallD,branchstallD;




	assign div_start = (alucontrolE == `EXE_DIV_OP&& div_ready == 1'b0)?1'b1:
				   (alucontrolE == `EXE_DIV_OP && div_ready == 1'b1)?1'b0:
				   (alucontrolE == `EXE_DIVU_OP && div_ready == 1'b0)?1'b1:
				   (alucontrolE == `EXE_DIVU_OP && div_ready == 1'b1)?1'b0:
			       1'b0;



	//forwarding sources to D stage (branch equality)
	assign forwardaD = (rsD != 0 & rsD == writeregM & regwriteM);
	assign forwardbD = (rtD != 0 & rtD == writeregM & regwriteM);
	assign forwardajalE = (alucontrolE == `EXE_JAL_OP||alucontrolE == `EXE_JALR_OP)?1'b1:1'b0;
	//forwarding sources to E stage (ALU)
	assign forwardhiloE =	(hilo_weE==2'b00 & (hilo_weM==2'b10 | hilo_weM==2'b01 | hilo_weM==2'b11))?2'b01:
							(hilo_weE==2'b00 & (hilo_weW==2'b10 | hilo_weW==2'b01 | hilo_weW==2'b11))?2'b10:
							2'b00;
	
	
	
	
	always @(*) begin
		forwardaE = 2'b00;
		forwardbE = 2'b00;
		if(rsE != 0) begin
			/* code */
			if(rsE == writeregM & regwriteM) begin
				/* code */
				forwardaE = 2'b10;
			end else if(rsE == writeregW & regwriteW) begin
				/* code */
				forwardaE = 2'b01;
			end
		end
		if(rtE != 0) begin
			/* code */
			if(rtE == writeregM & regwriteM) begin
				/* code */
				forwardbE = 2'b10;
			end else if(rtE == writeregW & regwriteW) begin
				/* code */
				forwardbE = 2'b01;
			end
		end
	end

	//stalls
	assign #1 lwstallD = memtoregE & (rtE == rsD | rtE == rtD);
	assign #1 branchstallD = branchD &
				(regwriteE & 
				(writeregE == rsD | writeregE == rtD) |
				memtoregM &
				(writeregM == rsD | writeregM == rtD));
	assign #1 stallD = div_start | lwstallD | branchstallD;
	assign #1 stallF = stallD;
	assign #1 stallE = div_start | branchstallD;
	assign #1 stallM = branchstallD;
		//stalling D stalls all previous stages
		//stalling D flushes next stage
	// Note: not necessary to stall D stage on store
  	//       if source comes from load;
  	//       instead, another bypass network could
  	//       be added from W to M
endmodule
