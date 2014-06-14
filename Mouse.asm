.BANK 0
.ORG 0
.SECTION "MouseCode" SEMIFREE

MouseRead:
  php                           ; Preserve Registers
  sep #$30

_MouseWait:                     ; _10
  lda $4212
  and #$01

  bne _MouseWait                ; automatic read ok?

  ldx #$0001                    ; Port 2
  lda $421a
  jsr MouseData

  lda.w MouseDS1Check1
  beq _MouseInitJoy1

  jsr MouseSpeedChange
  stz.w MouseDS1Check1

  plp
  rts

_MouseInitJoy1:                 ; _20
  dex
  lda $4218                     ; Joy1
  jsr MouseData

  lda.w MouseDS1Check0
  beq _MouseDone

  jsr MouseSpeedChange
  stz.w MouseDS1Check0

_MouseDone:                     ; _30
  plp
  rts

MouseData:
  sta.w MouseTempLo               ; save 421a 4218 to reg 0
  and #$0F                      ; is mouse connected?
  cmp #$01
  bne _MouseSetup

  stz.w MouseConnected0, x
  stz.w MouseX0,         x
  stz.w MouseY0,         x
  stz.w MouseTurbo0,     x
  stz.w MouseClick0,     x
  stz.w MouseClickPrev0, x

  rts

_MouseSetup:                    ; _m10
  lda.w MouseConnected0, x        ; When Mouse connected, speed will change
  bne _MouseLoopInit            ; Previous connection status
                                ; mouse.com judged by lower 1 bit
  lda #$01                      ; Turn connection flag on
  sta.w MouseConnected0, x
  sta.w MouseDS1Check0,  x

  rts

_MouseLoopInit:                 ; _m20
  ldy #$10

_MouseLoop:                     ; _m30
  lda $4016, x
  lsr a
  rol.w MouseX0, x
  rol.w MouseY0, x
  dey
  bne _MouseLoop

  stz.w MouseTurbo0, x

  rol.w MouseTempLo
  rol.w MouseTurbo0, x
  rol.w MouseTempLo
  rol.w MouseTurbo0, x            ; Switch Turbo

  lda.w MouseTurbo0,     x
  eor.w MouseClickPrev0, x        ; Get switch trigger
  bne _MouseClicks

  stz.w MouseClick0

  rts

_MouseClicks:
  lda.w MouseTurbo0,     x
  sta.w MouseClick0,     x
  sta.w MouseClickPrev0, x

  rts

MouseSpeedChange:
  php

  sep #30

  lda.w MouseConnected0, x
  beq _sMouseError

  lda #$10
  sta.w MouseTempHi

_sMouseInit:                    ; _s10
  lda #$01
  sta $4016
  lda $4016, x                  ; Speed Change (1 step)
  stz $4016

  lda #$01                      ; Read Speed Data
  sta $4016                     ; Shift Register Clear
  lda #$00
  sta $4016

  sta.w MouseSpeed0, x            ; Speed Register Clear

  ldy #$0a                      ; Shift Register Read has 'no meaning'

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

  cmp.w MouseSpeedSetting0, x     ; Is it at the selected speed?
  beq _sMouseDone

  dec.w MouseTempHi               ;
  bne _sMouseInit               ; Get Next Speed...

_sMouseError:                   ; _s25
  lda #$80                      ; Speed change Error
  sta.w MouseSpeed0, x

_sMouseDone:                    ; _s30

  plp
  rts

.ENDS
