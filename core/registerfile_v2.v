module registerfile (
    output wire [31:0] Rn_data,
    output wire [31:0] Rm_data,
    output wire [31:0] Rs_data,
    input wire [31:0] Rd_data,
    input wire [31:0] RdHi_data,
    input wire [3:0] Rn,
    input wire [3:0] Rm,
    input wire [3:0] Rs,
    input wire [3:0] Rd,
    input wire [3:0] RdHi,
    input wire [4:0] mode,
    input wire regWrite,
    input wire regHiWrite,
    input wire clk
);

localparam [4:0] USER       = 5'b10000;
localparam [4:0] FIQ        = 5'b10001;
localparam [4:0] IRQ        = 5'b10010;
localparam [4:0] SUPERVISOR = 5'b10011;
localparam [4:0] ABORT      = 5'b10111;
localparam [4:0] UNDEFINED  = 5'b11011;
localparam [4:0] SYSTEM     = 5'b11111;

reg [31:0] RegFileA [30:0]; //16 registers, 32 bits each, PLUS the registers shown below
//reg [31:0] RegFileB [30:0]; //all 16 are seen by SYSTEM and USER

reg [4:0] actual_reg_rn;
reg [4:0] actual_reg_rm;
reg [4:0] actual_reg_rs;
reg [4:0] actual_reg_rd;
reg [4:0] actual_reg_rdhi;

