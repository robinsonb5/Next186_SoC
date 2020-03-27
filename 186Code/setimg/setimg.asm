; setimg.com 

DC_SETIMAGE equ 0FCh

.186
.model tiny
.code

    org  0100h        ; .com files always start 256 bytes into the segment

	mov dx,msgsending
	mov	ah,9
	int 21h

	xor   bx,bx
	mov   bl,ds:[80h]

	cmp   bl,7Eh
	 ja   exit      ; preventing overflow

	mov   byte ptr ds:[bx+81h],0

	; copy the string to imgname, removing the . and padding to 11 characters.

	mov   si,82h
	mov   di,imgname
	mov	  cl,8

	; Send the first 8 characters of the filename
imgnameloop:
	lodsb
	cmp	  al,'.'
	jz    short padloop
	cmp   al,'9'
    jl    mainskipcase
	and   al,0dfh	; upper case
mainskipcase:
	stosb
	sub	  cl,1
	jnz	  short imgnameloop
	jmp   short ext
padloop:
	mov   al,' '
	stosb
	sub   cl,1
    jnz   short padloop

ext:
	mov   cl,3
extloop:
    lodsb
	cmp   al,'.'
	jz    extloop
	and   al,al
    jz    done
	cmp   al,'9'
    jl    extskipcase
	and   al,0dfh	; upper case
extskipcase:
    stosb
    sub   cl,1
    jnz   extloop
done:
    mov   al,'$'
    stosb

    mov   dx,imgname
    mov   ah,9
    int   21h

	sub   di,1
	mov   al,0
	stosb

	; Ask the control module to open an FD image file.
	mov   si,imgname

	mov	  cl,6
	mov	  al,DC_SETIMAGE ; DC_SETIMAGE
	call  dc_hi
sendimgnameloop:
	lodsb
	call  dc_lo
	lodsb
	call  dc_hi
	sub	  cl,1
	jnz   short sendimgnameloop
DOSimgnamesent:
	call  dc_lo	; Get response
	mov	  dx,msgok
	and   al,al
	jz    ok
	mov   dx,msgfailed
ok:
    mov   ah,9
    int   21h

exit:

	mov   ax,4C00h  ; subfunction 4C
	int   21h

imgname:
	db	'            ',0

; --- host datachannel ---

dc_hi:
	mov	ah,1
	out	3fh,ax
_dc_hi_loop:
	in	ax,3fh
	test	ax,100h
	je	_dc_hi_loop
	ret

dc_lo:
	mov	ah,0
	out	3fh,ax
_dc_lo_loop:
	in	ax,3fh
	test	ax,100h
	jne	_dc_lo_loop
	ret

msgsending:
	db 'sending $'
msgok:
	db 13,10,'OK$'
msgfailed:
	db 13,10,'Failed$'
	END

