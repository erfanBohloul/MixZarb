.data
    one_min_delay:
        .quad 120000000000

.text
.global delay_calculator
.type delay_calculator, %function

// args: int metronome, int n
// metronome: indicates bpm
// n is the number of note in one period
delay_calculator:
    // can't load one_min_delay directly, we should use pc-relative addressing
    adrp x2, one_min_delay
    add x2, x2, :lo12:one_min_delay

    ldr x2, [x2]
    udiv x2, x2, x0

    udiv x2, x2, x1

    mov x0, x2
    ret
