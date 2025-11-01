
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
	BYTE    "Librarian Menu:", 0dh, 0ah
	BYTE    "1. View Overdue Books", 0dh, 0ah
	BYTE    "2. Calculate Fines", 0dh, 0ah
	BYTE    "3. Add Book", 0dh, 0ah
	BYTE    "4. Display All Books", 0dh, 0ah
	BYTE    "5. Display All Users", 0dh, 0ah
	BYTE    "6. Logout", 0dh, 0ah
	BYTE    "Choose Your Option : ", 0
	LIB_LOGIN_MSG BYTE 0AH, "Enter librarian code: ",0
	INVALID_CODE_MSG BYTE 0AH, "Invalid code. Returning to top menu.",0dh,0ah,0
	LIB_SUCCESS_MSG BYTE 0AH, "Login successful! Welcome, Librarian.",0dh,0ah,0

MEMBER_MENU_MSG BYTE 0Ah, "1-> Sign In",0dh,0ah, "2-> Register",0dh,0ah, "Choose Your Option : ",0
MEMBER_SUCCESS_MSG BYTE 0AH, "Login successful! Welcome, ",0
MEMBER_SUCCESS_MSG2 BYTE ".",0dh,0ah,0

MEMBER_OPTIONS_MSG BYTE 0Ah
	BYTE    "Member Menu:",0dh,0ah
	BYTE    "1. Search a Book",0dh,0ah
	BYTE    "2. Issue Book",0dh,0ah
	BYTE    "3. Return Book",0dh,0ah
	BYTE    "4. View Sorted Books",0dh,0ah
	BYTE    "5. Logout",0dh,0ah
	BYTE    "Select an option: ",0

SEARCH_MENU_MSG BYTE 0Ah
	BYTE    "Search Menu:",0dh,0ah
	BYTE    "1. By Name",0dh,0ah
	BYTE    "2. By Author",0dh,0ah
	BYTE    "3. By Publisher",0dh,0ah
	BYTE    "4. By Year",0dh,0ah
	BYTE    "5. Back",0dh,0ah
	BYTE    "Select an option: ",0
 
SORT_MENU_MSG BYTE 0Ah
	BYTE    "Sort Menu:",0dh,0ah
	BYTE    "1. Name (Ascending)",0dh,0ah
	BYTE    "2. Name (Descending)",0dh,0ah
	BYTE    "3. Author (Ascending)",0dh,0ah
	BYTE    "4. Author (Descending)",0dh,0ah
	BYTE    "5. Publisher (Ascending)",0dh,0ah
	BYTE    "6. Publisher (Descending)",0dh,0ah
	BYTE    "7. Year (Ascending)",0dh,0ah
	BYTE    "8. Year (Descending)",0dh,0ah
	BYTE    "9. ISBN (Ascending)",0dh,0ah
	BYTE    "10. ISBN (Descending)",0dh,0ah
	BYTE    "11. Back",0dh,0ah
	BYTE    "Select an option: ",0

SORT_NAME_ASC_MSG BYTE 0Ah, "Sorting: Name (Ascending) - not implemented.",0Dh,0Ah,0
SORT_NAME_DESC_MSG BYTE 0Ah, "Sorting: Name (Descending) - not implemented.",0Dh,0Ah,0
SORT_AUTHOR_ASC_MSG BYTE 0Ah, "Sorting: Author (Ascending) - not implemented.",0Dh,0Ah,0
SORT_AUTHOR_DESC_MSG BYTE 0Ah, "Sorting: Author (Descending) - not implemented.",0Dh,0Ah,0
SORT_PUB_ASC_MSG BYTE 0Ah, "Sorting: Publisher (Ascending) - not implemented.",0Dh,0Ah,0
SORT_PUB_DESC_MSG BYTE 0Ah, "Sorting: Publisher (Descending) - not implemented.",0Dh,0Ah,0
SORT_YEAR_ASC_MSG BYTE 0Ah, "Sorting: Year (Ascending) - not implemented.",0Dh,0Ah,0
SORT_YEAR_DESC_MSG BYTE 0Ah, "Sorting: Year (Descending) - not implemented.",0Dh,0Ah,0
SORT_ISBN_ASC_MSG BYTE 0Ah, "Sorting: ISBN (Ascending) - not implemented.",0Dh,0Ah,0
SORT_ISBN_DESC_MSG BYTE 0Ah, "Sorting: ISBN (Descending) - not implemented.",0Dh,0Ah,0
SIGNIN_USER_MSG BYTE "Enter username: ",0
SIGNIN_PASS_MSG BYTE "Enter password: ",0
INVALID_CRED_MSG BYTE 0Ah, "Invalid email or password.",0dh,0ah,0

NO_BOOKS_MSG BYTE 0Ah, "No books found.",0Dh,0Ah,0

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
	NAME_LABEL BYTE "Name: ",0
	AUTHOR_LABEL BYTE "Author: ",0
	PUBLISHER_LABEL BYTE "Publisher: ",0
	GENRE_LABEL BYTE "Genre: ",0
	YEAR_LABEL BYTE "Year: ",0
	ISBN_LABEL BYTE "ISBN: ",0
					
; variables to maniulate Books & Members

bool		   DWORD ?
MEMBERS_FILE   BYTE "MEMBERS.txt",0
BOOKS_FILE     BYTE "BOOKS.txt",0
filehandle     DWORD ?
BUFFER_SIZE = 5000
buffer_mem   BYTE buffer_size DUP (?)
buffer_book  BYTE buffer_size DUP (?)
bytesRead dword 1 dup(0)
; Librarian menu options
VIEW_OVERDUE	 DWORD 1
CALCULATE_FINES DWORD 2
ADD_BOOK	 DWORD 3
DISPLAY_BOOKS	 DWORD 4
DISPLAY_USERS	 DWORD 5
LIB_LOGOUT	 DWORD 6

; Member menu options
SEARCH_BOOK	 DWORD 1
ISSUE_BOOK	 DWORD 2
RETURN_BOOK	 DWORD 3
VIEW_SORTED	 DWORD 4
MEMBER_LOGOUT DWORD 5

; Search menu options
SEARCH_BY_NAME	 DWORD 1
SEARCH_BY_AUTHOR DWORD 2
SEARCH_BY_PUBLISHER DWORD 3
SEARCH_BY_YEAR	 DWORD 4
SEARCH_BACK	 DWORD 5	
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

; Book structure variables
BOOK_STRUCT_SIZE = 200
CURRENT_BOOK DB BOOK_STRUCT_SIZE DUP (?)
BOOK_NAME_SIZE = 150
BOOK_AUTHOR_SIZE = 150
BOOK_PUBLISHER_SIZE = 150
BOOK_GENRE_SIZE = 100

; Book input buffers
BOOK_NAME_BUF DB BOOK_NAME_SIZE DUP (?)
BOOK_AUTHOR_BUF DB BOOK_AUTHOR_SIZE DUP (?)
BOOK_PUBLISHER_BUF DB BOOK_PUBLISHER_SIZE DUP (?)
BOOK_GENRE_BUF DB BOOK_GENRE_SIZE DUP (?)
BOOK_YEAR_BUF DB 10 DUP (?)
BOOK_ISBN_BUF DB 20 DUP (?)

