`timescale 1ns / 1ps
`include "defines.vh"

module aludec(
	input wire[5:0] op,funct,
	output reg [7:0] alucontrol
    );


	always @(*) begin
		case (op)
			`EXE_NOP:  //R型指�?
				case (funct)
					//逻辑运算
					`EXE_AND:alucontrol <= `EXE_AND_OP;
					`EXE_OR :alucontrol <= `EXE_OR_OP;
					`EXE_XOR:alucontrol <= `EXE_XOR_OP;
					`EXE_NOR:alucontrol <= `EXE_NOR_OP;

					//算术运算
					
					`EXE_ADD:alucontrol <=`EXE_ADD_OP;
					`EXE_SUB:alucontrol <=`EXE_SUB_OP;
					`EXE_ADDU:alucontrol<=`EXE_ADDU_OP;
					`EXE_SUBU:alucontrol<=`EXE_SUBU_OP;


					`EXE_SLT :alucontrol<=`EXE_SLT_OP;
					`EXE_SLTU:alucontrol <=`EXE_SLTU_OP;
					



					//移位指令
					`EXE_SLL:alucontrol <=`EXE_SLL_OP;
					`EXE_SRL:alucontrol <=`EXE_SRL_OP;
					`EXE_SRA:alucontrol <=`EXE_SRA_OP;
					`EXE_SLLV:alucontrol <=`EXE_SLLV_OP;
					`EXE_SRLV:alucontrol <=`EXE_SRLV_OP;
					`EXE_SRAV:alucontrol <=`EXE_SRAV_OP;

					default: alucontrol <=`EXE_ADDU_OP;

				endcase

			// 逻辑运算 immediate
			`EXE_ANDI :alucontrol <=`EXE_ANDI_OP;	
			`EXE_ORI  :alucontrol <=`EXE_ORI_OP;
			`EXE_XORI :alucontrol <=`EXE_XORI_OP;
			`EXE_LUI  :alucontrol <=`EXE_LUI_OP;	
			

			//算术运算 immediate
			`EXE_ADDI :alucontrol <=`EXE_ADDI_OP ;
			`EXE_ADDIU:alucontrol <=`EXE_ADDIU_OP;
			`EXE_SLTI:alucontrol <=`EXE_SLTI_OP;
			`EXE_SLTIU:alucontrol <=`EXE_SLTIU_OP;




			//访存指令
			`EXE_LW : alucontrol <=`EXE_ADD_OP;
			`EXE_SW : alucontrol <=`EXE_ADD_OP;

			//跳转指令
			`EXE_J : alucontrol <=`EXE_ADDU_OP;
			`EXE_BEQ : alucontrol <=`EXE_ADDU_OP;

			default: alucontrol <=`EXE_ADDU_OP;
		endcase 

	
	end
endmodule