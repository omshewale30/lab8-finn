`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/24/2025 05:35:50 PM
// Design Name: 
// Module Name: logical
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
`default_nettype none

module logical #(parameter N=32) (
    input wire [N-1:0] A, B,
    input wire [1:0] op,
    output wire [N-1:0] R
    );
    
    assign R = (op == 2'b00) ? A & B : 
               (op == 2'b01) ? A | B : 
               (op == 2'b10) ? A ^ B : 
               (op == 2'b11) ? ~(A | B) : 'x;
endmodule
