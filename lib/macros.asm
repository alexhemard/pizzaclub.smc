.MACRO LoadRAM
   LDX #\1                   ;Get lower 16-bits of source
   STX $4302                        ;Set source offset
   LDA #:\1                  ;Get upper 8-bits of source
   STA $4304                        ;Set source bank
   LDX #\3                        ; size
   STX $4305                        ;Set transfer size in bytes
   LDX #\2                     ;Get lower 16-bits of destination ptr
   STX $2181                        ;Set WRAM offset
   LDA #:\2                    ;Get upper 8-bits of dest ptr 
   STA $2183                        ;Set WRAM bank (only LSB is significant)
   LDA #$80
   STA $4301                        ;DMA destination is $2180
   LDA #$01                         ;DMA transfer mode=auto increment
   STA $4300                        ;  Write mode=1 byte to $2180
   STA $420B                        ;Initiate transfer using channel 0
.endm
