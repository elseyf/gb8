/**
 * GameBoy Hardware Abstraction Layer, by el_seyf
 * Contains functions and defines for GameBoy Hardware
*/

#ifndef GB_H
#define GB_H

#include <stdint.h>
#include <stdbool.h>

#define offsetof(_type, _member)    ((uint8_t)__builtin_offsetof(_type, _member))
#define num_elements(_a)            (sizeof(_a) / (sizeof(*_a)))
#define ei()                        __asm__("ei")
#define di()                        __asm__("di")
#define halt()                      __asm__("halt\nnop")
#define stop()                      __asm__("stop")
#define call(_a)                    __asm call _a __endasm
#define reg(_a)                     ((volatile uint8_t*)_a)
#define alloc_stack(_a,_size)       volatile uint8_t _a[_size]
#define rgb(_r,_g,_b)               ((uint16_t)(((_b & 0x1F) << 10) | ((_g & 0x1F) << 5) | (_r & 0x1F)))
#define break()                     __asm__("ld b,b")

#define ROM_START_ADDR  _main

#define OBJ_CHR_ADDR    0x8000
#define BG_CHR_ADDR     0x8000
#define BG_MAP_ADDR     0x9800
#define WIN_MAP_ADDR    0x9C00
#define OBJ_CHR         ((uint8_t*)OBJ_CHR_ADDR)
#define BG_CHR          ((uint8_t*)BG_CHR_ADDR)
#define BG_MAP          ((uint8_t*)BG_MAP_ADDR)
#define WIN_MAP         ((uint8_t*)WIN_MAP_ADDR)

#define WRAM            ((uint8_t*)0xC000)
#define HRAM            ((uint8_t*)0xFF80)

#define REG_JOY0            0xFF00
    #define KEY_OFF         0x30
    #define KEY_DIR         0x20
    #define KEY_BTN         0x10
    #define KEY_DOWN        0x80
    #define KEY_UP          0x40
    #define KEY_LEFT        0x20
    #define KEY_RIGHT       0x10
    #define KEY_START       0x08
    #define KEY_SELECT      0x04
    #define KEY_B           0x02
    #define KEY_A           0x01
    #define KEY_ANY_DIR     0xF0
    #define KEY_ANY_BTN     0x0F

#define REG_DIV             0xFF04
#define REG_TIMA            0xFF05
#define REG_TMA             0xFF06
#define REG_TAC             0xFF07

#define REG_LCDC            0xFF40
    #define LCDC_DISPLAY_ENABLE             0x80
    #define LCDC_WIN_MAP_SELECT             0x40
    #define LCDC_WIN_ENABLE                 0x20
    #define LCDC_BG_WIN_TILE_DATA_SELECT    0x10
    #define LCDC_BG_MAP_SELECT              0x08
    #define LCDC_OBJ_SIZE                   0x04
    #define LCDC_OBJ_ENABLE                 0x02
    #define LCDC_BG_ENABLE                  0x01
#define REG_LCD_STAT        0xFF41
    #define LCD_STAT_LYC_LY_INT             0x40
    #define LCD_STAT_MODE_2_INT             0x20
    #define LCD_STAT_MODE_1_INT             0x10
    #define LCD_STAT_MODE_0_INT             0x08
    #define LCD_STAT_LYC_LY_EQ_FLAG         0x04
    #define LCD_STAT_MODE_FLAG              0x03

#define REG_BG_SCY          0xFF42
#define REG_BG_SCX          0xFF43
#define REG_LY              0xFF44
#define REG_LYC             0xFF45
#define REG_WY              0xFF4A
#define REG_WX              0xFF4B

#define REG_OAM_DMA         0xFF46

#define REG_BGP             0xFF47
#define REG_OBP0            0xFF48
#define REG_OBP1            0xFF49

#define REG_IF              0xFF0F
#define REG_IE              0xFFFF
    #define JOYPAD_INT      0x10
    #define SERIAL_INT      0x08
    #define TIMER_INT       0x04
    #define LCD_STAT_INT    0x02
    #define VBLANK_INT      0x01

#define SCREEN_WIDTH    160
#define SCREEN_HEIGHT   144

#define MAX_BYTES_PER_VBLANK 32

typedef struct {
    uint8_t y;
    uint8_t x;
    uint8_t tile;
    uint8_t attr;
} obj_t;

typedef uint32_t time_t;

#define HRAM_OAM_DMA_ROUTINE 0xFF80
extern const uint8_t oam_dma_wait[];
extern const uint8_t oam_dma_wait_size;

extern const uint8_t bg_tiles[4096];
extern const uint8_t obj_tiles[2048];

extern obj_t obj[40];
extern uint8_t vram_transfer_size;
extern uint8_t vram_transfer_buffer[4 * MAX_BYTES_PER_VBLANK];
extern uint16_t vram_transfer_addr;
extern __at(0xFFC0) uint8_t hblank_transfer_counter;
extern uint8_t bg_pal, obj_pal0, obj_pal1;
extern uint8_t obj_slot;
extern uint8_t joy0, old_joy0;
extern uint8_t scroll_x, scroll_y;
extern uint8_t offset_x, offset_y;
extern volatile bool vblank_happened;

