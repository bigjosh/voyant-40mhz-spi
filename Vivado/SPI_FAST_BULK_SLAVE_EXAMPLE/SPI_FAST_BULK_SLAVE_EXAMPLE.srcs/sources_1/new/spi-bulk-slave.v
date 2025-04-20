module top(
    input  wire clk,                   // 100 MHz on-board clock
    output wire led,                    // Just for visual feedback
    output wire multi_spi_clk,         // 10 Hz
    output wire multi_spi_miso,        // 5 Hz
    output wire multi_spi_cs           // 2.5 Hz
);
    /* --------------------------------------------------------- */
    localparam CLK_HZ      = 100_000_000;
    localparam HALF_PERIOD = CLK_HZ / (2*10);   // 5 000 000 cycles
    /* --------------------------------------------------------- */

    reg [$clog2(HALF_PERIOD)-1:0] cnt = 0;
    reg clk_flop  = 1'b0;   // 10 Hz
    reg miso_flop = 1'b0;   // 5 Hz
    reg cs_flop   = 1'b0;   // 2.5 Hz

    always @(posedge clk) begin
        /* divide the 100 MHz input down to 10 Hz --------------- */
        if (cnt == HALF_PERIOD-1) begin
            cnt <= 0;
            clk_flop <= ~clk_flop;                     // 10 Hz square wave

            /* toggle MISO every *other* CLK change ------------- */
            miso_flop <= (clk_flop == 1'b0) ? ~miso_flop : miso_flop;

            /* toggle  CS every *other* MISO change ------------- */
            if (clk_flop == 1'b0 && miso_flop == 1'b0)
                cs_flop <= ~cs_flop;
        end
        else begin
            cnt <= cnt + 1;
        end
    end

    assign led = clk_flop;      // Blink LED so we know we are alive

    /* map internal flops to the header pins ------------------- */
    assign multi_spi_clk  = clk_flop;        // 10 Hz
    assign multi_spi_miso = miso_flop;  // 5 Hz
    assign multi_spi_cs   = cs_flop;    // 2.5 Hz
endmodule