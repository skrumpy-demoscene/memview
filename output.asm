UpdateView:
        ; set the cursor to 0, 0
        ld de, $0000
        call PrintAt
        
        call $0DAF ; clear screen - CL_ALL

        ld hl, (_ADDRESS)
        push hl ; store this as we want the actual address back at the end
        ld a, l
        and $f0 ; we want to start the row on a multiple of $10
        ld l, a
        ld de, $ff80 ; move the start row back eight
        add hl, de
        ld (_ADDRESS), hl

        ld c, $10 ; row counter
UpdateLoopRow:
        ld b, $10 ; column counter
UpdateLoopCol:
        ld a, (_FLAGS)
        bit 0, a
        jr nz, PrintChar

        ld a, (hl)
        ld d, a
        call PrintValue
PrintCont:
        inc hl ; clear up after printing NN or '. '
        ld (_ADDRESS), hl

        ld a, $13 ; brightness attr
        rst 16
        ld a, $00
        bit 1, b
        jr z, ColChange        
        ld a, $01
ColChange:
        rst 16

        djnz UpdateLoopCol ; carry on until end of row
        
        dec c
        jr nz, UpdateLoopRow ; go to next row

        pop hl
        ld (_ADDRESS), hl ; restore the address

        ld de, $1101 ; print the current address
        call PrintAt

        ld d, h
        call PrintValue
        ld d, l
        call PrintValue

        ld de, $1107 ; print its data
        call PrintAt

        ld a, (hl)
        ld d, a
        call PrintValue

        ld a, l ; highlight the current address
        and $0f
        sla a
        ld l, a
        ld h, $59
        ld (hl), $0e
        inc hl
        ld (hl), $0e

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

PrintValue: ; print the two character hex of the value in D
        ld a, d
        and %11110000
        rra
        rra
        rra
        rra
        call PrintValueDigit

        ld a, d
        and %00001111

PrintValueDigit:
        add $30
        cp $3a
        jr c, PrintValueDigitSkip
        add $07 ; if higher than 9 move up to A
PrintValueDigitSkip:
        rst 16

        ret

PrintAt: ; voes the cursor to row D column E
        ld a, $16
        rst 16
        ld a, d
        rst 16
        ld a, e
        rst 16
        ret
