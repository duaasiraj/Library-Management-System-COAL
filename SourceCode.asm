
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

MEMBER_MENU_MSG BYTE 0Ah, "1-> Sign In",0dh,0ah, "2-> Register",0dh,0ah, "Choose Your Option : ",0

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

; Search input buffers
SEARCH_INPUT_BUF BYTE 100 DUP(?)
SEARCH_RESULTS_MSG BYTE 0Ah, "Search Results:",0dh,0ah,0
NO_RESULTS_MSG BYTE 0Ah, "No books found matching your search.",0dh,0ah,0
SEARCH_PROMPT_MSG BYTE "Enter search term: ",0

; Improved search variables
TEMP_LINE BYTE 500 DUP(?)
FIELD_BUF BYTE 200 DUP(?)
FOUND DWORD 0
SEARCH_NAME_MSG BYTE "Enter book name to search: ",0
SEARCH_AUTHOR_MSG BYTE "Enter author name to search: ",0
SEARCH_PUBLISHER_MSG BYTE "Enter publisher name to search: ",0
SEARCH_YEAR_MSG BYTE "Enter year to search: ",0

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
	JE VIEW_B		; jump to Display All Books section
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

; Search menu functions - ROBUST IMPLEMENTATION
SEARCH_BY_NAME_FUNC:
	; Prompt for search term
	INVOKE MSG_DISPLAY, ADDR SEARCH_NAME_MSG
	mov edx, OFFSET SEARCH_INPUT_BUF
	mov ecx, 100
	CALL READSTRING
	
	; Convert to uppercase for case-insensitive search
	INVOKE Str_ucase, ADDR SEARCH_INPUT_BUF
	
	; Clear buffer before reuse
	mov ecx, BUFFER_SIZE
	mov edi, OFFSET BUFFER_BOOK
	mov al, 0
	rep stosb
	
	; Open BOOKS.txt for reading
	INVOKE CreateFile, ADDR BOOKS_FILE, GENERIC_READ, DO_NOT_SHARE, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0
	cmp eax, INVALID_HANDLE_VALUE
	je search_name_error
	mov filehandle, eax
	
	; Read file into buffer
	invoke ReadFile, filehandle, ADDR BUFFER_BOOK, BUFFER_SIZE, ADDR bytesRead, 0
	invoke CloseHandle, filehandle
	
	; Check if file is empty
	mov eax, DWORD PTR bytesRead
	cmp eax, 0
	je search_name_no_results
	
	; Display search results header
	INVOKE MSG_DISPLAY, ADDR SEARCH_RESULTS_MSG
	
	; Initialize search variables
	mov esi, OFFSET BUFFER_BOOK
	mov FOUND, 0
	
next_line_name:
	cmp byte ptr [esi], 0
	je done_search_name
	
	; Copy one line to temp buffer
	mov edi, OFFSET TEMP_LINE
copy_line_name:
	lodsb
	cmp al, 0Dh
	je end_line_name
	cmp al, 0Ah
	je end_line_name
	cmp al, 0
	je end_line_name
	stosb
	jmp copy_line_name
	
end_line_name:
	mov byte ptr [edi], 0
	
	; Parse first field (book name) - simple approach
	mov esi, OFFSET TEMP_LINE
	mov edi, OFFSET FIELD_BUF
	mov ecx, 0
copy_book_name:
	mov al, [esi + ecx]
	cmp al, ','
	je name_done
	cmp al, 0
	je name_done
	mov [edi + ecx], al
	inc ecx
	jmp copy_book_name
name_done:
	mov byte ptr [edi + ecx], 0
	
	; Convert to uppercase and check for exact match
	INVOKE Str_ucase, ADDR FIELD_BUF
	INVOKE Str_compare, ADDR FIELD_BUF, ADDR SEARCH_INPUT_BUF
	cmp eax, 0
	jne skip_print_name
	
	; Match found - display the entire book line
	mov edx, OFFSET TEMP_LINE
	call WriteString
	call Crlf
	mov FOUND, 1
	
skip_print_name:
	cmp byte ptr [esi], 0
	je done_search_name
	
	; Skip CR/LF
	cmp byte ptr [esi], 0Dh
	jne cont_name
	inc esi
	cmp byte ptr [esi], 0Ah
	jne cont_name
	inc esi
cont_name:
	jmp next_line_name
	
