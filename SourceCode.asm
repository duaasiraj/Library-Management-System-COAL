
INCLUDE IRVINE32.inc
.DATA

topMsg BYTE 0AH
	BYTE    "--------------------------------------------",0dh,0ah
	BYTE    "--  WELCOME TO LIBRARY MANAGEMENT SYSTEM  --",0dh,0ah
	BYTE    "--------------------------------------------",0dh,0ah,0ah
	BYTE    "1-> Librarian",0dh,0ah
	BYTE    "2-> Member",0dh,0ah
	BYTE    "3-> Exit",0dh,0ah
	BYTE    "Choose Your Option : ",0

msg1	 BYTE 0AH
	BYTE    "1-> Register a Member", 0dh, 0ah
	BYTE    "2-> View Members", 0dh, 0ah
	BYTE    "3-> View Members From File", 0dh, 0ah
	BYTE    "4-> Add Book", 0dh, 0ah
	BYTE    "5-> View Books", 0dh, 0ah
	BYTE    "6-> View Books From Files", 0dh, 0ah
	BYTE    "7-> Exit Program", 0dh, 0ah
	BYTE    "Choose Your Option : ", 0
	LIB_LOGIN_MSG BYTE 0AH, "Enter librarian code: ",0
	INVALID_CODE_MSG BYTE 0AH, "Invalid code. Returning to top menu.",0dh,0ah,0

MEMBER_MENU_MSG BYTE 0Ah, "1-> Sign In",0dh,0ah, "2-> Register",0dh,0ah, "Choose Your Option : ",0

MEMBER_OPTIONS_MSG BYTE 0Ah
	BYTE    "Member Menu:",0dh,0ah
	BYTE    "1. Search a Book",0dh,0ah
	BYTE    "2. Issue Book",0dh,0ah
	BYTE    "3. Return Book",0dh,0ah
	BYTE    "4. View Sorted Books",0dh,0ah
	BYTE    "5. Logout",0dh,0ah
	BYTE    "Select an option: ",0
SIGNIN_USER_MSG BYTE "Enter username: ",0
SIGNIN_PASS_MSG BYTE "Enter password: ",0
INVALID_CRED_MSG BYTE 0Ah, "Invalid email or password.",0dh,0ah,0

VALID_USER BYTE "faizan",0
VALID_PASS BYTE "1234",0
USERNAME_BUF BYTE 20 DUP(?)
PASSWORD_BUF BYTE 10 DUP(?)
COMMA_BYTE BYTE ',',0
LINE_USER_BUF BYTE 20 DUP(?)
LINE_PASS_BUF BYTE 10 DUP(?)
REG_MSG	 BYTE "	Enter Name: ",0
VIEW_MEMBERS_MSG BYTE 0Ah,"	Viewing Registered Members: ",0AH, 0DH, 0
ADD_MSG			 BYTE "	Enter Book Name & Author Name to Add: ", 0dh, 0ah,
			 "	Separated By Comma:",0
VIEW_BOOKS_MSG BYTE 0Ah, "	Viewing Books in Library: ",  0dh, 0ah, 0
EXIT_MSG	   BYTE 0AH,
				    "	----------------- ",0dh, 0ah,
				    "	Exiting Program...",0dh, 0ah,
					"	See you again  :')",0dh, 0ah,
					"	------------------", 0
					
	CRLF_BYTES BYTE 0Dh,0Ah
					
; variables to maniulate Books & Members

bool		   DWORD ?
MEMBERS_FILE   BYTE "MEMBERS.txt",0
BOOKS_FILE     BYTE "BOOKS.txt",0
filehandle     DWORD ?
BUFFER_SIZE = 5000
buffer_mem   BYTE buffer_size DUP (?)
buffer_book  BYTE buffer_size DUP (?)
bytesRead dword 1 dup(0)
REGISTER	 DWORD 1
VIEW_MEMBERS DWORD 2
VIEW_MF		 DWORD 3
ADD_BOOK	 DWORD 4
VIEW_BOOKS	 DWORD 5
VIEW_BF		 DWORD 6
EXITP		 DWORD 7

