`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: University of Exeter
// Engineer: Aaron Lloyd
// 
// Create Date: 14.04.2019 19:26:38
// Module Name: Neuron
//////////////////////////////////////////////////////////////////////////////////


module Neuron (
    input CLK104MHZ,
    input fireN1,
    input fireN2,
    input signed [11:0] neuron_12bit,
    output N1S1_OUT,
    output N2S2_OUT
    );
    
    //S1 and S2 act as multipliers on the 12-bit sample values to be outputted to the screen

    //S1 and S2 are BITWISE ANDed with the 12-bit sample value to be outputted from the XADC Controller
    //S1 = 12'hFFF, and so will not change the 12-bit sample value.
    
    //SYNAPSE#_STRENGTH is a 12-bit value that represents the synapse residing between pre- and post- synaptic neurons in the ANN.
    //There are 2^12 possible values [0,4096]. This can easily be adjusted by changing the number of bits in these values.
    

    //this neuron represents the `sight of food'
    detector N1 (
        .CLK104MHZ(CLK104MHZ),
        .fireNeuron(fireN1),
        .ADC_OUT(neuron_12bit),
        .enable(N1S1_OUT)
        );
    
    //this neuron represents the `ring of a bell'
    detector N2 (
        .CLK104MHZ(CLK104MHZ),
        .fireNeuron(fireN2),
        .ADC_OUT(neuron_12bit),
        .enable(N2S2_OUT)
        );
        
endmodule
