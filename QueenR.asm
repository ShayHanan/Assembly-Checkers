QueenR:
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
LeftDown:					;variables used: xp, yp, draws all the possible moves to the left down of the queen.
	sub [xp], 25 
	add [yp], 25
	add [xp], 12 
	add [yp], 12
	mov cx, [xp] 
	mov dx, [yp] 
	mov ah, 0dh 
	int 10h 
	cmp al, 7 			;checks if theres a soldier that can be eaten.
	je stopBlack 						
	cmp al, 3 			;checks if theres a black queen that can be eaten.
	je stopBlack		
	cmp al, 13 
	je JmpRightDown		;checks if theres a red soldier that prevents the queen to move to this position.
	cmp al, 255			;checks if theres a red queen that prevents the queen to move to this position.
	je JmpRightDown
	sub [xp], 12 
	sub [yp], 12 
	cmp [xp], 200 		;checks if this move is out of the range of the borad.
	ja alreadysubed2
	cmp [yp], 175 
	ja alreadysubed2	;checks if this move is out of the range of the borad.
	push 9 
	push [yp] 
	push [xp] 	
	call printsoldier	;draws the possible move.
	cmp [xp], 0
	je RightDown
	jmp LeftDown
JmpRightDown:	
	sub [xp], 12 
	sub [yp], 12 
alreadysubed2:	
	add [xp], 25 
	sub [yp], 25
	jmp RightDown
stopBlack:				
	sub cx, 25 
	add dx, 25
	mov ah, 0dh 
	int 10h 
	cmp al, 13 			;checks if theres a red player after the soldier that can be eaten that prevents the equeen to eat.
	je JmpRightDown
	cmp al, 255
	je JmpRightDown		;red queen
	cmp al, 7
	je JmpRightDown		;black soldier.
	cmp al, 3 			;black queen.
	je JmpRightDown
	cmp cx, 200 
	jae JmpRightDown
	sub cx, 12 
	sub dx, 12
	cmp dx, 25
	jbe JmpRightDown
	mov [xp], cx 
	mov [yp], dx
	push 9 
	push dx
	push cx
	call printsoldier     ;draws the possible move.
	mov ax, 1 
	int 33h
	inc [canEat]
RightDown:		;variables used: whitepossiblex1, whitepossibley1, draws all the possible moves to the right down of the queen
	mov ax, 2 
	int 33h
	add [whitepossiblex1], 25 
	add [whitepossibley1], 25 
	add [whitepossiblex1], 12 
	add [whitepossibley1], 12
	cmp [whitepossiblex1], 200 
	jae JmpRightUp
	mov cx, [whitepossiblex1] 
	mov dx, [whitepossibley1] 
	mov ah, 0dh 
	int 10h 
	cmp al, 7 
	je stopBlack2 ;checks if theres a soldier that can be eaten.
	cmp al, 3 
	je stopBlack2 ;black queen.
	cmp al, 13 
	je JmpRightUp	;check if theres a red soldier that prevents the queen from moving to this position, if so, jump to the next rwo.
	cmp al, 255	;red queen.
	je JmpRightUp
	sub [whitepossiblex1], 12 
	sub [whitepossibley1], 12 
	push 9
	push [whitepossibley1]
	push [whitepossiblex1]
	call printSoldier ;draws the possible move.
	cmp [whitepossibley1], 175 
	je RightUp
	jmp RightDown
JmpRightUp:
	sub [whitepossiblex1], 12 
	sub [whitepossibley1], 12 	
	sub [whitepossiblex1], 25 
	sub [whitepossibley1], 25 
	jmp RightUp
stopBlack2:
	mov ax, 2 
	int 33h 
	add cx, 25 
	add dx, 25
	mov ah, 0dh 
	int 10h 
	cmp al, 13 
	je JmpRightUp	;checks if theres a red oldier that prevents the queen from eating.
	cmp al, 255
	je JmpRightUp ;red queen.
	cmp al, 7
	je JmpRightUP ;black queen.
	cmp cx, 200 
	jae JmpRightUp ;checks if the move is out of the range of the board.
	sub cx, 12 
	sub dx, 12 
	cmp dx, 25 
	jbe JmpRightUP
	mov [whitepossiblex1], cx 
	mov [whitepossibley1], dx
	push 9 
	push dx
	push cx
	call printSoldier ;draws the possible move.
	mov ax, 1 
	int 33h
	inc [canEat]
