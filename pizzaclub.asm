.include "header.inc"
.include "Snes_Init.asm"
.include "LoadGraphics.asm"

.define SCREEN_WIDTH $FF
.define SCREEN_HEIGHT $E0

;; oam table 1
;; Sprite Table 1 (4-bytes per sprite)
;; Byte 1:    xxxxxxxx    x: X coordinate
;; Byte 2:    yyyyyyyy    y: Y coordinate
;; Byte 3:    cccccccc    c: Starting tile #
;; Byte 4:    vhoopppc    v: vertical flip h: horizontal flip  o: priority bits
;;                        p: palette #

.STRUCT OAM_hi
x     db
y     db
tile  db
data  db
.ENDST

.STRUCT OAM_table
hi ds 512
lo ds 32
.ENDST

.STRUCT star
x db
y db
z db
.ENDST

.DEFINE SCREEN

;; setup variables

.ENUM $00
OAM instanceof OAM_table
animation db
UploadOAMFlag db
.ENDE

.BANK 0 SLOT 0
.ORG 0
.SECTION "MainCode"

Start:
  Snes_Init                     ; Init Routine

  rep #$10
  sep #$20

  lda #$01                ; screen mode 1 #%00000001
  sta $2105                     ; screen mode register


  stz UploadOAMFlag

  ; Blue Background
  stz $2121
  lda #$40
  sta $2122
  sta $2122

  LoadPalette PizzaPalette, 128, 8

  LoadBlockToVRAM PizzaSprite, $0000, size_of_pizza

  jsr SpriteInit

  lda #($80-16)
  sta OAM.hi + OAM_hi.x

  lda #(224/2 - 16)
  sta OAM.hi + OAM_hi.y

  stz OAM.hi + OAM_hi.tile

  lda #%00000000
  sta OAM.hi + OAM_hi.data

  lda #%01010110
  sta OAM.lo

  jsr SetupVideo

  lda #$80
  sta $4200                     ; Enable NMI

Loop:
  WAI                           ; wait for V blank

  inc OAM.hi + OAM_hi.x
  inc OAM.hi + OAM_hi.x
  inc OAM.hi + OAM_hi.y

_done:
  jmp Loop

SpriteInit:
	php                           ; preserve registers

	rep	#$30                      ; 16bit mem/A, 16 bit X/Y

	ldx #$0000
  lda #$01
_offscreen:
  sta OAM.hi, X                 ; set x to 1 for each sprite
  inx
  inx
  inx
  inx
  cpx #$0200                    ; do this 512 times (the size of the OAM)
  bne _offscreen

	ldx #$0000
	lda #$5555                    ; init oam table 2 w/ offscreen x bit set
_clr:
	sta OAM.lo, X                 ; initialize all sprites to be off the screen
	inx
	inx
	cpx #$0020                    ; do this 20 times (size of oam table 2)
	bne _clr

	plp
	rts

SetupVideo:
  php

  rep #$10                      ; reset idx register size
  sep #$20                      ; set accumulator register size to 8bit

  lda #%10100000                ; 32x32 and 64x64 size sprites
  sta $2101

  lda #$10                      ; enable sprites
  sta $212C                     ; set main screen register

  lda #$0F                      ; set first 4 bits (brightnes) to 100%
  sta $2100                     ; and write to screen display register

  plp
  rts

VBlank:
  lda OAM

  stz $2102
  sta $2103                     ; Set OAM address to OAM

  ldy #$0400                    ; Writes #$00 to $4300, #$04 to $4301
  sty $4300                     ; CPU -> PPU, auto inc, $2104 (OAM write)
  stz $4302
  stz $4303
  ldy #$220
  sty $4305                     ; #$220 bytes to transfer
  lda #$7E
  sta $4304                     ; CPU address 7E:0000 - Work RAM
  lda #$01
  sta $420B

  RTI

  ;; here's where I guess if I was doing the starfield thing,
  ;; I'd update my BG's character data via a DMA transfer...
  ;; i'd have to do this during vblank b/c it'd probably
  ;; cause glitches if I was updating during a write 2 screen

.ENDS

.BANK 1 SLOT 0
.ORG 0
.SECTION "CharacterData"

.INCLUDE "tiles.inc"

.ENDS