; Temp buffers used by search routines
TEMP_FIELD DB 200 DUP(?)
TEMP_LINE  DB 512 DUP(?)

; Book input prompts
ISBN_PROMPT BYTE "Enter ISBN: ",0
BOOK_NAME_PROMPT BYTE "Enter book name: ",0
BOOK_AUTHOR_PROMPT BYTE "Enter author name: ",0
BOOK_PUBLISHER_PROMPT BYTE "Enter publisher name: ",0
BOOK_GENRE_PROMPT BYTE "Enter Genre: ",0
BOOK_YEAR_PROMPT BYTE "Enter publishing year: ",0
INVALID_ISBN_MSG BYTE "You must enter a valid 13 digit ISBN number.",0dh,0ah,0
DUPLICATE_ISBN_MSG BYTE "That book already exists. Please check the ISBN number again.",0dh,0ah,0
BOOK_ADDED_MSG BYTE "Book added successfully!",0dh,0ah,0

; ISBN validation constants
ISBN_CHECK QWORD 1000000000000
VALID_ISBN_MIN QWORD 1000000000000
VALID_ISBN_MAX QWORD 9999999999999


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
	; display the librarian menu and read option
	INVOKE MSG_DISPLAY, ADDR MSG1
	CALL READINT ; input for options

	CMP EAX, VIEW_OVERDUE
	JE VIEW_OVERDUE_FUNC	; jump to View Overdue Books section
	CMP EAX, CALCULATE_FINES
	JE CALCULATE_FINES_FUNC	; jump to Calculate Fines section
	CMP EAX, ADD_BOOK
	JE ADD_B		; jump to Add Book section
	CMP EAX, DISPLAY_BOOKS
	JE VIEW_BFILE		; jump to Display All Books section (from file)
	CMP EAX, DISPLAY_USERS
	JE VIEW_MFILE		; jump to Display All Users section
	CMP EAX, LIB_LOGOUT
	JE START		; logout -> return to main menu
	JMP SHOW_FULL_MENU	; invalid option -> show menu again

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

    ; Parse buffer line by line
    xor ebx, ebx            ; ebx = offset into BUFFER_MEM

search_loop_fixed:
    mov eax, DWORD PTR bytesRead
    cmp ebx, eax
    jge notfound_fixed      ; reached end without match

    ; Calculate line start pointer
    lea edi, [OFFSET BUFFER_MEM + ebx]

    ; Find line length
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
    ; Store line length on stack
    push ecx
    
    cmp ecx, 0
    je advance_offset_fixed   ; empty line, skip

    ; Find comma position in edx (0..ecx-1)
    xor edx, edx
find_comma_fixed:
    cmp edx, ecx
    jge advance_offset_fixed
    cmp byte ptr [edi + edx], ','
    je got_comma_fixed
    inc edx
    jmp find_comma_fixed

