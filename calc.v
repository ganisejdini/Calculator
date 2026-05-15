module calc(
    output wire [15:0] led,
    input wire [15:0] sw,
    input wire clk,
    input wire btnc,   
    input wire btnac,  
    input wire btnl,   
    input wire btnr,   
    input wire btnd    
);

    reg [15:0] accumulator;
    wire [31:0] result;
    wire [3:0] alu_op;
    wire zero; 
    wire ovf;  

    wire [31:0] op1; 
    wire [31:0] op2; 

    assign op1 = {{16{accumulator[15]}}, accumulator};
    assign op2 = {{16{sw[15]}}, sw};

    alu inst_alu (
        .op1(op1),
        .op2(op2),
        .alu_op(alu_op),
        .zero(zero),
        .result(result),
        .ovf(ovf)
    );

    calc_enc inst_enc (
        .btnl(btnl),
        .btnr(btnr),        
        .btnd(btnd),
        .alu_op(alu_op)
    );

    always @(posedge clk) 
        begin
            if (btnac)  
                accumulator <= 16'b0;
            else if (btnc) 
                accumulator <= result[15:0];
        end

    assign led = accumulator;

endmodule
