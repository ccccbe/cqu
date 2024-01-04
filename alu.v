`timescale 1ns / 1ps
`include "defines.vh"


module alu(
	input wire[31:0] a,b,
	input wire[7:0] sel,
	input wire[4:0] sa,
	output reg [31:0] result
    );

	always @(*) begin
		case (sel)
			//逻辑运算指令
			`EXE_AND_OP :result<= a & b;
			`EXE_OR_OP  :result<= a | b;
			`EXE_XOR_OP :result<= a ^ b;
			`EXE_NOR_OP :result<= ~(a | b);
			`EXE_ANDI_OP:result<= a & { {16{1'b0}} ,b[15:0]};
			`EXE_ORI_OP :result<= a | { {16{1'b0}} ,b[15:0]};
			`EXE_XORI_OP:result<= a ^ { {16{1'b0}} ,b[15:0]};
			`EXE_LUI_OP :result<= {b[15:0],16'b0};

			//算术运算
			`EXE_ADD_OP:result <= a + b;
			
			`EXE_ADDU_OP:result <= a + b;
			`EXE_SUB_OP:result <= a - b;
			`EXE_SUBU_OP:result <= a - b;
			`EXE_ADDI_OP:result <= a + b;
			`EXE_ADDIU_OP:result <= a + b;

			`EXE_SLT_OP  :result <=($signed(a)< $signed(b))? 1 : 0 ;
			`EXE_SLTU_OP :result <=(a < b)? 1 : 0 ;
			`EXE_SLTI_OP :result <=($signed(a)< $signed(b))? 1 : 0 ;
			`EXE_SLTIU_OP:result <=(a < b)? 1 : 0 ;



			//移位运算指令
			`EXE_SLL_OP:result <= b << sa; //移位sa
            `EXE_SRL_OP:result <= b >> sa;
            `EXE_SRA_OP:result <= $signed(b) >>> sa;
			`EXE_SLLV_OP:result <= b << a[4:0]; //移位src a
            `EXE_SRLV_OP:result <= b >> a[4:0];
            `EXE_SRAV_OP:result <= $signed(b) >>> a[4:0];


			default: result <= 32'b0;
		endcase
	end

endmodule
