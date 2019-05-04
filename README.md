# UoE-Individual-Project
This repository contains the code written for the Individual Project :An Investigation Into Methods For Enhancing Current Computational Technologies Using Brain-Like Designs In An FPGA Architecture

## References for Source Code
Thanks to Daniel and Jorge, whose project titled `Oscilloscope' proved to be a valuable educational resource and supplementary reference throughout the first principles approach that was taken to creating this system.

### Cite https://github.com/Daniel-And-Jorge/6.111-Final-Project

In the second year at the University of Exeter, during semester 2, as Electronic Engineers, we learnt fundamental Verilog code to create digital logic gates and simple test benches. In order to achieve a system of this level in this project, I required further resources to educate myself and devise a solutions that would fulfil the set objectives. The Oscilloscope project proved to be instrumental in advancing my knowledge to fully understand and implement a system at this level.

## Skills I have gained from this project
- Learning to develop code with the hardware in mind:
  - Coding in an FPGA is not the same as coding a program in software in lanugages such as C++ or Python. With Register-Transfer-Languages such as Verilog and VHDL, you are developing code to utilise registers, switching matrices and Lookup Tables (LUTs) in the FPGA. You are essentially coding architecture by definition. This was a steep learning curve for me. It was very rewarding once I got the hang of this approach to coding a system.
  
- 

## What ideas came in useful from Daniel-and-Jorge's code:
### Data_Collection Subsystem
The idea of using a ring buffer to store and send data.

### VGA_Display_Renderer Subsystem
Learning in conjunction with Will Green's article at `https://timetoexplore.net/blog/arty-fpga-vga-verilog-01', how to devise a method for communicating with the VGA Display, and devising a method for controlling pixel switching on each frame render.