done_search_name:
	cmp FOUND, 0
	jne exit_search_name
	INVOKE MSG_DISPLAY, ADDR NO_RESULTS_MSG
	
exit_search_name:
	JMP SEARCH_BOOK_FUNC
	
search_name_no_results:
	INVOKE MSG_DISPLAY, ADDR NO_RESULTS_MSG
	JMP SEARCH_BOOK_FUNC
	
search_name_error:
	INVOKE MSG_DISPLAY, ADDR NO_RESULTS_MSG
	JMP SEARCH_BOOK_FUNC

SEARCH_BY_AUTHOR_FUNC:
	; Prompt for search term
	INVOKE MSG_DISPLAY, ADDR SEARCH_AUTHOR_MSG
	mov edx, OFFSET SEARCH_INPUT_BUF
	mov ecx, 100
	CALL READSTRING
	
	; Convert to uppercase for case-insensitive search
	INVOKE Str_ucase, ADDR SEARCH_INPUT_BUF
	
	; Clear buffer before reuse
	mov ecx, BUFFER_SIZE
	mov edi, OFFSET BUFFER_BOOK
	mov al, 0
	rep stosb
	
	; Open BOOKS.txt for reading
	INVOKE CreateFile, ADDR BOOKS_FILE, GENERIC_READ, DO_NOT_SHARE, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0
	cmp eax, INVALID_HANDLE_VALUE
	je search_author_error
	mov filehandle, eax
	
	; Read file into buffer
	invoke ReadFile, filehandle, ADDR BUFFER_BOOK, BUFFER_SIZE, ADDR bytesRead, 0
	invoke CloseHandle, filehandle
	
	; Check if file is empty
	mov eax, DWORD PTR bytesRead
	cmp eax, 0
	je search_author_no_results
	
	; Display search results header
	INVOKE MSG_DISPLAY, ADDR SEARCH_RESULTS_MSG
	
	; Initialize search variables
	mov esi, OFFSET BUFFER_BOOK
	mov FOUND, 0
	
next_line_author:
	cmp byte ptr [esi], 0
	je done_search_author
	
	; Copy one line to temp buffer
	mov edi, OFFSET TEMP_LINE
copy_line_author:
	lodsb
	cmp al, 0Dh
	je end_line_author
	cmp al, 0Ah
	je end_line_author
	cmp al, 0
	je end_line_author
	stosb
	jmp copy_line_author
	
end_line_author:
	mov byte ptr [edi], 0
	
	; Parse author (2nd field) - simple approach
	mov esi, OFFSET TEMP_LINE
	mov edi, OFFSET FIELD_BUF
	mov ecx, 0
	mov edx, 0  ; comma counter
	
find_author_start:
	mov al, [esi + ecx]
	cmp al, ','
	je found_first_comma
	cmp al, 0
	je next_line_author
	inc ecx
	jmp find_author_start
	
found_first_comma:
	inc ecx  ; move past first comma
	mov ebx, 0  ; counter for author field
	
copy_author_field:
	mov al, [esi + ecx]
	cmp al, ','
	je author_done
	cmp al, 0
	je author_done
	mov [edi + ebx], al
	inc ecx
	inc ebx
	jmp copy_author_field
	
author_done:
	mov byte ptr [edi + ebx], 0
	
	; Convert to uppercase and check for exact match
	INVOKE Str_ucase, ADDR FIELD_BUF
	INVOKE Str_compare, ADDR FIELD_BUF, ADDR SEARCH_INPUT_BUF
	cmp eax, 0
	jne skip_print_author
	
	; Match found - display the entire book line
	mov edx, OFFSET TEMP_LINE
	call WriteString
	call Crlf
	mov FOUND, 1
	
skip_print_author:
	cmp byte ptr [esi], 0
	je done_search_author
	
	; Skip CR/LF
	cmp byte ptr [esi], 0Dh
	jne cont_author
	inc esi
	cmp byte ptr [esi], 0Ah
	jne cont_author
	inc esi
cont_author:
	jmp next_line_author
	
done_search_author:
	cmp FOUND, 0
	jne exit_search_author
	INVOKE MSG_DISPLAY, ADDR NO_RESULTS_MSG
	
exit_search_author:
	JMP SEARCH_BOOK_FUNC
	
search_author_no_results:
	INVOKE MSG_DISPLAY, ADDR NO_RESULTS_MSG
	JMP SEARCH_BOOK_FUNC
	
