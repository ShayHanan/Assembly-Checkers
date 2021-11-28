turnthenstart:
	call turnmsg
	call countMsg
	call countMsgBlack
	mov ax, 1 
	int 33h
game:
	cmp [countEatenWhite], 12 
	je JmpBlackWin
	cmp [countEatenBlack], 12 
	je JmpWhiteWin
	mov [countpossibleblack], 0  
	mov [countpossiblewhite], 0  
	mov [countpossibleblack], 0
	mov [countPiecesCanEaten], 0
	mov [itsBlack], 0
	mov [donthaveTo], 0
	mov [donthaveTo2], 0
	mov [canEat2], 0 
	mov [canEat], 0
	mov [redNotBlack], 0
	mov [outOfRange], 0
	mov [queenV], 0
	mov ax, 3
	int 33h
	shr cx, 1
	cmp cx, 200
	jae MidcheckAbove25
	jmp whichSoldier
JmpBlackWin:
	jmp BlackWin
JmpWhiteWin:
	jmp whiteWin
MidcheckAbove25:
	cmp dx, 25
	jb MidWannaReturn
	jmp whichSoldier
MidwannaReturn:
	cmp bx, 1
	jne game
	jmp menu
whichSoldier:
	cmp bx, 1 
	jne JmpGame
	mov ax, 2 
	int 33h
	cmp [turn], 1			;chceks turn (1 is white 0 is black)
	jne blacks
	mov ah, 0dh
	int 10h
	cmp al, 13				;checks if the solider that was pressed is white if not it doesn't do anything
	mov ax, 1 
	int 33h
	jne JmpGame4
decX:
	xor ah, ah
	mov ax, cx
	mov bl, 25
	div bl
	sub cl, ah 					;the x in which it starts to print the soldier											
decY:	
	xor ah, ah
	mov ax, dx
	mov bl, 25
	div bl		
	sub dl, ah					;the y in which it starts to print the soldier
changeColor:
	mov ax, 2
	int 33h
	dec [turn]					;switch to black turn	
	add dx, 12 
	add cx, 12 
	mov ah, 0dh
	int 10h
	cmp al, 255 
	je jmpQueen
	;push 15	
	;push dx
	;push cx 
	;call printSoldier			;changes the color of the soldier
	sub dx, 12 
	sub cx, 12 
	mov ax, 1 
	int 33h
	jmp possibleMoves
jmpQueen:
	jmp QueenR
JmpGame:
	mov ax, 1 
	int 33h
	jmp game	
JmpGame4:
	jmp game
blacks:
	mov ah, 0dh
	int 10h
	cmp al, 7							;checks if the mouse is on a black player
	mov ax, 1 
	int 33h
	jne JmpGame		
	cmp bx, 1
	jne JmpGame							;check if it was pressed
	xor ah, ah
	mov ax, cx
	mov bl, 25
	div bl						
	sub cl, ah 					;set the x in which it stars to print the soldier														
	xor ah, ah
	mov ax, dx
	mov bl, 25
	div bl		
	sub dl, ah				;set the y in which it stars to print the soldier
changeColorOfBlack:
	mov ax, 2
	int 33h	
	;push 255	
	;push dx					;changes the color of the soldier that was pressed
	;push cx 
	;call printSoldier
	inc [turn]			;changes the turn to white's turn but still the black needs to finish his turn in order for the to do his 
	add dx, 12 
	add cx, 12 
	mov ah, 0dh
	int 10h
	cmp al, 3 
	je JmpBlackQueen
	sub dx, 12 
	sub cx, 12 
	mov ax, 1 
	int 33h	
	jmp blackPossibleMoves
JmpBlackQueen:
	jmp BlackQueen
