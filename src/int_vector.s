;Vector Table, by el_seyf

.module int_vector

.area _INTERRUPT(ABS)

.globl _vblank_isr
.globl _lcd_stat_isr
.globl _timer_isr
.globl _serial_isr
.globl _joypad_isr
.globl _init_gameboy

.org 0x40
_vblank_vect:
    jp _vblank_isr
    
.org 0x48
_lcd_stat_vect:
    jp _lcd_stat_isr
    
.org 0x50
_timer_vect:
    jp _timer_isr
    
.org 0x58
_serial_vect:
    jp _serial_isr
    
.org 0x60
_joypad_vect:
    jp _joypad_isr
    

.org 0x100
    jp _init_gameboy