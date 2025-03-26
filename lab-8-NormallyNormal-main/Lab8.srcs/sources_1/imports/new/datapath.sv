`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/28/2025 07:38:00 PM
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


module datapath#(
    parameter Nreg = 32,                      // Number of memory locations
    parameter Dbits = 32                      // Number of bits in data
    )   (
    input wire clk, reset, enable, sgnext, bsel, werf,
    input wire [1:0] pcsel, wdsel, wasel, asel,
    input wire [Dbits-1 : 0] instr,
    input wire RegWrite,
    input wire [4:0] alufn,
    output wire Z,
    output wire [Dbits-1 : 0] mem_addr, mem_writedata, mem_readdata, pc
    );
    
    logic [Dbits-1 : 0] programcounter = 32'h00400000;
    assign pc = programcounter;
    wire [Dbits-1 : 0] pcPlus4 = programcounter + 4;
    
    wire [Dbits-1 : 0] alu_result;
    wire [Dbits-1 : 0] ReadData1, ReadData2;
    wire [$clog2(Nreg)-1 : 0] ReadAddr1, ReadAddr2, WriteAddr;
    wire [Dbits-1 : 0] WriteData;
    
    register_file #(Nreg, Dbits) rf(clk, werf, ReadAddr1, ReadAddr2, WriteAddr, WriteData, ReadData1, ReadData2);
    ALU #(32) alu(aluA, aluB, alu_result, alufn, Z);
    
    wire [15 : 0] Imm = instr[15 : 0];
    wire [4 : 0] shamt = instr[10 : 6];
    wire [4 : 0] Rd = instr[15 : 11];
    wire [4 : 0] Rt = instr[20 : 16];
    wire [4 : 0] Rs = instr[25 : 21];
    wire [25 : 0] J = instr[25 : 0];
    
    assign ReadAddr1 = Rs;
    assign ReadAddr2 = Rt;
    
    wire [Dbits-1 : 0] JT  = ReadData1;
    assign mem_writedata  = ReadData2;
    wire [Dbits-1:0] reg_writedata = (wdsel == 2'b00) ? pcPlus4 :
        (wdsel == 2'b01) ? alu_result :
        mem_readdata;
    assign WriteData = reg_writedata;
    
    assign WriteAddr = (wasel == 2'b00) ? Rd :
        (wasel == 2'b01) ? Rt :
        31;
        
    //SgnExt
    wire [Dbits-1:0] signImm = sgnext ? {{16{Imm[15]}}, Imm} : {16'b0, Imm};
    
    wire [Dbits-1 : 0] aluA, aluB;
    assign aluA = (asel == 2'b00) ? ReadData1 :
        (asel == 2'b01) ? {27'b0, shamt} :
        32'h10;
    assign aluB = (bsel == 2'b00) ? ReadData2 :
        signImm;
        
    assign mem_addr = alu_result;
        
    wire [Dbits-1 : 0] BT = pcPlus4 + (signImm << 2);
    
    wire [Dbits-1 : 0] newPC;
    assign newPC = (pcsel == 2'b00) ? pcPlus4 :
        (pcsel == 2'b01) ? BT :
        (pcsel == 2'b10) ? {programcounter[31:28], J[25:0], 2'b0} :
        JT;
        
    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            programcounter <= 32'h00400000; // Default MARS reset address
        else if (enable)
            programcounter <= newPC;
    end
endmodule
