module g05_max_min (
    input  logic       clk,
    input  logic       rst_n,
    input  logic [7:0] sample_in,
    input  logic       sample_valid,
    output logic [7:0] max_out,
    output logic [7:0] min_out
);
    logic [7:0] max_reg;
    logic [7:0] min_reg;
    logic [2:0] count;
    logic       first_sample;
    always_ff @(posedge clk) begin
        if (!rst_n) begin
            max_reg      <= 8'd0;
            min_reg      <= 8'd0;
            count        <= 3'd0;
            first_sample <= 1'b1;
            max_out      <= 8'd0;
            min_out      <= 8'd0;
        end else if (sample_valid) begin
            if (first_sample) begin
                max_reg      <= sample_in;
                min_reg      <= sample_in;
                first_sample <= 1'b0;
                count        <= 3'd1;
            end else begin
                if (sample_in > max_reg)
                    max_reg <= sample_in;

                if (sample_in < min_reg)
                    min_reg <= sample_in;

                if (count == 3'd7) begin
                    max_out <= (sample_in > max_reg)
                             ? sample_in : max_reg;
                    min_out <= (sample_in < min_reg)
                             ? sample_in : min_reg;

                    count        <= 3'd0;
                    first_sample <= 1'b1;
                end else begin
                    count <= count + 1'b1;
                end
            end
        end
    end
endmodule
