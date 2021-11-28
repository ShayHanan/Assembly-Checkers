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
	cmp al, 255 
	je Jmpback
	cmp al, 3 
	je Jmpback
	cmp dx, 175 
	jae Jmpback
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
	;push 7 								;changes the color of the soldier that can be eaten
	;push [whitepossibley1]		
	;push [whitepossiblex1]
	;call printSoldier
	add [whitepossiblex1], 25 			;turns the x to the starting x that the soldier is starting from
	sub [whitepossibley1], 25			;turns the y to the starting y that the soldier is starting from
	mov cx, 1
eatLoop:	
	push 9
	push [whitepossibley1]
	push [whitepossiblex1]
	call printSoldier
	call delay 
	push 0
	push [whitepossibley1]
	push [whitepossiblex1]
	call printSoldier
	call delay
	push 9
	push [whitepossibley1]
	push [whitepossiblex1]	
	call printSoldier
	loop eatLoop
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
	cmp al, 13								;checks if there's a red soldier that prevents the player from moving to the left side
	je haveToEat 
	cmp al, 255 
	je haveToEat
	cmp al, 7 								;checks if there's a black soldier that can be eaten too
	je eat2
	cmp al, 3 
	je Inceat2
	cmp [whitepossiblex2], 200 
	ja haveToEat
	push 9 									;if not mark that place as a possible move
	push [whitepossibley2]
	push [whitepossiblex2]
	call printSoldier
haveToEat:	
	add [xp], 25 						;returns the x and y that was pressed t0 their original values
	add [yp], 25
	jmp eatGraph
JmptheresRed5:
	inc [redNotBlack]	;increases the variable that indicates that its a red soldier and not black(later it will draw a red soldier and not a black one)
	jmp eatGraph	
JmptheresRed:
	inc [canEat2]	;increases the variable that indicates that the player can eat.
	jmp eatGraph
Inceat2:
	inc [queenV]	;;increases the variable that indicates that the player can eat a queen.
eat2:	;if the player can also eat to the left side.
	sub [whitepossiblex2], 12 
	sub [whitepossibley2], 12
	mov cx, [whitepossiblex2]
	mov dx, [whitepossibley2]
	mov bh, 0 
	mov ah, 0dh
	int 10h 
	cmp al, 7 					;checks if there's a black soldier that prevents the player from eating
	je JmptheresRed
	cmp al, 3 
	je JmptheresRed
	cmp al, 13 					;checks if there's a red soldier that prevents the player from eating
	je JmptheresRed5
	cmp al, 255 
	je JmptheresRed5
	add [whitepossiblex2], 12 
	add [whitepossibley2], 12
	cmp [whitepossiblex2], 0 
	jbe JmptheresRed5
	cmp [whitepossiblex2], 200 
	jae haveToEat
	;push 7 
	;push [whitepossibley2]				;changes the color of the soldier that can be eaten
	;push [whitepossiblex2]
	;call printSoldier
	mov ax, [whitepossiblex2]	
	mov bx, [whitepossibley2]
	sub ax, 25 
	sub bx, 25
	mov [MoveX], ax 					;put inside this variable the x of where the player will be moved if he eats to the left
	mov [MoveY], bx				;put inside this variable the y of where the player will be moved if he eats to the left
	mov cx, 1 
eatLoop2:	
	push 9 
	push bx 
	push ax 
	call printSoldier
	call delay 
	push 0 
	push bx 
	push ax 
	call printSoldier
	call delay
	push 9 
	push bx 
	push ax 
	call printSoldier
	loop eatLoop2
	inc [canEat] ;increases the variable that indicates that the player can also eat to the left side.
eatGraph:	
	mov ax, 3
	int 33h
	shr cx, 1
	cmp bx, 1 
	jne eatGraph
	mov ax , 2 
	int 33h 
	mov bh, 0h
	mov ah, 0dh 
	int 10h
	cmp al, 9    ;checks if the mouse is on a possible move
	mov ax, 1 
	int 33h
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
	je eaten ;checks if the player want to eat or not.
	cmp [canEat], 1 
	je JmpeatLeft	;if the player doesnt want to eat to the right, it checks if he wants to eat to the left side.
	jmp notEaten	; if both conditions are false it jumps to this lable.(dont want to eat)
