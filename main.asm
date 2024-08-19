        org	$fd00

Main:
        push hl
        push de
        push af

UpdateView:
        ld a, $16
        rst 16
        ld a, $00
        rst 16
        ld a, $00
        rst 16
        call ResetColour

        ld c, $10
UpdateLoopRow:
        ld b, $08
        call PrintAddress
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

        ld hl, (Address)
        ld b, $80
ResetAddress:
        dec hl
        djnz ResetAddress
        ld (Address), hl

UserInput:
        call WaitKey
        cp $58 // exit
        jp z, Exit
        cp $20 // change address
        jp z, ChangeAddress
        cp $0a // forward by 8
        jp z, ForwardLine
        cp $0b // back by 8
        jp z, BackLine
        cp $09 // forward by 256
        jp z, ForwardPage
        cp $08 // back by 256
        jp z, BackPage
        cp $54 // toggle text
        jp z, TextToggle

        jr UserInput

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

WaitKey:
        push hl
WaitKeyDown:
        ;  set CAPS
        ld hl, $5C6A
        set 3, (hl)

        ; wait for keypress
        halt
        call $02BF
        ld a, ($5C3B)
        bit 5, a
        jr z, WaitKeyDown
        ld a, ($5C08)
        push af

WaitKeyUp:
        ld hl, $5C08
        ld (hl), $00
        call $02BF
        ld a, ($5C08)
        cp $00
        jr nz, WaitKeyUp

        pop af
        pop hl
        ret

WaitHex:
        call WaitKey
        cp $30 // check '0' or above
        jr c, WaitHex
        cp $3b // check below ':'
        jr c, WaitHexNumber
        cp $41 // check 'A' or above
        jr c, WaitHex
        cp $47 // check below 'G'
        jr c, WaitHexLetter
        jr WaitHex
WaitHexNumber:
        ld d, a
        rst 16
        ld a, d
        sub $30
        ret
WaitHexLetter:
        ld d, a
        rst 16
        ld a, d
        sub $37
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
        ld d, a
        cp $20 ; check it's above 'space'
        jr c, PrintSkip
        cp $a2 ; and below the last guarnateed UDG (S)
        jr nc, PrintSkip
        rst 16
        jr PrintSpace
PrintSkip:
        ld a, $20
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

ForwardLine:
        ld hl, (Address)
        ld b, $08
ForwardLineInc:
        inc hl
        djnz ForwardLineInc

        ld (Address), hl

        jp UpdateView
        
BackLine:
        ld hl, (Address)
        ld b, $08
BackLineDec:
        dec hl
        djnz BackLineDec

        ld (Address), hl

        jp UpdateView

ForwardPage:
        ld hl, (Address)
        inc h

        ld (Address), hl

        jp UpdateView
        
BackPage:
        ld hl, (Address)
        dec h

        ld (Address), hl

        jp UpdateView
        
ChangeAddress:
        ; clear the address
        ld hl, $0000
        ld (Address), hl

        ; create prompt
        ld a, $16
        rst 16
        ld a, $11
        rst 16
        ld a, $00
        rst 16
        ld a, $2a
        rst 16
        ld a, $20
        rst 16

        call WaitHex
        rla
        rla
        rla
        rla
        ld h, a
        call WaitHex
        add h
        ld h, a
        call WaitHex
        rla
        rla
        rla
        rla
        ld l, a
        call WaitHex
        add l
        and $f8 ; we want to land on a multiple of 8
        ld l, a

        ld (Address), hl

        ; clear prompt
        ld a, $16
        rst 16
        ld a, $11
        rst 16
        ld a, $00
        rst 16
        ld a, $20
        rst 16
        ld a, $20
        rst 16
        ld a, $20
        rst 16
        ld a, $20
        rst 16
        ld a, $20
        rst 16
        ld a, $20
        rst 16

        jp UpdateView

TextToggle:
        ld a, (Flags)
        bit 0, a
        jr z, ToggleTextOn
        res 0, a
        jr ToggleTextGo
ToggleTextOn:
        set 0, a
ToggleTextGo:
        ld (Flags), a
        jp UpdateView

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
        defb $00, $fd
Flags:
        defb $00
