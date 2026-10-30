//=============================================================================
// LAB13: The Shared Eviction - Student Problem Code
// SystemVerilog Lab 05 | Asif Ansari | DTU
//=============================================================================
// Tasks 1-3: Build the classes from the handout specification.
// Tasks 4-7: The testbench is provided. Run it. Observe. Fix.
//=============================================================================

// ---------------------------------------------------------------------------
// Task 1: Build LineMetadata
// ---------------------------------------------------------------------------

// ---------------------------------------------------------------------------
// Task 2: Update CacheLine - add metadata, update constructor and display
// ---------------------------------------------------------------------------
class CacheLine;

  bit        valid;
  bit        dirty;
  bit [31:0] tag;
  byte       data[64];

  function new(bit [31:0] tag = 0);
    this.valid = 0;
    this.dirty = 0;
    this.tag   = tag;
    foreach (data[i]) data[i] = 0;
  endfunction

  function void display();
    $display("  CacheLine: valid=%0b dirty=%0b tag=0x%08h data[0:3]={%02h,%02h,%02h,%02h}",
             valid, dirty, tag, data[0], data[1], data[2], data[3]);
  endfunction

  // Task 3: Add copy() - shallow copy

  // Task 5: Add deep_copy() - deep copy

endclass

// ---------------------------------------------------------------------------
// CacheTransaction
// ---------------------------------------------------------------------------
class CacheTransaction;

  bit [31:0]    addr;
  byte          data[64];
  int unsigned  latency;

  static int txn_count = 0;

  function new(bit [31:0] addr, byte data[64]);
    this.addr    = addr;
    this.data    = data;
    this.latency = 0;
    txn_count++;
  endfunction

  virtual function void execute(CacheLine line);
    latency = 1;
    $display("  [CacheTransaction] execute: default, latency=1");
  endfunction

  virtual function void identify();
    $display("[CacheTransaction] addr=0x%08h latency=%0d", addr, latency);
  endfunction

endclass

// ---------------------------------------------------------------------------
// ReadHit
// ---------------------------------------------------------------------------
class ReadHit extends CacheTransaction;

  function new(bit [31:0] addr, byte data[64]);
    super.new(addr, data);
  endfunction

  function void execute(CacheLine line);
    latency = 1;
    $display("  [ReadHit] execute: data returned, latency=1");
  endfunction

  function void identify();
    super.identify();
    $display("  -> [ReadHit]");
  endfunction

endclass

// ---------------------------------------------------------------------------
// ReadMiss
// ---------------------------------------------------------------------------
class ReadMiss extends CacheTransaction;

  bit writeback_required;

  function new(bit [31:0] addr, byte data[64]);
    super.new(addr, data);
    this.writeback_required = 0;
  endfunction

  function void execute(CacheLine line);
    if (line.valid && line.dirty)
      writeback_required = 1;

    latency    = 100;
    line.valid = 1;
    line.dirty = 0;
    line.tag   = addr;
    foreach (this.data[i]) line.data[i] = this.data[i];

    $display("  [ReadMiss] execute: line fetched, latency=100, writeback=%0b",
             writeback_required);
  endfunction

  function void identify();
    super.identify();
    $display("  -> [ReadMiss] writeback_required=%0b", writeback_required);
  endfunction

endclass

// ---------------------------------------------------------------------------
// WriteHit
// ---------------------------------------------------------------------------
class WriteHit extends CacheTransaction;

  function new(bit [31:0] addr, byte data[64]);
    super.new(addr, data);
  endfunction

  function void execute(CacheLine line);
    latency = 1;
    foreach (this.data[i]) line.data[i] = this.data[i];
    line.dirty = 1;
    $display("  [WriteHit] execute: line updated, latency=1");
  endfunction

  function void identify();
    super.identify();
    $display("  -> [WriteHit]");
  endfunction

endclass

// ---------------------------------------------------------------------------
// Task 7: WriteMiss - replace field-by-field copy with deep_copy()
// ---------------------------------------------------------------------------
class WriteMiss extends CacheTransaction;

  CacheLine evicted_line;

  function new(bit [31:0] addr, byte data[64]);
    super.new(addr, data);
    this.evicted_line = null;
  endfunction

  function void execute(CacheLine line);
    if (line.valid && line.dirty) begin
      evicted_line = new();
      evicted_line.tag   = line.tag;
      evicted_line.valid = line.valid;
      evicted_line.dirty = line.dirty;
      foreach (line.data[i]) evicted_line.data[i] = line.data[i];
      // NOTE: metadata is not copied here. This is the bug.
    end

    latency    = 100;
    line.valid = 1;
    line.dirty = 1;
    line.tag   = addr;
    foreach (this.data[i]) line.data[i] = this.data[i];

    $display("  [WriteMiss] execute: line allocated, latency=100, evicted=%s",
             (evicted_line != null) ? "yes" : "no");
  endfunction

  function void identify();
    super.identify();
    $display("  -> [WriteMiss] evicted=%s",
             (evicted_line != null) ? "yes" : "no");
  endfunction

endclass

// ---------------------------------------------------------------------------
// Testbench
// ---------------------------------------------------------------------------
module lab13_tb;

  initial begin

    // -----------------------------------------------------------------
    // Task 4: Shallow copy - observe the aliasing
    // -----------------------------------------------------------------
    $display("\n===== TASK 4: Shallow Copy =====");

    // Create a CacheLine, give it some metadata activity,
    // shallow-copy it, then keep mutating the original's metadata.
    // Print both. Explain what you see.

    // -----------------------------------------------------------------
    // Task 6: Deep copy - confirm independence
    // -----------------------------------------------------------------
    $display("\n===== TASK 6: Deep Copy =====");

    // Repeat Task 4 using deep_copy(). Confirm the copy is frozen.

    // -----------------------------------------------------------------
    // Task 7: WriteMiss integration
    // -----------------------------------------------------------------
    $display("\n===== TASK 7: WriteMiss Integration =====");

    // Run a WriteMiss that triggers eviction.
    // After execute(), mutate the live line's metadata.
    // Print the evicted line's metadata.
    // Confirm it did not change.

    $display("\n===== LAB13 COMPLETE =====");

  end

endmodule
