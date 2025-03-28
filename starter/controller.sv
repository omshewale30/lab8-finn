`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//
// Montek Singh
// 3/3/2025
//
//////////////////////////////////////////////////////////////////////////////////

`default_nettype none

// These are non-R-type.
// OPCODES defined here:

`define LW     6'b 100011
`define SW     6'b 101011

`define ADDI   6'b 001000
`define ADDIU  6'b 001001     // NOTE:  addiu *does* sign-extend the imm
`define SLTI   6'b 001010
`define SLTIU  6'b 001011
`define ORI    6'b 001101
`define LUI    6'b 001111
`define ANDI   6'b 001100
`define XORI   6'b 001110

`define BEQ    6'b 000100
`define BNE    6'b 000101
`define J      6'b 000010
`define JAL    6'b 000011


// These are all R-type, i.e., OPCODE=0.
// FUNC field defined here:

`define ADD    6'b 100000
`define ADDU   6'b 100001
`define SUB    6'b 100010
`define AND    6'b 100100
`define OR     6'b 100101
`define XOR    6'b 100110
`define NOR    6'b 100111
`define SLT    6'b 101010
`define SLTU   6'b 101011
`define SLL    6'b 000000
`define SLLV   6'b 000100
`define SRL    6'b 000010
`define SRLV   6'b 000110
`define SRA    6'b 000011
`define SRAV   6'b 000111
`define JR     6'b 001000
`define JALR   6'b 001001


module controller(

// DO NOT CHANGE inputs and outputs

   input  wire enable,
   input  wire [5:0] op, 
   input  wire [5:0] func,
   input  wire Z,
   output wire [1:0] pcsel,
   output wire [1:0] wasel, 
   output wire sgnext,
   output wire bsel,
   output wire [1:0] wdsel, 
   output logic [4:0] alufn,      // will become wire because updated in always_comb
   output wire wr,
   output wire werf, 
   output wire [1:0] asel
   ); 

// CHANGE below by filling in the missing pieces


  assign pcsel = ((op == 6'b0) & (func == `JR)) ? 2'b11   // controls 4-way multiplexer
               : ...
               : ...                                      // for beq/bne check Z flag!
               : ...

  logic [9:0] controls;                // will become wires because of always_comb
  wire _werf_, _wr_;                   // need to be ANDed with enable (to freeze processor)
  assign werf = _werf_ & enable;       // turn off register writes when processor is disabled
  assign wr = _wr_ & enable;           // turn off memory writes when processor is disabled
 
  assign {_werf_, wdsel[1:0], wasel[1:0], asel[1:0], bsel, sgnext, _wr_} = controls[9:0];

  always_comb
     case(op)                                     // non-R-type instructions
        `LW: controls <= 10'b 1_10_01_00_1_1_0;     // LW
        `SW: controls <= ...                        // SW
      `ADDI,                                        // ADDI
     `ADDIU,                                        // ADDIU
      `SLTI: controls <= 10'b 1_01_01_00_1_1_0;     // SLTI
       `ORI: controls <= ...                        // ORI
       ... // add remaining non-R-type instructions here
      6'b000000:                                    
         case(func)                              // R-type
             `ADD,
            `ADDU: controls <= 10'b 1_01_00_00_0_x_0; // ADD and ADDU
             `SUB: controls <= 10'b 1_01_00_00_0_x_0; // SUB
             ... // add remaining R-type instructions here
            default:   controls <= 10'b 0_xx_xx_xx_x_x_0; // unknown instruction, turn off register and memory writes
         endcase
      default: controls <= 10'b 0_xx_xx_xx_x_x_0;         // unknown instruction, turn off register and memory writes
    endcase
    

  always_comb
    case(op)                        // non-R-type instructions
        `LW,                          // LW
        `SW,                          // SW
      `ADDI,                          // ADDI
     `ADDIU: alufn <= 5'b 0xx01;      // ADDIU
      `SLTI: alufn <= 5'b 1x011;      // SLTI
       `BEQ,                          // BEQ
       `BNE: alufn <= ...             // BNE
       ... // add remaining non-R-type instructions here
      6'b000000:                      
         case(func)                 // R-type
             `ADD:
            `ADDU: alufn <= 5'b 0xx01; // ADD and ADDU
             `SUB: alufn <= 5'b 1xx01; // SUB
             ... // add remaining R-type instructions here
            default:   alufn <= 5'b xxxxx; // unknown func
         endcase
      default: alufn <= 5'b xxxxx;         // for all other instructions, alufn is a don't-care.
    endcase
    
endmodule
