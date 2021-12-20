
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
    wire [31:0] nextPC;
    wire [31:0] branchTarget;
    wire [31:0] currentInstruction_fetch;
    wire [25:0] bl_offset;
    wire thumbMode;

    //Decode stage
    wire [31:0] currentInstruction_decode;
    wire [31:0] decompressedThumbInstruction;
    wire regDst_decode;
    wire memToReg_decode;
    wire regWrite_decode;
    wire regWriteHi_decode;
    wire memRead_decode;
    wire memWrite_decode;
    wire bx_decode;
    wire bl_decode;
    wire longMul_decode;
    wire I_flag_decode;
    wire S_flag_decode;
    wire A_flag_decode;
    wire U_flag_decode;
    wire B_flag_decode;
    wire P_flag_decode;
    wire W_flag_decode;
    wire L_flag_decode;
    wire H_flag_decode;
    wire Ps_flag_decode;
    wire [1:0] PSRwrite_decode;
    wire PSRread_decode;
    wire [15:0] operand2_decode;
    wire [3:0] rm, rn, rs, rdHi, rdLo;
    wire [3:0] ALUopcode;
    wire block_transfer_decode;
    wire switchtoARM_decode;
    wire switchtoTHUMB_decode;
    wire SWI_decode;
    wire UNDEFINED_decode;

    wire [31:0] rn_data_decode, rm_data_decode, rs_data_decode;

    wire permitted;

    //Execute stage
    wire stall;

  localparam DECODE_PIPE_WIDTH  = 32;  //current_instruction

  localparam EXECUTE_PIPE_WIDTH = 32  //inst_PC
                                +  4  //condition code
                                + 32  //Rm_data
                                + 32  //Rs_data
                                + 32  //Rn_data
                                +  5  //Rd (RdHi)
                                +  5  //RdLo
                                + 12  //intermediate
                                +  4;  //opcode

  //TODO: go back and update this as I learn more

  /*          FETCH STAGE           */
  assign bl_offset = currentInstruction_decode[23:0] << 2;
  assign nextPC = (bx_decode & permitted) ? rn_data_decode :
                  (bl_decode & permitted) ? currentPC + {{6{bl_offset[25]}}, bl_offset} :
                  thumbMode ? currentPC + 2 :
                  currentPC + 4;
  // need mux for stall. if stall, use currentPC. else use nextPC.
  
  /*         DECODE STAGE           */


  /*        EXECUTE STAGE           */



endmodule
