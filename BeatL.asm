BlackEatL:
	mov	[canEat], 0 
	mov [canEat2], 0
	sub cx, 25 
	add dx, 25 
	mov bh, 0 
	mov ah, 0dh 
	int 10h 
	cmp al, 7					;checks if there's a black soldier after the black soldier that prevents the player from eating
	je Jumpback
	cmp al, 13 
	je Jumpback
	cmp al, 255 
	je Jumpback
	cmp al, 3 
	je Jumpback
	jmp dontgoback
Jumpback:
	jmp backToBlackPosition
dontgoback:	
	sub [blackpossiblex1], 25 			;turns the possible move to the x that the soldier can move he eats
	cmp [blackpossiblex1], 200 			;checks if the x is out of range
	jae JmpbackBlack
	jmp besederBlack
JmpbackBlack:
	jmp backBlack
besederBlack:
	add [blackpossiblex1], 25 			;returns to the original x 
	;push 13 								;changes the color of the soldier that can be eaten
	;push [blackpossibley1]		
	;push [blackpossiblex1]
	;call printSoldier	
	sub [blackpossiblex1], 25 			;turns the x to the starting x that the soldier is starting from
	add [blackpossibley1], 25			;turns the y to the starting y that the soldier is starting from
	mov cx, 1 
eatLoop3:
	push 248
	push [blackpossibley1]
	push [blackpossiblex1]
	call printSoldier
	call delay
	push 0
	push [blackpossibley1]
	push [blackpossiblex1]
	call printSoldier
	call delay
	push 248
	push [blackpossibley1]
	push [blackpossiblex1]
	call printSoldier
	loop eatLoop3
	add [xpBLack], 25 		;turns the x that was pressed to the second x that the player can move to
	add [ypBlack], 25		;turns the y that was pressed to the second y that the player can move to
	mov ax, [xpBlack]
	mov bx, [ypBlack]
	mov [blackpossiblex2], ax				;turns the original possible x to the second possible x
	mov [blackpossibley2], bx				;turns the original possible y to the second possible y
	add ax, 12 
	add bx, 12
	mov cx, ax 
	mov dx, bx 
	mov bh, 0 
	mov ah, 0dh
	int 10h
	cmp al, 7								;checks if there's a black soldier that prevents the player from move to the left side
	je haveToEatBlack
	cmp al, 3
	je haveToEatBlack
	inc [donthaveTo]
	cmp al, 13 		;checks if there's a red soldier that can be eaten too
	je eat2Black
	cmp al, 255 
	je Inceat2Black
	inc [donthaveTo2]
	cmp [blackpossiblex2], 200 
	jae haveToEatBLack
	push 248 									;if not mark that place as a possible move
	push [blackpossibley2]
	push [blackpossiblex2]
	call printSoldier
haveToEatBlack:	
	sub [xpBlack], 25 						;returns the x and y that was pressed t0 their original values
	sub [ypBlack], 25
	jmp eatGraphBlack	
JmptheresBlack:
	inc [canEat2]
	jmp eatGraphBlack	
Inceat2Black:
	inc [queenV]
eat2Black:
	add [blackpossiblex2], 25 
	add [blackpossibley2], 25
	add [blackpossiblex2], 12 
	add [blackpossibley2], 12
	mov cx, [blackpossiblex2]
	mov dx, [blackpossibley2]
	mov bh, 0 
	mov ah, 0dh
	int 10h 
	cmp al, 7 					;checks if there's a black soldier that prevents the player from eating
	je JmptheresBlack
	cmp al, 13 					;checks if there's a red soldier that prevents the player from eating
	je haveToEatBLack
	sub [blackpossiblex2], 12 
	sub [blackpossibley2], 12
	cmp [blackpossiblex2], 0 
	jb haveToEatBlack
	cmp [blackpossiblex2], 200 
	jae haveToEatBlack
	sub [blackpossiblex2], 25 
	sub [blackpossibley2], 25
	;push 13 
	;push [blackpossibley2]				;changes the color of the soldier that can be eaten
	;push [blackpossiblex2]
	;call printSoldier
	mov ax, [Blackpossiblex2]	
	mov bx, [Blackpossibley2]
	add ax, 25 
	add bx, 25
	mov [MoveX], ax 					;put inside this variable the x of where the player will be moved if he eats to the left
	mov [MoveY], bx				;put inside this variable the y of where the player will be moved if he eats to the left
	mov cx, 1 
eatLoop4:	
	push 248 
	push bx 
	push ax 
	call printSoldier
	call delay
	push 0 
	push bx 
	push ax 
	call printSoldier
	call delay 
	push 248 
	push bx 
	push ax 
	call printSoldier
	loop eatLoop4
	inc [canEat]
eatGraphBlack:	
	mov ax, 3
	int 33h
	shr cx, 1
	cmp bx, 1 
	jne eatGraphBlack
	mov ax, 2 
	int 33h 
	mov bh, 0h
	mov ah, 0dh 
	int 10h
	cmp al, 248    ;checks if the mouse is on a possible move
	mov ax, 1 
	int 33h 
	je YXBlack
	jmp eatGraphBlack
YXBlack:
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
	cmp cx, [blackpossiblex1]
	je eatenBlack
	cmp [canEat], 1 
	je JmpeatLeftBlack
	jmp notEatenBlack
JmpeatLeftBlack:
	jmp eatLeftBlack
