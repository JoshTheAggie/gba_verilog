module registerfile (
    output [31:0] Rn_data,
    output [31:0] Rm_data,
    output [31:0] Rs_data,
    input [31:0] busW,
    input [3:0] Rn,
    input [3:0] Rm,
    input [3:0] Rs,
    input [3:0] Rd,
    input regWrite,
    input clk
);
    

reg [31:0] regFile [15:0]; //7 registers, 32 bits each

reg [31:0] r8_fiq;
reg [31:0] r9_fiq;
reg [31:0] r10_fiq;
reg [31:0] r11_fiq;
reg [31:0] r12_fiq;
reg [31:0] r13_fiq;
reg [31:0] r14_fiq;

reg [31:0] r13_svc;
reg [31:0] r14_svc;

reg [31:0] r13_abt;
reg [31:0] r14_abt;

reg [31:0] r13_irq;
reg [31:0] r14_irq;

reg [31:0] r13_und;
reg [31:0] r14_und;

assign busA = RegFile[RA];
assign busB = RegFile[RB];

always@(negedge clk) begin
    if (regWrite) RegFile[RW] = busW;
end

endmodule