`include "uart_rx.v"
`include "uart_tx.v"
module uart (clk16x,clrn,
		rdn,d_out,r_ready,rxd,parity_error,frame_error,
		wrn,d_in,t_empty,txd,cnt16x,
		no_bits_rcvd,r_buffer,r_clk1x,sampling,frame,
		no_bits_sent,t_buffer,t_clk1x,sending,d_buffer);
	input clk16x,clrn;
	//receiver
	input rdn;
	input rxd;
	output r_ready;
	output	 [7:0]d_out;
	output parity_error;
	output frame_error;
	//transmitter
	input wrn;
	output txd;
	output t_empty;
	input [7:0]d_in;
	//for test
	output [3:0] cnt16x;
	output sampling;
	output r_clk1x;
	output [3:0] no_bits_rcvd;
	output [10:0] r_buffer;
	output [7:0] frame;
	output sending;
	output t_clk1x;
	output [3:0] no_bits_sent;
	output [7:0] t_buffer;
	output [7:0] d_buffer;
	//clk16x counter
	always @(posedge clk16x or negedge clrn)begin
		if(clrn==0)begin
			cnt16x<= 4'd0;
		end	else begin
			cnt16x<=cnt16x+1'b1;
		end
	end
	
	uart_rx r(clk16x,clrn,rdn,d_out,r_ready,rxd,parity_error,
			frame_error,cnt16x,frame,no_bits_rcvd,
			r_buffer,r_clk1x,sampling);
	
	
	uart_tx t(clk16x,clrn,wrn,d_in,t_empty,txd,cnt16x,
			no_bits_sent,t_buffer,t_clk1x,sending,d_buffer);
	
endmodule
