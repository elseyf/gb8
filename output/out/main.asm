;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.7.1 #10455 (MINGW64)
;--------------------------------------------------------
	.module main
	.optsdcc -mgbz80
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _main
	.globl _key_hold
	.globl _read_joypad
	.globl _set_bg_map_tile
	.globl _set_bg_chr
	.globl _fill
	.globl _fastcpy
	.globl _set_bg_map_select
	.globl _gb8_display
	.globl _gb8_mem
	.globl _gb8_sound_timer
	.globl _gb8_delay_timer
	.globl _gb8_i
	.globl _gb8_seed
	.globl _gb8_v
	.globl _gb8_stack_p
	.globl _gb8_stack
	.globl _gb8_pc
	.globl _sp_buffer
	.globl _gb8_font
	.globl _gb8_key_map
	.globl _gb8_clear_screen
	.globl _gb8_get_key
	.globl _gb8_draw_sprite
	.globl _gb8_bcd_vx
	.globl _gb8_rnd
	.globl _gb8_step
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _DATA
_sp_buffer::
	.ds 2
_gb8_pc::
	.ds 2
_gb8_stack::
	.ds 64
_gb8_stack_p::
	.ds 1
_gb8_v::
	.ds 16
_gb8_seed::
	.ds 1
_gb8_i::
	.ds 2
_gb8_delay_timer::
	.ds 1
_gb8_sound_timer::
	.ds 1
_gb8_mem::
	.ds 4096
