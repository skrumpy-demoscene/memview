        org	$1000
        define _ADDRESS $fefe
Main:
Loop:
        call UpdateView
        call WaitKey

        cp $58 ; exit
        ret z
        
        cp $20 ; change address
        call z, ChangeAddress
        cp $0d ; poke address
        call z, PokeAddress

        cp $09 ; forward by 1
        call z, ForwardAddr
        cp $08 ; back by 1
        call z, BackAddr

        cp $0a ; forward by 16
        call z, ForwardLine
        cp $0b ; back by 16
        call z, BackLine

        cp $50 ; forward by 256
        call z, ForwardPage
        cp $4f ; back by 256
        call z, BackPage

        cp $54 ; toggle text
        call z, TextToggle

        jr Loop

        INCLUDE "output.asm"
        INCLUDE "commands.asm"
        INCLUDE "input.asm"
        INCLUDE "relocate.asm"
