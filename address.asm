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

LoopJumpJumpJump:  ; need this as we're too far to JR directly
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
	jr z, LoopJumpJumpJump
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