_gb8_display	=	0xd800
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
;src/main.c:143: void main(){
;	---------------------------------
; Function main
; ---------------------------------
_main::
	add	sp, #-6
;src/gb.h:141: inline bool display_state(){return (*reg(REG_LCDC) & LCDC_DISPLAY_ENABLE);}
	ld	de, #0xff40
	ld	a,(de)
	ld	c,a
	rlc	a
	and	a, #0x01
;src/gb.h:144: if(display_state()){
	bit	0, a
	jr	Z,00121$
;src/gb.h:145: while((*reg(REG_LCD_STAT) & LCD_STAT_MODE_FLAG) != 1); *reg(REG_LCDC) &= ~LCDC_DISPLAY_ENABLE;
00116$:
	ld	de, #0xff41
	ld	a,(de)
	ld	c, a
	ld	b, #0x00
	ld	a, c
	and	a, #0x03
	ld	c, a
	ld	b, #0x00
	ld	a, c
	dec	a
	or	a, b
	jr	NZ,00116$
	ld	de, #0xff40
	ld	a,(de)
	res	7, a
	ld	hl, #0xff40
	ld	(hl), a
;src/main.c:144: disable_display();
00121$:
;src/main.c:145: fastcpy(HRAM, oam_dma_wait, oam_dma_wait_size);
	ld	hl, #_oam_dma_wait_size
	ld	c, (hl)
	ld	b, #0x00
	push	bc
	ld	hl, #_oam_dma_wait
	push	hl
	ld	hl, #0xff80
	push	hl
	call	_fastcpy
	add	sp, #6
;src/main.c:147: vblank_happened = false;
	ld	hl, #_vblank_happened
	ld	(hl), #0x00
;src/gb.h:157: inline void enable_lcd_stat_int(uint8_t _int){*reg(REG_LCD_STAT) |= _int;}
	ld	de, #0xff41
	ld	a,(de)
	or	a, #0x48
	ld	hl, #0xff41
	ld	(hl), a
;src/gb.h:159: inline void set_lyc(uint8_t _lyc){*reg(REG_LYC) = _lyc;}
	ld	l, #0x45
	ld	(hl), #0x91
;src/gb.h:167: inline void set_bg_pal(uint8_t _data){*reg(REG_BGP) = bg_pal = _data;}
	ld	hl, #_bg_pal
	ld	(hl), #0xf0
	ld	hl, #0xff47
	ld	(hl), #0xf0
;src/gb.h:168: inline void set_obj_pal0(uint8_t _data){*reg(REG_OBP0) = obj_pal0 = _data;}
	ld	hl, #_obj_pal0
	ld	(hl), #0xe4
	ld	hl, #0xff48
	ld	(hl), #0xe4
;src/gb.h:169: inline void set_obj_pal1(uint8_t _data){*reg(REG_OBP1) = obj_pal1 = _data;}
	ld	hl, #_obj_pal1
	ld	(hl), #0x27
	ld	hl, #0xff49
	ld	(hl), #0x27
;src/main.c:155: set_bg_map_select(false);
	xor	a, a
	push	af
	inc	sp
	call	_set_bg_map_select
	inc	sp
;src/main.c:156: set_bg_chr(bg_tiles, 0x0000, sizeof(bg_tiles));
	ld	hl, #0x1000
	push	hl
	ld	h, #0x00
	push	hl
	ld	hl, #_bg_tiles
	push	hl
	call	_set_bg_chr
	add	sp, #6
;src/main.c:157: fill(BG_MAP, 0x7F, 0x0400);
	ld	hl, #0x0400
	push	hl
	ld	a, #0x7f
	push	af
	inc	sp
	ld	h, #0x98
	push	hl
	call	_fill
	add	sp, #5
;src/gb.h:189: inline void set_bg_scroll(uint8_t _sx, uint8_t _sy){scroll_x = _sx; scroll_y = _sy;}
	ld	hl, #_scroll_x
	ld	(hl), #0x00
	ld	hl, #_scroll_y
	ld	(hl), #0x00
;src/main.c:160: for(uint8_t i = 0; i < 4; i++)
	ldhl	sp,#5
	ld	(hl), #0x00
00139$:
	ldhl	sp,#5
	ld	a, (hl)
	sub	a, #0x04
	jp	NC, 00102$
;src/main.c:161: for(uint8_t j = 0; j < 16; j++)
	dec	hl
	ld	(hl), #0x00
00136$:
	ldhl	sp,#4
	ld	a, (hl)
	sub	a, #0x10
	jp	NC, 00140$
;src/main.c:162: set_bg_map_tile_xy(j + 2, i + 8, ((i * 16) + j) & 0x1F);
	inc	hl
	ld	a, (hl)
	swap	a
	and	a, #0xf0
	ld	c, a
	dec	hl
	ld	e, (hl)
	ld	a, c
	add	a, e
	and	a, #0x1f
	dec	hl
	dec	hl
	ld	(hl), a
	ldhl	sp,#5
	ld	a, (hl)
	add	a, #0x08
	inc	e
	inc	e
;src/gb.h:175: inline void set_bg_map_tile_xy(uint8_t _x, uint8_t _y, uint8_t _tile){set_bg_map_tile((_y << 5) + _x, _tile);}
	ld	c, a
	ld	b, #0x00
	sla	c
	rl	b
	sla	c
	rl	b
	sla	c
	rl	b
	sla	c
	rl	b
	sla	c
	rl	b
	ldhl	sp,#0
	ld	(hl), e
	inc	hl
	ld	(hl), #0x00
	pop	hl
	push	hl
	add	hl, bc
	ld	c, l
	ld	b, h
	ldhl	sp,#2
	ld	a, (hl)
	push	af
	inc	sp
	push	bc
	call	_set_bg_map_tile
	add	sp, #3
;src/main.c:161: for(uint8_t j = 0; j < 16; j++)
	ldhl	sp,#4
	inc	(hl)
	jp	00136$
00140$:
;src/main.c:160: for(uint8_t i = 0; i < 4; i++)
	ldhl	sp,#5
	inc	(hl)
	jp	00139$
00102$:
;src/gb.h:153: inline void disable_obj(){*reg(REG_LCDC) &= ~LCDC_OBJ_ENABLE;}
	ld	de, #0xff40
	ld	a,(de)
	res	1, a
	ld	hl, #0xff40
	ld	(hl), a
;src/gb.h:151: inline void disable_win(){*reg(REG_LCDC) &= ~LCDC_WIN_ENABLE;}
	ld	de, #0xff40
	ld	a,(de)
	res	5, a
	ld	l, #0x40
	ld	(hl), a
;src/gb.h:148: inline void enable_bg(){*reg(REG_LCDC) |= LCDC_BG_ENABLE;}
	ld	de, #0xff40
	ld	a,(de)
	ld	c, a
	ld	b, #0x00
	set	0, c
	ld	l, #0x40
	ld	(hl), c
;src/gb.h:142: inline void enable_display(){*reg(REG_LCDC) |= LCDC_DISPLAY_ENABLE;}
	ld	de, #0xff40
	ld	a,(de)
	ld	c, a
	ld	b, #0x00
	set	7, c
	ld	l, #0x40
	ld	(hl), c
;src/main.c:169: fastcpy(&gb8_mem, &gb8_font, sizeof(gb8_font));
	ld	hl, #0x0050
	push	hl
	ld	hl, #_gb8_font
	push	hl
	ld	hl, #_gb8_mem
	push	hl
	call	_fastcpy
	add	sp, #6
;src/main.c:170: fastcpy(&gb8_mem + GB8_PROGRAM_START, &rom, sizeof(rom));
	ld	hl, #0x0e00
	push	hl
	ld	hl, #_rom
	push	hl
	ld	hl, #(_gb8_mem + 0x0200)
	push	hl
	call	_fastcpy
	add	sp, #6
;src/main.c:171: gb8_pc = GB8_PROGRAM_START;
	ld	hl, #_gb8_pc
	ld	(hl), #0x00
	inc	hl
	ld	(hl), #0x02
;src/main.c:172: gb8_stack_p = 0;
	ld	hl, #_gb8_stack_p
	ld	(hl), #0x00
;src/main.c:173: for(uint8_t i = 0; i < 16; i++) gb8_v[i] = 0;
	ldhl	sp,#3
	ld	(hl), #0x00
00142$:
	ldhl	sp,#3
	ld	a, (hl)
	sub	a, #0x10
	jr	NC,00103$
	ld	de, #_gb8_v
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
	ld	c, l
	ld	b, h
	xor	a, a
	ld	(bc), a
	ldhl	sp,#3
	inc	(hl)
	jr	00142$
00103$:
;src/main.c:174: gb8_i = 0;
	ld	hl, #_gb8_i
	ld	(hl), #0x00
	inc	hl
	ld	(hl), #0x00
;src/main.c:175: gb8_delay_timer = 0;
	ld	hl, #_gb8_delay_timer
	ld	(hl), #0x00
;src/main.c:176: gb8_sound_timer = 0;
	ld	hl, #_gb8_sound_timer
	ld	(hl), #0x00
;src/gb.h:137: inline void clear_int_request_flags(){*reg(REG_IF) = 0x00;}
	ld	hl, #0xff0f
	ld	(hl), #0x00
;src/gb.h:135: inline void enable_int(uint8_t _int){*reg(REG_IE) |= _int;}
	ld	de, #0xffff
	ld	a,(de)
	or	a, #0x03
	ld	l, #0xff
	ld	(hl), a
;src/main.c:180: ei();
	ei
;src/main.c:183: while(!vblank_happened) halt();
00104$:
	ld	hl, #_vblank_happened
	bit	0, (hl)
	jr	NZ,00106$
	halt
	nop
	jr	00104$
00106$:
;src/main.c:184: vblank_happened = false;
	ld	hl, #_vblank_happened
	ld	(hl), #0x00
;src/main.c:185: read_joypad();
	call	_read_joypad
;src/main.c:187: for(uint8_t i = 0; i < GB8_INSTR_PER_FRAME; i++) gb8_step();
	ld	c, #0x00
00145$:
	ld	a, c
	sub	a, #0x07
	jr	NC,00107$
	push	bc
	call	_gb8_step
	pop	bc
	inc	c
	jr	00145$
00107$:
;src/main.c:189: if(gb8_delay_timer > 0) gb8_delay_timer--;
	ld	hl, #_gb8_delay_timer
	ld	a, (hl)
	or	a, a
	jr	Z,00109$
	dec	(hl)
00109$:
;src/main.c:190: if(gb8_sound_timer > 0) gb8_sound_timer--;
	ld	hl, #_gb8_sound_timer
	ld	a, (hl)
	or	a, a
	jr	Z,00104$
	dec	(hl)
	jr	00104$
;src/main.c:195: }
	add	sp, #6
	ret
_gb8_key_map:
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x02	; 2
	.db #0x40	; 64
	.db #0x01	; 1
	.db #0x20	; 32
	.db #0x80	; 128
	.db #0x10	; 16
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
_gb8_font:
	.db #0xf0	; 240
	.db #0x90	; 144
	.db #0x90	; 144
	.db #0x90	; 144
	.db #0xf0	; 240
	.db #0x20	; 32
	.db #0x60	; 96
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x70	; 112	'p'
	.db #0xf0	; 240
	.db #0x10	; 16
	.db #0xf0	; 240
	.db #0x80	; 128
	.db #0xf0	; 240
	.db #0xf0	; 240
	.db #0x10	; 16
	.db #0xf0	; 240
	.db #0x10	; 16
	.db #0xf0	; 240
	.db #0x90	; 144
	.db #0x90	; 144
	.db #0xf0	; 240
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0xf0	; 240
	.db #0x80	; 128
	.db #0xf0	; 240
	.db #0x10	; 16
	.db #0xf0	; 240
	.db #0xf0	; 240
	.db #0x80	; 128
	.db #0xf0	; 240
	.db #0x90	; 144
	.db #0xf0	; 240
	.db #0xf0	; 240
	.db #0x10	; 16
	.db #0x20	; 32
	.db #0x40	; 64
	.db #0x40	; 64
	.db #0xf0	; 240
	.db #0x90	; 144
	.db #0xf0	; 240
	.db #0x90	; 144
	.db #0xf0	; 240
	.db #0xf0	; 240
	.db #0x90	; 144
	.db #0xf0	; 240
	.db #0x10	; 16
	.db #0xf0	; 240
	.db #0xf0	; 240
	.db #0x90	; 144
	.db #0xf0	; 240
	.db #0x90	; 144
	.db #0x90	; 144
	.db #0xe0	; 224
	.db #0x90	; 144
	.db #0xe0	; 224
	.db #0x90	; 144
	.db #0xe0	; 224
	.db #0xf0	; 240
	.db #0x80	; 128
	.db #0x80	; 128
	.db #0x80	; 128
	.db #0xf0	; 240
	.db #0xe0	; 224
	.db #0x90	; 144
	.db #0x90	; 144
	.db #0x90	; 144
	.db #0xe0	; 224
	.db #0xf0	; 240
	.db #0x80	; 128
	.db #0xf0	; 240
	.db #0x80	; 128
	.db #0xf0	; 240
	.db #0xf0	; 240
	.db #0x80	; 128
	.db #0xf0	; 240
	.db #0x80	; 128
	.db #0x80	; 128
;src/main.c:197: void gb8_clear_screen(){
;	---------------------------------
; Function gb8_clear_screen
; ---------------------------------
_gb8_clear_screen::
;src/main.c:198: fill(&gb8_display, 0x00, sizeof(gb8_display));
	ld	hl, #0x0200
	push	hl
	xor	a, a
	push	af
	inc	sp
	ld	hl, #_gb8_display
	push	hl
	call	_fill
	add	sp, #5
;src/main.c:199: }
	ret
;src/main.c:201: uint8_t gb8_get_key(uint8_t _key){
;	---------------------------------
; Function gb8_get_key
; ---------------------------------
_gb8_get_key::
;src/main.c:202: return key_hold(gb8_key_map[_key]);
	ld	de, #_gb8_key_map
	ldhl	sp,#2
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	push	af
	inc	sp
	call	_key_hold
	inc	sp
;src/main.c:203: }
	ret
;src/main.c:205: void gb8_draw_sprite(uint8_t _px, uint8_t _py, uint8_t _n){
;	---------------------------------
; Function gb8_draw_sprite
; ---------------------------------
_gb8_draw_sprite::
;src/main.c:418: __endasm;
	line	= 0
	qbyte	= 1
	px	= 7
	py	= 8
	n	= 9
	dest_p	= 2
	src_b	= 0
	add	sp, #-5
	ld	hl, #(_gb8_v + 0x0F) ;gb8_v[0xF] = 0
	ld	(hl), #0
	ld	bc, #_gb8_display ;dest_p = dest pixel in display
	ldhl	sp, #py
	ld	a, (hl)
	ld	hl, #0
	bit	3, a
	jr	z, 20$
	inc	h
	   20$:
	bit 4, a
	jr	z, 21$
	inc	l
	   21$:
	and #0x07
	add	a
	add	l
	ld	l, a
	add	hl, bc
	ld	b, h
	ld	c, l
	ldhl	sp, #px
	ld	a, (hl)
	and	#0x38
	sla	a
	sla	a
	ld	l, a
	ld	h, #0
	add	hl, bc
	ld	b, h
	ld	c, l
	push	bc
	ld	de, #_gb8_mem ;src_b = src byte from font
	ld	hl, #_gb8_i
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	ld	d, h
	ld	e, l
	push	de
	ldhl	sp, #(n + 4)
	ld	a, (hl)
	and	#0x0F
	ld	(hl), a
	jp	z, 10$
	ldhl	sp, #(line + 4)
	ld	(hl), #0
	        0$:
	ldhl sp, #src_b
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	c, (hl)
	ld	b, #0
	sla	c
	rl	b
	ld	hl, #_pixel_scale_table
	add	hl, bc
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	xor	a
	ld	e, a
	ld	d, a
	ldhl	sp, #(px + 4)
	ld	a, (hl)
	and	#0x07
	jr	z, 2$
	        1$:
	srl c
	rr	b
	rr	e
	rr	d
	srl	c
	rr	b
	rr	e
	rr	d
	dec	a
	jr	nz, 1$
	        2$:
	ldhl sp, #(qbyte + 4)
	ld	a, c
	ld	(hl+), a
	ld	a, b
	ld	(hl+), a
	ld	a, e
	ld	(hl+), a
	ld	(hl), d
	ldhl	sp, #(py + 4)
	ld	a, (hl)
	ldhl	sp, #(line + 4)
	ld	d, (hl)
	add	(hl)
	ld	e, a
	ldhl	sp, #dest_p
	ld	a, (hl+)
	ld	b, (hl)
	ld	c, a
	ld	a, d
	add	a
	add	c
	and	#0x0F
	ld	d, a
	ld	a, c
	and	#0xF0
	add	d
	ld	c, a
	ld	a, b
	bit	3, e
	jr	z, 40$
	or	#0x01
	jr	41$
	40$:and	#0xFE
	       41$:
	ld b, a
	ld	a, c
	bit	4, e
	jr	z, 42$
	or	#0x01
	jr	43$
	42$:and	#0xFE
	       43$:
	ld c, a
	ld	e, #0
	ldhl	sp, #(qbyte + 4 + 0)
	ld	a, (bc)
	ld	d, a
	xor	(hl)
	ld	(bc), a
	ld	a, (hl+)
	and	d
	jr	z, 30$
	ld	e, #1
	       30$:
	ld a, c
	add	#16
	ld	c, a
	ld	a, (bc)
	ld	d, a
	xor	(hl)
	ld	(bc), a
	ld	a, (hl+)
	and	d
	jr	z, 31$
	ld	e, #1
	       31$:
	ld a, c
	add	#16
	ld	c, a
	ld	a, (bc)
	ld	d, a
	xor	(hl)
	ld	(bc), a
	ld	a, (hl+)
	and	d
	jr	z, 32$
	ld	e, #1
	       32$:
	ld a, c
	add	#16
	ld	c, a
	ld	a, (bc)
	ld	d, a
	xor	(hl)
	ld	(bc), a
	ld	a, (hl+)
	and	d
	jr	z, 33$
	ld	e, #1
	       33$:
	ld a, c
	add	#16
	ld	c, a
	ld	hl, #(_gb8_v + 0x0F) ;gb8_v[0xF] = e
	ld	a, (hl)
	or	e
	ld	(hl), a
	        4$:
	ldhl sp, #src_b
	inc	(hl)
	jr	nz, 5$
	inc	hl
	inc	(hl)
	        5$:
	ldhl sp, #(line + 4)
	inc	(hl)
	        9$:
	ldhl sp, #(n + 4)
	dec	(hl)
	jp	nz, 0$
	       10$:
	add sp, #9
;src/main.c:419: }
	ret
;src/main.c:421: void gb8_bcd_vx(uint8_t _vx){
;	---------------------------------
; Function gb8_bcd_vx
; ---------------------------------
_gb8_bcd_vx::
;src/main.c:462: __endasm;
	vx	= 2
	ldhl	sp, #vx
	ld	l, (hl)
	ld	h, #0
	ld	bc, #_gb8_v
	add	hl, bc
	ld	e, (hl)
	ld	hl, #_gb8_mem
	ld	a, (_gb8_i)
	ld	c, a
	ld	a, (_gb8_i + 1)
	ld	b, a
	add	hl, bc
	ld	a, e
	ld	d, #-100
	call	10$
	ld	(hl), b
	inc	hl
	ld	d, #-10
	call	10$
	ld	(hl), b
	inc	hl
	ld	d, #-1
	call	10$
	ld	(hl), b
	ret
	   10$:
	ld b, #-1
	   11$:
	inc b
	add	d
	jr	c, 11$
	sbc	d
	ret
;src/main.c:463: }
	ret
;src/main.c:465: uint8_t gb8_rnd(){
;	---------------------------------
; Function gb8_rnd
; ---------------------------------
_gb8_rnd::
;src/main.c:480: __endasm;
	ld	a, (_gb8_seed)
	ld	b, a
	rrca
	rrca
	rrca
	xor	#0x1F
	add	b
	sbc	#0xFF
	ld	e, a
	ldh	a, (0xFF04)
	add	e
	ld	(_gb8_seed), a
	ld	e, a
;src/main.c:481: }
	ret
;src/main.c:483: void gb8_step(){
;	---------------------------------
; Function gb8_step
; ---------------------------------
_gb8_step::
	add	sp, #-12
;src/main.c:484: uint8_t _instr_hi = gb8_mem[gb8_pc++];
	ld	hl, #_gb8_pc + 1
	dec	hl
	ld	c, (hl)
	inc	hl
	ld	b, (hl)
	dec	hl
	inc	(hl)
	jr	NZ,00376$
	inc	hl
	inc	(hl)
00376$:
	ld	hl, #_gb8_mem
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	a, (bc)
	ldhl	sp,#10
	ld	(hl), a
;src/main.c:485: uint8_t _instr_lo = gb8_mem[gb8_pc++];
	ld	hl, #_gb8_pc + 1
	dec	hl
	ld	c, (hl)
	inc	hl
	ld	b, (hl)
	dec	hl
	inc	(hl)
	jr	NZ,00377$
	inc	hl
	inc	(hl)
00377$:
	ld	hl, #_gb8_mem
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	a, (bc)
	ldhl	sp,#11
;src/main.c:487: switch(_instr_hi >> 4){
	ld	(hl-), a
	ld	a, (hl)
	swap	a
	and	a, #0x0f
	ldhl	sp,#4
	ld	(hl), a
	ld	a, #0x0f
	sub	a, (hl)
	jp	C, 00171$
	ld	c, (hl)
	ld	b, #0x00
	ld	hl, #00378$
	add	hl, bc
	add	hl, bc
	add	hl, bc
	jp	(hl)
00378$:
	jp	00101$
	jp	00105$
	jp	00106$
	jp	00107$
	jp	00110$
	jp	00113$
	jp	00116$
	jp	00117$
	jp	00118$
	jp	00129$
	jp	00132$
	jp	00133$
	jp	00134$
	jp	00135$
	jp	00136$
	jp	00144$
;src/main.c:488: case GB8_INSTR_SPEC:
00101$:
;src/main.c:489: switch(_instr_lo){
	ldhl	sp,#11
	ld	a, (hl)
	sub	a, #0xe0
	jr	Z,00102$
	ldhl	sp,#11
	ld	a, (hl)
	sub	a, #0xee
	jr	Z,00103$
	jp	00171$
;src/main.c:490: case GB8_INSTR_SPEC_CLR_SCRN:
00102$:
;src/main.c:491: gb8_clear_screen();
	call	_gb8_clear_screen
;src/main.c:492: break;
	jp	00171$
;src/main.c:493: case GB8_INSTR_SPEC_RETURN:
00103$:
;src/main.c:494: gb8_pc = gb8_stack[--gb8_stack_p];
	ld	hl, #_gb8_stack_p
	dec	(hl)
	ld	c, (hl)
	ld	b, #0x00
	sla	c
	rl	b
	ld	hl, #_gb8_stack
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	e, c
	ld	d, b
	ld	a,(de)
	ld	hl, #_gb8_pc
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl), a
;src/main.c:497: break;
	jp	00171$
;src/main.c:498: case GB8_INSTR_JUMP_N:
00105$:
;src/main.c:499: gb8_pc = ((_instr_hi & 0x0F) << 8) | _instr_lo;
	ldhl	sp,#10
	ld	e, (hl)
	ld	d, #0x00
	ld	a, e
	and	a, #0x0f
	ld	b, a
	ld	c, #0x00
	ld	c, #0x00
	inc	hl
	ld	e, (hl)
	ld	d, #0x00
	ld	a, c
	or	a, e
	ld	hl, #_gb8_pc
	ld	(hl), a
	ld	a, b
	or	a, d
	inc	hl
	ld	(hl), a
;src/main.c:500: break;
	jp	00171$
;src/main.c:501: case GB8_INSTR_CALL_N:
00106$:
;src/main.c:502: gb8_stack[gb8_stack_p++] = gb8_pc;
	ld	hl, #_gb8_stack_p
	ld	c, (hl)
	inc	(hl)
	ld	b, #0x00
	sla	c
	rl	b
	ld	hl, #_gb8_stack
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	hl, #_gb8_pc
	ld	a, (hl+)
	ld	(bc), a
	inc	bc
	ld	a, (hl)
	ld	(bc), a
;src/main.c:503: gb8_pc = ((_instr_hi & 0x0F) << 8) | _instr_lo;
	ldhl	sp,#10
	ld	e, (hl)
	ld	d, #0x00
	ld	a, e
	and	a, #0x0f
	ld	b, a
	ld	c, #0x00
	ld	c, #0x00
	inc	hl
	ld	e, (hl)
	ld	d, #0x00
	ld	a, c
	or	a, e
	ld	hl, #_gb8_pc
	ld	(hl), a
	ld	a, b
	or	a, d
	inc	hl
	ld	(hl), a
;src/main.c:504: break;
	jp	00171$
;src/main.c:505: case GB8_INSTR_SKIP_EQ_VX_N:
00107$:
;src/main.c:506: if(gb8_v[_instr_hi & 0x0F] == _instr_lo) gb8_pc += 2;
	ldhl	sp,#10
	ld	c, (hl)
	ld	b, #0x00
	ld	a, c
	and	a, #0x0f
	ld	c, a
	ld	b, #0x00
	ld	hl, #_gb8_v
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	a, (bc)
	ld	c, a
	ldhl	sp,#11
	ld	a, (hl)
	sub	a, c
	jp	NZ,00171$
	ld	hl, #_gb8_pc
	ld	a, (hl)
	add	a, #0x02
	ld	(hl+), a
	ld	a, (hl)
	adc	a, #0x00
	ld	(hl), a
;src/main.c:507: break;
	jp	00171$
;src/main.c:508: case GB8_INSTR_SKIP_NE_VX_N:
00110$:
;src/main.c:509: if(gb8_v[_instr_hi & 0x0F] != _instr_lo) gb8_pc += 2;
	ldhl	sp,#10
	ld	c, (hl)
	ld	b, #0x00
	ld	a, c
	and	a, #0x0f
	ld	c, a
	ld	b, #0x00
	ld	hl, #_gb8_v
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	a, (bc)
	ld	c, a
	ldhl	sp,#11
	ld	a, (hl)
	sub	a, c
	jp	Z,00171$
	ld	hl, #_gb8_pc
	ld	a, (hl)
	add	a, #0x02
	ld	(hl+), a
	ld	a, (hl)
	adc	a, #0x00
	ld	(hl), a
;src/main.c:510: break;
	jp	00171$
;src/main.c:511: case GB8_INSTR_SKIP_EQ_VX_VY:
00113$:
;src/main.c:512: if(gb8_v[_instr_hi & 0x0F] == gb8_v[_instr_lo >> 4]) gb8_pc += 2;
	ldhl	sp,#10
	ld	c, (hl)
	ld	b, #0x00
	ld	a, c
	and	a, #0x0f
	ld	c, a
	ld	b, #0x00
	ld	hl, #_gb8_v
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	a, (bc)
	ld	c, a
	ldhl	sp,#11
	ld	a, (hl)
	swap	a
	and	a, #0x0f
	add	a, #<(_gb8_v)
	ld	b, a
	ld	a, #0x00
	adc	a, #>(_gb8_v)
	ld	e, b
	ld	d, a
	ld	a,(de)
	sub	a, c
	jp	NZ,00171$
	ld	hl, #_gb8_pc
	ld	a, (hl)
	add	a, #0x02
	ld	(hl+), a
	ld	a, (hl)
	adc	a, #0x00
	ld	(hl), a
;src/main.c:513: break;
	jp	00171$
;src/main.c:514: case GB8_INSTR_LOAD_VX_N:
00116$:
;src/main.c:515: gb8_v[_instr_hi & 0x0F] = _instr_lo;
	ldhl	sp,#10
	ld	c, (hl)
	ld	b, #0x00
	ld	a, c
	and	a, #0x0f
	ld	c, a
	ld	b, #0x00
	ld	hl, #_gb8_v
	add	hl, bc
	ld	c, l
	ld	b, h
	ldhl	sp,#11
	ld	a, (hl)
	ld	(bc), a
;src/main.c:516: break;
	jp	00171$
;src/main.c:517: case GB8_INSTR_ADD_VX_N:
00117$:
;src/main.c:518: gb8_v[_instr_hi & 0x0F] += _instr_lo;
	ldhl	sp,#10
	ld	c, (hl)
	ld	b, #0x00
	ld	a, c
	and	a, #0x0f
	ld	c, a
	ld	b, #0x00
	ld	hl, #_gb8_v
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	a, (bc)
	ldhl	sp,#11
	add	a, (hl)
	ld	(bc), a
;src/main.c:519: break;
	jp	00171$
;src/main.c:520: case GB8_INSTR_ARITH:
00118$:
;src/main.c:521: switch(_instr_lo & 0x0F){
	ldhl	sp,#11
	ld	c, (hl)
	ld	b, #0x00
	ld	a, c
	and	a, #0x0f
	ld	c, a
	ld	b, #0x00
	ld	a, c
	or	a, a
	or	a, b
	jp	Z,00119$
	ld	a, c
	dec	a
	or	a, b
	jp	Z,00120$
	ld	a, c
	sub	a, #0x02
	or	a, b
	jp	Z,00121$
	ld	a, c
	sub	a, #0x03
	or	a, b
	jp	Z,00122$
	ld	a, c
	sub	a, #0x04
	or	a, b
	jp	Z,00123$
	ld	a, c
	sub	a, #0x05
	or	a, b
	jp	Z,00124$
	ld	a, c
	sub	a, #0x06
	or	a, b
	jp	Z,00125$
	ld	a, c
	sub	a, #0x07
	or	a, b
	jp	Z,00126$
	ld	a, c
	sub	a, #0x0e
	or	a, b
	jp	Z,00127$
	jp	00171$
;src/main.c:522: case GB8_INSTR_ARITH_LOAD_VX_VY:
00119$:
;src/main.c:523: gb8_v[_instr_hi & 0x0F] = gb8_v[_instr_lo >> 4];
	ldhl	sp,#10
	ld	c, (hl)
	ld	b, #0x00
	ld	a, c
	and	a, #0x0f
	ld	c, a
	ld	b, #0x00
	ld	hl, #_gb8_v
	add	hl, bc
	ld	a, l
	ld	d, h
	ldhl	sp,#5
	ld	(hl+), a
	ld	(hl), d
	ldhl	sp,#11
	ld	a, (hl)
	swap	a
	and	a, #0x0f
	add	a, #<(_gb8_v)
	ld	c, a
	ld	a, #0x00
	adc	a, #>(_gb8_v)
	ld	b, a
	ld	a, (bc)
	ld	c, a
	ldhl	sp,#5
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), c
;src/main.c:524: break;
	jp	00171$
;src/main.c:525: case GB8_INSTR_ARITH_OR_VX_VY:
00120$:
;src/main.c:526: gb8_v[_instr_hi & 0x0F] |= gb8_v[_instr_lo >> 4];
	ldhl	sp,#10
	ld	c, (hl)
	ld	b, #0x00
	ld	a, c
	and	a, #0x0f
	ld	c, a
	ld	b, #0x00
	ld	hl, #_gb8_v
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	a, (bc)
	ldhl	sp,#5
	ld	(hl), a
	ldhl	sp,#11
	ld	a, (hl)
	swap	a
	and	a, #0x0f
	ld	e, a
	ld	d, #0x00
	ld	hl, #_gb8_v
	add	hl, de
	ld	a, l
	ld	d, h
	ldhl	sp,#2
	ld	(hl+), a
	ld	(hl), d
	dec	hl
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	ld	a,(de)
	inc	hl
	inc	hl
	or	a, (hl)
	ld	(bc), a
;src/main.c:527: break;
	jp	00171$
;src/main.c:528: case GB8_INSTR_ARITH_AND_VX_VY:
00121$:
;src/main.c:529: gb8_v[_instr_hi & 0x0F] &= gb8_v[_instr_lo >> 4];
	ldhl	sp,#10
	ld	c, (hl)
	ld	b, #0x00
	ld	a, c
	and	a, #0x0f
	ld	c, a
	ld	b, #0x00
	ld	hl, #_gb8_v
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	a, (bc)
	ldhl	sp,#2
	ld	(hl), a
	ldhl	sp,#11
	ld	a, (hl)
	swap	a
	and	a, #0x0f
	ld	e, a
	ld	d, #0x00
	ld	hl, #_gb8_v
	add	hl, de
	ld	a, l
	ld	d, h
	ldhl	sp,#5
	ld	(hl+), a
	ld	(hl), d
	dec	hl
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	ld	a,(de)
	ldhl	sp,#2
	and	a, (hl)
	ld	(bc), a
;src/main.c:530: break;
	jp	00171$
;src/main.c:531: case GB8_INSTR_ARITH_XOR_VX_VY:
00122$:
;src/main.c:532: gb8_v[_instr_hi & 0x0F] ^= gb8_v[_instr_lo >> 4];
	ldhl	sp,#10
	ld	c, (hl)
	ld	b, #0x00
	ld	a, c
	and	a, #0x0f
	ld	c, a
	ld	b, #0x00
	ld	hl, #_gb8_v
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	a, (bc)
	ldhl	sp,#2
	ld	(hl), a
	ldhl	sp,#11
	ld	a, (hl)
	swap	a
	and	a, #0x0f
	ld	e, a
	ld	d, #0x00
	ld	hl, #_gb8_v
	add	hl, de
	ld	a, l
	ld	d, h
	ldhl	sp,#5
	ld	(hl+), a
	ld	(hl), d
	dec	hl
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	ld	a,(de)
	ldhl	sp,#2
	xor	a, (hl)
	ld	(bc), a
;src/main.c:533: break;
	jp	00171$
;src/main.c:534: case GB8_INSTR_ARITH_ADD_VX_VY:
00123$:
;src/main.c:535: gb8_v[0xF] = (((uint16_t)gb8_v[_instr_hi & 0x0F] + gb8_v[_instr_lo >> 4]) > 0x100) ? 1 : 0;
	ldhl	sp,#10
	ld	c, (hl)
	ld	b, #0x00
	ld	a, c
	and	a, #0x0f
	ld	c, a
	ld	b, #0x00
	ld	hl, #_gb8_v
	add	hl, bc
	ld	a, l
	ld	d, h
	ldhl	sp,#2
	ld	(hl+), a
	ld	(hl), d
	dec	hl
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	ld	a,(de)
	inc	hl
	inc	hl
	ld	(hl+), a
	ld	(hl), #0x00
	ldhl	sp,#11
	ld	a, (hl)
	swap	a
	and	a, #0x0f
	ld	e, a
	ld	d, #0x00
	ld	hl, #_gb8_v
	add	hl, de
	inc	sp
	inc	sp
	push	hl
	pop	de
	push	de
	ld	a,(de)
	ld	c, a
	ld	b, #0x00
	ldhl	sp,#5
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, bc
	ld	c, l
	ld	b, h
	xor	a, a
	cp	a, c
	ld	a, #0x01
	sbc	a, b
	jr	NC,00173$
	ld	bc, #0x0001
	jr	00174$
00173$:
	ld	bc, #0x0000
00174$:
	ld	hl, #(_gb8_v + 0x000f)
	ld	(hl), c
;src/main.c:536: gb8_v[_instr_hi & 0x0F] += gb8_v[_instr_lo >> 4];
	ldhl	sp,#(3 - 1)
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	ld	a,(de)
	ld	c, a
	pop	de
	push	de
	ld	a,(de)
	add	a, c
	ld	c, a
	dec	hl
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), c
;src/main.c:537: break;
	jp	00171$
;src/main.c:538: case GB8_INSTR_ARITH_SUB_VX_VY:
00124$:
;src/main.c:539: gb8_v[0xF] = (((int16_t)gb8_v[_instr_hi & 0x0F] - gb8_v[_instr_lo >> 4]) < 0) ? 0 : 1;
	ldhl	sp,#10
	ld	c, (hl)
	ld	b, #0x00
	ld	a, c
	and	a, #0x0f
	ld	c, a
	ld	b, #0x00
	ld	hl, #_gb8_v
	add	hl, bc
	inc	sp
	inc	sp
	push	hl
	pop	de
	push	de
	ld	a,(de)
	ld	c, a
	ld	b, #0x00
	ldhl	sp,#11
	ld	a, (hl)
	swap	a
	and	a, #0x0f
	ld	e, a
	ld	d, #0x00
	ld	hl, #_gb8_v
	add	hl, de
	ld	a, l
	ld	d, h
	ldhl	sp,#2
	ld	(hl+), a
	ld	(hl), d
	dec	hl
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	ld	a,(de)
	inc	hl
	inc	hl
	ld	(hl+), a
	ld	(hl), #0x00
	dec	hl
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	ld	a, c
	sub	a, e
	ld	e, a
	ld	a, b
	sbc	a, d
	ld	b, a
	ld	c, e
	bit	7, b
	jr	Z,00175$
	ld	bc, #0x0000
	jr	00176$
00175$:
	ld	bc, #0x0001
00176$:
	ld	hl, #(_gb8_v + 0x000f)
	ld	(hl), c
;src/main.c:540: gb8_v[_instr_hi & 0x0F] -= gb8_v[_instr_lo >> 4];
	pop	de
	push	de
	ld	a,(de)
	ldhl	sp,#(3 - 1)
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	push	af
	ld	a,(de)
	ld	c, a
	pop	af
	sub	a, c
	ld	c, a
	pop	hl
	push	hl
	ld	(hl), c
;src/main.c:541: break;
	jp	00171$
;src/main.c:542: case GB8_INSTR_ARITH_SHR_VX_VY:
00125$:
;src/main.c:543: gb8_v[0xF] = gb8_v[_instr_lo >> 4] & 0x01;
	ld	bc, #_gb8_v + 15
	ldhl	sp,#11
	ld	a, (hl)
	swap	a
	and	a, #0x0f
	ld	e, a
	ld	d, #0x00
	ld	hl, #_gb8_v
	add	hl, de
	inc	sp
	inc	sp
	push	hl
	pop	de
	push	de
	ld	a,(de)
	and	a, #0x01
	ld	(bc), a
;src/main.c:544: gb8_v[_instr_hi & 0x0F] = gb8_v[_instr_lo >> 4] >> 1;
	ldhl	sp,#10
	ld	c, (hl)
	ld	b, #0x00
	ld	a, c
	and	a, #0x0f
	ld	c, a
	ld	b, #0x00
	ld	hl, #_gb8_v
	add	hl, bc
	ld	c, l
	ld	b, h
	pop	de
	push	de
	ld	a,(de)
	srl	a
	ld	(bc), a
;src/main.c:545: break;
	jp	00171$
;src/main.c:546: case GB8_INSTR_ARITH_SUB_VY_VX:
00126$:
;src/main.c:547: gb8_v[0xF] = (((int16_t)gb8_v[_instr_lo >> 4] - gb8_v[_instr_hi & 0x0F]) < 0) ? 0 : 1;
	ldhl	sp,#11
	ld	a, (hl)
	swap	a
	and	a, #0x0f
	ld	e, a
	ld	d, #0x00
	ld	hl, #_gb8_v
	add	hl, de
	inc	sp
	inc	sp
	push	hl
	pop	de
	push	de
	ld	a,(de)
	ldhl	sp,#2
	ld	(hl+), a
	ld	(hl), #0x00
	ldhl	sp,#10
	ld	c, (hl)
	ld	b, #0x00
	ld	a, c
	and	a, #0x0f
	ld	c, a
	ld	b, #0x00
	ld	hl, #_gb8_v
	add	hl, bc
	ld	a, l
	ld	d, h
	ldhl	sp,#5
	ld	(hl+), a
	ld	(hl), d
	dec	hl
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	ld	a,(de)
	ld	c, a
	ld	b, #0x00
	ldhl	sp,#(3 - 1)
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	ld	a, e
	sub	a, c
	ld	e, a
	ld	a, d
	sbc	a, b
	ld	b, a
	ld	c, e
	bit	7, b
	jr	Z,00177$
	ld	bc, #0x0000
	jr	00178$
00177$:
	ld	bc, #0x0001
00178$:
	ld	hl, #(_gb8_v + 0x000f)
	ld	(hl), c
;src/main.c:548: gb8_v[_instr_hi & 0x0F] = gb8_v[_instr_lo >> 4] - gb8_v[_instr_hi & 0x0F];
	pop	de
	push	de
	ld	a,(de)
	ldhl	sp,#(6 - 1)
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	push	af
	ld	a,(de)
	ld	c, a
	pop	af
	sub	a, c
	ld	c, a
	dec	hl
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), c
;src/main.c:549: break;
	jp	00171$
;src/main.c:550: case GB8_INSTR_ARITH_SHL_VX_VY:
00127$:
;src/main.c:551: gb8_v[0xF] = gb8_v[_instr_lo >> 4] >> 7;
	ld	bc, #_gb8_v + 15
	ldhl	sp,#11
	ld	a, (hl)
	swap	a
	and	a, #0x0f
	ld	e, a
	ld	d, #0x00
	ld	hl, #_gb8_v
	add	hl, de
	inc	sp
	inc	sp
	push	hl
	pop	de
	push	de
	ld	a,(de)
	rlca
	and	a, #0x01
	ld	(bc), a
;src/main.c:552: gb8_v[_instr_hi & 0x0F] = gb8_v[_instr_lo >> 4] << 1;
	ldhl	sp,#10
	ld	c, (hl)
	ld	b, #0x00
	ld	a, c
	and	a, #0x0f
	ld	c, a
	ld	b, #0x00
	ld	hl, #_gb8_v
	add	hl, bc
	ld	c, l
	ld	b, h
	pop	de
	push	de
	ld	a,(de)
	add	a, a
	ld	(bc), a
;src/main.c:555: break;
	jp	00171$
;src/main.c:556: case GB8_INSTR_SKIP_NE_VX_VY:
00129$:
;src/main.c:557: if(gb8_v[_instr_hi & 0x0F] != gb8_v[_instr_lo >> 4]) gb8_pc += 2;
	ldhl	sp,#10
	ld	c, (hl)
	ld	b, #0x00
	ld	a, c
	and	a, #0x0f
	ld	c, a
	ld	b, #0x00
	ld	hl, #_gb8_v
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	a, (bc)
	ld	c, a
	ldhl	sp,#11
	ld	a, (hl)
	swap	a
	and	a, #0x0f
	add	a, #<(_gb8_v)
	ld	b, a
	ld	a, #0x00
	adc	a, #>(_gb8_v)
	ld	e, b
	ld	d, a
	ld	a,(de)
	sub	a, c
	jp	Z,00171$
	ld	hl, #_gb8_pc
	ld	a, (hl)
	add	a, #0x02
	ld	(hl+), a
	ld	a, (hl)
	adc	a, #0x00
	ld	(hl), a
;src/main.c:558: break;
	jp	00171$
;src/main.c:559: case GB8_INSTR_LOAD_I_N:
00132$:
;src/main.c:560: gb8_i = ((_instr_hi & 0x0F) << 8) | _instr_lo;
	ldhl	sp,#10
	ld	e, (hl)
	ld	d, #0x00
	ld	a, e
	and	a, #0x0f
	ld	b, a
	ld	c, #0x00
	ld	c, #0x00
	inc	hl
	ld	e, (hl)
	ld	d, #0x00
	ld	a, c
	or	a, e
	ld	hl, #_gb8_i
	ld	(hl), a
	ld	a, b
	or	a, d
	inc	hl
	ld	(hl), a
;src/main.c:561: break;
	jp	00171$
;src/main.c:562: case GB8_INSTR_JMP_N_V0:
00133$:
;src/main.c:563: gb8_pc = (((_instr_hi & 0x0F) << 8) | _instr_lo) + gb8_v[0];
	ldhl	sp,#10
	ld	e, (hl)
	ld	d, #0x00
	ld	a, e
	and	a, #0x0f
	ld	b, a
	ld	c, #0x00
	ld	c, #0x00
	inc	hl
	ld	e, (hl)
	ld	d, #0x00
	ld	a, c
	or	a, e
	ld	c, a
	ld	a, b
	or	a, d
	ld	b, a
	ld	a, (#_gb8_v + 0)
	ldhl	sp,#0
	ld	(hl+), a
	ld	(hl), #0x00
	pop	hl
	push	hl
	add	hl, bc
	ld	a, l
	ld	d, h
	ld	hl, #_gb8_pc
	ld	(hl+), a
	ld	(hl), d
;src/main.c:564: break;
	jp	00171$
;src/main.c:565: case GB8_INSTR_RND_VX_N:
00134$:
;src/main.c:566: gb8_v[_instr_hi & 0x0F] = gb8_rnd() & _instr_lo;
	ldhl	sp,#10
	ld	c, (hl)
	ld	b, #0x00
	ld	a, c
	and	a, #0x0f
	ld	c, a
	ld	b, #0x00
	ld	hl, #_gb8_v
	add	hl, bc
	ld	c, l
	ld	b, h
	push	bc
	call	_gb8_rnd
	ld	a, e
	pop	bc
	ldhl	sp,#11
	and	a, (hl)
	ld	(bc), a
;src/main.c:567: break;
	jp	00171$
;src/main.c:568: case GB8_INSTR_DRAW_SPR:
00135$:
;src/main.c:569: gb8_draw_sprite(gb8_v[_instr_hi & 0x0F], gb8_v[_instr_lo >> 4], _instr_lo & 0x0F);
	ldhl	sp,#11
	ld	a, (hl)
	and	a, #0x0f
	ldhl	sp,#0
	ld	(hl), a
	ldhl	sp,#11
	ld	a, (hl)
	swap	a
	and	a, #0x0f
	add	a, #<(_gb8_v)
	ld	c, a
	ld	a, #0x00
	adc	a, #>(_gb8_v)
	ld	b, a
	ld	a, (bc)
	ldhl	sp,#2
	ld	(hl), a
	ldhl	sp,#10
	ld	c, (hl)
	ld	b, #0x00
	ld	a, c
	and	a, #0x0f
	ld	c, a
	ld	b, #0x00
	ld	hl, #_gb8_v
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	a, (bc)
	ld	b, a
	ldhl	sp,#0
	ld	a, (hl)
	push	af
	inc	sp
	inc	hl
	inc	hl
	ld	a, (hl)
	push	af
	inc	sp
	push	bc
	inc	sp
	call	_gb8_draw_sprite
	add	sp, #3
;src/main.c:570: break;
	jp	00171$
;src/main.c:571: case GB8_INSTR_SKIP_KEY:
00136$:
;src/main.c:572: switch(_instr_lo){
	ldhl	sp,#11
	ld	a, (hl)
	sub	a, #0x9e
	jr	Z,00137$
	ldhl	sp,#11
	ld	a, (hl)
	sub	a, #0xa1
	jr	Z,00140$
	jp	00171$
;src/main.c:573: case GB8_INSTR_SKIP_KEY_PRSD:
00137$:
;src/main.c:574: if(gb8_get_key(gb8_v[_instr_hi & 0x0F])) gb8_pc += 2;
	ldhl	sp,#10
	ld	c, (hl)
	ld	b, #0x00
	ld	a, c
	and	a, #0x0f
	ld	c, a
	ld	b, #0x00
	ld	hl, #_gb8_v
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	a, (bc)
	push	af
	inc	sp
	call	_gb8_get_key
	inc	sp
	ld	a, e
	or	a, a
	jp	Z, 00171$
	ld	hl, #_gb8_pc
	ld	a, (hl)
	add	a, #0x02
	ld	(hl+), a
	ld	a, (hl)
	adc	a, #0x00
	ld	(hl), a
;src/main.c:575: break;
	jp	00171$
;src/main.c:576: case GB8_INSTR_SKIP_KEY_NOT_PRSD:
00140$:
;src/main.c:577: if(!(gb8_get_key(gb8_v[_instr_hi & 0x0F]))) gb8_pc += 2;
	ldhl	sp,#10
	ld	c, (hl)
	ld	b, #0x00
	ld	a, c
	and	a, #0x0f
	ld	c, a
	ld	b, #0x00
	ld	hl, #_gb8_v
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	a, (bc)
	push	af
	inc	sp
	call	_gb8_get_key
	inc	sp
	ld	a, e
	or	a, a
	jp	NZ, 00171$
	ld	hl, #_gb8_pc
	ld	a, (hl)
	add	a, #0x02
	ld	(hl+), a
	ld	a, (hl)
	adc	a, #0x00
	ld	(hl), a
;src/main.c:580: break;
	jp	00171$
;src/main.c:581: case GB8_INSTR_SPEC2:
00144$:
;src/main.c:582: switch(_instr_lo){
	ldhl	sp,#11
	ld	a, (hl)
	sub	a, #0x07
	jp	Z,00145$
	ldhl	sp,#11
	ld	a, (hl)
	sub	a, #0x0a
	jp	Z,00146$
	ldhl	sp,#11
	ld	a, (hl)
	sub	a, #0x15
	jp	Z,00152$
	ldhl	sp,#11
	ld	a, (hl)
	sub	a, #0x18
	jp	Z,00153$
	ldhl	sp,#11
	ld	a, (hl)
	sub	a, #0x1e
	jp	Z,00154$
	ldhl	sp,#11
	ld	a, (hl)
	sub	a, #0x29
	jp	Z,00155$
	ldhl	sp,#11
	ld	a, (hl)
	sub	a, #0x33
	jp	Z,00156$
	ldhl	sp,#11
	ld	a, (hl)
	sub	a, #0x55
	jp	Z,00215$
	ldhl	sp,#11
	ld	a, (hl)
	sub	a, #0x65
	jp	Z,00217$
	jp	00171$
;src/main.c:583: case GB8_INSTR_SPEC2_LOAD_VX_DELAY:
00145$:
;src/main.c:584: gb8_v[_instr_hi & 0x0F] = gb8_delay_timer;
	ldhl	sp,#10
	ld	c, (hl)
	ld	b, #0x00
	ld	a, c
	and	a, #0x0f
	ld	c, a
	ld	b, #0x00
	ld	hl, #_gb8_v
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	hl, #_gb8_delay_timer
	ld	a, (hl)
	ld	(bc), a
;src/main.c:585: break;
	jp	00171$
;src/main.c:586: case GB8_INSTR_SPEC2_WAIT_KEY_VX:
00146$:
;src/main.c:587: {   uint8_t _key, _any_key_pressed = 0;
	ldhl	sp,#7
	ld	(hl), #0x00
;src/main.c:588: for(_key = 0; _key < 16; _key++){
	ldhl	sp,#0
	ld	(hl), #0x00
	ld	b, #0x00
00163$:
;src/main.c:589: _any_key_pressed |= gb8_get_key(_key);
	push	bc
	push	bc
	inc	sp
	call	_gb8_get_key
	inc	sp
	ld	a, e
	pop	bc
	ldhl	sp,#7
	or	a, (hl)
	ld	(hl), a
;src/main.c:590: if(gb8_get_key(_key)){
	push	bc
	push	bc
	inc	sp
	call	_gb8_get_key
	inc	sp
	pop	bc
	ld	a, e
	or	a, a
	jr	Z,00164$
;src/main.c:591: gb8_v[_instr_hi & 0x0F] = _key;
	ldhl	sp,#10
	ld	c, (hl)
	ld	b, #0x00
	ld	a, c
	and	a, #0x0f
	ld	c, a
	ld	b, #0x00
	ld	hl, #_gb8_v
	add	hl, bc
	ld	c, l
	ld	b, h
	ldhl	sp,#0
	ld	a, (hl)
	ld	(bc), a
;src/main.c:592: break;
	jr	00149$
00164$:
;src/main.c:588: for(_key = 0; _key < 16; _key++){
	inc	b
	ldhl	sp,#0
	ld	(hl), b
	ld	a, b
	sub	a, #0x10
	jp	C, 00163$
00149$:
;src/main.c:595: if(!_any_key_pressed) gb8_pc -= 2;
	ldhl	sp,#7
	ld	a, (hl)
	or	a, a
	jp	NZ, 00171$
	ld	hl, #_gb8_pc + 1
	dec	hl
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	dec	de
	dec	de
	dec	hl
	ld	(hl), e
	inc	hl
	ld	(hl), d
;src/main.c:597: break;
	jp	00171$
;src/main.c:598: case GB8_INSTR_SPEC2_LOAD_DELAY_VX:
00152$:
;src/main.c:599: gb8_delay_timer = gb8_v[_instr_hi & 0x0F];
	ldhl	sp,#10
	ld	c, (hl)
	ld	b, #0x00
	ld	a, c
	and	a, #0x0f
	ld	c, a
	ld	b, #0x00
	ld	hl, #_gb8_v
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	a, (bc)
	ld	hl, #_gb8_delay_timer
	ld	(hl), a
;src/main.c:600: break;
	jp	00171$
;src/main.c:601: case GB8_INSTR_SPEC2_LOAD_SOUND_VX:
00153$:
;src/main.c:602: gb8_sound_timer = gb8_v[_instr_hi & 0x0F];
	ldhl	sp,#10
	ld	c, (hl)
	ld	b, #0x00
	ld	a, c
	and	a, #0x0f
	ld	c, a
	ld	b, #0x00
	ld	hl, #_gb8_v
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	a, (bc)
	ld	hl, #_gb8_sound_timer
	ld	(hl), a
;src/main.c:603: break;
	jp	00171$
;src/main.c:604: case GB8_INSTR_SPEC2_ADD_I_VX:
00154$:
;src/main.c:605: gb8_i += gb8_v[_instr_hi & 0x0F];
	ldhl	sp,#10
	ld	c, (hl)
	ld	b, #0x00
	ld	a, c
	and	a, #0x0f
	ld	c, a
	ld	b, #0x00
	ld	hl, #_gb8_v
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	a, (bc)
	ld	c, a
	ld	b, #0x00
	ld	hl, #_gb8_i
	ld	a, (hl)
	add	a, c
	ld	(hl+), a
	ld	a, (hl)
	adc	a, b
	ld	(hl), a
;src/main.c:606: break;
	jp	00171$
;src/main.c:607: case GB8_INSTR_SPEC2_LOAD_I_SPR_VX:
00155$:
;src/main.c:608: gb8_i = 5 * gb8_v[_instr_hi & 0x0F];
	ldhl	sp,#10
	ld	c, (hl)
	ld	b, #0x00
	ld	a, c
	and	a, #0x0f
	ld	c, a
	ld	b, #0x00
	ld	hl, #_gb8_v
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	a, (bc)
	ld	c, a
	ld	b, #0x00
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, hl
	add	hl, bc
	ld	a, l
	ld	d, h
	ld	hl, #_gb8_i
	ld	(hl+), a
	ld	(hl), d
;src/main.c:609: break;
	jp	00171$
;src/main.c:610: case GB8_INSTR_SPEC2_BCD_I_VX:
00156$:
;src/main.c:611: gb8_bcd_vx(_instr_hi & 0x0F);
	ldhl	sp,#10
	ld	a, (hl)
	and	a, #0x0f
	push	af
	inc	sp
	call	_gb8_bcd_vx
	inc	sp
;src/main.c:612: break;
	jp	00171$
;src/main.c:614: for(uint8_t i = 0; i < ((_instr_hi & 0x0F) + 1); i++) gb8_mem[gb8_i + i] = gb8_v[i];
00215$:
	ldhl	sp,#9
	ld	(hl), #0x00
00166$:
	ldhl	sp,#10
	ld	c, (hl)
	ld	b, #0x00
	ld	a, c
	and	a, #0x0f
	ld	c, a
	ld	b, #0x00
	inc	bc
	inc	sp
	inc	sp
	push	bc
	dec	hl
	ld	c, (hl)
	ld	b, #0x00
	ldhl	sp,#0
	ld	a, c
	sub	a, (hl)
	inc	hl
	ld	a, b
	sbc	a, (hl)
	ld	a, b
	ld	d, a
	ld	e, (hl)
	bit	7, e
	jr	Z,00411$
	bit	7, d
	jr	NZ,00412$
	cp	a, a
	jr	00412$
00411$:
	bit	7, d
	jr	Z,00412$
	scf
00412$:
	jp	NC, 00158$
	ld	a, c
	ld	hl, #_gb8_i
	add	a, (hl)
	ld	c, a
	ld	a, b
	inc	hl
	adc	a, (hl)
	ld	b, a
	ld	hl, #_gb8_mem
	add	hl, bc
	ld	a, l
	ld	d, h
	ldhl	sp,#2
	ld	(hl+), a
	ld	(hl), d
	ld	de, #_gb8_v
	ldhl	sp,#9
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	ld	c, a
	ldhl	sp,#2
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), c
	ldhl	sp,#9
	inc	(hl)
	jp	00166$
00158$:
;src/main.c:615: gb8_i += (_instr_hi & 0x0F) + 1;
	pop	bc
	push	bc
	ld	hl, #_gb8_i
	ld	a, (hl)
	add	a, c
	ld	(hl+), a
	ld	a, (hl)
	adc	a, b
	ld	(hl), a
;src/main.c:616: break;
	jp	00171$
;src/main.c:618: for(uint8_t i = 0; i < ((_instr_hi & 0x0F) + 1); i++) gb8_v[i] = gb8_mem[gb8_i + i];
00217$:
	ldhl	sp,#8
	ld	(hl), #0x00
00169$:
	ldhl	sp,#10
	ld	c, (hl)
	ld	b, #0x00
	ld	a, c
	and	a, #0x0f
	ld	c, a
	ld	b, #0x00
	inc	bc
	inc	sp
	inc	sp
	push	bc
	dec	hl
	dec	hl
	ld	c, (hl)
	ld	b, #0x00
	ldhl	sp,#0
	ld	a, c
	sub	a, (hl)
	inc	hl
	ld	a, b
	sbc	a, (hl)
	ld	a, b
	ld	d, a
	ld	e, (hl)
	bit	7, e
	jr	Z,00413$
	bit	7, d
	jr	NZ,00414$
	cp	a, a
	jr	00414$
00413$:
	bit	7, d
	jr	Z,00414$
	scf
00414$:
	jp	NC, 00160$
	ld	de, #_gb8_v
	ldhl	sp,#8
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
	ld	a, l
	ld	d, h
	ldhl	sp,#2
	ld	(hl+), a
	ld	(hl), d
	ld	a, c
	ld	hl, #_gb8_i
	add	a, (hl)
	ld	c, a
	ld	a, b
	inc	hl
	adc	a, (hl)
	ld	b, a
	ld	hl, #_gb8_mem
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	a, (bc)
	ld	c, a
	ldhl	sp,#2
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), c
	ldhl	sp,#8
	inc	(hl)
	jp	00169$
00160$:
;src/main.c:619: gb8_i += (_instr_hi & 0x0F) + 1;
	pop	bc
	push	bc
	ld	hl, #_gb8_i
	ld	a, (hl)
	add	a, c
	ld	(hl+), a
	ld	a, (hl)
	adc	a, b
	ld	(hl), a
;src/main.c:623: }
00171$:
;src/main.c:624: }
	add	sp, #12
	ret
	.area _CODE
	.area _CABS (ABS)
