`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: University of Exeter
// Engineer: Aaron Lloyd
// 
// Create Date: 07.04.2019 06:15:22
// Module Name: VGA_Display_Renderer
// 
//////////////////////////////////////////////////////////////////////////////////

module VGA_Display_Renderer (
   /*---------CLOCK I/O Instantiations---------*/
    input CLK104MHZ,
    output reg VGA_HS,
    output reg VGA_VS,
    output reg [3:0] VGA_R, 
    output reg [3:0] VGA_G, 
    output reg [3:0] VGA_B,
    
   /*---------ADC I/O Instantiations---------*/
    input signed [11:0] ADC_OUT,
    
   /*---------signal_Drawer I/O Instantiations---------*/
    output [11:0] sampleRequest,
    
    output activeBRAMselect  //ring buffer toggling wire
                // 0 => BRAM0 active, BRAM1 locked
                // 1 => BRAM1 locked, BRAM0 active
    );
   
   
    wire sVert;
    wire sHor;
    wire blnk;
    
    wire [11:0] current_x_read;
    wire [10:0] current_y_read;
    
    wire [11:0] signalReadX;
    wire [10:0] signalReadY;
    
    wire [11:0] pixel;
    
    wire signalsVert, signalsHor, signalblnk;        
        
    VGA_Config configure (
        .CLK104MHZ(CLK104MHZ),
        .current_x_read(current_x_read),
        .current_y_read(current_y_read),
        .sVert(sVert),
        .sHor(sHor),
        .blnk(blnk)
        );
        
    signal_Drawer drawer (
        .CLK104MHZ(CLK104MHZ),
        .ADC_OUT(ADC_OUT),                         //DRP output data bus for Vaux6 P/N
        .current_x_read(current_x_read),
        .current_y_read(current_y_read),
        .sHor(sHor),
        .sVert(sVert),
        .blnk(blnk),
        .pixel(pixel),
        .signalReadX(signalReadX),
        .signalReadY(signalReadY),
        .signalsVert(signalsVert),
        .signalsHor(signalsHor),
        .signalblnk(signalblnk),
        .ADD(sampleRequest),
        .activeBRAMselect(activeBRAMselect)
        );
        
always @(posedge CLK104MHZ)
    begin
        {VGA_R, VGA_G, VGA_B} <= signalblnk ? 4'b0 : pixel;
        VGA_HS <= signalsHor;
        VGA_VS <= signalsVert;
    end
   
endmodule