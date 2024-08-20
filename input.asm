WaitKey:
        push hl
WaitKeyDown:
        ;  set CAPS
        ld hl, $5C6A
        set 3, (hl)

        ; wait for keypress
        halt
        rst $38 ; scan for keypress
        ld hl, $5C3B
        bit 5, (hl)
        jr z, WaitKeyDown
        res 5, (hl)
        ld hl, $5C08
        ld a, (hl)
        push af

WaitKeyUp:
        ; wait for the key to be released
        ld (hl), h
        rst $38 ; scan for keypress
        ld a, (hl)
        cp h
        jr nz, WaitKeyUp

        pop af
        pop hl

        ret

WaitHex:
        call WaitKey
        cp $20 ; abort!
        ret z
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
