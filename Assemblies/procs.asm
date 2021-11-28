proc gmode
	push ax
	mov ax,13h
	xor ah,ah
	int 10h
	pop ax
	ret 
endp gmode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
proc textmode
	push ax
	mov ax,3
	int 10h
	pop ax
	ret 
endp textmode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
proc openningSound
	push cx
	mov cx,3
phase1:
	push chas
	call sound
	push dhas
	call sound
	loop phase1
	mov cx,3
phase2:
	push ahas
	call sound
	push b
	call sound
	loop phase2
	mov cx,2
phase3:
	push midc
	call sound
	push fhas
	call sound
	loop phase3
	mov cx,3
phase4:
	push d
	call sound
	loop phase4
	pop cx
ret  
endp openningSound
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
proc countdown
	mov ax, 40h 
	mov es, ax 
	mov ax, [Clock] 
FirstTick:  
	cmp ax, [Clock] 
	je FirstTick  
	; count 0.5 sec 
	mov cx, 10 ; 10*.055sec~0.5sec 
DelayLoop:
in al,61h
and al,11111100b
out 61h,al
 
	mov ax, [Clock] 
Tick: 
	cmp ax, [Clock] 
	je Tick 
	loop DelayLoop 
 endp countdown 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
proc delay                ;requires delaytime
     push ax bx cx dx si di
     cmp [delaytime], 0
     je delay_exit_12
     mov si,0
loopdel:
     mov cx,2000
    loop $	
	inc si
	mov dx, [delaytime]
    cmp si,dx
    jle loopdel
delay_exit_12:
      pop di si dx cx bx ax
      ret
endp delay
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  proc sound
push bp 
mov bp,sp
push ax bx cx
mov al,182
out 43h,al
mov ax,note
out 42h,al
mov al,ah
out 42h,al
in al,61h
or al,00000011b
out 61h,al
mov bx,50
pause1:
mov cx,65535
pause2:
loop pause2
dec bx
jnz pause1
in al,61h
and al,11111100b
out 61h,al
pop cx bx ax bp
ret 2
	endp sound
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
proc mouse
	;Initializes the mouse 
	mov ax,0h 
	int 33h 
	;Show mouse 
	mov ax,1h 
	int 33h 	
	ret
endp mouse
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 proc WhatPressed
	mov ax, 1
	int 33h
 s:
	mov ax, 3
	int 33h	
	shr cx, 1
	cmp cx, 100				    ;x range
	jae checkBelow225	
	jb s
 checkBelow225:                ;x range
	cmp cx, 225
	jbe checkAbove130
	jmp s
checkAbove130:	
	cmp dx, 130					;help's minimum y
	jae checkBelow155
	jb checkAbove95
checkAbove95:                  ;play's minimum y
	cmp dx, 95
	jae checkAbove120
	jmp s
checkAbove190:
	cmp dx, 190					;exit's maximum y
	je wannaExit
	jb wannaExit
	ja s
checkAbove120:
	cmp dx, 120					;play's maximum y
	ja checkBelow155
	jmp wannaStart
checkBelow155:
	cmp dx, 155					;help's maximum y
	jb wannaHelp
	ja checkAbove165
checkAbove165:
	cmp dx, 165
	je wannaExit
	ja checkAbove190
	jb s
wannaExit:
	push offset fileName7
	call pic
stoploop:
	mov ax, 3 
	int 33h	
	shr cx, 1                      	;checking if the mouse pressed on exit	
	cmp bx, 1
	je exitGame
	cmp cx, 100				    ;x range
	jae checkBelow225E	
	jb outE
 checkBelow225E:                ;x range
	cmp cx, 225
	jbe checkyE
	jmp outE
checkyE:	
	cmp dx, 165 
	ja stoploop
outE:	
	push offset fileName2 
	call pic
	jmp s
wannaHelp:
	push offset fileName5
	call pic
stoploopH:
	mov ax, 3 
	int 33h	
	shr cx, 1                      	
	cmp bx, 1
	je Jmphelp
	cmp cx, 100				    ;x range
	jae checkBelow225H	
	jb outH
Jmphelp:
	jmp help
 checkBelow225H:                ;x range
	cmp cx, 225
	jbe checkyH
	jmp outH
checkyH:	
	cmp dx, 120 
	ja check155H
	jb outH
check155H:
	cmp dx, 155
	ja outH
	jb stoploopH	
outH:	
	push offset fileName2 
	call pic
	jmp s							;checking if the mouse pressed on help	
exitGame:
mov cx, 7 
delayExit:	
	push offset fileName8 
	call pic 
	call delay   
	push offset fileName9 
	call pic 
	call delay
	loop delayExit
	push offset fileName10 
	call pic
	call delay
	call delay 
	call delay
	jmp exit
wannaStart:							;checking if the mouse pressed on play
	push offset fileName6
	call pic
stoploopP:
	mov ax, 3 
	int 33h	
	shr cx, 1                      	
	cmp bx, 1
	je JmpstartGame
	cmp cx, 100				    ;x range
	jae checkBelow225P	
	jb outP
 checkBelow225P:                ;x range
	cmp cx, 225
	jbe checkyP
	jmp outP
