        org	$fd00

Main:
        push hl

Loop:
        call UpdateView
        call UserInput
        jr Loop

        INCLUDE "output.asm"
        INCLUDE "input.asm"
        INCLUDE "commands.asm"

Exit:
        pop hl

        ret

Address:
        defb $00, $fd
Flags:
        defb $00
