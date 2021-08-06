
module condition (
    input [3:0] cond,
    input [31:0] cpsr,
    output permitted
);

    //condition codes
    localparam EQ = 4'b0000;
    localparam NE = 4'b0001;
    localparam CS = 4'b0010;
    localparam CC = 4'b0011;
    localparam MI = 4'b0100;
    localparam PL = 4'b0101;
    localparam VS = 4'b0110;
    localparam VC = 4'b0111;
    localparam HI = 4'b1000;
    localparam LS = 4'b1001;
    localparam GE = 4'b1010;
    localparam LT = 4'b1011;
    localparam GT = 4'b1100;
    localparam LE = 4'b1101;
    localparam AL = 4'b1110;
    
    //CPSR condition flags
    wire N, Z, C, V;
    assign N = cpsr[31];
    assign Z = cpsr[30];
    assign C = cpsr[29];
    assign V = cpsr[28];

    assign permitted = (cond == AL) |
                       ((cond == EQ) & Z) |
                       ((cond == NE) & ~Z) |
                       ((cond == CS) & C) |
                       ((cond == CC) & ~C) |
                       ((cond == MI) & N) |
                       ((cond == PL) & ~N) |
                       ((cond == VS) & V) |
                       ((cond == VC) & ~V) |
                       ((cond == HI) & C & ~Z) |
                       ((cond == LS) & ~C & Z) |
                       ((cond == GE) & (N == V)) |
                       ((cond == LT) & (N != V)) |
                       ((cond == GT) & (~Z & (N == V))) |
                       ((cond == LE) & (Z | (N != V)));

endmodule