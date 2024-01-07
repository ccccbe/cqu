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
module swselect(
    input [31:0] addressE,
    input [7:0] alucontrolE,
    output reg [3:0] memwriteE
    );
    always@ (*) 
    begin  
        case(alucontrolE)
            `EXE_SB_OP: begin
                case(addressE[1:0])
//                    2'b00: memwrite2E <= 4'b1000;
//                    2'b01: memwrite2E <= 4'b0100;
//                    2'b10: memwrite2E <= 4'b0010;
//                    2'b11: memwrite2E <= 4'b0001;
                    2'b11: memwriteE <= 4'b1000;
                    2'b10: memwriteE <= 4'b0100;
                    2'b01: memwriteE <= 4'b0010;
                    2'b00: memwriteE <= 4'b0001;
                    default: memwriteE <= 4'b0000;
                endcase
            end    
            `EXE_SH_OP: begin
                case(addressE[1:0])
                    2'b00: memwriteE <= 4'b0011;
                    2'b10: memwriteE <= 4'b1100;
                    default: memwriteE <= 4'b0000;
                endcase
            end
            `EXE_SW_OP:
                memwriteE <= 4'b1111;
            default: memwriteE <= 4'b0000;       
        endcase
    end
endmodule