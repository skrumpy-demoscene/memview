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
        inc hl
Find08Loop:
        ld a, (hl)
        cp c
        jr z, Find08Found
        inc hl
        jr Find08Loop
Find08Found:
        ld (_ADDRESS), hl
        jr LoopJumpJump
Find08Repeat:
        ld a, (_FIND08)
        jr Find08Start

PokeAddress:
        call PromptData
        ld hl, (_ADDRESS)
        ld (hl), a ; update data
        inc hl
        ld (_ADDRESS), hl

        jr LoopJumpJump

ChangeAddress:
        call PromptAddress
        ld (_ADDRESS), hl
        jr LoopJumpJump

PromptData:
        ld de, $1106
        call PrintAt
        ld a, $3e
        rst 16

        call WaitHex ; wait for first digit
        cp $ff
        jr z, LoopJumpJump
        call SlideA
        ld h, a
        
        call WaitHex ; wait for second digit
        cp $ff
        jr z, LoopJumpJump
        add h

        ret

PromptAddress:
        ld hl, $0000 ; clear the address

        ld de, $1100
        call PrintAt
        ld a, $2a
        rst 16

        call WaitHex ; wait for first digit
        cp $ff
        jr z, LoopJumpJump
        call SlideA
        ld h, a

        call WaitHex ; wait for second digit
        cp $ff
        jr z, LoopJumpJump
        add h
        ld h, a

        call WaitHex ; wait for first digit
        cp $ff
LoopJumpJumpJump:  ; need this as we're too far to JR directly
        jr z, LoopJumpJump
        call SlideA
        ld l, a

        call WaitHex ; wait for second digit
        cp $ff
        jr z, LoopJumpJumpJump
        add l
        ld l, a

        ret

SlideA:
        sla a
        sla a
        sla a
        sla a
        ret