checkyP:	
	cmp dx, 90 
	ja check120P
	jb outP
check120P:
	cmp dx, 120
	ja outP
	jb stoploopP	
outP:	
	push offset fileName2 
	call pic
	jmp s
JmpstartGame:
	jmp startGame
help:
	push offset fileName4
	call pic
	jmp loopHelp
loopHelp:	
	mov ax, 3
	int 33h
	cmp cx, 200
	je checkAbove25
	ja checkAbove25
	jmp loopHelp
checkAbove25:
	cmp dx, 25
	ja loopHelp
wannaReturn:
	cmp bx, 1
	jne loopHelp
menu:
	push offset fileName2
	call pic
	mov ax, 1
	int 33h
	jmp s	
startGame:	
	push offset fileName3  
	call pic
	mov ax, 0
	int 33h 
	push offset fileName3
	call pic
	mov ax, 1
	int 33h
	call firstRed4				;calling the procedure that prints the first row of red soldiers 
secondRedRow:	
	call secondRed4					;calling the procedure that prints the second row of red soldiers
thirdRedRow:
	call thirdRed4			;calling the procedure that prints the third row of red soldiers
firstBlackRow:
	call firstBlack4
secondBlackRow:
	call secondBlack4
thirdBlackRow:
	call thirdBlack4
	ret
endp WhatPressed
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	x equ [bp+4]
	y equ [bp+6]
	color equ [bp+8]
proc printSoldier
	push bp
	mov bp,sp
	push ax 
	push bx
	push cx
	push dx
	push si
	push di
	xor si, si
	xor di, di
	xor cx, cx
	mov bx, offset player
	mov dx, y
printPixel:
	cmp [byte ptr bx],0
	je nextPixel
	mov al, color
	mov ah, 0ch
	mov cx, x
	add cx, si	
	int 10h
nextPixel:
	inc bx
	inc si
	cmp si, 25              ;checking if reached to the 25th pixel in the row
	jne printPixel
	xor si, si
	inc dx
	inc di
	cmp di, 25               ;checking if reached to the 25th pixel in the col
	jne printPixel
	pop di
	pop	si
	pop	dx
	pop	cx
	pop	bx
	pop	ax
	pop	bp
	ret 6
endp printSoldier
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
x equ [bp+4]
	y equ [bp+6]
	color equ [bp+8]
proc printSmalldier
	push bp
	mov bp,sp
	push ax 
	push bx
	push cx
	push dx
	push si
	push di
	xor si, si
	xor di, di
	xor cx, cx
	mov bx, offset smalldier
	mov dx, y
printPixelS:
	cmp [byte ptr bx],0
	je nextPixelS
	mov al, color
	mov ah, 0ch
	mov cx, x
	add cx, si	
	int 10h
nextPixelS:
	inc bx
	inc si
	cmp si, 15              ;checking if reached to the 25th pixel in the row
	jne printPixelS
	xor si, si
	inc dx
	inc di
	cmp di, 15               ;checking if reached to the 25th pixel in the col
	jne printPixelS
	pop di
	pop	si
	pop	dx
	pop	cx
	pop	bx
	pop	ax
	pop	bp
	ret 6
endp printSmalldier
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
	x equ [bp+4]
	y equ [bp+6]
	color equ [bp+8]
proc printQueen
	push bp
	mov bp,sp
	push ax 
	push bx
	push cx
	push dx
	push si
	push di
	xor si, si
	xor di, di
	xor cx, cx
	mov bx, offset queen
	mov dx, y
printPixelQ:
	cmp [byte ptr bx],0
	je nextPixelQ
	cmp [byte ptr bx], 2
	je paintWhite
	mov al, color
	mov ah, 0ch
	mov cx, x
	add cx, si	
	int 10h
	jmp nextPixelQ
paintWhite:
	mov al, 255
	mov ah, 0ch
	mov cx, x
	add cx, si	
	int 10h
nextPixelQ:
	inc bx
	inc si
	cmp si, 25              ;checking if reached to the 25th pixel in the row
	jne printPixelQ
	xor si, si
	inc dx
	inc di
	cmp di, 25               ;checking if reached to the 25th pixel in the col
	jne printPixelQ	
	pop di
	pop	si
	pop	dx
	pop	cx
	pop	bx
	pop	ax
	pop	bp
	ret 6
endp printQueen
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
	x equ [bp+4]
	y equ [bp+6]
	color equ [bp+8]
proc printQueenBlack
	push bp
	mov bp,sp
	push ax 
	push bx
	push cx
	push dx
	push si
	push di
	xor si, si
	xor di, di
	xor cx, cx
	mov bx, offset queen
	mov dx, y
printPixelQ2:
	cmp [byte ptr bx],0
	je nextPixelQ2
	cmp [byte ptr bx], 2
	je paintGold
	mov al, color
	mov ah, 0ch
	mov cx, x
	add cx, si	
	int 10h
	jmp nextPixelQ2
paintGold:
	mov al, 3
	mov ah, 0ch
	mov cx, x
	add cx, si	
	int 10h
