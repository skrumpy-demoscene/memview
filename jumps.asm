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
