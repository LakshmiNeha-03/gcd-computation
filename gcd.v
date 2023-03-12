`timescale 1ns / 1ps

    module gcd_data_path( lt, gt, eq, lda, ldb, sel1, sel2, sel_in, data, clk);
    
    input lda, ldb, sel1, sel2, sel_in, clk;
    input [15:0] data;
    output lt, gt, eq;
    wire [15:0] bus, a_out, b_out, sub_out, x, y;
    
        pipo A (a_out, lda, clk, bus);
        pipo B (b_out, ldb, clk, bus); 
        mux mux1 (x, sel1, a_out, b_out);
        mux mux2 (y, sel2, a_out, b_out);
        mux load_mux (bus, sel_in, sub_out, data);  
        sub s (sub_out, x,y);
        comp c (lt, gt, eq, a_out, b_out );  
    endmodule
     
    module comp (output lt, gt, eq, input [15:0] in1, in2);
        assign lt = in1 < in2;
        assign gt = in1 > in2;
        assign eq = in1 == in2;  
    endmodule
    
    module mux(output [15:0] data_out, input sel, input [15:0] in_1, in_2);
        assign data_out = sel? in_1 : in_2;
    endmodule
    
    module pipo (output reg [15:0]data_out, input load, clk, input [15:0]data_in );
    
    always@(posedge clk)
        if(load) data_out<=data_in;
    
    endmodule
    
    module sub(output reg [15:0] data_out, input [15:0] in1, in2);
    always@(*) data_out = in1 - in2;
    endmodule
    
    module contrl_path (output reg lda, ldb, sel_in, sel1, sel2, done, input clk, lt, gt, eq, start);
    reg [2:0] state;
    parameter S0 = 3'b000, S1 = 3'b001, S2= 3'b010,  S3 = 3'b011,  S4= 3'b100, S5 = 3'b101;
    

    always@(posedge clk) begin
    case(state)
        S0 : if(start) state <= S1;
        S1 : state <= S2;
        S2 : #2 if(eq) state <= S5;
                else if (lt) state <= S3;
                else if(gt) state <= S4;
        S3 : #2 if(eq) state <= S5;
                else if(lt) state <= S3;
                else if(gt) state <= S4; 
        S4: #2  if(eq) state <=S5;
                else if(lt) state <= S3;
                else if(gt) state <= S4;
        S5: state <= S5;
        default: state <= S0;    
    endcase
    end
    
    always@(state) begin
    case(state)
        S0 : begin lda = 1; ldb = 0; sel_in = 0; done = 0; end
        S1 : begin lda = 0; ldb = 1; sel_in = 0;  end
        S2 : if(eq) done =1;
             else if(lt) begin
                         sel1 = 0; sel2 = 1; sel_in = 1;
                         #1 lda = 0 ; ldb =1;
                          end
             else if(gt) begin
                         sel1 = 1; sel2 = 0; sel_in = 1;
                         #1 lda = 1 ; ldb =0;
             end
         S3 : if(eq) done =1;
             else if(lt) begin
                         sel1 = 0; sel2 = 1; sel_in = 1;
                         #1 lda = 0 ; ldb =1;
                          end
             else if(gt) begin
                         sel1 = 1; sel2 = 0; sel_in = 1;
                         #1 lda = 1 ; ldb =0;
             end
         S4 : if(eq) done =1;
             else if(lt) begin
                         sel1 = 0; sel2 = 1; sel_in = 1;
                         #1 lda = 0 ; ldb =1;
                          end
             else if(gt) begin
                         sel1 = 1; sel2 = 0; sel_in = 1;
                         #1 lda = 1 ; ldb =0;
             end
         S5: begin done =1; sel1 = 0; sel2 = 0; lda = 0; ldb = 0; end
         default : begin lda =0; ldb =0; end        
    endcase
    end
    endmodule
