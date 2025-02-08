
.text
.global _noop
.type _noop, %function

_noop:
    loop:
        subs x0, x0, #1
        bne loop

    ret