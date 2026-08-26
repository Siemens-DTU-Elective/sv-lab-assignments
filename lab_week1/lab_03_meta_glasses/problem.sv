// ==========================================
// 1. DATA TYPE DEFINITIONS
// ==========================================
typedef logic [23:0] pixel_t;
typedef logic [7:0]  byte_t;

module smart_glasses_bridge;
    // ==========================================
    // 2. THE TRANSMIT API (Camera to Bridge)
    // ==========================================
    function void pixel_to_byte(input pixel_t in_pixels [], output byte_t out_bytes []);
        int num_pixels;
        int num_bytes;

        // Step 1: Calculate the required number of bytes.
        num_pixels = in_pixels.size();
        num_bytes  = num_pixels * 3;

        // Step 2: Allocate memory for 'out_bytes' using the new[] operator.
        out_bytes = new[num_bytes];

        // Step 3: Loop through 'in_pixels'.
        // Slice each 24-bit pixel into three 8-bit bytes and store them in 'out_bytes'.
        // Hint: Pixel 0 goes to Bytes 0, 1, 2. Pixel 1 goes to Bytes 3, 4, 5.
        for (int i = 0; i < num_pixels; i++) begin
            out_bytes[3*i]   = in_pixels[i][23:16]; // R / MSB
            out_bytes[3*i+1] = in_pixels[i][15:8];  // G
            out_bytes[3*i+2] = in_pixels[i][7:0];   // B / LSB
        end
    endfunction
    // ==========================================
    // 3. THE RECEIVE API (Bridge to Display)
    // ==========================================
    function void byte_to_pixel(input byte_t in_bytes [], output pixel_t out_pixels []);
        int num_bytes;
        int num_pixels;

        // Step 1: Calculate the required number of pixels.
        num_bytes  = in_bytes.size();
        num_pixels = num_bytes / 3;

        // Step 2: Allocate memory for 'out_pixels' using the new[] operator.
        out_pixels = new[num_pixels];

        // Step 3: Loop through 'out_pixels'.
        // Reconstruct each 24-bit pixel by concatenating three 8-bit bytes from 'in_bytes'.
        for (int i = 0; i < num_pixels; i++) begin
            out_pixels[i] = {in_bytes[3*i], in_bytes[3*i+1], in_bytes[3*i+2]};
        end
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
