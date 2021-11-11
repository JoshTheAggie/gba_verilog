module pipeline_register #(
  parameter PIPE_WIDTH = 32
) (
  input  clock,
  input  reset,
  input  flush,
  input  [PIPE_WIDTH-1:0] pipe_input,
  input  [PIPE_WIDTH-1:0] flush_input,
  output [PIPE_WIDTH-1:0] pipe_output
);
reg [PIPE_WIDTH-1:0] pipe_reg;

always@(negedge clock) begin
  if(reset)
    pipe_reg <= {PIPE_WIDTH{1'b0}};
  else if (flush)
    pipe_reg <= flush_input;
  else
    pipe_reg <= pipe_input;
end

assign pipe_output = pipe_reg;

endmodule
