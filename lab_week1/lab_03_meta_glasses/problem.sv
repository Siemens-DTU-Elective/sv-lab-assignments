// ==========================================
// 1. DATA TYPE DEFINITIONS
// ==========================================
// TODO: Define a PACKED array of 24 bits named 'pixel_t'
// TODO: Define a PACKED array of 8 bits named 'byte_t'

module smart_glasses_bridge;

    // ==========================================
    // 2. THE TRANSMIT API (Camera to Bridge)
    // ==========================================
    function void pixel_to_byte(input pixel_t in_pixels [], output byte_t out_bytes []);
        // TODO Step 1: Calculate the required number of bytes.
        // TODO Step 2: Allocate memory for 'out_bytes' using the new[] operator.
        
        
        // TODO Step 3: Loop through 'in_pixels'. 
        // Slice each 24-bit pixel into three 8-bit bytes and store them in 'out_bytes'.
        // Hint: Pixel 0 goes to Bytes 0, 1, 2. Pixel 1 goes to Bytes 3, 4, 5.
        
    endfunction

    // ==========================================
    // 3. THE RECEIVE API (Bridge to Display)
    // ==========================================
    function void byte_to_pixel(input byte_t in_bytes [], output pixel_t out_pixels []);
        // TODO Step 1: Calculate the required number of pixels.
        // TODO Step 2: Allocate memory for 'out_pixels' using the new[] operator.
        
        
        // TODO Step 3: Loop through 'out_pixels'.
        // Reconstruct each 24-bit pixel by concatenating three 8-bit bytes from 'in_bytes'.
        
    endfunction

    // ==========================================
    // TESTBENCH
    // ==========================================
    initial begin
        // Unpacked dynamic arrays (Notice the empty brackets [])
        pixel_t camera_frame [];
        byte_t  tx_stream [];
        pixel_t display_frame [];
        
        $display("--- META-VISION AI GLASSES BOOTING ---");
        
        // Simulate the camera capturing a tiny 2-pixel image
        // We allocate the dynamic array at runtime!
        camera_frame = new[2]; 
        camera_frame[0] = 24'hFF_AA_CC; // Pixel 0: R=FF, G=AA, B=CC
        camera_frame[1] = 24'h11_22_33; // Pixel 1: R=11, G=22, B=33
        
        $display("\n[CAMERA] Captured Frame: %p", camera_frame);
        
        // 1. Serialize for transmission
        pixel_to_byte(camera_frame, tx_stream);
        $display("[BRIDGE] Transmitting Byte Stream: %p", tx_stream);
        
        // 2. Deserialize for display
        byte_to_pixel(tx_stream, display_frame);
        $display("[DISPLAY] Reconstructed Frame: %p", display_frame);
        
        // 3. Verification Check
        if (camera_frame == display_frame) begin
            $display("\n[RESULT] SUCCESS! Image transmitted perfectly.");
        end else begin
            $display("\n[RESULT] ERROR! Image corruption detected.");
        end
    end

endmodule
