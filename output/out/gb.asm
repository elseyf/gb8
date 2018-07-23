;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.7.1 #10455 (MINGW64)
;--------------------------------------------------------
	.module gb
	.optsdcc -mgbz80
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _hblank_transfer_counter
	.globl _vblank_happened
	.globl _offset_y
	.globl _offset_x
	.globl _scroll_y
	.globl _scroll_x
	.globl _old_joy0
	.globl _joy0
	.globl _obj_slot
	.globl _obj_pal1
	.globl _obj_pal0
	.globl _bg_pal
	.globl _vram_transfer_addr
	.globl _vram_transfer_buffer
	.globl _vram_transfer_size
	.globl _obj
	.globl _vblank_isr
	.globl _lcd_stat_isr
	.globl _timer_isr
	.globl _serial_isr
	.globl _joypad_isr
	.globl _init_gameboy
	.globl _set_bg_map_select
	.globl _set_win_map_select
	.globl _fastcpy
	.globl _fill
	.globl _set_bg_chr
	.globl _set_bg_map
	.globl _set_bg_map_tile
	.globl _update_bg_map_tile
	.globl _set_win_map
	.globl _set_win_map_tile
	.globl _update_win_map_tile
	.globl _set_obj_chr
	.globl _set_obj
	.globl _copy_to_oam_obj
	.globl _read_joypad
	.globl _key_push
	.globl _key_hold
	.globl _key_release
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _DATA
_obj::
	.ds 160
_vram_transfer_size::
	.ds 1
_vram_transfer_buffer::
	.ds 128
_vram_transfer_addr::
	.ds 2
_bg_pal::
	.ds 1
_obj_pal0::
	.ds 1
_obj_pal1::
	.ds 1
_obj_slot::
	.ds 1
_joy0::
	.ds 1
_old_joy0::
	.ds 1
_scroll_x::
	.ds 1
_scroll_y::
	.ds 1
_offset_x::
	.ds 1
_offset_y::
	.ds 1
_vblank_happened::
	.ds 1
_hblank_transfer_counter	=	0xffc0
;--------------------------------------------------------
; absolute external ram data
;--------------------------------------------------------
	.area _DABS (ABS)
;--------------------------------------------------------
; global & static initialisations
;--------------------------------------------------------
	.area _HOME
	.area _GSINIT
	.area _GSFINAL
	.area _GSINIT
;--------------------------------------------------------
; Home
;--------------------------------------------------------
	.area _HOME
	.area _HOME
;--------------------------------------------------------
; code
;--------------------------------------------------------
	.area _CODE
;src/gb.c:25: void vblank_isr() __critical __interrupt __naked {
;	---------------------------------
; Function vblank_isr
; ---------------------------------
_vblank_isr::
;src/gb.c:100: __endasm;
	push	af
	push	bc
	push	de
	push	hl
	ld	(_sp_buffer), sp
	ld	sp, #_gb8_display
	ld	hl, #0x8000
	    0$:
	xor a
	ldh	(0xFF0F), a
	halt
	nop
	.rept	110
	pop	de
	ld	a, d
	ld	(hl+), a
	ld	a, e
	ld	(hl+), a ;36 per rept
	.endm	;+3960
	ld	a, (_scroll_x)
	ldh	(0xFF43), a
	ld	a, (_scroll_y)
	ldh	(0xFF42), a
;ld	a, (_offset_x)
;ldh	(0xFF4B), a
	ld	a, (_offset_y)
	ldh	(0xFF4A), a
	ld	a, (_bg_pal)
	ldh	(0xFF47), a ;+112 ;old +140
	ld	c, #59 ;+8
	.rept	5
	nop
	.endm	;+20
	    1$:
	.rept	65
	nop
	.endm	;+260
	.rept	5
	pop	de
	ld	a, d
	ld	(hl+), a
	ld	a, e
	ld	(hl+), a ;36 per rept
	.endm	;+180
	dec	c
	jr	nz, 1$ ;+12
	ld	a, #1
	ld	(_vblank_happened), a
	xor	a
	ldh	(_hblank_transfer_counter), a
	ldh	(0xFF0F), a
	ld	sp, #_sp_buffer
	pop	hl
	ld	sp, hl
	pop	hl
	pop	de
	pop	bc
	pop	af
	reti
;src/gb.c:101: }
;src/gb.c:102: void lcd_stat_isr() __interrupt __critical __naked {
;	---------------------------------
; Function lcd_stat_isr
; ---------------------------------
_lcd_stat_isr::
;src/gb.c:118: __endasm;
	push	af
	ldh	a, (0xFF44)
	cp	#0x63
	jr	nz, 0$
	ld	a, #0xCC
	ldh	(0xFF47), a
	    0$:
	ldh a, (0xFF44)
	rra
	jr	c, 1$
	ldh	a, (0xFF42)
	dec	a
	ldh	(0xFF42), a
	    1$:
	pop af
	reti
;src/gb.c:119: }
;src/gb.c:120: void timer_isr() __critical __interrupt {;}
;	---------------------------------
; Function timer_isr
; ---------------------------------
_timer_isr::
	push	af
	push bc
	push de
	push hl
	pop	hl
	pop de
	pop bc
	pop af
	reti
