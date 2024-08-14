        org	$fd00

Main:
        push hl

Loop:
        call UpdateView
        call UserInput
        jr Loop

        INCLUDE "output.asm"
        INCLUDE "commands.asm"
        INCLUDE "input.asm"

Exit:
        pop hl

        ret

Address:
        defb $00, $fd
