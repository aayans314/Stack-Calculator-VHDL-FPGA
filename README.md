# Stack-Based Calculator: VHDL Implementation on FPGA

This project delivers a stack-based calculator designed in VHDL that leverages RAM and registers to model a stack data structure. The calculator executes basic arithmetic operations—addition, subtraction, multiplication, and division—via a finite state machine coordinating user inputs, stack management, and arithmetic logic.

## Architecture Overview

At the top level, a finite state machine orchestrates data flow between the Memory Buffer Register (MBR), RAM-based stack, and arithmetic logic unit. Three user buttons control the system:

- **Capture (b0):** Loads the 8-bit value from switches into the MBR.
- **Enter (b1):** Pushes the MBR value onto the stack and increments the 4-bit stack pointer.
- **Action (b2):** Pops the top stack value and performs the selected arithmetic operation with the MBR, storing the result back in the MBR.

State transitions ensure proper sequencing, including memory access latency management, safe stack pointer manipulation, and protection against invalid operations like division by zero. 

The 7-segment display driver translates the 8-bit MBR output into a three-digit decimal readout, enhancing usability.

## Testing Strategy

Functionality was verified with basic arithmetic test cases. Videos demonstrating these tests are available at the linked Google Drive repository.

## Extensions

- **Wider Display Output:** Leveraged a previously developed wider decimal display driver to improve output readability (shown in `extension.mp4`).
- **Safe Stack Push and Stack Division (Incomplete):** Attempted enhancements for overflow-safe stack operations and improved division handling in `ExtensionPlus`; however, this remains unfinished due to unresolved initialization issues.

## File Structure

- **Project/**  
  Core VHDL sources including stack and calculator logic, display drivers, and RAM modules.

- **Extensions/Extension/**  
  Contains enhanced display output modules and supporting files.

- **Extensions/ExtensionPlus/**  
  Experimental code for safe stack push and stack division features.

- **Project6_Report_AayanShah.pdf**  
  Comprehensive project documentation detailing design decisions and implementation.

## Acknowledgements

Online resources from StackOverflow, Reddit, and Intel forums provided critical insights. Collaborative discussions with classmates greatly informed the design and troubleshooting process.

---

Video demonstrations and test results can be accessed via the provided Google Drive link in the project documentation.

## Author

**Aayan Shah**  
Computer Science & Physics Student  
[GitHub Profile](https://github.com/aayans314)
