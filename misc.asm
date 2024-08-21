FixHL:
	ld hl, (_ADDRESS)
	add hl, de
	ld (_ADDRESS), hl

	jr Loop

TextToggle:
	ld a, (_FLAGS)
	xor $01
	ld (_FLAGS), a

LoopJumpJump:  ; need this as we're too far to JR directly
	jr LoopJump
