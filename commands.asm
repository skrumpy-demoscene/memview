FixHL:
        ld hl, (_ADDRESS)
        add hl, de
        ld (_ADDRESS), hl

        jr Loop
        
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

LoopJumpJump:
        jr Loop ; need this as we're too far to JR directly

PokeAddress:
        ; create prompt
        ld de, $1106
        call PrintAt
        ld a, $3e
        rst 16

        call WaitHex ; wait for first digit
        cp $ff
        jr z, Loop
        call SlideA
        ld h, a
        
        call WaitHex ; wait for second digit
        cp $ff
        jr z, Loop
        add h

        ld hl, (_ADDRESS)
        ld (hl), a ; update data
        inc hl
        ld (_ADDRESS), hl

        jr Loop

TextToggle:
        ld a, (_FLAGS)
        xor $01
        ld (_FLAGS), a

        jr LoopJump

ChangeAddress:
        ; clear the address
        ld hl, $0000

        ; create prompt
        ld de, $1100
        call PrintAt
        ld a, $2a
        rst 16

        call WaitHex ; wait for first digit
        cp $ff
        jr z, LoopJump
        call SlideA
        ld h, a

        call WaitHex ; wait for second digit
        cp $ff
        jr z, LoopJump
        add h
        ld h, a

        call WaitHex ; wait for first digit
        cp $ff
        jr z, LoopJumpJump
        call SlideA
        ld l, a

        call WaitHex ; wait for second digit
        cp $ff
        jr z, LoopJumpJump
        add l
        ld l, a

        ld (_ADDRESS), hl

        jr LoopJumpJump

SlideA:
        sla a
        sla a
        sla a
        sla a
        ret
