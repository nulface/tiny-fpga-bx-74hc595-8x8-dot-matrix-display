module top (
    input CLK,        // 16MHz clock
    output LED,       // User/boot LED next to power LED
    output USBPU,     // USB pull-up resistor
    output PIN_18,    //SER
    output PIN_17,    //OE
    output PIN_19,    //RCLK
    output PIN_20,    //SRCLK
    output PIN_15     //SRCLR
);
    assign USBPU = 0; // drive USB pull-up resistor to '0' to disable USB
/*
srclr "clear"
  active low
  pull low to clear registers
  keep it high
srclk "clock"
  data shifts in on the rising edge of clk
rclk "latch"
  take data from storage register and shifts to output
OE "blank"
  to enable output, this pin must be pulled low
  keep low so that the register outputs
ser "data in"
  serial input

special thanks to Kevin Darrah for his video explaining shift registers
Here is his channel address:
https://www.youtube.com/channel/UC42d7zFnWU0dYVk_M0JED6w
*/

//this is the current data frame
reg [63:0] data;


reg [2:0] address;
reg [26:0] counter;
always @ (posedge CLK) begin

if(counter < 25_000_000) begin
  counter <= counter + 1;
end else begin
  counter <= 0;
      if(address < 5)begin
        address <= address + 1;
      end else begin
        address <= 0;
      end
end

//to better understand these values please view my repo
//https://github.com/nulface/targa-font-to-binary
case(address)
3'b000: data <= 64'd20345674416015432; //H
3'b001: data <= 64'd15833244201140280; //E
3'b010: data <= 64'd18085043209519160; //L
3'b011: data <= 64'd18085043209519160; //L
3'b100: data <= 64'd13590274169653296; //O
3'b101: data <= 64'd18085043205324800; //!
endcase

end


shift_register_control SRC(
  .sys_clk(CLK),
  .data_in(data),
  .DATA(PIN_18),
  .OE(PIN_17),
  .LATCH(PIN_19),
  .CLOCK(PIN_20),
  .CLEAR(PIN_15)
  );

endmodule