;src/gb.c:121: void serial_isr() __interrupt {;}
;	---------------------------------
; Function serial_isr
; ---------------------------------
_serial_isr::
	ei
	push	af
	push bc
	push de
	push hl
	pop	hl
	pop de
	pop bc
	pop af
	ret
;src/gb.c:122: void joypad_isr() __interrupt {;}
;	---------------------------------
; Function joypad_isr
; ---------------------------------
_joypad_isr::
	ei
	push	af
	push bc
	push de
	push hl
	pop	hl
	pop de
	pop bc
	pop af
	ret
;src/gb.c:124: void init_gameboy() __naked {
;	---------------------------------
; Function init_gameboy
; ---------------------------------
_init_gameboy::
;src/gb.c:142: __endasm;
	.globl	_main
	    1$:
	ld hl, #0xC000 ;clear ((uint8_t*)0xC000) at
	ld	de, #0x2000 ;0xC000 - 0xDFFF
	xor	a
	    0$:
	ld (hl+), a
	dec	de
	cp	e
	jr	nz, 0$
	cp	d
	jr	nz, 0$
	ld	sp, #0xE000 ;Stack points to RAM
	jp	_main ;actual start address
;src/gb.c:143: }
;src/gb.c:145: void set_bg_map_select(bool _offset){
;	---------------------------------
; Function set_bg_map_select
; ---------------------------------
_set_bg_map_select::
;src/gb.c:146: if(_offset) *reg(REG_LCDC) |= LCDC_BG_MAP_SELECT;
	ld	de, #0xff40
	ld	a,(de)
	ld	c, a
	ldhl	sp,#2
	bit	0, (hl)
	jr	Z,00102$
	ld	b, #0x00
	set	3, c
	ld	hl, #0xff40
	ld	(hl), c
	ret
00102$:
;src/gb.c:147: else        *reg(REG_LCDC) &= ~LCDC_BG_MAP_SELECT;
	res	3, c
	ld	hl, #0xff40
	ld	(hl), c
;src/gb.c:148: }
	ret
;src/gb.c:149: void set_win_map_select(bool _offset){
;	---------------------------------
; Function set_win_map_select
; ---------------------------------
_set_win_map_select::
;src/gb.c:150: if(_offset) *reg(REG_LCDC) |= LCDC_WIN_MAP_SELECT;
	ld	de, #0xff40
	ld	a,(de)
	ld	c, a
	ldhl	sp,#2
	bit	0, (hl)
	jr	Z,00102$
	ld	b, #0x00
	set	6, c
	ld	hl, #0xff40
	ld	(hl), c
	ret
00102$:
;src/gb.c:151: else        *reg(REG_LCDC) &= ~LCDC_WIN_MAP_SELECT;
	res	6, c
	ld	hl, #0xff40
	ld	(hl), c
;src/gb.c:152: }
	ret
