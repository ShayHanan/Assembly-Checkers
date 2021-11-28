IDEAL
MODEL small
STACK 100h
DATASEG
include 'varbs.asm'
; --------------------------
; Your variables here
; --------------------------
CODESEG
include 'procs.asm'
include 'game.asm'
include 'bmp.asm'
include 'eatR.asm'
include 'eatL.asm'
include 'BeatL.asm'
include 'BeatR.asm'
include 'QueenR.asm'
include 'QueenB.asm'
 start:
	mov ax, @data
	mov ds, ax
	call gmode
	push offset fileName 
	call pic
	call openningSound
	call delay
	push offset fileName2
	call pic
	call WhatPressed		
; --------------------------
; Your code here
; --------------------------
	
exit:
	call textmode
	mov ax, 4c00h
	int 21h
END start

