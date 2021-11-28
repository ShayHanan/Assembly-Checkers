macro PrintBmpPicture FILE_NAME
	
	push offset FILE_NAME
	call OpenFile
	call ReadHeader
	call ReadPalette
	call CopyPal
	call CopyBitmap
	
endm
;============ Bmp Proc ========
OpenFileName equ [bp + 4]
proc OpenFile
	; Open file
	push bp
	mov bp, sp
	mov ah, 3Dh
	xor al, al
	mov dx, OpenFileName
	int 21h
	jc openerror
	mov [filehandle], ax 
	pop bp
	ret 2
	openerror:
	mov dx, offset ErrorMsg
	mov ah, 9h
	int 21h
	pop bp
	ret 2
endp OpenFile
;--------------------------------------
proc ReadHeader
	; Read BMP file header, 54 bytes
	mov ah,3fh
	mov bx, [filehandle]
	mov cx,54
	mov dx,offset Header
	int 21h
	ret
endp ReadHeader
;--------------------------------------
proc ReadPalette
	; Read BMP file color palette, 256 colors * 4 bytes (400h)
	mov ah,3fh
	mov cx,400h
	mov dx,offset Palette
	int 21h
	ret
endp ReadPalette 
;--------------------------------------
proc CopyPal
	; Copy the colors palette to the video memory
	; The number of the first color should be sent to port 3C8h
	; The palette is sent to port 3C9h
	mov si,offset Palette
	mov cx,256
	mov dx,3C8h
	mov al,0
	; Copy starting color to port 3C8h
	out dx,al
	; Copy palette itself to port 3C9h
	inc dx
	PalLoop:
	; Note: Colors in a BMP file are saved as BGR values rather than RGB.
	mov al,[si+2] ; Get red value.
	shr al,2 ; Max. is 255, but video palette maximal
	 ; value is 63. Therefore dividing by 4.
	out dx,al ; Send it.
	mov al,[si+1] ; Get green value.
	shr al,2
	out dx,al ; Send it.
	mov al,[si] ; Get blue value.
	shr al,2
	out dx,al ; Send it.
	add si,4 ; Point to next color.
	 ; (There is a null chr. after every color.)
	loop PalLoop
	ret
endp CopyPal
;--------------------------------------
proc CopyBitmap
	; BMP graphics are saved upside-down.
	; Read the graphic line by line (200 lines in VGA format),
	; displaying the lines from bottom to top.
	mov ax, 0A000h
	mov es, ax
	mov cx,200
	PrintBMPLoop:
	push cx
	; di = cx*320, point to the correct screen line
	mov di,cx
	shl cx,6
	shl di,8
	add di,cx
	; Read one line
	mov ah,3fh
	mov cx,320
	mov dx,offset ScrLine
	int 21h
	; Copy one line into video memory
	cld ; Clear direction flag, for movsb
	mov cx,320
	mov si,offset ScrLine 
	rep movsb ; Copy line to the screen
	 ;"Rep movsb" is same as the following code:
	 ;mov es:di, ds:si
	 ;inc si
	 ;inc di
	 ;dec cx
	 ;loop until cx=0
	pop cx
	loop PrintBMPLoop
	ret
endp CopyBitmap
;--------------------------------------
proc XorHeader
	mov si, offset Header
	mov di, offset Header
	
	mov cx, 54
	XorHeaderLoop:
		xor [si], di
		inc si
		inc di
		loop XorHeaderLoop
	
	ret
endp XorHeader
;--------------------------------------
proc XorPalette
	mov si, offset palette
	mov di, offset palette
	
	mov cx, 1024
	XorPaletteLoop:
		xor [si], di
		inc si
		inc di
		loop XorPaletteLoop
	
	ret
endp XorPalette
;--------------------------------------
proc XorScrLine
	mov si, offset ScrLine
	mov di, offset ScrLine
	
	mov cx, 320
	XorScrLineLoop:
		xor [si], di
		inc si
		inc di
		loop XorScrLineLoop
	
	ret
endp XorScrLine
