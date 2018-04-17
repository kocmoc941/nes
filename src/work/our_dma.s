
;--- CODE START ---;
 .inesmir 1
 .inesmap 0 ; INES header $H!7.
 .ineschr 1
 .inesprg 1
 
 .bank 1
 .org $FFFA  ; vector table
 .dw 0
 .dw Start
 .dw 0
 
 .bank 0
 .org $0010 
 addrLO: .db 0  ; make "variable"s for our indirect addressing 
 addrHI: .db 0

 .org $8000 
 Start:

 ldx #0
 lda #$20  ; set the destination address in PPU memory
 sta $2006  ; should be $2000
 stx $2006
 lda #low(backg)   ; put the high and low bytes of the address "backg"
 sta addrLO        ; into the variables so we can use indirect addressing.
 lda #high(backg)
 sta addrHI
 
 ldx #4  ; number of 256-byte chunks to load
 ldy #0 
 loop:
 lda [addrLO],y
 sta $2007     ; load 256 bytes
 iny
 bne loop ;--------------------
 inc addrHI  ; increment high byte of address backg to next 256 byte chunk
 dex        ; one chunk done so X = X - 1.
 bne loop   ; if X isn't zero, do again
 
 
 lda #$3F
 sta $2006
 lda #$00    ; point $2006 to the palette
 sta $2006
 ldx #$00 
 palload:
 lda tilepal, X     ; use a simple load of 32 bytes.
 inx
 sta $2007
 cpx #32
 bne palload
 
 jsr turn_screen_on  ; call subroutine to turn on / setup the PPU.
 
 lda #0
 infin: ; our infinite loop 
 ldx $2002
 bpl infin
 sta $2005
 sbc #1
 sta $2005
 jmp infin
 
 turn_screen_on: ; Setup the PPU 
 lda #%00001000 
 sta $2000 
 lda #%00011110 
 sta $2001 
 rts
 
 tilepal: .incbin "our.pal" ; include the palette 
 backg: .incbin "zelda.nam" ; include the name table data
 
 .bank 2
 .org $0000
 .incbin "our.spr"  ; include the picture data in the background part
 ;of the CHR-BANK (#2) ;;--- CODE END/ END OF FILE ---;; </code>
