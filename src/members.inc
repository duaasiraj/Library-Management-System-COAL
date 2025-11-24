MEMBER_SIGNIN:
    ; Prompt for username
    INVOKE MSG_DISPLAY, ADDR SIGNIN_USER_MSG
    mov edx, OFFSET USERNAME_BUF
    mov ecx, 20
    CALL READSTRING

    ; Prompt for password
    INVOKE MSG_DISPLAY, ADDR SIGNIN_PASS_MSG
    mov edx, OFFSET PASSWORD_BUF
    mov ecx, 10
    CALL READSTRING

    ; Open MEMBERS.txt for reading
    INVOKE CreateFile, ADDR MEMBERS_FILE, GENERIC_READ, DO_NOT_SHARE, NULL, OPEN_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0
    mov filehandle, eax
    ; check handle
    cmp eax, INVALID_HANDLE_VALUE
    je signin_file_error

    ; Read file into buffer
    invoke ReadFile, filehandle, ADDR BUFFER_MEM, BUFFER_SIZE, ADDR bytesRead, 0
    ; store bytesRead in a temp if you want; using bytesRead directly is fine
    invoke CloseHandle, filehandle

    ; if file empty -> invalid
    mov eax, DWORD PTR bytesRead
    cmp eax, 0
    je invalid

    ; Parse buffer line by line
    xor ebx, ebx            ; ebx = offset into BUFFER_MEM

search_loop:
    mov eax, DWORD PTR bytesRead
    cmp ebx, eax
    jge notfound     ; reached end without match

    ; Calculate line start pointer
    lea edi, [OFFSET BUFFER_MEM + ebx]

    ; Find line length
    xor ecx, ecx
find_eol:
    mov al, [edi + ecx]
    cmp al, 0
    je process_line
    cmp al, 0Dh
    je process_line
    cmp al, 0Ah
    je process_line
    inc ecx
    jmp find_eol

process_line:
    ; Store line length on stack
    push ecx
    
    cmp ecx, 0
    je advance_offset   ; empty line, skip

    ; Find comma position in edx (0..ecx-1)
    xor edx, edx
find_comma:
    cmp edx, ecx
    jge advance_offset
    cmp byte ptr [edi + edx], ','
    je got_comma
    inc edx
    jmp find_comma

got_comma:
    ; Save comma position and line start
    push edx
    push edi
    
    ; Copy username (length = edx) to LINE_USER_BUF
    mov esi, edi
    mov edi, OFFSET LINE_USER_BUF
    mov ecx, edx
copy_user:
    cmp ecx, 0
    je term_user
    mov al, [esi]
    mov [edi], al
    inc esi
    inc edi
    dec ecx
    jmp copy_user
