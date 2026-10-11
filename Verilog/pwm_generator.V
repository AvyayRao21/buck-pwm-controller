// this program generates a pulse width modulation square wave,
// whose duty cycle is set by an input register,
// this wave is intended to act like the MOSFET in a buck converter

// functioning:
// A counter counts from 0 to (2^WIDTH - 1) and loops over.
// The output is HIGH whenever the counter is below the duty value.
// So over one full counter period of 2^WIDTH clock cycles, the output is high
// for exactly "duty" clock cycles.

// duty percentage = duty / 2^WIDTH

// With WIDTH = 8:  duty = 128  ->  128/(2^8) = 128/256 = 50.0%
//
// Note on range: 
// duty = 0 gives a LOW output (0%), 
// but the maximum duty value (2^WIDTH - 1) gives 255/256 = 99.6%, 
// not 100%.
// a counter-comparator PWM cannot reach exactly 100% duty,
// as a buck converter caps the maximum achievable output voltage.
//
// PWM switching frequency = clock frequency / 2^WIDTH,
// e.g. 100 MHz clock, WIDTH = 8  ->  (100 x 10^6) / 256 = 390.6 kHz
// so the PWM pulses at 390.6 kHZ

// we will require a very small timescale due to the high frequencies we are dealing with.
`timescale 1ns / 1ps

// we will make the pwm adjustable,
// function definition:
module pwm_generator #(
    parameter WIDTH = 8 // modifiable PWM resolution in bits (indicated by #())
)( // fixed inputs:
    input  wire clk, // system clock
    input  wire reset_n, // active-low asynchronous reset
    input  wire [WIDTH-1:0] duty, // duty cycle setpoint, 0 to 2^WIDTH-1
    output wire pwm_out // PWM waveform out
);

    // free running counter,
    // rolls over automatically on overflow because it is exactly WIDTH bits wide:
    reg [WIDTH-1:0] counter;

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            counter <= {WIDTH{1'b0}};    // reset to all zeros
        else
            counter <= counter + 1'b1; // increment
    end

    // output is high for the first "duty" counts of each period:
    assign pwm_out = (counter < duty); // boolean returns HIGH or LOW.

endmodule