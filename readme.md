To set up the Vivado project, you can run `generate_vivado.tcl` (in the Vivado interface before opening a project there's a "run script" option in tools, you can use that)

To export the new setup, in vivado run `write_project_tcl generate_vivado.tcl`

Make sure to install the [Basys drivers](https://reference.digilentinc.com/vivado/installing-vivado/start) too.

TODOS:
 - get the graphics data into the machine
 - write up packaging scripts for the image data

IDEAS:
 - caching the task script (or just using make....)
 - trying to get things working with Symbiflow? 
 - running synthessis through command line instead
 - figuring out how to wire up a controller 


Links People have given me:
 - [picorv32](https://github.com/cliffordwolf/picorv32), softcore I can use for the CPU
 - [vunit](https://vunit.github.io/) Verilog equivalent of pytest
 - [cocotb](https://github.com/cocotb/cocotb) another testing suite
 - [nMigen](https://github.com/m-labs/nmigen) a DSL on top of verilog
 - [symbiflow](https://github.com/antmicro/symbiflow-examples) examples
 - [MiSTer](https://github.com/MiSTer-devel/Main_MiSTer/wiki)  
