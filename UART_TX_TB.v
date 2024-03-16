`timescale 1ns/1ns
`define WAVES_FILE "./work/waves-tx.vcd"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/01/27 16:41:00
// Design Name: 
// Module Name: UART_TX_TB
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module UART_TX_TB;
reg clk; // Top level system clock input.
reg resetn;
wire uart_txd; // UART transmit pin.
wire uart_tx_busy; // Module busy sending previous item.
reg uart_tx_en; 
reg [7:0] uart_tx_data; // The recieved data.
localparam BIT_RATE = 9600;
localparam BIT_P    = (1000000000/BIT_RATE);
localparam CLK_HZ   = 50000000;
localparam CLK_P    = 1000000000/ CLK_HZ;
localparam CLK_P_2    = 500000000/ CLK_HZ;

always #CLK_P_2 clk=~clk;

task send_byte;
    input [7:0] to_send;
    begin
        $display("Send data %b at time %d", to_send,$time);
        uart_tx_data= to_send;
        uart_tx_en  = 1'b1;
    end
endtask

reg [7:0] to_send;
initial begin
    resetn  = 1'b0;
    clk     = 1'b0;
    #40 resetn = 1'b1;
    $dumpfile(`WAVES_FILE);
    $dumpvars(0,UART_TX_TB);
    repeat(20) begin
        to_send = $random;
        send_byte(to_send);
        #1000;
        wait(!uart_tx_busy);
    end
    $display("BIT RATE  : %db/s", BIT_RATE );
    $display("BIT PERIOD: %dns" , BIT_P    );
    $display("CLK PERIOD: %dns" , CLK_P    );
    $display("CYCLES/BIT: %d"   , i_uart_tx.CYCLES_PER_BIT);
    $display("Finish simulation at time %d", $time);
    $finish();
end

UART_TX #(
.BIT_RATE(BIT_RATE),
.CLK_HZ  (CLK_HZ  )
) i_uart_tx(
.clk          (clk          ),
.resetn       (resetn       ),
.uart_txd     (uart_txd     ),
.uart_tx_en   (uart_tx_en   ),
.uart_tx_busy (uart_tx_busy ),
.uart_tx_data (uart_tx_data ) 
);
endmodule
