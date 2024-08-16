UserInput:
        call WaitKey

        cp $58 ; exit
        jp z, Exit
        
        cp $20 ; change address
        call z, ChangeAddress
        cp $0d ; poke address
        call z, PokeAddress

        cp $09 ; forward by 1
        call z, ForwardAddr
        cp $08 ; back by 1
        call z, BackAddr

        cp $0a ; forward by 16
        call z, ForwardLine
        cp $0b ; back by 16
        call z, BackLine

        cp $50 ; forward by 256
        call z, ForwardPage
        cp $4f ; back by 256
        call z, BackPage

        cp $54 ; toggle text
        call z, TextToggle

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
        res 5, a
        ld ($5C3B), a
        ld a, ($5C08)
        push af

WaitKeyUp:
; wait for the key to be released
        ld a, $00
        ld ($5C08), a
        call $02BF
        ld a, ($5C08)
        cp $00
        jr nz, WaitKeyUp

        pop af
        pop hl

        ret

WaitHex:
        call WaitKey
        cp $20 ; abort!
        jr z, WaitHexAbort
        cp $30 ; check '0' or above
        jr c, WaitHex
        cp $3b ; check below ':'
        jr c, WaitHexNumber
        cp $41 ; check 'A' or above
        jr c, WaitHex
        cp $47 ; check below 'G'
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
WaitHexAbort:
        ld a, $ff ; anything that detects an impossible digit to display will know to abort
        ret
