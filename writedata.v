`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/01/04 18:19:23
// Design Name: 
// Module Name: writedata
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


module writedata(
    input [31:0] writedataM,
    input [7:0] alucontrolM,
    output reg [31:0] writedata2M
    );
     always@ (*) begin
        case (alucontrolM)
            `EXE_SB_OP: writedata2M <= {{writedataM[7:0]},{writedataM[7:0]},{writedataM[7:0]},{writedataM[7:0]}};
            `EXE_SH_OP: writedata2M <= {{writedataM[15:0]},{writedataM[15:0]}};
            default: writedata2M <= writedataM;
        endcase
    end
endmodule
