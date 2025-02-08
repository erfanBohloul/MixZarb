.data
    log_tag:
        .ascii "ASM\0"

.text
.global play_music_func
.type play_music_func, %function

play_music_func:
    // store return address
    stp x29, x30, [sp, #-16]!


    mov x21, x0
    mov x22, x1
    mov x20, x2
    mov x23, x3

    read_loop:
        // check if string has ended
        ldrb w2, [x20]
        cbz w2, end_loop

        // count the number of note in one period
        b count_note

        after_count_note:

        // if number of notes are zero
        cmp x0, #0


        // calculate period
        mov x24, x0
        mov x0, x23
        mov x1, x24
        bl delay_calculator

        // store period
        mov x25, x0


        play_loop:

            cmp x24, #0
            beq end_play_loop

            ldrb w2, [x20]

            // switch case
            cmp w2, #100
            beq play_do

            cmp w2, #114
            beq play_re

            cmp w2, #109
            beq play_mi

            cmp w2, #102
            beq play_fa

            cmp w2, #115
            beq play_sol

            cmp w2, #108
            beq play_la

            cmp w2, #116
            beq play_ti

            cmp w2, #40
            beq loop_continue

            cmp w2, #41
            beq loop_continue

            // blank
            cmp w2, #98
            beq delay

            b loop_continue

            delay:
                mov x0, x25
                bl _noop


            loop_continue:
                add x20, x20, #1
                sub x24, x24, #1
                b play_loop


        end_play_loop:
            b read_loop

    end_loop:
        ldp x29, x30, [sp], #16
        ret



    play_do:
        mov x0, x21
        mov x1, x22
        bl play_note_do
        b delay

    play_re:
        mov x0, x21
        mov x1, x22
        bl play_note_re
        b delay

    play_mi:
        mov x0, x21
        mov x1, x22
        bl play_note_mi
        b delay

    play_fa:
        mov x0, x21
        mov x1, x22
        bl play_note_fa
        b delay

    play_sol:
        mov x0, x21
        mov x1, x22
        bl play_note_sol
        b delay

    play_la:
        mov x0, x21
        mov x1, x22
        bl play_note_la
        b delay

    play_ti:
        mov x0, x21
        mov x1, x22
        bl play_note_ti
        b delay


    count_note:
        ldrb w1, [x20]

        mov x0, #1 // ans

        cmp w1, #40
        bne after_count_note

        mov x0, #0
        mov x2, #1
        count_loop:
            ldrb w1, [x20, x2]

            cmp w1, #41 // ')'
            beq end_count_loop

            cmp w1, #0 // '\0'
            beq end_count_loop

            add x0, x0, #1
            add x2, x2, #1
            b count_loop

        end_count_loop:
            b after_count_note

