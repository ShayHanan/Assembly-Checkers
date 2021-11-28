BlackEatR:
	mov [canEat3], 0
	mov [canEat4], 0
	add cx, 25 
	add dx, 25 
	mov bh, 0 
	mov ah, 0dh 
	int 10h 
	cmp al, 7					;checks if there's a black soldier after the black soldier that prevents the player from eating
	je Jchoose2
	cmp al, 13 
	je Jchoose2
	cmp al, 255 
	je Jchoose2
	cmp al, 3 
	je Jchoose2
	cmp cx, 200 
	ja Jchoose2
	jmp dontback3
Jchoose2: 
	jmp dontprint4
Jmpbac3:
	jmp back3
Jmpdontprint4:
	jmp dontprint4	
dontback3:
	add [blackpossiblex1], 50 			;turns the possible move to the x that the soldier can move he eats
	;push 13 								;changes the color of the soldier that can be eaten
	;push [blackpossibley1]		
	;push [blackpossiblex1]
	;call printSoldier
	add [blackpossiblex1], 25 			;turns the x to the starting x that the soldier is starting from
	add [blackpossibley1], 25			;turns the y to the starting y that the soldier is starting from
	cmp [blackpossibley1], 175 
	ja Jmpdontprint4
	cmp [blackpossiblex1], 200 			;checks if the x is out of range
	jae Jmpbac3
	mov cx, 1 
eatLoop7:	
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
	loop eatLoop7
	sub [xpBlack], 25 		;turns the x that was pressed to the second x that the player can move to
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
	je jmphaveToEatBlack2WithCondition 
	cmp al, 3
	je jmphaveToEatBlack2WithCondition
	cmp al, 13 								;checks if there's a red soldier that can be eaten too
	je eat4	
	cmp [blackpossiblex2], 200 
	jae haveToEatBlack2INC
	cmp al, 255 								;checks if there's a red soldier that can be eaten too
	je eat4
	push 248 									;if not mark that place as a possible move
	push [blackpossibley2]
	push [blackpossiblex2]
	call printSoldier
	jmp haveToEatBlack2
haveToEatBlack2INC:
	inc [outOfRange]
haveToEatBlack2:
	add [xpBlack], 25 						;returns the x and y that was pressed to their original values
	sub [ypBlack], 25
	jmp eatGraph4
JmphaveToEatBlack2WithCondition:
	inc [redNotBlack]
	jmp haveToEatBlack2
eat4:
	sub [blackpossiblex2], 12 
	add [blackpossibley2], 37
	mov cx, [blackpossiblex2]
	mov dx, [blackpossibley2]
	mov bh, 0 
	mov ah, 0dh
	int 10h 
	cmp al, 13 					;checks if there's a red soldier that prevents the player from eating
	je JmphaveToEatBlack3
	cmp al, 7 					;checks if there's a black soldier that prevents the player from eating
	je JmpeatGraph4
	add [blackpossiblex2], 12 
	sub [blackpossibley2], 37
	push 13 
	push [blackpossibley2]				;changes the color of the soldier that can be eaten
	push [blackpossiblex2]
	call printSoldier
	mov ax, [blackpossiblex2]	
	mov bx, [blackpossibley2]
	sub ax, 25 
	sub bx, 25
	mov [MoveX], ax 					;put inside this variable the x of where the player will be moved if he eats to the left
	mov [MoveY], bx				;put inside this variable the y of where the player will be moved if he eats to the left
	cmp [MoveX], 200 
	jae JmphaveToEatBlack3
	mov cx, 1 
eatLoop8:	
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
	loop eatLoop8
	inc [canEat3]
JmpEatGraph4:	
	jmp eatGraph4
JmphaveToEatBlack3:
	inc [itsBlack]
	add [xpBlack], 25 						;returns the x and y that was pressed t0 their original values
	sub [ypBlack], 25
	jmp eatGraph4
eatGraph4:	
	mov ax, 3
	int 33h
	shr cx, 1
	cmp bx, 1 
	jne eatGraph4
	mov ax, 2 
	int 33h 
	mov bh, 0h
	mov ah, 0dh 
	int 10h
	cmp al, 248    ;checks if the mouse is on a possible move
	mov ax, 1 
	int 33h
	je YXBlack2
	jmp eatGraph4
YXBlack2:
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
	je eatenBlack2
	cmp [canEat3], 1 
	je JmpeatRightBlack
	jmp notEatenBlack2
JmpeatRightBlack:
	jmp eatRightBlack	
JmptheresBlack3:
	jmp theresBlack2
eatenBlack2:
	mov ax, 3 
	int 33h 
	shr cx, 1
	mov ax, 2 
	int 33h
	inc [countEatenwhite]
	push 7
	push [blackpossibley1]
	push [blackpossiblex1]
	call printSoldier
	mov ax, [blackpossiblex1]
	mov bx, [blackpossibley1]
	mov [MoveX], ax 
	mov [MoveY], bx 
	sub [blackpossiblex1], 25 
	sub [blackpossibley1], 25
	push 0
	push [blackpossibley1]
	push [blackpossiblex1]
	call printSoldier
	add [blackpossibley2], 12 
	add [blackpossiblex2], 12 
	mov cx, [blackpossiblex2]
	mov dx, [blackpossibley2]
	mov bh, 0 
	mov ah, 0dh 
	int 10h 
	cmp al, 7 
	je JmptheresBlack3
	sub [blackpossibley2], 12 
	sub [blackpossiblex2], 12 
	mov ax, [xpBlack] 
	mov bx, [ypBlack]
	mov [blackpossiblex2], ax 
	mov [blackpossibley2], bx
	sub [blackpossiblex2], 25 
	add [blackpossibley2], 25
	cmp [blackpossiblex2], 200	
	jae blackOutside4
	push 0
	push [blackpossibley2]
	push [blackpossiblex2]
	call printSoldier
blackOutside4:
	push 0 
	push [ypBlack] 
	push [xpBlack] 
	call printSoldier
	cmp [canEat3], 1 
	je JMPaddYXpBlack2
	cmp [canEat4], 1 
	je JMPaddYXpBlack2
	cmp [itsBlack], 1 
	je dontbBlack
	cmp [redNotBlack], 0 
	jne dontblacktheblack
	cmp [outOfRange], 1 
	je hi
	push 0
	push [blackpossibley2]
	push [blackpossiblex2]
	call printSoldier
hi:	
	cmp [MoveY], 175 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	je queenEat
	mov ax, 1 
	int 33h	
	jmp turnthenstart
queenEat:
	call putBlackQueen
	mov ax, 1
	int 33h 
	mov [canEat3], 0
	jmp turnthenstart		
JMPaddYXpBlack2:
	jmp addYXpBlack2
dontblacktheblack:	
	mov ax, [blackpossiblex2]
	mov bx, [blackpossibley2]
	mov [MoveX], ax 
	mov [MoveY], bx
	call putBlackQueen
	mov ax, 1 
	int 33h	
	jmp turnthenstart
dontbBlack:
	push 13 
	push [blackpossibley2]
	push [blackpossiblex2]
	call printSoldier
	cmp [MoveY], 175 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	je queenEat
	mov ax, 1 
	int 33h	
	jmp turnthenstart
JmphaveToEatBlack2:
	jmp haveToEatBlack2
theresBlack2: 
	push 0
	push [ypBlack]
	push [xpBlack]
	call printSoldier
	mov ax, 1
	int 33h 
	jmp turnthenstart
addYXpBlack2:
	add [xpBlack], 50  
	push 0
	push [ypBlack] 
	push [xpBlack] 
	call printSoldier
	sub [blackpossiblex2], 50
	push 7
	push [blackpossibley2]
	push [blackpossiblex2]
	call printSoldier
	cmp [canEat4], 1 
	jne dontbringBackBlack2
	sub [xpBlack], 25 
	sub [ypBlack], 25 
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
dontbringBackBlack2:
	mov ax, 1 
	int 33h	
	jmp turnthenstart	
JmpeatGraph5:
	jmp eatGraph4
eatRightBlack:
	mov ax, 3 
	int 33h 
	shr cx, 1
	cmp bx, 1 
	jne JmpeatGraph5
	mov ax, 2 
	int 33h
	inc [countEatenwhite]
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
	push 13
	push [blackpossibley1]
	push [blackpossiblex1]
	call printSoldier
	push 0 
	push [ypBlack] 
	push [xpBlack]
	call printSoldier
	add [xpBlack], 25
	add [ypBlack], 25
	push 0 
	push [ypBlack] 
	push [xpBlack]
	call printSoldier
	mov ax, 1
	int 33h 
	mov [canEat3], 0
	jmp turnthenstart	
notEatenBlack2:
	mov ax, 3 
	int 33h 
	cmp bx, 1 
	je dontWantoeatBlack2
	jmp eatGraph4
dontWantoeatBlack2:	
	mov ax, 2 
	int 33h 
	push 0
	push [blackpossibley1]
	push [blackpossiblex1]
	call printSoldier
	push 7 									
	push [blackpossibley2]
	push [blackpossiblex2]
	call printSoldier
	push 0 
	push [ypBlack]
	push [xpBlack]
	call printSoldier
	sub [blackpossiblex1], 25
	sub [blackpossibley1], 25
	push 13
	push [blackpossibley1]
	push [blackpossiblex1]
	call printSoldier
	mov ax, 1 
	int 33h 
	jmp turnthenstart	
