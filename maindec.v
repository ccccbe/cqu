`timescale 1ns / 1ps
`include "defines.vh"


module maindec(
	input wire[5:0] op,funct,

	output reg memtoreg,
	output reg [3:0] memwrite,
	output reg branch,
	output reg alusrc,
	output reg regdst,
	output reg regwrite,
	output reg jump
	

    );
	reg[6:0] controls;
	
	// memtoreg
	always @(*) begin
		case (op)
		`EXE_LB,
        `EXE_LBU,
    	`EXE_LH,
        `EXE_LHU,
        `EXE_LW :memtoreg <= 1'b1;
		default: memtoreg <= 1'b0;
		endcase
	end

	// memwrite
	always @(*) begin
		case (op)
		`EXE_SB : memwrite <=4'b0001;
        `EXE_SH : memwrite <=4'b0011;
        `EXE_SW : memwrite <= 4'b1111;
		default: memwrite <= 4'b0000;
		endcase
	end
    // Branch
    always @(*) begin
		case (op)
		`EXE_BEQ
		:branch <= 1'b1;
		default: branch <= 1'b0;
		endcase
	end
	// alusrc
	always @(*) begin
		case (op)
		`EXE_ANDI,
		`EXE_ORI,
		`EXE_XORI,
		`EXE_LUI,

		`EXE_ADDI,
		`EXE_ADDIU,
		`EXE_SLTI,
		`EXE_SLTIU,
		
		//访存
		`EXE_LB,
        `EXE_LBU,
    	`EXE_LH,
        `EXE_LHU,
        `EXE_LW,
		`EXE_SB,
        `EXE_SH,
        `EXE_SW


		: alusrc <= 1'b1;
		default: alusrc <= 1'b0;
		endcase
	end

	// regwrite
	always @(*) begin
		case (op)
		//逻辑
		`EXE_NOP,


		`EXE_ANDI,
		`EXE_ORI,
		`EXE_XORI,
		`EXE_LUI,

		//移位

		`EXE_SLL,
		`EXE_SLLV,
		`EXE_SRL,
		`EXE_SRLV,
		`EXE_SRA,
		`EXE_SRAV,


		//算术运算

		`EXE_ADDI,
		`EXE_ADDIU,
		`EXE_SLTI,
		`EXE_SLTIU,

		//访存
		`EXE_LB,
        `EXE_LBU,
    	`EXE_LH,
        `EXE_LHU,
        `EXE_LW,

		//数据移动
		`EXE_MFHI,
    	`EXE_MFLO,

		//跳转
		`EXE_JALR


		: regwrite <= 1'b1;
		default: regwrite <= 1'b0;
		endcase
	end

	// regdst
	always @(*) begin
		case (op)
		`EXE_NOP : regdst <= 1'b1;
		default: regdst <= 1'b0;
		endcase
	end

	// jump
	always @(*) begin
		case (op)
		`EXE_J ,
		`EXE_JAL: jump <= 1'b1;
		default: jump <= 1'b0;
		endcase
	end

	

endmodule
