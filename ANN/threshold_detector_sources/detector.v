`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: University of Exeter
// Engineer: Aaron Lloyd
// 
// Create Date: 21.02.2019 15:52:37
// Module Name: detector
//////////////////////////////////////////////////////////////////////////////////


module detector(
    input CLK104MHZ,
    input fireNeuron,
    input signed [11:0] ADC_OUT,
    output enable           // the output wire that enables the post-synaptic pulse to propagate, when Vin > Vt
    );
    
    wire A, B, C, D, E;
    
    magComp comparator (
        .CLK104MHZ(CLK104MHZ),
        .fireNeuron(fireNeuron),
        .ADC_OUT(ADC_OUT),
        .Eq(A), 
        .Lt(B), 
        .Gt(C)
        );
    
    or ORgate(D, A, B);
    not NOTgate(E, D);
    and ANDgate(enable, E, C);
    
endmodule
