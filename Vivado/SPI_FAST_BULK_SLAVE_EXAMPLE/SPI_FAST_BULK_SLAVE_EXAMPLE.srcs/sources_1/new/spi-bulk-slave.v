module top(
    input  wire clk,                   // 100 MHz on-board clock
    input  wire multi_spi_clk,           
    input  wire multi_spi_cs,          

    output wire multi_spi_miso,            
    output wire led,                   // Just for visual feedback
    
    output wire gnd
);
    
    // ────────────────────────────────────────────────────────────────
    // Tell Vivado **not** to insert a BUFG on the SPI clock pin,
    // otherwise it assumes it is a global clock which is not what we want.
    // ────────────────────────────────────────────────────────────────
    

    reg clk_flop  = 1'b0;   // 10 Hz
    reg miso_flop = 1'b0;   // 5 Hz
    reg cs_flop   = 1'b0;   // 2.5 Hz

    always @(posedge multi_spi_clk) begin
    
        clk_flop <= ~clk_flop;
        
        miso_flop <= ~miso_flop;
                            
        
        if (clk_flop) begin

            /* toggle MISO every *other* CLK change ------------- */
            // miso_flop <= ~miso_flop;
                        
        end            
    end

    assign led = miso_flop;      // Blink LED so we know we are alive

    /* map internal flops to the header pins ------------------- */
    assign multi_spi_miso = miso_flop;  // 5 Hz
    
    assign gnd = 1'b0;              // Force this pin low so we can use it as a ground.
        
endmodule