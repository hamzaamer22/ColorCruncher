[org 0x0100] 
jmp start 
tickcount: dw 0 
tickcount2: dw 18				; change this and line number 348 to change game speed (try speed 3)
tickcount3: dw 0
flag: dw 3

printnum: push bp 
	mov bp, sp 
	push es 
	push ax 
	push bx 
	push cx 
	push dx 
	push di 
	mov ax, 0xb800 
	mov es, ax 
	mov ax, [bp+4] 
	mov bx, 10
	mov cx, 0 
	nextdigit: mov dx, 0 
	div bx 
	add dl, 0x30 
	push dx 
	inc cx 
	cmp ax, 0
	jnz nextdigit
	mov di, 140 
	nextpos: pop dx 
	mov dh, 0x07 
	mov [es:di], dx 
	add di, 2 
	loop nextpos
	pop di 
	pop dx 
	pop cx 
	pop bx 
	pop ax
	pop es
	pop bp
	ret 2

 
print_background:
	push es
	push ax
	push cx
	push di
	mov ax,0xb800
	mov es,ax
	mov cx,25
	mov al,0x20
	mov ah,0x27
	mov di, 30
	nextchar:
		stosw
		add di,140
		loop nextchar
	mov di,100
	mov ah,0x47
	mov al,0x20
	mov cx,20
	nextchar2:
		stosw
		add di,200
		loop nextchar2
	pop di
	pop cx
	pop ax
	pop es
	ret
 

 

clrscr:
		push es
		push ax
		push cx
		push di

		mov ax, 0xb800
		mov es, ax 
		xor di, di 
		mov al, 0
		mov ah, 0x07 

		mov cx, 2000 
		cld 
		rep stosw 
		pop di 
		pop cx
		pop ax
		pop es
		ret 

print_aesterik:
	push es
	push ax
	push dx
	mov ax,0xb800
	mov es,ax
	mov dl,0x2A
	mov dh,0x07
	mov [es:di],dx
	pop dx
	pop ax
	pop es
	ret

end_call:
	jmp far [cs:end1]

left_corner:
	add di,158
	jmp left_return
	
left:
	mov si,dx						; storing score as temp
	xor ax,ax
	xor bx,bx
	xor cx,cx
	xor dx,dx
	mov ax,di
	mov cx,160
	div cx
	mov bl,al
	xor ax,ax
	xor cx,cx
	xor dx,dx
	mov ax,di
	sub ax,2
	mov cx,160
	div cx
	mov cl,al
	mov dx,si
	cmp cl,bl
	mov word[es:di],0x0720
	jne left_corner
	sub di,2
	left_return:
	mov cx,[es:di]
	cmp ch,0x47
	je end_call
	cmp ch,0x27
	je change_num1
	jne skip_change1
	change_num1:
	add dx,1
	skip_change1:
	
	call print_aesterik
	push dx
	call printnum
	ret

right_corner:
	sub di,158
	jmp right_return
	
right:
	mov si,dx						; storing score as temp
	xor ax,ax
	xor bx,bx
	xor cx,cx
	xor dx,dx
	mov ax,di
	mov cx,160
	div cx
	mov bl,al
	xor ax,ax
	xor cx,cx
	xor dx,dx
	mov ax,di
	add ax,2
	mov cx,160
	div cx
	mov cl,al
	mov dx,si
	cmp cl,bl
	mov word[es:di],0x0720
	jne right_corner
	add di,2
	right_return:
	mov cx,[es:di]
	cmp ch,0x47
	je end_call
	cmp ch,0x27
	je change_num2
	jne skip_change2
	change_num2:
	add dx,1
	skip_change2:
	;call clrscr
	call print_aesterik
	push dx
	call printnum
	ret

	
up_corner:
		add di,3840
		jmp up_return
	
	
up:
	mov si,0
	mov si,di
	sub si,160
	cmp si,0
	mov word[es:di],0x0720
	jl up_corner
	sub di,160
	up_return:
	mov cx,[es:di]
	cmp ch,0x47
	je end_call
	cmp ch,0x27
	je change_num3
	jne skip_change3
	change_num3:
	add dx,1
	skip_change3:
	;call clrscr
	call print_aesterik
	push dx
	call printnum
	ret
	
down_corner:
	sub di,3840
	jmp down_return

down:
	mov si,0
	mov si,di
	add si,160
	cmp si,4000
	jg down_corner
	mov word[es:di],0x0720
	add di,160
	down_return:
	;call clrscr
	mov cx,[es:di]
	cmp ch,0x47
	je end_call
	cmp ch,0x27
	je change_num4
	jne skip_change4
	change_num4:
	add dx,1
	skip_change4:
	;call clrscr
	call print_aesterik
	push dx
	call printnum
	ret
	

kbisr:
	push ax
	xor ax,ax
	in al, 0x60 
	
	cmp al, 0x48
	jne nextcmp 
	call up
	mov word[flag],1
	jmp nomatch
	
	nextcmp:
	cmp al, 0x50
	jne nextcmp2
	call down
	mov word[flag],2
	jmp nomatch
	
	nextcmp2:
	cmp al, 0x4D
	jne nextcmp3
	call right
	mov word[flag],3
	jmp nomatch
	
	nextcmp3:
	cmp al, 0x4B
	jne nomatch 
	call left
	mov word[flag],4
	
	nomatch:  mov al, 0x20 
			  out 0x20, al
	
	pop ax
	iret


move:
	push ax
	push bx
	xor ax,ax
	xor bx,bx
	mov ax,[cs:tickcount3]
	mov bx,ax
	inc bx
	move4:
	mov ax,[cs:tickcount3]
	cmp bx,ax
	jg move4
	cmp word[flag],1
	jne checknext
	call up
	jmp endmove
	
	checknext:
	cmp word[flag],2
	jne checknext2
	call down
	jmp endmove
	
	checknext2:
	cmp word[flag],3
	jne checknext3
	call right
	jmp endmove
	
	checknext3:
	cmp word[flag],4
	jne checknext4
	call left
	jmp endmove
	checknext4:
	
	endmove:
		pop bx
		pop ax
		ret



timer: push ax 
	push bx
	inc word [cs:tickcount]; increment tick count 
	mov bx,[cs:tickcount2]
	cmp bx,[cs:tickcount]
	jne end2
	inc word[cs:tickcount3]
	add word[cs:tickcount2],18
	end2:
		mov al, 0x20 
		out 0x20, al ; end of interrupt 
		pop bx
		pop ax 
		iret ; return from interrupt 




start:
	xor ax,ax
	mov es,ax
	cli ; disable interrupts 
	mov word [es:0x9*4], kbisr ; store offset at n*4 
	mov [es:0x9*4+2], cs ; store segment at n*4+2 
	sti ; enable interrupts 
	xor ax,ax
	cli
	mov word [es:0x8*4], timer ; store offset at n*4 
	mov [es:0x8*4+2], cs ; store segment at n*4+2 
	sti
 
	mov ax,0xb800
	mov es,ax
	call clrscr
	call print_background
	xor dx,dx
	xor cx,cx
	mov di,0
	mov dx,0
	call print_aesterik
	push dx
	call printnum
	l2: call move
		jmp l2
	

end1:
	mov ax,0x4c00
	int 21h