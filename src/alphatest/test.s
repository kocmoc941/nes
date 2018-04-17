
 .inesmir 0
 .inesprg 1
 .ineschr 1
 .inesmap 0

 .bank 1
    .org $FFFA 
    .dw 0
    .org $FFFC 
    .dw reset
    .org $FFFE 
    .dw 0
    
 .bank 2
    chr: .incbin "test.chr" ; all 8kB

 .bank 0
 .org $0900
    posY: .db $0
    numSpr: .db $0
    attrSpr: .db $0
    posX: .db $0
    isADown: .db $0
    isBDown: .db $0
    
 .org $8000
    reset:

    ; load pal
    lda #$3F
    sta $2006
    lda #$00
    sta $2006

    ldx #4
    load_pal_next:
    lda pal, x
    sta $2007
    inx
    cpx #32
    bne load_pal_next

       lda #%00001000 ; do the setup of PPU 
       sta $2000 ; that we 
       lda #%00011110 ; talked about 
       sta $2001 ; on a previous day

    ; load tiles
    lda #$20
    sta $2006
    lda #$00
    sta $2006

    ldx #0
    ldy #0
    load_tile_next:
    stx $2007
    inx
    cpx #$A0
    bne load_tile_next
    iny
    cpy #4
    bne load_tile_next
    
    lda #%00000010
    sta attrSpr
    lda #10
    sta posX
    sta posY

    draw:
    vblank:
    bit $2002
    bpl vblank
    
    lda #0
    sta $2003
    sta $2003

    lda #$9
    sta $4014

    lda #1
    sta $4016
    lda #0
    sta $4016

    lda $4016
    and #1
    bne keyA
    lda $4016
    and #1
    bne keyB
    lda $4016
    lda $4016
    lda $4016
    and #1
    bne keyUp
    lda $4016
    and #1
    bne keyDown
    lda $4016
    and #1
    bne keyLeft
    lda $4016
    and #1
    bne keyRight

    lda #0
    sta isADown
    sta isBDown

    infinite: 
    jmp draw


    keyA:
    lda isADown
    bne draw
    lda #0
    cmp numSpr
    beq draw
    dec numSpr
    lda #1
    sta isADown
    jmp draw

    keyB:
    lda isBDown
    bne draw
    lda #15
    cmp numSpr
    beq draw
    inc numSpr
    lda #1
    sta isBDown
    jmp draw

    keyUp:
    dec posY
    dec posY
    jmp draw

    keyDown:
    inc posY
    inc posY
    jmp draw

    keyLeft:
    dec posX
    dec posX
    jmp draw

    keyRight:
    inc posX
    inc posX
    jmp draw


    pal: .incbin "test.pal"
    map: .incbin "our.map"
