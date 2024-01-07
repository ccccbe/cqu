`timescale 1ns / 1ps
`include "defines.vh"


module maindec(

	input wire stallD,
	input wire[31:0] instrD,

	output reg memtoreg,
	output reg memwrite,
	output reg branch,
	output reg alusrc,
	output reg regdst,
	output reg regwrite,
	output reg jump,jr,

	output reg [1:0] hregwrite
    );
	reg[6:0] controls;
	wire [5:0] op,funct;
	assign op=instrD[31:26];
	assign funct=instrD[5:0];
	always @(*) begin
		if (~stallD) begin
		case (op)
			`EXE_NOP:
				case (funct)
				`EXE_MULT ,
        		`EXE_MULTU,
				`EXE_DIV,
				`EXE_DIVU:hregwrite <= 2'b11;
    			`EXE_MTHI:hregwrite <= 2'b10;
        		`EXE_MTLO:hregwrite <= 2'b01;
				default:  hregwrite <= 2'b00;
				endcase
			default:  hregwrite <= 2'b00;
		endcase
		end
	end


	// memtoreg
	always @(*) begin
		if (~stallD) begin
		case (op)
		`EXE_LB,
        `EXE_LBU,
    	`EXE_LH,
        `EXE_LHU,
        `EXE_LW :memtoreg <= 1'b1;
		default: memtoreg <= 1'b0;
		endcase
		end
	end

	// memwrite
	always @(*) begin
		if (~stallD) begin
		case (op)
		`EXE_SB,
        `EXE_SH,
        `EXE_SW : memwrite <= 1'b1;
		default: memwrite <= 1'b0;
		endcase
		end
	end
    // Branch
    always @(*) begin
		if (~stallD) begin
		case (op)

		//`EXE_BEQ,
		//`EXE_BGTZ,
        //`EXE_BLEZ,
        //`EXE_BNE:branch <= 1'b1;
       // 6'b001000:
		
		//`EXE_BLTZ,`EXE_BGEZ,
        //`EXE_BLTZAL,
        
        //`EXE_BGEZAL:branch <= 1'b1;
		default: branch <= 1'b0;
		endcase
		end
	end
	// alusrc
	always @(*) begin
		if (~stallD) begin
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
	end

	// regwrite
	always @(*) begin
		if (~stallD) begin
		case (op)
		//逻辑
		`EXE_NOP:
			case (funct)
				`EXE_MTHI,
				`EXE_MTLO,
				`EXE_MULT,
        		`EXE_MULTU,
				`EXE_DIV,
				`EXE_DIVU,
				`EXE_JR
				: regwrite <= 1'b0;
				default: regwrite <= 1'b1;
			endcase

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


		//跳转
		`EXE_JAL

		: regwrite <= 1'b1;
		default: regwrite <= 1'b0;
		endcase
		end
	end

	// regdst
	always @(*) begin
		if (~stallD) begin
		case (op)
		`EXE_NOP : regdst <= 1'b1;
		default: regdst <= 1'b0;
		endcase
		end
	end

	// jump
	always @(*) begin
		if (~stallD) begin
		case (op)
		`EXE_J ,
		`EXE_JAL: jump <= 1'b1;

		`EXE_NOP:
			case (funct)
				//`EXE_JALR
				//: jump <= 1'b1;
				default: jump <= 1'b0;
			endcase


		default: jump <= 1'b0;
		endcase
		end
	end


	//jr
	always @(*) begin
		if (~stallD) begin
		case (op)

		`EXE_NOP:
			case (funct)
				`EXE_JALR,
				`EXE_JR
				: jr <= 1'b1;
				default: jr <= 1'b0;
			endcase


		default: jr <= 1'b0;
		endcase
		end
	end



	

endmodule
