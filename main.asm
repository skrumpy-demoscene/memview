        org	$0000

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

        ; $81d4 / 33236
Relocate:
        ld de, $0000 ; this needs to be set by the hacker to the memory address of Main
        ld hl, de ; HL will be the memory counter to work through the code
        ld bc, $0200 ; length of our program
RelocateLoop:
        ld a, (hl)
        cp $cd ; is it a call?
        jr z, RelocateUpdate ; if so, update the following bytes
RelocateCont:
        inc hl
        dec bc
        ld a, b
        or c
        jr nz, RelocateLoop
        ret ; all done - check before running!
RelocateUpdate:
        inc hl
        ld a, (hl)
        add e
        ld (hl), a
        jr nc, RelocateNC
        inc hl
        inc (hl)
        jr RelocateC
RelocateNC:
        inc hl
RelocateC:
        ld a, (hl)
        add d
        ld (hl), a

        dec bc
        dec bc
        jr RelocateCont

Address:
        defb $00, $80
