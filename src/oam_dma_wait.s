;OAM DMA Routine, by el_seyf

.module oam_dma_wait

.globl _oam_dma_wait
.globl _oam_dma_wait_end
.globl _oam_dma_wait_size
.globl _obj
_oam_dma_wait:
    ld a, #(_obj >> 8)          ;Use DMA on OAM Buffer          ; 2 Bytes
    ldh (0x46), a               ;Transfer takes 160 * 4 Cycles  ; 2 Bytes
    ld a, #40                   ;Wait for (40 * 16)             ; 2 Bytes
    loop:                       ;         + 8 + 16 Cycles
        dec a                   ;                               ; 1 Bytes
        jr nz, loop             ;                               ; 2 Bytes
    ret                         ;                               ; 1 Bytes
                                ;                               ; = 10 Bytes
_oam_dma_wait_end:
_oam_dma_wait_size:
    .db (_oam_dma_wait_end - _oam_dma_wait)
