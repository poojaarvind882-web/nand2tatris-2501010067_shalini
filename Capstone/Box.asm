
    // Read the keyboard register
    @KBD
    D=M

    // If D != 0, a key is pressed -> set color to black (-1)
    @KEY_PRESSED
    D;JNE

    // Otherwise, key is released -> set color to white (0)
    @color
    M=0
    @DRAW_INIT
    0;JMP

(KEY_PRESSED)
    // Set color to -1 (16 bits of 1s = black)
    @color
    M=-1

(DRAW_INIT)
    // Initialize addr pointer to start of box: SCREEN + 32 * 178 = 22080
    @22080
    D=A
    @addr
    M=D

    // Initialize row counter: 20 rows to draw
    @20
    D=A
    @rows_left
    M=D

(ROW_LOOP)
    // Check if all 20 rows are completed
    @rows_left
    D=M
    @MAIN_LOOP
    D;JEQ          // If rows_left == 0, go back to main loop to poll keyboard

    // Fetch the current fill color (-1 or 0)
    @color
    D=M

    // Word 0 of current row (pixels 0-15)
    @addr
    A=M
    M=D

    // Move to Word 1 of current row (pixels 16-31)
    @addr
    M=M+1
    @color
    D=M
    @addr
    A=M
    M=D

    // Move to Word 2 of current row (pixels 32-47)
    @addr
    M=M+1
    @color
    D=M
    @addr
    A=M
    M=D

    // Advance addr to the start of the next row.
    // Screen width is 32 words per row.
    // We already moved addr forward by 2 words (from word 0 to word 2).
    // Therefore, adding 30 words moves addr to word 0 of the next row (2 + 30 = 32).
    @30
    D=A
    @addr
    M=D+M

    // Decrement the row counter
    @rows_left
    M=M-1

    // Repeat for the next row
    @ROW_LOOP
    0;JMP
