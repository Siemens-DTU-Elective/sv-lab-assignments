// ==========================================
// 1. CUSTOM DATA TYPE DEFINITION
// ==========================================
typedef enum logic [7:0] {
    HOVER   = 8'h00,
    PATROL  = 8'h01,
    DEFEND  = 8'h02,
    RTL     = 8'h03
} drone_cmd_e;

module aegis_radio_firewall;

    // ==========================================
    // 2. THE VULNERABLE UPLINK
    // ==========================================
    task unsafe_uplink(logic [7:0] raw_rx);
        drone_cmd_e next_cmd;
        
        // Static Cast: Blindly trusts the input (Forced compile-time conversion)
        next_cmd = drone_cmd_e'(raw_rx);
        
        // If raw_rx is 99, next_cmd becomes 99 (which is invalid).
        // The .name() method will return an empty string "" !
        $display("[UNSAFE] Radio received: %0d | AI Command set to: '%0s'", raw_rx, next_cmd.name());
    endtask

    // ==========================================
    // 3. THE SECURE UPLINK
    // ==========================================
    task secure_uplink(logic [7:0] raw_rx);
        drone_cmd_e next_cmd;
        
        // Dynamic Cast: Runtime function that checks the dictionary first
        if ($cast(next_cmd, raw_rx)) begin
            $display("[SECURE] Valid data. AI Command set to: '%0s'", next_cmd.name());
        end else begin
            $display("[SECURE] HACKER ALERT! Malicious code '%0d' detected and blocked!", raw_rx);
            next_cmd = RTL;
            $display("         -> Safely defaulting to: '%0s'", next_cmd.name());
        end
    endtask

    // ==========================================
    // TESTBENCH
    // ==========================================
    initial begin
        $display("--- AEGIS CORP: RADIO FIREWALL BOOTING ---");
        
        $display("\n--- RUNNING VULNERABLE UPLINK ---");
        unsafe_uplink(8'h01); 
        unsafe_uplink(8'h02); 
        unsafe_uplink(8'h99); // Prints a blank name!
        
        $display("\n--- RUNNING SECURE UPLINK ---");
        secure_uplink(8'h01); 
        secure_uplink(8'h02); 
        secure_uplink(8'h99); // Safely caught and handled!
        
        $display("\n--- FIREWALL DIAGNOSTICS COMPLETE ---");
    end

endmodule
