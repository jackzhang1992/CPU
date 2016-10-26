module uart_rx (clk16x,clrn,rdn,d_out,r_ready,rxd,parity_error,
			frame_error,cnt16x,frame,no_bits_rcvd,
			r_buffer,clk1x,sampling);
			
	input clk16x,clrn;
	//receiver
	input rdn;
	input rxd;
	output reg r_ready;
	output	 [7:0]d_out;
	output reg parity_error;
	output reg frame_error;
	int [3:0] cnt16x;
	output [3:0] no_bits_rcvd;
	output [10:0] r_buffer;
	output [7:0] frame;
	output clk1x;
	output sampling;
	
	reg [3:0] sampling_place;
	reg [3:0] no_bits_rcvd;
	reg [10:0] r_buffer;
	reg	clk1x;
	reg rxd_old,rxd_new;
	reg sampling;
	reg [7:0] frame;
	
	//latch 2 sampling bits
	always @(posedge clk16x or negedge clrn) begin
	if(clrn ==0)begin
			rxd_old<=1'b1;
			rxd_new<=1'b1;
		
	end  else begin
			rxd_old<=rxd_new;
			rxd_new<=rxd;
	end
	
//detect start bit
	always @(posedge cnt16x or negedge clrn ) begin
		if(clrn ==0)begin
			sampling<=1'b0;
		end else begin
			if(rxd_old && ! rxd_new)begin
				if(!sampling) sampling_place<=cnt16x+4'b1000;
				sampling<=1'b1;
			end else begin
				if(no_bits_rcvd==4'b1011)
					sampling<=1'b0;
			end
		end
	
	end
	
	
//sampling clock:clk1x
	always @(posedge clk16x or negedge clrn) begin
		if(clrn ==0)begin
			clk16x<=1'b0;
		end else begin
			if(sampling)begin
				if(cnt16x==sampling_place) clk1x<=1'b1;
				if(cnt16x == sampling_place+4'b0001) clk1x<=1'b0;
			end else  clk1x<=1'b0'
		
		end
	
	end
	
	
//number of bits received 
always @(posedge clk1x or negedge sampling) begin
	if(!sampling)begin
		no_bits_rcvd<=4'b0000;
	end else begin
		no_bits_rcvd<=no_bits_rcvd+4'b0001;
		r_buffer[no_bits_rcvd] <= rxd;
		
	end
end


//one frame, rdn clears r_ready
always @(posedge clk16x or negedge clrn or negedge rdn) begin
	if(clrn==0)begin
		r_ready<=1'b0;
		parity_error<=1'b0;
		frame_error<=1'b0;
	end	else begin
		if(!rdn)begin
			r_ready<=1'b0;
			parity_error<=1'b0;
			frame_error<=1'b0;
		end else begin
		if(no_bits_rcvd=4'b1011)begin
			frame<=r_buffer[8:1];
			r_ready<=1'b1;
			if(^r_buffer[9:1)begin 
				parity_error<=1'b1;
			end
			if(!r_buffer[10])begin
				frame_error<=1'b1;
			end
		end 
	
		end
	end

end

assign d_out = !rdn? frame : 8'bz;


endmodule