; Member menu options
SEARCH_BOOK	 DWORD 1
ISSUE_BOOK	 DWORD 2
RETURN_BOOK	 DWORD 3
VIEW_SORTED	 DWORD 4
MEMBER_LOGOUT DWORD 5	
MEMBER_SIZE = 20
MEMBER1 DB MEMBER_SIZE DUP (?)
MEMBER2 DB MEMBER_SIZE DUP (?)
MEMBER3 DB MEMBER_SIZE DUP (?)
MEMBER4 DB MEMBER_SIZE DUP (?)
MEMBER5 DB MEMBER_SIZE DUP (?)
MEMBER6 DB MEMBER_SIZE DUP (?)
NUM_MEMBERS DWORD 0
MEMBERS DD MEMBER1, MEMBER2, MEMBER3, MEMBER4, MEMBER5, MEMBER6, 0AH, 0DH, 0

BOOK_SIZE = 30
BOOK1 DB BOOK_SIZE DUP (?)
BOOK2 DB BOOK_SIZE DUP (?)
BOOK3 DB BOOK_SIZE DUP (?)
BOOK4 DB BOOK_SIZE DUP (?)
BOOK5 DB BOOK_SIZE DUP (?)
BOOK6 DB BOOK_SIZE DUP (?)
NUM_BOOKS DWORD 0
BOOKS DD BOOK1, BOOK2, BOOK3, BOOK4, BOOK5, BOOK6, 0AH, 0DH, 0


; **********************************************
; *************** Code Section *****************
; **********************************************

.CODE
MSG_DISPLAY proto, var: PTR DWORD
STRING_INPUT proto, var1: PTR DWORD

main PROC
	START:
	; Top-level menu: Librarian / Member / Exit
	INVOKE MSG_DISPLAY, ADDR topMsg
	CALL READINT ; read top-level choice

	CMP EAX, 1
	JE LIB_LOGIN
	CMP EAX, 2
	JE MEMBER_MENU
	CMP EAX, 3
	JE EXIT_MENU
	; any other input -> show top menu again
	JMP START

SHOW_FULL_MENU:
	; display the existing full menu and read option
	INVOKE MSG_DISPLAY, ADDR MSG1
	CALL READINT ; input for options

	CMP EAX, REGISTER
	JE REG_M		; jump to Register Member section
	CMP EAX, VIEW_MEMBERS
	JE VIEW_M		; jump to View Members section
	CMP EAX, VIEW_MF
	JE VIEW_MFILE		; jump to Add Book section
	CMP EAX, ADD_BOOK
	JE ADD_B		; jump to View Books section
	CMP EAX, VIEW_BOOKS
	JE VIEW_B		; calling function to display message
	CMP EAX, VIEW_BF
	JE VIEW_BFILE		; taking input in 2D array
		JMP EXIT_MENU

SHOW_MEMBER_MENU:
	; display member menu and read option
	INVOKE MSG_DISPLAY, ADDR MEMBER_OPTIONS_MSG
	CALL READINT ; input for options

	CMP EAX, SEARCH_BOOK
	JE SEARCH_BOOK_FUNC	; jump to Search Book section
	CMP EAX, ISSUE_BOOK
	JE ISSUE_BOOK_FUNC	; jump to Issue Book section
	CMP EAX, RETURN_BOOK
	JE RETURN_BOOK_FUNC	; jump to Return Book section
	CMP EAX, VIEW_SORTED
	JE VIEW_SORTED_FUNC	; jump to View Sorted Books section
	CMP EAX, MEMBER_LOGOUT
	JE START		; logout -> return to main menu
	JMP SHOW_MEMBER_MENU	; invalid option -> show menu again

MEMBER_MENU:
	; Show member options: Sign In or Register
	INVOKE MSG_DISPLAY, ADDR MEMBER_MENU_MSG
	CALL READINT
	CMP EAX, 1
	JE MEMBER_SIGNIN
	CMP EAX, 2
	JE REG_M    ; Register -> call registration routine directly
	JMP START

