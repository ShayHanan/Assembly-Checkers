BlackQueen:
	sub dx, 12
	sub cx, 12
	mov [xp], cx 
	mov [yp], dx 
	mov [whitepossiblex1], cx 
	mov [whitepossibley1], dx 
	mov [whitepossiblex2], cx 
	mov [whitepossibley2], dx 
	mov [xpBlack], cx 
	mov [ypBlack], dx
	mov [queenPressedX], cx 
	mov [queenPressedY], dx
	mov bx, [queenPressedY]
	mov [canEat], 0
	mov [itsBlack], 1 
LeftDownBlack:							;variables used: xp, yp
	cmp [yp], 175
	je JmpRightDownBlack2 ;dont need to sub because its the queen's x and y. jumps to the next one.
	sub [xp], 25 
	add [yp], 25
	add [xp], 12 
	add [yp], 12
	mov cx, [xp] 
	mov dx, [yp] 
	mov ah, 0dh 
	int 10h 
	cmp al, 13 
	je stopRed 
	cmp al, 255 
	je stopRed 
	cmp al, 3 
	je JmpRightDownBlack
	cmp al, 7 
	je JmpRightDownBlack
	cmp al, 255
	je stopRed
	sub [xp], 12 
	sub [yp], 12 
	cmp [xp], 200 
	ja shortcut2
	push 248 
	push [yp] 
	push [xp] 	
	call printsoldier
	cmp [xp], 0
	je RightDownBlack
	cmp [yp], 175 
	jae RightDownBlack
	jmp LeftDownBlack
JmpRightDownBlack2:
	jmp RightDownBlack
JmpRightDownBlack:
	sub [xp], 12 
	sub [yp], 12
shortcut2:	
	add [xp], 25 
	sub [yp], 25	
	jmp RightDownBlack
stopRed:
	sub cx, 25 
	add dx, 25
	mov ah, 0dh 
	int 10h 
	cmp al, 7 
	je JmpRightDownBlack
	cmp al, 255
	je JmpRightDownBlack
	cmp al, 13
	je JmpRightDownBlack
	cmp cx, 200 
	jae JmpRightDownBlack
	sub cx, 12 
	sub dx, 12
	cmp dx, 25
	jbe JmpRightDownBlack
	mov [xp], cx 
	mov [yp], dx
	push 248 
	push dx
	push cx
	call printsoldier
	mov ax, 1 
	int 33h
	inc [canEat]
RightDownBlack:						;variables used: whitepossiblex1, whitepossibley1
	mov ax, 2 
	int 33h
	add [whitepossiblex1], 25 
	add [whitepossibley1], 25 
	cmp [whitepossibley1], 200 
	je alreadysubed
	add [whitepossiblex1], 12 
	add [whitepossibley1], 12
	cmp [whitepossiblex1], 200 
	jae JmpRightUpBlack
	mov cx, [whitepossiblex1] 
	mov dx, [whitepossibley1] 
	mov ah, 0dh 
	int 10h 
	cmp al, 13 
	je stopRed2 
	cmp al, 7 
	je JmpRightUpBlack
	cmp al, 3 
	je JmpRightUPBlack
	cmp al, 255
	je stopRed2
	sub [whitepossiblex1], 12 
	sub [whitepossibley1], 12 
	cmp [whitepossibley1], 175 
	ja alreadysubed
	push 248
	push [whitepossibley1]
	push [whitepossiblex1]
	call printSoldier
	jmp RightDownBlack
JmpRightUpBlack:
	sub [whitepossiblex1], 12 
	sub [whitepossibley1], 12 
alreadysubed:	
	sub [whitepossiblex1], 25 
	sub [whitepossibley1], 25 
	jmp RightUpBlack
stopRed2:
	mov ax, 2 
	int 33h 
	add cx, 25 
	add dx, 25
	mov ah, 0dh 
	int 10h 
	cmp al, 13 
	je JmpRightUpBlack
	cmp al, 255
	je JmpRightUpBlack
	cmp al, 7
	je JmpRightUPBlack
	cmp cx, 200 
	jae JmpRightUpBlack
	sub cx, 12 
	sub dx, 12 
	cmp dx, 175 
	ja JmpRightUPBlack
	mov [whitepossiblex1], cx 
	mov [whitepossibley1], dx
	push 248 
	push dx
	push cx
	call printSoldier
	mov ax, 1 
	int 33h
	inc [canEat]
RightUpBlack:						;variables used: whitepossiblex2, whitepossibley2
	add [whitepossiblex2], 25 
	sub [whitepossibley2], 25
	add [whitepossiblex2], 12 
	add [whitepossibley2], 12
	cmp [whitepossiblex2], 200 
	jae JmpLeftUpBlack	
	cmp [whitepossibley2], 175 
	jae JmpLeftUpBlack
	mov cx, [whitepossiblex2] 
	mov dx, [whitepossibley2] 
	mov ah, 0dh 
	int 10h 
	cmp al, 13 
	je stopRed3 
	cmp al, 7 
	je JmpLeftUpBlack
	cmp al, 3 
	je JmpLeftUpBlack
	cmp al, 255
	je stopRed3
	sub [whitepossiblex2], 12 
	sub [whitepossibley2], 12 
	push 248
	push [whitepossibley2]
	push [whitepossiblex2]
	call printSoldier
	cmp [whitepossibley2], 0 
	je LeftUpBlack
	jmp RightUpBlack
