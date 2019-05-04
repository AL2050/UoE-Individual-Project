 //////////////////////////////////////////////////////////////////////////////////
// Company: University of Exeter
// Engineer: Aaron Lloyd
// 
// Create Date: 06.04.2019 15:36:21
// Module Name: VGA_Config
//////////////////////////////////////////////////////////////////////////////////
 
 module VGA_Config 
            #(parameter
            FP_hor = 48,
            S_hor = 112,
            BP_hor = 248,
            Act_hor = 1280,
            Tot_hor = 1688,
            FP_vert = 1,
            S_vert = 3,
            BP_vert = 38,
            Act_vert = 1024,
            Tot_vert = 1066
            )
            (
            input               	CLK104MHZ,
            output 	reg [11:0]    current_x_read,
            output 	reg [10:0]    current_y_read,            
            output  reg          	sVert,
            output  reg          	sHor,
            output  reg          	blnk
            );

    //defining wires for horizontal and vertical sync, blnk and reset - used to define condition for reading screen pixels
    wire 		sHorON,sVertON,
                sHorOFF,sVertOFF,
                rstHor,rstVert,
                blnkHorON,blnkVertON,next_blnkHor,next_blnkVert;
                
    //defining the period where the screen resides in the refactory period between frames
	reg 		blnkVert,blnkHor;
	
    /*
                            |Horizontal Region Size |Vertical Region Size   |
    Front Porch             |           48          |           1           |
    Sync Pulse              |           112         |           3           |
    Back Porch              |           248         |           38          |
    Active Video            |           1280        |           1024        |
    Total Pixels            |           1688        |           1066        |
    */
	
	//minus one on each of these states since first index is zero
	assign 		sHorON = (current_x_read == (FP_hor + Act_hor - 1));	
    assign 		sVertON = rstHor & (current_y_read == (Act_vert + FP_vert -  1));
    
	assign 		sHorOFF = (current_x_read == (Act_hor + FP_hor + S_hor - 1));
	assign 		sVertOFF = rstHor & (current_y_read == (Act_vert + FP_vert + S_vert - 1));
	
	assign 		rstHor = (current_x_read == (Tot_hor - 1));
	assign 		rstVert = rstHor & (current_y_read == (Tot_vert - 1));

	assign 		blnkVertON = rstHor & (current_y_read == (Act_vert - 1));
	assign 		blnkHorON = (current_x_read == (Act_hor - 1));
    assign 		next_blnkVert = rstVert ? 0 : blnkVertON ? 1 : blnkVert;
	assign 		next_blnkHor = rstHor ? 0 : blnkHorON ? 1 : blnkHor;

   
	always @(posedge CLK104MHZ) 
		begin
			//reading within the horizontal region
			current_x_read <= rstHor ? 0 : current_x_read + 1;
			//reading within the vertical region
			current_y_read <= rstHor ? (rstVert ? 0 : current_y_read + 1) : current_y_read;
			
			//horizontal blnking and syncing conditions
			blnkVert <= next_blnkVert;
			blnkHor <= next_blnkHor;
			blnk <= next_blnkVert | (next_blnkHor & ~rstHor);
			sVert <= sVertON ? 0 : sVertOFF ? 1 : sVert;
			sHor <= sHorON ? 0 : sVertOFF ? 1 : sHor;
		end
   
endmodule


module pixelClass(
	input  [11:0]   pixel, 
	input           blnk,
	output [3:0]    vga_r,vga_g,vga_b
    );

    assign {vga_r, vga_g, vga_b} = blnk ? 12'h0 : pixel;
    
endmodule