; -------------------------
; MEMBER_SIGNIN (fixed)
; -------------------------
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

    ; -------- parse buffer safely line by line --------
    ; ESI = base of BUFFER_MEM
    mov esi, OFFSET BUFFER_MEM
    xor ebx, ebx            ; ebx = offset into BUFFER_MEM (bytes consumed)

search_loop_fixed:
    mov eax, DWORD PTR bytesRead
    cmp ebx, eax
    jge notfound_fixed      ; reached end without match

    ; edi = pointer to current line (BUFFER_MEM + ebx)
    lea edi, [esi + ebx]

    ; find line length in ecx (stop at NULL, CR or LF)
    xor ecx, ecx
find_eol_fixed:
    mov al, [edi + ecx]
    cmp al, 0
    je process_line_fixed
    cmp al, 0Dh
    je process_line_fixed
    cmp al, 0Ah
    je process_line_fixed
    inc ecx
    jmp find_eol_fixed

process_line_fixed:
    cmp ecx, 0
    je advance_offset_fixed   ; empty line, skip

    ; find comma position in edx (0..ecx-1)
    xor edx, edx
find_comma_fixed:
    cmp edx, ecx
    jge advance_offset_fixed
    cmp byte ptr [edi + edx], ','
    je got_comma_fixed
    inc edx
    jmp find_comma_fixed

got_comma_fixed:
    ; copy username (length = edx) from [edi] to LINE_USER_BUF
    mov esi, edi              ; source pointer
    mov edi, OFFSET LINE_USER_BUF ; dest pointer
    mov ecx, edx              ; number of bytes to copy
    xor eax, eax
copy_user_fixed:
    cmp ecx, 0
    je term_user_fixed
    mov al, [esi]
    mov [edi], al
    inc esi
    inc edi
    dec ecx
    jmp copy_user_fixed
term_user_fixed:
    mov byte ptr [edi], 0     ; null-terminate LINE_USER_BUF

    ; copy password (length = ecx_line - commaIndex - 1)
    ; compute password length in ecx: (lineLen - edx - 1)
    mov eax, ecx              ; careful: ecx currently 0 (we used it); recalc
    ; We still have original line length in stack? No — recalc using saved values:
    ; line length was in original register when we found EOL: we used ECX then changed.
    ; To avoid this confusion, re-calc line len: find EOL again (cheap) from edi-of-line
    ; Simpler: compute password length = ( (pointer to EOL) - (pointer to edi) ) - (comma+1)
    ; We have pointer to line in edi_orig (we used edi). Recreate:
    ; edi currently points to LINE_USER_BUF + username_len + 1 (after term_user_fixed)
    ; so use a different approach: compute pwLen = (offset to EOL) - (commaIndex +1)
    ; We'll recompute line length into ecx by scanning again from line start.

    ; Recompute line length:
    lea esi, [OFFSET BUFFER_MEM + ebx]
    xor ecx, ecx
find_eol_fixed2:
    mov al, [esi + ecx]
    cmp al, 0
    je got_len2
    cmp al, 0Dh
    je got_len2
    cmp al, 0Ah
    je got_len2
    inc ecx
    jmp find_eol_fixed2
got_len2:
    ; ecx = lineLen, edx = commaIndex (still)
    mov eax, ecx
    sub eax, edx
    dec eax    ; password length = lineLen - commaIndex - 1
    cmp eax, 0
    jle term_pass_fixed2   ; nothing after comma

    ; prepare source pointer = lineStart + commaIndex + 1
    lea esi, [OFFSET BUFFER_MEM + ebx]
    add esi, edx
    inc esi                  ; now esi points to first char of password
    mov edi, OFFSET LINE_PASS_BUF
    mov ecx, eax             ; password length
copy_pass_fixed:
    cmp ecx, 0
    je term_pass_fixed2
    mov al, [esi]
    mov [edi], al
    inc esi
    inc edi
    dec ecx
    jmp copy_pass_fixed
