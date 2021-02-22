module shift_register_control(
  input sys_clk,
  input wire [63:0] data_in,
  output reg DATA,       //serial in
  output wire OE,        //output enable, active low
  output reg LATCH,      //latch, move data from shift register into output registers
  output wire CLOCK,      //data clock, data shifts in on rising edge
  output wire CLEAR      //clears regsiters, active low, keep high
  );

//enable output
assign OE = 0;

//do not want to clear registers
assign CLEAR = 1;

//data frame being shifted out
reg [15:0] data_out;

//index of bit to be shifted out
reg [5:0] shift_counter;

//pointer to segment of memory to shift out
reg [2:0] pointer;

//stops clock if this is pulled low
reg start_clk;
assign CLOCK = sys_clk & start_clk;

//not every toolchain allows you to synthesize initial blocks
//but this one does!
//I think this is unnecessary since registers default to zero already
initial begin
	shift_counter = 0;
	pointer = 0;
	start_clk = 0;
end

//data to be available on positive edge
always @ (posedge sys_clk) begin
case(pointer)
	3'b000: data_out <= {(8'b0000_0001), ~data_in[7:0]  };
	3'b001: data_out <= {(8'b0000_0010), ~data_in[15:8] };
	3'b010: data_out <= {(8'b0000_0100), ~data_in[23:16]};
	3'b011: data_out <= {(8'b0000_1000), ~data_in[31:24]};
	3'b100: data_out <= {(8'b0001_0000), ~data_in[39:32]};
	3'b101: data_out <= {(8'b0010_0000), ~data_in[47:40]};
	3'b110: data_out <= {(8'b0100_0000), ~data_in[55:48]};
	3'b111: data_out <= {(8'b1000_0000), ~data_in[63:56]};
endcase
end

//change the data line on the negative edge
//so that the data is there for the shift register
//on its rising edge
always @ (negedge sys_clk) begin

//two 8bit shift registers, therefore we need to shift out
//16 bits to them
  if(shift_counter <= 15) begin

    start_clk <= 1;
    shift_counter <= shift_counter + 1;
    DATA <= data_out[shift_counter];
    LATCH = 0;

  end else begin

    shift_counter <= 0;
    LATCH <= 1;
    DATA = 0;
    pointer <= pointer + 1;

  end

end

endmodule
