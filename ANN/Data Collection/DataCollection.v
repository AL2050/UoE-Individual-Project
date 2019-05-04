`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: University of Exeter
// Engineer: Aaron Lloyd
// 
// Create Date: 03.04.2019 16:35:07
// Module Name: DataCollection
// 
//////////////////////////////////////////////////////////////////////////////////


module DataCollection(
   /*---------CLOCK I/O Instantiations---------*/
   input CLK104MHZ,
   input rst,
   
   /*---------ADC I/O Instantiations---------*/
    input vauxp6,
    input vauxn6,
    
    
   /*---------Buffer I/O Instantiations---------*/
    input [11:0] sampleRequest,
    input activeBRAMselect,
    output [11:0] sendSample,
    
   /*---------Neuron I/O Instantiations---------*/
    input N1S1_OUT,
    input N2S2_OUT,
    output signed [11:0] neuron_12bit
   );
    
    wire [11:0] dataOUT;
    
    wire    XADCreadyToSend,
            conversionEND, 
            rawADC_DataOUT;
    
    wire sampleOUTready;

    ADC adc(
        .XADCreadyToSend(XADCreadyToSend),
        .CLK104MHZ(CLK104MHZ),
        .vauxp6(vauxp6),
        .vauxn6(vauxn6),
        .rst(rst),
        .eoc(conversionEND),
        .dataOUT(rawADC_DataOUT)
    );

    assign neuron_12bit = rawADC_DataOUT;
    
    //this is where the neural network operates
    //data is manipulated in this module and then data is passed onto the buffer for storage
    XADC_Controller XADC_Control (
        .CLK104MHZ(CLK104MHZ),
        .rst(rst),
        .ACTIVEsample(1'b1),
        .SAMPLEinReady(XADCreadyToSend),
        .dataIN(rawADC_DataOUT),
        .sampleReady(sampleOUTready),
        .dataOUT(dataOUT),
        .N1S1_OUT(N1S1_OUT),
        .N2S2_OUT(N2S2_OUT)
    );
    
    // the buffer draws data from the XADC controller
    Buffer BUFFER (
        .CLK104MHZ(CLK104MHZ), 
        .ready(sampleOUTready),
        .rst(rst),
        .trigReading(1),
        .activeBRAMselect(activeBRAMselect),
        .dataIN(dataOUT), 
        .readAddress(sampleRequest),
        .dataOUT(sendSample)
    );
    
endmodule
