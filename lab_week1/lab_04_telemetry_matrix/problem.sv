module gargantua_telemetry;

    // ==========================================
    // 1. DATA STRUCTURES
    // ==========================================
    typedef struct {
        int resonance;
        int corruption;
    } quantum_packet_s;

    // TODO: Declare an associative array named 'telemetry_map'.
    // It should store 'quantum_packet_s' types and be indexed by an 'int' (the frequency).
    

    // ==========================================
    // 2. DATA INGESTION
    // ==========================================
    task receive_packet(int freq, int res, int cor);
        // TODO: Store the resonance and corruption into the associative array at index 'freq'.
        
        $display("[TARS] Packet received on Freq: %0h | Res: %0d | Cor: %0d", freq, res, cor);
    endtask

    // ==========================================
    // 3. DATA PURGE (SAFE DELETION)
    // ==========================================
    task purge_corrupted_data();
        $display("\n[TARS] Initiating Radiation Purge...");
        
        // TODO: Iterate through the associative array.
        // If the corruption is >= 9000, delete that entry from the array.
        // Hint: You can use a foreach loop: foreach(telemetry_map[freq])
        
        
        $display("[TARS] Purge complete. Remaining valid packets: %0d", telemetry_map.num());
    endtask

    // ==========================================
    // 4. THE GRAVITY EQUATION
    // ==========================================
    task solve_gravity_equation();
        // Declare first, then assign to avoid the implicit static error!
        int max_res;
        int best_freq;
        
        max_res = 0;
        best_freq = 0;
        
        $display("\n[TARS] Calculating Gravity Equation...");
        
        // TODO: Iterate through the remaining data in the associative array.
        // Find the packet with the highest resonance. Save its resonance and frequency.
        
        
        $display("==================================================");
        $display("   GRAVITY EQUATION SOLVED! ");
        $display("   Optimal Frequency: %0h", best_freq);
        $display("   Maximum Resonance: %0d", max_res);
        $display("==================================================");
    endtask

    // ==========================================
    // TESTBENCH
    // ==========================================
    initial begin
        $display("--- ENDURANCE SPACECRAFT: TELEMETRY SYSTEM ONLINE ---\n");
        
        // Simulating sparse data arriving from the black hole
        // Notice the frequencies (indices) are massive and scattered!
        receive_packet(32'h0000_00A1, 4500, 1200);
        receive_packet(32'h1234_5678, 8800, 9500); // CORRUPTED!
        receive_packet(32'hFFFF_FFFF, 9200, 400);  // The Solution
        receive_packet(32'h8000_0000, 7100, 9100); // CORRUPTED!
        receive_packet(32'h00FF_00FF, 3300, 800);
        
        // Execute the system tasks
        purge_corrupted_data();
        solve_gravity_equation();
        
        $display("\n--- SYSTEM SHUTDOWN ---");
    end

endmodule
