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

reg [31:0] RegFileA [15:0]; //7 registers, 32 bits each
reg [31:0] RegFileB [15:0]; //all 16 are seen by SYSTEM and USER
//reg [31:0] RegFileC [15:0];

reg [31:0]  r8_fiqA,  r8_fiqB;
reg [31:0]  r9_fiqA,  r9_fiqB;
reg [31:0] r10_fiqA, r10_fiqB;
reg [31:0] r11_fiqA, r11_fiqB;
reg [31:0] r12_fiqA, r12_fiqB;
reg [31:0] r13_fiqA, r13_fiqB;
reg [31:0] r14_fiqA, r14_fiqB;

reg [31:0] r13_svcA, r13_svcB;
reg [31:0] r14_svcA, r14_svcB;

reg [31:0] r13_abtA, r13_abtB;
reg [31:0] r14_abtA, r14_abtB;

reg [31:0] r13_irqA, r13_irqB;
reg [31:0] r14_irqA, r14_irqB;

reg [31:0] r13_undA, r13_undB;
reg [31:0] r14_undA, r14_undB;


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
                Rn_data <= r8_fiqA;
            else if (Rn == 4'b1001)
                Rn_data <= r9_fiqA;
            else if (Rn == 4'b1010)
                Rn_data <= r10_fiqA;
            else if (Rn == 4'b1011)
                Rn_data <= r11_fiqA;
            else if (Rn == 4'b1100)
                Rn_data <= r12_fiqA;
            else if (Rn == 4'b1101)
                Rn_data <= r13_fiqA;
            else if (Rn == 4'b1110)
                Rn_data <= r14_fiqA;
            
            if(Rm[3] == 1'b0 || Rm == 4'b1111)
                Rm_data <= RegFileA[Rm];
            else if (Rm == 4'b1000)
                Rm_data <= r8_fiqA;
            else if (Rm == 4'b1001)
                Rm_data <= r9_fiqA;
            else if (Rm == 4'b1010)
                Rm_data <= r10_fiqA;
            else if (Rm == 4'b1011)
                Rm_data <= r11_fiqA;
            else if (Rm == 4'b1100)
                Rm_data <= r12_fiqA;
            else if (Rm == 4'b1101)
                Rm_data <= r13_fiqA;
            else if (Rm == 4'b1110)
                Rm_data <= r14_fiqA;
            
            if(Rs[3] == 1'b0 || Rs == 4'b1111)
                Rs_data <= RegFileB[Rs];
            else if (Rs == 4'b1000)
                Rs_data <= r8_fiqB;
            else if (Rs == 4'b1001)
                Rs_data <= r9_fiqB;
            else if (Rs == 4'b1010)
                Rs_data <= r10_fiqB;
            else if (Rs == 4'b1011)
                Rs_data <= r11_fiqB;
            else if (Rs == 4'b1100)
                Rs_data <= r12_fiqB;
            else if (Rs == 4'b1101)
                Rs_data <= r13_fiqB;
            else if (Rs == 4'b1110)
                Rs_data <= r14_fiqB;
        end
        IRQ : begin
            if(Rn != 4'b1101 && Rn != 4'b1110)
                Rn_data <= RegFileA[Rn];
            else if (Rn == 4'b1101)
                Rn_data <= r13_irqA;
            else if (Rn == 4'b1110)
                Rn_data <= r14_irqA;
            
            if(Rm != 4'b1101 && Rm != 4'b1110)
                Rm_data <= RegFileA[Rm];
            else if (Rm == 4'b1101)
                Rm_data <= r13_irqA;
            else if (Rm == 4'b1110)
                Rm_data <= r14_irqA;
            
            if(Rs != 4'b1101 && Rs != 4'b1110)
                Rs_data <= RegFileB[Rs];
            else if (Rs == 4'b1101)
                Rs_data <= r13_irqB;
            else if (Rs == 4'b1110)
                Rs_data <= r14_irqB;
        end
        SUPERVISOR : begin
            if(Rn != 4'b1101 && Rn != 4'b1110)
                Rn_data <= RegFileA[Rn];
            else if (Rn == 4'b1101)
                Rn_data <= r13_svcA;
            else if (Rn == 4'b1110)
                Rn_data <= r14_svcA;
            
            if(Rm != 4'b1101 && Rm != 4'b1110)
                Rm_data <= RegFileA[Rm];
            else if (Rm == 4'b1101)
                Rm_data <= r13_svcA;
            else if (Rm == 4'b1110)
                Rm_data <= r14_svcA;
            
            if(Rs != 4'b1101 && Rs != 4'b1110)
                Rs_data <= RegFileB[Rs];
            else if (Rs == 4'b1101)
                Rs_data <= r13_svcB;
            else if (Rs == 4'b1110)
                Rs_data <= r14_svcB;
        end
        ABORT : begin
            if(Rn != 4'b1101 && Rn != 4'b1110)
                Rn_data <= RegFileA[Rn];
            else if (Rn == 4'b1101)
                Rn_data <= r13_abtA;
            else if (Rn == 4'b1110)
                Rn_data <= r14_abtA;
            
            if(Rm != 4'b1101 && Rm != 4'b1110)
                Rm_data <= RegFileA[Rm];
            else if (Rm == 4'b1101)
                Rm_data <= r13_abtA;
            else if (Rm == 4'b1110)
                Rm_data <= r14_abtA;
            
            if(Rs != 4'b1101 && Rs != 4'b1110)
                Rs_data <= RegFileB[Rs];
            else if (Rs == 4'b1101)
                Rs_data <= r13_abtB;
            else if (Rs == 4'b1110)
                Rs_data <= r14_abtB;
        end
        UNDEFINED : begin
            if(Rn != 4'b1101 && Rn != 4'b1110)
                Rn_data <= RegFileA[Rn];
            else if (Rn == 4'b1101)
                Rn_data <= r13_undA;
            else if (Rn == 4'b1110)
                Rn_data <= r14_undA;
            
            if(Rm != 4'b1101 && Rm != 4'b1110)
                Rm_data <= RegFileA[Rm];
            else if (Rm == 4'b1101)
                Rm_data <= r13_undA;
            else if (Rm == 4'b1110)
                Rm_data <= r14_undA;
            
            if(Rs != 4'b1101 && Rs != 4'b1110)
                Rs_data <= RegFileB[Rs];
            else if (Rs == 4'b1101)
                Rs_data <= r13_undB;
            else if (Rs == 4'b1110)
                Rs_data <= r14_undB;
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
                    r8_fiqA <= Rd_data;
                    r8_fiqB <= Rd_data;
                end
                else if (Rd == 4'b1001) begin
                    r9_fiqA <= Rd_data;
                    r9_fiqB <= Rd_data;
                end
                else if (Rd == 4'b1010) begin
                    r10_fiqA <= Rd_data;
                    r10_fiqB <= Rd_data;
                end
                else if (Rd == 4'b1011) begin
                    r11_fiqA <= Rd_data;
                    r11_fiqB <= Rd_data;
                end
                else if (Rd == 4'b1100) begin
                    r12_fiqA <= Rd_data;
                    r12_fiqB <= Rd_data;
                end
                else if (Rd == 4'b1101) begin
                    r13_fiqA <= Rd_data;
                    r13_fiqB <= Rd_data;
                end
                else if (Rd == 4'b1110) begin
                    r14_fiqA <= Rd_data;
                    r14_fiqB <= Rd_data;
                end 
            end
            IRQ : begin
                if(Rd != 4'b1101 && Rd != 4'b1110) begin
                    RegFileA[Rd] <= Rd_data;
                    RegFileB[Rd] <= Rd_data;
                    //RegFileC[Rd] <= Rd_data;
                    end
                    else if (Rd == 4'b1101) begin
                        r13_irqA <= Rd_data;
                        r13_irqB <= Rd_data;
                    end
                    else if (Rd == 4'b1110) begin
                        r14_irqA <= Rd_data;
                        r14_irqB <= Rd_data;
                    end
            end
            SUPERVISOR : begin
                if(Rd != 4'b1101 && Rd != 4'b1110) begin
                    RegFileA[Rd] <= Rd_data;
                    RegFileB[Rd] <= Rd_data;
                    //RegFileC[Rd] <= Rd_data;
                    end
                    else if (Rd == 4'b1101) begin
                        r13_svcA <= Rd_data;
                        r13_svcB <= Rd_data;
                    end
                    else if (Rd == 4'b1110) begin
                        r14_svcA <= Rd_data;
                        r14_svcB <= Rd_data;
                    end
            end
            ABORT : begin
                if(Rd != 4'b1101 && Rd != 4'b1110) begin
                    RegFileA[Rd] <= Rd_data;
                    RegFileB[Rd] <= Rd_data;
                    //RegFileC[Rd] <= Rd_data;
                    end
                    else if (Rd == 4'b1101) begin
                        r13_abtA <= Rd_data;
                        r13_abtB <= Rd_data;
                    end
                    else if (Rd == 4'b1110) begin
                        r14_abtA <= Rd_data;
                        r14_abtB <= Rd_data;
                    end
            end
            UNDEFINED : begin
                if(Rd != 4'b1101 && Rd != 4'b1110) begin
                    RegFileA[Rd] <= Rd_data;
                    RegFileB[Rd] <= Rd_data;
                    //RegFileC[Rd] <= Rd_data;
                    end
                    else if (Rd == 4'b1101) begin
                        r13_undA <= Rd_data;
                        r13_undB <= Rd_data;
                    end
                    else if (Rd == 4'b1110) begin
                        r14_undA <= Rd_data;
                        r14_undB <= Rd_data;
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
                    r8_fiqA <= RdHi_data;
                    r8_fiqB <= RdHi_data;
                end
                else if (RdHi == 4'b1001) begin
                    r9_fiqA <= RdHi_data;
                    r9_fiqB <= RdHi_data;
                end
                else if (RdHi == 4'b1010) begin
                    r10_fiqA <= RdHi_data;
                    r10_fiqB <= RdHi_data;
                end
                else if (RdHi == 4'b1011) begin
                    r11_fiqA <= RdHi_data;
                    r11_fiqB <= RdHi_data;
                end
                else if (RdHi == 4'b1100) begin
                    r12_fiqA <= RdHi_data;
                    r12_fiqB <= RdHi_data;
                end
                else if (RdHi == 4'b1101) begin
                    r13_fiqA <= RdHi_data;
                    r13_fiqB <= RdHi_data;
                end
                else if (RdHi == 4'b1110) begin
                    r14_fiqA <= RdHi_data;
                    r14_fiqB <= RdHi_data;
                end 
            end
            IRQ : begin
                if(RdHi != 4'b1101 && RdHi != 4'b1110) begin
                    RegFileA[RdHi] <= RdHi_data;
                    RegFileB[RdHi] <= RdHi_data;
                    //RegFileC[Rd] <= RdHi_data;
                    end
                    else if (RdHi == 4'b1101) begin
                        r13_irqA <= RdHi_data;
                        r13_irqB <= RdHi_data;
                    end
                    else if (RdHi == 4'b1110) begin
                        r14_irqA <= RdHi_data;
                        r14_irqB <= RdHi_data;
                    end
            end
            SUPERVISOR : begin
                if(RdHi != 4'b1101 && RdHi != 4'b1110) begin
                    RegFileA[RdHi] <= RdHi_data;
                    RegFileB[RdHi] <= RdHi_data;
                    //RegFileC[RdHi] <= RdHi_data;
                    end
                    else if (RdHi == 4'b1101) begin
                        r13_svcA <= RdHi_data;
                        r13_svcB <= RdHi_data;
                    end
                    else if (RdHi == 4'b1110) begin
                        r14_svcA <= RdHi_data;
                        r14_svcB <= RdHi_data;
                    end
            end
            ABORT : begin
                if(RdHi != 4'b1101 && RdHi != 4'b1110) begin
                    RegFileA[RdHi] <= RdHi_data;
                    RegFileB[RdHi] <= RdHi_data;
                    //RegFileC[RdHi] <= RdHi_data;
                    end
                    else if (RdHi == 4'b1101) begin
                        r13_abtA <= RdHi_data;
                        r13_abtB <= RdHi_data;
                    end
                    else if (RdHi == 4'b1110) begin
                        r14_abtA <= RdHi_data;
                        r14_abtB <= RdHi_data;
                    end
            end
            UNDEFINED : begin
                if(RdHi != 4'b1101 && RdHi != 4'b1110) begin
                    RegFileA[RdHi] <= RdHi_data;
                    RegFileB[RdHi] <= RdHi_data;
                    //RegFileC[Rd] <= Rd_data;
                    end
                    else if (RdHi == 4'b1101) begin
                        r13_undA <= RdHi_data;
                        r13_undB <= RdHi_data;
                    end
                    else if (RdHi == 4'b1110) begin
                        r14_undA <= RdHi_data;
                        r14_undB <= RdHi_data;
                    end
            end
        endcase
    end
end

endmodule
