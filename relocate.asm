Relocate:
	call $0013 ; call a ret
	dec sp
	dec sp
	ex (sp), hl ; grab the old return address - we now have a PC
	inc sp
	inc sp
	dec hl
	dec hl
	ld (hl), Loop-Relocate-2 ; Rewrite the first instruction to a JR
	dec hl
	ld (hl), $18 ; For convenient reloading after the initial relocate
	ld a, h
	sub $40		; as we're ignoring calls below $4000, we only need to add a certain amount to the offset
	ld d, a
	ld e, l ; DE will be the base to add to each address (ie. the address of Start)
	ld bc, _PROGLEN ; length of our program
RelocateLoop:
	ld a, (hl)
	cp $cd ; is it a call?
	jr z, RelocateUpdate ; if so, update the following bytes
RelocateCont:
	inc hl
	dec bc
	ld a, b
	or c ; check whether we have hit the end of the program
	jr nz, RelocateLoop
	jr Loop
RelocateUpdate:
	ld ix, hl

	ld a, (ix-1) ; check it's not a $cd in a JR
	cp $18
	jr z, RelocateCont
	cp $28
	jr z, RelocateCont
	
	ld a, (ix+2) ; get MSB first
	cp $40
	jr c, RolocateROM ; this is a ROM call so leave it alone
	add d
	ld (ix+2), a

	ld a, (ix+1) ; get LSB
	add e
	jr nc, RelocateC ; it overflowed so increase MSB
	inc (ix+2)
RelocateC:
	ld (ix+1), a
RolocateROM:
	inc hl ; update the counters for the two address bytes
	inc hl
	dec bc
	dec bc

	jr RelocateCont
