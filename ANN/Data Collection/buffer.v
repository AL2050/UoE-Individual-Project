
//////////////////////////////////////////////////////////////////////////////////
// Company: University of Exeter
// Engineer: Aaron Lloyd
// Module Name: Buffer
//////////////////////////////////////////////////////////////////////////////////

module Buffer 
    #(parameter
        SAMPLE_SIZE=12
    )
    (
    input CLK104MHZ, 
    input ready, 
    input rst,
    input trigReading,
    input activeBRAMselect,
    input signed [SAMPLE_SIZE-1:0]dataIN,
    input signed [SAMPLE_SIZE-1:0]ADDread,
    output reg signed [SAMPLE_SIZE-1:0]dataOut
    );
    
    wire [SAMPLE_SIZE-1:0] addSpace;
    assign addSpace = 'hFFFFFFFFFFF; 
    //assigning logic `1' to all address locations to being with, 
    //which enables assignments to be made with pointer below
    
    reg BRAM0we, BRAM1we;
    reg [SAMPLE_SIZE-1:0] BRAM0add_trig, BRAM1add_trig;
    reg [SAMPLE_SIZE-1:0] BRAM0point, BRAM1point;   //pointer that locates adddress and value in BRAM
    reg [SAMPLE_SIZE-1:0] ADDa_BRAM0, ADDa_BRAM1, ADDb_BRAM0, ADDb_BRAM1;
    reg [SAMPLE_SIZE-1:0] BRAM0in, BRAM1in, BRAM0out, BRAM1out;
    

    blk_mem_gen_0 BRAM0 (
      .clka(CLK104MHZ),    
      .ena(1),    
      .wea(BRAM0we),     
      .addra(ADDa_BRAM0), 
      .dina(BRAM0in),    
      .clkb(CLK104MHZ),  
      .enb(1),    
      .web(0),  
      .addrb(ADDb_BRAM0),
      .doutb(BRAM0out)
    );

    blk_mem_gen_0 BRAM1 (
          .clka(CLK104MHZ),    
          .ena(1),     
          .wea(BRAM1we),  
          .addra(ADDa_BRAM1),  
          .dina(BRAM1in),  
          .clkb(CLK104MHZ),    
          .enb(1),     
          .web(0),      
          .addrb(ADDb_BRAM1),
          .doutb(BRAM1out)  
        );

  always @(posedge CLK104MHZ) 
    begin
        if (rst)
            begin
                BRAM0point <= 0;
                BRAM1point <= 0;
                BRAM0add_trig <= 0;
                BRAM1add_trig <= 0;
            end
        
        else 
            begin
                if (ready) 
                    begin
                        ADDa_BRAM0 <= BRAM0point;
                        BRAM0in <= dataIN;
                        ADDa_BRAM1 <= BRAM1point;
                        BRAM1in <= dataIN;
    
                /*The active BRAM is written to while the locked BRAM is protected from writing*/
                    if (activeBRAMselect == 0) 
                        begin
                          BRAM0point <= BRAM0point + 1;
                          BRAM0we <= 1;
                          BRAM1we <= 0;
                        end 
                    else 
                        begin
                          BRAM0we <= 0;
                          BRAM1we <= 1;
                          BRAM1point <= BRAM1point + 1;
                        end
                     end
      
          //the pointer to the address space is triggered continuously during operation
                if (activeBRAMselect == 0) 
                    begin
                        BRAM0add_trig <= BRAM0point;
                    end
                else 
                    begin
                        BRAM1add_trig <= BRAM1point;
                    end
            end
    
        // read data, set the trigger
        if (trigReading) 
            begin
                ADDb_BRAM0 <= (BRAM0add_trig + ADDread) & addSpace;
                ADDb_BRAM1 <= (BRAM1add_trig + ADDread) & addSpace;
            end 
        else 
            begin
                ADDb_BRAM0 <= (BRAM0point + ADDread) & addSpace;
                ADDb_BRAM1 <= (BRAM1point + ADDread) & addSpace;
            end
    
        //BRAM active is written to by the Data Controller while the locked BRAM is read from
        if (activeBRAMselect == 0)
            dataOut <= BRAM1out;
        else
            dataOut <= BRAM0out;
    end
    
endmodule
