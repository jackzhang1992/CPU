`timescale 1ns/1ns
module vga(
input clk,                                    // 系统时钟50MHZ
input clrn,                                  //复位信号
input [23:0]datain,                       //输入R,G,B数据24bit
output rdn,                                 //读使能信号，低电平有效。
output [18:0]rd_a,                       //读地址，read_address={row(9),col(10bit)}
output reg[9:0]h_count=10'd0      //列计数器 0-799
output reg[9:0]v_count=10'd0,     //行计数器  0-524
output reg vga_clk=1'b0，           //vga时钟 25MHZ  

//VGA接口信号
output hs,                                        //行扫描信号
output vs,                                          //场扫描信号
output [7:0]r,g,b                          //R,G,B输出信号
);

//refreshrate=25*10^6/((96+48+640+16)*(480+2+33+10))=59.5=60

//1.VGA时钟生成，vga_clk:25MHZ   
always @( negedge clrn or posedge clk  )
vga_clk<=(!clrn)?1'b0: ~vga_clk;

//2.计数器v_count(0-524) and h_count(0-799)
always @( negedge clrn or posedge vga_clk  )
     if(!clrn) begin v_count<=10'd0;h_count<=10'd0;end
         else if(v_count==10'd524)
          v_count<=10'd0;
         else
         begin
         if(h_count==10'd799)
                begin h_count<=10'd0;      v_count<=v_count+1'b1;end
         else
                h_count<=h_count+1'b1;   
     end


// 3.锁存输入数据data_in，rdn=0时，外部有存储器有40ns的时间提供datain数据。
reg video_out=1'b0;
reg [23:0]data_reg=24'd0;

always @(negedge clrn or posedge vga_clk)
              if(!clrn)
                            begin video_out<=1'b0;data_reg<=24'd0;end
              else
                            begin video_out<=~rdn; data_reg<=datain;end


//4.接口信号生成   
assign hs=(h_count>=96);               //HS波形输出
assign vs=(v_count>=2);               //VS波形输出
wire [9:0]rol=v_count-10'd35;        //计算行地址
wire [9:0]col =h_count-10'd143;     //计算列地址
assign rd_a={rol[8:0],col[9:0]};    //行列地址拼接成一个rd_a
assign rdn=~(((h_count>=10'd143)&&(h_count<10'd783))&&((v_count>=10'd35)&&(v_count<10'd515)));                                            //只有在有效的数据位rdn才置0
assign r=(video_out)?data_reg[23:16]:8'd0;
assign g=(video_out)?data_reg[15:8]:8'd0;
assign b=(video_out)?data_reg[7:0]:8'd0;

endmodule