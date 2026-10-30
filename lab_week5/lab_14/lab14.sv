    
//=============================================================================
// LAB14: The Rigid Line - Student Problem Code
// SystemVerilog Lab 05 | Asif Ansari | DTU
//=============================================================================
// The code below is the working LAB13 solution with hardcoded dimensions.
// Tasks 1-3: Parameterize the classes per the handout specification.
// Tasks 4-6: The testbench is provided. Run it. Observe. Fix.
//=============================================================================

// ---------------------------------------------------------------------------
// Task 1: LineMetadata - parameterize the timestamp type
// ---------------------------------------------------------------------------
class LineMetadata;

  int unsigned read_count;
  int unsigned write_count;
  int unsigned last_access_time;

  function new();
    this.read_count       = 0;
    this.write_count      = 0;
    this.last_access_time = 0;
  endfunction

  function void record_read(int unsigned time_now);
    read_count++;
    last_access_time = time_now;
  endfunction

  function void record_write(int unsigned time_now);
    write_count++;
    last_access_time = time_now;
  endfunction

  function void display();
    $display("    Metadata: reads=%0d writes=%0d last_access=%0d",
             read_count, write_count, last_access_time);
  endfunction

  function LineMetadata copy();
    LineMetadata c = new();
    c.read_count       = this.read_count;
    c.write_count      = this.write_count;
    c.last_access_time = this.last_access_time;
    return c;
  endfunction

endclass

// ---------------------------------------------------------------------------
// Task 2: CacheLine - parameterize LINE_BYTES and TAG_WIDTH
// ---------------------------------------------------------------------------
class CacheLine;

  bit        valid;
  bit        dirty;
  bit [31:0] tag;
  byte       data[64];
  LineMetadata meta;

  function new(bit [31:0] tag = 0);
    this.valid = 0;
    this.dirty = 0;
    this.tag   = tag;
    foreach (data[i]) data[i] = 0;
    this.meta = new();
  endfunction

  function void display();
    $display("  CacheLine: valid=%0b dirty=%0b tag=0x%08h data[0:3]={%02h,%02h,%02h,%02h}",
             valid, dirty, tag, data[0], data[1], data[2], data[3]);
    if (meta != null) meta.display();
  endfunction

  function CacheLine copy();
    CacheLine c = new(this.tag);
    c.valid = this.valid;
    c.dirty = this.dirty;
    foreach (this.data[i]) c.data[i] = this.data[i];
    c.meta = this.meta;
    return c;
  endfunction

  function CacheLine deep_copy();
    CacheLine c = new(this.tag);
    c.valid = this.valid;
    c.dirty = this.dirty;
    foreach (this.data[i]) c.data[i] = this.data[i];
    if (this.meta != null)
      c.meta = this.meta.copy();
    return c;
  endfunction

endclass

// ---------------------------------------------------------------------------
// Task 3: CacheTransaction - parameterize to match CacheLine
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

class ReadHit extends CacheTransaction;

  function new(bit [31:0] addr, byte data[64]);
    super.new(addr, data);
  endfunction

  function void execute(CacheLine line);
    latency = 1;
    if (line.meta != null) line.meta.record_read(1);
    $display("  [ReadHit] execute: data returned, latency=1");
  endfunction

  function void identify();
    super.identify();
    $display("  -> [ReadHit]");
  endfunction

endclass

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
    line.meta = new();
    line.meta.record_read(100);

    $display("  [ReadMiss] execute: line fetched, latency=100, writeback=%0b",
             writeback_required);
  endfunction

  function void identify();
    super.identify();
    $display("  -> [ReadMiss] writeback_required=%0b", writeback_required);
  endfunction

endclass

class WriteHit extends CacheTransaction;

  function new(bit [31:0] addr, byte data[64]);
    super.new(addr, data);
  endfunction

  function void execute(CacheLine line);
    latency = 1;
    foreach (this.data[i]) line.data[i] = this.data[i];
    line.dirty = 1;
    if (line.meta != null) line.meta.record_write(1);
    $display("  [WriteHit] execute: line updated, latency=1");
  endfunction

  function void identify();
    super.identify();
    $display("  -> [WriteHit]");
  endfunction

endclass

class WriteMiss extends CacheTransaction;

  CacheLine evicted_line;

  function new(bit [31:0] addr, byte data[64]);
    super.new(addr, data);
    this.evicted_line = null;
  endfunction

  function void execute(CacheLine line);
    if (line.valid && line.dirty)
      evicted_line = line.deep_copy();

    latency    = 100;
    line.valid = 1;
    line.dirty = 1;
    line.tag   = addr;
    foreach (this.data[i]) line.data[i] = this.data[i];
    line.meta = new();
    line.meta.record_write(100);

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
// Testbench - DO NOT MODIFY
// ---------------------------------------------------------------------------
module lab14_tb;

  initial begin

    // -----------------------------------------------------------------
    // Task 4: L1 and L2 configurations
    // -----------------------------------------------------------------
    $display("\n===== TASK 4: L1 and L2 =====");

    // Create an L1 line (64B, 32-bit tag) and an L2 line (128B, 48-bit tag).
    // Run a ReadHit on the L1 line. Run a WriteHit on the L2 line.
    // Print both. Confirm dimensions are correct.

    // -----------------------------------------------------------------
    // Task 5: Static counters per specialization
    // -----------------------------------------------------------------
    $display("\n===== TASK 5: Static Counters =====");

    // Print txn_count for L1 transactions and L2 transactions.
    // Confirm they are independent.

    // -----------------------------------------------------------------
    // Task 6: Type safety
    // -----------------------------------------------------------------
    $display("\n===== TASK 6: Type Safety =====");

    // Uncomment the line below. What does the compiler say?
    // l1_txn.execute(l2_line);

    $display("\n===== LAB14 COMPLETE =====");

  end

endmodule
