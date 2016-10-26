module vga_keyboard (clk,clrn,ps2_clk,ps2_data,.r,g,b,hs,vs);
	input clk;// 50MHZ
	input clrn;
	input ps2_clk,ps2_data;
	output [3:0] r,g,b;
	output vs,hs;
	
	//vga
	wire [18:0] rd_a;
	wire vga_rdn;
	wire [9:0] h_count;
	wire [9:0] v_count;
	vga vga1(clk,clrn,{12{ft_do}},rd_a,vga_rdn,r,g,b,
				hs,vs,h_count,v_count);

	wire 	[8:0] vga_row = rd_a[18:0];
	wire	[9:0] vga_col = rd_a[9:0];
	wire [2:0] row = vga_row[2:0];
	wire [2:0] col = vga_col[2:0];
	wire [5:0] char_row = cram_w ? kbd_row  : vga_row[8:3];
	wire [6:0] char_col = cram_w ? kbd_col : vga_col[9:3];


//char_ram 
wire [12:0] cram_a = {char_row,char_col};
wire [6:0] cram_do ;
char_ram charram(cram_do,cram_di,cram_a,cram_w,clk);

//font table
wire [12:0] fta = {cram_do,row,col};
wire ft_do;
font_table ft(fta,~clk,ft_do);

//ps2_keyboard
wire [3:0] count;
wire ready,overflow;
wire [7:0] data;
ps2_keyboard kbd(clk,clrn,ps2_clk,ps2_data,kbd_rdn,data,ready,overflow,count);

//key type
reg is_shift;
reg is_break;
always @(*) begin
		is_shift=0;
		is_break = 0;
		if(ready)begin
			if(data == 8'hf0)begin
				is_break =  1;
			
			end
			if((data==8'h12)||(data == 8'h59))begin
			is_shift = 1;
			end
		end


end


//state 0 1 2 3
reg [1:0] state;
reg shift_pressed;
reg key_pressed;
always @(negedge clk or negedge clrn)begin
	if(clrn==0)begin
		state<=0;
	end else begin
		case(state)
		2'd0:begin
				if(is_shift)shift_pressed<=1;
				if(is_break)state<=1;
			end
		2'd1:begin
				if(!ready) state<=2;
			end
		2'd2: begin
				if(ready) state<=3;
			  end
		2'd3:begin
				if(is_shift) shift_pressed<=0;
				if(!ready) state<=0;
			 end
		endcase
	end

end
				
	//get ascii of make code 
	reg [6:0] cram_di;
	reg cram_w;
	reg kbd_rdn;
	always @(posedge clk)begin
		if(ready)begin
			kbd_rdn<=0;
			if((state)==0 && (!is_shift))begin
				cram_di <= s2a(data);
				cram_w <= 1;
			end
		
		end else begin
			cram_w <=0;
			kbd_rdn<=1;
		
		end
	
	end
				
				
	//scan code to ascii code 
	function [6:0]s2a;
		input [7:0]a;
		case (s)
			8'h4b:s2a = shift_pressed?7'h4c:7'h6c;
			8'h4c:s2a = shift_pressed?7'h49:7'h69;
			8'h35:s2a = shift_pressed?7'h59:7'h79;
			8'h1c:s2a = shift_pressed?7'h41:7'h61;
			8'h3a:s2a = shift_pressed?7'h4d:7'h6d;
			8'h31:s2a = shift_pressed?7'h4e:7'h6e;
			8'h16:s2a = shift_pressed?7'h21:7'h31;
			8'h29:s2a = 7'h20;
			default: s2a = s[6:0];
		endcase			
	endfunction

//character row and column for writing to char RAM
reg [5:0] kbd_row =0;
reg [6:0] kdb_col =0;
always @(negedge cram_w)begin
	if(kdb_col == 7'd79)begin
		kbd_row <= kbd_row +1'b1;
		kbd_col<=0;
	
	end else kbd_col <= kbd_col +1'b1;

end	
				
endmodule