always@(*) begin
    // translate the register "address" according to mode
    case(mode)
        USER : begin
            actual_reg_rn = {1'b0, Rn};
            actual_reg_rm = {1'b0, Rm};
            actual_reg_rs = {1'b0, Rs};
            actual_reg_rd = {1'b0, Rd};
            actual_reg_rdhi = {1'b0, RdHi};
        end
        SYSTEM : begin
            actual_reg_rn = {1'b0, Rn};
            actual_reg_rm = {1'b0, Rm};
            actual_reg_rs = {1'b0, Rs};
            actual_reg_rd = {1'b0, Rd};
            actual_reg_rdhi = {1'b0, RdHi};
        end
        FIQ : begin
            if (Rn[3] == 1'b0 || Rn == 4'b1111)
                actual_reg_rn = {1'b0, Rn};
            else if (Rn == 4'b1000)
                actual_reg_rn = 16;
            else if (Rn == 4'b1001)
                actual_reg_rn = 17;
            else if (Rn == 4'b1010)
                actual_reg_rn = 18;
            else if (Rn == 4'b1011)
                actual_reg_rn = 19;
            else if (Rn == 4'b1100)
                actual_reg_rn = 20;
            else if (Rn == 4'b1101)
                actual_reg_rn = 21;
            else if (Rn == 4'b1110)
                actual_reg_rn = 22;
            else
                actual_reg_rn = 31; //garbage
            if (Rm[3] == 1'b0 || Rm == 4'b1111)
                actual_reg_rm = {1'b0, Rm};
            else if (Rm == 4'b1000)
                actual_reg_rm = 16;
            else if (Rm == 4'b1001)
                actual_reg_rm = 17;
            else if (Rm == 4'b1010)
                actual_reg_rm = 18;
            else if (Rm == 4'b1011)
                actual_reg_rm = 19;
            else if (Rm == 4'b1100)
                actual_reg_rm = 20;
            else if (Rm == 4'b1101)
                actual_reg_rm = 21;
            else if (Rm == 4'b1110)
                actual_reg_rm = 22;
            else
                actual_reg_rm = 31; //garbage
            if (Rs[3] == 1'b0 || Rs == 4'b1111)
                actual_reg_rs = {1'b0, Rs};
            else if (Rs == 4'b1000)
                actual_reg_rs = 16;
            else if (Rs == 4'b1001)
                actual_reg_rs = 17;
            else if (Rs == 4'b1010)
                actual_reg_rs = 18;
            else if (Rs == 4'b1011)
                actual_reg_rs = 19;
            else if (Rs == 4'b1100)
                actual_reg_rs = 20;
            else if (Rs == 4'b1101)
                actual_reg_rs = 21;
            else if (Rs == 4'b1110)
                actual_reg_rs = 22;
            else
                actual_reg_rs = 31; //garbage
            if (Rd[3] == 1'b0 || Rd == 4'b1111)
                actual_reg_rd = {1'b0, Rd};
            else if (Rd == 4'b1000)
                actual_reg_rd = 16;
            else if (Rd == 4'b1001)
                actual_reg_rd = 17;
            else if (Rd == 4'b1010)
                actual_reg_rd = 18;
            else if (Rd == 4'b1011)
                actual_reg_rd = 19;
            else if (Rd == 4'b1100)
                actual_reg_rd = 20;
            else if (Rd == 4'b1101)
                actual_reg_rd = 21;
            else if (Rd == 4'b1110)
                actual_reg_rd = 22;
            else
                actual_reg_rd = 31; //garbage
            if (RdHi[3] == 1'b0 || RdHi == 4'b1111)
                actual_reg_rdhi = {1'b0, RdHi};
            else if (RdHi == 4'b1000)
                actual_reg_rdhi = 16;
            else if (RdHi == 4'b1001)
                actual_reg_rdhi = 17;
            else if (RdHi == 4'b1010)
                actual_reg_rdhi = 18;
            else if (RdHi == 4'b1011)
                actual_reg_rdhi = 19;
            else if (RdHi == 4'b1100)
                actual_reg_rdhi = 20;
            else if (RdHi == 4'b1101)
                actual_reg_rdhi = 21;
            else if (RdHi == 4'b1110)
                actual_reg_rdhi = 22;
            else
                actual_reg_rdhi = 31; //garbage
        end
        IRQ : begin
            if (Rn != 4'b1101 && Rn != 4'b1110)
                actual_reg_rn = {1'b0, Rn};
            else if (Rn == 4'b1101)
                actual_reg_rn = 27;
            else if (Rn == 4'b1110)
                actual_reg_rn = 28;
            else
                actual_reg_rn = 31; //garbage
            if (Rm != 4'b1101 && Rm != 4'b1110)
                actual_reg_rm = {1'b0, Rm};
            else if (Rm == 4'b1101)
                actual_reg_rm = 27;
            else if (Rm == 4'b1110)
                actual_reg_rm = 28;
            else
                actual_reg_rm = 31; //garbage
            if (Rs != 4'b1101 && Rs != 4'b1110)
                actual_reg_rs = {1'b0, Rs};
            else if (Rs == 4'b1101)
                actual_reg_rs = 27;
            else if (Rs == 4'b1110)
                actual_reg_rs = 28;
            else
                actual_reg_rs = 31; //garbage
            if (Rd != 4'b1101 && Rd != 4'b1110)
                actual_reg_rd = {1'b0, Rd};
            else if (Rd == 4'b1101)
                actual_reg_rd = 27;
            else if (Rd == 4'b1110)
                actual_reg_rd = 28;
            else
                actual_reg_rd = 31; //garbage
            if (RdHi != 4'b1101 && RdHi != 4'b1110)
                actual_reg_rdhi = {1'b0, RdHi};
            else if (RdHi == 4'b1101)
                actual_reg_rdhi = 27;
            else if (RdHi == 4'b1110)
                actual_reg_rdhi = 28;
            else
                actual_reg_rdhi = 31; //garbage
        end
        SUPERVISOR : begin
            if (Rn != 4'b1101 && Rn != 4'b1110)
                actual_reg_rn = {1'b0, Rn};
            else if (Rn == 4'b1101)
                actual_reg_rn = 23;
            else if (Rn == 4'b1110)
                actual_reg_rn = 24;
            else
                actual_reg_rn = 31; //garbage
            if (Rm != 4'b1101 && Rm != 4'b1110)
                actual_reg_rm = {1'b0, Rm};
            else if (Rm == 4'b1101)
                actual_reg_rm = 23;
            else if (Rm == 4'b1110)
                actual_reg_rm = 24;
            else
                actual_reg_rm = 31; //garbage
            if (Rs != 4'b1101 && Rs != 4'b1110)
                actual_reg_rs = {1'b0, Rs};
            else if (Rs == 4'b1101)
                actual_reg_rs = 23;
            else if (Rs == 4'b1110)
                actual_reg_rs = 24;
            else
                actual_reg_rs = 31; //garbage
            if (Rd != 4'b1101 && Rd != 4'b1110)
                actual_reg_rd = {1'b0, Rd};
            else if (Rd == 4'b1101)
                actual_reg_rd = 23;
            else if (Rd == 4'b1110)
                actual_reg_rd = 24;
            else
                actual_reg_rd = 31; //garbage
            if (RdHi != 4'b1101 && RdHi != 4'b1110)
                actual_reg_rdhi = {1'b0, RdHi};
            else if (RdHi == 4'b1101)
                actual_reg_rdhi = 23;
            else if (RdHi == 4'b1110)
                actual_reg_rdhi = 24;
            else
                actual_reg_rdhi = 31; //garbage
        end
        ABORT : begin
            if (Rn != 4'b1101 && Rn != 4'b1110)
                actual_reg_rn = {1'b0, Rn};
            else if (Rn == 4'b1101)
                actual_reg_rn = 25;
            else if (Rn == 4'b1110)
                actual_reg_rn = 26;
            else
                actual_reg_rn = 31; //garbage
            if (Rm != 4'b1101 && Rm != 4'b1110)
                actual_reg_rm = {1'b0, Rm};
            else if (Rm == 4'b1101)
                actual_reg_rm = 25;
            else if (Rm == 4'b1110)
                actual_reg_rm = 26;
            else
                actual_reg_rm = 31; //garbage
            if (Rs != 4'b1101 && Rs != 4'b1110)
                actual_reg_rs = {1'b0, Rs};
            else if (Rs == 4'b1101)
                actual_reg_rs = 25;
            else if (Rs == 4'b1110)
                actual_reg_rs = 26;
            else
                actual_reg_rs = 31; //garbage
            if (Rd != 4'b1101 && Rd != 4'b1110)
                actual_reg_rd = {1'b0, Rd};
            else if (Rd == 4'b1101)
                actual_reg_rd = 25;
            else if (Rd == 4'b1110)
                actual_reg_rd = 26;
            else
                actual_reg_rd = 31; //garbage
            if (RdHi != 4'b1101 && RdHi != 4'b1110)
                actual_reg_rdhi = {1'b0, RdHi};
            else if (RdHi == 4'b1101)
                actual_reg_rdhi = 25;
            else if (RdHi == 4'b1110)
                actual_reg_rdhi = 26;
            else
                actual_reg_rdhi = 31; //garbage
        end
        UNDEFINED : begin
            if (Rn != 4'b1101 && Rn != 4'b1110)
                actual_reg_rn = {1'b0, Rn};
            else if (Rn == 4'b1101)
                actual_reg_rn = 29;
            else if (Rn == 4'b1110)
                actual_reg_rn = 30;
            else
                actual_reg_rn = 31; //garbage
            if (Rm != 4'b1101 && Rm != 4'b1110)
                actual_reg_rm = {1'b0, Rm};
            else if (Rm == 4'b1101)
                actual_reg_rm = 29;
            else if (Rm == 4'b1110)
                actual_reg_rm = 30;
            else
                actual_reg_rm = 31; //garbage
            if (Rs != 4'b1101 && Rs != 4'b1110)
                actual_reg_rs = {1'b0, Rs};
            else if (Rs == 4'b1101)
                actual_reg_rs = 29;
            else if (Rs == 4'b1110)
                actual_reg_rs = 30;
            else
                actual_reg_rs = 31; //garbage
            if (Rd != 4'b1101 && Rd != 4'b1110)
                actual_reg_rd = {1'b0, Rd};
            else if (Rd == 4'b1101)
                actual_reg_rd = 29;
            else if (Rd == 4'b1110)
                actual_reg_rd = 30;
            else
                actual_reg_rd = 31; //garbage
            if (RdHi != 4'b1101 && RdHi != 4'b1110)
                actual_reg_rdhi = {1'b0, RdHi};
            else if (RdHi == 4'b1101)
                actual_reg_rdhi = 29;
            else if (RdHi == 4'b1110)
                actual_reg_rdhi = 30;
            else
                actual_reg_rdhi = 31; //garbage
        end
        default : begin
            actual_reg_rn = {1'b0, Rn};
            actual_reg_rm = {1'b0, Rm};
            actual_reg_rs = {1'b0, Rs};
            actual_reg_rd = {1'b0, Rd};
            actual_reg_rdhi = {1'b0, RdHi};
        end
    endcase
end

/*      READ ON POSEDGE     */
//always@(posedge clk) begin
    assign Rn_data = RegFileA[actual_reg_rn];
    assign Rm_data = RegFileA[actual_reg_rm];
    assign Rs_data = RegFileA[actual_reg_rs];
//end


/*     WRITE ON NEGEDGE     */
always@(negedge clk) begin
    if (regWrite) begin //RegFile[Rd] <= Rd_data;
        RegFileA[actual_reg_rd] <= Rd_data;
        //RegFileB[actual_reg_rd] <= Rd_data;
    end
    if (regHiWrite) begin //RegFile[Rd] <= RdHi_data;
        RegFileA[actual_reg_rdhi] <= RdHi_data;
        //RegFileB[actual_reg_rdhi] <= RdHi_data;
    end
end

endmodule
