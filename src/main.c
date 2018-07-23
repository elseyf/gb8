/**
 * gb8 - Chip-8 Emulator for GameBoy, by el_seyf
*/

//Disable Warnings
#pragma disable_warning 158
#pragma disable_warning 59

#include <stdint.h>
#include <stdbool.h>
#include "gb.h"

#define fp8(_f)                 ((int16_t)(_f*256))
typedef int16_t fp8_t;

#define BG_PALETTE  0xE4
#define OBJ_PAL_0   0xE4
#define OBJ_PAL_1   0x27
#define GB8_PAL_0   0xF0
#define GB8_PAL_1   0xCC

#define SCREEN_W    20
#define SCREEN_H    18

#define GB8_INSTR_PER_FRAME 7 //equals 480Hz

#define GB8_PROGRAM_START   0x0200
#define GB8_PC_STACK_SIZE   32

//Instruction Types:
#define GB8_INSTR_SPEC          0x0
    #define GB8_INSTR_SPEC_CLR_SCRN         0xE0
    #define GB8_INSTR_SPEC_RETURN           0xEE
#define GB8_INSTR_JUMP_N        0x1
#define GB8_INSTR_CALL_N        0x2
#define GB8_INSTR_SKIP_EQ_VX_N  0x3
#define GB8_INSTR_SKIP_NE_VX_N  0x4
#define GB8_INSTR_SKIP_EQ_VX_VY 0x5
#define GB8_INSTR_LOAD_VX_N     0x6
#define GB8_INSTR_ADD_VX_N      0x7
#define GB8_INSTR_ARITH         0x8
    #define GB8_INSTR_ARITH_LOAD_VX_VY      0x0
    #define GB8_INSTR_ARITH_OR_VX_VY        0x1
    #define GB8_INSTR_ARITH_AND_VX_VY       0x2
    #define GB8_INSTR_ARITH_XOR_VX_VY       0x3
    #define GB8_INSTR_ARITH_ADD_VX_VY       0x4
    #define GB8_INSTR_ARITH_SUB_VX_VY       0x5
    #define GB8_INSTR_ARITH_SHR_VX_VY       0x6
    #define GB8_INSTR_ARITH_SUB_VY_VX       0x7
    #define GB8_INSTR_ARITH_SHL_VX_VY       0xE
#define GB8_INSTR_SKIP_NE_VX_VY 0x9
#define GB8_INSTR_LOAD_I_N      0xA
#define GB8_INSTR_JMP_N_V0      0xB
#define GB8_INSTR_RND_VX_N      0xC
#define GB8_INSTR_DRAW_SPR      0xD
#define GB8_INSTR_SKIP_KEY      0xE
    #define GB8_INSTR_SKIP_KEY_PRSD         0x9E
    #define GB8_INSTR_SKIP_KEY_NOT_PRSD     0xA1
#define GB8_INSTR_SPEC2         0xF
    #define GB8_INSTR_SPEC2_LOAD_VX_DELAY   0x07
    #define GB8_INSTR_SPEC2_WAIT_KEY_VX     0x0A
    #define GB8_INSTR_SPEC2_LOAD_DELAY_VX   0x15
    #define GB8_INSTR_SPEC2_LOAD_SOUND_VX   0x18
    #define GB8_INSTR_SPEC2_ADD_I_VX        0x1E
    #define GB8_INSTR_SPEC2_LOAD_I_SPR_VX   0x29
    #define GB8_INSTR_SPEC2_BCD_I_VX        0x33
    #define GB8_INSTR_SPEC2_LOAD_I_V0_VX    0x55
    #define GB8_INSTR_SPEC2_LOAD_V0_VX_I    0x65

uint16_t sp_buffer;

uint16_t gb8_pc;
uint16_t gb8_stack[GB8_PC_STACK_SIZE];
uint8_t gb8_stack_p;
uint8_t gb8_v[16];
uint8_t gb8_seed;
uint16_t gb8_i;
uint8_t gb8_delay_timer;
uint8_t gb8_sound_timer;
uint8_t gb8_mem[4096];

__at(0xD800) uint8_t gb8_display[512];

extern const uint16_t pixel_scale_table[256];