term_pass_fixed2:
    mov byte ptr [edi], 0

    ; Compare input username with LINE_USER_BUF
    INVOKE Str_compare, ADDR USERNAME_BUF, ADDR LINE_USER_BUF
    jne restore_and_continue_fixed
    ; Compare input password with LINE_PASS_BUF
    INVOKE Str_compare, ADDR PASSWORD_BUF, ADDR LINE_PASS_BUF
    jne restore_and_continue_fixed

    ; Found match -> show member menu
    JMP SHOW_MEMBER_MENU

restore_and_continue_fixed:
    ; Advance ebx to after this line (skip CR/LF and the line itself)
    ; ebx += lineLen
    ; compute lineLen again:
    lea eax, [OFFSET BUFFER_MEM]
    add eax, ebx            ; eax = pointer to line start
    ; but easier: we already computed lineLen in ecx (got_len2)
    mov eax, ecx
    add ebx, eax

    ; skip CR then LF if present
    cmp byte ptr [OFFSET BUFFER_MEM + ebx], 0Dh
    jne cont_loop_fixed
    inc ebx
    cmp byte ptr [OFFSET BUFFER_MEM + ebx], 0Ah
    jne cont_loop_fixed
    inc ebx
cont_loop_fixed:
    jmp search_loop_fixed

advance_offset_fixed:
    ; when no comma or empty line -> skip this line
    ; recompute line length in ecx
    lea esi, [OFFSET BUFFER_MEM + ebx]
    xor ecx, ecx
find_eol_skip:
    mov al, [esi + ecx]
    cmp al, 0
    je got_len_skip
    cmp al, 0Dh
    je got_len_skip
    cmp al, 0Ah
    je got_len_skip
    inc ecx
    jmp find_eol_skip
got_len_skip:
    add ebx, ecx
    ; skip CRLF
    cmp byte ptr [OFFSET BUFFER_MEM + ebx], 0Dh
    jne after_cr_fixed
    inc ebx
    cmp byte ptr [OFFSET BUFFER_MEM + ebx], 0Ah
    jne after_cr_fixed
    inc ebx
after_cr_fixed:
    jmp search_loop_fixed

notfound_fixed:
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
		JE SHOW_FULL_MENU
		INVOKE MSG_DISPLAY, ADDR INVALID_CODE_MSG
		JMP START

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
	INVOKE MSG_DISPLAY, ADDR SIGNIN_PASS_MSG
	mov edx, OFFSET PASSWORD_BUF
	mov ecx, 10
	CALL READSTRING

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

	;INVOKE CreateFile,
	;ADDR MEMBERS_FILE,
	;GENERIC_WRITE,
	;DO_NOT_SHARE, 
	;NULL, 
	;OPEN_ALWAYS, 
	;FILE_ATTRIBUTE_NORMAL, 
	;0
;
;cmp eax, INVALID_HANDLE_VALUE
	;je exit_1
	;mov filehandle, eax
;INVOKE SetFilePointer,
	 ;filehandle,
	;0, ; distance low
	;0, ; distance high
	;FILE_END
	;mov eax,filehandle
;
	;mov edx, offset BUFFER_MEM
	;mov ecx, 7
	;call READSTRING
	;mov eax, filehandle
	;call WriteToFile
;
	;INVOKE SetFilePointer,
	 ;filehandle,
	;0, ; distance low
	;0, ; distance high
	;FILE_END
;exit_1:
	;invoke CloseHandle, filehandle

		JMP START

;--------------------------------------
;--------------VIEW MEMBERS------------
;--------------------------------------
	VIEW_M:
		INVOKE MSG_DISPLAY, ADDR VIEW_MEMBERS_MSG
	MOV ECX, NUM_MEMBERS
	cmp ECX, 0
	JE START
	MOV EBX, 0
