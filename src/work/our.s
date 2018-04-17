;;--- CODE START ---;;

; INES header stuff
 .inesprg 1   ; 1 bank of code
 .ineschr 1   ; 1 bank of spr/bkg data
 .inesmir 1   ; something always 1
 .inesmap 0   ; we use mapper 0
 
 .bank 1   ; following goes in bank 1
 .org $FFFA  ; start at $FFFA
 .dw 0    ; dw stands for Define Word and we give 0 as address for NMI routine
 .dw Start ; give address of start of our code for execution on reset of NES.
 .dw 0   ; give 0 for address of VBlank interrupt handler, we tell PPU not to
 ; make an interrupt for VBlank.
 
 .bank 0   ; bank 0 - our place for code.
 .org $0
  pos_X: .db 0
  pos_Y: .db 0
 .org $8000  ; code starts at $8000

Start: lda #%00001000 ; do the setup of PPU 
 sta $2000 ; that we 
 lda #%00011110 ; talked about 
 sta $2001 ; on a previous day

 lda #$0A
 sta pos_Y

 ldx #$00    ; clear X
 
 lda #$3F    ; have $2006 tell
 sta $2006   ; $2007 to start
 lda #$00    ; at $3F00 (palette).
 sta $2006

loadpal: ; this is a freaky loop 
 lda tilepal, x ; that gives 32 numbers 
 sta $2007 ; to $2007, ending when 
 inx ; X is 32, meaning we 
 cpx #32 ; are done. 
 bne loadpal ; if X isn’t =32, goto “loadpal:” line.

 lda #$20
 sta $2006 ; give $2006 both parts of address $2020.
 sta $2006
 
 ldx #$00 
 loadNames:
 lda ourMap, X ; load A with a byte from address (ourMap + X)
 inx
 sta $2007
 cpx #64 ; map in previous section 64 bytes long
 bne loadNames ; if not all 64 done, loop and do some more

 sprite_movie:
 waitblank: ; this is the wait for VBlank code from above 
 lda $2002 ; load A with value at location $2002
 bpl waitblank ; if bit 7 is not set (not VBlank) keep checking
 
 lda #$00   ; these lines tell $2003
 sta $2003  ; to tell
 lda #$00   ; $2004 to start
 sta $2003  ; at $0000.
 
 lda pos_Y ; load Y value
 sta $2004 ; store Y value
 lda #$00  ; tile number 0
 sta $2004 ; store tile number
 lda #%00100000 ; no special junk
 sta $2004 ; store special junk
 lda pos_X ; load X value
 sta $2004 ; store X value
 ; and yes, it MUST go in that order.

 lda #$01
 sta $4016
 lda #$00
 sta $4016

 lda $4016
 lda $4016
 lda $4016
 lda $4016

 lda $4016
 and #1
 bne keyup
 lda $4016
 and #1
 bne keydown
 lda $4016
 and #1
 bne keyleft
 lda $4016
 and #1
 bne keyright

 ; sound
 lda #$FF   ; typical
 sta $400C  ; write
 
 lda #$50
 sta $400E  ; immediate means "not an address, just a number".
 
 lda #$AB
 sta $400F
 
 lda #%00001000
 sta $4015
 
 jmp infin

 keyup:
  lda pos_Y
  sbc #1
  sta pos_Y
  jmp infin
 keydown:
  lda pos_Y
  adc #1
  sta pos_Y
  jmp infin
 keyleft:
  lda pos_X
  sbc #1
  sta pos_X
  jmp infin
 keyright:
  lda pos_X
  adc #1
  sta pos_X
  jmp infin

 infin: jmp sprite_movie ; JuMP to infin. note that this loop never ends. :)
 
tilepal: .incbin "our.pal" ; include and label our palette
ourMap: .incbin "our.map" ; assuming our.map is the binary map file.

 .bank 2   ; switch to bank 2
 .org $0000  ; start at $0000
 .incbin "our.bkg"  ; empty background first
 .incbin "our.spr"  ; our sprite pic data
; note these MUST be in that order.

;;--- WERE DONE / CODE END ---;; </code>