void vblank_isr() __critical __interrupt __naked;
void lcd_stat_isr() __critical __interrupt __naked;
void timer_isr() __critical __interrupt;
void serial_isr() __interrupt;
void joypad_isr() __interrupt;

inline void enable_int(uint8_t _int){*reg(REG_IE) |= _int;}
inline void disable_int(uint8_t _int){*reg(REG_IE) &= ~(_int);}
inline void clear_int_request_flags(){*reg(REG_IF) = 0x00;}

void init_gameboy();

inline bool display_state(){return (*reg(REG_LCDC) & LCDC_DISPLAY_ENABLE);}
inline void enable_display(){*reg(REG_LCDC) |= LCDC_DISPLAY_ENABLE;}
inline void disable_display(){
    if(display_state()){
        while((*reg(REG_LCD_STAT) & LCD_STAT_MODE_FLAG) != 1); *reg(REG_LCDC) &= ~LCDC_DISPLAY_ENABLE;
    }
}
inline void enable_bg(){*reg(REG_LCDC) |= LCDC_BG_ENABLE;}
inline void disable_bg(){*reg(REG_LCDC) &= ~LCDC_BG_ENABLE;}
inline void enable_win(){*reg(REG_LCDC) |= LCDC_WIN_ENABLE;}
inline void disable_win(){*reg(REG_LCDC) &= ~LCDC_WIN_ENABLE;}
inline void enable_obj(){*reg(REG_LCDC) |= LCDC_OBJ_ENABLE;}
inline void disable_obj(){*reg(REG_LCDC) &= ~LCDC_OBJ_ENABLE;}
void set_bg_map_select(bool _offset);
void set_win_map_select(bool _offset);

inline void enable_lcd_stat_int(uint8_t _int){*reg(REG_LCD_STAT) |= _int;}
inline void disable_lcd_stat_int(uint8_t _int){*reg(REG_LCD_STAT) &= ~_int;}
inline void set_lyc(uint8_t _lyc){*reg(REG_LYC) = _lyc;}

inline bool bg_state(){return (*reg(REG_LCDC) & LCDC_BG_ENABLE);}
inline bool obj_state(){return (*reg(REG_LCDC) & LCDC_OBJ_ENABLE);}

void fastcpy(void* _dst, void* _src, uint16_t _size);
void fill(void* _dst, uint8_t _val, uint16_t _size);

inline void set_bg_pal(uint8_t _data){*reg(REG_BGP) = bg_pal = _data;}
inline void set_obj_pal0(uint8_t _data){*reg(REG_OBP0) = obj_pal0 = _data;}
inline void set_obj_pal1(uint8_t _data){*reg(REG_OBP1) = obj_pal1 = _data;}
inline void update_bg_pal(uint8_t _data){bg_pal = _data;}

void set_bg_chr(uint8_t* _data, uint16_t _addr, uint16_t _size);
void set_bg_map(uint8_t* _data, uint16_t _addr, uint16_t _size);
void set_bg_map_tile(uint16_t _addr, uint8_t _tile);
inline void set_bg_map_tile_xy(uint8_t _x, uint8_t _y, uint8_t _tile){set_bg_map_tile((_y << 5) + _x, _tile);}
void update_bg_map_tile(uint16_t _addr, uint8_t _tile);
inline void update_bg_map_tile_xy(uint8_t _x, uint8_t _y, uint8_t _tile){update_bg_map_tile((_y << 5) + _x, _tile);}

void set_win_map(uint8_t* _data, uint16_t _addr, uint16_t _size);
void set_win_map_tile(uint16_t _addr, uint8_t _tile);
inline void set_win_map_tile_xy(uint8_t _x, uint8_t _y, uint8_t _tile){set_win_map_tile((_y << 5) + _x, _tile);}
void update_win_map_tile(uint16_t _addr, uint8_t _tile);
inline void update_win_map_tile_xy(uint8_t _x, uint8_t _y, uint8_t _tile){update_win_map_tile((_y << 5) + _x, _tile);}

void set_obj_chr(uint8_t* _data, uint16_t _addr, uint16_t _size);
void set_obj(obj_t* _obj, uint8_t _x, uint8_t _y, uint8_t _tile, uint8_t _attr);
uint8_t copy_to_oam_obj(obj_t* _obj, uint8_t _slot);

inline void set_bg_scroll(uint8_t _sx, uint8_t _sy){scroll_x = _sx; scroll_y = _sy;}
inline void set_win_offset(uint8_t _ox, uint8_t _oy){offset_x = _ox + 7; offset_y = _oy;}

void read_joypad();
bool key_push(uint8_t _key);
bool key_hold(uint8_t _key);
bool key_release(uint8_t _key);

#endif
