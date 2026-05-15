module calc_enc(
    input wire btnl,
    input wire btnr,
    input wire btnd,
    output wire [3:0] alu_op
);

    wire not_btnl, not_btnr, not_btnd;
    wire w01, w02, w03;
    wire w11;
    wire w21, w22, w23, w24;
    wire w31, w32;

    not (not_btnl, btnl);
    not (not_btnr, btnr);
    not (not_btnd, btnd);

    and (w01, not_btnl, btnd);
    and (w02, btnl, btnr);
    and (w03, w02, not_btnd);
    or  (alu_op[0], w01, w03);

    or  (w11,not_btnr,not_btnd);
    and (alu_op[1], btnl, w11);

    xor (w21, btnr, btnd);
    not (w22, w21); 
    and (w23, not_btnl, btnr);
    and (w24, btnl, w22);
    or  (alu_op[2], w23, w24);

    and (w31, btnl, btnr);
    and (w32, btnl, btnd);
    or  (alu_op[3], w31, w32);

endmodule
