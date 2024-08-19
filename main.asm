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
        ld a, $16
        rst 16
        ld a, $12
        rst 16
        ld a, $00
        rst 16

        call WaitKey
        cp $58 // exit
        jp z, Exit
        cp $20 // change address
        jp z, ChangeAddress
        cp $36 // forward by 8
        jp z, ForwardAddress
        cp $37 // back by 8
        jp z, BackAddress

        jr UserInput

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

ForwardAddress:
        ld hl, (Address)
        ld b, $08
ForwardAddressInc:
        inc hl
        djnz ForwardAddressInc

        ld (Address), hl

        jp UpdateView
        
BackAddress:
        ld hl, (Address)
        ld b, $08
BackAddressDec:
        dec hl
        djnz BackAddressDec

        ld (Address), hl

        jp UpdateView
        
ChangeAddress:
        ; clear the address
        ld hl, $0000
        ld (Address), hl

        ; create prompt
        ld a, $16
        rst 16
        ld a, $10
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
        ld l, a

        ld (Address), hl

        ; clear prompt
        ld a, $16
        rst 16
        ld a, $10
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

Exit:
        pop af
        pop de
        ld hl, (Address)
        push hl
        pop bc
        pop hl

        ret

Address:
        defb $00, $fd
