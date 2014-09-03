StarsInit:
  php
  rep #$10        
  sep #$20
        
  LoadRAM StarSeed, Stars, _sizeof_star * $1f
        
  plp        
  rts

StarsUpdate:
	php

  rep #$10
  sep #$20        

_StarsUpdateOAM:
  ldx.w #(Stars - Stars.1)
  stx.w StarCurrent
        
  ldx.w #OAM_lo.2        
  stx.w OAM_lo_Current

  ldx #0        
_StarsUpdateOAMLoop:

  ldy StarCurrent.w             ; update x
  lda Stars, y
  ldy OAM_lo_Current.w        
  sta OAM_lo.x, y

  ldy StarCurrent.w             ; update x
  lda Stars + 1, y
  ldy OAM_lo_Current.w        
  sta OAM_lo.y, y        
        
  lda #$08        
  sta OAM_lo.tile & $ffff, y

  lda #%00000010        
  sta OAM_lo.data & $ffff, y                

  iny
  iny
  iny
  iny        
  sty OAM_lo_Current.w

  ldy StarCurrent.w
  iny
  iny
  iny
  sty StarCurrent.w        
        
  inx
  txa
  cmp #$1F
  bne _StarsUpdateOAMLoop

  plp
  rts
