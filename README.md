# tiny-fpga-bx-74hc595-8x8-dot-matrix-display
Controlling a pair of 74hc595 to control a 8x8 dot matrix display

I built this project using iverilog, apio, yosys, etc toolchain for the tiny fpga BX board
There are some unsupported features in this toolchain, such as multidimensional arrays which is why I had to produce a work around involving a case statement with hardcoded part selections.


Example video:
https://www.instagram.com/p/CLk5Po-A1ci/