nextPixelQ2:
	inc bx
	inc si
	cmp si, 25              ;checking if reached to the 25th pixel in the row
	jne printPixelQ2
	xor si, si
	inc dx
	inc di
	cmp di, 25               ;checking if reached to the 25th pixel in the col
	jne printPixelQ2
	pop di
	pop	si
	pop	dx
	pop	cx
	pop	bx
	pop	ax
	pop	bp
	ret 6
endp printQueenBlack
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
proc firstRed4
	push 13 ;color
	push 175    ;y of the player
	push 0       ;x of the player
	call printSoldier
	push 13
	push 175
	push 50
	call printSoldier
	push 13
	push 175
	push 100
	call printSoldier
	push 13
	push 175
	push 150
	call printSoldier
	jmp secondRedRow
	ret
endp firstRed4
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
proc secondRed4
	push 13     ;color
	push 150    ;y of the player
	push 25      ;x of the player
	call printSoldier
	push 13
	push 150
	push 75
	call printSoldier
	push 13
	push 150
	push 125
	call printSoldier
	push 13
	push 150
	push 175
	call printSoldier
	jmp thirdRedRow
	ret
endp secondRed4
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
proc thirdRed4
	push 13     ;color
	push 125  ;y of the player
	push 0      ;x of the player
	call printSoldier
	push 13
	push 125
	push 50
	call printSoldier
	push 13
	push 125
	push 100
	call printSoldier
	push 13
	push 125
	push 150
	call printSoldier
	jmp firstBlackRow
	ret
endp thirdRed4
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
proc firstBlack4
	push 7   ;color
	push 0 	   ;y of the player
	push 25    ;x of the player
	call printSoldier
	push 7
	push 0
	push 75
	call printSoldier
	push 7
	push 0 
	push 125
	call printSoldier
	push 7
	push 0
	push 175
	call printSoldier
	jmp secondBlackRow
	ret
endp firstBlack4
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
proc secondBlack4
	push 7     ;color
	push 25    ;y of the player
	push 0       ;x of the player
	call printSoldier
	push 7
	push 25
	push 50
	call printSoldier
	push 7
	push 25
	push 100
	call printSoldier
	push 7
	push 25
	push 150
	call printSoldier
	jmp thirdBlackRow
	ret
endp secondBlack4
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
proc thirdBlack4
	push 7     ;color
	push 50	   ;y of the player
	push 25    ;x of the player
	call printSoldier
	push 7
	push 50
	push 75
	call printSoldier
	push 7
	push 50 
	push 125
	call printSoldier
	push 7
	push 50
	push 175
	call printSoldier
	mov [turn], 1
	mov [countEatenBlack], 0 
	mov	[countEatenWhite], 0
	mov [spaceY], 140 
	mov [spaceX], 203
	mov [already], 0
	mov [spaceYB], 140 
	mov [spaceXB], 260 
	mov [already2], 0 
	jmp turnthenstart
	ret
endp thirdBlack4
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
proc printSXYC			;Print a string with a color to the characters. background is always black. Use printBXYC later to fix.
	push bp				;Gets offset of string, text row (0-24), text column(0-39) and color pushed. 
	mov bp,sp
	push ax
	push bx
	push cx
	push dx
	push es 
	mov AH,0Bh
	mov	BH,0
	mov bl,1
	mov al,1
	int 10h
	mov ah,13h
	mov AL,1
	mov bx,[bp+4]		;	Color combination
    mov BH,0	
	mov DX,[bp+8]		;	Column at which to start writing.(0-39) ->DL
	mov CX,[bp+6]
	mov dh,cl			; 	Row at which to start writing. (0-24) ->DH
	mov CX, MaxDigits	; 	String Length
	push ds
	pop es
	mov bp,[bp+10]		;	ES:BP points to string to be printed.
	int 10h
	pop es 
	pop dx
	pop	cx	
	pop	bx
	pop	ax
	pop bp
	ret 8
endp printSXYC
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
proc printSXYC2			;Print a string with a color to the characters. background is always black. Use printBXYC later to fix.
	push bp				;Gets offset of string, text row (0-24), text column(0-39) and color pushed. 
	mov bp,sp
	push ax
	push bx
	push cx
	push dx
	push es 
	mov AH,0Bh
	mov	BH,0
	mov bl,1
	mov al,1
	int 10h
	mov ah,13h
	mov AL,1
	mov bx,[bp+4]		;	Color combination
    mov BH,0	
	mov DX,[bp+8]		;	Column at which to start writing.(0-39) ->DL
	mov CX,[bp+6]
	mov dh,cl			; 	Row at which to start writing. (0-24) ->DH
	mov CX, 2	; 	String Length
	push ds
	pop es
	mov bp,[bp+10]		;	ES:BP points to string to be printed.
	int 10h
	pop es 
	pop dx
	pop	cx	
	pop	bx
	pop	ax
	pop bp
	ret 8
