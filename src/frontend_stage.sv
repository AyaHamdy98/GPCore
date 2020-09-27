module frontend_stage(
	input logic clk, nrst,
	input logic PCSEL,		// pc select control signal

	output logic [31:0] pc2,	// pc at instruction mem pipe #2
	output logic [31:0] instr2,  	// instruction output from inst memory (to decode stage)
	
	//Just for testing not an actual output
	output logic [31:0] pc		// program counter PIPE #1
	);

	// registers
	logic [31:0] pcReg; 	   // pipe #1 pc
	logic [31:0] pcReg2;	   // pipe #2 from pc to inst mem

	// wires
	logic [31:0] npc;   	   // next pc wire

	// pipes
	always_ff @(posedge clk, negedge nrst)
	  begin
		if (!nrst)
		  begin
			pcReg <= 0;
			pcReg2 <= 0;
		  end
		else
		  begin
			pcReg <= npc;		// PIPE1
			pcReg2 <= pcReg;	// PIPE2
		  end
	  end

	always_comb
	  begin
		// npc logic
		unique case(PCSEL)
			0: npc = pcReg + 4;
			1: npc = 0;
			default: npc = pcReg + 4;
		endcase
	  end

	// output
	assign pc  = pcReg;
	assign pc2 = pcReg2; 	// pc + 4 will be piped to (EXE/MEM stage)
	
	// dummy inst mem
	instr_mem m1 (.clk(clk), .addr(pc), .instr(instr2));  // output inst for decode stage

endmodule