        org	$fd00

Main:
        push hl
        push de
        push af

Loop:
        call UpdateView
        call UserInput
        jr Loop

        INCLUDE "output.asm"
        INCLUDE "input.asm"
        INCLUDE "commands.asm"

Exit:
        pop af
        pop de

        ; return the current address
        ld hl, (Address)
        push hl
        pop bc

        pop hl

        ret

Address:
        defb $80, $fe
Flags:
        defb $00
