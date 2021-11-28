module shifter(
    input wire [31:0] operand,
    input wire I_flag,
    input wire [7:0] shift_amount,
    input wire [1:0] shift_type,
    input wire [3:0] rotation_amt,
    input wire [7:0] immediate,
    input wire carry_in,
    output wire [31:0] shifter_out,
    output wire carryout
);
// I_flag
// 0 = operand 2 is a register
//   11:4 is shift
//    3:0 is Rm number
// 1 = operand 2 is an immediate
//   11:8 is rotate
//    7:0 is 8-bit unsigned immediate value
localparam [1:0] LL = 2'b00;
localparam [1:0] LR = 2'b01;
localparam [1:0] AR = 2'b10;
localparam [1:0] RR = 2'b11;

reg [31:0] shifted, rotated;
reg shift_carry, carry_temp;
reg [7:0] shamt_temp;

always@(*) begin
    case(shift_type)
        LL : begin
            shamt_temp = 0;
            {carry_temp, shifted} = {1'b0, operand} << shift_amount;
            shift_carry = (shift_amount == 0) ? carry_in : carry_temp;
        end
        LR : begin
            shamt_temp = (shift_amount == 8'b0) ? 8'b00100000 : shift_amount;
            {shifted, shift_carry} = {operand, 1'b0} >> shamt_temp;
            carry_temp = 0;
        end
        AR : begin
            shamt_temp = (shift_amount == 8'b0) ? 8'b00100000 : shift_amount;
            {shifted, shift_carry} = {operand, 1'b0} >>> shamt_temp;
            carry_temp = 0;
        end
        RR : begin
            shamt_temp = 0;
            if (shift_amount == 8'b0)
                {carry_temp, shifted} = {carry_in, operand, carry_in, operand} >> shift_amount;
            else
                shifted = {operand, operand} >> shift_amount;
            shift_carry = shifted[31];
        end
    endcase
end

always@(*) begin
    rotated = {24'b0, immediate, 24'b0, immediate} >> (rotation_amt >> 1);
end

assign shifter_out = I_flag ? rotated : shifted;
assign carryout    = I_flag ?    1'b0 : shift_carry;

endmodule