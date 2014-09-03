.include "header.inc"
.include "lib/init.asm"
.include "lib/graphics.asm"

.include "structs.asm"
.include "defines.asm"
.include "memory.asm"

.BANK 0 SLOT 1
.ORG 0
.SECTION "MainCode"

.include "lib/mouse.asm"
.include "lib/cursor.asm"
.include "lib/stars.asm"

Start:
  Snes_Init                     ; Init Routine

  rep #$10
  sep #$20

  stz MouseDS1Check0.w
  stz MouseDS1Check1.w

  lda #$00                      ; screen mode 0
  sta $2105                     ; screen mode register

  ;; dark blue palette

  stz $2121

  LoadPalette PizzaPalette, 128, 8

  LoadBlockToVRAM PizzaSprite, $0000, size_of_pizza

  LoadBlockToVRAM StarSprites, $0080, 32*8

  LoadPalette StarPalette, 128+16, 8

  jsr StarsInit
  jsr SpriteInit

  lda #($80-16)
  sta.w OAM_lo.1.x

  lda #(224/2 - 16 )
  sta.w OAM_lo.1.y

  stz.w OAM_lo.1.tile

  lda #%00000000
  sta.w OAM_lo.1.data

 ;; lda #$08
 ;; sta.w OAM_lo.2.tile
 ;; lda #%00000010
 ;; sta.w OAM_lo.2.data

  lda #%00000010
  sta OAM_hi.w

  ldy #1

_init_oam_hi:

  lda #0
  sta OAM_hi.w, Y

  iny
  tya
  cmp #$1F
  bne _init_oam_hi

  jsr SetupVideo

  lda #$81                      ; NMI & Joypadz
  sta $4200                     ; Enable NMI

Loop:

WaitVBlank:
  wai
  lda $4212		;check the vblank flag
  and #$80
  beq WaitVBlank

  jsr CursorUpdate
  jsr StarsUpdate

  jmp Loop


SpriteInit:
	php                           ; preserve registers

	rep	#$30                      ; 16bit mem/A, 16 bit X/Y

	ldx #$0000
  lda #$01
_offscreen:
  sta OAM_lo.w, X                 ; set x to 1 for each sprite
  inx
  inx
  inx
  inx
  cpx #$0200                    ; do this 512 times (the size of the OAM)
  bne _offscreen

	ldx #$0000
	lda #$5555                    ; init oam table 2 w/ offscreen x bit set
_clr:
	sta OAM_hi.w, x               ; initialize all sprites to be off the screen
	inx
	inx
	cpx #$0020                    ; do this 20 times (size of oam table 2)
	bne _clr

	plp
	rts

SetupVideo:
  php

SetupSprites:

  rep #$10                      ; reset idx register size
  sep #$20                      ; set accumulator register size to 8bit

  lda #%01000000                ; 8x8 and 64x64 size sprites
  sta $2101

  lda #$14                      ; enable sprites, bg3
  sta $212C                     ; set main screen register

  lda #$0F                      ; set first 4 bits (brightnes) to 100%
  sta $2100                     ; and write to screen display register

SetupBG3:
  ;; $2107-$210A BG Tile Map Location

  ;; aaaaaacc -
  ;; a = Tile Map VRAM offset, shifted right 10 times
  ;; c = size of tilemap

  lda #$10                      ; offset = $1000, 32x32 tilemap
  sta $2109                     ; BG3 Tile Map Location

  ;; $210C BG3/4 Character Location
  ;; ccccdddd
  ;; c = BG4 char offset (shift left by 12)
  ;; d = BG3 char offset

  lda #$04                      ; offset = $4000
  sta $210C                     ; BG3/BG4 Character Location

  plp
  rts

VBlank:
  php

  sep #$20

  jsr MouseRead

DMA_OAM:
  stz $2102
  stz $2103                     ; Set OAM address to $0000 (VRAM)

  ldy #$0400                    ; Writes #$00 to $4300, #$04 to $4301
  sty $4300                     ; CPU -> PPU, auto inc, $2104 (OAM write)
  stz $4302
  stz $4303
  ldy #$220
  sty $4305                     ; #$220 bytes to transfer
  lda #$7E
  sta $4304                     ; CPU address 7E:0000 - Work RAM

  lda #$01
  sta $420B                     ;initiate transfer on channel 1,2

  plp
  rti

.ENDS

.BANK 1 SLOT 1
.ORG 0
.SECTION "CharacterData"

.INCLUDE "tiles.inc"

StarSeed:
.REPEAT $1F
  .DBRND 1, 0, $FF          ; x
  .DBRND 1, 0, $FF          ; y
  .DBRND 1, 0, $FF          ; z
.ENDR

.ENDS
