    
// ==========================================
// 1. CUSTOM DATA TYPE DEFINITION
// ==========================================
// TODO: Use 'typedef' to create an enum of type 'logic [7:0]'.
// Name the type 'drone_cmd_e'.
// States: HOVER = 8'h00, PATROL = 8'h01, DEFEND = 8'h02, RTL = 8'h03

module aegis_radio_firewall;

    // ==========================================
    // 2. THE VULNERABLE UPLINK
    // ==========================================
    task unsafe_uplink(logic [7:0] raw_rx);
        // TODO: Declare a variable named 'next_cmd' of type 'drone_cmd_e'
        
        
        // TODO: Perform a forced, compile-time type cast to push 'raw_rx' into 'next_cmd'.
        // (Do not check if it is valid. Just force it!)
        
        
        $display("[UNSAFE] Radio received: %0d | AI Command set to: '%0s'", raw_rx, next_cmd.name());
    endtask

    // ==========================================
    // 3. THE SECURE UPLINK
    // ==========================================
    task secure_uplink(logic [7:0] raw_rx);
        // TODO: Declare a variable named 'next_cmd' of type 'drone_cmd_e'
        
        
        // TODO: Use SystemVerilog's built-in runtime casting function to safely check the input.
        // If the function returns 1 (success), print the valid state.
        // If the function returns 0 (fail), print a hacker warning and set state to RTL.
        
    endtask

    // ==========================================
    // TESTBENCH
    // ==========================================
    initial begin
        $display("--- AEGIS CORP: RADIO FIREWALL BOOTING ---");
        
        $display("\n--- RUNNING VULNERABLE UPLINK ---");
        unsafe_uplink(8'h01); // Valid (PATROL)
        unsafe_uplink(8'h02); // Valid (DEFEND)
        unsafe_uplink(8'h99); // HACKER ATTACK! (99)
        
        $display("\n--- RUNNING SECURE UPLINK ---");
        secure_uplink(8'h01); // Valid (PATROL)
        secure_uplink(8'h02); // Valid (DEFEND)
        secure_uplink(8'h99); // HACKER ATTACK! (99)
        
        $display("\n--- FIREWALL DIAGNOSTICS COMPLETE ---");
    end

endmodule
