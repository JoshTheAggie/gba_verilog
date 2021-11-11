
module core (
    //inputs
    //Clocks
    input mclk,
    input nWAIT,
    //Interrupts
    input nIRQ,
    input nFIQ,
    input isync,
    //Bus controls
    input nReset,
    input busEn,
    input bigEnd,
    input nEnin,
    input abe,
    input ape,
    input ale,
    input dbe,
    input tbe,
    //Debug
    input dbgrq,
    input breakpt,
    input extern1,
    input extern0,
    input dbgen,
    //Boundary scan
    input tck,
    input tms,
    input tdi,
    input nTrst,
    //Memory interface
    input [31:0] D,
    input [31:0] DIN,
    input [3:0] bl,
    //Memory management interface
    input abort,
    //Coprocessor interface
    input cpa,
    input cpb,

    //outputs
    //Clocks
    output eclk,
    //Bus controls
    output highz,
    output nEnout,
    output nEnouti,
    output busdis,
    output ecapclk,
    //Debug
    output dbgack,
    output nExec,
    output rangeout0,
    output rangeout1,
    output dbgrqi,
    output commrx,
    output commtx,
    //Boundary scan
    output tdo,
    output [3:0] tapsm,
    output [3:0] ir,
    output nTdoen,
    output tck1,
    output tck2,
    output [3:0] screg,
    //Processor mode
    output [4:0] nM,
    //Processor state
    output tbit,
    //Memory interface
    output [31:0] A,
    output [31:0] DOUT,
    output nMREQ,
    output seq,
    output nRW,
    output [1:0] mas,
    output lock,
    output nTRANS,
    output nOPC,
    output nCPI
);

    //Operation modes
    localparam USER       = 5'b10000;
    localparam FIQ        = 5'b10001;
    localparam IRQ        = 5'b10010;
    localparam SUPERVISOR = 5'b10011;
    localparam ABORT      = 5'b10111;
    localparam UNDEFINED  = 5'b11011;
    localparam SYSTEM     = 5'b11111;

    //Fetch stage
    reg [31:0] currentPC;
    wire [31:0] jumpTarget;
    wire [31:0] currentInstruction_fetch;
    wire [1:0] addrSel;

    //Decode stage
    wire [31:0] currentInstruction_decode;
    wire [31:0] decompressedThumbInstruction;
    wire aluSrc; //unknown if needed
    wire memToReg;
    wire regWrite;
    wire memRead;
    wire memWrite;
    wire branch;
    wire jump;
    wire signExtend; //unknown if needed
    wire jal;
    wire jr;
    wire [3:0] rs, rt, rd;
    wire [5:0] opcode;

    //Execute stage
    reg [31:0] CPSR;

endmodule