/* CHIP-8 Keypad
 *  -------
 * |1|2|3|C|
 * |4|5|6|D|
 * |7|8|9|E|
 * |A|0|B|F|
 *  -------
*/
//F8Z Map:
const uint8_t gb8_key_map[16] = {
    0x00,
    0x00,       0x00,       0x00,
    KEY_B,      KEY_UP,     KEY_A,
    KEY_LEFT,   KEY_DOWN,   KEY_RIGHT,
    0x00,                   0x00,
    0x00,       0x00,       0x00,       0x00
};
//Tetris Map:
/*const uint8_t gb8_key_map[16] = {
    0x00,
    0x00,       0x00,       0x00,
    KEY_A,      KEY_LEFT,   KEY_RIGHT,
    KEY_DOWN,   0x00,       0x00,
    0x00,                   0x00,
    0x00,       0x00,       0x00,       0x00
};*/


const uint8_t gb8_font[80] = {
    0xF0, 0x90, 0x90, 0x90, 0xF0,
    0x20, 0x60, 0x20, 0x20, 0x70,
    0xF0, 0x10, 0xF0, 0x80, 0xF0,
    0xF0, 0x10, 0xF0, 0x10, 0xF0,
    0x90, 0x90, 0xF0, 0x10, 0x10,
    0xF0, 0x80, 0xF0, 0x10, 0xF0,
    0xF0, 0x80, 0xF0, 0x90, 0xF0,
    0xF0, 0x10, 0x20, 0x40, 0x40,
    0xF0, 0x90, 0xF0, 0x90, 0xF0,
    0xF0, 0x90, 0xF0, 0x10, 0xF0,
    0xF0, 0x90, 0xF0, 0x90, 0x90,
    0xE0, 0x90, 0xE0, 0x90, 0xE0,
    0xF0, 0x80, 0x80, 0x80, 0xF0,
    0xE0, 0x90, 0x90, 0x90, 0xE0,
    0xF0, 0x80, 0xF0, 0x80, 0xF0,
    0xF0, 0x80, 0xF0, 0x80, 0x80
};

extern const uint8_t rom[3584];


void gb8_clear_screen();
uint8_t gb8_get_key(uint8_t _key);
void gb8_draw_sprite(uint8_t _px, uint8_t _py, uint8_t _n);
void gb8_bcd_vx(uint8_t _vx);
uint8_t gb8_rnd();
void gb8_step();

void main(){
    disable_display();
    fastcpy(HRAM, oam_dma_wait, oam_dma_wait_size);
    
    vblank_happened = false;
    enable_lcd_stat_int(LCD_STAT_LYC_LY_INT | LCD_STAT_MODE_0_INT);
    set_lyc(0x91);
    
    set_bg_pal(GB8_PAL_0);
    set_obj_pal0(OBJ_PAL_0);
    set_obj_pal1(OBJ_PAL_1);
    
    set_bg_map_select(false);
    set_bg_chr(bg_tiles, 0x0000, sizeof(bg_tiles));
    fill(BG_MAP, 0x7F, 0x0400);
    set_bg_scroll(0, 0);
    
    for(uint8_t i = 0; i < 4; i++)
        for(uint8_t j = 0; j < 16; j++)
            set_bg_map_tile_xy(j + 2, i + 8, ((i * 16) + j) & 0x1F);
    
    disable_obj();
    disable_win();
    enable_bg();
    enable_display();
    
    fastcpy(&gb8_mem, &gb8_font, sizeof(gb8_font));
    fastcpy(&gb8_mem + GB8_PROGRAM_START, &rom, sizeof(rom));
    gb8_pc = GB8_PROGRAM_START;
    gb8_stack_p = 0;
    for(uint8_t i = 0; i < 16; i++) gb8_v[i] = 0;
    gb8_i = 0;
    gb8_delay_timer = 0;
    gb8_sound_timer = 0;
    
    clear_int_request_flags();
    enable_int(VBLANK_INT | LCD_STAT_INT);
    ei();
    
    while(1){
        while(!vblank_happened) halt();
        vblank_happened = false;
        read_joypad();
        
        for(uint8_t i = 0; i < GB8_INSTR_PER_FRAME; i++) gb8_step();
        //Update Timers once every frame:
        if(gb8_delay_timer > 0) gb8_delay_timer--;
        if(gb8_sound_timer > 0) gb8_sound_timer--;
        
        //obj_slot = 0;
        //fill((void*)(((uint16_t)obj) + (obj_slot << 2)), 0xFF, sizeof(obj) - (obj_slot << 2));
    }
}

void gb8_clear_screen(){
    fill(&gb8_display, 0x00, sizeof(gb8_display));
}

uint8_t gb8_get_key(uint8_t _key){
    return key_hold(gb8_key_map[_key]);
}

