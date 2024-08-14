FixHL:
        ld hl, (Address)
        add hl, de
        ld (Address), hl

        ret
        
ForwardAddr:
        ld de, $0001
        jr FixHL
        
BackAddr:
        ld de, $ffff
        jr FixHL

ForwardLine:
        ld de, $0010
        jr FixHL
        
BackLine:
        ld de, $fff0
        jr FixHL

ForwardPage:
        ld de, $0100
        jr FixHL
        
BackPage:
        ld de, $ff00
        jr FixHL

PokeAddress:
        ; create prompt
        ld de, $1106
        call PrintAt
        ld a, $3e
        rst 16

        call WaitHex ; wait for first digit
        cp $ff
        jr z, EndPokeAddress
        call SlideA
        ld h, a
        
        call WaitHex ; wait for second digit
        cp $ff
        jr z, EndPokeAddress
        add h

        ld hl, (Address)
        ld (hl), a ; update data
        inc hl
        ld (Address), hl

EndPokeAddress:
        ; clear prompt
        ld de, $1106
        call PrintAt
        ld a, $20
        rst 16

        ret

WaitForDigit:
        call WaitHex ; wait for first digit
        cp $ff
        jr z, EndChangeAddress

        ret
ChangeAddress:
        ; clear the address
        ld hl, $0000

        ; create prompt
        ld de, $1100
        call PrintAt
        ld a, $2a
        rst 16

        call WaitForDigit
        call SlideA
        ld h, a

        call WaitForDigit
        add h
        ld h, a

        call WaitForDigit
        call SlideA
        ld l, a

        call WaitForDigit
        add l
        ld l, a

        ld (Address), hl

EndChangeAddress
        ; clear prompt
        ld de, $1100
        call PrintAt
        ld a, $20
        rst 16

        ret

TextToggle:
        ; self-modifying code, changes the result of the $cp $00 and thus the Z flag
        ld a, (UpdateLoopCol+1)
        cpl
        ld (UpdateLoopCol+1), a

        ret

SlideA:
        sla a
        sla a
        sla a
        sla a
        ret