possibleMoves:
	mov [xp], cx
	mov [yp], dx
	add cx, 25
	sub dx, 25
	mov [whitepossiblex1], cx
	mov [whitepossibley1], dx
	cmp cx, 200						;checks if the move is out of range
	jae Jmpdontprint	
	cmp cx, 0						;checks if the move is out of range
	jb Jmpdontprint
	add cx, 12 
	add dx, 12
	mov bh, 0
	mov ah, 0dh
	int 10h
	cmp al, 13						;checks if there's a soldier in the way
	je incYX
	cmp al, 255 
	je incYX
	mov bh, 0 
	mov ah, 0dh
	int 10h
	cmp al, 7                      ;checks if theres a soldier that can be eaten
	je Jmpeat
	cmp al, 3 ;black queen
	je JmpeatINC
	sub cx, 12 
	sub dx, 12
	push 9
	push dx
	push cx
	call printSoldier
	inc [countpossiblewhite]
Jmpdontprint:	
	jmp dontPrint	
incYX:						;returns cx and dx to it's original value after they was added 12
	sub cx, 12
	sub dx, 12
	jmp dontPrint
JmpeatINC:
	inc [queenV]
Jmpeat: 	
	jmp eat
JmpeatINC2:
	inc [queenV]
JmpeatL:
	jmp eatL
back:
	sub [whitepossiblex1], 25
BackToPosition:
	sub cx, 37 
	add dx, 13
	mov [whitepossiblex1], cx
	inc [countPiecesCanEaten]
dontPrint:
	mov cx, [whitepossiblex1]			
	sub cx, 50						;checks if the x is out of range
	cmp cx, 200
	jae dontPrint2
	cmp cx, 0									;checks if the x is out of range
	jb dontPrint2
	add cx, 12
	add dx, 12
	mov bh, 0
	mov ah, 0dh
	int 10h
	cmp al, 13						;checks if theres a red soldier in this place
	je dontPrint2
	cmp al, 255 
	je dontPrint2
	cmp al, 7						;checks if theres a black soldier in this place
	je JmpeatL
	cmp al, 3 ;queen
	je	JmpeatINC2
	sub dx, 12 
	sub cx, 12
	mov [whitepossiblex2], cx
	mov [whitepossibley2], dx
	push 9
	push dx
	push cx 
	call printSoldier
	inc [countpossiblewhite]
dontPrint2:
	cmp [countpossiblewhite], 0			;checks if the player can move
	jne choose	
	jmp needToPickAnother
Jmpchoose:
	jmp choose
choose:	
	mov ax, 3
	int 33h
	cmp bx, 1 
	jne choose
	shr cx, 1
	mov ax, 2 
	int 33h	
	mov bh, 0h
	mov ah, 0dh 
	int 10h
	cmp al, 9 				;checks if the player pressed on a possible move
	mov ax, 1 
	int 33h
	je setYX
	jmp choose
back2:
	add [whitepossiblex2], 25
	jmp choose 
setYX:						;set the y and the x to where the soldier is printed from
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
	cmp cx, [whitepossiblex1]				;checks if the player wanted to move right or left
	je moveRight
	jmp moveLeft
moveRight:
	mov [MoveX], cx 				;put the x that was pressed in a variable
	mov [MoveY], dx 			;put the y that was pressed in a varriable
	mov ax, 3 
	int 33h 
	shr cx, 1					
	mov ax, 2 
	int 33h
	push 13
	push [MoveY]				;print a white soldier where the player pressed
	push [MoveX]
	call printSoldier
	push 0 						;turns the previous position to black
	push [yp]
	push [xp]
	call printSoldier
	cmp [countpossiblewhite], 1
	je JmpGame3
	push 0 						;turns the second possible move to black
	push [whitepossibley2]
	push [whitepossiblex2]
	call printSoldier
JmpGame3:	
	cmp [MoveY], 0 
	je jmpTurnToQueen
	mov ax, 1
	int 33h
	jmp turnthenstart
jmpTurnToQueen:
	jmp turnToQueen
moveLeft:
	mov [MoveX], cx 				;put the x that was pressed on a variable 
	mov [MoveY], dx 			;put the y that was pressed in a variable
	mov ax, 3 
	int 33h 
	shr cx, 1
	cmp bx, 1 
	je press 
	jmp choose 
press:	
	mov ax, 2 
	int 33h
	push 13
	push [MoveY]			;print a white soldier where the player pressed
	push [MoveX]
	call printSoldier
	push 0 					;turns the previous position to black
	push [yp]
	push [xp]
	call printSoldier
	cmp [whitepossiblex1], 200		;checks if the place is out of range
	jae outaRange
	cmp [countpossiblewhite], 1
	je JmpGame3
	push 0 				;turns the second possible move to black
	push [whitepossibley1]		
	push [whitepossiblex1]
	call printSoldier
