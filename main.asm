        org	$1000
        define _FLAGS $fefd
        define _ADDRESS $fefe
Main:
Loop:
        call UpdateView
        call WaitKey

        cp $58 ; exit
        ret z
        
        cp $20 ; change address
        jr z, ChangeAddress
        cp $0d ; poke address
        jr z, PokeAddress

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

        cp $54 ; toggle text
        jr z, TextToggle

LoopJump:
        jr Loop

        INCLUDE "commands.asm"
        INCLUDE "output.asm"
        INCLUDE "input.asm"
        INCLUDE "relocate.asm"