eatenBlack:
	mov ax, 3 
	int 33h 
	shr cx, 1
	mov ax, 2 
	int 33h
	inc [countEatenWhite]
	push 0
	push [ypBlack]
	push [xpBLack] 
	call printSoldier
	push 7
	push [blackpossibley1]
	push [blackpossiblex1]
	call printSoldier
	mov ax, [blackpossiblex1]
	mov bx, [blackpossibley1]
	mov [MoveX], ax 
	mov [MoveY], bx 
	add [blackpossiblex1], 25 
	sub [blackpossibley1], 25
	push 0
	push [blackpossibley1]
	push [blackpossiblex1]
	call printSoldier
	sub [blackpossibley2], 12 
	sub [blackpossiblex2], 12
	jmp proceed
JmptheresBlack2:
	jmp theresBlack
proceed:	
	add [blackpossibley2], 12 
	add [blackpossiblex2], 12
	mov ax, [xpBlack] 
	mov bx, [ypBlack]
	mov [blackpossiblex2], ax 
	mov [blackpossibley2], bx
	add [blackpossiblex2], 25 
	add [blackpossibley2], 25
	cmp [blackpossiblex2], 200 
	jae blackOutsideBlack
	cmp [donthaveTo], 0
	je blackOutsideBlack
	cmp [donthaveTo2], 0
	je blackOutsideBlack
	push 0
	push [Blackpossibley2]
	push [Blackpossiblex2]
	call printSoldier
blackOutsideBlack:	
	push 0 
	push [ypBlack] 
	push [xpBlack] 
	call printSoldier
	cmp [MoveY], 175
	je JmpqueenEat2
	cmp [canEat], 1 
	je addYXpBlack
	cmp [canEat2], 1 
	je addYXpBlack 
	mov ax, 1 
	int 33h	
	jmp turnthenstart
JmpqueenEat2:
	jmp queenEat2
theresBlack:
	push 0
	push [ypBlack]
	push [xpBlack]
	call printSoldier
	mov ax, 1
	int 33h 
	jmp turnthenstart
addYXpBlack:
	sub [ypBLack], 25 
	sub [xpBLack], 25
	sub [blackpossiblex2], 50 
	sub [blackpossibley2], 50 	
	push 0
	push [blackpossibley2] 
	push [blackpossiblex2] 
	call printSoldier
	add [xpBLack], 25
	add [ypBlack], 25
	push 13
	push [ypBlack]
	push [xpBlack]
	call printSoldier
	add [ypBlack], 25
	add [xpBLack], 25
	push 0
	push [ypBlack]
	push [xpBlack]
	call printSoldier
	cmp [canEat2], 1 
	jne dontbringBackBlack
	add [blackpossiblex2], 25 
	add [blackpossibley2], 25 
	push 13 
	push [blackpossibley2] 
	push [blackpossiblex2] 
	call printSoldier
	add [blackpossiblex2], 25 
	add [blackpossibley2], 25 
	push 7 
	push [blackpossibley2] 
	push [blackpossiblex2] 
	call printSoldier
dontbringBackBlack:
	mov ax, 1 
	int 33h	
	jmp turnthenstart	
JmpeatGraphBlack:
	jmp eatGraphBlack
eatLeftBlack:
	mov ax, 3 
	int 33h 
	shr cx, 1
	cmp bx, 1 
	jne JmpeatGraphBlack
	mov ax, 2 
	int 33h
	inc [countEatenWhite]
	push 0 
	push [blackpossibley2]
	push [blackpossiblex2]
	call printSoldier
	push 7
	push [MoveY]
	push [MoveX]
	call printSoldier
	push 0 
	push [blackpossibley1]
	push [blackpossiblex1]
	call printSoldier
	add [blackpossiblex1], 25 
	sub [blackpossibley1], 25
	cmp [queenV], 1
	je queenie
	push 13
	push [blackpossibley1]
	push [blackpossiblex1]
	call printSoldier
queenie:	
	push 0 
	push [ypBlack] 
	push [xpBlack]
	call printSoldier
	sub [xpBlack], 25
	sub [ypBlack], 25
	push 0 
	push [ypBlack] 
	push [xpBlack]
	call printSoldier
	cmp [MoveY], 175
	je queenEat2
	mov ax, 1
	int 33h 
	mov [canEat], 0
	jmp turnthenstart
queenEat2:
	call putBlackQueen
	mov ax, 1
	int 33h 
	mov [canEat3], 0
	jmp turnthenstart			
notEatenBlack:
	mov ax, 3 
	int 33h 
	cmp bx, 1 
	je dontWantoeatBlack
	jmp eatGraphBlack
dontWantoeatBlack:	
	mov ax, 2 
	int 33h 
	;push 4
	;push [blackpossibley1]
	;push [blackpossiblex1]
	;call printSoldier
	push 0 
	push [ypBlack]
	push [xpBlack]
	call printSoldier
	add [xpBLack], 25
	add [ypBLack], 25
	push 7 
	push [ypBlack]
	push [xpBlack]
	call printSoldier
	push 0
	push [blackpossibley1]
	push [blackpossiblex1]
	call printSoldier
	add [blackpossiblex1], 25
	sub [blackpossibley1], 25
	cmp [queenV], 1 
	je itsqueen3
	push 13
	push [blackpossibley1]
	push [blackpossiblex1]
	call printSoldier
itsqueen3:	
	mov ax, 1 
	int 33h 
	jmp turnthenstart
	

	