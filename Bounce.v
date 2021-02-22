module Ball(
  input wire clk,
  output reg [63:0] data

  );

//ball displacement
reg [2:0] x;
reg [2:0] y;

initial begin
  x = 3;
end

//ball velocity
//negative direction is 0,
//positive direction is 1
reg vx;
reg vy;

reg animation_clk;

//generate a slower clock
reg [26:0] counter;
always @ (posedge clk) begin
    if(counter < 1_000_000) begin
      counter <= counter + 1;
    end else begin
      counter <= 0;
      animation_clk = ~animation_clk;
    end
end

//animation block
always @ (posedge animation_clk) begin

  if(x == 1 && vx == 0) begin
    vx <= 1;
    x <= x + 1;
  end else if(x == 7 && vx == 1) begin
    vx <= 0;
    x <= x - 1;
  end else begin
    if(vx == 1) begin
      x <= x + 1;
    end else begin
      x <= x - 1;
    end
  end

  if(y == 0 && vy == 0) begin
    vy <= 1;
    y <= y + 1;
  end else if(y == 7 && vy == 1) begin
    vy <= 0;
    y = y - 1;
  end else begin
    if(vy == 1) begin
      y <= y + 1;
    end else begin
      y <= y - 1;
    end
  end

end //animation loop


//drawing block
always @ (posedge animation_clk) begin
  data <= (64'd1 << (y * 8 + x)) | (64'd1 << (y * 8 ));
end

endmodule
