`timescale 1ns/1ps

module smart_glasses_bridge;

    // ==========================================
    // 1. DATA TYPE DEFINITIONS
    // ==========================================
    typedef bit [23:0] pixel_t; // 24-bit packed array for RGB pixel
    typedef bit [7:0]  byte_t;  // 8-bit packed array for single byte

    // ==========================================
    // 2. THE TRANSMIT API (Camera to Bridge)
    // ==========================================
    function void pixel_to_byte(input pixel_t in_pixels [], output byte_t out_bytes []);
        int num_bytes;

        // Step 1: Calculate the required number of bytes (3 bytes per 24-bit pixel)
        num_bytes = in_pixels.size() * 3;

        // Step 2: Allocate dynamic memory for 'out_bytes'
        out_bytes = new[num_bytes];

        // Step 3: Slice each pixel into three 8-bit bytes
        for (int i = 0; i < in_pixels.size(); i++) begin
            out_bytes[i*3 + 0] = in_pixels[i][23:16]; // Red / MSB Byte
            out_bytes[i*3 + 1] = in_pixels[i][15:8];  // Green / Middle Byte
            out_bytes[i*3 + 2] = in_pixels[i][7:0];   // Blue / LSB Byte
        end
    endfunction

    // ==========================================
    // 3. THE RECEIVE API (Bridge to Display)
    // ==========================================
    function void byte_to_pixel(input byte_t in_bytes [], output pixel_t out_pixels []);
        int num_pixels;

        // Step 1: Calculate required number of pixels
        num_pixels = in_bytes.size() / 3;

        // Step 2: Allocate dynamic memory for 'out_pixels'
        out_pixels = new[num_pixels];

        // Step 3: Reconstruct each 24-bit pixel via concatenation {}
        for (int i = 0; i < num_pixels; i++) begin
            out_pixels[i] = {in_bytes[i*3 + 0], in_bytes[i*3 + 1], in_bytes[i*3 + 2]};
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