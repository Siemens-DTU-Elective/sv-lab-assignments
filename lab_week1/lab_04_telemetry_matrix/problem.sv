module gargantua_telemetry;
    // ==========================================
    // 1. DATA STRUCTURES
    // ==========================================
    typedef struct {
        int resonance;
        int corruption;
    } quantum_packet_s;

    // Associative array: quantum_packet_s values, indexed by int (frequency)
    quantum_packet_s telemetry_map [int];

    // ==========================================
    // 2. DATA INGESTION
    // ==========================================
    task receive_packet(int freq, int res, int cor);
        // Store the resonance and corruption into the associative array at index 'freq'.
        telemetry_map[freq].resonance  = res;
        telemetry_map[freq].corruption = cor;

        $display("[TARS] Packet received on Freq: %0h | Res: %0d | Cor: %0d", freq, res, cor);
    endtask
    // ==========================================
    // 3. DATA PURGE (SAFE DELETION)
    // ==========================================
    task purge_corrupted_data();
        int keys_to_delete[$]; // never delete from an assoc. array while foreach-ing it!

        $display("\n[TARS] Initiating Radiation Purge...");

        // Pass 1: just LOOK -- collect the keys that need to go.
        foreach (telemetry_map[freq]) begin
            if (telemetry_map[freq].corruption >= 9000) begin
                keys_to_delete.push_back(freq);
            end
        end

        // Pass 2: now it's safe to actually delete them.
        foreach (keys_to_delete[i]) begin
            telemetry_map.delete(keys_to_delete[i]);
        end

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
        
        // Iterate through the remaining data; keep the highest resonance seen.
        foreach (telemetry_map[freq]) begin
            if (telemetry_map[freq].resonance > max_res) begin
                max_res   = telemetry_map[freq].resonance;
                best_freq = freq;
            end
        end
        
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
