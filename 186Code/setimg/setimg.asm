; setimg.com 

.186
.model tiny
.code

    org  0100h        ; .com files always start 256 bytes into the segment

	; INT 21h subfunction 9 requires '$' to terminate string
	xor   bx,bx
	mov   bl,ds:[80h]

	cmp   bl,7Eh
	 ja   exit      ; preventing overflow
	mov   byte ptr ds:[bx+81h],'$'

	; print the string
	mov   ah,9
	mov   dx,81h
	int   21h

exit:

	mov   ax,4C00h  ; subfunction 4C
	int   21h

	END

