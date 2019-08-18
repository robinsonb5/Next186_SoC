; This file is part of the Next186 SoC PC project
; http://opencores.org/project,next186

; Filename: bootstrap.asm
; Description: Part of the Next186 SoC PC project, bootstrap "ROM" code (RAM initialized with cache)
; Version 1.0
; Creation date: Jun2013

; Author: Nicolae Dumitrache 
; e-mail: ndumitrache@opencores.org

; -------------------------------------------------------------------------------------
 
; Copyright (C) 2013 Nicolae Dumitrache
 
; This source file may be used and distributed without 
; restriction provided that this copyright statement is not 
; removed from the file and that any derivative work contains 
; the original copyright notice and the associated disclaimer.
 
; This source file is free software; you can redistribute it 
; and/or modify it under the terms of the GNU Lesser General 
; Public License as published by the Free Software Foundation;
; either version 2.1 of the License, or (at your option) any 
; later version. 
 
; This source is distributed in the hope that it will be 
; useful, but WITHOUT ANY WARRANTY; without even the implied 
; warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR 
; PURPOSE. See the GNU Lesser General Public License for more 
; details. 
 
; You should have received a copy of the GNU Lesser General 
; Public License along with this source; if not, download it 
; from http://www.opencores.org/lgpl.shtml 
 
; -----------------------------------------------------------------------

; Additional Comments: 
; Assembled with MASM v6.14.8444
; No hardware resources are required for the bootstrap ROM, I use only the initial value of the cache memory
; BIOS will be read from the last BIOSSIZE sectors of SD Card and placed in DRAM at F000:(-BIOSSIZE*512)
; SD HC card required



.186
.model tiny
.code


BIOSSIZE    EQU     16      ; sectors
BOOTOFFSET  EQU     0fc00h  ; bootstrap code offset in segment 0f000h

; this code is for bootstrap deployment only, it will not be present in ROM (cache)
;---------------- EXECUTE -----------------
		org		100h        ; this code is loaded at 0f000h:100h
exec    label near

		mov		si, begin
		mov		di, BOOTOFFSET
		mov		cx, 256*4/2 ; last 4 cache lines (from total 8)
		rep		movsw
		db		0eah
		dw		0, -1       ; CPU reset, execute bootstrap


; Loads BIOS (8K = 16 sectors) from last sectors of SD card (if present)
; If no SD card detected, wait on RS232 115200bps and load program at F000:100h
; the following code is placed in the last 1kB of cache (last 4 lines), each with the dirty bit set
; the corresponding position in RAM will be F000:BOOTOFFSET
; ----------------- RS232 bootstrap - last 256byte cache line ---------------
        org     200h
begin label far               ; this code is placed at F000:BOOTOFFSET

		cli
		cld
		mov		ax, cs        ; cs = 0f000h
		mov		ds, ax
		mov		es, ax
		mov		ss, ax
		mov		sp, BOOTOFFSET
		xor		ax, ax        ; map seg0
		out		80h, ax
		mov		al, 0bh       ; map text segB
		out		8bh, ax
		mov		al, 0fh       ; map ROM segF
		out		8fh, ax
		mov		al, 34h	      ; Counter zero, LSB/MSB, mode 2 (rate generator), not BCD
		out		43h, al
		xor		al, al
		out		40h, al
		out		40h, al       ; program PIT for RS232

		; Message

		mov		dx, 3c0h
		mov		al, 10h
		out		dx, al
		mov		al, 8h
		out		dx, al      ; set text mode
		mov		dx, 3d4h
		mov		al, 0ah
		out		dx, al
		inc		dx
		mov		al, 1 shl 5 ; hide cursor
		out		dx, al
		dec		dx
		mov		al, 0ch
		out		dx, al
		inc		dx
		mov		al, 0
		out		dx, al
		dec		dx
		mov		al, 0dh
		out		dx, al
		inc		dx
		mov		al, 0
		out		dx, al      ; reset video offset
      
		push		0b800h      ; clear screen
		pop		es
		xor		di, di
		mov		cx, 25*80
		xor		ax, ax
		rep		stosw
		
		mov		dx, 3c8h    ; set palette entry 1
		mov		ax, 101h
		out		dx, al
		inc		dx
		mov		al, 2ah
		out		dx, al
		out		dx, al
		out		dx, al
		
		xor		di, di
		mov		si, booterrmsg + BOOTOFFSET - begin
		lodsb
nextchar:      
		stosw
		lodsb
		test		al, al
		jnz		short nextchar

		mov		bx, 4000h
flush:        
		mov		al, [bx]
		sub		bx, 40h
		jnz		flush

;		AMR - modify to load the BIOS over RS232 rather than a program.	
		xor	si,si
		mov	bx,2000h

		mov 	ax,180h
		out	3fh,ax
_hsloop:
		in	ax,3fh
		cmp	ax,0180h
		jne	_hsloop
		mov	ax,080h
		out	3fh,ax
_hsloop2:
		in	ax,3fh
		cmp	ax,080h
		jne	_hsloop2

		jmp 	rs232boot

		mov	ax,181h	; BOOTSTRAP
		out	3fh,ax

_recloop:
		in	ax,3fh
		test	ax,100h
		je	_recloop
		mov	[si],al
		inc	si
		mov	al,bl
		mov	ah,0
		out	3fh,ax
		dec	bx
_recloop2:
		in	ax,3fh
		test	ax,100h
		jne	_recloop2
		mov	[si],al
		inc	si
		dec	bx
		je	_boot
		mov	al,bl
		mov	ah,1
		out	3fh,ax
		jmp	_recloop


; ----------------  serial receive byte 115200 bps --------------
srecb:  
		mov		ah, 80h
		mov		dx, 3dah
		mov		cx, -5aeh ; (half start bit) -- was 5ae
srstb:  
		in		al, dx
		shr		al, 2
		jc		srstb

		in		al, 40h ; lo counter
		add		ch, al
		in		al, 40h ; hi counter, ignore
l1:
		call		dlybit
		in		al, dx
		shr		al, 2
		rcr		ah, 1
		jnc		l1
dlybit:
		sub		cx, 0a5bh  ;  (full bit) -- was a5b
dly1:
		in		al, 40h
		cmp		al, ch
		in		al, 40h
		jnz		dly1
		ret


rs232boot:
		call		srecb
		mov		[si], ah
		inc		si
		dec		bx
		jnz		rs232boot

_boot:
		xor		sp, sp
		mov		ss, sp
		mov		bx,si

		push		0f000h
		pop		es	; Restore E segment after outputting to video
		mov		si, reloc + BOOTOFFSET - begin
		mov		di, bx
		mov		cx, endreloc - reloc
		rep		movsb       ; relocate code from reloc to endreloc after loaded BIOS
		mov		di, -BIOSSIZE*512
		xor		si, si
		mov		cx, BIOSSIZE*512/2
		jmp		bx
reloc:      
		rep		movsw
		db		0eah
		dw		0, -1       ; CPU reset, execute BIOS
endreloc:


handshake:

		ret

booterrmsg  db  'Waiting for BIOS image...', 0


; ---------------- RESET ------------------
		org 05f0h
start:
		db		0eah
		dw		BOOTOFFSET, 0f000h
		db		0,0,0,0,0,0,0,0,0,0,0
       
end exec