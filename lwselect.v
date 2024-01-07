`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/01/05 16:07:58
// Design Name: 
// Module Name: lwselect
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
module lwselect(
    input wire [31:0] aluoutW,
    input [7:0] alucontrolW,
    input [31:0] resultW,
    output reg [31:0] result2W
    //output reg adel
    );

    always@ (*) begin
        case(alucontrolW)
            `EXE_LB_OP: case(aluoutW[1:0])
                2'b00: result2W = {{24{resultW[7]}},resultW[7:0]};
                2'b01: result2W = {{24{resultW[15]}},resultW[15:8]};
                2'b10: result2W = {{24{resultW[23]}},resultW[23:16]};
                2'b11: result2W = {{24{resultW[31]}},resultW[31:24]};
                default: result2W = resultW;
            endcase
            `EXE_LBU_OP: case(aluoutW[1:0])
                2'b00: result2W = {{24{1'b0}},resultW[7:0]};
                2'b01: result2W = {{24{1'b0}},resultW[15:8]};
                2'b10: result2W = {{24{1'b0}},resultW[23:16]};
                2'b11: result2W = {{24{1'b0}},resultW[31:24]};
                default: result2W = resultW;
            endcase
            `EXE_LH_OP: case(aluoutW[1:0])
                2'b00: result2W = {{16{resultW[15]}},resultW[15:0]};
                2'b10: result2W = {{16{resultW[31]}},resultW[31:16]};
                default: result2W = resultW;  //adel = 1;
            endcase
            `EXE_LHU_OP:case(aluoutW[1:0])
                2'b00: result2W = {{16{1'b0}},resultW[15:0]};
                2'b10: result2W = {{16{1'b0}},resultW[31:16]};
                default: result2W = resultW;  //adel = 1;   
            endcase
            // `EXE_LW_OP: if(aluoutW[1:0] == 2'b00) 
            //                 result2W = resultW;
            //             else adel = 1;
        default: result2W = resultW;
        endcase
    end
endmodule
