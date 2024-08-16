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

 Now, with v1.2 you don't even need to recompile it for it to work anywhere in RAM - it *just works*. Load it in to the address you desire and then call ```USR (LoadPoint + Program Length)```. As of v1.2, the program length is 448 bytes, so if you load it in at 40000, you would run ```RANDOMIZE USR 40448``` to relocate and then ```RANDOMIZE USR 40000``` to run. If I can find two bytes from somewhere, I'll make this automatic.

## Usage

- Cursor keys to move (`$01` / `$10` byte jumps)
- O & P to move RAM page (`$100` byte jumps)
- Space to select address
- Enter to update value, the cusror will automatically move on
- Space during an update to abort it
- T to toggle text / hex (data updates still as hex digits)
- X to exit, RUN will carry on from the same address

## Notes
- You must relocate before running (unless you have somehow loaded it in at ```$1000``` / ```4096```!)
- All addresses are in hex
- Screen updates won't persist
- Change the value in `$5c8d`([ATTR_P](https://skoolkid.github.io/rom/asm/5C8D.html)) to change the screen colours.
