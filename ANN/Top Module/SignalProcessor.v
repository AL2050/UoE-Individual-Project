`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: University of Exeter
// Engineer: Aaron Lloyd
// 
// Create Date: 03.04.2019 17:28:15
// Module Name: SignalProcessor
// Project Name: ANN
// 
//////////////////////////////////////////////////////////////////////////////////


module SignalProcessor(

/*---------CLK_DIVIDER I/O Instantiations---------*/
    input CLK100MHZ,
    input rst,
    output CLK104MHZ,
    
/*---------DATA_COLLECTOR I/O Instantiations---------*/
    input vauxp6,   //these are the external voltage signal inputs into the data collector
    input vauxn6,

/*---------VGA_RENDERER I/O Instantiations---------*/
    output VGA_HS,  //reg?
    output VGA_VS,
    output [3:0] VGA_R, 
    output [3:0] VGA_G, 
    output [3:0] VGA_B,
    
/*---------NEURON I/O Instantiations---------*/
    input fireN1,
    input fireN2
    );
    
    clk_wiz_0 CLK_DIVIDER (
        .clk_in1(CLK100MHZ),
        .clk_out1(CLK104MHZ),
        .reset(rst),
        .locked(locked)
        );
        
    wire signed [11:0] neuron_12bit;
    wire N1S1_OUT;
    wire N2S2_OUT;
        
    Neuron neurons (
        .CLK104MHZ(CLK104MHZ),
        .fireN1(fireN1),
        .fireN2(fireN2), 
        .neuron_12bit(neuron_12bit),
        .N1S1_OUT(N1S1_OUT),
        .N2S2_OUT(N2S2_OUT)
        );
        
    wire [11:0] sampleRequest;
    wire [11:0] sendSample;
    wire activeBRAMselect;
    
    DataCollection DATA_COLLECTOR (
        .CLK104MHZ(CLK104MHZ),
        .vauxp6(vauxp6),
        .vauxn6(vauxn6),
        .sampleRequest(sampleRequest),
        .activeBRAMselect(activeBRAMselect),
        .sendSample(sendSample),
        .N1S1_OUT(N1S1_OUT),
        .N2S2_OUT(N2S2_OUT),
        .neuron_12bit(neuron_12bit)
        );
    
    VGA_Display_Renderer RENDERER (
        .CLK104MHZ(CLK104MHZ),
        .VGA_HS(VGA_HS),
        .VGA_VS(VGA_VS),
        .VGA_R(VGA_R), 
        .VGA_G(VGA_G), 
        .VGA_B(VGA_B),
        .sampleRequest(sampleRequest),
        .ADC_OUT(sendSample),
        .activeBRAMselect(activeBRAMselect)
        );
    
endmodule
