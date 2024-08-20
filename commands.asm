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

TextToggle:
        ld a, (_FLAGS)
        xor $01
        ld (_FLAGS), a

LoopJumpJump:  ; need this as we're too far to JR directly
        jr LoopJump

Find08:
        call PromptData
        ld (_FIND08), a
Find08Start:
        ld c, a
        ld hl, (_ADDRESS)
Find08Loop:
        inc hl
        ld a, (hl)
        cp c
        jr nz, Find08Loop

        ld (_ADDRESS), hl
        jr LoopJumpJump
        
Find08Repeat:
        ld a, (_FIND08)
        jr Find08Start

Find10:
        call PromptAddress
        ld (_FIND10), hl
Find10Start:
        ld bc, hl
        ld hl, (_ADDRESS)
Find10Loop:
        inc hl
        ld a, (hl)
        cp b
        jr z, Find10Found
        jr Find10Loop
Find10Found:
        inc hl
        ld a, (hl)
        dec hl
        cp c
        jr nz, Find10Loop
        ld (_ADDRESS), hl
        jr LoopJumpJump
Find10Repeat:
        ld hl, (_FIND10)
        jr Find10Start

ChangeAddress:
        call PromptAddress
        ld (_ADDRESS), hl
        jr LoopJumpJump

PokeAddress:
        call PromptData
        ld hl, (_ADDRESS)
        ld (hl), a ; update data
        inc hl
        ld (_ADDRESS), hl

        jr LoopJumpJump

PromptData:
        ld de, $1106
        call PrintAt
        ld a, $3e
        rst 16

        call WaitHex ; wait for first digit
        cp $20
        jr z, LoopJumpJump
        call SlideA
        ld h, a
        
        call WaitHex ; wait for second digit
        cp $20
LoopJumpJumpJump:  ; need this as we're too far to JR directly
        jr z, LoopJumpJump
        add h

        ret

PromptAddress:
        ld de, $1100
        call PrintAt
        ld a, $2a
        rst 16

        call WaitHex ; wait for first digit
        cp $20
        jr z, LoopJumpJumpJump
        call SlideA
        ld h, a

        call WaitHex ; wait for second digit
        cp $20
        jr z, LoopJumpJumpJump
        add h
        ld h, a

        call WaitHex ; wait for first digit
        cp $20
        jr z, LoopJumpJumpJump
        call SlideA
        ld l, a

        call WaitHex ; wait for second digit
        cp $20
        jr z, LoopJumpJumpJump
        add l
        ld l, a

        ret

SlideA:
        add a, a
        add a, a
        add a, a
        add a, a
        ret