term_user:
    mov byte ptr [edi], 0

    ; Restore registers
    pop edi  ; line start
    pop edx  ; comma position
    
    ; Calculate password length = lineLen - commaIndex - 1
    mov eax, [esp]  ; get line length from stack (don't pop yet)
    sub eax, edx
    dec eax
    cmp eax, 0
    jle term_pass2

    ; Copy password to LINE_PASS_BUF
    push edi
    lea esi, [edi + edx + 1]  ; start after comma
    mov edi, OFFSET LINE_PASS_BUF
    mov ecx, eax  ; password length
copy_pass:
    cmp ecx, 0
    je term_pass2
    mov al, [esi]
    mov [edi], al
    inc esi
    inc edi
    dec ecx
    jmp copy_pass
term_pass2:
    mov byte ptr [edi], 0
    pop edi

    ; Compare username
    INVOKE Str_compare, ADDR USERNAME_BUF, ADDR LINE_USER_BUF
    jne restore_and_continue
    
    ; Compare password
    INVOKE Str_compare, ADDR PASSWORD_BUF, ADDR LINE_PASS_BUF
    jne restore_and_continue

    ; Found match -> clean up stack, show success message with username and member menu
    pop ecx  ; remove line length from stack
    
    ; Display "Login successful! Welcome, "
    INVOKE MSG_DISPLAY, ADDR MEMBER_SUCCESS_MSG
    
    ; Display the username
    mov edx, OFFSET LINE_USER_BUF
    call WriteString
    
    ; Display "."
    INVOKE MSG_DISPLAY, ADDR MEMBER_SUCCESS_MSG2
    
    JMP SHOW_MEMBER_MENU

restore_and_continue:
    ; Get line length from stack
    pop ecx
    
    ; Advance offset by line length
    add ebx, ecx

    ; Skip CR/LF
    cmp byte ptr [OFFSET BUFFER_MEM + ebx], 0Dh
    jne skip_lf_member
    inc ebx
skip_lf_member:
    cmp byte ptr [OFFSET BUFFER_MEM + ebx], 0Ah
    jne cont_loop
    inc ebx
cont_loop:
    jmp search_loop

advance_offset:
    ; Pop line length
    pop ecx
    
    ; Skip this line
    add ebx, ecx
    
    ; Skip CR/LF
    cmp byte ptr [OFFSET BUFFER_MEM + ebx], 0Dh
    jne skip_lf_member2
    inc ebx
skip_lf_member2:
    cmp byte ptr [OFFSET BUFFER_MEM + ebx], 0Ah
    jne after_cr
    inc ebx
after_cr:
    jmp search_loop

notfound:
    ; no matching entry
    jmp invalid

signin_file_error:
    ; could not open file; treat as invalid login
    INVOKE MSG_DISPLAY, ADDR INVALID_CRED_MSG
    JMP START

invalid:
    INVOKE MSG_DISPLAY, ADDR INVALID_CRED_MSG
    JMP START

LIB_LOGIN:
		; Prompt for librarian code and validate
		INVOKE MSG_DISPLAY, ADDR LIB_LOGIN_MSG
		CALL READINT
		CMP EAX, 987102
		JE LIB_LOGIN_SUCCESS
		INVOKE MSG_DISPLAY, ADDR INVALID_CODE_MSG
		JMP START

LIB_LOGIN_SUCCESS:
		INVOKE MSG_DISPLAY, ADDR LIB_SUCCESS_MSG
		JMP SHOW_FULL_MENU

;----------------------------------------
;------------REGISTER MEMBERS------------
;----------------------------------------
REG_M:
	INVOKE MSG_DISPLAY, ADDR REG_MSG
	;INVOKE STRING_INPUT, ADDR INPUT_STRING

	MOV ESI, OFFSET MEMBERS
	MOV EAX, MEMBER_SIZE
	MUL NUM_MEMBERS
	ADD ESI, EAX
	MOV EDX, ESI
	MOV ECX, MEMBER_SIZE
	CALL READSTRING
	INC NUM_MEMBERS

	; Append the newly registered member to MEMBERS.txt
	INVOKE CreateFile,
		ADDR MEMBERS_FILE,    ; lpFileName
		GENERIC_WRITE,       ; dwDesiredAccess
		DO_NOT_SHARE,        ; dwShareMode
		NULL,                ; lpSecurityAttributes
		OPEN_ALWAYS,         ; dwCreationDisposition
		FILE_ATTRIBUTE_NORMAL, ; dwFlagsAndAttributes
		0                    ; hTemplateFile
	mov filehandle, eax

	; Move file pointer to end for appending
	INVOKE SetFilePointer, filehandle, 0, 0, FILE_END

	; Prompt for a password for this member
	; Prompt for a password for this member
GET_PASSWORD:
    INVOKE MSG_DISPLAY, ADDR SIGNIN_PASS_MSG
    mov edx, OFFSET PASSWORD_BUF
    mov ecx, 20                ; allow user to type up to 20 chars
    CALL READSTRING

    ; Check password length >= 8
    mov edx, OFFSET PASSWORD_BUF
    INVOKE Str_length, edx     ; result in EAX
    cmp eax, 8
    jl PASS_TOO_SHORT          ; if < 8, show error and re-enter

    jmp PASS_OK

PASS_TOO_SHORT:
    INVOKE MSG_DISPLAY, ADDR PASS_TOO_SHORT_MSG
	call Crlf
    jmp GET_PASSWORD

PASS_OK:


	; ESI already points to the member buffer; write name to file
	mov edx, esi          ; pointer to name buffer
	INVOKE Str_length, edx
	mov ecx, eax          ; length returned in EAX
	mov eax, filehandle
	call WriteToFile

	; write comma separator
	mov eax, filehandle
	mov edx, OFFSET COMMA_BYTE
	mov ecx, 1
	call WriteToFile

	; write password
	mov edx, OFFSET PASSWORD_BUF
	INVOKE Str_length, edx
	mov ecx, eax
	mov eax, filehandle
	call WriteToFile

	; write CRLF after the entry
	mov eax, filehandle
	mov edx, OFFSET CRLF_BYTES
	mov ecx, 2
	call WriteToFile

	invoke CloseHandle, filehandle


		JMP START

; VIEW MEMBERS FROM FILE
VIEW_MFILE:
	INVOKE CreateFile,
	ADDR MEMBERS_FILE, ; ptr to filename
	GENERIC_READ, ; mode = Can read
	DO_NOT_SHARE, ; share mode
	NULL, ; ptr to security attributes
	OPEN_ALWAYS, ; open an existing file
	FILE_ATTRIBUTE_NORMAL, ; normal file attribute
	0 ; not used
	mov filehandle, eax ; Copy handle to variable
	invoke ReadFile,
	filehandle, ; file handle
	addr BUFFER_MEM, ; where to read
	BUFFER_SIZE, ; num bytes to read
	addr bytesRead, ; bytes actually read
	0
	invoke CloseHandle,
	filehandle
	; null-terminate buffer at bytesRead
	mov eax, DWORD PTR bytesRead
	lea edi, [OFFSET BUFFER_MEM]
	add edi, eax
	mov byte ptr [edi], 0

	; Parse BUFFER_MEM line by line and print only the first CSV field (name)
	mov esi, OFFSET BUFFER_MEM
	xor ebx, ebx            ; offset into buffer

vm_loop_file:
	mov eax, DWORD PTR bytesRead
	cmp ebx, eax
	jge vm_done_file

	; line start = BUFFER_MEM + ebx
	lea edi, [OFFSET BUFFER_MEM + ebx]
	xor ecx, ecx
vm_find_eol_file:
	mov al, [edi + ecx]
	cmp al, 0
	je vm_proc_line_file
	cmp al, 0Dh
	je vm_proc_line_file
	cmp al, 0Ah
	je vm_proc_line_file
	inc ecx
	jmp vm_find_eol_file

vm_proc_line_file:
	cmp ecx, 0
	je vm_advance_only_file

	; copy up to first comma (or end) into TEMP_FIELD
	lea esi, [OFFSET BUFFER_MEM + ebx]
	mov edi, OFFSET TEMP_FIELD
	xor edx, edx
vm_copy_name_file:
	mov al, [esi + edx]
	cmp al, ','
	je vm_name_done_file
	cmp al, 0Dh
	je vm_name_done_file
	cmp al, 0Ah
	je vm_name_done_file
	mov [edi], al
	inc edi
	inc edx
	cmp edx, ecx
	jl vm_copy_name_file
vm_name_done_file:
	mov byte ptr [edi], 0

	; print the name
	mov edx, OFFSET TEMP_FIELD
	call WriteString
	call CRLF

	; advance offset by this line length (ecx)
	add ebx, ecx
	; skip CR/LF if present
	cmp byte ptr [OFFSET BUFFER_MEM + ebx], 0Dh
	jne vm_loop_continue_file
	inc ebx
	cmp byte ptr [OFFSET BUFFER_MEM + ebx], 0Ah
	jne vm_loop_continue_file
	inc ebx
vm_loop_continue_file:
	jmp vm_loop_file

vm_advance_only_file:
	; empty line - skip one char and continue
	add ebx, ecx
	cmp byte ptr [OFFSET BUFFER_MEM + ebx], 0Dh
	jne vm_loop_after_advance_file
	inc ebx
	cmp byte ptr [OFFSET BUFFER_MEM + ebx], 0Ah
	jne vm_loop_after_advance_file
	inc ebx
vm_loop_after_advance_file:
	jmp vm_loop_file

vm_done_file:
	JMP SHOW_FULL_MENU