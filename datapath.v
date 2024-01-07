`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/11/02 15:12:22
// Design Name: 
// Module Name: datapath
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


module datapath(
	input wire clk,rst,
	//fetch stage
	output wire[31:0] pcF,
	input wire[31:0] instrF,
	//decode stage
	input wire pcsrcD,branchD,
	input wire jumpD,jrD,
	output wire equalD,stallD,
	output wire[31:0] instrD,

	//execute stage
	input wire memtoregE,
	input wire alusrcE,regdstE,
	input wire regwriteE,
	input wire[7:0] alucontrolE,
	output wire flushE,stallE,
	
	//mem stage
	output wire stallM,
	input wire memtoregM,
	input wire regwriteM,
	output wire[31:0] aluoutM,writedataM,
	input wire[31:0] readdataM,
	//writeback stage
	input wire memtoregW,
	input wire regwriteW,
	input wire[1:0] hregwriteE,
	input wire[1:0] hregwriteM,
	input wire[1:0] hregwriteW

    );
	
	//fetch stage
	wire stallF;
	//FD
	wire [31:0] pcnextFD,pcnextF2D,pcnextbrFD,pcplus4F,pcbranchD;
	//decode stage
	wire [31:0] pcplus4D;
	wire [5:0]  opD,functD;
	
	wire forwardaD,forwardbD;
	wire [4:0] rsD,rtD,rdD;
	wire [31:0] hiD,loD;
	wire flushD,stallD; 
	wire [31:0] signimmD,signimmshD;
	wire [31:0] srcaD,srca2D,srcbD,srcb2D;
	//execute stage

	wire forwardajalE;

	wire[31:0] instrE;
	wire [1:0] forwardaE,forwardbE,forwardhiloE;
	wire [4:0] rsE,rtE,rdE,saD,saE;

	//hi-lo reg value to be written back
	wire [31:0] hi_alu_outE,lo_alu_outE;
	wire [31:0] hi_div_outE,lo_div_outE;


	wire ready_oE,start_iE;//div start and div finish signal
	wire div_signalE;

	wire overflow;
	//hi-lo reg value propagate
	wire selectregwriteE;
	wire [31:0] hiE,loE;
	wire [31:0] hi2E,lo2E;
	wire [4:0] writeregE,writereg2E;
	wire [31:0] signimmE;
	wire [31:0] srcaE,srca2E,srca3E,srcbE,srcb2E,srcb3E;
	wire [31:0] aluoutE;
	//mem stage
	wire stallM;
	wire [4:0] writeregM;
	//writeback stage
	wire [4:0] writeregW;
	wire [31:0] aluoutW,readdataW,resultW;
	wire [31:0] hi_iM,lo_iM,hi_iE,lo_iE,hi_iW,lo_iW;
	//hazard detection
	hazard h(
		//fetch stage
		stallF,
		//decode stage
		rsD,rtD,
		branchD,
		forwardaD,forwardbD,
		stallD,
		//execute stage
		forwardajalE,
		hregwriteE,
		forwardhiloE,
		stallE,
		rsE,rtE,
		writeregE,
		regwriteE,
		memtoregE,
		forwardaE,forwardbE,
		flushE,

		start_iE,
		ready_oE,

		alucontrolE,
		//mem stage
		stallM,
		hregwriteM,

		writeregM,
		regwriteM,
		memtoregM,
		//write back stage

		hregwriteW,


		writeregW,
		regwriteW
		);

	//next PC logic (operates in fetch an decode)
	mux2 #(32) pcbrmux(pcplus4F,pcbranchD,pcsrcD,pcnextbrFD);
	mux2 #(32) pcmux(pcnextbrFD,
		{pcplus4D[31:28],instrD[25:0],2'b00},
		jumpD,pcnextFD);
	mux2 #(32) qqmux(pcnextFD,srca2D,jrD,pcnextF2D);


	//regfile (operates in decode and writeback)
	regfile rf(clk,regwriteW,rsD,rtD,writeregW,resultW,srcaD,srcbD);

	//fetch stage logic
	pc #(32) pcreg(clk,rst,~stallF,pcnextF2D,pcF);
	adder pcadd1(pcF,32'b100,pcplus4F);
	//decode stage
	flopenr #(32) r1D(clk,rst,~stallD,pcplus4F,pcplus4D);
	flopenrc #(32) r2D(clk,rst,~stallD,flushD,instrF,instrD);
	signext se(instrD[15:0],signimmD);//������չ
	sl2 immsh(signimmD,signimmshD);
	adder pcadd2(pcplus4D,signimmshD,pcbranchD);
	mux2 #(32) forwardamux(srcaD,aluoutM,forwardaD,srca2D);

	mux2 #(32) forwardbmux(srcbD,aluoutM,forwardbD,srcb2D);
	eqcmp comp(srca2D,srcb2D,equalD);

	assign opD = instrD[31:26];
	assign functD = instrD[5:0];
	assign rsD = instrD[25:21];
	assign rtD = instrD[20:16];
	assign rdD = instrD[15:11];
	assign saD = instrD[10:6];
	//assign instrD1 = instrD;

	//execute stage
	floprc #(32) r1E(clk,rst,flushE,srcaD,srcaE);
	floprc #(32) r2E(clk,rst,flushE,srcbD,srcbE);
	floprc #(32) r3E(clk,rst,flushE,signimmD,signimmE);
	floprc #(5) r4E(clk,rst,flushE,rsD,rsE);
	floprc #(5) r5E(clk,rst,flushE,rtD,rtE);
	floprc #(5) r6E(clk,rst,flushE,rdD,rdE);
	
	
	

	
	floprc #(5) r7E(clk,rst,flushE,saD,saE);
	floprc #(32) r9E(clk,rst,flushE,instrD,instrE);


	flopenrc #(64)  r8E(clk,rst,~stallE,flushE, {hiD,loD},{hiE,loE});
	mux3 #(32) forwardaemux(srcaE,resultW,aluoutM,forwardaE,srca2E);
	mux3 #(32) forwardbemux(srcbE,resultW,aluoutM,forwardbE,srcb2E);


	//hilo forward (MTHI->MFHI)
	mux3 #(32) forwardhimux(hiE,hi_iM,hi_iW,forwardhiloE,hi2E);
	mux3 #(32) forwardlomux(loE,lo_iM,lo_iW,forwardhiloE,lo2E);

	mux2 #(32) srcbmux(srcb2E,signimmE,alusrcE,srcb3E);

	mux2 #(32) jalmux(srca2E,pcplus4D,forwardajalE,srca3E);

	alu alu(srca3E,srcb3E,alucontrolE,saE,hi2E,lo2E,aluoutE,hi_alu_outE,lo_alu_outE,overflow);
	mux2 #(5) wrmux(rtE,rdE,regdstE,writeregE);


	assign selectregwriteE = (alucontrolE == `EXE_JAL_OP)? 1 : 0;
	
	mux2 #(5) wrmuxE2(writeregE,5'b11111,selectregwriteE,writereg2E);
	
	//mux2 #(5) wrmux(writeregE,5'b11111,,writereg2E);

	assign div_signalE = ((alucontrolE == `EXE_DIV_OP)|(alucontrolE == `EXE_DIVU_OP))? 1 : 0;

	divider_Primary div_Primary (clk,rst,alucontrolE,srca2E,srcb3E,1'b0,{hi_div_outE,lo_div_outE},ready_oE,start_iE);
	//mux2 is judge the input of hilo_reg come from alu or divider_Primary
	mux2 #(32) hi_div(hi_alu_outE,hi_div_outE,div_signalE,hi_iE);
	mux2 #(32) lo_div(lo_alu_outE,lo_div_outE,div_signalE,lo_iE);
	//mem stage
	flopr #(32) r1M(clk,rst,srcb2E,writedataM);
	flopr #(32) r2M(clk,rst,aluoutE,aluoutM);
	flopr #(5) r3M(clk,rst,writereg2E,writeregM);


	flopr #(32) r4M(clk,rst,hi_iE,hi_iM);
	flopr #(32) r5M(clk,rst,lo_iE,lo_iM);
	//writeback stage
	flopr #(32) r1W(clk,rst,aluoutM,aluoutW);
	flopr #(32) r2W(clk,rst,readdataM,readdataW);
	flopr #(5) r3W(clk,rst,writeregM,writeregW);
	flopr #(32) r4W(clk,rst,hi_iM,hi_iW);
	flopr #(32) r5W(clk,rst,lo_iM,lo_iW);
	mux2 #(32) resmux(aluoutW,readdataW,memtoregW,resultW);


	hilo_reg  hilo_reg(clk,rst,hregwriteW,hi_iW,lo_iW,hiD,loD);
endmodule
