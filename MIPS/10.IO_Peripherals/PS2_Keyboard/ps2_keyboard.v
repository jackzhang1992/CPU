module ps2_keyboard(clk,clrn,ps2_clk,ps2_data,
			rdn,data,ready,overflow,count);

			input clk,clrn,ps2_clk,ps2_data;
			input rdn;
			output ready;
			output overflow;
			output [3:0] count;
			reg overflow;
			reg [3:0] count;
			reg [9:0] buffer;
			reg [7:0] fifo [7:0];
			reg [2:0] w_ptr,r_ptr;
			
			reg [2:0] ps2_clk_sync;
			always @(posedge clk)beign
				if(clrn ==0)begin
					count<=0;
					w_ptr<=0;
					r_ptr<=0;
					overflow<=0;
					
				end else if(sampling) begin
					if(count==4'd10) begin
						if(([buffer[0]==0) && 
							ps2_data &&
							(^buffer[9:1])) begin
								fifo[w_ptr]<= buffer[8:1];
								w_ptr<=w_ptr+1'b1;
								overflow<= overflow| (r_ptr == w_ptr+1'b1);
							end
							count <= 0;
					end else begin
						buffer[count]<= ps2_data;
						count<= count + 1'b1;
					
					end
				end
				
				if(!rdn && ready)begin
					r_ptr <= r_ptr +1'b1;
					overflow <= 0;
				end
			
			end	
			
			assign ready = (w_ptr != r_ptr);
			assign data = fifo[r_ptr];
			