
use CTypes;
use queens_GPU_single_locale;

//Variables from the command line
config const initial_depth: c_int = 5;

config const size: uint(16) = 15; //queens

proc main(){


	writeln("--- N-Queens multi-GPU search - single locale --- \n\n");
	GPU_queens_call_search(size,initial_depth);


}
