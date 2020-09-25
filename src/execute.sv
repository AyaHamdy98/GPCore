module exe_stage(
	input logic clk, nrst,
	input logic fn_i, we_i,
	input logic [4:0] alu_fn_i,
	input logic [31:0] op_a, op_b,	// operands a and b from issue stage
	output logic [31:0] alu_res,  	// alu result in PIPE #5
	output logic fn, we
	);
	
	// registers
	logic [31:0] opa_e;	   // pipe #5 from decode to execute stage (operand A at execute stage)
	logic [31:0] opb_e;	   // pipe #5 from decode to execute stage (operand B at execute stage)
	logic [4:0] alu_fn_e;	   // alu control in exe stage will be input to alu block
	logic fn_e;		   
	logic we_e;
	
	// *will be replaced by alu block and alu_fn_e will be the input ctrl* //
	assign alu_res = opa_e + opb_e;

	// pipes
	always_ff @(posedge clk, negedge nrst)
	  begin
		if (!nrst)
		  begin
			opa_e    <= 0;
			opb_e    <= 0;
			alu_fn_e <= 0;
			fn_e	 <= 0;
			we_e	 <= 0;
		  end
		else
		  begin
			opa_e    <= op_a;
			opb_e    <= op_b;	
			alu_fn_e <= alu_fn_i;
			fn_e	 <= fn_i;
			we_e	 <= we_i;
		  end
	  end

	// output
	assign fn = fn_e;
	assign we = we_e;

endmodule
