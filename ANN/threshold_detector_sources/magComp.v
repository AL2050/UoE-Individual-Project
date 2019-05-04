`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: University of Exeter
// Engineer: Aaron Lloyd
// 
// Create Date: 21.02.2019 13:16:30
// Module Name: magComp
//////////////////////////////////////////////////////////////////////////////////


module magComp
    #(parameter
        THRESHOLD_VOLTAGE = 12'd512    //half the amplitude of the scaled 12-bit raw data accepted to the screen
    )
    (
        input CLK104MHZ,
        input fireNeuron,
        input signed [11:0] ADC_OUT,
        output reg Eq, Lt, Gt
    );

always @ (posedge CLK104MHZ) // check the status of the inputs
    begin
        Eq <= ( ADC_OUT ==  THRESHOLD_VOLTAGE   ) && (fireNeuron == 1) ? 1'b1 : 1'b0;
        Lt <= ( ADC_OUT <   THRESHOLD_VOLTAGE   ) && ( ~ADC_OUT <  THRESHOLD_VOLTAGE   ) && (fireNeuron == 1) ? 1'b1 : 1'b0;
        Gt <= ( ADC_OUT >   THRESHOLD_VOLTAGE   ) && ( ~ADC_OUT >  THRESHOLD_VOLTAGE   ) && (fireNeuron == 1) ? 1'b1 : 1'b0;
    end
    
endmodule