JmpeatLeft:
	jmp eatLeft
jmptheresred123:
	jmp theresRed	
eaten:
	mov ax, 3 
	int 33h 
	shr cx, 1
	mov ax, 2 
	int 33h
	inc [countEatenBlack] 
	push 13
	push [whitepossibley1]
	push [whitepossiblex1]
	call printSoldier		;draws a red soldier in the place he chose.
	sub [whitepossiblex1], 25 
	add [whitepossibley1], 25
	push 0
	push [whitepossibley1]
	push [whitepossiblex1]
	call printSoldier		;disappearing the soldier that was eaten.
	add [whitepossibley2], 12 
	add [whitepossiblex2], 12 
	mov cx, [whitepossiblex2]
	mov dx, [whitepossibley2]
	mov bh, 0 
	mov ah, 0dh 
	int 10h 
	cmp al, 13 
	je jmptheresred123
	sub [whitepossibley2], 12 
	sub [whitepossiblex2], 12
	sub [xp], 25 
	sub [yp], 25 
	mov ax, [xp] 
	mov bx, [yp]
	mov [whitepossiblex2], ax 
	mov [whitepossibley2], bx
	cmp [whitepossiblex2], 200 
	jae blackOutside		;checks if this place is out of the board, if it does, it skips the printing of the black circle.
	push 0
	push [whitepossibley2]
	push [whitepossiblex2]
	call printSoldier
blackOutside:	
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
	cmp [redNotBlack], 1 
	je addYXp
	add [whitepossiblex1], 25 
	sub [whitepossibley1], 25
	cmp [whitepossibley1], 0 
	je jmpTurnToQueen2
	mov ax, 1 
	int 33h	
	jmp turnthenstart
theresRed:
	push 0
	push [yp]
	push [xp]
	call printSoldier
	add [whitepossiblex1], 25 
	sub [whitepossibley1], 25
	cmp [whitepossibley1], 0 
	je jmpTurnToQueen2
	mov ax, 1
	int 33h	
	jmp turnthenstart
jmpTurnToQueen2:
	mov ax, [whitepossiblex1]
	mov bx, [whitepossibley1]
	mov [MoveX], ax 
	mov [MoveY], bx
	jmp turnToQueen	
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
	cmp [queenV], 1 
	je putaqueen
	jmp notqueen
putaqueen:
	push 0
	push [whitepossibley2]
	push [whitepossiblex2]
	call printSoldier
	push 7
	push [whitepossibley2]
	push [whitepossiblex2]
	call printQueenBlack
notqueen:	
	cmp [canEat2], 1 
	jne dontbringBack
	cmp [redNotBlack], 1 
	je printRed
	sub [xp], 50 
	sub [yp], 50
	push 7 
	push [yp] 
	push [xp] 
	call printSoldier
dontbringBack:
	add [whitepossiblex1], 25 
	sub [whitepossibley1], 25
	cmp [whitepossibley1], 0 
	je jmpTurnToQueen4
	mov ax, 1 
	int 33h	
	jmp turnthenstart	
jmpTurnToQueen4:
	mov ax, [whitepossiblex1]
	mov bx, [whitepossibley1]
	mov [MoveX], ax 
	mov [MoveY], bx
	jmp turnToQueen		
printRed:
	sub [xp], 50 
	sub [yp], 50
	push 13 
	push [yp] 
	push [xp] 
	call printSoldier
	add [whitepossiblex1], 25 
	sub [whitepossibley1], 25
	cmp [whitepossibley1], 0 
	je jmpTurnToQueen4
	mov ax, 1 
	int 33h	
	jmp turnthenstart	
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
	inc [countEatenBlack]
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
	;push 7
	;push [whitepossibley1]
	;push [whitepossiblex1]
	;call printSoldier
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
	mov [canEat], 0
	cmp [MoveY], 200 
	je jmpTurnToQueen3
	mov ax, 1
	int 33h 
	jmp turnthenstart
jmpTurnToQueen3:
	jmp turnToQueen
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
	cmp [queenV], 1 
	je itsqueen
	push 7
	push [whitepossibley1]
	push [whitepossiblex1]
	call printSoldier
itsqueen:
	mov ax, 1 
	int 33h 
	jmp turnthenstart