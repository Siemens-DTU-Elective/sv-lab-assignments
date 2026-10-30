//=============================================================================
// LAB12: The Wrong Hit - Student Problem Code
// SystemVerilog Lab 05 | Asif Ansari | DTU
//=============================================================================
// Tasks 1-6: Build the classes from the handout specification.
// Tasks 7-9: The testbench is provided. Run it. Observe. Fix.
//=============================================================================

// ---------------------------------------------------------------------------
// Task 1: Build CacheLine
// ---------------------------------------------------------------------------

// ---------------------------------------------------------------------------
// Task 2: Build CacheTransaction
// ---------------------------------------------------------------------------

// ---------------------------------------------------------------------------
// Task 3: Build ReadHit
// ---------------------------------------------------------------------------

// ---------------------------------------------------------------------------
// Task 4: Build ReadMiss
// ---------------------------------------------------------------------------

// ---------------------------------------------------------------------------
// Task 5: Build WriteHit
// ---------------------------------------------------------------------------

// ---------------------------------------------------------------------------
// Task 6: Build WriteMiss
// ---------------------------------------------------------------------------

// ---------------------------------------------------------------------------
// Testbench - DO NOT MODIFY
// ---------------------------------------------------------------------------
module lab12_tb;

  initial begin

    byte test_data[64];
    CacheLine line;
    ReadHit   rh;
    ReadMiss  rm;
    WriteHit  wh;
    WriteMiss wm;
    CacheTransaction txn_queue[4];
    WriteMiss wm_cast;

    foreach (test_data[i]) test_data[i] = i;

    line = new(32'hDEAD_0000);
    line.valid = 1;
    line.dirty = 1;
    line.data[0] = 8'hFF;

    rh = new(32'hAAAA_0000, test_data);
    rm = new(32'hBBBB_0000, test_data);
    wh = new(32'hCCCC_0000, test_data);
    wm = new(32'hDDDD_0000, test_data);

    txn_queue[0] = rh;
    txn_queue[1] = rm;
    txn_queue[2] = wh;
    txn_queue[3] = wm;

    // =================================================================
    // Task 7: Run this. Every transaction should behave differently.
    //         Does it? Explain what you see and why.
    // =================================================================
    $display("\n===== TASK 7 =====");

    foreach (txn_queue[i]) begin
      $display("\n--- Transaction %0d ---", i);
      txn_queue[i].identify();
      txn_queue[i].execute(line);
    end

    $display("\nTotal transactions: %0d", CacheTransaction::txn_count);

    // =================================================================
    // Task 8: Fix the problem above. Only class definitions may change.
    //         Do NOT modify this testbench. Run again.
    // =================================================================

    // =================================================================
    // Task 9: Uncomment the block below.
    //
    //   9a - Run it. Does it work? Why?
    //   9b - Swap txn_queue[2] and txn_queue[3] assignments above.
    //        Run again. Explain.
    //   9c - Replace with a safe alternative that works regardless
    //        of array ordering.
    // =================================================================

    // $display("\n===== TASK 9 =====");
    // wm_cast = WriteMiss'(txn_queue[3]);
    // $display("evicted_line is %s",
    //          (wm_cast.evicted_line != null) ? "present" : "null");

    $display("\n===== LAB12 COMPLETE =====");

  end

endmodule