endp printSXYC2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
proc printBXYC			;Fix background color for text.
	push bp				;Gets length(characters) of string, text row (0-24), text column(0-39) of beginning and color pushed. 
	mov bp,sp
	push ax
	push bx
	push cx 
	push dx
	push di 
	push si
	XOR DX,DX
	mov ax,[bp+4]
	mov [pixC],ax
	mov ax,[bp+8] ;Column
	mov bx,FontSize
	mul bx
	mov [pixX], ax 		;X begin
	XOR DX,DX
	mov ax,[bp+6] ;Row
	mov bx,FontSize
	mul bx
	mov [pixY],ax     ;Y Begin
	XOR DX,DX
	mov ax,[bp+10] ;Length
	mov bx,FontSize
	mul bx
	mov [pixL], ax	;Number of pixels in every row
	xor di,di
manyRowsLoop:
	xor si,si
inRowLoop:
	mov CX,[pixX]
	add Cx,si
	push Cx
	mov Dx,[pixY]
	add Dx,di
	push dx
	call GetPixelXY
	pop ax
	cmp al,BLACK		;if it's black replace it.
	jne skipPixel
	push cx
	push dx
	push [pixC]
	call PutPixelXYC
skipPixel:
	inc si
	cmp si,[pixL]
	jb inRowLoop
	inc di
	cmp di,FontSize
	jb manyRowsLoop
	pop si 
	pop di
	pop	dx
	pop	cx
	pop	bx
	pop	ax 
	pop bp
	ret 8
endp printBXYC
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
proc PutPixelXYC			;Put a pixel without interrupt. gets X, Y and Color pushed.
	push bp
	mov bp,sp
	push ax
	push bx 
	push es
	push VideoSeg
	pop es
	mov ax,[bp+6]	;Y = Lines
	mov bx,VideoLen
	mul bx
	add ax,[bp+8]	;X
	mov bx,ax
	mov ax,[bp+4]	;Color
	mov [byte ptr ES:BX],al
	pop es
	pop	bx
	pop	ax
	pop	bp
	ret 6
endp PutPixelXYC
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
proc GetPixelXY				;Get a pixel without interrupt. gets X, Y pushed. Returns color in stack.
	push bp
	mov bp,sp
	push ax
	push bx
	push dx 
	push es
	push VideoSeg
	pop es
	mov ax,[bp+4]	;Y = Lines
	mov bx,VideoLen
	mul bx
	add ax,[bp+6]	;X
	mov bx,ax
	xor ax,ax
	mov al,[byte ptr ES:BX]
	mov [bp+6],ax	;return Color
	pop es
	pop	dx 
	pop bx
	pop ax	
	pop	bp
	ret 2
endp GetPixelXY
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
proc turnmsg
cmp [turn],0
jne change_color
push [blackturn]
push 28
push 14
Push 248	;Text Color of black turn
jmp dont_change
change_color:
push [whiteturn]
push 28
push 14
push 13        ;;;;;;;;;change_color;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
dont_change:
call printSXYC
push MaxDigits	;Length
push 28		;column
push 14	;row
Push 255			;Background Color
call printBXYC
ret 
endp turnmsg 

num equ [bp + 4]
proc number
	push bp
	mov bp, sp	
	push num
	push 29
	push 16
	Push 71	;Text Color of THE NUMBER
	call printSXYC2
	push 2	;Length
	push 29		;column
	push 16	;row
	Push 255			;Background Color
	call printBXYC	
	pop bp
	ret 2
endp number
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
num equ [bp + 4]
proc numberBlack
	push bp
	mov bp, sp	
	push num
	push 38
	push 16
	Push 7	;Text Color of THE NUMBER
	call printSXYC2
	push 2	;Length
	push 38	;column
	push 16	;row
	Push 255			;Background Color
	call printBXYC	
	pop bp
	ret 2
endp numberBlack
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
proc countMsg
	cmp [countEatenBlack], 0
	je zeroloop 
	cmp [countEatenBlack], 1
	je oneloop
	cmp [countEatenBlack], 2
	je Jtwoloop
	cmp [countEatenBlack], 3
	je Jthreeloop
	cmp [countEatenBlack], 4
	je Jfourloop
	cmp [countEatenBlack], 5
	je Jfiveloop
	cmp [countEatenBlack], 6
	je Jsixloop
	cmp [countEatenBlack], 7
	je Jsevenloop
	cmp [countEatenBlack], 8
	je Jeightloop
	cmp [countEatenBlack], 9
	je Jnineloop
	cmp [countEatenBlack], 10
	je Jtenloop
	cmp [countEatenBlack], 11
	je Jelevenloop
	cmp [countEatenBlack], 12
	je Jtwelveloop
Jtwoloop:
	jmp twoloop
Jthreeloop:
	jmp threeloop
Jfourloop:
	jmp fourloop
Jfiveloop:
	jmp fiveloop
Jsixloop:
	jmp sixloop
Jsevenloop:
	jmp sevenloop	
Jeightloop:
	jmp eightloop
Jnineloop:
	jmp nineloop
Jtenloop:
	jmp tenloop
Jelevenloop:
	jmp elevenloop
Jtwelveloop:
	jmp twelveloop
zeroloop:
	push [zeroP]	
	call number 
	jmp finish