RightUp:						;variables used: whitepossiblex2, whitepossibley2
	add [whitepossiblex2], 25 
	sub [whitepossibley2], 25
	add [whitepossiblex2], 12 
	add [whitepossibley2], 12
	cmp [whitepossiblex2], 200 
	jae JmpLeftUp	
	cmp [whitepossibley2], 175 
	jae JmpLeftUp
	mov cx, [whitepossiblex2] 
	mov dx, [whitepossibley2] 
	mov ah, 0dh 
	int 10h 
	cmp al, 7 
	je stopBlack3 
	cmp al, 3 
	je stopBlack3
	cmp al, 13 
	je JmpLeftUp
	cmp al, 255
	je JmpLeftUp
	sub [whitepossiblex2], 12 
	sub [whitepossibley2], 12 
	push 9
	push [whitepossibley2]
	push [whitepossiblex2]
	call printSoldier
	cmp [whitepossibley2], 0 
	je LeftUp
	jmp RightUp
JmpLeftUp:
	sub [whitepossiblex2], 12 
	sub [whitepossibley2], 12	
	sub [whitepossiblex2], 25 
	add [whitepossibley2], 25	
	jmp LeftUp
stopBlack3:
	add [whitepossiblex2], 25 
	sub [whitepossibley2], 25
	mov cx, [whitepossiblex2]
	mov dx, [whitepossibley2]
	mov ah, 0dh 
	int 10h 
	cmp al, 7 
	je JmpLeftUp
	cmp al, 13 
	je JmpLeftUp
	cmp al, 255
	je JmpLeftUp
	cmp [whitepossiblex2], 200 
	jae JmpLeftUp
	cmp [whitepossibley2], 175
	jae JmpLeftUp
	sub [whitepossiblex2], 12 
	sub [whitepossibley2], 12
	push 9 
	push [whitepossibley2]
	push [whitepossiblex2]
	call printSoldier
	mov ax, 1 
	int 33h 
	inc [canEat]
LeftUp:					;variables used: ypBlack, xpBlack
	sub [ypBlack], 25 
	sub [xpBlack], 25 
	add [ypBlack], 12
	add [xpBlack], 12 
	cmp [ypBlack], 0 
	je Jmperase
	cmp [ypBlack], 190
	ja JmpErase
	mov cx, [xpBlack] 
	mov dx, [ypBlack] 
	mov ah, 0dh 
	int 10h 
	cmp al, 7 
	je stopBlack4
	cmp al, 3 
	je stopBlack4
	cmp al, 13 
	je JmpErase
	cmp al, 255
	je JmpErase
	sub [ypBlack], 12
	sub [xpBlack], 12 
	;cmp [xpBlack], 200 
	;ja shortcut
	cmp [xpBlack], 200 
	ja JmpErase2
	push 9 
	push [ypBlack] 
	push [xpBlack]
	call printSoldier
	jmp LeftUp
JmpErase:
	sub [ypBlack], 12
	sub [xpBlack], 12
JmpErase2:	
	add [xpBlack], 25 
	add [ypBlack], 25
	mov ax, 1 
	int 33h
shortcut:	
	jmp erase
stopBlack4:
	sub [ypBlack], 25 
	sub [xpBlack], 25 
	mov cx, [xpBlack]
	mov dx, [ypBlack]
	mov ah, 0dh 
	int 10h 
	cmp al, 7 
	je Jmperase
	cmp al, 13 
	je Jmperase
	cmp al, 255
	je Jmperase
	cmp [xpBlack], 200 
	jae Jmperase
	cmp [ypBlack], 175
	jae Jmperase
	sub [ypBlack], 12
	sub [xpBlack], 12
	push 9 
	push [ypBlack] 
	push [xpBlack]
	call printSoldier
	mov ax, 1 
	int 33h
	inc [canEat]
	jmp erase
erase:
	mov ax, 1 
	int 33h
	mov ax, 3
	int 33h
	cmp bx, 1 
	jne erase
	shr cx, 1
	mov ax, 2 
	int 33h	
	mov bh, 0h
	mov ah, 0dh 
	int 10h
	cmp al, 9 				;checks if the player pressed on a possible move
	mov ax, 1 
	int 33h
	je setYXQueen
	cmp [canEat], 0 
	je DontChangeTurn
	jmp erase
DontChangeTurn:
	inc [turn]
	jmp whichSoldier	
setYXQueen:						;set the y and the x to where the soldier is printed from
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
	call printSoldier	;disappearing the queen.
	mov ax, [queenPressedX]
	cmp [xp], ax 
	je loop2
	call EraseLeftDown	
loop2:
	cmp [whitepossiblex1], ax 
	je loop3
	call EraseRightDown
loop3:	
	cmp [whitepossiblex2], ax 
	je loop4
	call EraseRightUp
loop4:	
	cmp [xpBlack], ax 
	je loop5
	call EraseLeftUp
loop5:	
	push 13 
	push [MoveY] 
	push [MoveX]
	call printQueen
	mov ax, 1 
	int 33h	
	jmp turnthenstart

	 