OUTPUT:
	MOV ESI, OFFSET MEMBERS
	MOV EAX, MEMBER_SIZE
	MUL EBX
	ADD ESI, Eax
	MOV EDX, ESI
	CALL WRITESTRING
	INC EBX
	CALL CRLF
LOOP OUTPUT
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
	mov edx, offset BUFFER_MEM ; Write String
	call WriteString
	JMP START
;----------------------------------
;--------------ADD BOOKS-----------
;----------------------------------	
	ADD_B:

	INVOKE MSG_DISPLAY, ADDR ADD_MSG
	MOV ESI, OFFSET BOOKS
	MOV EAX, BOOK_SIZE
	MUL NUM_BOOKS
	ADD ESI, EAX
	MOV EDX, ESI
	MOV ECX, BOOK_SIZE
	CALL READSTRING
	INC NUM_BOOKS
		
	JMP START
;------------------------------------
;-------------VIEW BOOKS-------------
;------------------------------------
	VIEW_B:
	
	INVOKE MSG_DISPLAY, ADDR VIEW_BOOKS_MSG
	MOV ECX, NUM_BOOKS
	cmp ECX, 0
	JE START
	MOV EBX, 0
OUTPUTB:
	MOV ESI, OFFSET BOOKS
	MOV EAX, BOOK_SIZE
	MUL EBX
	ADD ESI, Eax
	MOV EDX, ESI
	CALL WRITESTRING
	INC EBX
	CALL CRLF	
LOOP OUTPUTB
		
JMP START
; VIEW BOOKS FROM FILE
VIEW_BFILE:
	INVOKE CreateFile,
	ADDR BOOKS_FILE, ; ptr to filename
	GENERIC_READ, ; mode = Can read
	DO_NOT_SHARE, ; share mode
	NULL, ; ptr to security attributes
	OPEN_ALWAYS, ; open an existing file
	FILE_ATTRIBUTE_NORMAL, ; normal file attribute
	0 ; not used
	mov filehandle, eax ; Copy handle to variable
	invoke ReadFile,
	filehandle, ; file handle
	addr BUFFER_BOOK, ; where to read
	BUFFER_SIZE, ; num bytes to read
	addr bytesRead, ; bytes actually read
	0
	invoke CloseHandle,
	filehandle
	mov edx, offset BUFFER_BOOK ; Write String
	call WriteString
	JMP START

; Member menu functions (placeholders)
SEARCH_BOOK_FUNC:
	; TODO: Implement search book functionality
	INVOKE MSG_DISPLAY, ADDR CRLF_BYTES
	INVOKE MSG_DISPLAY, ADDR CRLF_BYTES
	JMP SHOW_MEMBER_MENU

ISSUE_BOOK_FUNC:
	; TODO: Implement issue book functionality
	INVOKE MSG_DISPLAY, ADDR CRLF_BYTES
	INVOKE MSG_DISPLAY, ADDR CRLF_BYTES
	JMP SHOW_MEMBER_MENU

RETURN_BOOK_FUNC:
	; TODO: Implement return book functionality
	INVOKE MSG_DISPLAY, ADDR CRLF_BYTES
	INVOKE MSG_DISPLAY, ADDR CRLF_BYTES
	JMP SHOW_MEMBER_MENU

VIEW_SORTED_FUNC:
	; TODO: Implement view sorted books functionality
	INVOKE MSG_DISPLAY, ADDR CRLF_BYTES
	INVOKE MSG_DISPLAY, ADDR CRLF_BYTES
	JMP SHOW_MEMBER_MENU

	EXIT_MENU:
		INVOKE MSG_DISPLAY, ADDR EXIT_MSG
	
	invoke ExitProcess,0
main endp


MSG_DISPLAY PROC USES EDX, VAR: ptr dword
	MOV EDX, VAR
	CALL WRITESTRING
	RET
	MSG_DISPLAY ENDP

STRING_INPUT PROC USES EDX ECX, var: ptr dword
		
	MOV EDX, VAR
	MOV ECX, 5000
	CALL READSTRING
	RET
	STRING_INPUT ENDP

end main