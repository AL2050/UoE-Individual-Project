# UoE-Individual-Project
This repository contains the code written for my Individual Project: An Investigation Into Methods For Enhancing Current Computational Technologies Using Brain-Like Designs In An FPGA Architecture

## References for Source Code
Thanks to Daniel and Jorge, whose project titled `Oscilloscope' proved to be a valuable educational resource and supplementary reference throughout the first principles approach that was taken to creating aspects of this system stated below.

### Cite:
Daniel-And-Jorge (2017) 6.111-Final-Project, Available at: https://github.com/Daniel-And-Jorge (Accessed: 4/5/19).

## What ideas came in useful from Daniel-and-Jorge's code:
### Data_Collection Subsystem
I was working towards an AXI-Lite interface with the XADC through a MicroBlaze Soft Core, and using a Memory Block Generator. However, this is a High-Level-Synthesis approach, and with limited FPGA and Verilog development experience, I had no context on where to look to solve errors and warnings, so as to successfully debug the system design.

The ring-buffer approach is straight forward and can be set up to transfer data, in a First-In-First-Out (FIFO) fashion (or one-to-one), which makes it easy to calibrate the system timing requirements between the Data_Collection and VGA_Display_Renderer subsystems, making this the optimal sample storage and send approach.

### VGA_Display_Renderer Subsystem
My initial concept was to use a debug core, to save the requirement for extra hardware in the system, and to derive a software-based solution for viewing the output from the Artificial Neural Network, using Vivado's Logic Analyzer with the High-Level System that would show us the output from the system, in a timing-diagram format. However, I predicted that for an Artificial Neural Network the analog, biological nature of neural signals would not be possible to view. There I considered the need for a direct visual output to be seen. This motivated the idea of a VGA Display as the output from the system.

Daniel and Jorge's Oscilloscope project in conjunction with Will Green's article at `https://timetoexplore.net/blog/arty-fpga-vga-verilog-01', was incremental in helping me to fully understand and implement the VGA_Display Renderer. These resources enabled me to devise a way for communicating with the VGA Display, and implement a method for controlling pixel switching on each frame render.

## Summary for use of the above references
In the second year at the University of Exeter, during semester 2, as Electronic Engineers, we learnt fundamental Verilog code to create digital logic gates and simple test benches. In order to achieve a system at this level for this project, I required further resources to educate myself and devise solutions that would fulfil the set objectives. The Oscilloscope project proved to be instrumental in advancing my knowledge to fully understand and implement a system of this magnitude.

## Skills I have gained and enhanced from this project
- Learning to develop code with the hardware in mind:
  - Coding in an FPGA is not the same as coding a program in software in languages such as C++ or Python. With Register-Transfer-Languages such as Verilog and VHDL, you are developing code to utilise registers, switching matrices and Lookup Tables (LUTs) in the FPGA. You are essentially coding architecture by definition. This was a steep learning curve for me. It was very rewarding to have achieved, new coding and project management with a successful outcome.
 
- Understanding and manipulating a system on a hardware level:
  - FPGA technologies have taught me to consider a system on a component level. How do signals pass through the components of a system, and how can this be optimised? One major factor that must be understood and optimised in an FPGA is timing. The clock signal is not an ideal square-wave, but a sloped version. The slopes are called the rising and falling edges, which must be calibrated. Also, slack timing must be calibrated, so that signals reach the required locations at the right times to ensure that the system behaves as expected, operating with the correct logic at the correct time.
  
- Breaking down a problem into irreducible parts and building it up to a final product, one step at a time:
  - Following attempts to utilise High-Level Synthesis in the early stages of this project, and after some meetings with Prof. C. David Wright, I began to ask critical questions such as `how can I be more productive in my approach to finding a constructive solution to Vivado errors, warnings, and system faults?'. This inspired a first-principles approach, which has enhanced my critical thinking and problem-solving skills over the past three months.
  
- Patience and persistence:
  - Working with FPGA technologies has been an exceptional challenge, that I am grateful to have been exposed to. Patience and persistence are two qualities worth mentioning, because without them it would not be possible to overcome the obstacles necessary to achieve the outcomes of this long-term project. Keeping a clear mind, and maintaining your focus on the goals to be fulfilled is important in the corporate setting.
