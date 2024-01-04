`timescale 1ns / 1ps
`include "defines.vh"


module maindec(
	input wire[5:0] op,funct,

	output reg memtoreg,
	output reg memwrite,
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
		`EXE_LW : memtoreg <= 1'b1;
		default: memtoreg <= 1'b0;
		endcase
	end

	// memwrite
	always @(*) begin
		case (op)
		`EXE_SW : memwrite <= 1'b1;
		default: memwrite <= 1'b0;
		endcase
	end
    // Branch
    always @(*) begin
		case (op)
		default: branch <= 1'b0;
		endcase
	end
	// alusrc
	always @(*) begin
		case (op)
		`EXE_LW,
		`EXE_SW,

  		`EXE_ANDI,
		`EXE_ORI,
		`EXE_XORI,
		`EXE_LUI,

		`EXE_ADDI,
		`EXE_ADDIU,
		`EXE_SLTI,
		`EXE_SLTIU: alusrc <= 1'b1;
		default: alusrc <= 1'b0;
		endcase
	end

	// regwrite
	always @(*) begin
		case (op)
		//逻辑
		`EXE_NOP,
		`EXE_AND,
		`EXE_OR,
		`EXE_XOR,
		`EXE_NOR,
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

		//访存
		`EXE_LW,


		//算术运算
		`EXE_ADD,
		`EXE_ADDU,

		`EXE_ADDI,
		`EXE_ADDIU,
		
		`EXE_SUB,
		`EXE_SUBU,

		`EXE_SLT,
		`EXE_SLTU,

		`EXE_SLTI,
		`EXE_SLTIU
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
		`EXE_J : jump <= 1'b1;
		default: jump <= 1'b0;
		endcase
	end

	

endmodule
