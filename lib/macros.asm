.MACRO LoadRAM
  ldx.w #\1                   ;Get lower 16-bits of source
  stx $4302                   ;Set source offset
  lda #:\1                    ;Get upper 8-bits of source
  sta $4304                   ;Set source bank
  ldx.b #\3                   ;
  stx $4305                   ;Set transfer size in bytes
  ldx.w #\2                   ;Get lower 16-bits of destination ptr
  stx $2181                   ;Set WRAM offset
  lda #:\2                    ;Get upper 8-bits of dest ptr 
  sta $2183                   ;Set WRAM bank (only LSB is significant)
  lda #$80
  sta $4301                   ;DMA destination is $2180
  lda #$01                    ;DMA transfer mode=auto increment
  sta $4300                   ;  Write mode=1 byte to $2180
  sta $420B                   ;Initiate transfer using channel 0
.endm