JmpLeftUpBlack:
	sub [whitepossiblex2], 12 
	sub [whitepossibley2], 12	
	sub [whitepossiblex2], 25 
	add [whitepossibley2], 25	
	jmp LeftUpBlack
stopRed3:
	add [whitepossiblex2], 25 
	sub [whitepossibley2], 25
	mov cx, [whitepossiblex2]
	mov dx, [whitepossibley2]
	mov ah, 0dh 
	int 10h 
	cmp al, 7 
	je JmpLeftUpBlack
	cmp al, 13 
	je JmpLeftUpBlack
	cmp al, 255
	je JmpLeftUpBlack
	cmp al, 3
	je JmpLeftUpBlack
	cmp [whitepossiblex2], 200 
	jae JmpLeftUpBlack
	cmp [whitepossibley2], 175
	jae JmpLeftUpBlack
	sub [whitepossiblex2], 12 
	sub [whitepossibley2], 12
	push 248 
	push [whitepossibley2]
	push [whitepossiblex2]
	call printSoldier
	mov ax, 1 
	int 33h 
	inc [canEat]
LeftUpBlack:					;variables used: ypBlack, xpBlack
	sub [ypBlack], 25 
	sub [xpBlack], 25 
	add [ypBlack], 12
	add [xpBlack], 12 
	cmp [ypBlack], 0 
	je JmperaseBlack
	cmp [ypBlack], 190
	ja JmpEraseBlack
	cmp [xpBlack], 200 
	jae JmpEraseBlack
	mov cx, [xpBlack] 
	mov dx, [ypBlack] 
	mov ah, 0dh 
	int 10h 
	cmp al, 13 
	je stopRed4
	cmp al, 7 
	je JmpEraseBlack
	cmp al, 3 
	je JmpEraseBlack	
	cmp al, 255
	je stopRed4
	sub [ypBlack], 12
	sub [xpBlack], 12 
	;cmp [xpBlack], 200 
	;ja shortcut
	push 248 
	push [ypBlack] 
	push [xpBlack]
	call printSoldier
	cmp [xpBlack], 0 
	je eraseBlack
	jmp LeftUpBlack
JmpEraseBlack:
	sub [ypBlack], 12
	sub [xpBlack], 12
JmpErase2Black:	
	add [xpBlack], 25 
	add [ypBlack], 25
	mov ax, 1 
	int 33h
shortcutBlack:	
	jmp eraseBlack
stopRed4:
	sub [ypBlack], 25 
	sub [xpBlack], 25 
	mov cx, [xpBlack]
	mov dx, [ypBlack]
	mov ah, 0dh 
	int 10h 
	cmp al, 7 
	je JmperaseBlack
	cmp al, 13 
	je JmperaseBlack
	cmp al, 255
	je JmperaseBlack
	cmp [xpBlack], 200 
	jae JmperaseBlack
	cmp [ypBlack], 175
	jae JmperaseBlack
	sub [ypBlack], 12
	sub [xpBlack], 12
	push 248 
	push [ypBlack] 
	push [xpBlack]
	call printSoldier
	mov ax, 1 
	int 33h
	inc [canEat]
eraseBlack:
	mov ax, 1 
	int 33h
	mov ax, 3
	int 33h
	cmp bx, 1 
	jne eraseBlack
	shr cx, 1
	mov ax, 2 
	int 33h	
	mov bh, 0h
	mov ah, 0dh 
	int 10h
	cmp al, 248 				;checks if the player pressed on a possible move
	mov ax, 1 
	int 33h
	je setYXQueenBlack
	cmp [canEat], 0 
	je DontChangeTurnBlack
	jmp eraseBlack
DontChangeTurnBlack:
	dec [turn]
	jmp blacks	
setYXQueenBlack:						;set the y and the x to where the soldier is printed from
	mov ax, 1 
	int 33h
	xor ah, ah
	mov ax, cx
	mov bl, 25
	div bl
	sub cl, ah
	xor ah, ah
	mov ax, dx
	mov bl, 25
	div bl		
	sub dl, ah
	mov [MoveX], cx 
	mov [MoveY], dx 
	mov ax, 2 
	int 33h 
	push 0 
	push [queenPressedY]
	push [queenPressedX]
	call printSoldier
	mov ax,[queenPressedX]
	cmp [xp], ax 
	je loop2Black
	call EraseLeftDownBlack	
loop2Black:
	cmp [whitepossiblex1], ax 
	je loop3Black
	call EraseRightDownBlack
loop3Black:	
	cmp [whitepossiblex2], ax 
	je loop4Black
	call EraseRightUpBlack
loop4Black:	
	cmp [xpBlack], ax 
	je loop5Black
	call EraseLeftUpBlack
loop5Black:	
	push 7 
	push [MoveY] 
	push [MoveX]
	call printQueenBlack
	mov ax, 1 
	int 33h	
	jmp turnthenstart