outaRange:				;a label which pervents the program from draw a black soldier in case it is out of range
	cmp [MoveY], 0 
	je jmpTurnToQueen
	mov ax, 1 
	int 33h
dontErase:				
	cmp [countPiecesCanEaten], 0		;checks if there's no soldier that can be eaten and if there isn't it draws back the black soldier that was erased before
	jne erase2
	jmp turnthenstart
erase2:
	push 7								;draws the black soldier again
	push [whitepossibley1]
	push [whitepossiblex1]
	call printSoldier
	mov [countPiecesCanEaten], 0		;move zero to the variable
	jmp turnthenstart
exitGame2:
	jmp exit
needToPickAnother:
	mov ax, 2 
	int 33h
	push 13 					;draws the white player back 
	push [yp]
	push [xp]
	call printSoldier
	mov ax, 1 
	int 33h
	inc [turn]					;keeps the white turn
	jmp whichSoldier
blackPossibleMoves:
	mov [xpBlack], cx 			;puts the x that was pressed in a variable	
	mov [ypBlack], dx			;puts the y that was pressed in a variable
	sub cx, 25
	add dx, 25
	mov [blackpossiblex1], cx             ;;put the possible x in a variable (lefft)	
	mov [blackpossibley1], dx	;put the possible y in a variable	(left)
	cmp cx, 200					;checks if the place that the player can move is out of range
	jae dontPrint3
	cmp cx, 0					;checks if the place that the player can move is out of range
	jb dontPrint3
	add cx, 12 				
	add dx, 12
	mov bh, 0
	mov ah, 0dh
	int 10h
	cmp al, 13 		;checks if there's a soldier that can be eaten
	je JmpBlackEat
	cmp al, 255 
	je JmpBlackEatINC
	cmp al, 7
	je incYX2
	cmp al, 3 
	je incYX2
	sub cx, 12 
	sub dx, 12					;returns x and y values
	push 248					
	push dx
	push cx
	call printSoldier
	inc [countpossibleblack]		;increases the number of move that can be made
	jmp dontPrint3
JmpBlackEatINC:
	inc [queenV]
JmpBlackEat:
	jmp BlackEatL
incYX2:	
	sub cx, 12
	sub dx, 12
	jmp dontPrint3
backBlack:
	add [blackpossiblex1], 25 
backToBlackPosition:
	add cx, 25 
	sub dx, 25
	sub cx, 12 
	sub dx, 12
	mov [blackpossiblex1], cx
	inc [countPiecesCanEaten]
dontPrint3:
	add cx, 50					;turn cx to the value in which the second possible x is
	cmp cx, 200					;checks if the x is out of range	
	jae dontPrint4
	cmp cx, 0
	jb dontPrint4	
	add cx, 12 
	add dx, 12
	mov bh, 0
	mov ah, 0dh
	int 10h
	cmp al, 7					;checks if theres a black soldier in the way
	je dontPrint4
	cmp al, 3 
	je dontPrint4
	cmp al, 13 
	je JmpBlackEatR						;checks if theres a white soldier that can be eaten	
	cmp al, 255 
	je JmpBlackEatRInc2
	sub cx, 12 
	sub dx, 12
	mov [blackpossiblex2], cx		;mov the x of the second possible move into a variable (right)
	mov [blackpossibley2], dx		;mov the y of the second possible move into a variable (right)
	push 248							
	push dx
	push cx 
	call printSoldier
	inc [countpossibleblack]		;increases the number of move that can be made
dontPrint4:	
	cmp [countpossibleblack], 0				;checks if theres no possible move and if it does, the player needs to choose another soldier
	jne chooseBlack
	jmp needToPickAnotherBlack
JmpBlackEatRInc2:
	inc [queenV]
JmpBlackEatR:
	jmp BlackEatR