;src/gb.c:155: void fastcpy(void* _dst, void* _src, uint16_t _size){
;	---------------------------------
; Function fastcpy
; ---------------------------------
_fastcpy::
;src/gb.c:189: __endasm;
	dst	= 2
	src	= 4
	size	= 6
	ldhl	sp, #size ;bc = _size
	ld	a, (hl+)
	ld	b, (hl)
	ld	c, a
	xor	a
	or	b
	or	c
	jr	z, 1$
	ldhl	sp, #src ;de = _src
	ld	a, (hl+)
	ld	d, (hl)
	ld	e, a
	ldhl	sp, #dst ;hl = _dst
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	        0$:
	ld a, (de) ;for(;bc > 0; bc--) *(hl++) = *(de++)
	ld	(hl+), a
	inc	de
	dec	bc
	xor	a
	or	b
	or	c
	jr	nz, 0$
	        1$:
;src/gb.c:190: }
	ret
;src/gb.c:192: void fill(void* _dst, uint8_t _val, uint16_t _size){
;	---------------------------------
; Function fill
; ---------------------------------
_fill::
;src/gb.c:223: __endasm;
	dst	= 2
	val	= 4
	size	= 5
	ldhl	sp, #size ;bc = size
	ld	a, (hl+)
	ld	b, (hl)
	ld	c, a
	xor	a
	or	b
	or	c
	jr	z, 1$
	ldhl	sp, #val ;e = val
	ld	e, (hl)
	ldhl	sp, #dst ;hl = dst
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	        0$:
	ld a, e ;for() *(hl++) = e
	ld	(hl+), a
	dec	bc
	xor	a
	or	b
	or	c
	jr	nz, 0$
	        1$:
;src/gb.c:224: }
	ret
;src/gb.c:226: void set_bg_chr(uint8_t* _data, uint16_t _addr, uint16_t _size){
;	---------------------------------
; Function set_bg_chr
; ---------------------------------
_set_bg_chr::
	add	sp, #-2
;src/gb.c:227: fastcpy(BG_CHR + _addr, _data, _size);
	ldhl	sp,#4
	ld	a, (hl+)
	ld	e, (hl)
	ldhl	sp,#0
	ld	(hl+), a
	ld	(hl), e
	ldhl	sp,#(7 - 1)
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	ld	hl, #0x8000
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,#8
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,#2
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	push	bc
	call	_fastcpy
	add	sp, #6
;src/gb.c:228: }
	add	sp, #2
	ret
;src/gb.c:230: void set_bg_map(uint8_t* _data, uint16_t _addr, uint16_t _size){
;	---------------------------------
; Function set_bg_map
; ---------------------------------
_set_bg_map::
	add	sp, #-2
;src/gb.c:231: fastcpy(BG_MAP + _addr, _data, _size);
	ldhl	sp,#4
	ld	a, (hl+)
	ld	e, (hl)
	ldhl	sp,#0
	ld	(hl+), a
	ld	(hl), e
	ldhl	sp,#(7 - 1)
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	ld	hl, #0x9800
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,#8
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,#2
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	push	bc
	call	_fastcpy
	add	sp, #6
;src/gb.c:232: }
	add	sp, #2
	ret
;src/gb.c:234: void set_bg_map_tile(uint16_t _addr, uint8_t _tile){
;	---------------------------------
; Function set_bg_map_tile
; ---------------------------------
_set_bg_map_tile::
;src/gb.c:235: *reg(BG_MAP + _addr) = _tile;
	ldhl	sp,#(3 - 1)
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	ld	hl, #0x9800
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,#4
	ld	a, (hl)
	ld	(bc), a
;src/gb.c:236: }
	ret
