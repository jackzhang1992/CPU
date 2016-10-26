module uart_tx (clk16x,clrn,wrn,d_in,t_empty,txd,cnt16x,
			no_bits_sent,t_buffer,t_clk1x,sending,d_buffer);
	input clk16x,clrn;
	input wrn;
	output reg txd;
	output reg t_empty;
	input [7:0]d_in;
	input [3:0] cnt16x;
	
	output [3:0] no_bits_sent;
	output [7:0] t_buffer;
	output clk1x;
	output sending;
	output  [7:0] d_buffer;
	reg [3:0] no_bits_sent;
	reg [7:0] t_buffer;
	reg sending;
	reg [7:0] d_buffer;
	reg load_t_buffer
	
always @(posedge clk16x or negedge clrn or negedge wrn) begin
	if(clrn ==0)begin
		sending<=1'b0;
		t_empty<=1'b0;
		load_t_buffer<=1'b0;
		
	end else begin
		if(!sending) begin
			if(load_t_buffer)begin
				sending<=1'b1;
				t_buffer<=d_buffer;
				t_empty<= 1'b1;
				load_t_buffer<=1'b0;
			end
		end else begin
			if(no_bits_sent==4'b1011)
				sending<=1'b0;
		end
	
	end
	
	
end
		

		assign clk1x = cnt16x[3];
always @(posedge clk1x or negedge sending )begin
	if(!sending) begin
		no_bits_sent<=4'b0000;
		txd<=1'b1;
	end else begin
		case(no_bits_sent)
		0: txd<=1'b0;
		1: txd<=t_buffer[0];
		2: txd<=t_buffer[1];
		3: txd<=t_buffer[2];
		4: txd<=t_buffer[3];
		5: txd<=t_buffer[4];
		6: txd<=t_buffer[5];
		7: txd<=t_buffer[6];
		8: txd<=t_buffer[7];
		9: txd<= ^t_buffer;
		default: txd<=1'b1;
		endcase
		no_bits_sent<= no_bits_sent + 1'b1;
	end
	

end		
			
endmodule