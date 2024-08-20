# Memview

A lightweight utility for browsing and updating the ZX Spectrum memory inside the machine.

Designed to be loaded in whilst you are hacking / editing / playing with other code. The original aims were to

 - Easily browse all RAM in 256 byte pages
 - View in hex and text
 - Make arbitrary data changes
 - Be smaller than 512 bytes
 - Return to BASIC without any side-effects
 - Be recompilable anywhere

As of v1.1, it had reached these goals, with 42 bytes left to play with. It even has some visual niceties.

Now, with v1.2.2 you don't even need to recompile it for it to work anywhere in RAM - it *just works*. Load it in to the address you desire and then call ```USR LoadPoint```.

## Usage

- Cursor keys to move (`$01` / `$10` byte jumps)
- O & P to move RAM page (`$100` byte jumps)
- Space to select address
- Enter to update value, the cusror will automatically move on
- Space during an update to abort it
- T to toggle text / hex (data updates still as hex digits)
- F to find a byte, G to repeat the search forward
- H to find a word (two bytes), J to repeat the search forward
- Z to dump the screen to the ZX printer (```COPY```)
- X to exit, RUN will carry on from the same address

## Notes
- All addresses are in hex
- Screen updates won't persist
- Change the value in `$5c8d`([ATTR_P](https://skoolkid.github.io/rom/asm/5C8D.html)) to change the screen colours.