search_author_error:
	INVOKE MSG_DISPLAY, ADDR NO_RESULTS_MSG
	JMP SEARCH_BOOK_FUNC

SEARCH_BY_PUBLISHER_FUNC:
	; Prompt for search term
	INVOKE MSG_DISPLAY, ADDR SEARCH_PUBLISHER_MSG
	mov edx, OFFSET SEARCH_INPUT_BUF
	mov ecx, 100
	CALL READSTRING
	
	; Convert to uppercase for case-insensitive search
	INVOKE Str_ucase, ADDR SEARCH_INPUT_BUF
	
	; Clear buffer before reuse
	mov ecx, BUFFER_SIZE
	mov edi, OFFSET BUFFER_BOOK
	mov al, 0
	rep stosb
	
	; Open BOOKS.txt for reading
	INVOKE CreateFile, ADDR BOOKS_FILE, GENERIC_READ, DO_NOT_SHARE, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0
	cmp eax, INVALID_HANDLE_VALUE
	je search_publisher_error
	mov filehandle, eax
	
	; Read file into buffer
	invoke ReadFile, filehandle, ADDR BUFFER_BOOK, BUFFER_SIZE, ADDR bytesRead, 0
	invoke CloseHandle, filehandle
	
	; Check if file is empty
	mov eax, DWORD PTR bytesRead
	cmp eax, 0
	je search_publisher_no_results
	
	; Display search results header
	INVOKE MSG_DISPLAY, ADDR SEARCH_RESULTS_MSG
	
	; Initialize search variables
	mov esi, OFFSET BUFFER_BOOK
	mov FOUND, 0
	
next_line_publisher:
	cmp byte ptr [esi], 0
	je done_search_publisher
	
	; Copy one line to temp buffer
	mov edi, OFFSET TEMP_LINE
copy_line_publisher:
	lodsb
	cmp al, 0Dh
	je end_line_publisher
	cmp al, 0Ah
	je end_line_publisher
	cmp al, 0
	je end_line_publisher
	stosb
	jmp copy_line_publisher
	
end_line_publisher:
	mov byte ptr [edi], 0
	
	; Parse publisher (3rd field) - simple approach
	mov esi, OFFSET TEMP_LINE
	mov edi, OFFSET FIELD_BUF
	mov ecx, 0
	mov edx, 0  ; comma counter
	
find_publisher_start:
	mov al, [esi + ecx]
	cmp al, ','
	je found_comma_publisher
	cmp al, 0
	je next_line_publisher
	inc ecx
	jmp find_publisher_start
	
found_comma_publisher:
	inc edx
	cmp edx, 2  ; we want the 3rd field, so skip 2 commas
	jne continue_publisher_search
	; Found 2nd comma, now copy until 3rd comma
	inc ecx
	mov ebx, 0  ; counter for publisher field
	
copy_publisher_field:
	mov al, [esi + ecx]
	cmp al, ','
	je publisher_done
	cmp al, 0
	je publisher_done
	mov [edi + ebx], al
	inc ecx
	inc ebx
	jmp copy_publisher_field
	
continue_publisher_search:
	inc ecx
	jmp find_publisher_start
	
publisher_done:
	mov byte ptr [edi + ebx], 0
	
	; Convert to uppercase and check for exact match
	INVOKE Str_ucase, ADDR FIELD_BUF
	INVOKE Str_compare, ADDR FIELD_BUF, ADDR SEARCH_INPUT_BUF
	cmp eax, 0
	jne skip_print_publisher
	
	; Match found - display the entire book line
	mov edx, OFFSET TEMP_LINE
	call WriteString
	call Crlf
	mov FOUND, 1
	
skip_print_publisher:
	cmp byte ptr [esi], 0
	je done_search_publisher
	
	; Skip CR/LF
	cmp byte ptr [esi], 0Dh
	jne cont_publisher
	inc esi
	cmp byte ptr [esi], 0Ah
	jne cont_publisher
	inc esi
cont_publisher:
	jmp next_line_publisher
	
done_search_publisher:
	cmp FOUND, 0
	jne exit_search_publisher
	INVOKE MSG_DISPLAY, ADDR NO_RESULTS_MSG
	
exit_search_publisher:
	JMP SEARCH_BOOK_FUNC
	
search_publisher_no_results:
	INVOKE MSG_DISPLAY, ADDR NO_RESULTS_MSG
	JMP SEARCH_BOOK_FUNC
	
