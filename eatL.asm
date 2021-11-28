eatL:
	mov [canEat3], 0
	mov [canEat4], 0
	sub cx, 25 
	sub dx, 25 
	mov bh, 0 
	mov ah, 0dh 
	int 10h 
	cmp al, 7					;checks if there's a black soldier after the black soldier that prevents the player from eating
	je Jchoose
	cmp al, 13 
	je Jchoose
	cmp al, 255 
	je Jchoose
	cmp al, 3 
	je Jchoose
	cmp cx, 200 
	ja Jchoose
	cmp dx, 175 
	jae Jchoose
	jmp dontback2
Jchoose: 
	jmp dontprint2
Jmpbac2:
	jmp back2
dontback2:
	sub [whitepossiblex1], 50 			;turns the possible move to the x that the soldier can move he eats
	cmp [whitepossiblex1], 200 			;checks if the x is out of range
	jae Jmpbac2 
	;push 7 								;changes the color of the soldier that can be eaten
	;push [whitepossibley1]		
	;push [whitepossiblex1]
	;call printSoldier
	sub [whitepossiblex1], 25 			;turns the x to the starting x that the soldier is starting from
	sub [whitepossibley1], 25			;turns the y to the starting y that the soldier is starting from
	mov cx, 1 
eatLoop5:
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
	loop eatLoop5
	add [xp], 25 		;turns the x that was pressed to the second x that the player can move to
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
	cmp al, 13								;checks if there's a red soldier that prevents the player from move to the right side
	je haveToEat2 
	cmp al, 255								;checks if there's a red queen that prevents the player from move to the right side
	je haveToEat2 
	cmp al, 7 								;checks if there's a black soldier that can be eaten too
	je eat3
	cmp al, 3 
	je eat3
	push 9 									;if not mark that place as a possible move
	push [whitepossibley2]
	push [whitepossiblex2]
	call printSoldier
haveToEat2:
	sub [xp], 25 						;returns the x and y that was pressed t0 their original values
	add [yp], 25
	jmp eatGraph2
JmptheresRed2:
	inc [canEat4]
	jmp eatGraph2	
eat3:
	cmp [whitepossiblex2], 175 
	jae haveToEat2	
	add [whitepossiblex2], 12 
	add [whitepossibley2], 12
	mov cx, [whitepossiblex2]
	mov dx, [whitepossibley2]
	mov bh, 0 
	mov ah, 0dh
	int 10h 
	cmp al, 7 					;checks if there's a black soldier that prevents the player from eating
	je JmphaveToEat3
	cmp al, 13 					;checks if there's a red soldier that prevents the player from eating
	je eatGraph2
	sub [whitepossiblex2], 12 
	sub [whitepossibley2], 12
	;push 7 
	;push [whitepossibley2]				;changes the color of the soldier that can be eaten
	;push [whitepossiblex2]
	;call printSoldier
	mov ax, [whitepossiblex2]	
	mov bx, [whitepossibley2]
	add ax, 25 
	add bx, 25
	cmp bx, 200
	jae JmphaveToEat3
	mov [MoveX], ax 					;put inside this variable the x of where the player will be moved if he eats to the left
	mov [MoveY], bx				;put inside this variable the y of where the player will be moved if he eats to the left
	mov cx, 1 
eatLoop6:	
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
	loop eatLoop6 
	inc [canEat3]
	jmp eatGraph2
JmphaveToEat3:
	inc [itsBlack]
	jmp haveToEat2
eatGraph2:	
	mov ax, 3
	int 33h
	shr cx, 1
	cmp bx, 1 
	jne eatGraph2
	mov ax, 2 
	int 33h 
	mov bh, 0h
	mov ah, 0dh 
	int 10h
	cmp al, 9    ;checks if the mouse is on a possible move
	mov ax, 1 
	int 33h 
	je YX2
	jmp eatGraph2
YX2:
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
	je eaten2
	cmp [canEat2], 1 
	je JmpeatRight
	jmp notEaten2
JmpeatRight:
	jmp eatRight
JmptheresRed3:
	jmp theresRed2
