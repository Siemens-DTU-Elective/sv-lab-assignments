# 🛡️ SystemVerilog Verification Lab Suite (Labs 01 – 04)

This documentation provides an overview of the verification architectures, data specifications, and expected simulation outputs for **Labs 01 through 04**.

---

## 📑 Table of Contents
1. [Lab 01: The Aegis Cyber-Attack (Enums & Dynamic $cast)](#lab-01-the-aegis-cyber-attack)
2. [Lab 02: The Terminal Parser (String Manipulations)](#lab-02-the-terminal-parser)
3. [Lab 03: Meta-Vision AI Glasses Pixel Bridge (Dynamic Arrays & Serialization)](#lab-03-meta-vision-ai-glasses-pixel-bridge)
4. [Lab 04: Gargantua Telemetry Matrix (Associative Arrays & Sparse Memory)](#lab-04-gargantua-telemetry-matrix)

---

## 🚁 Lab 01: The Aegis Cyber-Attack

### 📌 Overview & Target Concepts
* **Target Concepts:** Custom Types (`typedef`), Enumerations (`enum`), Compile-time vs. Runtime Type Casting (`$cast`).
* **Scenario:** An autonomous security drone receives raw 8-bit remote commands over an RF link subject to active cyber-attacks injecting illegal state codes (e.g., `8'h99`).
* **Goal:** Implement a secure uplink using dynamic runtime casting (`$cast`) to safely catch illegal enum values and fall back to `RTL` (Return To Launch).

### 🛠️ Interface & Data Specifications
| Construct | Declaration / Signature | Description |
| :--- | :--- | :--- |
| `drone_cmd_e` | `typedef enum logic [7:0] { HOVER=0, PATROL=1, DEFEND=2, RTL=3 }` | Custom 8-bit enumeration for drone flight commands. |
| `unsafe_uplink` | `task unsafe_uplink(logic [7:0] raw_rx)` | Static compile-time cast; creates "ghost states" on corrupted input. |
| `secure_uplink` | `task secure_uplink(logic [7:0] raw_rx)` | Uses `$cast` to validate incoming raw bytes at runtime. |

### 🖥️ Expected Simulation Output
```text
--- AEGIS DRONE UPLINK SYSTEM ONLINE ---

--- Testing Unsafe Task (Static Cast) ---
[UNSAFE] AI Command set to: 'PATROL'
[UNSAFE] AI Command set to: ''

--- Testing Secure Task (Dynamic $cast) ---
[SECURE] Valid Command Received: PATROL
[HACKER ALERT] Invalid raw code 8'h99 injected! Blocking attack...
[SECURE] Safety Protocol Triggered: Forced state to RTL
```

---

# 🖥️ Lab 02: The Terminal Parser

## 📌 Overview & Target Concepts

**Target Concepts:** `string` Data Type, String Methods (`.tolower()`, `.len()`, `.substr()`), String Concatenation (`{}`), ASCII Indexing.

**Scenario:** Parse incoming text commands from a testbench command-line interface byte-by-byte into base command strings and argument strings.

**Goal:** Extract sub-components dynamically without manual fixed-width register bit-shifting or risking memory overflow.

## 🛠️ Interface & Data Specifications

| Method / Operation | Syntax / Formula | Description |
|---|---|---|
| Case Normalization | `str.tolower()` | Converts entire raw input string to lowercase. |
| Character Bounds | $I_{\text{end}} = L_{\text{total}} - 1$ | Derives exact 0-indexed upper bound for substring operations. |
| String Slicing | `str.substr(start_idx, end_idx)` | Inclusive character array slice. |
| Concatenation | `{"Command: ", base_cmd, "Argument: ", argument}` | — |

## 🖥️ Expected Simulation Output

```plaintext
--- CLI BOOT SEQUENCE INITIATED ---

[TERMINAL] Processing raw input: 'SUDO UPDATE'
Command: sudo | Argument: update

[TERMINAL] Processing raw input: 'read 0x4A'
Command: read | Argument: 0x4a

[TERMINAL] Processing raw input: 'INJECT FAULT_01'
Command: inject | Argument: fault_01

--- PARSER DIAGNOSTICS COMPLETE ---
```

---

# 👓 Lab 03: Meta-Vision AI Glasses Pixel Bridge

## 📌 Overview & Target Concepts

**Target Concepts:** Dynamic Array Allocation (`new[]`), Packed vs. Unpacked Arrays, Data Serialization & Bit Slicing.

**Scenario:** Smart glasses stream dynamic resolution camera data (24-bit RGB) over an 8-bit narrow wireless bridge to a holographic display.

**Goal:** Construct conversion functions `pixel_to_byte` (serialization) and `byte_to_pixel` (deserialization) with dynamic runtime memory sizing where $N_{\text{bytes}} = N_{\text{pixels}} \times 3$.

## 🛠️ Interface & Data Specifications

| API Function | Parameters | Operation |
|---|---|---|
| `pixel_to_byte` | `(input pixel_t in_pixels[], output byte_t out_bytes[])` | Dynamically allocates $N_{\text{pixels}} \times 3$ bytes and slices pixels into MSB, Middle, LSB. |
| `byte_to_pixel` | `(input byte_t in_bytes[], output pixel_t out_pixels[])` | Dynamically allocates $N_{\text{bytes}} / 3$ pixels and reconstructs 24-bit words via `{}`. |

## 🖥️ Expected Simulation Output

```plaintext
--- META-VISION AI GLASSES BOOTING ---

[CAMERA] Captured Frame: '{'hffaacc, 'h112233}
[BRIDGE] Transmitting Byte Stream: '{'hff, 'haa, 'hcc, 'h11, 'h22, 'h33}
[DISPLAY] Reconstructed Frame: '{'hffaacc, 'h112233}

[RESULT] SUCCESS! Image transmitted perfectly.
```

---

# 🌌 Lab 04: Gargantua Telemetry Matrix

## 📌 Overview & Target Concepts

**Target Concepts:** Associative Arrays (`[int]`), SystemVerilog Structs, Dynamic In-Loop Deletion (`.delete()`), Map Sizing (`.num()`).

**Scenario:** Deep-space probes transmit sparse quantum telemetry across a 32-bit frequency grid ($2^{32}$ addresses) suffering from severe radiation corruption.

**Goal:** Store sparse data in an associative array `telemetry_map[int]`, purge corrupted entries where $\text{Corruption} \ge 9000$, and compute the optimal frequency for maximum quantum resonance ($R_{\max}$).

## 🛠️ Interface & Data Specifications

| Map / Task | Declaration / Signature | Description |
|---|---|---|
| `quantum_packet_s` | `typedef struct { int resonance; int corruption; }` | Packet data container layout. |
| `telemetry_map` | `quantum_packet_s telemetry_map[int]` | Sparse Associative Array indexed by 32-bit int frequency. |
| `receive_packet` | `task receive_packet(int freq, int res, int cor)` | Stores resonance and corruption into map at index freq. |
| `purge_corrupted_data` | `task purge_corrupted_data()` | Iterates map via `foreach` and removes keys where corruption $\ge 9000$. |
| `solve_gravity_equation` | `task solve_gravity_equation()` | Scans remaining valid entries to identify $R_{\max} = \max(R_i)$ and its frequency. |

## 🖥️ Expected Simulation Output

```plaintext
--- ENDURANCE SPACECRAFT: TELEMETRY SYSTEM ONLINE ---

[TARS] Packet received on Freq: a1 | Res: 4500 | Cor: 1200
[TARS] Packet received on Freq: 12345678 | Res: 8800 | Cor: 9500
[TARS] Packet received on Freq: ffffffff | Res: 9200 | Cor: 400
[TARS] Packet received on Freq: 80000000 | Res: 7100 | Cor: 9100
[TARS] Packet received on Freq: ff00ff | Res: 3300 | Cor: 800

[TARS] Initiating Radiation Purge...
[TARS] Purge complete. Remaining valid packets: 3

[TARS] Calculating Gravity Equation...
==================================================
   GRAVITY EQUATION SOLVED! 
   Optimal Frequency: ffffffff
   Maximum Resonance: 9200
==================================================

--- SYSTEM SHUTDOWN ---
```