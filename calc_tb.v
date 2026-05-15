`timescale 1ns / 1ps

module calc_tb;

    
    reg [15:0] sw;
    reg clk;
    reg btnc;
    reg btnac;
    reg btnl;
    reg btnr;
    reg btnd;

    wire [15:0] led;

    calc DUT (
        .led(led), 
        .sw(sw), 
        .clk(clk), 
        .btnc(btnc), 
        .btnac(btnac), 
        .btnl(btnl), 
        .btnr(btnr), 
        .btnd(btnd)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    task press_enter;
        begin
            @(negedge clk);
            btnc = 1;
            @(negedge clk);
            btnc = 0;
            #20; 
        end
    endtask

    task set_op;
        input l, r, d;
        begin
            btnl = l;
            btnr = r;
            btnd = d;
            #10;
        end
    endtask

    task run_test_step;
        input [15:0] sw_val;
        input l, r, d;
        input [15:0] expected_val;
        input [8*20:1] op_name;
        begin
            sw = sw_val;
            
            btnl = l;
            btnr = r;
            btnd = d;
            
            #10; 

            press_enter();
            if (led == expected_val)
                $display("PASS: [%s] Inputs: sw=%h, btns=%b%b%b -> Result: %h (Expected: %h)", op_name, sw, l, r, d, led, expected_val);
            else
                $display("FAIL: [%s] Inputs: sw=%h, btns=%b%b%b -> Result: %h (Expected: %h)", op_name, sw, l, r, d, led, expected_val);
        end
    endtask

    initial begin
        sw = 0;
        btnc = 0;
        btnac = 0;
        btnl = 0;
        btnr = 0;
        btnd = 0;

        #100;
        
        $display("Starting Calculator Testbench based on Requirements Table...");
        $display("----------------------------------------------------------------");
        
        sw = 16'hxxxx; 
        btnl = 0; btnr = 0; btnd = 0; 
        btnac = 1; #20; btnac = 0; #10;
        if (led == 16'h0) 
            $display("PASS: [Reset] -> Result: 0x0");
        else 
            $display("FAIL: [Reset] -> Result: %h (Expected: 0x0)", led);

        run_test_step(16'h285a, 0, 1, 0, 16'h285a, "ADD");

        run_test_step(16'h04c8, 1, 1, 1, 16'h2c92, "XOR");
        run_test_step(16'h0005, 0, 0, 0, 16'h0164, "LSR");
        run_test_step(16'ha085, 1, 0, 1, 16'h5e1a, "NOR");
        run_test_step(16'h07fe, 1, 0, 0, 16'h13cc, "MULT");
        run_test_step(16'h0004, 0, 0, 1, 16'h3cc0, "LSL");
        run_test_step(16'hfa65, 1, 1, 0, 16'hc7bf, "NAND");
        run_test_step(16'hb2e4, 0, 1, 1, 16'h14db, "SUB");

        $display("----------------------------------------------------------------");
        $display("Test Sequence Completed.");
        
    end

endmodule
