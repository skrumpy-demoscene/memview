        ; $01c0 / 448 - program length
Relocate:
        call $0013 ; call a ret
        dec sp
        dec sp
        ex (sp), hl ; grab the old return address - we now have a PC
        inc sp
        inc sp
        ld de, $fe3d ; needs to be updated if the program length changes ($10000 - program length - 3)
        add hl, de ; pull it back to the beginning of the program
                   ; HL will be the memory counter to work through the code
        ld a, h
        sub $10
        ld d, a
        ld e, l ; DE will be the base to add to each address (ie. the address of Start)
        ld bc, $01c0 ; length of our program, needs to be updated if the length changes
RelocateLoop:
        ld a, (hl)
        cp $cd ; is it a call?
        jr z, RelocateUpdate ; if so, update the following bytes
RelocateCont:
        inc hl
        dec bc
        ld a, b
        or c ; check whether we have hit the end of the program
        jr nz, RelocateLoop
        ret ; all done
RelocateUpdate:
        ld ix, hl

        ld a, (ix+2) ; get MSB first
        cp $10
        jr c, RolocateROM ; this is a ROM call so leave it alone
        add d
        ld (ix+2), a

        ld a, (ix+1) ; get LSB
        add e
        jr nc, RelocateC ; it overflowed so increase MSB
        inc (ix+2)
RelocateC:
        ld (ix+1), a
RolocateROM:
        inc hl ; update the counters for the two address bytes
        inc hl
        dec bc
        dec bc

        jr RelocateCont
