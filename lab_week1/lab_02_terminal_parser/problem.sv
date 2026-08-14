module terminal_parser;

    task parse_and_execute(string raw_input);
        string clean_input;
        string base_cmd;
        string argument;
        string final_output;
        
        // 1. Declare the variables without initializing them here
        int space_idx;
        int end_idx;

        $display("\n[TERMINAL] Processing raw input: '%0s'", raw_input);

        // 2. Initialize space_idx inside the task body so it resets every time!
        space_idx = -1; 

        // TODO 1: Convert 'raw_input' to lowercase and store it in 'clean_input'
        
        
        // TODO 2: Calculate 'end_idx' using the formula: length - 1
        // Hint: Use the .len() method on clean_input
        
        
        // TODO 3: Scan 'clean_input' byte-by-byte to find the space character (" ").
        // Save the index to 'space_idx' and break the loop.
        
        
        // TODO 4: Use .substr() to slice the string into two pieces.
        // base_cmd = from index 0 to (space_idx - 1)
        // argument = from (space_idx + 1) to end_idx
        
        
        // TODO 5: Use string concatenation {} to build the final_output string.
        // Format it exactly like this: "Command: [cmd] | Argument: [arg]"
        // Then print it using $display!
        
    endtask

    // ==========================================
    // TESTBENCH
    // ==========================================
    initial begin
        $display("--- CLI BOOT SEQUENCE INITIATED ---");
        
        parse_and_execute("SUDO UPDATE");
        parse_and_execute("read 0x4A");
        parse_and_execute("INJECT FAULT_01");
        
        $display("\n--- PARSER DIAGNOSTICS COMPLETE ---");
    end

endmodule
