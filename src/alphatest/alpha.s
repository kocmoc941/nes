
 ; must make print routine
 .inesmir 1
 .inesprg 1 ; 32kb
 .ineschr 1 ; 8kb
 .inesmap 0

 .bank 1
 .org $FFFA
 .dw NMI
 .dw RESET
 .dw IRQ

 NMI:
 IRQ:

 .bank 2
 .dw 0
 .dw 0
 .dw 0
 .dw 0
 .dw 0
 .dw 0
 .dw 0
 .dw 0
 .incbin "alpha.chr"
 .dw $FF 
 .dw $FF 
 .dw $FF 
 .dw $FF 
 .dw $00 
 .dw $00 
 .dw $00 
 .dw $00 

 .bank 0
 .org $8000
 RESET:

 ; load palette
 lda #$3F
 sta $2006
 lda #$0
 sta $2006
 ldx #$0
 load_pal_next:
 lda palette, x
 sta $2007
 inx
 cpx #$20
 bne load_pal_next

 ; configure PPU
 lda #%00001000
 sta $2000
 lda #%00011110
 sta $2001

 ; load 1 tile
 lda #$20
 sta $2006
 sta $2006

 lda #$1
 sta $2007

 ; load attr
 lda #$23
 sta $2006
 lda #$C0
 sta $2006
 ldx #$0
 lda #$0
 load_attr_next:
 sta $2007
 inx
 cpx #$40
 bne load_attr_next

 ldx #$20
 lda #$10
 sta $200 ; X
 sta $201 ; Y

 loop_draw:

  vblank_wait:
  bit $2002
  bpl vblank_wait

  cpx #$A0
  beq stop
  lda #0
  sta $2005
  dex
  stx $2005
  stop:

 jsr getKeyState
 lda $33
 and #%1
 bne keyR
 keyNext:

 lda #$0 ; first two spr is garbage
 sta $2003
 sta $2003
 lda $201
 sta $2004
 lda #$2
 sta $2004
 lda #%00100000
 sta $2004
 lda $200
 sta $2004

 loop: jmp loop_draw

 keyR:
 inc $200
 jmp keyNext

 palette:
 ; bckgr
 .db $0F, $00, $19, $9A
 .db $0F, $13, $19, $9A
 .db $0F, $13, $19, $9A
 .db $0F, $13, $19, $9A

 ; spr
 .db $0F, $13, $19, $9A
 .db $0F, $13, $19, $9A
 .db $0F, $13, $19, $9A
 .db $0F, $13, $19, $9A

 getKeyState:
    txa
    pha
    lda #$1
    sta $4016
    lda #$0
    sta $4016
    ldx #$0
    stx $33
    keyLoop:
       rol $33
       lda $4016
       and #$1
       ora $33
       sta $33
       inx
       cpx #$8
       bne keyLoop
    pla
    tax
    rts

