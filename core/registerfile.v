module registerfile (
    output reg [31:0] Rn_data,
    output reg [31:0] Rm_data,
    output reg [31:0] Rs_data,
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
reg [31:0] RegFileB [30:0]; //all 16 are seen by SYSTEM and USER
//reg [31:0] RegFileC [15:0];

/*
reg [31:0]  r8_fiqA,  r8_fiqB;  //16
reg [31:0]  r9_fiqA,  r9_fiqB;  //17
reg [31:0] r10_fiqA, r10_fiqB;  //18
reg [31:0] r11_fiqA, r11_fiqB;  //19
reg [31:0] r12_fiqA, r12_fiqB;  //20
reg [31:0] r13_fiqA, r13_fiqB;  //21
reg [31:0] r14_fiqA, r14_fiqB;  //22
reg [31:0] r13_svcA, r13_svcB;  //23
reg [31:0] r14_svcA, r14_svcB;  //24
reg [31:0] r13_abtA, r13_abtB;  //25
reg [31:0] r14_abtA, r14_abtB;  //26
reg [31:0] r13_irqA, r13_irqB;  //27
reg [31:0] r14_irqA, r14_irqB;  //28
reg [31:0] r13_undA, r13_undB;  //29
reg [31:0] r14_undA, r14_undB;  //30
*/

/*      READ ON POSEDGE     */
always@(posedge clk) begin
    case (mode)
        USER : begin
            Rn_data <= RegFileA[Rn];
            Rm_data <= RegFileA[Rm];
            Rs_data <= RegFileB[Rs];
        end
        SYSTEM : begin
            Rn_data <= RegFileA[Rn];
            Rm_data <= RegFileA[Rm];
            Rs_data <= RegFileB[Rs];
        end
        FIQ : begin
            if(Rn[3] == 1'b0 || Rn == 4'b1111)
                Rn_data <= RegFileA[Rn];
            else if (Rn == 4'b1000)
                Rn_data <= RegFileA[16];
            else if (Rn == 4'b1001)
                Rn_data <= RegFileA[17];
            else if (Rn == 4'b1010)
                Rn_data <= RegFileA[18];
            else if (Rn == 4'b1011)
                Rn_data <= RegFileA[19];
            else if (Rn == 4'b1100)
                Rn_data <= RegFileA[20];
            else if (Rn == 4'b1101)
                Rn_data <= RegFileA[21];
            else if (Rn == 4'b1110)
                Rn_data <= RegFileA[22];
            
            if(Rm[3] == 1'b0 || Rm == 4'b1111)
                Rm_data <= RegFileA[Rm];
            else if (Rm == 4'b1000)
                Rm_data <= RegFileA[16];
            else if (Rm == 4'b1001)
                Rm_data <= RegFileA[17];
            else if (Rm == 4'b1010)
                Rm_data <= RegFileA[18];
            else if (Rm == 4'b1011)
                Rm_data <= RegFileA[19];
            else if (Rm == 4'b1100)
                Rm_data <= RegFileA[20];
            else if (Rm == 4'b1101)
                Rm_data <= RegFileA[21];
            else if (Rm == 4'b1110)
                Rm_data <= RegFileA[22];
            
            if(Rs[3] == 1'b0 || Rs == 4'b1111)
                Rs_data <= RegFileB[Rs];
            else if (Rs == 4'b1000)
                Rs_data <= RegFileB[16];
            else if (Rs == 4'b1001)
                Rs_data <= RegFileB[17];
            else if (Rs == 4'b1010)
                Rs_data <= RegFileB[18];
            else if (Rs == 4'b1011)
                Rs_data <= RegFileB[19];
            else if (Rs == 4'b1100)
                Rs_data <= RegFileB[20];
            else if (Rs == 4'b1101)
                Rs_data <= RegFileB[21];
            else if (Rs == 4'b1110)
                Rs_data <= RegFileB[22];
        end
        IRQ : begin
            if(Rn != 4'b1101 && Rn != 4'b1110)
                Rn_data <= RegFileA[Rn];
            else if (Rn == 4'b1101)
                Rn_data <= RegFileA[27];
            else if (Rn == 4'b1110)
                Rn_data <= RegFileA[28];
            
            if(Rm != 4'b1101 && Rm != 4'b1110)
                Rm_data <= RegFileA[Rm];
            else if (Rm == 4'b1101)
                Rm_data <= RegFileA[27];
            else if (Rm == 4'b1110)
                Rm_data <= RegFileA[28];
            
            if(Rs != 4'b1101 && Rs != 4'b1110)
                Rs_data <= RegFileB[Rs];
            else if (Rs == 4'b1101)
                Rs_data <= RegFileB[27];
            else if (Rs == 4'b1110)
                Rs_data <= RegFileB[28];
        end
        SUPERVISOR : begin
            if(Rn != 4'b1101 && Rn != 4'b1110)
                Rn_data <= RegFileA[Rn];
            else if (Rn == 4'b1101)
                Rn_data <= RegFileA[23];
            else if (Rn == 4'b1110)
                Rn_data <= RegFileA[24];
            
            if(Rm != 4'b1101 && Rm != 4'b1110)
                Rm_data <= RegFileA[Rm];
            else if (Rm == 4'b1101)
                Rm_data <= RegFileA[23];
            else if (Rm == 4'b1110)
                Rm_data <= RegFileA[24];
            
            if(Rs != 4'b1101 && Rs != 4'b1110)
                Rs_data <= RegFileB[Rs];
            else if (Rs == 4'b1101)
                Rs_data <= RegFileB[23];
            else if (Rs == 4'b1110)
                Rs_data <= RegFileB[24];
        end
        ABORT : begin
            if(Rn != 4'b1101 && Rn != 4'b1110)
                Rn_data <= RegFileA[Rn];
            else if (Rn == 4'b1101)
                Rn_data <= RegFileA[25];
            else if (Rn == 4'b1110)
                Rn_data <= RegFileA[26];
            
            if(Rm != 4'b1101 && Rm != 4'b1110)
                Rm_data <= RegFileA[Rm];
            else if (Rm == 4'b1101)
                Rm_data <= RegFileA[25];
            else if (Rm == 4'b1110)
                Rm_data <= RegFileA[26];
            
            if(Rs != 4'b1101 && Rs != 4'b1110)
                Rs_data <= RegFileB[Rs];
            else if (Rs == 4'b1101)
                Rs_data <= RegFileB[25];
            else if (Rs == 4'b1110)
                Rs_data <= RegFileB[26];
        end
        UNDEFINED : begin
            if(Rn != 4'b1101 && Rn != 4'b1110)
                Rn_data <= RegFileA[Rn];
            else if (Rn == 4'b1101)
                Rn_data <= RegFileA[29];
            else if (Rn == 4'b1110)
                Rn_data <= RegFileA[30];
            
            if(Rm != 4'b1101 && Rm != 4'b1110)
                Rm_data <= RegFileA[Rm];
            else if (Rm == 4'b1101)
                Rm_data <= RegFileA[29];
            else if (Rm == 4'b1110)
                Rm_data <= RegFileA[30];
            
            if(Rs != 4'b1101 && Rs != 4'b1110)
                Rs_data <= RegFileB[Rs];
            else if (Rs == 4'b1101)
                Rs_data <= RegFileB[29];
            else if (Rs == 4'b1110)
                Rs_data <= RegFileB[30];
        end
    endcase
end


/*     WRITE ON NEGEDGE     */
always@(negedge clk) begin
    if (regWrite) begin //RegFile[Rd] <= Rd_data;
        case (mode)
            USER : begin
                RegFileA[Rd] <= Rd_data;
                RegFileB[Rd] <= Rd_data;
                //RegFileC[Rd] <= Rd_data;
            end
            SYSTEM : begin
                RegFileA[Rd] <= Rd_data;
                RegFileB[Rd] <= Rd_data;
                //RegFileC[Rd] <= Rd_data;
            end
            FIQ : begin
                if(Rd[3] == 1'b0 || Rd == 4'b1111) begin
                RegFileA[Rd] <= Rd_data;
                RegFileB[Rd] <= Rd_data;
                //RegFileC[Rd] <= Rd_data;
                end
                else if (Rd == 4'b1000) begin
                    RegFileA[16] <= Rd_data;
                    RegFileB[16] <= Rd_data;
                end
                else if (Rd == 4'b1001) begin
                    RegFileA[17] <= Rd_data;
                    RegFileB[17] <= Rd_data;
                end
                else if (Rd == 4'b1010) begin
                    RegFileA[18] <= Rd_data;
                    RegFileB[18] <= Rd_data;
                end
                else if (Rd == 4'b1011) begin
                    RegFileA[19] <= Rd_data;
                    RegFileB[19] <= Rd_data;
                end
                else if (Rd == 4'b1100) begin
                    RegFileA[20] <= Rd_data;
                    RegFileB[20] <= Rd_data;
                end
                else if (Rd == 4'b1101) begin
                    RegFileA[21] <= Rd_data;
                    RegFileB[21] <= Rd_data;
                end
                else if (Rd == 4'b1110) begin
                    RegFileA[22] <= Rd_data;
                    RegFileB[22] <= Rd_data;
                end 
            end
            IRQ : begin
                if(Rd != 4'b1101 && Rd != 4'b1110) begin
                    RegFileA[Rd] <= Rd_data;
                    RegFileB[Rd] <= Rd_data;
                    //RegFileC[Rd] <= Rd_data;
                    end
                    else if (Rd == 4'b1101) begin
                        RegFileA[27] <= Rd_data;
                        RegFileB[27] <= Rd_data;
                    end
                    else if (Rd == 4'b1110) begin
                        RegFileA[28] <= Rd_data;
                        RegFileB[28] <= Rd_data;
                    end
            end
            SUPERVISOR : begin
                if(Rd != 4'b1101 && Rd != 4'b1110) begin
                    RegFileA[Rd] <= Rd_data;
                    RegFileB[Rd] <= Rd_data;
                    //RegFileC[Rd] <= Rd_data;
                    end
                    else if (Rd == 4'b1101) begin
                        RegFileA[23] <= Rd_data;
                        RegFileB[23] <= Rd_data;
                    end
                    else if (Rd == 4'b1110) begin
                        RegFileA[24] <= Rd_data;
                        RegFileB[24] <= Rd_data;
                    end
            end
            ABORT : begin
                if(Rd != 4'b1101 && Rd != 4'b1110) begin
                    RegFileA[Rd] <= Rd_data;
                    RegFileB[Rd] <= Rd_data;
                    //RegFileC[Rd] <= Rd_data;
                    end
                    else if (Rd == 4'b1101) begin
                        RegFileA[25] <= Rd_data;
                        RegFileB[25] <= Rd_data;
                    end
                    else if (Rd == 4'b1110) begin
                        RegFileA[26] <= Rd_data;
                        RegFileB[26] <= Rd_data;
                    end
            end
            UNDEFINED : begin
                if(Rd != 4'b1101 && Rd != 4'b1110) begin
                    RegFileA[Rd] <= Rd_data;
                    RegFileB[Rd] <= Rd_data;
                    //RegFileC[Rd] <= Rd_data;
                    end
                    else if (Rd == 4'b1101) begin
                        RegFileA[29] <= Rd_data;
                        RegFileB[29] <= Rd_data;
                    end
                    else if (Rd == 4'b1110) begin
                        RegFileA[30] <= Rd_data;
                        RegFileB[30] <= Rd_data;
                    end
            end
        endcase
    end
end

always@(negedge clk) begin
    if (regHiWrite) begin //RegFile[Rd] <= RdHi_data;
        case (mode)
            USER : begin
                RegFileA[RdHi] <= RdHi_data;
                RegFileB[RdHi] <= RdHi_data;
                //RegFileC[RdHi] <= RdHi_data;
            end
            SYSTEM : begin
                RegFileA[RdHi] <= RdHi_data;
                RegFileB[RdHi] <= RdHi_data;
                //RegFileC[RdHi] <= RdHi_data;
            end
            FIQ : begin
                if(RdHi[3] == 1'b0 || RdHi == 4'b1111) begin
                RegFileA[RdHi] <= RdHi_data;
                RegFileB[RdHi] <= RdHi_data;
                //RegFileC[RdHi] <= RdHi_data;
                end
                else if (RdHi == 4'b1000) begin
                    RegFileA[16] <= RdHi_data;
                    RegFileB[16] <= RdHi_data;
                end
                else if (RdHi == 4'b1001) begin
                    RegFileA[17] <= RdHi_data;
                    RegFileB[17] <= RdHi_data;
                end
                else if (RdHi == 4'b1010) begin
                    RegFileA[18] <= RdHi_data;
                    RegFileB[18] <= RdHi_data;
                end
                else if (RdHi == 4'b1011) begin
                    RegFileA[19] <= RdHi_data;
                    RegFileB[19] <= RdHi_data;
                end
                else if (RdHi == 4'b1100) begin
                    RegFileA[20] <= RdHi_data;
                    RegFileB[20] <= RdHi_data;
                end
                else if (RdHi == 4'b1101) begin
                    RegFileA[21] <= RdHi_data;
                    RegFileB[21] <= RdHi_data;
                end
                else if (RdHi == 4'b1110) begin
                    RegFileA[22] <= RdHi_data;
                    RegFileB[22] <= RdHi_data;
                end 
            end
            IRQ : begin
                if(RdHi != 4'b1101 && RdHi != 4'b1110) begin
                    RegFileA[RdHi] <= RdHi_data;
                    RegFileB[RdHi] <= RdHi_data;
                    //RegFileC[Rd] <= RdHi_data;
                    end
                    else if (RdHi == 4'b1101) begin
                        RegFileA[27] <= RdHi_data;
                        RegFileB[27] <= RdHi_data;
                    end
                    else if (RdHi == 4'b1110) begin
                        RegFileA[28] <= RdHi_data;
                        RegFileB[28] <= RdHi_data;
                    end
            end
            SUPERVISOR : begin
                if(RdHi != 4'b1101 && RdHi != 4'b1110) begin
                    RegFileA[RdHi] <= RdHi_data;
                    RegFileB[RdHi] <= RdHi_data;
                    //RegFileC[RdHi] <= RdHi_data;
                    end
                    else if (RdHi == 4'b1101) begin
                        RegFileA[23] <= RdHi_data;
                        RegFileB[23] <= RdHi_data;
                    end
                    else if (RdHi == 4'b1110) begin
                        RegFileA[24] <= RdHi_data;
                        RegFileB[24] <= RdHi_data;
                    end
            end
            ABORT : begin
                if(RdHi != 4'b1101 && RdHi != 4'b1110) begin
                    RegFileA[RdHi] <= RdHi_data;
                    RegFileB[RdHi] <= RdHi_data;
                    //RegFileC[RdHi] <= RdHi_data;
                    end
                    else if (RdHi == 4'b1101) begin
                        RegFileA[25] <= RdHi_data;
                        RegFileB[25] <= RdHi_data;
                    end
                    else if (RdHi == 4'b1110) begin
                        RegFileA[26] <= RdHi_data;
                        RegFileB[26] <= RdHi_data;
                    end
            end
            UNDEFINED : begin
                if(RdHi != 4'b1101 && RdHi != 4'b1110) begin
                    RegFileA[RdHi] <= RdHi_data;
                    RegFileB[RdHi] <= RdHi_data;
                    //RegFileC[Rd] <= Rd_data;
                    end
                    else if (RdHi == 4'b1101) begin
                        RegFileA[29] <= RdHi_data;
                        RegFileB[29] <= RdHi_data;
                    end
                    else if (RdHi == 4'b1110) begin
                        RegFileA[30] <= RdHi_data;
                        RegFileB[30] <= RdHi_data;
                    end
            end
        endcase
    end
end

endmodule