oneloop:
	cmp [already], 1 
	je Jfinish
	push [oneP]
	call number
	push 0
	push [spaceY]
	push [spaceX] 
	call printSmalldier
	add [spaceX], 17
	inc [already]
Jfinish:	
	jmp finish
twoloop:
	cmp [already], 2
	je Jfinish	
	push [twoP]
	call number
	push 0 
	push [spaceY]
	push [spaceX]
	call printSmalldier
	add [spaceX], 17
	inc [already]
	jmp finish 
threeloop:
	cmp [already], 3
	je Jfinish	
	push [threeP]
	call number
	push 0 
	push [spaceY]
	push [spaceX]
	call printSmalldier
	sub [spaceX], 34
	add [spaceY], 15
	inc [already]
	jmp finish	
fourloop:
	cmp [already], 4
	je Jfinish
	push [fourP]
	call number	
	push 0 
	push [spaceY]
	push [spaceX]
	call printSmalldier
	add [spaceX], 17
	inc [already]
	jmp finish	
fiveloop:
	cmp [already], 5
	je Jfinish2
	push [fiveP]
	call number
	push 0 
	push [spaceY]
	push [spaceX]
	call printSmalldier
	add [spaceX], 17
	inc [already]
Jfinish2:	
	jmp finish	
sixloop:
	cmp [already], 6
	je Jfinish2
	push [sixP]
	call number
	push 0 
	push [spaceY]
	push [spaceX]
	call printSmalldier
	sub [spaceX], 34
	add [spaceY], 15
	inc [already]
	jmp finish	
sevenloop:
	cmp [already], 7
	je Jfinish2	
	push [sevenP]
	call number
	push 0 
	push [spaceY]
	push [spaceX]
	call printSmalldier
	add [spaceX], 17
	inc [already] 
	jmp finish	
eightloop:
	cmp [already], 8
	je Jfinish2	
	push [eightP]
	call number
	push 0 
	push [spaceY]
	push [spaceX]
	call printSmalldier
	add [spaceX], 17
	inc [already] 
	jmp finish	
nineloop:
	cmp [already], 9
	je finish3
	push [nineP]
	call number	
	push 0 
	push [spaceY]
	push [spaceX]
	call printSmalldier
	sub [spaceX], 34
	add [spaceY], 15
	inc [already]
finish3:	
	jmp finish	
tenloop:
	push [tenP]
	call number
	cmp [already], 10
	je finish	
	push 0 
	push [spaceY]
	push [spaceX]
	call printSmalldier
	add [spaceX], 17
	inc [already] 
	jmp finish	
elevenloop:
	cmp [already], 11
	je finish
	push [elevenP]
	call number	
	push 0 
	push [spaceY]
	push [spaceX]
	call printSmalldier
	add [spaceX], 17
	inc [already] 
	jmp finish	
twelveloop:
	push [twelveP]
	call number		
	cmp [already], 12
	je finish	
	push 0 
	push [spaceY]
	push [spaceX]
	call printSmalldier
	add [spaceX], 17
	inc [already] 	
finish:	
ret 
endp countMsg 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
proc countMsgBlack
	cmp [countEatenWhite], 0
	je zeroloop2 
	cmp [countEatenWhite], 1
	je oneloop2
	cmp [countEatenWhite], 2
	je Jtwoloop2
	cmp [countEatenWhite], 3
	je Jthreeloop2
	cmp [countEatenWhite], 4
	je Jfourloop2
	cmp [countEatenWhite], 5
	je Jfiveloop2
	cmp [countEatenWhite], 6
	je Jsixloop2
	cmp [countEatenWhite], 7
	je Jsevenloop2
	cmp [countEatenWhite], 8
	je Jeightloop2
	cmp [countEatenWhite], 9
	je Jnineloop2
	cmp [countEatenWhite], 10
	je Jtenloop2
	cmp [countEatenWhite], 11
	je Jelevenloop2
Jtwoloop2:
	jmp twoloop2
Jthreeloop2:
	jmp threeloop2
Jfourloop2:
	jmp fourloop2
Jfiveloop2:
	jmp fiveloop2
Jsixloop2:
	jmp sixloop2
Jsevenloop2:
	jmp sevenloop2	
Jeightloop2:
	jmp eightloop2
Jnineloop2:
	jmp nineloop2
Jtenloop2:
	jmp tenloop2
Jelevenloop2:
	jmp elevenloop2	
zeroloop2:
	push [zeroP]
	call numberBlack
	jmp Jfinish5
oneloop2:
	cmp [already2], 1
	je Jfinish6
	push [oneP]
	call numberBlack
	push 0fh
	push [spaceYB]
	push [spaceXB]
	call printSmalldier
	add [spaceXB], 17
	inc [already2]
	jmp finish2
Jfinish6:
	jmp finish2
twoloop2:
	cmp [already2], 2
	je Jfinish5
	push [twoP]
	call numberBlack
	push 0fh
	push [spaceYB]
	push [spaceXB]
	call printSmalldier
	add [spaceXB], 17
	inc [already2]
	jmp finish2
