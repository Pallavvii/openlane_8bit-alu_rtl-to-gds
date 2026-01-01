`timescale 1ns/1ps

module ALU_8bit_TB;

    reg [7:0] A, B;
    reg [3:0] ALU_Sel;
    reg clk, rst;

    wire [15:0] ALU_Out;
    wire CarryOut, Zero, Sign, Overflow;

    ALU_8bit DUT (
        .A(A),
        .B(B),
        .ALU_Sel(ALU_Sel),
        .clk(clk),
        .rst(rst),
        .ALU_Out(ALU_Out),
        .CarryOut(CarryOut),
        .Zero(Zero),
        .Sign(Sign),
        .Overflow(Overflow)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        $dumpfile("alu.vcd");
        $dumpvars(0, ALU_8bit_TB);
    end

    initial begin
        clk = 0; rst = 0;
        A = 0; B = 0; ALU_Sel = 0;

        #10 rst = 1;

        // ADD
        #10 A = 8'd20;  B = 8'd10;  ALU_Sel = 4'b0000;

        // SUB
        #10 A = 8'd50;  B = 8'd15;  ALU_Sel = 4'b0001;

        // AND
        #10 A = 8'b11001100; B = 8'b10101010; ALU_Sel = 4'b0010;

        // OR
        #10 A = 8'b11001100; B = 8'b10101010; ALU_Sel = 4'b0011;

        // XOR
        #10 A = 8'b11110000; B = 8'b00001111; ALU_Sel = 4'b0100;

        // NOT
        #10 A = 8'b10101010; ALU_Sel = 4'b0101;

        // INC
        #10 A = 8'd99; ALU_Sel = 4'b0110;

        // DEC
        #10 A = 8'd99; ALU_Sel = 4'b0111;

        // MUL
        #10 A = 8'd12; B = 8'd11; ALU_Sel = 4'b1000;

        #50 $finish;
    end

endmodule
