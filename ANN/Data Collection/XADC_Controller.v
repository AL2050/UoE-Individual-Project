`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: University of Exeter
// Engineer: Aaron Lloyd
// Module Name: XADC_Controller
//////////////////////////////////////////////////////////////////////////////////

module XADC_Controller
   #(parameter 
       SIGNAL_SHRINK = 3,
       NUMERATOR_SCALED_DATA_BITS = 24,
       SAMPLE_WIDTH = 12,
       SAMPLE_SET = 5634674,    //random number - to be changed
       DIVISOR = 28'd524288  //dividing the clock divider by 104MHz giving a 1Hz clock
   )
   (
/*---------Clock instantiations------------*/
    input CLK104MHZ,
    input rst,    
    
    input signed [SAMPLE_WIDTH-1:0] dataIN,
    input SAMPLEinReady,
    input ACTIVEsample,
    
    output reg sampleReady,
    output reg signed[SAMPLE_WIDTH-1:0] dataOUT,
    output reg sampleRAWsampleReady,
/*---------Neural Network Instantiations---------*/
    input N1S1_OUT,
    input N2S2_OUT
    
    );
    
/*    wire    signed  [23:0] S1 = 24'hFFFFFF;
    reg     signed  [23:0] S2 = 24'h000000;*/
    
    wire    signed  [10:0] S1 = 11'b11111111111;
    reg     signed  [10:0] S2 = 11'b00000000000;
    
    reg[27:0] counter=28'd0;
    wire synapseCounter;
    
    reg [3:0] pointer = 4'd0;   //points to bit in synapse value

//    reg synapseCounter = 0;     //the rate of learning depends on this counter
//                                //and the PLASTICITY_RATE parameter
    
/*    wire signed [NUMERATOR_SCALED_DATA_BITS-1:0] scaledDataIN;
    assign scaledDataIN = dataIN;*/
    reg signed [11:0] dataScaling;
    
    wire signed [11:0] scaledDataIN;
    assign scaledDataIN = dataScaling;
    
    always @(posedge CLK104MHZ)
        begin
            counter <= counter + 28'd1;
            
            if(counter >= (DIVISOR-1))
                counter <= 28'd0;
        end

    //when the counter register is half the synapseCounter period, toggle logic => 1Hz CLK104MHZ signal
    assign synapseCounter = (counter < DIVISOR/2) ? 1'b0 : 1'b1;


    always @(posedge synapseCounter) 
        begin
            if((N1S1_OUT == 1'b1) && (N2S2_OUT == 1'b1))
                if((S2 < 11'b11111111111))
                    S2 <= S2 + 1;
                else
                    if((S2 == 11'b11111111111))
                            S2 <= S2;

            if((N1S1_OUT == 1'b0) && (N2S2_OUT == 1'b1))
                begin
                    S2 <= S2;
                end
                
            if((N1S1_OUT == 1'b1) && (N2S2_OUT == 1'b0))
                begin
                    if((S2 > 11'b00000000000))
                        S2 <= S2 - 1;
                    else
                        if(S2 == 11'b00000000000)
                            S2 <= S2;
                end
        end
    


    always @(posedge CLK104MHZ) 
        begin
            // request the next sample if the DRP output data bus in sampleReady
            if (!rst && ACTIVEsample && SAMPLEinReady)
                begin
                    sampleReady <= 1;
                    
                    if((N1S1_OUT == 1'b1) && (N2S2_OUT == 1'b1))
                        begin
                            if(scaledDataIN < 0)
                                begin
                                    dataScaling <= dataIN + (S1-S2);
                                    dataOUT <= dataScaling >>> SIGNAL_SHRINK;
                                end
                            else
                                begin
                                    dataScaling <= dataIN + (S2-S1);
                                    dataOUT <= dataScaling >>> SIGNAL_SHRINK;
                                end
                        end

                    if((N1S1_OUT == 1'b0) && (N2S2_OUT == 1'b1))
                        begin
                            if(scaledDataIN < 0)
                                begin
                                    dataScaling <= dataIN - S2;
                                    dataOUT <= dataScaling >>> SIGNAL_SHRINK;
                                end
                            else
                                begin
                                    dataScaling <= dataIN + S2;
                                    dataOUT <= dataScaling >>> SIGNAL_SHRINK;
                                end
                        end

                    if((N1S1_OUT == 1'b1) && (N2S2_OUT == 1'b0))
                        begin
                            if(scaledDataIN < 0)
                                begin
                                    dataScaling <= dataIN - S1;
                                    dataOUT <= dataScaling >>> SIGNAL_SHRINK;
                                end
                            else
                                begin
                                    dataScaling <= dataIN + S1;
                                    dataOUT <= dataScaling >>> SIGNAL_SHRINK;
                                end
                        end
                        
                        
                    if(((N1S1_OUT == 1'b0) && (N2S2_OUT == 1'b0)))
                        begin
                            dataOUT <= 12'b0;
                        end
                end 
                    
            else
                begin
                    sampleRAWsampleReady <= 1;
                end

                
            if (sampleReady)
                sampleReady <= 0;
            
            if (sampleRAWsampleReady)
                sampleRAWsampleReady <= 0;
            
            if (rst) 
                begin
                    sampleReady <= 0;
                    sampleRAWsampleReady <= 0;
                    dataOUT <= 0;
                end
    end

    
/*    always @(posedge CLK104MHZ) 
        begin
            // request the next sample if the DRP output data bus in sampleReady
            if (!rst && ACTIVEsample && inputsampleReady)
                begin
                    sampleReady <= 1;
                    
                    if((N1S1_OUT == 1'b1) && (N2S2_OUT == 1'b1))
                        begin
                            if(scaledDataIN[11] == 1)
                                dataOUT <= scaledDataIN * ~(S2-S1) >>> SIGNAL_SHRINK;
                            else
                                dataOUT <= scaledDataIN * (S2-S1) >>> SIGNAL_SHRINK;

                                
                            if((S2 < 24'hFFFFFF) && (sampleCLK104MHZ == SAMPLE_SET))
                                begin
                                    S2 <= S2 + 1;
                                    sampleCLK104MHZ <= 0;
                                end
                            else
                                S2 <= 24'hFFFFFF;
                        end
                                
                    if((N1S1_OUT == 1'b0) && (N2S2_OUT == 1'b1))
                        begin
                            if(scaledDataIN < 0)
                                dataOUT <= scaledDataIN * ~S2 >>> SIGNAL_SHRINK;
                            else
                                dataOUT <= scaledDataIN * S2 >>> SIGNAL_SHRINK;

                            S2 <= S2;
                        end
                            
                            
                    if((N1S1_OUT == 1'b1) && (N2S2_OUT == 1'b0))
                        begin
                            if(scaledDataIN < 0)
                                dataOUT <= scaledDataIN & ~S1 >>> SIGNAL_SHRINK;
                            else
                                dataOUT <= scaledDataIN & S1 >>> SIGNAL_SHRINK;

                            if((S2 > 24'h000000) && (sampleCLK104MHZ == SAMPLE_SET))
                                begin
                                    S2 <= S2 - 1;
                                    sampleCLK104MHZ <= 0;
                                end
                            else
                                S2 <= 24'h000000;
                        end
                        
                        
                    if(((N1S1_OUT == 1'b0) && (N2S2_OUT == 1'b0)))
                        begin
                            dataOUT <= 12'b0;
                        end
                            
                             
                    sampleCLK104MHZ <= sampleCLK104MHZ + 1; //do we need this?
                end 
                    
            else
                begin
//                    sampleCLK104MHZ <= sampleCLK104MHZ + 1;     //counting 0 to 1279 for each Buffer frame
                    sampleRAWsampleReady <= 1;
                end

                
            if (sampleReady)
                sampleReady <= 0;
            
            if (sampleRAWsampleReady)
                sampleRAWsampleReady <= 0;
            
            if (rst) 
                begin
                    sampleReady <= 0;
                    sampleRAWsampleReady <= 0;
                    dataOUT <= 0;
                end
    end*/
endmodule