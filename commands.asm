FixHL:
        ld hl, (Address)
        add hl, de
        ld (Address), hl

        ret
        
ForwardAddr:
        ld de, $0001
        call FixHL

        ret
        
BackAddr:
        ld de, $ffff
        call FixHL

        ret

ForwardLine:
        ld de, $0010
        call FixHL

        ret
        
BackLine:
        ld de, $fff0
        call FixHL

        ret

ForwardPage:
        ld de, $0100
        call FixHL

        ret
        
BackPage:
        ld de, $ff00
        call FixHL

        ret

PokeAddress:
        ; create prompt
        ld a, $16
        rst 16
        ld a, $11
        rst 16
        ld a, $08
        rst 16
        ld a, $3e
        rst 16
        ld a, $20
        rst 16

        call WaitHex
        cp $ff
        jr z, EndPokeAddress
        sla a
        sla a
        sla a
        sla a
        ld h, a
        
        call WaitHex
        cp $ff
        jr z, EndPokeAddress
        add h

        ld hl, (Address)
        ld (hl), a
        inc hl
        ld (Address), hl

EndPokeAddress:
        ; clear prompt
        ld a, $16
        rst 16
        ld a, $11
        rst 16
        ld a, $08
        rst 16
        ld a, $20
        rst 16
        ld a, $20
        rst 16

        ret

ChangeAddress:
        ; clear the address
        ld hl, $0000

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
        cp $ff
        jr z, EndChangeAddress
        sla a
        sla a
        sla a
        sla a
        ld h, a

        call WaitHex
        cp $ff
        jr z, EndChangeAddress
        add h
        ld h, a

        call WaitHex
        cp $ff
        jr z, EndChangeAddress
        sla a
        sla a
        sla a
        sla a
        ld l, a

        call WaitHex
        cp $ff
        jr z, EndChangeAddress
        add l
        ld l, a

        ld (Address), hl

EndChangeAddress
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

        ret

TextToggle:
        ld a, (Flags)
        bit 4, a
        jr z, ToggleTextOn
        res 4, a
        jr ToggleTextGo
ToggleTextOn:
        set 4, a
ToggleTextGo:
        ld (Flags), a

        ret

