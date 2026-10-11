// 9 bit version of the code,
// must modify the test bench to test for different values too.
`timescale 1ns / 1ps

module pwm_generator_1 #(parameter WIDTH = 9) (
    input wire clk,
    input wire reset_n,
    input wire [WIDTH-1 : 0] duty,
    output wire pwm_out
);

reg [WIDTH-1 : 0] counter;
always@(posedge clk or negedge reset_n) begin
    if (!reset_n)
        counter <= {WIDTH {1'b0}};
    else
        counter <=counter + 1'b1;
end

assign pwm_out = (counter < duty); // boolean.

endmodule