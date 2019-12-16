# single-cycle-RISC-processor

Microprocessor built in this repository is a 16-bit, program counter-based architecture with a single ALU, register file and a separate instruction and data memories.

#### Register File [RF]
The register file contains sixteen 16-bit registers (r0-r15), with two read ports which are fed in parallel to the ALU and shifter, and a write port (for writeback). The register allocation is as follows:
- r0-r12: General purpose registers
- r13   : Stack pointer 
- r14   : Link register
- r15   : Program counter

#### Arithmetic Logic Unit [ALU]
The ALU performs all the basic operations such as, addition, subtraction, bitwise OR, AND, XOR, NOT and comparison. The inputs are fed from two MUXs which select between the register file read outputs and immediate operands from the instruction decoder. 

#### Shifter
The 16-bit shifter provides hardware support for the shift and rotate instructions. It recieves two operands (the shift amount and the input to be shifted) from the register file, and control signals to select the type of shift and directions from the instruction decoder. 

#### Instruction Decoder and Program Counter
The instruction decoder interpretes binary instructions, and determine the control signals to coordinate the microprocessor subsystems. 

The Program counter is a 16-bit register that holds the address of the next instruction to be executed. 

#### Instruction and Data Memory
The instruction and data memory are both 16b x 64K Words. The instruction memory stores all binary instructios, and outputs an istruction according to the value/address of the program counter. The data memory is read-writable, and recieves its address input from the ALU.

