	:BasicUpstart2(cleanup)
	
	*=$8000
	.pc = * "Code Segment"
	.label v = $d000
	
	.label sp0 = $3000
	.label sp1 = $3040
	.label sp2 = $3080
	.label exp1 = $30c0
	.label exp2 = $3100
	.label exp3 = $3140
	.label die = $5000
	.label joy = $dc00
	.label colormem = $d800
	
	.label speed = $7ffa
	
	cleanup:
		lda #147    // clear screen
		jsr $ffd2
		
		lda #0		// clean adresses up
		sta v+32
		sta v+33
		sta v+21
		sta score
		sta score+1
		
		lda #0
		ldx #0
	loop0:			// clean sprites up
		sta sp0,x
		inx
		cpx #63
		bne loop0
	title:			// title screen. Press Fire (numpad 0)
		lda joy
		and #16
		bne title
		
	gameinit:
		lda #1
		sta $0286
	
		lda #3		// setting lives
		sta lives
		
		lda #1		// set sprite color
		sta v+39
		
		lda #%11111101  // sprite activate
		sta v+21
		
		lda #192 // set player sprite
		sta $07f8
		lda #193 // set bullet sprite
		sta $07f9
		
		ldx #0
		lda #194	// set sprite for enemies
	loop:
		sta $07fa,x
		inx
		cpx #6
		bne loop
		
		ldx #0		// draw player
	loop1:
		lda player,x
		sta sp0,x
		inx
		cpx #63
		bne loop1
		
		ldx #0		// draw bullet
	loop2:
		lda bullet,x
		sta sp1,x
		inx
		cpx #63
		bne loop2
		
		ldx #0
	loop21:
		lda enemy,x
		sta sp2,x
		inx
		cpx #63
		bne loop21
		
		lda #50
		ldx #0
	loop3:
		sta v+5,x
		lda #230
		sta v+4,x
		lda v+5,x
		clc
		adc #35
		inx
		inx
		cpx #12
		bne loop3
		
		ldx #0 // explosion frame one
	loopexp1:
		lda explos1,x
		sta exp1,x
		inx
		cpx #63
		bne loopexp1
		
		ldx #0 // explosion frame two
	loopexp2:
		lda explos2,x
		sta exp2,x
		inx
		cpx #63
		bne loopexp2
	
		ldx #0	// explosion frame three
	loopexp3:
		lda explos3,x
		sta exp3,x
		inx
		cpx #63
		bne loopexp3
		
		lda #8
		sta v+46
		
		ldx #0
	loop4:		// give random speed to enemies
		lda v+18
		eor $dc04
		sec
		sbc $dc05
		and #7
		lsr
		adc #1
		sta speed,x
		inx
		cpx #6
		bne loop4
		
	gameloop:
		lda #$ff	// delay
		cmp v+18
		bne gameloop
		
		jsr control
		jsr bulmov
		jsr coldet
		jsr getkey
		jsr movenem
		jsr collision
		jsr showbul
		jsr showscore
		
		lda lives
		cmp #0
		bne gameloop
		
		// gameover
		jmp cleanup
		
	control:
		lda joy
	up:	
		lsr
		bcs down
		dec pos
	down:
		lsr
		bcs button
		inc pos
	button:
		ldx #0
	loop5:
		lsr
		inx
		cpx #2
		bne loop5
		
		lsr
		bcs dr
		lda v+21 // check if bullet sprite is one
		lsr
		lsr
		bcs dr
		lda v+21 // if not turn it one
		ora #2
		sta v+21
		lda #70 // position bullet
		sta v+2
		lda pos
		sta v+3
	dr:
		lda #50
		sta v
		lda pos
		sta v+1
		rts
	bulmov:
		lda v+21
		lsr
		lsr 
		bcs gg
		rts
	gg:
		ldx #0
	loop6:
		inc v+2
		inx
		cpx #4
		bne loop6
		rts
	
	coldet:
		lda v+2		// check if bullet is out of bounds
		cmp #$f0
		bcs gone
		rts
	gone:			// if yes then deactivate the sprite
		lda v+21
		eor #2
		sta v+21
		lda #70
		sta v+2
		sta v+3
		rts
		
	getkey:
		lda v+21
		lsr
		lsr
		bcs ex
	chang:
		jsr $ffe4
		cmp #$31
		bcc ex
		cmp #$37
		bcs ex
		and #$0f
		clc
		adc #2
		sta v+40
	ex:
		rts
		
	movenem:
		ldx #0		// move enemies at their own random speeds
		ldy #0
	loop7:
		lda v+4,x
		sec
		sbc speed,y
		sta v+4,x
		iny
		inx
		inx
		cpy #6
		bne loop7
		rts
		
	collision:
		ldy #0
		ldx #0
	loop8:		// check if player is coliding
		lda v
		clc
		adc #24
		cmp v+4,x
		bcs checkx		// if it is on front then check if it is on x axis
		jmp checkbul	// if not then check if bullet is
	checkx:
		lda v
		sec
		sbc #24
		cmp v+4,x
		bcc checkdown  // if it is then check if it is down
	checkdown:
		lda pos
		clc
		adc #15
		cmp v+5,x
		bcs checkup
		jmp checkbul
	checkup:
		lda pos
		sec
		sbc #15
		cmp v+5,x
		lda #1
		sta die		// I store 1 in die because to check if it is player that is coliding or bullet
		bcc suc
	
	checkbul:
		lda v+2
		clc
		adc #12
		cmp v+4,x
		bcs chebdown
		jmp endl
	chebdown:
		lda v+3
		clc
		adc #12
		cmp v+5,x
		bcs checkbup
		jmp endl
	checkbup: 
		lda v+3
		sec 
		sbc #12
		cmp v+5,x
		bcc finchek
		jmp endl
	finchek:
		lda v+40
		cmp v+41,y
		beq final
		jmp endl
	final:
		cpy last
		beq endl
		lda #0
		sta die
		jmp suc
	endl:
		inx
		inx
		iny
		cpy #6
		bne gotoloop
		rts
	gotoloop:
		jmp loop8
	
	suc:
		ldx #0
		lda #194
		sta $07fa,y
	looper:
		lda #$ff
		cmp v+18
		bne looper
		inc it
		lda it
		cmp #10
		bne looper
		lda #0
		sta it		// it means itterator btw
		
		lda $07fa,y
		clc
		adc #1
		sta $07fa,y
		inx
		cpx #4
		bcc looper
		
		tya 	// reset pos
		asl
		tay
		lda #230
		sta v+4,y
		
		tya
		lsr
		tay
		lda v+18
		sec
		sbc $dc04
		eor $dc05
		and #7
		lsr
		adc #1
		sta speed,y
		
		lda #194
		sta $07fa,y
		
		lda die
		cmp #1
		beq dead
		
		lda score+1
		clc
		adc #1
		sta score+1
		lda score
		adc #0
		sta score
		lda v+21
		and #253
		sta v+21
		lda #0
		sta v+2
		sta v+3
		
		sty last
		rts
	dead:
		lda lives
		cmp #3
		bne lred
		lda #10
		sta v+39
		jmp deli
	lred:
		lda #2
		sta v+39
	deli:
		dec lives
		lda score+1
		cmp #0
		bne anch
		lda score
		cmp #0
		beq endit
	anch:
		sec
		sbc #1
		sta score+1
		lda score
		sbc #0
		sta score
	endit:
		rts
	
	showbul:    // this print which plane this bullet kills
		ldx #0
	ptext1:
		lda text1,x
		sta $0400,x
		lda #1
		sta colormem,x
		inx
		cpx #7
		bne ptext1
		
		lda v+40
		clc
		adc #$3e
		sta $0400,x
		lda #1
		sta colormem,x
		rts
		
	showscore:
		ldx #0
	ptext2:
		lda text2,x
		sta $040f,x
		lda #1
		sta colormem+$f,x
		inx
		cpx #6
		bne ptext2
		
		lda #19
		jsr $ffd2
		
		lda #22
		sta $d3
		
		ldx score+1
		lda score
		jsr $bdcd
		
		rts
		
	last: .byte 255
	
	score: .byte 0, 0
	
	it: .byte 0
	
	lives: .byte 3
	
	pos: .byte 100
	
	player:
		.import binary "player.RAW"
		
	bullet:
		.import binary "bullet.RAW"
	
	enemy:
		.import binary "enemy.RAW"
	
	explos1:
		.import binary "explosion1.RAW"
	
	explos2:
		.import binary "explosion2.RAW"
	
	explos3:
		.import binary "explosion3.RAW"
	
	text1: .text "bullet:"
	text2: .text "score:"
