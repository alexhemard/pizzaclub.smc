CursorUpdate:
  lda MouseConnected0.w
  beq _CursorDone
  jmp _CursorConnected

_CursorDone:

  rts

_CursorConnected:
  lda MouseX0.w
  and #$7F
  sta MouseDeltaX.w

  lda MouseX0.w
  and #$80
  bne _CursorLeft

  lda OAM_lo.1.x.w
  adc MouseDeltaX.w
  sta OAM_lo.1.x.w

  jmp _CursorUp

_CursorLeft:
  lda OAM_lo.1.x.w
  sbc MouseDeltaX.w
  sta OAM_lo.1.x.w

  lda MouseX0.w
  and #$7F
  sta MouseDeltaX.w

_CursorUp
  lda MouseY0.w
  and #$7F
  sta MouseDeltaY.w

  lda MouseY0.w
  and #$80
  bne _CursorDown

  lda OAM_lo.1.y.w
  adc MouseDeltaY.w
  sta OAM_lo.1.y.w

  jmp _CursorDone

_CursorDown:
  lda OAM_lo.1.y.w
  sbc MouseDeltaY.w
  sta OAM_lo.1.y.w

  jmp _CursorDone
