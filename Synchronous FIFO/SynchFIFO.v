module SynchFIFO #(
    parameter Data_Width = 32,
    parameter Depth = 8
) (
    input clk, reset, cs, wr_en, rd_en, 
    input [Data_Width-1:0] inp_data,
    output reg [Data_Width-1:0] out_data,
    output empty, full
);
    
    localparam Address_Width = $clog2(Depth);

    reg [Data_Width-1:0] FIFO [0:Depth-1];

    reg [Address_Width:0] Write_ptr;
    reg [Address_Width:0] Read_ptr;

    always @(posedge clk or posedge reset) begin
        if(reset)
        Write_ptr <= 0;
        else if(cs && wr_en && !full) begin
            FIFO[Write_ptr] <= inp_data;
            Write_ptr <= Write_ptr + 1'b1;
        end
    end

    always @(posedge clk or posedge reset) begin
        if(reset)
        Read_ptr <= 0;
        else if(cs && rd_en && !empty) begin
            out_data <= FIFO[Read_ptr];
            Read_ptr<=Read_ptr+1'b1;
        end
    end

    assign empty = (Read_ptr == Write_ptr);
    assign full = (Read_ptr == {~Write_ptr[Address_Width],Write_ptr[Address_Width-1:0]}); 

endmodule