void gb8_draw_sprite(uint8_t _px, uint8_t _py, uint8_t _n){
    _px = _px; _py = _py; _n = _n;
    __asm
        line = 0
        qbyte = 1
        px = 7
        py = 8
        n =  9
        dest_p = 2
        src_b = 0
        
        add sp, #-5
        
        ld hl, #(_gb8_v + 0x0F) ;gb8_v[0xF] = 0
        ld (hl), #0
        
        ld bc, #_gb8_display    ;dest_p = dest pixel in display
        
        ldhl sp, #py
        ld a, (hl)
        ld hl, #0
        bit 3, a
        jr z, 20$
            inc h
   20$: bit 4, a
        jr z, 21$
            inc l
   21$: and #0x07
        add a
        add l
        ld l, a
        add hl, bc
        ld b, h
        ld c, l
        
        ldhl sp, #px
        ld a, (hl)
        and #0x38
        sla a
        sla a
        ld l, a
        ld h, #0
        add hl, bc
        ld b, h
        ld c, l
        push bc
        
        ld de, #_gb8_mem        ;src_b = src byte from font
        ld hl, #_gb8_i
        ld a, (hl+)
        ld h, (hl)
        ld l, a
        add hl, de
        ld d, h
        ld e, l
        push de
        
        ldhl sp, #(n + 4)
        ld a, (hl)
        and #0x0F
        ld (hl), a
        jp z, 10$
            
            ldhl sp, #(line + 4)
            ld (hl), #0
            
        0$: ldhl sp, #src_b
            ld a, (hl+)
            ld h, (hl)
            ld l, a
            ld c, (hl)
            ld b, #0
            sla c
            rl b
            
            ld hl, #_pixel_scale_table
            add hl, bc
            
            ld a, (hl+)
            ld c, a
            ld b, (hl)
            xor a
            ld e, a
            ld d, a
            
            ldhl sp, #(px + 4)
            ld a, (hl)
            and #0x07
            jr z, 2$
        1$: srl c
            rr b
            rr e
            rr d
            srl c
            rr b
            rr e
            rr d
            dec a
            jr nz, 1$
        2$: ldhl sp, #(qbyte + 4)
            ld a, c
            ld (hl+), a
            ld a, b
            ld (hl+), a
            ld a, e
            ld (hl+), a
            ld (hl), d
            
            ldhl sp, #(py + 4)
            ld a, (hl)
            ldhl sp, #(line + 4)
            ld d, (hl)
            add (hl)
            ld e, a
            ldhl sp, #dest_p
            ld a, (hl+)
            ld b, (hl)
            ld c, a
            
            ld a, d
            add a
            add c
            and #0x0F
            ld d, a
            ld a, c
            and #0xF0
            add d
            ld c, a
            
            ld a, b
            bit 3, e
            jr z, 40$
                or  #0x01
                jr 41$
            40$:and #0xFE
       41$: ld b, a
            ld a, c
            bit 4, e
            jr z, 42$
                or  #0x01
                jr 43$
            42$:and #0xFE
       43$: ld c, a
            
            ld e, #0
            ldhl sp, #(qbyte + 4 + 0)
            ld a, (bc)
            ld d, a
            xor (hl)
            ld (bc), a
            ld a, (hl+)
            and d
            jr z, 30$
                ld e, #1
       30$: ld a, c
            add #16
            ld c, a
            
            ld a, (bc)
            ld d, a
            xor (hl)
            ld (bc), a
            ld a, (hl+)
            and d
            jr z, 31$
                ld e, #1
       31$: ld a, c
            add #16
            ld c, a
            
            ld a, (bc)
            ld d, a
            xor (hl)
            ld (bc), a
            ld a, (hl+)
            and d
            jr z, 32$
                ld e, #1
       32$: ld a, c
            add #16
            ld c, a
            
            ld a, (bc)
            ld d, a
            xor (hl)
            ld (bc), a
            ld a, (hl+)
            and d
            jr z, 33$
                ld e, #1
       33$: ld a, c
            add #16
            ld c, a
            
            ld hl, #(_gb8_v + 0x0F) ;gb8_v[0xF] = e
            ld a, (hl)
            or e
            ld (hl), a
            
        4$: ldhl sp, #src_b
            inc (hl)
            jr nz, 5$
                inc hl
                inc (hl)
            
        5$: ldhl sp, #(line + 4)
            inc (hl)
            
        9$: ldhl sp, #(n + 4)
            dec (hl)
            jp nz, 0$
            
       10$: add sp, #9
    __endasm;
}

