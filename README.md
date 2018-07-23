# gb8
Chip-8 Emulator for GameBoy

Compiled with SDCC 3.7.1
```
rom.s holds the CHIP-8 program, change the contents and recompile the project with SDCC
to run any other custom programs

In order to change the Button Mapping, open the main.c file, in line 95 you will find 'gb8_key_map',
change it to any desired layout (Button constants can be found in gb.h)
```
