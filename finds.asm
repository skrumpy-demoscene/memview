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
