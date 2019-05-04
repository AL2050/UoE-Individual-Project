`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: University of Exeter
// Engineer: Aaron Lloyd
// 
// Module Name: ADC
//////////////////////////////////////////////////////////////////////////////////
 

module ADC(
    output XADCreadyToSend,
    input CLK104MHZ,
    input vauxp6,
    input vauxn6,
    input rst,
    output eoc,
    output [11:0] dataOUT
 );

   reg [6:0] ADDin;
   wire [15:0] dOUTxadc;  

    
    //the input address is kept constant as the DRP status register for Vaux6
    always @(posedge(CLK104MHZ))
        begin
            ADDin <= 7'h16; // Vaux6 data output register
        end
        
        
   // XADC IP module - this module is being set with the EOC pin fed back into the DEN pin
   // to enable the continuous conversion of raw analog data into digital data
    xadc_wiz_0  XADC (
        .daddr_in(ADDin), //addresses can be found in the artix 7 XADC user guide DRP register space
        .dclk_in(CLK104MHZ), 
        .den_in(eoc),                   
        .vauxp6(vauxp6),
        .vauxn6(vauxn6),
        .vn_in(1'b0),
        .vp_in(1'b0),
        .do_out(dOUTxadc),
        .rst_in(rst),
        .eoc_out(eoc),
        .drdy_out(XADCreadyToSend)
        );
    
    assign dataOUT = dOUTxadc[15:4];
      
endmodule
