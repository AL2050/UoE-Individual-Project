`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: University of Exeter
// Engineer: Aaron Lloyd
// 
// Create Date: 08.04.2019 12:47:43
// Module Name: signal_Drawer
// 
//////////////////////////////////////////////////////////////////////////////////

module signal_Drawer
    #(parameter
        SIGNAL_COLOUR = 12'h6F0,			//emerald green
        SAMPLE_WIDTH = 12,
        
        ACTIVE_HOR = 1280,TOT_HOR = 1688,
        ACTIVE_VERT = 1024,TOT_VERT = 1066,
        
        ZERO_LEVEL = ACTIVE_VERT/2,
        
        VERT_SIZE = 12,HOR_SIZE = 11,
        
        PIXEL_THICKNESS = 1,            //drawing pixels in the neighbourhood of the pixel location
        ADD_SIZE = 11
     )
    (
    /*Inputs coming from the VGA Configuration module*/
    input 										CLK104MHZ,
    input 			[VERT_SIZE - 1 : 0] 	current_x_read,
    input 			[HOR_SIZE - 1 : 0] 	current_y_read,
    input 										sVert,
    input 										sHor,
    input 										blnk,
    
    input signed 	[SAMPLE_WIDTH - 1 : 0] 	  ADC_OUT,           //input sample originating from the Buffer
    
    /*Signal Drawer instantiations */
    output 			[SAMPLE_WIDTH - 1 : 0] 	  pixel,
    
    output reg 		[VERT_SIZE - 1 : 0] 	  signalReadX,
    output reg 		[HOR_SIZE - 1 : 0] 	      signalReadY,
    
    output reg 							      signalsVert,
    output reg 							      signalsHor,
    output reg 								  signalblnk,
    
    output reg 		[ADD_SIZE - 1 : 0] 		  ADD,
    
    output reg 								  activeBRAMselect         //instantiate activeBRAMselect = 0;
    );
    reg pixelON;    //switch enabling the switching ON of pixels
    wire signed 	[SAMPLE_WIDTH - 1 : 0] 		  scaledADC_OUT;
    wire 			[HOR_SIZE - 1: 0] 	         pixelLOC;
    
    assign 	scaledADC_OUT = ADC_OUT; //scaling takes place in XADC controller
    assign  pixelLOC = ZERO_LEVEL - scaledADC_OUT;
    
    
    
    /*
        mode of operation:
            - are we scanning in the active region of the screen? Y/N
            - if N : toggle BRAMs in Buffer to access next sample set
            - if Y :    - proceed to read address of next sample
                        - active pixels in the reigon where 
    */
    always @(posedge CLK104MHZ)
        begin
            if((current_x_read == ACTIVE_HOR - 1) && (current_y_read == ACTIVE_VERT - 1))	//are we on the last visible pixel? if so, start reading the other BRAM
                begin
                    activeBRAMselect = ~ activeBRAMselect;
                end
            else
            if((current_x_read >= 0) && (current_x_read <= (ACTIVE_HOR - 1)))
                begin
                    ADD <= current_x_read;
                end
            else
                ADD <= ADD;
                if((current_y_read > pixelLOC - PIXEL_THICKNESS) && (current_y_read < pixelLOC + PIXEL_THICKNESS))
                    begin
                        pixelON <= 1;
                    end
                else
                    begin
                        pixelON <= 0;
                    end
    /*These values are passed onto the next pixelClass for preparing the VGA data*/
            signalReadX <= current_x_read;
            signalReadY <= current_y_read;
            signalsVert <= sVert;
            signalsHor <= sHor;
            signalblnk <= blnk;
        end

    //pixel is a logical unary value, that expresses `1' or `0' depending on the state of the above conditions 
    //when scanning onto the screen for each frame
    assign pixel = pixelON ? SIGNAL_COLOUR : 12'h0;

endmodule