void gb8_bcd_vx(uint8_t _vx){
    _vx = _vx;
    __asm
        vx = 2
        
        ldhl sp, #vx
        ld l, (hl)
        ld h, #0
        ld bc, #_gb8_v
        add hl, bc
        ld e, (hl)
        
        ld hl, #_gb8_mem
        ld a, (_gb8_i)
        ld c, a
        ld a, (_gb8_i + 1)
        ld b, a
        add hl, bc
        
        ld a, e
        ld d, #-100
        call 10$
        ld (hl), b
        inc hl
        
        ld d, #-10
        call 10$
        ld (hl), b
        inc hl
        
        ld d, #-1
        call 10$
        ld (hl), b
        ret
        
   10$: ld b, #-1
   11$: inc b
        add d
        jr c, 11$
        sbc d
        ret
    __endasm;
}

uint8_t gb8_rnd(){
    __asm
        ld a, (_gb8_seed)
        ld b, a
        rrca
        rrca
        rrca
        xor #0x1F
        add b
        sbc #0xFF
        ld e, a
        ldh a, (REG_DIV)
        add e
        ld (_gb8_seed), a
        ld e, a
    __endasm;
}

void gb8_step(){
    uint8_t _instr_hi = gb8_mem[gb8_pc++];
    uint8_t _instr_lo = gb8_mem[gb8_pc++];
    
    switch(_instr_hi >> 4){
        case GB8_INSTR_SPEC:
            switch(_instr_lo){
                case GB8_INSTR_SPEC_CLR_SCRN:
                    gb8_clear_screen();
                    break;
                case GB8_INSTR_SPEC_RETURN:
                    gb8_pc = gb8_stack[--gb8_stack_p];
                    break;
            }
            break;
        case GB8_INSTR_JUMP_N:
            gb8_pc = ((_instr_hi & 0x0F) << 8) | _instr_lo;
            break;
        case GB8_INSTR_CALL_N:
            gb8_stack[gb8_stack_p++] = gb8_pc;
            gb8_pc = ((_instr_hi & 0x0F) << 8) | _instr_lo;
            break;
        case GB8_INSTR_SKIP_EQ_VX_N:
            if(gb8_v[_instr_hi & 0x0F] == _instr_lo) gb8_pc += 2;
            break;
        case GB8_INSTR_SKIP_NE_VX_N:
            if(gb8_v[_instr_hi & 0x0F] != _instr_lo) gb8_pc += 2;
            break;
        case GB8_INSTR_SKIP_EQ_VX_VY:
            if(gb8_v[_instr_hi & 0x0F] == gb8_v[_instr_lo >> 4]) gb8_pc += 2;
            break;
        case GB8_INSTR_LOAD_VX_N:
            gb8_v[_instr_hi & 0x0F] = _instr_lo;
            break;
        case GB8_INSTR_ADD_VX_N:
            gb8_v[_instr_hi & 0x0F] += _instr_lo;
            break;
        case GB8_INSTR_ARITH:
            switch(_instr_lo & 0x0F){
                case GB8_INSTR_ARITH_LOAD_VX_VY:
                    gb8_v[_instr_hi & 0x0F] = gb8_v[_instr_lo >> 4];
                    break;
                case GB8_INSTR_ARITH_OR_VX_VY:
                    gb8_v[_instr_hi & 0x0F] |= gb8_v[_instr_lo >> 4];
                    break;
                case GB8_INSTR_ARITH_AND_VX_VY:
                    gb8_v[_instr_hi & 0x0F] &= gb8_v[_instr_lo >> 4];
                    break;
                case GB8_INSTR_ARITH_XOR_VX_VY:
                    gb8_v[_instr_hi & 0x0F] ^= gb8_v[_instr_lo >> 4];
                    break;
                case GB8_INSTR_ARITH_ADD_VX_VY:
                    gb8_v[0xF] = (((uint16_t)gb8_v[_instr_hi & 0x0F] + gb8_v[_instr_lo >> 4]) > 0x100) ? 1 : 0;
                    gb8_v[_instr_hi & 0x0F] += gb8_v[_instr_lo >> 4];
                    break;
                case GB8_INSTR_ARITH_SUB_VX_VY:
                    gb8_v[0xF] = (((int16_t)gb8_v[_instr_hi & 0x0F] - gb8_v[_instr_lo >> 4]) < 0) ? 0 : 1;
                    gb8_v[_instr_hi & 0x0F] -= gb8_v[_instr_lo >> 4];
                    break;
                case GB8_INSTR_ARITH_SHR_VX_VY:
                    gb8_v[0xF] = gb8_v[_instr_lo >> 4] & 0x01;
                    gb8_v[_instr_hi & 0x0F] = gb8_v[_instr_lo >> 4] >> 1;
                    break;
                case GB8_INSTR_ARITH_SUB_VY_VX:
                    gb8_v[0xF] = (((int16_t)gb8_v[_instr_lo >> 4] - gb8_v[_instr_hi & 0x0F]) < 0) ? 0 : 1;
                    gb8_v[_instr_hi & 0x0F] = gb8_v[_instr_lo >> 4] - gb8_v[_instr_hi & 0x0F];
                    break;
                case GB8_INSTR_ARITH_SHL_VX_VY:
                    gb8_v[0xF] = gb8_v[_instr_lo >> 4] >> 7;
                    gb8_v[_instr_hi & 0x0F] = gb8_v[_instr_lo >> 4] << 1;
                    break;
            }
            break;
        case GB8_INSTR_SKIP_NE_VX_VY:
            if(gb8_v[_instr_hi & 0x0F] != gb8_v[_instr_lo >> 4]) gb8_pc += 2;
            break;
        case GB8_INSTR_LOAD_I_N:
            gb8_i = ((_instr_hi & 0x0F) << 8) | _instr_lo;
            break;
        case GB8_INSTR_JMP_N_V0:
            gb8_pc = (((_instr_hi & 0x0F) << 8) | _instr_lo) + gb8_v[0];
            break;
        case GB8_INSTR_RND_VX_N:
            gb8_v[_instr_hi & 0x0F] = gb8_rnd() & _instr_lo;
            break;
        case GB8_INSTR_DRAW_SPR:
            gb8_draw_sprite(gb8_v[_instr_hi & 0x0F], gb8_v[_instr_lo >> 4], _instr_lo & 0x0F);
            break;
        case GB8_INSTR_SKIP_KEY:
            switch(_instr_lo){
                case GB8_INSTR_SKIP_KEY_PRSD:
                    if(gb8_get_key(gb8_v[_instr_hi & 0x0F])) gb8_pc += 2;
                    break;
                case GB8_INSTR_SKIP_KEY_NOT_PRSD:
                    if(!(gb8_get_key(gb8_v[_instr_hi & 0x0F]))) gb8_pc += 2;
                    break;
            }
            break;
        case GB8_INSTR_SPEC2:
            switch(_instr_lo){
                case GB8_INSTR_SPEC2_LOAD_VX_DELAY:
                    gb8_v[_instr_hi & 0x0F] = gb8_delay_timer;
                    break;
                case GB8_INSTR_SPEC2_WAIT_KEY_VX:
                    {   uint8_t _key, _any_key_pressed = 0;
                        for(_key = 0; _key < 16; _key++){
                            _any_key_pressed |= gb8_get_key(_key);
                            if(gb8_get_key(_key)){
                                gb8_v[_instr_hi & 0x0F] = _key;
                                break;
                            }
                        }
                        if(!_any_key_pressed) gb8_pc -= 2;
                    }
                    break;
                case GB8_INSTR_SPEC2_LOAD_DELAY_VX:
                    gb8_delay_timer = gb8_v[_instr_hi & 0x0F];
                    break;
                case GB8_INSTR_SPEC2_LOAD_SOUND_VX:
                    gb8_sound_timer = gb8_v[_instr_hi & 0x0F];
                    break;
                case GB8_INSTR_SPEC2_ADD_I_VX:
                    gb8_i += gb8_v[_instr_hi & 0x0F];
                    break;
                case GB8_INSTR_SPEC2_LOAD_I_SPR_VX:
                    gb8_i = 5 * gb8_v[_instr_hi & 0x0F];
                    break;
                case GB8_INSTR_SPEC2_BCD_I_VX:
                    gb8_bcd_vx(_instr_hi & 0x0F);
                    break;
                case GB8_INSTR_SPEC2_LOAD_I_V0_VX:
                    for(uint8_t i = 0; i < ((_instr_hi & 0x0F) + 1); i++) gb8_mem[gb8_i + i] = gb8_v[i];
                    gb8_i += (_instr_hi & 0x0F) + 1;
                    break;
                case GB8_INSTR_SPEC2_LOAD_V0_VX_I:
                    for(uint8_t i = 0; i < ((_instr_hi & 0x0F) + 1); i++) gb8_v[i] = gb8_mem[gb8_i + i];
                    gb8_i += (_instr_hi & 0x0F) + 1;
                    break;
            }
            break;
    }
}