threeloop2: 
	cmp [already2], 3
	je Jfinish5
	push [threeP]
	call numberBlack
	push 0fh
	push [spaceYB]
	push [spaceXB]
	call printSmalldier
	sub [spaceXB], 34 
	add [spaceYB], 15 
	inc [already2]
	jmp finish2	
Jfinish5:
	jmp finish2
fourloop2: 
	cmp [already2], 4
	je Jfinish5
	push [fourP]
	call numberBlack
	push 0fh
	push [spaceYB]
	push [spaceXB]
	call printSmalldier
	add [spaceXB], 17
	inc [already2]
	jmp finish2	
fiveloop2:
	cmp [already2], 5
	je Jfinish4
	push [fiveP]
	call numberBlack
	push 0fh
	push [spaceYB]
	push [spaceXB]
	call printSmalldier
	add [spaceXB], 17
	inc [already2]
	jmp finish2
sixloop2:
	cmp [already2], 6
	je Jfinish4
	push [sixP]
	call numberBlack
	push 0fh
	push [spaceYB]
	push [spaceXB]
	call printSmalldier
	sub [spaceXB], 34
	add [spaceYB], 15 
	inc [already2]
	jmp finish2
Jfinish4:
	jmp finish2
sevenloop2:
	cmp [already2], 7
	je Jfinish4
	push [sevenP]
	call numberBlack
	push 0fh
	push [spaceYB]
	push [spaceXB]
	call printSmalldier
	add [spaceXB], 17
	inc [already2]
	jmp finish2
eightloop2:
	cmp [already2], 8
	je Jfinish4
	push [eightP]
	call numberBlack
	push 0fh
	push [spaceYB]
	push [spaceXB]
	call printSmalldier
	add [spaceXB], 17
	inc [already2]
	jmp finish2
nineloop2:
	cmp [already2], 9
	je Jfinish4
	push [nineP]
	call numberBlack
	push 0fh
	push [spaceYB]
	push [spaceXB]
	call printSmalldier
	sub [spaceXB], 34
	add [spaceYB], 15
	inc [already2]
	jmp finish2
tenloop2: 
	cmp [already2], 10
	je finish2
	push [tenP]
	call numberBlack
	push 0fh
	push [spaceYB]
	push [spaceXB]
	call printSmalldier
	add [spaceXB], 17
	inc [already2]
	jmp finish2
elevenloop2:
	cmp [already2], 11
	je finish2
	push [elevenP]
	call numberBlack
	push 0fh
	push [spaceYB]
	push [spaceXB]
	call printSmalldier
	add [spaceXB], 17
	inc [already2]
	jmp finish2
finish2:	
ret	
endp countMsgBlack
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
proc texmode
push ax
mov ax,3
int 10h
pop ax
ret 
endp texmode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
proc hidemos
push ax
mov ax,2
int 33h
pop ax 
ret 
endp hidemos
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
proc showmos
push ax
mov ax,1
int 33h
pop ax
ret 
endp showmos
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
proc pass 
push ax
nopass:
in al,60h
cmp al,spacepress
jne nopass
pop ax
ret 
endp pass
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
proc PutQueen
	push 0 
	push [MoveY]
	push [MoveX]
	call printSoldier
	push 13 
	push [MoveY] 
	push [MoveX] 
	call printQueen
	ret 
endp PutQueen
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
proc PutBlackQueen
	push 0 
	push [MoveY]
	push [MoveX]
	call printSoldier
	push 7 
	push [MoveY] 
	push [MoveX] 
	call printQueenBlack
	ret 
endp PutBlackQueen
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
proc EraseLeftDown
	sub [xp], 25 
	add [yp], 25
LeftLoop:
	sub [yp], 25 
	add [xp], 25 
	mov ax, [xp] 
	cmp [QueenPressedX], ax 
	je next	
	add [xp], 12 
	add [yp], 12 
	mov cx, [xp] 
	mov dx, [yp]
	mov ah, 0dh 
	int 10h 
	cmp al, 7
	je checkIfWantToEat
	cmp al, 3
	je checkIfWantToEat
	sub [xp], 12 
	sub [yp], 12 
	push 0
	push [yp] 
	push [xp] 
	call printSoldier
	jmp LeftLoop
checkIfWantToEat:
	sub [xp], 12 
	sub [yp], 12
	mov ax, [xp]
	cmp [MoveX], ax 
	ja DontWantTo
	mov bx, [QueenPressedY]
	cmp [MoveY], bx 
	jb DontWantTo
	push 0 
	push [yp] 
	push [xp] 
	call printSoldier
	inc [countEatenBlack]
	jmp LeftLoop
next:
	jmp loop2
DontWantTo:
	;push 7
	;push [yp]
	;push [xp] 
	;call printSoldier
	jmp LeftLoop
	ret
endp EraseLeftDown
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
proc EraseRightDown
	add [whitepossiblex1], 25 
	add [whitepossibley1], 25 
