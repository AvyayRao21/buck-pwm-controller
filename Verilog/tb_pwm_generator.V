//=============================================================================
// tb_pwm_generator.v
//
// Self-checking testbench for pwm_generator.
//
// "Self-checking" means the testbench decides pass/fail on its own instead of
// making a human squint at a waveform. For each duty setting it counts how
// many clock cycles the output was HIGH over exactly one counter period, and
// compares that against what the design promised.
//
// Why sampling for exactly 2^WIDTH clocks is a valid measurement:
//   Over one full counter period the counter visits every value 0..255
//   exactly once. The output is high whenever counter < duty, so the number
//   of HIGH clocks must equal `duty` exactly. Not approximately -- exactly.
//   That makes this a strict check with no tolerance needed.
//=============================================================================

`timescale 1ns / 1ps
`include "pwm_generator.V"

module tb_pwm_generator;

    //-------------------------------------------------------------------------
    // Parameters
    //-------------------------------------------------------------------------
    parameter WIDTH  = 8;
    parameter PERIOD = 1 << WIDTH;       // 2^8 = 256 clocks per PWM period

    //-------------------------------------------------------------------------
    // Signals driving the design under test (DUT)
    //-------------------------------------------------------------------------
    reg              clk   = 1'b0;
    reg              reset_n = 1'b0;
    reg  [WIDTH-1:0] duty  = {WIDTH{1'b0}};
    wire             pwm_out;

    // Bookkeeping
    integer high_count;
    integer i;
    integer errors = 0;
    real    measured_pct;
    real    expected_pct;

    //-------------------------------------------------------------------------
    // Instantiate the design under test
    //-------------------------------------------------------------------------
    pwm_generator #(
        .WIDTH   (WIDTH)
    ) dut (
        .clk     (clk),
        .reset_n   (reset_n),
        .duty    (duty),
        .pwm_out (pwm_out)
    );

    //-------------------------------------------------------------------------
    // Clock: toggle every 5 ns -> 10 ns period -> 100 MHz
    //-------------------------------------------------------------------------
    always #5 clk = ~clk;

    //-------------------------------------------------------------------------
    // Measure the duty cycle for one setting and check it
    //-------------------------------------------------------------------------
    task check_duty(input [WIDTH-1:0] duty_val);
        begin
            duty = duty_val;
            @(posedge clk);              // let the new value take effect

            high_count = 0;
            for (i = 0; i < PERIOD; i = i + 1) begin
                @(posedge clk);
                #1;                      // small delay so signals settle
                if (pwm_out === 1'b1)
                    high_count = high_count + 1;
            end

            measured_pct = 100.0 * high_count / PERIOD;
            expected_pct = 100.0 * duty_val  / PERIOD;

            $display("duty=%3d | expected %6.2f%% | measured %6.2f%% | high clocks = %3d",
                     duty_val, expected_pct, measured_pct, high_count);

            if (high_count != duty_val) begin
                $display("   *** FAIL: expected %0d high clocks, measured %0d",
                         duty_val, high_count);
                errors = errors + 1;
            end
        end
    endtask

    //-------------------------------------------------------------------------
    // Test sequence
    //-------------------------------------------------------------------------
    initial begin
        // Write a waveform file that GTKWave can open
        $dumpfile("pwm.vcd");
        $dumpvars(0, tb_pwm_generator);

        $display("");
        $display("=== pwm_generator testbench, WIDTH = %0d ===", WIDTH);
        $display("");

        // Hold reset for a few clocks, then release
        reset_n = 1'b0;
        repeat (4) @(posedge clk);
        reset_n = 1'b1;
        @(posedge clk);

        // The three settings that map onto the PSpice sweep, plus the corners
        check_duty(8'd0);        //   0.0%  - output should never go high
        check_duty(8'd64);       //  25.0%
        check_duty(8'd128);      //  50.0%
        check_duty(8'd192);      //  75.0%
        check_duty(8'd255);      //  99.6%  - note: NOT 100%

        $display("");
        if (errors == 0)
            $display("RESULT: all checks PASSED");
        else
            $display("RESULT: %0d check(s) FAILED", errors);
        $display("");

        $finish;
    end

endmodule