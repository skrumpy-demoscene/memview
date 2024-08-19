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
        ld de, $0008
        call FixHL

        ret
        
BackLine:
        ld de, $fff8
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
        
ChangeAddress:
        ; clear the address
        ld hl, $0000
        ld (Address), hl

        ; create prompt
        ld a, $16
        rst 16
        ld a, $12
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

        ld (Address), hl

        ; clear prompt
        ld a, $16
        rst 16
        ld a, $12
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