chooseBlack:
	mov ax, 3
	int 33h
	shr cx, 1
	cmp bx, 1 
	jne chooseBlack
	mov ax, 2 
	int 33h 
	mov bh, 0h
	mov ah, 0dh 	
	int 10h
	cmp al, 248 						;checks if the mouse is on a possible move
	mov ax, 1 
	int 33h
	je setYXBlack
	jmp chooseBlack
back3:
	sub [whitepossiblex2], 25
	jmp chooseBlack 
setYXBlack:					;sets the y and x to where the soldier is printed
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
	cmp cx, [blackpossiblex1]		;checks if the player wanted to move left or right (left is the right from the black angel)
	je moveRightBlack
	jmp moveLeftBlack
moveRightBlack:
	mov [MoveX], cx 			;move the x that was pressed to a variable
	mov [MoveY], dx 			;move the x that was pressed to a variable
	mov ax, 3 
	int 33h 
	shr cx, 1
	mov ax, 2 
	int 33h
	push 7				;put a black soldier where the player pressed
	push [MoveY]
	push [MoveX]
	call printSoldier
	push 0 			;erase the previous position
	push [ypBlack]
	push [xpBlack]
	call printSoldier
	cmp [countpossibleblack], 1
	je JmpGame2
	push 0
	push [blackpossibley2]		;erase the second possible move 
	push [blackpossiblex2]
	call printSoldier
JmpGame2:	
	cmp [moveY], 175 
	je JmpturnToBlackQueen
	mov ax, 1 
	int 33h
	jmp turnthenstart
JmpturnToBlackQueen:
	jmp turnToBlackQueen
moveLeftBlack:
	mov [MoveX], cx 
	mov [MoveY], dx 
	mov ax, 3 
	int 33h 
	shr cx, 1
	cmp bx, 1 
	je pressBlack 
	jmp chooseBlack 
pressBlack:	
	mov ax, 2 
	int 33h
	push 7
	push [MoveY]
	push [MoveX]
	call printSoldier
	push 0 
	push [ypBlack]
	push [xpBlack]
	call printSoldier
	cmp [countpossibleblack], 1
	je JmpGame2
	push 0 
	push [blackpossibley1]
	push [blackpossiblex1]
	call printSoldier
	cmp [MoveY], 175 
	je turnToBlackQueen
	mov ax, 1 
	int 33h
	jmp turnthenstart	
needToPickAnotherBlack:					;if theres no possible moves that the player can do.
	mov ax, 2 
	int 33h
	push 7 
	push [ypBlack]
	push [xpBlack]
	call printSoldier
	mov ax, 1 
	int 33h
	dec [turn]
	jmp blacks
turnToBlackQueen:					
	call PutBlackQueen
	mov ax, 1 
	int 33h
	jmp turnthenstart
turnToQueen:
	call PutQueen
	mov ax, 1 
	int 33h
	jmp turnthenstart
BlackWin:
	push offset fileName15
	call pic
	call delay
	push offset fileName16
	call pic
	call delay
	push offset fileName15
	call pic
	call delay
	push offset fileName16
	call pic
	call delay
	push offset fileName15 
	call pic
	call delay
	push offset fileName16
	call pic
	call delay
	push offset fileName15
	call pic
	call delay
	push offset fileName16
	call pic
	call delay
	push offset fileName15
	call pic
	call delay
	push offset fileName16
	call pic
	call delay
	push offset fileName15 
	call pic
	call delay
	push offset fileName16
	call pic
	call delay
	push offset fileName14
	call pic
	mov ah, 0h 
    int 16h 
	jmp exit
	jmp exit 
whiteWin:
	push offset fileName12 
	call pic
	call delay
	push offset fileName13
	call pic
	call delay
	push offset fileName12 
	call pic
	call delay
	push offset fileName13
	call pic
	call delay
	push offset fileName12 
	call pic
	call delay
	push offset fileName13
	call pic
	call delay
	push offset fileName12 
	call pic
	call delay
	push offset fileName13
	call pic
	call delay
	push offset fileName12 
	call pic
	call delay
	push offset fileName13
	call pic
	call delay
	push offset fileName12 
	call pic
	call delay
	push offset fileName13
	call pic
	call delay
	push offset fileName14
	call pic
	mov ah, 0h 
    int 16h 
	jmp exit