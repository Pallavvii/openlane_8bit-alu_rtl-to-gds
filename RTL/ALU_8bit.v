module ALU_8bit (
    input  [7:0] A, B,
    input  [3:0] ALU_Sel,
    input        clk,
    input        rst,

    output reg [15:0] ALU_Out,
    output reg        CarryOut,
    output reg        Zero,
    output reg        Sign,
    output reg        Overflow
);

    reg [15:0] result;

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            ALU_Out  <= 16'b0;
            result   <= 16'b0;
            CarryOut <= 1'b0;
            Overflow <= 1'b0;
            Zero     <= 1'b0;
            Sign     <= 1'b0;
        end else begin
            // defaults (prevents inferred latches & lint errors)
            result   <= 16'b0;
            CarryOut <= 1'b0;
            Overflow <= 1'b0;

            case (ALU_Sel)

                // ADD
                4'b0000: begin
                    {CarryOut, result[7:0]} <= A + B;
                    Overflow <= (~(A[7] ^ B[7])) & (A[7] ^ result[7]);
                end

                // SUB
                4'b0001: begin
                    {CarryOut, result[7:0]} <= A - B;
                    Overflow <= (A[7] ^ B[7]) & (A[7] ^ result[7]);
                end

                // AND
                4'b0010: result <= {8'b0, (A & B)};

                // OR
                4'b0011: result <= {8'b0, (A | B)};

                // XOR
                4'b0100: result <= {8'b0, (A ^ B)};

                // NOT A
                4'b0101: result <= {8'b0, (~A)};

                // INC A
                4'b0110: {CarryOut, result[7:0]} <= A + 1;

                // DEC A
                4'b0111: {CarryOut, result[7:0]} <= A - 1;

                // MUL
                4'b1000: result <= A * B;

                default: result <= 16'b0;
            endcase

            ALU_Out <= result;
            Zero    <= (result == 16'b0);
            Sign    <= result[15];
        end
    end
endmodule
