	DEFINE _DO_RELOCATE 1
	DEFINE _DO_FIND08 1
	DEFINE _DO_FIND10 1

	DEFINE _FLAGS $fefd
	DEFINE _ADDRESS $fefe
	DEFINE _FIND08 $fefa
	DEFINE _FIND10 $fefb
	DEFINE _PROGLEN End-Start-3

	IF (_DO_RELOCATE == 1)
		ORG	$4000
	ELSE
		ORG $fc00
	ENDIF

Start:
	IF (_DO_RELOCATE == 1)
		INCLUDE "relocate.asm"
	ENDIF

Loop:
	call UpdateView
	call WaitKey

	INCLUDE "keys.asm"

LoopJump:  ; need this as we're too far to JR directly
	jr Loop

	INCLUDE "misc.asm"
	INCLUDE "jumps.asm"
	
	IF (_DO_FIND08 == 1)
		INCLUDE "find08.asm"
	ENDIF
	
	IF (_DO_FIND10 == 1)
		INCLUDE "find10.asm"
	ENDIF
	
	INCLUDE "address.asm"
	INCLUDE "output.asm"
	INCLUDE "input.asm"

End:
