eat:  
mov [canEat2], 0
mov [canEat], 0
	add cx, 25 
	sub dx, 25 
	mov bh, 0 
	mov ah, 0dh 
	int 10h 
	cmp al, 7					;checks if there's a black soldier after the black soldier that prevents the player from eating
	je Jmpback
	cmp al, 13 
	je Jmpback
	jmp dontback
Jmpback:
	jmp BackToPosition
dontback:	
	add [whitepossiblex1], 25 			;turns the possible move to the x that the soldier can move he eats
	cmp [whitepossiblex1], 200 			;checks if the x is out of range
	jae Jmpback2
	jmp beseder
Jmpback2:
	jmp back
beseder:	
	sub [whitepossiblex1], 25 			;returns to the original x 
	push 2 								;changes the color of the soldier that can be eaten
	push [whitepossibley1]		
	push [whitepossiblex1]
	call printSoldier
	add [whitepossiblex1], 25 			;turns the x to the starting x that the soldier is starting from
	sub [whitepossibley1], 25			;turns the y to the starting y that the soldier is starting from
	push 3
	push [whitepossibley1]
	push [whitepossiblex1]
	call printSoldier
	sub [xp], 25 		;turns the x that was pressed to the second x that the player can move to
	sub [yp], 25		;turns the y that was pressed to the second y that the player can move to
	mov ax, [xp]
	mov bx, [yp]
	mov [whitepossiblex2], ax				;turns the original possible x to the second possible x
	mov [whitepossibley2], bx				;turns the original possible y to the second possible y
	add ax, 12 
	add bx, 12
	mov cx, ax 
	mov dx, bx 
	mov bh, 0 
	mov ah, 0dh
	int 10h
	cmp al, 13								;checks if there's a red soldier that prevents the player from move to the left side
	je haveToEat 
	cmp al, 7 								;checks if there's a black soldier that can be eaten too
	je eat2
	push 3 									;if not mark that place as a possible move
	push [whitepossibley2]
	push [whitepossiblex2]
	call printSoldier
haveToEat:	
	add [xp], 25 						;returns the x and y that was pressed t0 their original values
	add [yp], 25
	jmp eatGraph
eat2:
	sub [whitepossiblex2], 12 
	sub [whitepossibley2], 12
	mov cx, [whitepossiblex2]
	mov dx, [whitepossibley2]
	mov bh, 0 
	mov ah, 0dh
	int 10h 
	cmp al, 7 					;checks if there's a black soldier that prevents the player from eating
	je JmptheresRed
	cmp al, 13 					;checks if there's a red soldier that prevents the player from eating
	je eatGraph
	add [whitepossiblex2], 12 
	add [whitepossibley2], 12
	push 2 
	push [whitepossibley2]				;changes the color of the soldier that can be eaten
	push [whitepossiblex2]
	call printSoldier
	mov ax, [whitepossiblex2]	
	mov bx, [whitepossibley2]
	sub ax, 25 
	sub bx, 25
	mov [MoveX], ax 					;put inside this variable the x of where the player will be moved if he eats to the left
	mov [MoveY], bx				;put inside this variable the y of where the player will be moved if he eats to the left
	push 3 
	push bx 
	push ax 
	call printSoldier
	inc [canEat]
	jmp eatGraph
JmptheresRed:
	inc [canEat2]
	jmp eatGraph
eatGraph:	
	mov ax, 3
	int 33h
	shr cx, 1
	mov bh, 0h
	mov ah, 0dh 
	int 10h
	cmp al, 3    ;checks if the mouse is on a possible move
	je YX
	jmp eatGraph
YX:
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
	cmp cx, [whitepossiblex1]
	je eaten
	cmp [canEat], 1 
	je JmpeatLeft
	jmp notEaten
JmpeatLeft:
	jmp eatLeft
eaten:
	mov ax, 3 
	int 33h 
	shr cx, 1
	cmp bx, 1 
	jne eatGraph
	mov ax, 2 
	int 33h
	push 13
	push [whitepossibley1]
	push [whitepossiblex1]
	call printSoldier
	sub [whitepossiblex1], 25 
	add [whitepossibley1], 25
	push 0
	push [whitepossibley1]
	push [whitepossiblex1]
	call printSoldier
	add [whitepossibley2], 12 
	add [whitepossiblex2], 12 
	mov cx, [whitepossiblex2]
	mov dx, [whitepossibley2]
	mov bh, 0 
	mov ah, 0dh 
	int 10h 
	cmp al, 13 
	je theresRed
	cmp al, 7 
	je theresRed
	sub [whitepossibley2], 12 
	sub [whitepossiblex2], 12
	sub [xp], 25 
	sub [yp], 25 
	mov ax, [xp] 
	mov bx, [yp]
	mov [whitepossiblex2], ax 
	mov [whitepossibley2], bx
	push 0 
	push [whitepossibley2]
	push [whitepossiblex2]
	call printSoldier
	add [xp], 25 
	add [yp], 25 
	push 0 
	push [yp] 
	push [xp] 
	call printSoldier
	cmp [canEat], 1 
	je addYXp
	cmp [canEat2], 1 
	je addYXp
	mov ax, 1 
	int 33h	
	jmp game
theresRed:
	push 0
	push [yp]
	push [xp]
	call printSoldier
	mov ax, 1
	int 33h 
	jmp game
addYXp:
	add [xp], 25 
	add [yp], 25 
	push 0
	push [yp] 
	push [xp] 
	call printSoldier
	add [whitepossiblex2], 25
	add [whitepossibley2], 25
	push 7
	push [whitepossibley2]
	push [whitepossiblex2]
	call printSoldier
	cmp [canEat2], 1 
	jne dontbringBack
	sub [xp], 25 
	sub [yp], 25 
	push 7 
	push [yp] 
	push [xp] 
	call printSoldier
	sub [xp], 25 
	sub [yp], 25 
	push 7 
	push [yp] 
	push [xp] 
	call printSoldier
dontbringBack:
	mov ax, 1 
	int 33h	
	jmp game	
JmpeatGraph:
	jmp eatGraph
eatLeft:
	mov ax, 3 
	int 33h 
	shr cx, 1
	cmp bx, 1 
	jne JmpeatGraph
	mov ax, 2 
	int 33h
	push 0 
	push [whitepossibley2]
	push [whitepossiblex2]
	call printSoldier
	push 13
	push [MoveY]
	push [MoveX]
	call printSoldier
	push 0 
	push [whitepossibley1]
	push [whitepossiblex1]
	call printSoldier
	sub [whitepossiblex1], 25 
	add [whitepossibley1], 25
	push 7
	push [whitepossibley1]
	push [whitepossiblex1]
	call printSoldier
	push 0 
	push [yp] 
	push [xp]
	call printSoldier
	add [xp], 25
	add [yp], 25
	push 0 
	push [yp] 
	push [xp]
	call printSoldier
	mov ax, 1
	int 33h 
	mov [canEat], 0
	jmp game
notEaten:
	mov ax, 3 
	int 33h 
	cmp bx, 1 
	je dontWantoeat
	jmp eatGraph
dontWantoeat:	
	mov ax, 2 
	int 33h 
	push 0
	push [whitepossibley1]
	push [whitepossiblex1]
	call printSoldier
	push 13 									
	push [whitepossibley2]
	push [whitepossiblex2]
	call printSoldier
	push 0 
	push [yp]
	push [xp]
	call printSoldier
	sub [whitepossiblex1], 25
	add [whitepossibley1], 25
	push 7
	push [whitepossibley1]
	push [whitepossiblex1]
	call printSoldier
	mov ax, 1 
	int 33h 
	jmp game