RightLoop:
	sub [whitepossiblex1], 25 
	sub [whitepossibley1], 25 	
	mov ax, [whitepossiblex1]
	cmp [QueenPressedX], ax 
	je next2 	
	add [whitepossiblex1], 12 
	add [whitepossibley1], 12 
	mov cx, [whitepossiblex1]
	mov dx, [whitepossibley1]
	mov ah, 0dh 
	int 10h 
	cmp al, 7 
	je checkIfWantToEat2
	cmp al, 3 
	je checkIfWantToEat2
	sub [whitepossiblex1], 12 
	sub [whitepossibley1], 12 
	push 0
	push [whitepossibley1]
	push [whitepossiblex1]
	call printSoldier
	jmp RightLoop
checkIfWantToEat2:
	sub [whitepossiblex1], 12 
	sub [whitepossibley1], 12
	mov ax, [whitepossiblex1]	
	cmp [MoveX], ax 
	jb DontWantTo2
	mov bx, [QueenPressedY]
	cmp [MoveY], bx 
	jb DontWantTo2
	push 0
	push [whitepossibley1] 
	push [whitepossiblex1] 
	call printSoldier
	inc [countEatenBlack]
	jmp RightLoop
next2:
	jmp loop3
DontWantTo2:
	;push 7
	;push [whitepossibley1]
	;push [whitepossiblex1] 
	;call printSoldier
	jmp RightLoop
	ret
endp EraseRightDown
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
proc EraseRightUp
	add [whitepossiblex2], 25 
	sub [whitepossibley2], 25
RightLoop2:
	sub [whitepossiblex2], 25 
	add [whitepossibley2], 25
	mov ax, [whitepossiblex2]
	cmp [QueenPressedX], ax 
	je next3 	
	add [whitepossiblex2], 12 
	add [whitepossibley2], 12 
	mov cx, [whitepossiblex2]
	mov dx, [whitepossibley2]
	mov ah, 0dh 
	int 10h 
	cmp al, 7 
	je checkIfWantToEat3
	cmp al, 3 
	je checkIfWantToEat3
	sub [whitepossiblex2], 12 
	sub [whitepossibley2], 12 
	push 0 
	push [whitepossibley2]
	push [whitepossiblex2]
	call printSoldier
	jmp RightLoop2
checkIfWantToEat3:
	sub [whitepossiblex2], 12 
	sub [whitepossibley2], 12 
	mov ax, [whitepossiblex2]
	cmp [MoveX], ax
	jb DontWantTo3
	mov bx, [QueenPressedY]
	cmp [MoveY], bx	
	ja DontWantTo3
	push 0 
	push [whitepossibley2] 
	push [whitepossiblex2] 
	call printSoldier
	inc [countEatenBlack]
	jmp RightLoop2
next3:
	jmp loop4
DontWantTo3:
	;push 7 
	;push [whitepossibley2]
	;push [whitepossiblex2] 
	;call printSoldier
	jmp RightLoop2
	ret
endp EraseRightUp 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
proc EraseLeftUP
	sub [ypBlack], 25 
	sub [xpBlack], 25 
LeftLoop2:
	add [ypBlack], 25 
	add [xpBlack], 25 
	mov ax, [xpBlack]
	cmp [QueenPressedX], ax 
	je next4 
	add [xpBlack], 12 
	add [ypBlack], 12 
	mov cx, [xpBlack]
	mov dx, [ypBlack]
	mov ah, 0dh 
	int 10h 
	cmp al, 7 
	je checkIfWantToEat4
	cmp al, 3 
	je checkIfWantToEat4
	sub [xpBlack], 12 
	sub [ypBlack], 12 
	push 0
	push [ypBlack]
	push [xpBlack]
	call printSoldier
	jmp LeftLoop2
checkIfWantToEat4:
	sub [xpBlack], 12 
	sub [ypBlack], 12 
	mov ax, [xpBlack]
	cmp [MoveX], ax
	ja DontWantTo4
	mov bx, [QueenPressedY]
	cmp [MoveY], bx	
	ja DontWantTo4
	push 0 
	push [ypBlack] 
	push [xpBlack] 
	call printSoldier
	inc [countEatenBlack]
	jmp LeftLoop2
next4:
	jmp loop5	
DontWantTo4:
	;push 7 
	;push [ypBlack]
	;push [xpBlack] 
	;call printSoldier
	jmp LeftLoop2
	ret	
endp EraseLeftUp	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
proc EraseLeftDownBlack
	sub [xp], 25 
	add [yp], 25
LeftLoopBlack:
	sub [yp], 25 
	add [xp], 25 
	mov ax, [xp] 
	cmp [QueenPressedX], ax 
	je nextBlack	
	add [xp], 12 
	add [yp], 12 
	mov cx, [xp] 
	mov dx, [yp]
	mov ah, 0dh 
	int 10h 
	cmp al, 13
	je checkIfWantToEatBlack
	cmp al, 255
	je checkIfWantToEatBlack
	sub [xp], 12 
	sub [yp], 12 
	push 0
	push [yp] 
	push [xp] 
	call printSoldier
	jmp LeftLoopBlack
checkIfWantToEatBlack:
	sub [xp], 12 
	sub [yp], 12
	mov ax, [xp]
	cmp [MoveX], ax 
	ja DontWantToBlack
	mov bx, [QueenPressedY]
	cmp [MoveY], bx 
	jb DontWantToBlack
	push 0 
	push [yp] 
	push [xp] 
	call printSoldier
	inc [countEatenWhite]
	jmp LeftLoopBlack