;src/gb.c:238: void update_bg_map_tile(uint16_t _addr, uint8_t _tile){
;	---------------------------------
; Function update_bg_map_tile
; ---------------------------------
_update_bg_map_tile::
	add	sp, #-2
;src/gb.c:239: vram_transfer_buffer[(vram_transfer_size << 2) + 0] = (BG_MAP_ADDR + _addr) & 0xFF;
	ld	hl, #_vram_transfer_size
	ld	c, (hl)
	ld	b, #0x00
	sla	c
	rl	b
	sla	c
	rl	b
	ld	hl, #_vram_transfer_buffer
	add	hl, bc
	ld	c, l
	ld	b, h
	ldhl	sp,#4
	ld	a, (hl)
	ld	(bc), a
;src/gb.c:240: vram_transfer_buffer[(vram_transfer_size << 2) + 1] = ((BG_MAP_ADDR + _addr) >> 8) & 0xFF;
	ld	hl, #_vram_transfer_size
	ld	c, (hl)
	ld	b, #0x00
	sla	c
	rl	b
	sla	c
	rl	b
	inc	bc
	ld	hl, #_vram_transfer_buffer
	add	hl, bc
	ld	c, l
	ld	b, h
	ldhl	sp,#(5 - 1)
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	ld	hl, #0x9800
	add	hl, de
	inc	sp
	inc	sp
	push	hl
	ldhl	sp,#1
	ld	e, (hl)
	ld	d, #0x00
	ld	a, e
	ld	(bc), a
;src/gb.c:241: vram_transfer_buffer[(vram_transfer_size << 2) + 2] = 0x00;
	ld	hl, #_vram_transfer_size
	ld	c, (hl)
	ld	b, #0x00
	sla	c
	rl	b
	sla	c
	rl	b
	inc	bc
	inc	bc
	ld	hl, #_vram_transfer_buffer
	add	hl, bc
	ld	c, l
	ld	b, h
	xor	a, a
	ld	(bc), a
;src/gb.c:242: vram_transfer_buffer[(vram_transfer_size << 2) + 3] = _tile;
	ld	hl, #_vram_transfer_size
	ld	c, (hl)
	ld	b, #0x00
	sla	c
	rl	b
	sla	c
	rl	b
	inc	bc
	inc	bc
	inc	bc
	ld	hl, #_vram_transfer_buffer
	add	hl, bc
	ld	c, l
	ld	b, h
	ldhl	sp,#6
	ld	a, (hl)
	ld	(bc), a
;src/gb.c:243: vram_transfer_size++;
	ld	hl, #_vram_transfer_size
	inc	(hl)
;src/gb.c:244: }
	add	sp, #2
	ret
;src/gb.c:246: void set_win_map(uint8_t* _data, uint16_t _addr, uint16_t _size){
;	---------------------------------
; Function set_win_map
; ---------------------------------
_set_win_map::
	add	sp, #-2
;src/gb.c:247: fastcpy(WIN_MAP + _addr, _data, _size);
	ldhl	sp,#4
	ld	a, (hl+)
	ld	e, (hl)
	ldhl	sp,#0
	ld	(hl+), a
	ld	(hl), e
	ldhl	sp,#(7 - 1)
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	ld	hl, #0x9c00
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,#8
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,#2
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	push	bc
	call	_fastcpy
	add	sp, #6
;src/gb.c:248: }
	add	sp, #2
	ret
;src/gb.c:250: void set_win_map_tile(uint16_t _addr, uint8_t _tile){
;	---------------------------------
; Function set_win_map_tile
; ---------------------------------
_set_win_map_tile::
;src/gb.c:251: *reg(WIN_MAP + _addr) = _tile;
	ldhl	sp,#(3 - 1)
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	ld	hl, #0x9c00
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,#4
	ld	a, (hl)
	ld	(bc), a
;src/gb.c:252: }
	ret
