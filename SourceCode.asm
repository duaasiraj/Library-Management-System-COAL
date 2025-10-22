
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

MEMBER_MENU:
	; Show member options: Sign In or Register
	INVOKE MSG_DISPLAY, ADDR MEMBER_MENU_MSG
	CALL READINT
	CMP EAX, 1
	JE MEMBER_SIGNIN
	CMP EAX, 2
	JE REG_M    ; Register -> call registration routine directly
	JMP START

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

	; Read MEMBERS.txt into buffer
	INVOKE CreateFile, ADDR MEMBERS_FILE, GENERIC_READ, DO_NOT_SHARE, NULL, OPEN_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0
	mov filehandle, eax
	invoke ReadFile, filehandle, ADDR BUFFER_MEM, BUFFER_SIZE, ADDR bytesRead, 0
	invoke CloseHandle, filehandle

	; if file empty -> invalid
	mov eax, DWORD PTR bytesRead
	cmp eax, 0
	je invalid

	; Prepare line buffers (defined in DATA section)

	; Search through BUFFER_MEM line by line
	mov ebx, 0              ; offset index into BUFFER_MEM
	mov esi, OFFSET BUFFER_MEM
search_loop:
	mov eax, DWORD PTR bytesRead
	cmp ebx, eax
	jge notfound
	lea edi, [esi+ebx]      ; edi = &BUFFER_MEM[ebx] -> line start

	; find end of line (CR, LF or NULL)
	mov edx, 0              ; lineLen
find_eol:
	mov al, byte ptr [edi+edx]
	cmp al, 0
	je process_line
	cmp al, 0Dh
	je process_line
	cmp al, 0Ah
	je process_line
	inc edx
	jmp find_eol

process_line:
	; edx = line length
	cmp edx, 0
	je advance_offset

	; find comma index within line
	mov ecx, 0              ; commaIndex
find_comma:
	cmp ecx, edx
	jge advance_offset
	cmp byte ptr [edi+ecx], ','
	je got_comma
	inc ecx
	jmp find_comma

advance_offset:
	; move ebx to after this line (skip CR/LF)
	add ebx, edx
	; skip CR
	cmp byte ptr [esi+ebx], 0Dh
	jne after_cr
	inc ebx
	cmp byte ptr [esi+ebx], 0Ah
	jne after_cr
	inc ebx
after_cr:
	jmp search_loop

got_comma:
	; copy username part into LINE_USER_BUF
	mov edi, OFFSET LINE_USER_BUF
	mov ecx, 0
copy_user:
    cmp ecx, edx
    jge term_user

    ; calculate address (BUFFER_MEM + ebx + ecx)
    mov edx, esi
    add edx, ebx
    add edx, ecx

    mov al, byte ptr [edx]
    mov byte ptr [OFFSET LINE_USER_BUF + ecx], al

    inc ecx
    jmp copy_user

term_user:
	; null-terminate user buffer (commaIndex is in ECX when found)
	mov byte ptr [OFFSET LINE_USER_BUF + ecx], 0

	; compute password length = edx - (ecx+1)
	mov eax, edx
	sub eax, ecx
	dec eax                 ; password length
	; copy password into LINE_PASS_BUF
	mov edi, OFFSET LINE_PASS_BUF
	mov esi, OFFSET BUFFER_MEM
	mov ebp, ecx            ; commaIndex
	mov ecx, 0
copy_pass:
    cmp ecx, eax
    jge term_pass

    ; compute starting address (BUFFER_MEM + commaIndex + 1)
    mov edx, esi
    add edx, ebp
    add edx, 1

    mov al, byte ptr [edx+ecx]
    mov byte ptr [edi+ecx], al

    inc ecx
    jmp copy_pass

term_pass:
	mov byte ptr [edi+ecx], 0

	; Compare input username with LINE_USER_BUF
	INVOKE Str_compare, ADDR USERNAME_BUF, ADDR LINE_USER_BUF
	jne restore_and_continue
	; Compare input password with LINE_PASS_BUF
	INVOKE Str_compare, ADDR PASSWORD_BUF, ADDR LINE_PASS_BUF
	jne restore_and_continue
	; Found match
	JMP SHOW_FULL_MENU

restore_and_continue:
	; advance offset past this line
	add ebx, edx
	; skip CRLF
	cmp byte ptr [OFFSET BUFFER_MEM + ebx], 0Dh
	jne cont_loop
	inc ebx
	cmp byte ptr [OFFSET BUFFER_MEM + ebx], 0Ah
	jne cont_loop
	inc ebx
cont_loop:
	jmp search_loop

notfound:
	; no matching entry
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
