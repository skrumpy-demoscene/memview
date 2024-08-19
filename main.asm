        ; NOTES

        ; All addresses are in hex
        ; Cursor keys to move ($01 / $10 byte jumps)
        ; O & P to move RAM page ($100 byte jumps)
        ; Space to select address
        ; Enter to update value, the cusror will automatically move on
        ; T to toggle text / hex (data updates still as hex digits)
        ; X to exit, RUN will carry on from the same addr

        ; Change the value in $5c8d (ATTR_P) to change the screen colours
        
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
Flags:
        defb $00
