ForwardLine:
        ld de, $0008
        call FixHL

        ret
        
BackLine:
        ld de, $fff8
        call FixHL

        ret

ForwardPage:
        ld de, $0080
        call FixHL

        ret
        
BackPage:
        ld de, $ff80
        call FixHL

        ret
        
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

        ret

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

        ret

