.data
    valid_chars:
        .ascii "drmfsltb)("
        .byte 0, 0, 0, 0, 0, 0

.text
.global string_check
.type string_check, %function

// string_check(char* input)
// input's length is a multiply of 16
string_check:
    stp x29, x30, [sp, #-16]!

    mov x21, #0     // flag
    mov x22, #0     // counter
    mov x20, x0     // string

    b check_valid_chars

    end_checking:

    loop:
        ldrb w2, [x20]
        cbz w2, end_string

        cmp w2, #40
        beq open_param

        cmp w2, #41
        beq close_param

        cmp x21, #1
        beq count

        b loop_continue


    loop_continue:
        add x20, x20, #1
        b loop



end:
    ldp x29, x30, [sp], #16
    ret


// string in x20
check_valid_chars:

    // Load address of valid_chars using adrp and add
    adrp x0, valid_chars
    add x0, x0, :lo12:valid_chars
    ldr q0, [x0]    // Load valid_chars into q0

    mov x2, x20  // hold a pointer

    check_loop:
        ldrb w3, [x2]
        cbz w3, end_checking    // check if we reach end of string

        dup v1.16b, w3
        cmeq v2.16b, v1.16b, v0.16b     // compare each byte

        umaxv b2, v2.16b    // find the max value in v2
        fmov w4, s2     // move results to a general register
        cbz w4, invalid_input

        add x2, x2, #1
        b check_loop




open_param:
    cmp x21, #0
    bne invalid_input

    mov x21, #1
    b loop_continue


close_param:
    cmp x21, #1
    bne invalid_input

    mov x21, #0

    cmp x22, #0
    beq invalid_input

    mov x22, 0

    b loop_continue

end_string:
    cmp x21, #1
    beq invalid_input

    b valid_input

count:
    add x22, x22, #1
    b loop_continue


invalid_input:
    mov x0, 1
    b end

valid_input:
    mov x0, 0
    b end