search_publisher_error:
	INVOKE MSG_DISPLAY, ADDR NO_RESULTS_MSG
	JMP SEARCH_BOOK_FUNC

SEARCH_BY_YEAR_FUNC:
	; Prompt for search term
	INVOKE MSG_DISPLAY, ADDR SEARCH_YEAR_MSG
	mov edx, OFFSET SEARCH_INPUT_BUF
	mov ecx, 100
	CALL READSTRING
	
	; Convert to uppercase for case-insensitive search
	INVOKE Str_ucase, ADDR SEARCH_INPUT_BUF
	
	; Clear buffer before reuse
	mov ecx, BUFFER_SIZE
	mov edi, OFFSET BUFFER_BOOK
	mov al, 0
	rep stosb
	
	; Open BOOKS.txt for reading
	INVOKE CreateFile, ADDR BOOKS_FILE, GENERIC_READ, DO_NOT_SHARE, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0
	cmp eax, INVALID_HANDLE_VALUE
	je search_year_error
	mov filehandle, eax
	
	; Read file into buffer
	invoke ReadFile, filehandle, ADDR BUFFER_BOOK, BUFFER_SIZE, ADDR bytesRead, 0
	invoke CloseHandle, filehandle
	
	; Check if file is empty
	mov eax, DWORD PTR bytesRead
	cmp eax, 0
	je search_year_no_results
	
	; Display search results header
	INVOKE MSG_DISPLAY, ADDR SEARCH_RESULTS_MSG
	
	; Initialize search variables
	mov esi, OFFSET BUFFER_BOOK
	mov FOUND, 0
	
next_line_year:
	cmp byte ptr [esi], 0
	je done_search_year
	
	; Copy one line to temp buffer
	mov edi, OFFSET TEMP_LINE
copy_line_year:
	lodsb
	cmp al, 0Dh
	je end_line_year
	cmp al, 0Ah
	je end_line_year
	cmp al, 0
	je end_line_year
	stosb
	jmp copy_line_year
	
end_line_year:
	mov byte ptr [edi], 0
	
	; Parse year (5th field) - simple approach
	mov esi, OFFSET TEMP_LINE
	mov edi, OFFSET FIELD_BUF
	mov ecx, 0
	mov edx, 0  ; comma counter
	
find_year_start:
	mov al, [esi + ecx]
	cmp al, ','
	je found_comma_year
	cmp al, 0
	je next_line_year
	inc ecx
	jmp find_year_start
	
found_comma_year:
	inc edx
	cmp edx, 4  ; we want the 5th field, so skip 4 commas
	jne continue_year_search
	; Found 4th comma, now copy until 5th comma
	inc ecx
	mov ebx, 0  ; counter for year field
	
copy_year_field:
	mov al, [esi + ecx]
	cmp al, ','
	je year_done
	cmp al, 0
	je year_done
	mov [edi + ebx], al
	inc ecx
	inc ebx
	jmp copy_year_field
	
continue_year_search:
	inc ecx
	jmp find_year_start
	
year_done:
	mov byte ptr [edi + ebx], 0
	
	; Convert to uppercase and check for exact match
	INVOKE Str_ucase, ADDR FIELD_BUF
	INVOKE Str_compare, ADDR FIELD_BUF, ADDR SEARCH_INPUT_BUF
	cmp eax, 0
	jne skip_print_year
	
	; Match found - display the entire book line
	mov edx, OFFSET TEMP_LINE
	call WriteString
	call Crlf
	mov FOUND, 1
	
skip_print_year:
	cmp byte ptr [esi], 0
	je done_search_year
	
	; Skip CR/LF
	cmp byte ptr [esi], 0Dh
	jne cont_year
	inc esi
	cmp byte ptr [esi], 0Ah
	jne cont_year
	inc esi
cont_year:
	jmp next_line_year
	
done_search_year:
	cmp FOUND, 0
	jne exit_search_year
	INVOKE MSG_DISPLAY, ADDR NO_RESULTS_MSG
	
exit_search_year:
	JMP SEARCH_BOOK_FUNC
	
search_year_no_results:
	INVOKE MSG_DISPLAY, ADDR NO_RESULTS_MSG
	JMP SEARCH_BOOK_FUNC
	
search_year_error:
	INVOKE MSG_DISPLAY, ADDR NO_RESULTS_MSG
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
end main