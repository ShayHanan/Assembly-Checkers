note equ [bp+4]
Clock  equ es:6Ch 
ErrorMsg db 'Error with opening the file ', 13, 10,'$'
filehandle dw ?
;=========== BMP Variables ==========
filename db 'open.bmp',0
fileName2 db 'menu.bmp', 0
fileName3 db 'board.bmp', 0
fileName4 db 'help.bmp', 0
fileName5 db 'helpp.bmp', 0
fileName6 db 'playp.bmp', 0
fileName7 db 'exitp.bmp', 0
fileName8 db 'exitf.bmp', 0 
fileName9 db 'exits.bmp', 0
fileName10 db 'goodbye.bmp', 0 ;goodbye
fileName11 db 'helppr.bmp', 0
fileName12 db 'whiteWin.bmp', 0 
fileName13 db 'winWhite.bmp', 0
fileName14 db 'cont.bmp', 0 
fileName15 db 'blackWin.bmp', 0 
fileName16 db 'winBlack.bmp', 0
Header db 54 dup (0)
Palette db 256*4 dup (0)
ScrLine db 320 dup (0)
spacepress equ 39h
delaytime dw 8000
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

player  db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
		db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
		db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
		db 0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0
		db 0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0
		db 0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0
		db 0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0
		db 0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0
		db 0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0
		db 0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0
		db 0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0
		db 0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0
		db 0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0
		db 0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0
		db 0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0
		db 0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0
		db 0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0
		db 0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0
		db 0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0
		db 0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0
		db 0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0
		db 0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0
		db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
		db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
		db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
queen 	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
		db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
		db 0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0
		db 0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0
		db 0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0
		db 0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0
		db 0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0
		db 0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0
		db 0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0
		db 0,0,0,1,1,1,2,1,1,1,1,1,2,1,1,1,1,1,2,1,1,1,0,0,0
		db 0,0,0,1,1,1,2,2,1,1,1,2,2,2,1,1,1,2,2,1,1,1,0,0,0
		db 0,0,0,1,1,1,2,2,2,1,2,2,2,2,2,1,2,2,2,1,1,1,0,0,0
		db 0,0,0,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,1,1,1,0,0,0
		db 0,0,0,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,1,1,1,0,0,0
		db 0,0,0,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,1,1,1,0,0,0
		db 0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0
		db 0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0
		db 0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0
		db 0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0
		db 0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0
		db 0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0
		db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
		db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
		db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
smalldier db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
		  db 0,0,0,0,1,1,1,1,1,1,1,0,0,0,0
		  db 0,0,0,1,1,1,1,1,1,1,1,1,0,0,0
		  db 0,0,1,1,1,1,1,1,1,1,1,1,1,0,0
		  db 0,1,1,1,1,1,1,1,1,1,1,1,1,1,0
		  db 0,1,1,1,1,1,1,1,1,1,1,1,1,1,0
		  db 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
		  db 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
		  db 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
		  db 0,1,1,1,1,1,1,1,1,1,1,1,1,1,0
		  db 0,1,1,1,1,1,1,1,1,1,1,1,1,1,0
		  db 0,0,1,1,1,1,1,1,1,1,1,1,1,0,0
		  db 0,0,0,1,1,1,1,1,1,1,1,1,0,0,0
		  db 0,0,0,0,1,1,1,1,1,1,1,0,0,0,0
		  db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
chas equ 8609
dhas equ 7670
ahas equ 5119
b equ 4831
midc equ 4560
fhas equ 3224
d equ 2031
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;		
xp dw ?
yp dw ?	
;;;;;;;;;;;;;;;;	
turn db 1		
MaxDigits 	EQU 10d			;Word is 0-65535 - 5 digits.		
VideoSeg	EQU 0A000h		;Video Segment for direct access.
VideoSiz	EQU 0FA00h		;320X200=FA00h pixels total on screen.
VideoLen	EQU 320d		;Pixel row Length.
FontSize	EQU 8			;Characters are 8X8 pixels in graphics mode.
BLACK		EQU 0			;Color of the background before correction.
wturn db 'red turn  '	;Spaces
bturn db 'black turn'
pixX dw ?						;Variables for printBXYC
pixY dw ?
pixL dw ?
pixC dw ?	
whitec equ 15
whiteTurn dw (offset wturn)
blackTurn dw (offset bturn)
zero db '0 '
one db '1 '
two db '2 '
three db '3 '
four db '4 '
five db '5 '
six db '6 '
seven db '7 '
eight db '8 '
nine db '9 '
ten db '10'
eleven db '11'
twelve db '12'
zerop dw (offset zero)
oneP dw (offset one)
twoP dw (offset two)
threeP dw (offset three)
fourP dw (offset four)
fiveP dw (offset five)
sixP dw (offset six)
sevenP dw (offset seven)
eightP dw (offset eight)
nineP dw (offset nine)
tenP dw (offset ten)
elevenP dw (offset eleven)
twelveP dw (offset twelve)
xpBlack dw 0
ypBlack dw 0
blackpossiblex1 dw 0
blackpossibley1 dw 0
whitepossiblex1 dw 0
whitepossibley1 dw 0
blackpossiblex2 dw 0
blackpossibley2 dw 0
whitepossiblex2 dw 0
whitepossibley2 dw 0
queenPressedX dw 0 
queenPressedY dw 0 
countpossibleblack dw 0 
countpossiblewhite dw 0
MoveY dw 0
MoveX dw 0
countPiecesCanEaten dw 0
canEat dw 0
canEat2 dw 0
canEat3 dw 0 
canEat4 dw 0
donthaveTo dw 0
itsBlack dw 0
donthaveTo2 dw 0
redNotBlack dw 0
outOfRange dw 0
queenV dw 0
countEatenBlack dw 0 
countEatenWhite dw 0 
spaceY dw 140 
spaceX dw 203
spaceYB dw 140 
spaceXB dw 260
already dw 0
already2 dw 0