MouseRead:
  php

  sep #$30

_MouseWait:                     ; _10
  lda $4212
  and #$01
  bne _MouseWait                ; automatic read ok?

  ldx #$01                    ; Port 2
  lda $421a
  jsr MouseData

  lda MouseDS1Check1.w
  beq _MouseInitJoy1

  jsr MouseSpeedChange
  stz MouseDS1Check1.w

  plp
  rts

_MouseInitJoy1:                 ; _20
  dex
  lda $4218                     ; Joy1
  jsr MouseData

  lda MouseDS1Check0.w
  beq _MouseDone

  jsr MouseSpeedChange
  stz MouseDS1Check0.w

_MouseDone:                     ; _30
  plp
  rts

MouseData:
  sta MouseTempLo.w             ; save 421a 4218 to reg 0
  and #$0F                      ; Is connected?
  cmp #$01
  beq _MouseSetup

  stz MouseConnected0.w,    x
  stz MouseX0.w,         x
  stz MouseY0.w,         x
  stz MouseTurbo0.w,     x
  stz MouseClick0.w,     x
  stz MouseClickPrev0.w, x

  rts

_MouseSetup:                    ; _m10

  lda MouseConnected0.w, x      ; When Mouse connected, speed will change
  bne _MouseLoopInit            ; Previous connection status
                                ; mouse.com judged by lower 1 bit
  lda #$01                      ; Turn connection flag on
  sta MouseConnected0.w, x
  sta MouseDS1Check0.w,  x

  rts

_MouseLoopInit:                 ; _m20
  ldy #16                       ; #16

_MouseLoop:                     ; _m30
  lda $4016, x
  lsr a
  rol MouseX0.w, x
  rol MouseY0.w, x
  dey
  bne _MouseLoop

  stz MouseTurbo0.w, x

  rol MouseTempLo.w
  rol MouseTurbo0.w, x
  rol MouseTempLo.w
  rol MouseTurbo0.w, x            ; Switch Turbo

  lda MouseTurbo0.w,     x
  eor MouseClickPrev0.w, x        ; Get switch trigger
  bne _MouseClicks

  stz MouseClick0.w, x

  rts

_MouseClicks:                   ; _m40
  lda MouseTurbo0.w,     x
  sta MouseClick0.w,     x
  sta MouseClickPrev0.w, x

  rts

MouseSpeedChange:
  php

  sep #$30

  lda.w MouseConnected0, x
  beq _sMouseError

  lda.w #$10
  sta.w MouseTempHi

_sMouseInit:                    ; _s10
  lda.w #$01
  sta $4016
  lda $4016, x                  ; Speed Change (1 step)
  stz $4016

  lda.w #$01                    ; Read Speed Data
  sta $4016                     ; Shift Register Clear
  lda.w #$00
  sta $4016

  sta.w MouseSpeed0, x          ; Speed Register Clear

  ldy #10                       ; Shift Register Read has 'no meaning'

_sMouseReadLoop:                ; _s20
  lda $4016, x
  dey
  bne _sMouseReadLoop

  lda $4016, x                  ; Read Speed
  lsr a
  rol.w MouseSpeed0, x

  lda $4016, x

  lsr a
  rol.w MouseSpeed0, x
  lda.w MouseSpeed0, x

  cmp.w MouseSpeedSetting0, x   ; Is it at the selected speed?
  beq _sMouseDone

  dec.w MouseTempHi
  bne _sMouseInit               ; Get Next Speed...

_sMouseError:                   ; _s25
  lda.w #$80                    ; Speed change Error
  sta.w MouseSpeed0, x

_sMouseDone:                    ; _s30

  plp
  rts
