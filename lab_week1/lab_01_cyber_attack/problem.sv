// ==========================================
// 1. CUSTOM DATA TYPE DEFINITION
// ==========================================
typedef enum logic [7:0] {
    HOVER  = 8'h00,
    PATROL = 8'h01,
    DEFEND = 8'h02,
    RTL    = 8'h03
} drone_cmd_e;

module aegis_radio_firewall;
    // ==========================================
    // 2. THE VULNERABLE UPLINK
    // ==========================================
    task unsafe_uplink(logic [7:0] raw_rx);
        drone_cmd_e next_cmd;

        // Static (compile-time) cast: just reinterprets the 8 bits as
        // drone_cmd_e with ZERO legality checking.
        next_cmd = drone_cmd_e'(raw_rx);

        $display("[UNSAFE] Radio received: %0d | AI Command set to: '%0s'", raw_rx, next_cmd.name());
    endtask
    // ==========================================
    // 3. THE SECURE UPLINK
    // ==========================================
    task secure_uplink(logic [7:0] raw_rx);
        drone_cmd_e next_cmd;

        // $cast called as a FUNCTION (inside the if) returns 1 on success,
        // 0 on failure, instead of just firing a simulator warning.
        if ($cast(next_cmd, raw_rx)) begin
            $display("[SECURE] Radio received: %0d | AI Command set to: '%0s'", raw_rx, next_cmd.name());
        end else begin
            next_cmd = RTL;
            $display("[SECURE] *** INTRUSION DETECTED *** Command %0d rejected -- forcing failsafe: '%0s'", raw_rx, next_cmd.name());
        end
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
