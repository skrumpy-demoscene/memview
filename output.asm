UpdateView:
        ld a, $16
        rst 16
        ld a, $00
        rst 16
        ld a, $00
        rst 16
        
        ld a, $10
        rst 16
        ld a, $00
        rst 16

        ld a, $11
        rst 16
        ld a, $07
        rst 16

        ld hl, (Address)
        push hl
        ld a, l
        and $f0 ; we want to start the row on a multiple of $10
        ld l, a
        ld (Address), hl
        ld de, $ffc0 ; move the start row back four
        call FixHL

        ld c, $10 ; row counter
UpdateLoopRow:
        ld a, $13
        rst 16
        ld a, c ; if this is the active row, set bright, otherwise don't
        cp $0c
        jr nz, NotActiveRow
        ld a, $01
        jr StartRow
NotActiveRow:
        ld a, $00
StartRow:
        rst 16
        ld b, $10
UpdateLoopCol:
        ld a, (Flags)
        bit 4, a
        jr nz, PrintChar

        ld a, (hl)
        ld d, a
        call PrintValue
PrintCont:
        inc hl
        ld (Address), hl

        djnz UpdateLoopCol
        
        dec c
        jr nz, UpdateLoopRow

        pop hl
        ld (Address), hl

        ld a, $16
        rst 16
        ld a, $11
        rst 16
        ld a, $02
        rst 16

        ld d, h
        call PrintValue
        ld d, l
        call PrintValue

        ld a, $16
        rst 16
        ld a, $11
        rst 16
        ld a, $0a
        rst 16

        ld a, (hl)
        ld d, a
        call PrintValue

        ld a, l
        and $0f
        rla
        add $80
        ld l, a
        ld h, $58
        ld (hl), $31
        inc hl
        ld (hl), $31

        ret

PrintChar:
        ld a, (hl)
        cp $20 ; check it's above 'space'
        jr c, PrintSkip
        cp $a2 ; and below the last guarnateed UDG (S)
        jr nc, PrintSkip
        rst 16
        ld a, $20
        rst 16
        jr PrintCont

PrintSkip:
        ld a, $2e
        rst 16
        ld a, $20
        rst 16
        jr PrintCont

; print the two character hex of the value in D
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