;src/gb.c:254: void update_win_map_tile(uint16_t _addr, uint8_t _tile){
;	---------------------------------
; Function update_win_map_tile
; ---------------------------------
_update_win_map_tile::
	add	sp, #-2
;src/gb.c:255: vram_transfer_buffer[(vram_transfer_size << 2) + 0] = (WIN_MAP_ADDR + _addr) & 0xFF;
	ld	hl, #_vram_transfer_size
	ld	c, (hl)
	ld	b, #0x00
	sla	c
	rl	b
	sla	c
	rl	b
	ld	hl, #_vram_transfer_buffer
	add	hl, bc
	ld	c, l
	ld	b, h
	ldhl	sp,#4
	ld	a, (hl)
	ld	(bc), a
;src/gb.c:256: vram_transfer_buffer[(vram_transfer_size << 2) + 1] = ((WIN_MAP_ADDR + _addr) >> 8) & 0xFF;
	ld	hl, #_vram_transfer_size
	ld	c, (hl)
	ld	b, #0x00
	sla	c
	rl	b
	sla	c
	rl	b
	inc	bc
	ld	hl, #_vram_transfer_buffer
	add	hl, bc
	ld	c, l
	ld	b, h
	ldhl	sp,#(5 - 1)
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	ld	hl, #0x9c00
	add	hl, de
	inc	sp
	inc	sp
	push	hl
	ldhl	sp,#1
	ld	e, (hl)
	ld	d, #0x00
	ld	a, e
	ld	(bc), a
;src/gb.c:257: vram_transfer_buffer[(vram_transfer_size << 2) + 2] = 0x00;
	ld	hl, #_vram_transfer_size
	ld	c, (hl)
	ld	b, #0x00
	sla	c
	rl	b
	sla	c
	rl	b
	inc	bc
	inc	bc
	ld	hl, #_vram_transfer_buffer
	add	hl, bc
	ld	c, l
	ld	b, h
	xor	a, a
	ld	(bc), a
;src/gb.c:258: vram_transfer_buffer[(vram_transfer_size << 2) + 3] = _tile;
	ld	hl, #_vram_transfer_size
	ld	c, (hl)
	ld	b, #0x00
	sla	c
	rl	b
	sla	c
	rl	b
	inc	bc
	inc	bc
	inc	bc
	ld	hl, #_vram_transfer_buffer
	add	hl, bc
	ld	c, l
	ld	b, h
	ldhl	sp,#6
	ld	a, (hl)
	ld	(bc), a
;src/gb.c:259: vram_transfer_size++;
	ld	hl, #_vram_transfer_size
	inc	(hl)
;src/gb.c:260: }
	add	sp, #2
	ret
;src/gb.c:262: void set_obj_chr(uint8_t* _data, uint16_t _addr, uint16_t _size){
;	---------------------------------
; Function set_obj_chr
; ---------------------------------
_set_obj_chr::
	add	sp, #-2
;src/gb.c:263: fastcpy(OBJ_CHR + _addr, _data, _size);
	ldhl	sp,#4
	ld	a, (hl+)
	ld	e, (hl)
	ldhl	sp,#0
	ld	(hl+), a
	ld	(hl), e
	ldhl	sp,#(7 - 1)
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	ld	hl, #0x8000
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,#8
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,#2
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	push	bc
	call	_fastcpy
	add	sp, #6
;src/gb.c:264: }
	add	sp, #2
	ret
;src/gb.c:266: void set_obj(obj_t* _obj, uint8_t _x, uint8_t _y, uint8_t _tile, uint8_t _attr){
;	---------------------------------
; Function set_obj
; ---------------------------------
_set_obj::
	add	sp, #-2
;src/gb.c:267: _obj->x     = _x;
	ldhl	sp,#4
	ld	a, (hl+)
	ld	e, (hl)
	ldhl	sp,#0
	ld	(hl+), a
	ld	(hl), e
	pop	bc
	push	bc
	inc	bc
	ldhl	sp,#6
	ld	a, (hl)
	ld	(bc), a
;src/gb.c:268: _obj->y     = _y;
	pop	de
	push	de
	inc	hl
	ld	a, (hl)
	ld	(de), a
;src/gb.c:269: _obj->tile  = _tile;
	pop	bc
	push	bc
	inc	bc
	inc	bc
	inc	hl
	ld	a, (hl)
	ld	(bc), a
;src/gb.c:270: _obj->attr  = _attr;
	pop	bc
	push	bc
	inc	bc
	inc	bc
	inc	bc
	inc	hl
	ld	a, (hl)
	ld	(bc), a
;src/gb.c:271: }
	add	sp, #2
	ret
