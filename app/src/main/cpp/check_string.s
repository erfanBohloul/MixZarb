.text
.global string_check
.type string_check, %function

// string_check(char* input)
string_check:
    stp x29, x30, [sp, #-16]!


    mov x21, #0     // flag
    mov x22, #0     // counter
    mov x20, x0     // string

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

