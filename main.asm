        org	$8000

Main:
        push hl
        push de
        push bc
        push af
        ld hl, $8000

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

        ld c, $0f
UpdateLoopRow:
        ld b, $08
        call PrintAddress
UpdateLoopCol:
        call PrintData
        inc hl
        djnz UpdateLoopCol
        
        ld a, $20
        rst 16
        ld a, $20
        rst 16
        ld a, $20
        rst 16
        dec c
        jr nz, UpdateLoopRow

UserInput:
        ld a, $16
        rst 16
        ld a, $12
        rst 16
        ld a, $00
        rst 16

        call WaitKey
        cp $58 // exit
        jr z, Exit
        // cp $20 // select address

        jr UserInput
        
WaitKey:
        ld hl, $5C6A
        set 3, (hl)
        halt
        call $02BF
        ld a, ($5C3B)
        bit 5, a
        jr z, WaitKey
        ld a, ($5C08)
        ret

PrintAddress:
        ld d, h
        call PrintValue

        ld d, l
        call PrintValue

        ld a, $20
        rst 16

        ret

PrintData:
        ld a, (hl)
        ld d, a
        call PrintValue

        ld a, $20
        rst 16

        ret

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

Exit:
        ld a, $0d
        rst 16

        pop af
        pop bc
        pop de
        pop hl
        ret
