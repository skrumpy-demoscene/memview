        org	$fd00
        define _FLAGS $fefc
        define _FIND08 $fefd
        define _ADDRESS $fefe
Start:
Loop:
        call UpdateView
        call WaitKey

        cp $58 ; exit
        ret z
        
        cp $5a ; COPY screen
        call z, $0eac

        cp $09 ; forward by 1
        jr z, ForwardAddr
        cp $08 ; back by 1
        jr z, BackAddr

        cp $0a ; forward by 16
        jr z, ForwardLine
        cp $0b ; back by 16
        jr z, BackLine

        cp $50 ; forward by 256
        jr z, ForwardPage
        cp $4f ; back by 256
        jr z, BackPage

        cp $20 ; change address
        jr z, ChangeAddress
        cp $0d ; poke address
        jr z, PokeAddress

        cp $46
        jr z, Find08 ; find byte
        cp $47
        jr z, Find08Repeat ; repeat find byte

        cp $54 ; toggle text
        jr z, TextToggle

LoopJump:  ; need this as we're too far to JR directly
        jr Loop

        INCLUDE "commands.asm"
        INCLUDE "output.asm"
        INCLUDE "input.asm"
End:
