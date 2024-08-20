        org	$fd00
        define _FLAGS End
        define _FIND08 End+1
        define _FIND10 End+2
        define _ADDRESS End+4
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

        cp $46
        jr z, Find08 ; find byte
        cp $47
        jr z, Find08Repeat ; repeat find byte

        cp $48
        jr z, Find10 ; find byte
        cp $4a
        jr z, Find10Repeat ; repeat find byte

        cp $54 ; toggle text
        jr z, TextToggle

        cp $20 ; change address
        jr z, ChangeAddress
        cp $0d ; poke address
        jr z, PokeAddress

LoopJump:  ; need this as we're too far to JR directly
        jr Loop

        INCLUDE "commands.asm"
        INCLUDE "output.asm"
        INCLUDE "input.asm"
End:
