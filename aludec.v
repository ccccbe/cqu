`timescale 1ns / 1ps
`include "defines.vh"

module aludec(
	input wire stallD,
	input wire[31:0] instrD,
	output reg [7:0] alucontrol
    );

	wire [5:0] op,funct;
	assign op = instrD[31:26];
	assign funct = instrD[5:0];
	always @(*) begin
		
		if (~stallD) begin
		case (op)
			`EXE_NOP:  //R型指�???
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


					`EXE_MULT :alucontrol<=`EXE_MULT_OP;
 					`EXE_MULTU:alucontrol<=`EXE_MULTU_OP;
					`EXE_DIV  :alucontrol<=`EXE_DIV_OP;
					`EXE_DIVU :alucontrol<=`EXE_DIVU_OP;
					`EXE_MTHI :alucontrol<=`EXE_MTHI_OP;
					`EXE_MTLO :alucontrol<=`EXE_MTLO_OP;
					`EXE_MFHI :alucontrol<=`EXE_MFHI_OP;
					`EXE_MFLO :alucontrol<=`EXE_MFLO_OP;
					


					//移位指令
					`EXE_SLL:alucontrol <=`EXE_SLL_OP;
					`EXE_SRL:alucontrol <=`EXE_SRL_OP;
					`EXE_SRA:alucontrol <=`EXE_SRA_OP;
					`EXE_SLLV:alucontrol <=`EXE_SLLV_OP;
					`EXE_SRLV:alucontrol <=`EXE_SRLV_OP;
					`EXE_SRAV:alucontrol <=`EXE_SRAV_OP;

					//跳转指令
					`EXE_JALR:alucontrol <=`EXE_JALR_OP;

					default: alucontrol <=8'b0;

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
			`EXE_JAL: alucontrol <=`EXE_JAL_OP;

			`EXE_BEQ : alucontrol <=`EXE_ADDU_OP;

			default: alucontrol <=8'b0;
		endcase 
		end
	
	end
endmodule