StarsInit:
  LoadRAM StarSeed, Stars, (_sizeof_star * $1f)
        
  rts

StarsUpdate:
	php

  rep #$10
  sep #$20        

_StarsUpdateOAM:

  ldx.w #OAM_lo.2        
  stx OAM_lo_Current.w

  ldx #0        
_StarsUpdateOAMLoop:
  ldy OAM_lo_Current.w            

  lda #$08        
  sta OAM_lo.tile, y

  lda #%00000010        
  sta OAM_lo.data, y                

  tya 
  adc #_sizeof_OAM_lo_table
  tya
  sty OAM_lo_Current.w       
        
  inx
  txa
  cmp #$1F
  bne _StarsUpdateOAMLoop

  plp
  rts
