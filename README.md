# UoE-Individual-Project
This repository contains the code written for the Individual Project :An Investigation Into Methods For Enhancing Current Computational Technologies Using Brain-Like Designs In An FPGA Architecture

## References for Source Code
Thanks to Daniel and Jorge, whose project titled `Oscilloscope' proved to be a valuable educational resource and supplementary reference throughout the first principles approach that was taken to creating this system.

### Cite https://github.com/Daniel-And-Jorge/6.111-Final-Project

## What ideas came in useful from Daniel-and-Jorge's code:
### Data_Collection Subsystem
The idea of using a ring buffer to store and send data.

### VGA_Display_Renderer Subsystem
Learning in conjunction with Will Green's article at `https://timetoexplore.net/blog/arty-fpga-vga-verilog-01', how to devise a method for communicating with the VGA Display, and devising a method for controlling pixel switching on each frame render.


In the second year at the University of Exeter, during semester 2, as Electronic Engineers, we learnt fundamental Verilog code to create digital logic gates and simple test benches. In order to achieve a system at this level in this project, I required further resources to educate myself and devise solutions that would fulfil the set objectives. The Oscilloscope project proved to be instrumental in advancing my knowledge to fully understand and implement a system at this level.

## Skills I have gained and enhanced from this project
- Learning to develop code with the hardware in mind:
  - Coding in an FPGA is not the same as coding a program in software in lanugages such as C++ or Python. With Register-Transfer-Languages such as Verilog and VHDL, you are developing code to utilise registers, switching matrices and Lookup Tables (LUTs) in the FPGA. You are essentially coding architecture by definition. This was a steep learning curve for me. It was very rewarding once I got the hang of this approach to coding a system.
  
- Understanding and manipulating a system on a hardware level:
  - FPGA technologies have taught me to consider a system on a component level. How do signals pass through the componenets of a system, and how can this be optimised? One major factor that must be understood and optimised in an FPGA is timing. The clock signal is not an ideal square-wave, but a sloped version. The sloped are called the rising and falling edges. These must be calibrated. Also, slack timing must be calibrated, so that signals reach the required locations at the right times so that the system behaves as expected, operating with the correct logic at the correct time.
  
- Breaking down a problem into irreducible parts and building it up to a final product, one step at a time:
  - Following attempts to utilise High-Level Synthesis in the early stages of this project, and after some meetings with Prof. C. David Wright, I began to ask critical questions such as `how can I be more productive in my approahc to finding a constructive solutions to Vivado errors, warnings, and system faults?'. This inspired a first-principles approach, which has enhanced my critical thinking and problem solving skills over the past 1-2 months.
  
- Patience and persistence:
  - Working with FPGA technologies has been an acceptional challenge, that I am grateful to have been exposed to. Patience and persistence are two qualities worth mentioning, because without them it would not be possible to overcome the obstacles necessary to achieve the outcomes of this long-term project. Keeping a clear mind, and maintaining your focus on the goals to be fulfilled is important in the corporate setting.
