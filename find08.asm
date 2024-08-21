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
