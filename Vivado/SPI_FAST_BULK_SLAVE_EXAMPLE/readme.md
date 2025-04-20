This is the constraints and Verilog code to be a stand-in for the Lidar hardware. It generates test data rather than voxels, but it should be easy to plug this into the Lidar peak FIFO. 

It uses 3 pins on the FPGA that are connected to corresponding pins on the iMX8P...

| Signal | Direction |
| - | - |
| `CLK` | FPGA <- MCU  | 
| `MISO` | FPGA -> MCU |
| `CS` | FPGA <- MCU |

IMPORTANT NOTE: The `CLK` pin is currently different than the one used on the Voyant board. This is because the Voyant board uses a pin that is not available on the FPGA test board. You must change the pin assignment in the constraints file before running this code on a Voyant board!