;src/gb.c:273: uint8_t copy_to_oam_obj(obj_t* _obj, uint8_t _slot){
;	---------------------------------
; Function copy_to_oam_obj
; ---------------------------------
_copy_to_oam_obj::
;src/gb.c:309: __endasm;
	obj	= 2
	slot	= 4
	ldhl	sp, #obj
	ld	a, (hl+)
	ld	d, (hl)
	ld	e, a
	ldhl	sp, #slot
	ld	l, (hl)
	ld	h, #0
	add	hl, hl
	add	hl, hl
	ld	bc, #_obj
	add	hl, bc
	ld	a, (de) ;copy Y
	inc	de
	add	#16
	ld	(hl+), a
	ld	a, (de) ;copy X
	inc	de
	add	#8
	ld	(hl+), a
	ld	a, (de) ;copy Tile
	inc	de
	ld	(hl+), a
	ld	a, (de) ;copy Attr
	ld	(hl), a
	ldhl	sp, #slot
	ld	e, (hl)
	inc	e
;src/gb.c:310: }
	ret
;src/gb.c:312: void read_joypad(){
;	---------------------------------
; Function read_joypad
; ---------------------------------
_read_joypad::
;src/gb.c:339: __endasm;
	ld	hl, #0xFF00
	ld	a, (_joy0)
	ld	(_old_joy0), a
	ld	(hl), #0x20
	ld	c, (hl)
	ld	c, (hl)
	ld	c, (hl)
	ld	a, (hl)
	swap	a
	and	#0xF0
	ld	b, a
	ld	(hl), #0x10
	ld	c, (hl)
	ld	c, (hl)
	ld	c, (hl)
	ld	a, (hl)
	and	#0x0F
	or	b
	ld	(hl), #0x30
	cpl
	ld	(_joy0), a
;src/gb.c:340: }
	ret
;src/gb.c:341: bool key_push(uint8_t _key){return (!(old_joy0 & _key) && (joy0 & _key));}
;	---------------------------------
; Function key_push
; ---------------------------------
_key_push::
	ld	hl, #_old_joy0
	ld	a, (hl)
	ldhl	sp,#2
	and	a,(hl)
	jr	NZ,00103$
	ld	hl, #_joy0
	ld	a, (hl)
	ldhl	sp,#2
	and	a,(hl)
	jr	NZ,00104$
00103$:
	xor	a, a
	jr	00105$
00104$:
	ld	a, #0x01
00105$:
	ld	e, a
	ret
;src/gb.c:342: bool key_hold(uint8_t _key){return (joy0 & _key);}
;	---------------------------------
; Function key_hold
; ---------------------------------
_key_hold::
	ld	hl, #_joy0
	ld	a, (hl)
	ldhl	sp,#2
	and	a, (hl)
	ld	c, a
	xor	a, a
	cp	a, c
	rla
	ld	e, a
	ret
;src/gb.c:343: bool key_release(uint8_t _key){return ((old_joy0 & _key) && !(joy0 & _key));}
;	---------------------------------
; Function key_release
; ---------------------------------
_key_release::
	ld	hl, #_old_joy0
	ld	a, (hl)
	ldhl	sp,#2
	and	a,(hl)
	jr	Z,00103$
	ld	hl, #_joy0
	ld	a, (hl)
	ldhl	sp,#2
	and	a,(hl)
	jr	Z,00104$
00103$:
	xor	a, a
	jr	00105$
00104$:
	ld	a, #0x01
00105$:
	ld	e, a
	ret
	.area _CODE
	.area _CABS (ABS)