got_comma_fixed:
    ; Save comma position and line start
    push edx
    push edi
    
    ; Copy username (length = edx) to LINE_USER_BUF
    mov esi, edi
    mov edi, OFFSET LINE_USER_BUF
    mov ecx, edx
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
    mov byte ptr [edi], 0

    ; Restore registers
    pop edi  ; line start
    pop edx  ; comma position
    
    ; Calculate password length = lineLen - commaIndex - 1
    mov eax, [esp]  ; get line length from stack (don't pop yet)
    sub eax, edx
    dec eax
    cmp eax, 0
    jle term_pass_fixed2

    ; Copy password to LINE_PASS_BUF
    push edi
    lea esi, [edi + edx + 1]  ; start after comma
    mov edi, OFFSET LINE_PASS_BUF
    mov ecx, eax  ; password length
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
    pop edi

    ; Compare username
    INVOKE Str_compare, ADDR USERNAME_BUF, ADDR LINE_USER_BUF
    jne restore_and_continue_fixed
    
    ; Compare password
    INVOKE Str_compare, ADDR PASSWORD_BUF, ADDR LINE_PASS_BUF
    jne restore_and_continue_fixed

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

restore_and_continue_fixed:
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
    jne cont_loop_fixed
    inc ebx
cont_loop_fixed:
    jmp search_loop_fixed

advance_offset_fixed:
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
;----------------------------------
;--------------ADD BOOKS-----------
;----------------------------------	
	ADD_B:
		; Prompt for ISBN
		INVOKE MSG_DISPLAY, ADDR ISBN_PROMPT
		mov edx, OFFSET BOOK_ISBN_BUF
		mov ecx, 20
		CALL READSTRING
		
		; Convert ISBN string to number (simplified validation)
		; For now, we'll do basic length check
		INVOKE Str_length, ADDR BOOK_ISBN_BUF
		cmp eax, 13
		jne invalid_isbn
		
		; Check for duplicate ISBN (simplified - just check if any book exists)
		; For this implementation, we'll skip duplicate checking for simplicity
		
		; Prompt for book name
		INVOKE MSG_DISPLAY, ADDR BOOK_NAME_PROMPT
		mov edx, OFFSET BOOK_NAME_BUF
		mov ecx, BOOK_NAME_SIZE
		CALL READSTRING
		
		; Prompt for author name
		INVOKE MSG_DISPLAY, ADDR BOOK_AUTHOR_PROMPT
		mov edx, OFFSET BOOK_AUTHOR_BUF
		mov ecx, BOOK_AUTHOR_SIZE
		CALL READSTRING
		
		; Prompt for publisher name
		INVOKE MSG_DISPLAY, ADDR BOOK_PUBLISHER_PROMPT
		mov edx, OFFSET BOOK_PUBLISHER_BUF
		mov ecx, BOOK_PUBLISHER_SIZE
		CALL READSTRING
		
		; Prompt for genre
		INVOKE MSG_DISPLAY, ADDR BOOK_GENRE_PROMPT
		mov edx, OFFSET BOOK_GENRE_BUF
		mov ecx, BOOK_GENRE_SIZE
		CALL READSTRING
		
		; Prompt for publishing year
		INVOKE MSG_DISPLAY, ADDR BOOK_YEAR_PROMPT
		mov edx, OFFSET BOOK_YEAR_BUF
		mov ecx, 10
		CALL READSTRING
		
		; Store book information in the books array (simplified - just store in memory for now)
		; The main storage will be in the file, so we'll skip the complex memory copying
		
		INC NUM_BOOKS
		
		; Write book data to BOOKS.txt file
		INVOKE CreateFile,
			ADDR BOOKS_FILE,    ; lpFileName
			GENERIC_WRITE,       ; dwDesiredAccess
			DO_NOT_SHARE,        ; dwShareMode
			NULL,                ; lpSecurityAttributes
			OPEN_ALWAYS,         ; dwCreationDisposition
			FILE_ATTRIBUTE_NORMAL, ; dwFlagsAndAttributes
			0                    ; hTemplateFile
		mov filehandle, eax

		; Move file pointer to end for appending
		INVOKE SetFilePointer, filehandle, 0, 0, FILE_END

		; Write book name
		mov edx, OFFSET BOOK_NAME_BUF
		INVOKE Str_length, edx
		cmp eax, 0
		je skip_name_write
		mov ecx, eax          ; length returned in EAX
		mov eax, filehandle
		call WriteToFile
		skip_name_write:

		; write comma separator
		mov eax, filehandle
		mov edx, OFFSET COMMA_BYTE
		mov ecx, 1
		call WriteToFile

		; write author
		mov edx, OFFSET BOOK_AUTHOR_BUF
		INVOKE Str_length, edx
		mov ecx, eax
		mov eax, filehandle
		call WriteToFile

		; write comma separator
		mov eax, filehandle
		mov edx, OFFSET COMMA_BYTE
		mov ecx, 1
		call WriteToFile

		; write publisher
		mov edx, OFFSET BOOK_PUBLISHER_BUF
		INVOKE Str_length, edx
		mov ecx, eax
		mov eax, filehandle
		call WriteToFile

		; write comma separator
		mov eax, filehandle
		mov edx, OFFSET COMMA_BYTE
		mov ecx, 1
		call WriteToFile

		; write genre
		mov edx, OFFSET BOOK_GENRE_BUF
		INVOKE Str_length, edx
		mov ecx, eax
		mov eax, filehandle
		call WriteToFile

		; write comma separator
		mov eax, filehandle
		mov edx, OFFSET COMMA_BYTE
		mov ecx, 1
		call WriteToFile

		; write year
		mov edx, OFFSET BOOK_YEAR_BUF
		INVOKE Str_length, edx
		mov ecx, eax
		mov eax, filehandle
		call WriteToFile

		; write comma separator
		mov eax, filehandle
		mov edx, OFFSET COMMA_BYTE
		mov ecx, 1
		call WriteToFile

		; write ISBN
		mov edx, OFFSET BOOK_ISBN_BUF
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

		; Display success message
		INVOKE MSG_DISPLAY, ADDR BOOK_ADDED_MSG
		
		JMP SHOW_FULL_MENU
		
	invalid_isbn:
		INVOKE MSG_DISPLAY, ADDR INVALID_ISBN_MSG
		JMP SHOW_FULL_MENU
;------------------------------------
;-------------VIEW BOOKS-------------
;------------------------------------
	VIEW_B:
	
	INVOKE MSG_DISPLAY, ADDR VIEW_BOOKS_MSG
	MOV ECX, NUM_BOOKS
	cmp ECX, 0
	JE SHOW_FULL_MENU
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
		
JMP SHOW_FULL_MENU
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
	; Read entire file into BUFFER_BOOK (use helper to ensure full file is read)
	CALL ReadAllBooks
	; Display each CSV line with labels: Name, Author, Publisher, Genre, Year, ISBN
	mov esi, OFFSET BUFFER_BOOK
	xor ebx, ebx                ; offset into buffer
	mov eax, DWORD PTR bytesRead
	cmp eax, 0
	je vb_done

vb_loop:
	mov eax, DWORD PTR bytesRead
	cmp ebx, eax
	jge vb_done

	; esi currently base; set esi_line to line start
	lea esi, [OFFSET BUFFER_BOOK]
	add esi, ebx               ; esi -> start of current line

	; find end of line (ecx = line length)
	xor ecx, ecx
vb_find_eol:
	mov al, [esi + ecx]
	cmp al, 0
	je vb_proc_line
	cmp al, 0Dh
	je vb_proc_line
	cmp al, 0Ah
	je vb_proc_line
	inc ecx
	jmp vb_find_eol
vb_proc_line:
	cmp ecx, 0
	je vb_advance_only

	; copy fields sequentially from esi into the named buffers
	; Field 1 -> BOOK_NAME_BUF
	mov edi, OFFSET BOOK_NAME_BUF
vb_copy_name:
	mov al, [esi]
	cmp al, ','
	je vb_name_done
	cmp al, 0Dh
	je vb_name_done
	cmp al, 0Ah
	je vb_name_done
	mov [edi], al
	inc edi
	inc esi
	jmp vb_copy_name
vb_name_done:
	mov byte ptr [edi], 0
	; skip comma if present
	cmp byte ptr [esi], ','
	jne vb_after_name
	inc esi
vb_after_name:

	; Field 2 -> BOOK_AUTHOR_BUF
	mov edi, OFFSET BOOK_AUTHOR_BUF
vb_copy_author:
	mov al, [esi]
	cmp al, ','
	je vb_author_done
	cmp al, 0Dh
	je vb_author_done
	cmp al, 0Ah
	je vb_author_done
	mov [edi], al
	inc edi
	inc esi
	jmp vb_copy_author
vb_author_done:
	mov byte ptr [edi], 0
	cmp byte ptr [esi], ','
	jne vb_after_author
	inc esi
vb_after_author:

	; Field 3 -> BOOK_PUBLISHER_BUF
	mov edi, OFFSET BOOK_PUBLISHER_BUF
vb_copy_publisher:
	mov al, [esi]
	cmp al, ','
	je vb_publisher_done
	cmp al, 0Dh
	je vb_publisher_done
	cmp al, 0Ah
	je vb_publisher_done
	mov [edi], al
	inc edi
	inc esi
	jmp vb_copy_publisher
vb_publisher_done:
	mov byte ptr [edi], 0
	cmp byte ptr [esi], ','
	jne vb_after_publisher
	inc esi
vb_after_publisher:

	; Field 4 -> BOOK_GENRE_BUF
	mov edi, OFFSET BOOK_GENRE_BUF
vb_copy_genre:
	mov al, [esi]
	cmp al, ','
	je vb_genre_done
	cmp al, 0Dh
	je vb_genre_done
	cmp al, 0Ah
	je vb_genre_done
	mov [edi], al
	inc edi
	inc esi
	jmp vb_copy_genre
vb_genre_done:
	mov byte ptr [edi], 0
	cmp byte ptr [esi], ','
	jne vb_after_genre
	inc esi
vb_after_genre:

	; Field 5 -> BOOK_YEAR_BUF
	mov edi, OFFSET BOOK_YEAR_BUF
vb_copy_year:
	mov al, [esi]
	cmp al, ','
	je vb_year_done
	cmp al, 0Dh
	je vb_year_done
	cmp al, 0Ah
	je vb_year_done
	mov [edi], al
	inc edi
	inc esi
	jmp vb_copy_year
vb_year_done:
	mov byte ptr [edi], 0
	cmp byte ptr [esi], ','
	jne vb_after_year
	inc esi
vb_after_year:

	; Field 6 -> BOOK_ISBN_BUF (rest of line)
	mov edi, OFFSET BOOK_ISBN_BUF
vb_copy_isbn:
	mov al, [esi]
	cmp al, 0Dh
	je vb_isbn_done
	cmp al, 0Ah
	je vb_isbn_done
	cmp al, 0
	je vb_isbn_done
	mov [edi], al
	inc edi
	inc esi
	jmp vb_copy_isbn
vb_isbn_done:
	mov byte ptr [edi], 0

	; Print nicely (spacing only) - header already printed before loop
	INVOKE MSG_DISPLAY, ADDR CRLF_BYTES

	; Print Name label and name - just print normally
	INVOKE MSG_DISPLAY, ADDR NAME_LABEL
	mov edx, OFFSET BOOK_NAME_BUF
	call WriteString
	call CRLF

	INVOKE MSG_DISPLAY, ADDR AUTHOR_LABEL
	mov edx, OFFSET BOOK_AUTHOR_BUF
	call WriteString
	call CRLF

	INVOKE MSG_DISPLAY, ADDR PUBLISHER_LABEL
	mov edx, OFFSET BOOK_PUBLISHER_BUF
	call WriteString
	call CRLF

	INVOKE MSG_DISPLAY, ADDR GENRE_LABEL
	mov edx, OFFSET BOOK_GENRE_BUF
	call WriteString
	call CRLF

	INVOKE MSG_DISPLAY, ADDR YEAR_LABEL
	mov edx, OFFSET BOOK_YEAR_BUF
	call WriteString
	call CRLF

	INVOKE MSG_DISPLAY, ADDR ISBN_LABEL
	mov edx, OFFSET BOOK_ISBN_BUF
	call WriteString
	call CRLF

	; compute new offset = esi - base
	mov eax, esi
	sub eax, OFFSET BUFFER_BOOK
	mov ebx, eax
	; skip CR/LF if present
	cmp byte ptr [OFFSET BUFFER_BOOK + ebx], 0Dh
	jne vb_loop_continue
	inc ebx
	cmp byte ptr [OFFSET BUFFER_BOOK + ebx], 0Ah
	jne vb_loop_continue
	inc ebx
vb_loop_continue:
	jmp vb_loop

vb_advance_only:
	; empty line - just skip
	lea eax, [OFFSET BUFFER_BOOK]
	add eax, ebx
	; advance by 1 (skip possible CR/LF)
	inc eax
	sub eax, OFFSET BUFFER_BOOK
	mov ebx, eax
	jmp vb_loop

vb_done:
	JMP SHOW_FULL_MENU

; Librarian menu functions (placeholders)
VIEW_OVERDUE_FUNC:
	; TODO: Implement view overdue books functionality
	INVOKE MSG_DISPLAY, ADDR CRLF_BYTES
	INVOKE MSG_DISPLAY, ADDR CRLF_BYTES
	JMP SHOW_FULL_MENU

CALCULATE_FINES_FUNC:
	; TODO: Implement calculate fines functionality
	INVOKE MSG_DISPLAY, ADDR CRLF_BYTES
	INVOKE MSG_DISPLAY, ADDR CRLF_BYTES
	JMP SHOW_FULL_MENU

; Member menu functions
SEARCH_BOOK_FUNC:
	; Display search menu and read option
	INVOKE MSG_DISPLAY, ADDR SEARCH_MENU_MSG
	CALL READINT ; input for options

	CMP EAX, SEARCH_BY_NAME
	JE SEARCH_BY_NAME_FUNC	; jump to Search By Name section
	CMP EAX, SEARCH_BY_AUTHOR
	JE SEARCH_BY_AUTHOR_FUNC	; jump to Search By Author section
	CMP EAX, SEARCH_BY_PUBLISHER
	JE SEARCH_BY_PUBLISHER_FUNC	; jump to Search By Publisher section
	CMP EAX, SEARCH_BY_YEAR
	JE SEARCH_BY_YEAR_FUNC	; jump to Search By Year section
	CMP EAX, SEARCH_BACK
	JE SHOW_MEMBER_MENU	; back -> return to member menu
	JMP SEARCH_BOOK_FUNC	; invalid option -> show search menu again

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
	; Display sort menu and handle selection
	INVOKE MSG_DISPLAY, ADDR SORT_MENU_MSG
	CALL READINT

	CMP EAX, 1
	JE SORT_NAME_ASC
	CMP EAX, 2
	JE SORT_NAME_DESC
	CMP EAX, 3
	JE SORT_AUTHOR_ASC
	CMP EAX, 4
	JE SORT_AUTHOR_DESC
	CMP EAX, 5
	JE SORT_PUB_ASC
	CMP EAX, 6
	JE SORT_PUB_DESC
	CMP EAX, 7
	JE SORT_YEAR_ASC
	CMP EAX, 8
	JE SORT_YEAR_DESC
	CMP EAX, 9
	JE SORT_ISBN_ASC
	CMP EAX, 10
	JE SORT_ISBN_DESC
	CMP EAX, 11
	JE SHOW_MEMBER_MENU

	; invalid option -> show sort menu again
	JMP VIEW_SORTED_FUNC

; Sort option handlers (stubs)
SORT_NAME_ASC:
    INVOKE MSG_DISPLAY, ADDR SORT_NAME_ASC_MSG
    JMP VIEW_SORTED_FUNC

SORT_NAME_DESC:
    INVOKE MSG_DISPLAY, ADDR SORT_NAME_DESC_MSG
    JMP VIEW_SORTED_FUNC

SORT_AUTHOR_ASC:
    INVOKE MSG_DISPLAY, ADDR SORT_AUTHOR_ASC_MSG
    JMP VIEW_SORTED_FUNC

SORT_AUTHOR_DESC:
    INVOKE MSG_DISPLAY, ADDR SORT_AUTHOR_DESC_MSG
    JMP VIEW_SORTED_FUNC

SORT_PUB_ASC:
    INVOKE MSG_DISPLAY, ADDR SORT_PUB_ASC_MSG
    JMP VIEW_SORTED_FUNC

SORT_PUB_DESC:
    INVOKE MSG_DISPLAY, ADDR SORT_PUB_DESC_MSG
    JMP VIEW_SORTED_FUNC

SORT_YEAR_ASC:
    INVOKE MSG_DISPLAY, ADDR SORT_YEAR_ASC_MSG
    JMP VIEW_SORTED_FUNC

SORT_YEAR_DESC:
    INVOKE MSG_DISPLAY, ADDR SORT_YEAR_DESC_MSG
    JMP VIEW_SORTED_FUNC

SORT_ISBN_ASC:
    INVOKE MSG_DISPLAY, ADDR SORT_ISBN_ASC_MSG
    JMP VIEW_SORTED_FUNC

SORT_ISBN_DESC:
    INVOKE MSG_DISPLAY, ADDR SORT_ISBN_DESC_MSG
    JMP VIEW_SORTED_FUNC

; Search menu functions (placeholders)
SEARCH_BY_NAME_FUNC:
	; Prompt for book name to search
	INVOKE MSG_DISPLAY, ADDR BOOK_NAME_PROMPT
	mov edx, OFFSET BOOK_NAME_BUF
	mov ecx, BOOK_NAME_SIZE
	CALL READSTRING

	; Open BOOKS.txt for reading
	INVOKE CreateFile, ADDR BOOKS_FILE, GENERIC_READ, DO_NOT_SHARE, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0
	mov filehandle, eax
	cmp eax, INVALID_HANDLE_VALUE
	je search_books_notfound

	; Read the whole file into BUFFER_BOOK
	CALL ReadAllBooks

	; check bytesRead
	mov eax, DWORD PTR bytesRead
	cmp eax, 0
	je search_books_notfound

	; Scan buffer line by line and match book name (first CSV field)
	xor ebx, ebx ; offset in buffer

search_name_loop_fixed:
	mov eax, DWORD PTR bytesRead
	cmp ebx, eax
	jge search_name_done_fixed

	; Calculate line start pointer (don't use ESI here, keep it safe)
	lea edi, [OFFSET BUFFER_BOOK + ebx]
	
	; Find line length
	xor ecx, ecx
find_eol_name_fixed:
	mov al, [edi + ecx]
	cmp al, 0
	je process_name_line_fixed
	cmp al, 0Dh
	je process_name_line_fixed
	cmp al, 0Ah
	je process_name_line_fixed
	inc ecx
	jmp find_eol_name_fixed

process_name_line_fixed:
	; Store line length on stack for later use
	push ecx
	
	cmp ecx, 0
	je advance_name_offset_fixed_pop

	; find comma index in edx (0..ecx-1)
	xor edx, edx
find_comma_name_fixed:
	cmp edx, ecx
	jge advance_name_offset_fixed_pop
	cmp byte ptr [edi + edx], ','
	je got_comma_name_fixed
	inc edx
	jmp find_comma_name_fixed

got_comma_name_fixed:
	; Save edx (field length) and copy first field into TEMP_FIELD
	push edx
	push edi
	
	; Source: current line start (edi)
	; Dest: TEMP_FIELD
	; Length: edx
	mov esi, edi
	mov edi, OFFSET TEMP_FIELD
	mov ecx, edx
copy_field_name_fixed:
	cmp ecx, 0
	je term_field_name_fixed
	mov al, [esi]
	mov [edi], al
	inc esi
	inc edi
	dec ecx
	jmp copy_field_name_fixed
term_field_name_fixed:
	mov byte ptr [edi], 0

	; Restore edi (line start pointer)
	pop edi
	pop edx
	
	; compare user input BOOK_NAME_BUF with TEMP_FIELD
	INVOKE Str_compare, ADDR BOOK_NAME_BUF, ADDR TEMP_FIELD
	jne continue_name_fixed

	; match -> parse and display with labels
	; Get line length from stack (don't pop yet)
	mov ecx, [esp]
	
	; Copy full line to TEMP_LINE
	push edi
	mov esi, edi
	mov edi, OFFSET TEMP_LINE
copy_line_to_temp_fixed:
	cmp ecx, 0
	je term_temp_line_fixed
	mov al, [esi]
	mov [edi], al
	inc esi
	inc edi
	dec ecx
	jmp copy_line_to_temp_fixed
term_temp_line_fixed:
	mov byte ptr [edi], 0
	pop edi
	
	; Display formatted output with labels
	mov edx, OFFSET TEMP_LINE
	call DisplayBookLine

continue_name_fixed:
	; Get line length from stack
	pop ecx
	
	; advance offset by lineLen and skip CR/LF
	add ebx, ecx
	
	; skip CR then LF if present
	cmp byte ptr [OFFSET BUFFER_BOOK + ebx], 0Dh
	jne skip_lf_name_fixed
	inc ebx
skip_lf_name_fixed:
	cmp byte ptr [OFFSET BUFFER_BOOK + ebx], 0Ah
	jne cont_loop_name_fixed
	inc ebx
cont_loop_name_fixed:
	jmp search_name_loop_fixed

advance_name_offset_fixed_pop:
	; Pop the line length we pushed earlier
	pop ecx
	
	; Skip this line
	add ebx, ecx
	cmp byte ptr [OFFSET BUFFER_BOOK + ebx], 0Dh
	jne skip_lf_name_fixed2
	inc ebx
skip_lf_name_fixed2:
	cmp byte ptr [OFFSET BUFFER_BOOK + ebx], 0Ah
	jne after_cr_name_fixed
	inc ebx
after_cr_name_fixed:
	jmp search_name_loop_fixed

search_name_done_fixed:
	JMP SEARCH_BOOK_FUNC

search_books_notfound:
	INVOKE MSG_DISPLAY, ADDR NO_BOOKS_MSG
	JMP SEARCH_BOOK_FUNC


SEARCH_BY_AUTHOR_FUNC:
	; Prompt for author name to search
	INVOKE MSG_DISPLAY, ADDR BOOK_AUTHOR_PROMPT
	mov edx, OFFSET BOOK_AUTHOR_BUF
	mov ecx, BOOK_AUTHOR_SIZE
	CALL READSTRING

	; Open BOOKS.txt
	INVOKE CreateFile, ADDR BOOKS_FILE, GENERIC_READ, DO_NOT_SHARE, NULL, OPEN_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0
	mov filehandle, eax
	cmp eax, INVALID_HANDLE_VALUE
	je search_books_notfound_author

	; Read the whole file into BUFFER_BOOK
	CALL ReadAllBooks

	mov eax, DWORD PTR bytesRead
	cmp eax, 0
	je search_books_notfound_author

	; Scan lines and compare second CSV field (author)
	xor ebx, ebx ; offset

search_author_loop:
	mov eax, DWORD PTR bytesRead
	cmp ebx, eax
	jge search_author_done

	; Calculate line start pointer
	lea edi, [OFFSET BUFFER_BOOK + ebx]
	
	; Find line length
	xor ecx, ecx
find_eol_author:
	mov al, [edi + ecx]
	cmp al, 0
	je process_author_line
	cmp al, 0Dh
	je process_author_line
	cmp al, 0Ah
	je process_author_line
	inc ecx
	jmp find_eol_author

process_author_line:
	; Store line length on stack
	push ecx
	
	cmp ecx, 0
	je advance_author_offset
	
	; Find first comma (end of book name field)
	xor edx, edx
find_first_comma_author:
	mov al, [edi + edx]
	cmp al, ','
	je got_first_comma_author
	cmp al, 0
	je no_author_field
	cmp al, 0Dh
	je no_author_field
	cmp al, 0Ah
	je no_author_field
	inc edx
	cmp edx, ecx
	jge no_author_field
	jmp find_first_comma_author
	
got_first_comma_author:
	inc edx ; edx now points to start of author field
	push edx ; save author field start position
	
	; Find end of author field (next comma or EOL)
	mov ebp, edx
find_end_author2:
	mov al, [edi + ebp]
	cmp al, 0
	je got_end_author2
	cmp al, 0Dh
	je got_end_author2
	cmp al, 0Ah
	je got_end_author2
	cmp al, ','
	je got_end_author2
	inc ebp
	jmp find_end_author2
	
got_end_author2:
	; Calculate author field length (ebp - edx)
	mov eax, ebp
	sub eax, edx
	cmp eax, 0
	jle restore_author_and_continue
	
	; Copy author field to TEMP_FIELD
	push edi
	push ebp
	
	lea esi, [edi + edx]  ; source = line start + author field offset
	mov edi, OFFSET TEMP_FIELD
	mov ecx, eax  ; length
copy_author_to_temp:
	cmp ecx, 0
	je term_author_temp
	mov al, [esi]
	mov [edi], al
	inc esi
	inc edi
	dec ecx
	jmp copy_author_to_temp
term_author_temp:
	mov byte ptr [edi], 0
	
	pop ebp
	pop edi
	
	; Compare with user input
	INVOKE Str_compare, ADDR BOOK_AUTHOR_BUF, ADDR TEMP_FIELD
	jne restore_author_and_continue
	
	; Match found - copy and display with labels
	mov ecx, [esp + 4]  ; get line length from stack (skip author field start)
	
	push edi
	lea esi, [OFFSET BUFFER_BOOK + ebx]
	mov edi, OFFSET TEMP_LINE
copy_line_author:
	cmp ecx, 0
	je term_temp_line_author
	mov al, [esi]
	mov [edi], al
	inc esi
	inc edi
	dec ecx
	jmp copy_line_author
term_temp_line_author:
	mov byte ptr [edi], 0
	pop edi
	
	mov edx, OFFSET TEMP_LINE
	call DisplayBookLine

restore_author_and_continue:
	; Clean up stack (author field start)
	pop edx
	; Get line length
	pop ecx
	
	; Advance offset by line length
	add ebx, ecx
	
	; Skip CR/LF
	cmp byte ptr [OFFSET BUFFER_BOOK + ebx], 0Dh
	jne skip_lf_author
	inc ebx
skip_lf_author:
	cmp byte ptr [OFFSET BUFFER_BOOK + ebx], 0Ah
	jne after_cr_author
	inc ebx
after_cr_author:
	jmp search_author_loop

advance_author_offset:
	; Pop line length
	pop ecx
	
	; Skip this line
	add ebx, ecx
	cmp byte ptr [OFFSET BUFFER_BOOK + ebx], 0Dh
	jne skip_lf_author2
	inc ebx
skip_lf_author2:
	cmp byte ptr [OFFSET BUFFER_BOOK + ebx], 0Ah
	jne after_cr_author2
	inc ebx
after_cr_author2:
	jmp search_author_loop

no_author_field:
	; Pop line length and skip line
	pop ecx
	add ebx, ecx
	cmp byte ptr [OFFSET BUFFER_BOOK + ebx], 0Dh
	jne skip_lf_author3
	inc ebx
skip_lf_author3:
	cmp byte ptr [OFFSET BUFFER_BOOK + ebx], 0Ah
	jne after_cr_author3
	inc ebx
after_cr_author3:
	jmp search_author_loop

search_author_done:
	JMP SEARCH_BOOK_FUNC

search_books_notfound_author:
	INVOKE MSG_DISPLAY, ADDR NO_BOOKS_MSG
	JMP SEARCH_BOOK_FUNC

SEARCH_BY_PUBLISHER_FUNC:
	; Prompt for publisher name to search
	INVOKE MSG_DISPLAY, ADDR BOOK_PUBLISHER_PROMPT
	mov edx, OFFSET BOOK_PUBLISHER_BUF
	mov ecx, BOOK_PUBLISHER_SIZE
	CALL READSTRING

	; Open BOOKS.txt
	INVOKE CreateFile, ADDR BOOKS_FILE, GENERIC_READ, DO_NOT_SHARE, NULL, OPEN_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0
	mov filehandle, eax
	cmp eax, INVALID_HANDLE_VALUE
	je search_books_notfound_publisher

	; Read the whole file into BUFFER_BOOK
	CALL ReadAllBooks

	mov eax, DWORD PTR bytesRead
	cmp eax, 0
	je search_books_notfound_publisher

	; Parse lines and match publisher (third CSV field)
	xor ebx, ebx

search_publisher_loop:
	mov eax, DWORD PTR bytesRead
	cmp ebx, eax
	jge search_publisher_done

	; Calculate line start
	lea edi, [OFFSET BUFFER_BOOK + ebx]
	
	; Find line length
	xor ecx, ecx
find_eol_publisher:
	mov al, [edi + ecx]
	cmp al, 0
	je process_publisher_line
	cmp al, 0Dh
	je process_publisher_line
	cmp al, 0Ah
	je process_publisher_line
	inc ecx
	jmp find_eol_publisher

process_publisher_line:
	; Store line length
	push ecx
	
	cmp ecx, 0
	je advance_publisher_offset

	; Find first comma (skip book name)
	xor edx, edx
find_first_comma_pub:
	mov al, [edi + edx]
	cmp al, ','
	je found_first_comma_pub
	cmp al, 0
	je no_publisher_field
	cmp al, 0Dh
	je no_publisher_field
	cmp al, 0Ah
	je no_publisher_field
	inc edx
	cmp edx, ecx
	jge no_publisher_field
	jmp find_first_comma_pub
	
found_first_comma_pub:
	inc edx
	
	; Find second comma (skip author)
find_second_comma_pub:
	mov al, [edi + edx]
	cmp al, ','
	je found_second_comma_pub
	cmp al, 0
	je no_publisher_field
	cmp al, 0Dh
	je no_publisher_field
	cmp al, 0Ah
	je no_publisher_field
	inc edx
	cmp edx, ecx
	jge no_publisher_field
	jmp find_second_comma_pub
	
found_second_comma_pub:
	inc edx ; edx now points to start of publisher field
	push edx
	
	; Find end of publisher field
	mov ebp, edx
find_end_publisher2:
	mov al, [edi + ebp]
	cmp al, 0
	je got_end_publisher2
	cmp al, 0Dh
	je got_end_publisher2
	cmp al, 0Ah
	je got_end_publisher2
	cmp al, ','
	je got_end_publisher2
	inc ebp
	jmp find_end_publisher2
	
got_end_publisher2:
	; Calculate publisher field length
	mov eax, ebp
	sub eax, edx
	cmp eax, 0
	jle restore_publisher_and_continue
	
	; Copy publisher to TEMP_FIELD
	push edi
	push ebp
	
	lea esi, [edi + edx]
	mov edi, OFFSET TEMP_FIELD
	mov ecx, eax
copy_publisher_to_temp:
	cmp ecx, 0
	je term_publisher_temp
	mov al, [esi]
	mov [edi], al
	inc esi
	inc edi
	dec ecx
	jmp copy_publisher_to_temp
term_publisher_temp:
	mov byte ptr [edi], 0
	
	pop ebp
	pop edi
	
	; Compare
	INVOKE Str_compare, ADDR BOOK_PUBLISHER_BUF, ADDR TEMP_FIELD
	jne restore_publisher_and_continue
	
	; Match - copy and display with labels
	mov ecx, [esp + 4]
	
	push edi
	lea esi, [OFFSET BUFFER_BOOK + ebx]
	mov edi, OFFSET TEMP_LINE
copy_line_pub:
	cmp ecx, 0
	je term_temp_line_pub
	mov al, [esi]
	mov [edi], al
	inc esi
	inc edi
	dec ecx
	jmp copy_line_pub
term_temp_line_pub:
	mov byte ptr [edi], 0
	pop edi
	
	mov edx, OFFSET TEMP_LINE
	call DisplayBookLine

restore_publisher_and_continue:
	pop edx
	pop ecx
	
	; Advance offset
	add ebx, ecx
	
	; Skip CR/LF
	cmp byte ptr [OFFSET BUFFER_BOOK + ebx], 0Dh
	jne skip_lf_publisher
	inc ebx
skip_lf_publisher:
	cmp byte ptr [OFFSET BUFFER_BOOK + ebx], 0Ah
	jne after_cr_publisher
	inc ebx
after_cr_publisher:
	jmp search_publisher_loop

advance_publisher_offset:
	pop ecx
	add ebx, ecx
	cmp byte ptr [OFFSET BUFFER_BOOK + ebx], 0Dh
	jne skip_lf_publisher2
	inc ebx
skip_lf_publisher2:
	cmp byte ptr [OFFSET BUFFER_BOOK + ebx], 0Ah
	jne after_cr_publisher2
	inc ebx
after_cr_publisher2:
	jmp search_publisher_loop

no_publisher_field:
	pop ecx
	add ebx, ecx
	cmp byte ptr [OFFSET BUFFER_BOOK + ebx], 0Dh
	jne skip_lf_publisher3
	inc ebx
skip_lf_publisher3:
	cmp byte ptr [OFFSET BUFFER_BOOK + ebx], 0Ah
	jne after_cr_publisher3
	inc ebx
after_cr_publisher3:
	jmp search_publisher_loop

search_publisher_done:
	JMP SEARCH_BOOK_FUNC

search_books_notfound_publisher:
	INVOKE MSG_DISPLAY, ADDR NO_BOOKS_MSG
	JMP SEARCH_BOOK_FUNC

SEARCH_BY_YEAR_FUNC:
	; Prompt for year to search
	INVOKE MSG_DISPLAY, ADDR BOOK_YEAR_PROMPT
	mov edx, OFFSET BOOK_YEAR_BUF
	mov ecx, 10
	CALL READSTRING

	; Open BOOKS.txt
	INVOKE CreateFile, ADDR BOOKS_FILE, GENERIC_READ, DO_NOT_SHARE, NULL, OPEN_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0
	mov filehandle, eax
	cmp eax, INVALID_HANDLE_VALUE
	je search_books_notfound_year

	; Read the whole file into BUFFER_BOOK
	CALL ReadAllBooks

	mov eax, DWORD PTR bytesRead
	cmp eax, 0
	je search_books_notfound_year

	; Parse lines and match year (fifth CSV field; name,author,publisher,genre,year,isbn)
	xor ebx, ebx

search_year_loop:
	mov eax, DWORD PTR bytesRead
	cmp ebx, eax
	jge search_year_done

	; Calculate line start
	lea edi, [OFFSET BUFFER_BOOK + ebx]
	
	; Find line length
	xor ecx, ecx
find_eol_year:
	mov al, [edi + ecx]
	cmp al, 0
	je process_year_line
	cmp al, 0Dh
	je process_year_line
	cmp al, 0Ah
	je process_year_line
	inc ecx
	jmp find_eol_year

process_year_line:
	; Store line length
	push ecx
	
	cmp ecx, 0
	je advance_year_offset

	; Find the start of 5th field (year) by counting 4 commas
	xor edx, edx  ; index
	xor ebp, ebp  ; comma count

find_year_field:
	mov al, [edi + edx]
	cmp al, 0
	je no_year_field
	cmp al, 0Dh
	je no_year_field
	cmp al, 0Ah
	je no_year_field
	cmp al, ','
	jne skip_comma_year
	inc ebp
	cmp ebp, 4
	je year_field_start
skip_comma_year:
	inc edx
	cmp edx, ecx
	jge no_year_field
	jmp find_year_field

year_field_start:
	inc edx  ; move past the 4th comma
	push edx
	
	; Find end of year field
	mov ebp, edx
find_end_year2:
	mov al, [edi + ebp]
	cmp al, 0
	je got_end_year2
	cmp al, 0Dh
	je got_end_year2
	cmp al, 0Ah
	je got_end_year2
	cmp al, ','
	je got_end_year2
	inc ebp
	jmp find_end_year2
	
got_end_year2:
	; Calculate year field length
	mov eax, ebp
	sub eax, edx
	cmp eax, 0
	jle restore_year_and_continue
	
	; Copy year to TEMP_FIELD
	push edi
	push ebp
	
	lea esi, [edi + edx]
	mov edi, OFFSET TEMP_FIELD
	mov ecx, eax
copy_year_to_temp:
	cmp ecx, 0
	je term_year_temp
	mov al, [esi]
	mov [edi], al
	inc esi
	inc edi
	dec ecx
	jmp copy_year_to_temp
term_year_temp:
	mov byte ptr [edi], 0
	
	pop ebp
	pop edi
	
	; Compare
	INVOKE Str_compare, ADDR BOOK_YEAR_BUF, ADDR TEMP_FIELD
	jne restore_year_and_continue
	
	; Match - copy and display with labels
	mov ecx, [esp + 4]
	
	push edi
	lea esi, [OFFSET BUFFER_BOOK + ebx]
	mov edi, OFFSET TEMP_LINE
copy_line_year:
	cmp ecx, 0
	je term_temp_line_year
	mov al, [esi]
	mov [edi], al
	inc esi
	inc edi
	dec ecx
	jmp copy_line_year
term_temp_line_year:
	mov byte ptr [edi], 0
	pop edi
	
	mov edx, OFFSET TEMP_LINE
	call DisplayBookLine

restore_year_and_continue:
	pop edx
	pop ecx
	
	; Advance offset
	add ebx, ecx
	
	; Skip CR/LF
	cmp byte ptr [OFFSET BUFFER_BOOK + ebx], 0Dh
	jne skip_lf_year
	inc ebx
skip_lf_year:
	cmp byte ptr [OFFSET BUFFER_BOOK + ebx], 0Ah
	jne after_cr_year
	inc ebx
after_cr_year:
	jmp search_year_loop

advance_year_offset:
	pop ecx
	add ebx, ecx
	cmp byte ptr [OFFSET BUFFER_BOOK + ebx], 0Dh
	jne skip_lf_year2
	inc ebx
skip_lf_year2:
	cmp byte ptr [OFFSET BUFFER_BOOK + ebx], 0Ah
	jne after_cr_year2
	inc ebx
after_cr_year2:
	jmp search_year_loop

no_year_field:
	pop ecx
	add ebx, ecx
	cmp byte ptr [OFFSET BUFFER_BOOK + ebx], 0Dh
	jne skip_lf_year3
	inc ebx
skip_lf_year3:
	cmp byte ptr [OFFSET BUFFER_BOOK + ebx], 0Ah
	jne after_cr_year3
	inc ebx
after_cr_year3:
	jmp search_year_loop

search_year_done:
	JMP SEARCH_BOOK_FUNC

search_books_notfound_year:
	INVOKE MSG_DISPLAY, ADDR NO_BOOKS_MSG
	JMP SEARCH_BOOK_FUNC

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

; ReadAllBooks - helper to read entire BOOKS.txt into BUFFER_BOOK
; Expects: filehandle contains an open handle to BOOKS.txt
; Returns: bytesRead (dword variable) updated; buffer null-terminated
ReadAllBooks PROC
	; preserve registers
	pushad

	; get file size (low dword)
	INVOKE SetFilePointer, filehandle, 0, 0, FILE_END
	mov esi, eax            ; esi = file size low

	; move file pointer back to beginning
	INVOKE SetFilePointer, filehandle, 0, 0, FILE_BEGIN

	; limit to BUFFER_SIZE-1 to leave space for terminating NUL
	mov eax, BUFFER_SIZE
	dec eax
	cmp esi, eax
	jle size_ok
	mov esi, eax
size_ok:

	; Read file (esi bytes) into BUFFER_BOOK
	INVOKE ReadFile, filehandle, ADDR BUFFER_BOOK, esi, ADDR bytesRead, 0

	; close handle
	invoke CloseHandle, filehandle

	; null-terminate buffer at bytesRead
	mov eax, DWORD PTR bytesRead
	lea edi, [OFFSET BUFFER_BOOK]
	add edi, eax
	mov byte ptr [edi], 0

	popad
	ret
ReadAllBooks ENDP

; DisplayBookLine - helper to parse and display a CSV book line with labels
; Expects: EDX = pointer to null-terminated CSV line
; Modifies: book buffers and displays formatted output
DisplayBookLine PROC
	push eax
	push ebx
	push ecx
	push edx
	push esi
	push edi

	; Clear all book buffers first
	mov edi, OFFSET BOOK_NAME_BUF
	mov ecx, BOOK_NAME_SIZE
	xor al, al
dbl_clear_name:
	mov [edi], al
	inc edi
	loop dbl_clear_name
	
	mov edi, OFFSET BOOK_AUTHOR_BUF
	mov ecx, BOOK_AUTHOR_SIZE
dbl_clear_author:
	mov [edi], al
	inc edi
	loop dbl_clear_author
	
	mov edi, OFFSET BOOK_PUBLISHER_BUF
	mov ecx, BOOK_PUBLISHER_SIZE
dbl_clear_pub:
	mov [edi], al
	inc edi
	loop dbl_clear_pub
	
	mov edi, OFFSET BOOK_GENRE_BUF
	mov ecx, BOOK_GENRE_SIZE
dbl_clear_genre:
	mov [edi], al
	inc edi
	loop dbl_clear_genre
	
	mov edi, OFFSET BOOK_YEAR_BUF
	mov ecx, 10
dbl_clear_year:
	mov [edi], al
	inc edi
	loop dbl_clear_year
	
	mov edi, OFFSET BOOK_ISBN_BUF
	mov ecx, 20
dbl_clear_isbn:
	mov [edi], al
	inc edi
	loop dbl_clear_isbn

	; Parse CSV line (EDX points to line)
	mov esi, edx
	
	; Field 1 -> BOOK_NAME_BUF
	mov edi, OFFSET BOOK_NAME_BUF
dbl_copy_name:
	mov al, [esi]
	cmp al, ','
	je dbl_name_done
	cmp al, 0
	je dbl_name_done
	mov [edi], al
	inc edi
	inc esi
	jmp dbl_copy_name
dbl_name_done:
	mov byte ptr [edi], 0
	cmp byte ptr [esi], ','
	jne dbl_after_name
	inc esi
dbl_after_name:

	; Field 2 -> BOOK_AUTHOR_BUF
	mov edi, OFFSET BOOK_AUTHOR_BUF
dbl_copy_author:
	mov al, [esi]
	cmp al, ','
	je dbl_author_done
	cmp al, 0
	je dbl_author_done
	mov [edi], al
	inc edi
	inc esi
	jmp dbl_copy_author
dbl_author_done:
	mov byte ptr [edi], 0
	cmp byte ptr [esi], ','
	jne dbl_after_author
	inc esi
dbl_after_author:

	; Field 3 -> BOOK_PUBLISHER_BUF
	mov edi, OFFSET BOOK_PUBLISHER_BUF
dbl_copy_publisher:
	mov al, [esi]
	cmp al, ','
	je dbl_publisher_done
	cmp al, 0
	je dbl_publisher_done
	mov [edi], al
	inc edi
	inc esi
	jmp dbl_copy_publisher
dbl_publisher_done:
	mov byte ptr [edi], 0
	cmp byte ptr [esi], ','
	jne dbl_after_publisher
	inc esi
dbl_after_publisher:

	; Field 4 -> BOOK_GENRE_BUF
	mov edi, OFFSET BOOK_GENRE_BUF
dbl_copy_genre:
	mov al, [esi]
	cmp al, ','
	je dbl_genre_done
	cmp al, 0
	je dbl_genre_done
	mov [edi], al
	inc edi
	inc esi
	jmp dbl_copy_genre
dbl_genre_done:
	mov byte ptr [edi], 0
	cmp byte ptr [esi], ','
	jne dbl_after_genre
	inc esi
dbl_after_genre:

	; Field 5 -> BOOK_YEAR_BUF
	mov edi, OFFSET BOOK_YEAR_BUF
dbl_copy_year:
	mov al, [esi]
	cmp al, ','
	je dbl_year_done
	cmp al, 0
	je dbl_year_done
	mov [edi], al
	inc edi
	inc esi
	jmp dbl_copy_year
dbl_year_done:
	mov byte ptr [edi], 0
	cmp byte ptr [esi], ','
	jne dbl_after_year
	inc esi
dbl_after_year:

	; Field 6 -> BOOK_ISBN_BUF
	mov edi, OFFSET BOOK_ISBN_BUF
dbl_copy_isbn:
	mov al, [esi]
	cmp al, 0
	je dbl_isbn_done
	mov [edi], al
	inc edi
	inc esi
	jmp dbl_copy_isbn
dbl_isbn_done:
	mov byte ptr [edi], 0

	; Display with labels
	INVOKE MSG_DISPLAY, ADDR CRLF_BYTES
	
	INVOKE MSG_DISPLAY, ADDR NAME_LABEL
	mov edx, OFFSET BOOK_NAME_BUF
	call WriteString
	call CRLF

	INVOKE MSG_DISPLAY, ADDR AUTHOR_LABEL
	mov edx, OFFSET BOOK_AUTHOR_BUF
	call WriteString
	call CRLF

	INVOKE MSG_DISPLAY, ADDR PUBLISHER_LABEL
	mov edx, OFFSET BOOK_PUBLISHER_BUF
	call WriteString
	call CRLF

	INVOKE MSG_DISPLAY, ADDR GENRE_LABEL
	mov edx, OFFSET BOOK_GENRE_BUF
	call WriteString
	call CRLF

	INVOKE MSG_DISPLAY, ADDR YEAR_LABEL
	mov edx, OFFSET BOOK_YEAR_BUF
	call WriteString
	call CRLF

	INVOKE MSG_DISPLAY, ADDR ISBN_LABEL
	mov edx, OFFSET BOOK_ISBN_BUF
	call WriteString
	call CRLF

	pop edi
	pop esi
	pop edx
	pop ecx
	pop ebx
	pop eax
	ret
DisplayBookLine ENDP

end main