eaten2:
	mov ax, 3 
	int 33h 
	shr cx, 1
	mov ax, 2 
	int 33h
	inc [countEatenBlack]
	push 13
	push [whitepossibley1]
	push [whitepossiblex1]
	call printSoldier
	add [whitepossiblex1], 25 
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
	je JmptheresRed3
	cmp al, 255 
	je JmptheresRed3
	mov bh, 0 
	mov ah, 0dh 
	int 10h 
	cmp al, 7 
	je JmptheresRed3
	cmp al, 3 
	je JmptheresRed3	
	sub [whitepossibley2], 12 
	sub [whitepossiblex2], 12 
	mov ax, [xp] 
	mov bx, [yp]
	mov [whitepossiblex2], ax 
	mov [whitepossibley2], bx
	add [whitepossiblex2], 25 
	sub [whitepossibley2], 25
	cmp [whitepossiblex2], 200	
	jae blackOutside2
	push 0 
	push [whitepossibley2]
	push [whitepossiblex2]
	call printSoldier
blackOutside2:	 
	push 0 
	push [yp] 
	push [xp] 
	call printSoldier
	cmp [canEat3], 1 
	je jumpAddYX
	cmp [canEat4], 1 
	je jumpAddYX
	cmp [itsBlack], 1 
	jne dontb
	push 7 
	push [whitepossibley2]
	push [whitepossiblex2]
	call printSoldier
	sub [whitepossiblex1], 25 
	sub [whitepossibley1], 25
	cmp [whitepossibley1], 0 
	je jumpTurnToQueen
dontb:
	sub [whitepossiblex1], 25 
	sub [whitepossibley1], 25
	cmp [whitepossibley1], 0 
	je jumpTurnToQueen
	mov ax, 1 
	int 33h	
	jmp turnthenstart
jumpAddYX:
	jmp addYXp2
JmphaveToEat2:
	jmp haveToEat2
theresRed2: 
	push 0
	push [yp]
	push [xp]
	call printSoldier
	sub [whitepossiblex1], 25 
	sub [whitepossibley1], 25
	cmp [whitepossibley1], 0 
	je jumpTurnToQueen
	mov ax, 1
	int 33h 
	jmp turnthenstart
jumpTurnToQueen:
	mov ax, [whitepossiblex1]
	mov bx, [whitepossibley1]
	mov [MoveX], ax 
	mov [MoveY], bx
	jmp turnToQueen		
addYXp2:
	sub [xp], 50  
	push 0
	push [yp] 
	push [xp] 
	call printSoldier
	sub [whitepossiblex2], 50
	push 13
	push [whitepossibley2]
	push [whitepossiblex2]
	call printSoldier
	cmp [canEat4], 1 
	jne dontbringBack2
	add [xp], 25 
	add [yp], 25 
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
dontbringBack2:
	sub [whitepossiblex1], 25 
	sub [whitepossibley1], 25
	cmp [whitepossibley1], 0 
	je jumpTurnToQueen4
	mov ax, 1 
	int 33h	
	jmp turnthenstart	
jumpTurnToQueen4:
	mov ax, [whitepossiblex2]
	mov bx, [whitepossibley2]
	mov [MoveX], ax 
	mov [MoveY], bx
	jmp turnToQueen	
JmpeatGraph2:
	jmp eatGraph2
eatRight:
	mov ax, 3 
	int 33h 
	shr cx, 1
	cmp bx, 1 
	jne JmpeatGraph2
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
	inc [countEatenBlack]
	cmp [MoveY], 0 
	je jumpTurnToQueen2
	mov ax, 1
	int 33h 
	mov [canEat2], 0
	jmp turnthenstart
jumpTurnToQueen2:
	jmp turnToQueen
notEaten2:
	mov ax, 3 
	int 33h 
	cmp bx, 1 
	je dontWantoeat2
	jmp eatGraph2
dontWantoeat2:	
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
	add [whitepossiblex1], 25
	add [whitepossibley1], 25
	cmp [queenV], 1 
	je itsqueen2
	push 7
	push [whitepossibley1]
	push [whitepossiblex1]
	call printSoldier
itsqueen2:
	mov ax, 1 
	int 33h 
	jmp turnthenstart	
