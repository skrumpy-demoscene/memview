UpdateView:
        ld a, $16
        rst 16
        ld a, $00
        rst 16
        ld a, $00
        rst 16
        call ResetColour

        ld c, $10
        ld de, $ffe0
        call FixHL
UpdateLoopRow:
        ld a, $13
        rst 16
        ld a, c
        cp $0c
        jr nz, NotActiveRow
        ld a, $01
        jr StartRow
NotActiveRow:
        ld a, $00
StartRow:
        rst 16
        call PrintAddress
        ld b, $08
UpdateLoopCol:
        call PrintData
        
        ld hl, (Address)
        inc hl
        ld (Address), hl

        djnz UpdateLoopCol
        
        ld a, $20
        rst 16
        ld a, $20
        rst 16

        dec c
        jr nz, UpdateLoopRow

        ld de, $ffa0
        call FixHL

        ret

PrintAddress:
        ld hl, (Address)
        ld d, h
        call PrintValue
        ld d, l
        call PrintValue

        ld a, $20
        rst 16
        ld a, $20
        rst 16

        ret

PrintData:
        ld hl, (Address)
        ld a, (Flags)
        bit 0, a
        jr nz, PrintChar
        ld a, (hl)
        ld d, a
        call PrintValue
PrintEnd:
        ld a, $20
        rst 16

        ret
PrintChar:
        ld a, (hl)
        cp $20 ; check it's above 'space'
        jr c, PrintSkip
        cp $a2 ; and below the last guarnateed UDG (S)
        jr nc, PrintSkip
        rst 16
        jr PrintSpace
PrintSkip:
        ld d, a
        ld a, $2e
        rst 16
PrintSpace:
        ld a, $10
        rst 16

        ld a, d
        and $07
        rst 16

        ld a, $11
        rst 16

        ld a, d
        and $38
        rra
        rra
        rra
        rst 16

        ld a, d
        ld a, $83
        rst 16

        call ResetColour
        jr PrintEnd

PrintValue:
        ld a, d
        and %11110000
        rra
        rra
        rra
        rra
        add $30
        cp $3a
        jr c, PrintValueDigitHigh
        add $07
PrintValueDigitHigh:
        rst 16

        ld a, d
        and %00001111
        add $30
        cp $3a
        jr c, PrintValueDigitLow
        add $07
PrintValueDigitLow:
        rst 16

        ret

ResetColour:
        ld a, $10
        rst 16
        ld a, $00
        rst 16

        ld a, $11
        rst 16
        ld a, $07
        rst 16

        ret