nextBlack:
	jmp loop2Black
DontWantToBlack:
	;push 13
	;push [yp]
	;push [xp] 
	;call printSoldier
	jmp LeftLoopBlack
	ret
endp EraseLeftDownBlack
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
proc EraseRightDownBlack
	add [whitepossiblex1], 25 
	add [whitepossibley1], 25 
RightLoopBlack:
	sub [whitepossiblex1], 25 
	sub [whitepossibley1], 25 	
	mov ax, [whitepossiblex1]
	cmp [QueenPressedX], ax 
	je next2Black 	
	add [whitepossiblex1], 12 
	add [whitepossibley1], 12 
	mov cx, [whitepossiblex1]
	mov dx, [whitepossibley1]
	mov ah, 0dh 
	int 10h 
	cmp al, 13 
	je checkIfWantToEat2Black
	cmp al, 255
	je checkIfWantToEat2Black
	sub [whitepossiblex1], 12 
	sub [whitepossibley1], 12 
	push 0
	push [whitepossibley1]
	push [whitepossiblex1]
	call printSoldier
	jmp RightLoopBlack
checkIfWantToEat2Black:
	sub [whitepossiblex1], 12 
	sub [whitepossibley1], 12
	mov ax, [whitepossiblex1]	
	cmp [MoveX], ax 
	jb DontWantTo2Black
	mov bx, [QueenPressedY]
	cmp [MoveY], bx 
	jb DontWantTo2Black
	push 0
	push [whitepossibley1] 
	push [whitepossiblex1] 
	call printSoldier
	inc [countEatenWhite]
	jmp RightLoopBlack
next2Black:
	jmp loop3Black
DontWantTo2Black:
	;push 13
	;push [whitepossibley1]
	;push [whitepossiblex1] 
	;call printSoldier
	jmp RightLoopBlack
	ret
endp EraseRightDownBlack
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
proc EraseRightUpBlack
	add [whitepossiblex2], 25 
	sub [whitepossibley2], 25
RightLoop2Black:
	sub [whitepossiblex2], 25 
	add [whitepossibley2], 25
	mov ax, [whitepossiblex2]
	cmp [QueenPressedX], ax 
	je next3Black 	
	add [whitepossiblex2], 12 
	add [whitepossibley2], 12 
	mov cx, [whitepossiblex2]
	mov dx, [whitepossibley2]
	mov ah, 0dh 
	int 10h 
	cmp al, 13 
	je checkIfWantToEat3Black
	cmp al, 255
	je checkIfWantToEat3Black
	sub [whitepossiblex2], 12 
	sub [whitepossibley2], 12 
	push 0
	push [whitepossibley2]
	push [whitepossiblex2]
	call printSoldier
	jmp RightLoop2Black
checkIfWantToEat3Black:
	sub [whitepossiblex2], 12 
	sub [whitepossibley2], 12 
	mov ax, [whitepossiblex2]
	cmp [MoveX], ax
	jb DontWantTo3Black
	mov bx, [QueenPressedY]
	cmp [MoveY], bx	
	ja DontWantTo3Black
	push 0 
	push [whitepossibley2] 
	push [whitepossiblex2] 
	call printSoldier
	inc [countEatenWhite]
	jmp RightLoop2Black
next3Black:
	jmp loop4Black
DontWantTo3Black:
	;push 13 
	;push [whitepossibley2]
	;push [whitepossiblex2] 
	;call printSoldier
	jmp RightLoop2Black
	ret
endp EraseRightUpBlack 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
proc EraseLeftUPBlack
	sub [ypBlack], 25 
	sub [xpBlack], 25 
LeftLoop2Black:
	add [ypBlack], 25 
	add [xpBlack], 25 
	mov ax, [xpBlack]
	cmp [QueenPressedX], ax 
	je next4Black 
	add [xpBlack], 12 
	add [ypBlack], 12 
	mov cx, [xpBlack]
	mov dx, [ypBlack]
	mov ah, 0dh 
	int 10h 
	cmp al, 13 
	je checkIfWantToEat4Black
	cmp al, 255
	je checkIfWantToEat4Black
	sub [xpBlack], 12 
	sub [ypBlack], 12 
	push 0
	push [ypBlack]
	push [xpBlack]
	call printSoldier
	jmp LeftLoop2Black
checkIfWantToEat4Black:
	sub [xpBlack], 12 
	sub [ypBlack], 12 
	mov ax, [xpBlack]
	cmp [MoveX], ax
	ja DontWantTo4Black
	mov bx, [QueenPressedY]
	cmp [MoveY], bx	
	ja DontWantTo4Black
	push 0 
	push [ypBlack] 
	push [xpBlack] 
	call printSoldier
	inc [countEatenWhite]
	jmp LeftLoop2Black
next4Black:
	jmp loop5Black	
DontWantTo4Black:
	;push 13 
	;push [ypBlack]
	;push [xpBlack] 
	;call printSoldier
	jmp LeftLoop2Black
	ret	
endp EraseLeftUpBlack	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
