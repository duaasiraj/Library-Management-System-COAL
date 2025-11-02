
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
	BYTE    "6. View Issued Books", 0dh, 0ah
	BYTE    "7. Logout", 0dh, 0ah
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
OVERDUE_BOOKS_HEADER BYTE 0Ah, "========== OVERDUE BOOKS ==========",0dh,0ah,0
NO_OVERDUE_MSG BYTE 0Ah, "No overdue books found.",0dh,0ah,0
ISSUED_BOOKS_HEADER BYTE 0Ah, "========== ISSUED BOOKS ==========",0dh,0ah,0
NO_ISSUED_MSG BYTE 0Ah, "No books are currently issued.",0dh,0ah,0
OVERDUE_SEPARATOR BYTE "-----------------------------------",0dh,0ah,0
USERNAME_LABEL BYTE "Username: ",0
ISSUE_DATE_LABEL BYTE "Issue Date: ",0
RETURN_DATE_LABEL BYTE "Return Date: ",0
FINES_HEADER BYTE 0Ah, "========== CALCULATE FINES ==========",0dh,0ah,0
DAYS_OVERDUE_LABEL BYTE "Days Overdue: ",0
FINE_AMOUNT_LABEL BYTE "Fine Amount: Rs. ",0
TOTAL_FINE_LABEL BYTE 0Ah, "Total Fines: Rs. ",0
NO_FINES_MSG BYTE 0Ah, "No fine to collect for this book. Book not found or returned on time!",0dh,0ah,0
FINE_RATE_MSG BYTE "(Fine rate: Rs. 10 per day)",0dh,0ah,0

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
					
	CRLF_BYTES BYTE 0Dh,0Ah,0
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
ISSUED_BOOKS_FILE BYTE "ISSUED_BOOKS.txt",0
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
VIEW_ISSUED_BOOKS DWORD 6
LIB_LOGOUT	 DWORD 7

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

; Issue/Return book messages
ISSUE_BOOK_MSG BYTE 0Ah, "Issue Book",0dh,0ah, "Enter ISBN of book to issue: ",0
RETURN_BOOK_MSG BYTE 0Ah, "Return Book",0dh,0ah, "Enter ISBN of book to return: ",0
BOOK_NOT_FOUND_MSG BYTE "Book not found in library.",0dh,0ah,0
BOOK_ISSUED_SUCCESS_MSG BYTE "Book issued successfully!",0dh,0ah,0
BOOK_ALREADY_ISSUED_MSG BYTE "This book is already issued.",0dh,0ah,0
BOOK_RETURNED_SUCCESS_MSG BYTE "Book returned successfully!",0dh,0ah,0
BOOK_NOT_ISSUED_MSG BYTE "This book was not issued to any member.",0dh,0ah,0
BOOK_LIMIT_REACHED_MSG BYTE "You have reached the maximum limit of 5 issued books.",0dh,0ah, "Please return a book before issuing a new one.",0dh,0ah,0

; ISBN search buffer
ISBN_SEARCH_BUF DB 20 DUP(?)

; Date buffer for issue/return
DATE_BUF DB 20 DUP(?)
RETURN_DATE_BUF DB 20 DUP(?)
ISSUED_BOOK_NAME_BUF DB 150 DUP(?)
CURRENT_DATE_BUF DB 20 DUP(?)
PARSED_RETURN_DATE_BUF DB 20 DUP(?)
OVERDUE_USERNAME_BUF DB 20 DUP(?)
OVERDUE_BOOKNAME_BUF DB 150 DUP(?)
OVERDUE_ISBN_BUF DB 20 DUP(?)
OVERDUE_ISSUE_DATE_BUF DB 20 DUP(?)
DAYS_OVERDUE_BUF DB 10 DUP(?)
FINE_AMOUNT_BUF DB 20 DUP(?)
FINE_RATE DWORD 10  ; Rs. 10 per day fine

; ISBN validation constants
ISBN_CHECK QWORD 1000000000000
VALID_ISBN_MIN QWORD 1000000000000
VALID_ISBN_MAX QWORD 9999999999999

; Sorting structures
MAX_BOOKS = 100
LINE_POINTERS DD MAX_BOOKS DUP (?)
LINE_LENGTHS DD MAX_BOOKS DUP (?)
NUM_LINES DWORD 0
SORT_TEMP_LINE DB 512 DUP(?)


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
	CMP EAX, VIEW_ISSUED_BOOKS
	JE VIEW_ISSUED_BOOKS_FUNC	; jump to View Issued Books section
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
;------VIEW ISSUED BOOKS-----------
;----------------------------------
VIEW_ISSUED_BOOKS_FUNC:
	; Display issued books header
	INVOKE MSG_DISPLAY, ADDR ISSUED_BOOKS_HEADER
	
	; Read ISSUED_BOOKS.txt
	INVOKE CreateFile, ADDR ISSUED_BOOKS_FILE, GENERIC_READ, DO_NOT_SHARE, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0
	cmp eax, INVALID_HANDLE_VALUE
	je view_issued_no_books
	
	mov filehandle, eax
	INVOKE ReadFile, filehandle, ADDR buffer_mem, BUFFER_SIZE, ADDR bytesRead, 0
	INVOKE CloseHandle, filehandle
	
	mov eax, DWORD PTR bytesRead
	cmp eax, 0
	je view_issued_no_books
	
	; Null-terminate buffer
	mov edi, OFFSET buffer_mem
	mov ecx, DWORD PTR bytesRead
	mov byte ptr [edi + ecx], 0
	
	xor ebx, ebx  ; offset in buffer
	xor esi, esi  ; counter for issued books
	
view_issued_loop:
	mov eax, DWORD PTR bytesRead
	cmp ebx, eax
	jge view_issued_check_count
	
	lea edi, [OFFSET buffer_mem + ebx]
	
	; Find line length
	xor ecx, ecx
view_issued_find_eol:
	mov al, [edi + ecx]
	cmp al, 0
	je view_issued_process_line
	cmp al, 0Dh
	je view_issued_process_line
	inc ecx
	jmp view_issued_find_eol
	
view_issued_process_line:
	cmp ecx, 0
	je view_issued_advance
	
	push ecx
	push edi
	
	; Parse line: username,bookname,ISBN,issuedate,returndate
	mov esi, edi
	
	; Field 1: Username
	mov edi, OFFSET OVERDUE_USERNAME_BUF
view_issued_extract_user:
	mov al, [esi]
	cmp al, ','
	je view_issued_user_done
	mov [edi], al
	inc esi
	inc edi
	jmp view_issued_extract_user
view_issued_user_done:
	mov byte ptr [edi], 0
	inc esi
	
	; Field 2: Book name
	mov edi, OFFSET OVERDUE_BOOKNAME_BUF
view_issued_extract_book:
	mov al, [esi]
	cmp al, ','
	je view_issued_book_done
	mov [edi], al
	inc esi
	inc edi
	jmp view_issued_extract_book
view_issued_book_done:
	mov byte ptr [edi], 0
	inc esi
	
	; Field 3: ISBN
	mov edi, OFFSET OVERDUE_ISBN_BUF
view_issued_extract_isbn:
	mov al, [esi]
	cmp al, ','
	je view_issued_isbn_done
	mov [edi], al
	inc esi
	inc edi
	jmp view_issued_extract_isbn
view_issued_isbn_done:
	mov byte ptr [edi], 0
	inc esi
	
	; Field 4: Issue date
	mov edi, OFFSET OVERDUE_ISSUE_DATE_BUF
view_issued_extract_issue:
	mov al, [esi]
	cmp al, ','
	je view_issued_issue_done
	mov [edi], al
	inc esi
	inc edi
	jmp view_issued_extract_issue
view_issued_issue_done:
	mov byte ptr [edi], 0
	inc esi
	
	; Field 5: Return date
	mov edi, OFFSET PARSED_RETURN_DATE_BUF
view_issued_extract_return:
	mov al, [esi]
	cmp al, 0
	je view_issued_return_done
	cmp al, 0Dh
	je view_issued_return_done
	cmp al, 0Ah
	je view_issued_return_done
	mov [edi], al
	inc esi
	inc edi
	jmp view_issued_extract_return
view_issued_return_done:
	mov byte ptr [edi], 0
	
	; Display issued book details
	INVOKE MSG_DISPLAY, ADDR USERNAME_LABEL
	INVOKE MSG_DISPLAY, ADDR OVERDUE_USERNAME_BUF
	INVOKE MSG_DISPLAY, ADDR CRLF_BYTES
	
	INVOKE MSG_DISPLAY, ADDR NAME_LABEL
	INVOKE MSG_DISPLAY, ADDR OVERDUE_BOOKNAME_BUF
	INVOKE MSG_DISPLAY, ADDR CRLF_BYTES
	
	INVOKE MSG_DISPLAY, ADDR ISBN_LABEL
	INVOKE MSG_DISPLAY, ADDR OVERDUE_ISBN_BUF
	INVOKE MSG_DISPLAY, ADDR CRLF_BYTES
	
	INVOKE MSG_DISPLAY, ADDR ISSUE_DATE_LABEL
	INVOKE MSG_DISPLAY, ADDR OVERDUE_ISSUE_DATE_BUF
	INVOKE MSG_DISPLAY, ADDR CRLF_BYTES
	
	INVOKE MSG_DISPLAY, ADDR RETURN_DATE_LABEL
	INVOKE MSG_DISPLAY, ADDR PARSED_RETURN_DATE_BUF
	INVOKE MSG_DISPLAY, ADDR CRLF_BYTES
	
	INVOKE MSG_DISPLAY, ADDR OVERDUE_SEPARATOR
	
	inc esi  ; increment issued books counter
	
	pop edi
	pop ecx
	
view_issued_advance:
	add ebx, ecx
	cmp byte ptr [OFFSET buffer_mem + ebx], 0Dh
	jne view_issued_skip_lf
	inc ebx
view_issued_skip_lf:
	cmp byte ptr [OFFSET buffer_mem + ebx], 0Ah
	jne view_issued_next_line
	inc ebx
view_issued_next_line:
	jmp view_issued_loop
	
view_issued_check_count:
	; Check if any issued books found
	cmp esi, 0
	jne view_issued_done
	
view_issued_no_books:
	INVOKE MSG_DISPLAY, ADDR NO_ISSUED_MSG
	
view_issued_done:
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
	; Display overdue books header
	INVOKE MSG_DISPLAY, ADDR OVERDUE_BOOKS_HEADER
	
	; Get current date
	push eax
	push ebx
	push ecx
	push edx
	
	sub esp, 16
	mov esi, esp
	INVOKE GetLocalTime, esi
	
	; Extract day, month, year
	movzx eax, WORD PTR [esi+2]  ; wMonth
	movzx ebx, WORD PTR [esi+6]  ; wDay
	movzx ecx, WORD PTR [esi]    ; wYear
	add esp, 16
	
	; Store current date values for comparison
	; Convert to comparable format: YYYYMMDD
	; Current date = year*10000 + month*100 + day
	push eax  ; save month
	mov eax, ecx  ; year
	mov edx, 10000
	mul edx
	mov ecx, eax  ; ecx = year * 10000
	pop eax       ; restore month
	push ebx      ; save day
	mov edx, 100
	mul edx
	add ecx, eax  ; ecx += month * 100
	pop eax       ; get day
	add ecx, eax  ; ecx += day
	; Now ecx contains current date as YYYYMMDD
	push ecx      ; save current date
	
	; Read ISSUED_BOOKS.txt
	INVOKE CreateFile, ADDR ISSUED_BOOKS_FILE, GENERIC_READ, DO_NOT_SHARE, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0
	cmp eax, INVALID_HANDLE_VALUE
	je overdue_no_books
	
	mov filehandle, eax
	INVOKE ReadFile, filehandle, ADDR buffer_mem, BUFFER_SIZE, ADDR bytesRead, 0
	INVOKE CloseHandle, filehandle
	
	mov eax, DWORD PTR bytesRead
	cmp eax, 0
	je overdue_no_books
	
	; Null-terminate buffer
	mov edi, OFFSET buffer_mem
	mov ecx, DWORD PTR bytesRead
	mov byte ptr [edi + ecx], 0
	
	xor ebx, ebx  ; offset in buffer
	xor esi, esi  ; counter for overdue books
	
overdue_loop:
	mov eax, DWORD PTR bytesRead
	cmp ebx, eax
	jge overdue_check_count
	
	lea edi, [OFFSET buffer_mem + ebx]
	
	; Find line length
	xor ecx, ecx
overdue_find_eol:
	mov al, [edi + ecx]
	cmp al, 0
	je overdue_process_line
	cmp al, 0Dh
	je overdue_process_line
	inc ecx
	jmp overdue_find_eol
	
overdue_process_line:
	cmp ecx, 0
	je overdue_advance
	
	push ecx
	push edi
	
	; Parse line: username,bookname,ISBN,issuedate,returndate
	; Extract return date (5th field)
	mov esi, edi
	xor edx, edx  ; comma counter
	
overdue_skip_to_return_date:
	mov al, [esi]
	cmp al, 0
	je overdue_line_done
	cmp al, 0Dh
	je overdue_line_done
	cmp al, ','
	jne overdue_skip_char
	inc edx
	cmp edx, 4
	je overdue_found_return_date
overdue_skip_char:
	inc esi
	jmp overdue_skip_to_return_date
	
overdue_found_return_date:
	; Skip comma
	inc esi
	
	; Copy return date to PARSED_RETURN_DATE_BUF
	push edi
	mov edi, OFFSET PARSED_RETURN_DATE_BUF
overdue_copy_date:
	mov al, [esi]
	cmp al, 0
	je overdue_date_copied
	cmp al, 0Dh
	je overdue_date_copied
	cmp al, 0Ah
	je overdue_date_copied
	mov [edi], al
	inc esi
	inc edi
	jmp overdue_copy_date
	
overdue_date_copied:
	mov byte ptr [edi], 0
	pop edi
	
	; Parse return date DD/MM/YYYY and convert to YYYYMMDD
	push edi
	mov esi, OFFSET PARSED_RETURN_DATE_BUF
	
	; Extract day (first 2 chars)
	movzx eax, byte ptr [esi]
	sub al, '0'
	mov bl, 10
	mul bl
	movzx edx, byte ptr [esi+1]
	sub dl, '0'
	add al, dl
	movzx eax, al
	push eax  ; save day
	
	; Extract month (chars 3-4, after '/')
	movzx eax, byte ptr [esi+3]
	sub al, '0'
	mov bl, 10
	mul bl
	movzx edx, byte ptr [esi+4]
	sub dl, '0'
	add al, dl
	movzx eax, al
	push eax  ; save month
	
	; Extract year (chars 6-9, after second '/')
	movzx eax, byte ptr [esi+6]
	sub al, '0'
	mov dx, 1000
	mul dx
	movzx ecx, ax
	
	movzx eax, byte ptr [esi+7]
	sub al, '0'
	mov dx, 100
	mul dx
	add ecx, eax
	
	movzx eax, byte ptr [esi+8]
	sub al, '0'
	mov dx, 10
	mul dx
	add ecx, eax
	
	movzx eax, byte ptr [esi+9]
	sub al, '0'
	add ecx, eax
	
	; Now ecx = year, calculate YYYYMMDD
	mov eax, ecx
	mov edx, 10000
	mul edx
	mov ecx, eax  ; ecx = year * 10000
	
	pop eax  ; get month
	mov edx, 100
	mul edx
	add ecx, eax  ; ecx += month * 100
	
	pop eax  ; get day
	add ecx, eax  ; ecx += day
	
	pop edi
	
	; Compare with current date
	mov eax, [esp+8]  ; get current date from stack
	cmp ecx, eax
	jge overdue_line_done  ; return date >= current date, not overdue
	
	; Book is overdue! Extract and display details
	pop edi
	pop ecx
	push ecx
	push edi
	
	; Extract all fields from line
	mov esi, edi
	
	; Field 1: Username
	mov edi, OFFSET OVERDUE_USERNAME_BUF
overdue_extract_user:
	mov al, [esi]
	cmp al, ','
	je overdue_user_done
	mov [edi], al
	inc esi
	inc edi
	jmp overdue_extract_user
overdue_user_done:
	mov byte ptr [edi], 0
	inc esi
	
	; Field 2: Book name
	mov edi, OFFSET OVERDUE_BOOKNAME_BUF
overdue_extract_book:
	mov al, [esi]
	cmp al, ','
	je overdue_book_done
	mov [edi], al
	inc esi
	inc edi
	jmp overdue_extract_book
overdue_book_done:
	mov byte ptr [edi], 0
	inc esi
	
	; Field 3: ISBN
	mov edi, OFFSET OVERDUE_ISBN_BUF
overdue_extract_isbn:
	mov al, [esi]
	cmp al, ','
	je overdue_isbn_done
	mov [edi], al
	inc esi
	inc edi
	jmp overdue_extract_isbn
overdue_isbn_done:
	mov byte ptr [edi], 0
	inc esi
	
	; Field 4: Issue date
	mov edi, OFFSET OVERDUE_ISSUE_DATE_BUF
overdue_extract_issue:
	mov al, [esi]
	cmp al, ','
	je overdue_issue_done
	mov [edi], al
	inc esi
	inc edi
	jmp overdue_extract_issue
overdue_issue_done:
	mov byte ptr [edi], 0
	
	; Display overdue book details
	INVOKE MSG_DISPLAY, ADDR USERNAME_LABEL
	INVOKE MSG_DISPLAY, ADDR OVERDUE_USERNAME_BUF
	INVOKE MSG_DISPLAY, ADDR CRLF_BYTES
	
	INVOKE MSG_DISPLAY, ADDR NAME_LABEL
	INVOKE MSG_DISPLAY, ADDR OVERDUE_BOOKNAME_BUF
	INVOKE MSG_DISPLAY, ADDR CRLF_BYTES
	
	INVOKE MSG_DISPLAY, ADDR ISBN_LABEL
	INVOKE MSG_DISPLAY, ADDR OVERDUE_ISBN_BUF
	INVOKE MSG_DISPLAY, ADDR CRLF_BYTES
	
	INVOKE MSG_DISPLAY, ADDR ISSUE_DATE_LABEL
	INVOKE MSG_DISPLAY, ADDR OVERDUE_ISSUE_DATE_BUF
	INVOKE MSG_DISPLAY, ADDR CRLF_BYTES
	
	INVOKE MSG_DISPLAY, ADDR RETURN_DATE_LABEL
	INVOKE MSG_DISPLAY, ADDR PARSED_RETURN_DATE_BUF
	INVOKE MSG_DISPLAY, ADDR CRLF_BYTES
	
	INVOKE MSG_DISPLAY, ADDR OVERDUE_SEPARATOR
	
	inc DWORD PTR [esp+8+4]  ; increment overdue counter (accounting for pushes)
	
overdue_line_done:
	pop edi
	pop ecx
	
overdue_advance:
	add ebx, ecx
	cmp byte ptr [OFFSET buffer_mem + ebx], 0Dh
	jne overdue_skip_lf
	inc ebx
overdue_skip_lf:
	cmp byte ptr [OFFSET buffer_mem + ebx], 0Ah
	jne overdue_next_line
	inc ebx
overdue_next_line:
	jmp overdue_loop
	
overdue_check_count:
	; Clean up stack (current date)
	pop ecx
	
	; Check if any overdue books found
	cmp esi, 0
	jne overdue_done
	
overdue_no_books:
	INVOKE MSG_DISPLAY, ADDR NO_OVERDUE_MSG
	
overdue_done:
	pop edx
	pop ecx
	pop ebx
	pop eax
	JMP SHOW_FULL_MENU

CALCULATE_FINES_FUNC:
	; Ask user to enter ISBN
	INVOKE MSG_DISPLAY, ADDR ISBN_PROMPT
	mov edx, OFFSET ISBN_SEARCH_BUF
	mov ecx, 20
	CALL READSTRING
	
	; Display fines header
	INVOKE MSG_DISPLAY, ADDR FINES_HEADER
	INVOKE MSG_DISPLAY, ADDR FINE_RATE_MSG
	
	; Get current date
	push eax
	push ebx
	push ecx
	push edx
	
	sub esp, 16
	mov esi, esp
	INVOKE GetLocalTime, esi
	
	; Extract day, month, year
	movzx eax, WORD PTR [esi+2]  ; wMonth
	movzx ebx, WORD PTR [esi+6]  ; wDay
	movzx ecx, WORD PTR [esi]    ; wYear
	add esp, 16
	
	; Store current date values for comparison
	; Convert to comparable format: YYYYMMDD
	push eax  ; save month
	mov eax, ecx  ; year
	mov edx, 10000
	mul edx
	mov ecx, eax  ; ecx = year * 10000
	pop eax       ; restore month
	push ebx      ; save day
	mov edx, 100
	mul edx
	add ecx, eax  ; ecx += month * 100
	pop eax       ; get day
	add ecx, eax  ; ecx += day
	; Now ecx contains current date as YYYYMMDD
	push ecx      ; save current date
	
	; Store individual date components for day calculation
	sub esp, 16
	mov esi, esp
	INVOKE GetLocalTime, esi
	movzx eax, WORD PTR [esi+2]  ; wMonth
	movzx ebx, WORD PTR [esi+6]  ; wDay
	movzx ecx, WORD PTR [esi]    ; wYear
	add esp, 16
	
	push ecx  ; current year
	push eax  ; current month
	push ebx  ; current day
	
	; Read ISSUED_BOOKS.txt
	INVOKE CreateFile, ADDR ISSUED_BOOKS_FILE, GENERIC_READ, DO_NOT_SHARE, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0
	cmp eax, INVALID_HANDLE_VALUE
	je fines_no_books
	
	mov filehandle, eax
	INVOKE ReadFile, filehandle, ADDR buffer_mem, BUFFER_SIZE, ADDR bytesRead, 0
	INVOKE CloseHandle, filehandle
	
	mov eax, DWORD PTR bytesRead
	cmp eax, 0
	je fines_no_books
	
	; Null-terminate buffer
	mov edi, OFFSET buffer_mem
	mov ecx, DWORD PTR bytesRead
	mov byte ptr [edi + ecx], 0
	
	xor ebx, ebx  ; offset in buffer
	xor esi, esi  ; total fine amount
	
fines_loop:
	mov eax, DWORD PTR bytesRead
	cmp ebx, eax
	jge fines_check_total
	
	lea edi, [OFFSET buffer_mem + ebx]
	
	; Find line length
	xor ecx, ecx
fines_find_eol:
	mov al, [edi + ecx]
	cmp al, 0
	je fines_process_line
	cmp al, 0Dh
	je fines_process_line
	inc ecx
	jmp fines_find_eol
	
fines_process_line:
	cmp ecx, 0
	je fines_advance
	
	push ecx
	push edi
	
	; Parse line: username,bookname,ISBN,issuedate,returndate
	; First check if ISBN matches the searched ISBN
	mov esi, edi
	xor edx, edx  ; comma counter
	
fines_skip_to_isbn:
	mov al, [esi]
	cmp al, 0
	je fines_line_done
	cmp al, 0Dh
	je fines_line_done
	cmp al, ','
	jne fines_skip_isbn_char
	inc edx
	cmp edx, 2
	je fines_found_isbn_field
fines_skip_isbn_char:
	inc esi
	jmp fines_skip_to_isbn
	
fines_found_isbn_field:
	; Skip comma
	inc esi
	
	; Compare ISBN with search buffer
	push edi
	mov edi, OFFSET ISBN_SEARCH_BUF
fines_compare_isbn:
	mov al, [esi]
	mov bl, [edi]
	cmp bl, 0
	je fines_check_isbn_end
	cmp al, bl
	jne fines_isbn_no_match
	inc esi
	inc edi
	jmp fines_compare_isbn
	
fines_check_isbn_end:
	mov al, [esi]
	cmp al, ','
	je fines_isbn_match
	
fines_isbn_no_match:
	pop edi
	jmp fines_line_done
	
fines_isbn_match:
	pop edi
	
	; Now extract return date (5th field)
	mov esi, edi
	xor edx, edx  ; comma counter
	
fines_skip_to_return_date:
	mov al, [esi]
	cmp al, 0
	je fines_line_done
	cmp al, 0Dh
	je fines_line_done
	cmp al, ','
	jne fines_skip_char
	inc edx
	cmp edx, 4
	je fines_found_return_date
fines_skip_char:
	inc esi
	jmp fines_skip_to_return_date
	
fines_found_return_date:
	; Skip comma
	inc esi
	
	; Copy return date to PARSED_RETURN_DATE_BUF
	push edi
	mov edi, OFFSET PARSED_RETURN_DATE_BUF
fines_copy_date:
	mov al, [esi]
	cmp al, 0
	je fines_date_copied
	cmp al, 0Dh
	je fines_date_copied
	cmp al, 0Ah
	je fines_date_copied
	mov [edi], al
	inc esi
	inc edi
	jmp fines_copy_date
	
fines_date_copied:
	mov byte ptr [edi], 0
	pop edi
	
	; Parse return date DD/MM/YYYY and convert to YYYYMMDD
	push edi
	mov esi, OFFSET PARSED_RETURN_DATE_BUF
	
	; Extract day
	movzx eax, byte ptr [esi]
	sub al, '0'
	mov bl, 10
	mul bl
	movzx edx, byte ptr [esi+1]
	sub dl, '0'
	add al, dl
	movzx eax, al
	push eax  ; save return day
	
	; Extract month
	movzx eax, byte ptr [esi+3]
	sub al, '0'
	mov bl, 10
	mul bl
	movzx edx, byte ptr [esi+4]
	sub dl, '0'
	add al, dl
	movzx eax, al
	push eax  ; save return month
	
	; Extract year
	movzx eax, byte ptr [esi+6]
	sub al, '0'
	mov dx, 1000
	mul dx
	movzx ecx, ax
	
	movzx eax, byte ptr [esi+7]
	sub al, '0'
	mov dx, 100
	mul dx
	add ecx, eax
	
	movzx eax, byte ptr [esi+8]
	sub al, '0'
	mov dx, 10
	mul dx
	add ecx, eax
	
	movzx eax, byte ptr [esi+9]
	sub al, '0'
	add ecx, eax
	
	; Now ecx = year, calculate YYYYMMDD
	mov eax, ecx
	mov edx, 10000
	mul edx
	mov ecx, eax  ; ecx = year * 10000
	
	pop eax  ; get return month
	mov edx, 100
	mul edx
	add ecx, eax  ; ecx += month * 100
	
	pop eax  ; get return day
	add ecx, eax  ; ecx += day
	
	pop edi
	
	; Compare with current date
	mov eax, [esp+8+12]  ; get current date from stack (accounting for 3 date component pushes)
	cmp ecx, eax
	jge fines_line_done  ; return date >= current date, not overdue
	
	; Book is overdue! Calculate days overdue and fine
	; Simple calculation: currentDate - returnDate (approximation)
	mov eax, [esp+8+12]  ; current date YYYYMMDD
	sub eax, ecx         ; subtract return date
	; Approximate days (this is simplified - actual would need proper date arithmetic)
	; For simplicity: assume difference in dates gives rough day count
	; Better approach: use individual components
	
	; Get return date components back from string
	mov esi, OFFSET PARSED_RETURN_DATE_BUF
	movzx ebx, byte ptr [esi]
	sub bl, '0'
	mov al, 10
	mul bl
	movzx edx, byte ptr [esi+1]
	sub dl, '0'
	add al, dl
	movzx ebx, al  ; ebx = return day
	
	movzx eax, byte ptr [esi+3]
	sub al, '0'
	mov dl, 10
	mul dl
	movzx ecx, byte ptr [esi+4]
	sub cl, '0'
	add al, cl
	movzx ecx, al  ; ecx = return month
	
	; Get current date components from stack
	mov eax, [esp+8]    ; current day
	mov edx, [esp+8+4]  ; current month
	
	; Simple day calculation (assuming same month for simplicity)
	; In reality, need complex date arithmetic
	; For demo: if same month, days = current_day - return_day
	cmp edx, ecx
	jne fines_diff_month
	
	sub eax, ebx  ; days overdue = current_day - return_day
	jmp fines_calc_fine
	
fines_diff_month:
	; Simplified: add 30 days for month difference
	mov eax, 30
	sub eax, ebx  ; days left in return month
	add eax, [esp+8]  ; add days in current month
	
fines_calc_fine:
	; eax now has days overdue
	cmp eax, 0
	jle fines_line_done  ; skip if not actually overdue
	
	; Calculate fine: days * rate
	mov edx, FINE_RATE
	mul edx  ; eax = days * rate
	
	; Save fine for this book
	push eax  ; save fine amount
	
	; Extract book details
	pop edx  ; get fine back
	pop edi
	pop ecx
	push ecx
	push edi
	push edx  ; save fine again
	
	mov esi, edi
	
	; Field 1: Username
	mov edi, OFFSET OVERDUE_USERNAME_BUF
fines_extract_user:
	mov al, [esi]
	cmp al, ','
	je fines_user_done
	mov [edi], al
	inc esi
	inc edi
	jmp fines_extract_user
fines_user_done:
	mov byte ptr [edi], 0
	inc esi
	
	; Field 2: Book name
	mov edi, OFFSET OVERDUE_BOOKNAME_BUF
fines_extract_book:
	mov al, [esi]
	cmp al, ','
	je fines_book_done
	mov [edi], al
	inc esi
	inc edi
	jmp fines_extract_book
fines_book_done:
	mov byte ptr [edi], 0
	
	; Display details with fine
	INVOKE MSG_DISPLAY, ADDR USERNAME_LABEL
	INVOKE MSG_DISPLAY, ADDR OVERDUE_USERNAME_BUF
	INVOKE MSG_DISPLAY, ADDR CRLF_BYTES
	
	INVOKE MSG_DISPLAY, ADDR NAME_LABEL
	INVOKE MSG_DISPLAY, ADDR OVERDUE_BOOKNAME_BUF
	INVOKE MSG_DISPLAY, ADDR CRLF_BYTES
	
	INVOKE MSG_DISPLAY, ADDR RETURN_DATE_LABEL
	INVOKE MSG_DISPLAY, ADDR PARSED_RETURN_DATE_BUF
	INVOKE MSG_DISPLAY, ADDR CRLF_BYTES
	
	INVOKE MSG_DISPLAY, ADDR FINE_AMOUNT_LABEL
	pop eax  ; get fine amount
	call WriteDec
	INVOKE MSG_DISPLAY, ADDR CRLF_BYTES
	
	INVOKE MSG_DISPLAY, ADDR OVERDUE_SEPARATOR
	
	; Book found and fine calculated, exit
	pop edi
	pop ecx
	
	; Clean up stack (current day, month, year, current date)
	pop ebx  ; day
	pop ecx  ; month
	pop edx  ; year
	pop eax  ; current date
	
	jmp fines_done
	
fines_line_done:
	pop edi
	pop ecx
	
fines_advance:
	add ebx, ecx
	cmp byte ptr [OFFSET buffer_mem + ebx], 0Dh
	jne fines_skip_lf
	inc ebx
fines_skip_lf:
	cmp byte ptr [OFFSET buffer_mem + ebx], 0Ah
	jne fines_next_line
	inc ebx
fines_next_line:
	jmp fines_loop
	
fines_check_total:
	; Clean up stack (current day, month, year, current date)
	pop ebx  ; day
	pop ecx  ; month
	pop edx  ; year
	pop eax  ; current date
	
	; Check if any fines calculated
	cmp esi, 0
	je fines_no_books
	
	; No total display needed
	jmp fines_done
	
fines_no_books:
	; Clean up stack if we jumped here
	add esp, 16  ; clean up date components and current date
	INVOKE MSG_DISPLAY, ADDR NO_FINES_MSG
	
fines_done:
	pop edx
	pop ecx
	pop ebx
	pop eax
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
	; First, check if user has already issued 5 books
	; Read ISSUED_BOOKS.txt and count books issued by current user
	INVOKE CreateFile, ADDR ISSUED_BOOKS_FILE, GENERIC_READ, DO_NOT_SHARE, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0
	cmp eax, INVALID_HANDLE_VALUE
	je issue_check_done ; File doesn't exist, no books issued yet
	
	mov filehandle, eax
	
	; Read all issued books into buffer_mem
	INVOKE ReadFile, filehandle, ADDR buffer_mem, BUFFER_SIZE, ADDR bytesRead, 0
	INVOKE CloseHandle, filehandle
	
	mov eax, DWORD PTR bytesRead
	cmp eax, 0
	je issue_check_done ; No books issued yet
	
	; Null-terminate buffer
	mov edi, OFFSET buffer_mem
	mov ecx, DWORD PTR bytesRead
	mov byte ptr [edi + ecx], 0
	
	; Count books issued by current user
	xor ebx, ebx ; offset in buffer
	xor esi, esi ; counter for user's books
	
issue_count_loop:
	mov eax, DWORD PTR bytesRead
	cmp ebx, eax
	jge issue_check_limit
	
	lea edi, [OFFSET buffer_mem + ebx]
	
	; Find line length
	xor ecx, ecx
issue_count_eol:
	mov al, [edi + ecx]
	cmp al, 0
	je issue_count_process
	cmp al, 0Dh
	je issue_count_process
	inc ecx
	jmp issue_count_eol
	
issue_count_process:
	cmp ecx, 0
	je issue_count_advance
	
	; Extract username (first field) and compare with USERNAME_BUF
	push ecx
	push edi
	push esi
	
	; Copy username from line to TEMP_FIELD
	mov esi, edi
	mov edi, OFFSET TEMP_FIELD
issue_count_copy_user:
	mov al, [esi]
	cmp al, ','
	je issue_count_compare_user
	cmp al, 0
	je issue_count_compare_user
	cmp al, 0Dh
	je issue_count_compare_user
	mov [edi], al
	inc esi
	inc edi
	jmp issue_count_copy_user
	
issue_count_compare_user:
	mov byte ptr [edi], 0
	
	; Compare with USERNAME_BUF
	INVOKE Str_compare, ADDR USERNAME_BUF, ADDR TEMP_FIELD
	pop esi
	pop edi
	pop ecx
	jne issue_count_advance
	
	; Username matches, increment counter
	inc esi
	
issue_count_advance:
	add ebx, ecx
	cmp byte ptr [OFFSET buffer_mem + ebx], 0Dh
	jne issue_count_lf
	inc ebx
issue_count_lf:
	cmp byte ptr [OFFSET buffer_mem + ebx], 0Ah
	jne issue_count_next
	inc ebx
issue_count_next:
	jmp issue_count_loop
	
issue_check_limit:
	; Check if user has 5 or more books
	cmp esi, 5
	jge issue_limit_reached
	
issue_check_done:
	; User has less than 5 books, proceed with issuing
	
	; Prompt for ISBN
	INVOKE MSG_DISPLAY, ADDR ISSUE_BOOK_MSG
	mov edx, OFFSET ISBN_SEARCH_BUF
	mov ecx, 20
	CALL READSTRING
	
	; First check if book exists in BOOKS.txt
	INVOKE CreateFile, ADDR BOOKS_FILE, GENERIC_READ, DO_NOT_SHARE, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0
	mov filehandle, eax
	cmp eax, INVALID_HANDLE_VALUE
	je issue_book_not_found
	
	CALL ReadAllBooks
	INVOKE CloseHandle, filehandle
	
	; Search for ISBN in BUFFER_BOOK (field 6)
	mov eax, DWORD PTR bytesRead
	cmp eax, 0
	je issue_book_not_found
	
	xor ebx, ebx ; offset in buffer
	mov edi, OFFSET TEMP_FIELD
	mov byte ptr [edi], 0 ; flag for found
	
issue_search_loop:
	mov eax, DWORD PTR bytesRead
	cmp ebx, eax
	jge issue_book_not_found
	
	lea edi, [OFFSET BUFFER_BOOK + ebx]
	
	; Find line length
	xor ecx, ecx
issue_find_eol:
	mov al, [edi + ecx]
	cmp al, 0
	je issue_process_line
	cmp al, 0Dh
	je issue_process_line
	inc ecx
	jmp issue_find_eol
	
issue_process_line:
	cmp ecx, 0
	je issue_advance_empty
	
	; Extract ISBN (6th field) - skip 5 commas
	push ecx
	push edi
	
	mov esi, edi
	xor edx, edx ; field counter
	xor ecx, ecx ; position in line
	
issue_find_isbn_field:
	mov al, [esi]
	cmp al, 0
	je issue_extract_isbn
	cmp al, 0Dh
	je issue_extract_isbn
	cmp al, ','
	jne issue_skip_char
	inc edx
	cmp edx, 5
	je issue_extract_isbn
issue_skip_char:
	inc esi
	jmp issue_find_isbn_field
	
issue_extract_isbn:
	; Skip the last comma if we found 5
	cmp edx, 5
	jne issue_line_done
	cmp byte ptr [esi], ','
	jne issue_start_copy
	inc esi
	
issue_start_copy:
	; Copy ISBN to TEMP_FIELD
	mov edi, OFFSET TEMP_FIELD
issue_copy_isbn:
	mov al, [esi]
	cmp al, 0
	je issue_compare
	cmp al, 0Dh
	je issue_compare
	cmp al, 0Ah
	je issue_compare
	mov [edi], al
	inc esi
	inc edi
	jmp issue_copy_isbn
	
issue_compare:
	mov byte ptr [edi], 0
	
	; Compare with ISBN_SEARCH_BUF
	INVOKE Str_compare, ADDR ISBN_SEARCH_BUF, ADDR TEMP_FIELD
	je issue_book_found
	
issue_line_done:
	pop edi
	pop ecx
	
issue_advance:
	add ebx, ecx
	cmp byte ptr [OFFSET BUFFER_BOOK + ebx], 0Dh
	jne issue_skip_lf
	inc ebx
issue_skip_lf:
	cmp byte ptr [OFFSET BUFFER_BOOK + ebx], 0Ah
	jne issue_next_line
	inc ebx
issue_next_line:
	jmp issue_search_loop

issue_advance_empty:
	xor ecx, ecx
	jmp issue_advance
	
issue_book_found:
	pop edi
	pop ecx
	
	; First, extract book name from the matched line (edi points to start of line)
	; Save edi (line start) for later use
	push edi
	
	; Copy book name (first field) to ISSUED_BOOK_NAME_BUF
	mov esi, edi
	mov edi, OFFSET ISSUED_BOOK_NAME_BUF
issue_extract_name:
	mov al, [esi]
	cmp al, ','
	je issue_name_done
	cmp al, 0
	je issue_name_done
	cmp al, 0Dh
	je issue_name_done
	mov [edi], al
	inc esi
	inc edi
	jmp issue_extract_name
issue_name_done:
	mov byte ptr [edi], 0
	
	; Restore edi
	pop edi
	
	; Check if already issued by reading ISSUED_BOOKS.txt
	INVOKE CreateFile, ADDR ISSUED_BOOKS_FILE, GENERIC_READ, DO_NOT_SHARE, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0
	cmp eax, INVALID_HANDLE_VALUE
	je issue_not_yet_issued ; File doesn't exist, so no books issued yet
	
	mov filehandle, eax
	
	; Read issued books into buffer_mem
	INVOKE ReadFile, filehandle, ADDR buffer_mem, BUFFER_SIZE, ADDR bytesRead, 0
	INVOKE CloseHandle, filehandle
	
	; Search for ISBN in issued books
	mov eax, DWORD PTR bytesRead
	cmp eax, 0
	je issue_not_yet_issued
	
	; Null-terminate buffer
	mov edi, OFFSET buffer_mem
	mov ecx, DWORD PTR bytesRead
	mov byte ptr [edi + ecx], 0
	
	xor ebx, ebx
issue_check_loop:
	mov eax, DWORD PTR bytesRead
	cmp ebx, eax
	jge issue_not_yet_issued
	
	lea esi, [OFFSET buffer_mem + ebx]
	
	; Find line length
	xor ecx, ecx
issue_check_eol:
	mov al, [esi + ecx]
	cmp al, 0
	je issue_check_isbn
	cmp al, 0Dh
	je issue_check_isbn
	inc ecx
	jmp issue_check_eol
	
issue_check_isbn:
	cmp ecx, 0
	je issue_check_advance
	
	; Extract ISBN (3rd field) from issued books line: username,bookname,ISBN,issuedate,returndate
	push ecx
	push esi
	
	; Skip first two fields (username, bookname)
	xor edx, edx ; comma counter
issue_skip_to_isbn:
	mov al, [esi]
	cmp al, 0
	je issue_check_no_match
	cmp al, 0Dh
	je issue_check_no_match
	cmp al, ','
	jne issue_skip_next_char
	inc edx
	cmp edx, 2
	je issue_found_isbn_field
issue_skip_next_char:
	inc esi
	jmp issue_skip_to_isbn
	
issue_found_isbn_field:
	; Skip the comma
	inc esi
	
	; Copy ISBN to TEMP_FIELD
	mov edi, OFFSET TEMP_FIELD
issue_copy_issued_isbn:
	mov al, [esi]
	cmp al, 0
	je issue_check_compare
	cmp al, 0Dh
	je issue_check_compare
	cmp al, ','
	je issue_check_compare
	mov [edi], al
	inc esi
	inc edi
	jmp issue_copy_issued_isbn
	
issue_check_compare:
	mov byte ptr [edi], 0
	
	; Check if ISBN matches
	INVOKE Str_compare, ADDR ISBN_SEARCH_BUF, ADDR TEMP_FIELD
	je issue_already_issued_pop

issue_check_no_match:
	pop esi
	pop ecx
	
issue_check_advance:
	add ebx, ecx
	cmp byte ptr [OFFSET buffer_mem + ebx], 0Dh
	jne issue_check_lf
	inc ebx
issue_check_lf:
	cmp byte ptr [OFFSET buffer_mem + ebx], 0Ah
	jne issue_check_next
	inc ebx
issue_check_next:
	jmp issue_check_loop
	
issue_already_issued_pop:
	pop esi
	pop ecx
	INVOKE MSG_DISPLAY, ADDR BOOK_ALREADY_ISSUED_MSG
	JMP SHOW_MEMBER_MENU
	
issue_not_yet_issued:
	; Book exists and not issued - add to ISSUED_BOOKS.txt
	; Format: username,bookname,ISBN,date
	
	; Get current date using GetLocalTime
	push eax
	push ebx
	push ecx
	push edx
	
	; Allocate SYSTEMTIME structure on stack (16 bytes)
	sub esp, 16
	mov esi, esp
	
	INVOKE GetLocalTime, esi
	
	; Extract day, month, year from SYSTEMTIME structure
	; SYSTEMTIME: wYear(2), wMonth(2), wDayOfWeek(2), wDay(2), wHour(2), wMinute(2), wSecond(2), wMilliseconds(2)
	movzx eax, WORD PTR [esi+2]  ; wMonth (offset 2)
	movzx ebx, WORD PTR [esi+6]  ; wDay (offset 6)
	movzx ecx, WORD PTR [esi]    ; wYear (offset 0)
	
	; Clean up stack
	add esp, 16
	
	; Save the values we need
	push ecx  ; save year
	push eax  ; save month
	push ebx  ; save day
	
	; Format date as "DD/MM/YYYY" in DATE_BUF
	mov edi, OFFSET DATE_BUF
	
	; Day (2 digits)
	pop eax   ; get day
	push eax  ; save it again
	xor edx, edx
	push ecx  ; save ecx
	mov ecx, 10
	div ecx
	add al, '0'
	mov [edi], al
	inc edi
	mov al, dl
	add al, '0'
	mov [edi], al
	inc edi
	pop ecx   ; restore ecx
	
	; Separator
	mov byte ptr [edi], '/'
	inc edi
	
	; Month (2 digits)
	mov eax, [esp+4]  ; get month (skip day on stack)
	xor edx, edx
	push ecx  ; save ecx
	mov ecx, 10
	div ecx
	add al, '0'
	mov [edi], al
	inc edi
	mov al, dl
	add al, '0'
	mov [edi], al
	inc edi
	pop ecx   ; restore ecx
	
	; Separator
	mov byte ptr [edi], '/'
	inc edi
	
	; Year (4 digits)
	mov eax, [esp+8]  ; get year from stack
	push ebx
	mov ebx, 1000
	xor edx, edx
	div ebx
	add al, '0'
	mov [edi], al
	inc edi
	
	mov eax, edx
	mov ebx, 100
	xor edx, edx
	div ebx
	add al, '0'
	mov [edi], al
	inc edi
	
	mov eax, edx
	mov ebx, 10
	xor edx, edx
	div ebx
	add al, '0'
	mov [edi], al
	inc edi
	
	mov al, dl
	add al, '0'
	mov [edi], al
	inc edi
	
	mov byte ptr [edi], 0
	pop ebx
	
	; Clean up stack but save day, month, year for return date calculation
	; Stack has: day, month, year
	pop eax  ; day
	pop ebx  ; month
	pop ecx  ; year
	
	; Calculate return date (10 days later)
	; Add 10 to the day
	add eax, 10
	
	; Save registers
	push edx
	
	; Check if day exceeds month's max days
	; Simple logic: assume 30 days per month for simplicity
	cmp eax, 30
	jle return_date_ok
	
	; Day exceeds 30, move to next month
	sub eax, 30
	inc ebx
	
	; Check if month exceeds 12
	cmp ebx, 12
	jle return_date_ok
	
	; Month exceeds 12, move to next year
	sub ebx, 12
	inc ecx
	
return_date_ok:
	; Now eax=day, ebx=month, ecx=year for return date
	; Format return date as "DD/MM/YYYY" in RETURN_DATE_BUF
	
	mov edi, OFFSET RETURN_DATE_BUF
	
	; Day (2 digits) - eax has day
	push eax
	push ebx
	push ecx
	xor edx, edx
	mov ecx, 10
	div ecx
	add al, '0'
	mov [edi], al
	inc edi
	mov al, dl
	add al, '0'
	mov [edi], al
	inc edi
	pop ecx
	pop ebx
	pop eax
	
	; Separator
	mov byte ptr [edi], '/'
	inc edi
	
	; Month (2 digits) - ebx has month
	push eax
	push ebx
	push ecx
	mov eax, ebx
	xor edx, edx
	mov ecx, 10
	div ecx
	add al, '0'
	mov [edi], al
	inc edi
	mov al, dl
	add al, '0'
	mov [edi], al
	inc edi
	pop ecx
	pop ebx
	pop eax
	
	; Separator
	mov byte ptr [edi], '/'
	inc edi
	
	; Year (4 digits) - ecx has year
	push eax
	push ebx
	mov eax, ecx
	push ebx
	mov ebx, 1000
	xor edx, edx
	div ebx
	add al, '0'
	mov [edi], al
	inc edi
	
	mov eax, edx
	mov ebx, 100
	xor edx, edx
	div ebx
	add al, '0'
	mov [edi], al
	inc edi
	
	mov eax, edx
	mov ebx, 10
	xor edx, edx
	div ebx
	add al, '0'
	mov [edi], al
	inc edi
	
	mov al, dl
	add al, '0'
	mov [edi], al
	inc edi
	
	mov byte ptr [edi], 0
	pop ebx
	pop ebx
	pop eax
	
	pop edx
	
	pop edx
	pop ecx
	pop ebx
	pop eax
	
	; Now write to file: username,bookname,ISBN,issuedate,returndate
	INVOKE CreateFile, ADDR ISSUED_BOOKS_FILE, GENERIC_WRITE, DO_NOT_SHARE, NULL, OPEN_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0
	mov filehandle, eax
	
	; Move to end of file
	INVOKE SetFilePointer, filehandle, 0, 0, FILE_END
	
	; Write username
	mov edx, OFFSET USERNAME_BUF
	INVOKE Str_length, edx
	mov ecx, eax
	mov eax, filehandle
	call WriteToFile
	
	; Write comma
	mov eax, filehandle
	mov edx, OFFSET COMMA_BYTE
	mov ecx, 1
	call WriteToFile
	
	; Write book name
	mov edx, OFFSET ISSUED_BOOK_NAME_BUF
	INVOKE Str_length, edx
	mov ecx, eax
	mov eax, filehandle
	call WriteToFile
	
	; Write comma
	mov eax, filehandle
	mov edx, OFFSET COMMA_BYTE
	mov ecx, 1
	call WriteToFile
	
	; Write ISBN
	mov edx, OFFSET ISBN_SEARCH_BUF
	INVOKE Str_length, edx
	mov ecx, eax
	mov eax, filehandle
	call WriteToFile
	
	; Write comma
	mov eax, filehandle
	mov edx, OFFSET COMMA_BYTE
	mov ecx, 1
	call WriteToFile
	
	; Write issue date
	mov edx, OFFSET DATE_BUF
	INVOKE Str_length, edx
	mov ecx, eax
	mov eax, filehandle
	call WriteToFile
	
	; Write comma
	mov eax, filehandle
	mov edx, OFFSET COMMA_BYTE
	mov ecx, 1
	call WriteToFile
	
	; Write return date
	mov edx, OFFSET RETURN_DATE_BUF
	INVOKE Str_length, edx
	mov ecx, eax
	mov eax, filehandle
	call WriteToFile
	
	; Write newline
	mov eax, filehandle
	mov edx, OFFSET CRLF_BYTES
	mov ecx, 2
	call WriteToFile
	
	INVOKE CloseHandle, filehandle
	
	INVOKE MSG_DISPLAY, ADDR BOOK_ISSUED_SUCCESS_MSG
	JMP SHOW_MEMBER_MENU
	
issue_limit_reached:
	INVOKE MSG_DISPLAY, ADDR BOOK_LIMIT_REACHED_MSG
	JMP SHOW_MEMBER_MENU

issue_book_not_found:
	INVOKE MSG_DISPLAY, ADDR BOOK_NOT_FOUND_MSG
	JMP SHOW_MEMBER_MENU

RETURN_BOOK_FUNC:
	; Prompt for ISBN
	INVOKE MSG_DISPLAY, ADDR RETURN_BOOK_MSG
	mov edx, OFFSET ISBN_SEARCH_BUF
	mov ecx, 20
	CALL READSTRING
	
	; Check if book is issued by reading ISSUED_BOOKS.txt
	INVOKE CreateFile, ADDR ISSUED_BOOKS_FILE, GENERIC_READ, DO_NOT_SHARE, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0
	cmp eax, INVALID_HANDLE_VALUE
	je return_book_not_issued ; File doesn't exist
	
	mov filehandle, eax
	
	; Read all issued books
	INVOKE ReadFile, filehandle, ADDR buffer_mem, BUFFER_SIZE, ADDR bytesRead, 0
	INVOKE CloseHandle, filehandle
	
	mov eax, DWORD PTR bytesRead
	cmp eax, 0
	je return_book_not_issued
	
	; Null-terminate
	mov edi, OFFSET buffer_mem
	mov ecx, DWORD PTR bytesRead
	mov byte ptr [edi + ecx], 0
	
	; Search for ISBN and rebuild file without it
	xor ebx, ebx ; offset in buffer
	mov edi, OFFSET TEMP_LINE
	mov byte ptr [edi], 0 ; flag for found
	
	; Reopen file for writing (truncate)
	INVOKE CreateFile, ADDR ISSUED_BOOKS_FILE, GENERIC_WRITE, DO_NOT_SHARE, NULL, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0
	mov filehandle, eax
	
	xor ebx, ebx
return_search_loop:
	mov eax, DWORD PTR bytesRead
	cmp ebx, eax
	jge return_check_found
	
	lea esi, [OFFSET buffer_mem + ebx]
	
	; Find line length
	xor ecx, ecx
return_find_eol:
	mov al, [esi + ecx]
	cmp al, 0
	je return_process_line
	cmp al, 0Dh
	je return_process_line
	inc ecx
	jmp return_find_eol
	
return_process_line:
	cmp ecx, 0
	je return_advance
	
	push ecx
	push esi
	
	; Extract ISBN (3rd field) from line: username,bookname,ISBN,issuedate,returndate
	push esi
	xor edx, edx ; comma counter
return_skip_to_isbn:
	mov al, [esi]
	cmp al, 0
	je return_no_isbn_match_pop
	cmp al, 0Dh
	je return_no_isbn_match_pop
	cmp al, ','
	jne return_skip_next
	inc edx
	cmp edx, 2
	je return_isbn_field_found
return_skip_next:
	inc esi
	jmp return_skip_to_isbn
	
return_isbn_field_found:
	; Skip the comma
	inc esi
	
	; Copy ISBN to TEMP_FIELD
	mov edi, OFFSET TEMP_FIELD
return_copy_isbn_field:
	mov al, [esi]
	cmp al, 0
	je return_compare_isbn
	cmp al, 0Dh
	je return_compare_isbn
	cmp al, ','
	je return_compare_isbn
	mov [edi], al
	inc esi
	inc edi
	jmp return_copy_isbn_field
	
return_compare_isbn:
	mov byte ptr [edi], 0
	
	; Compare with ISBN_SEARCH_BUF
	INVOKE Str_compare, ADDR ISBN_SEARCH_BUF, ADDR TEMP_FIELD
	pop esi ; restore original line start
	je return_skip_this_line ; Found it, don't write it back

return_no_isbn_match_pop:
	pop esi ; clean up the extra push
	
return_no_isbn_match:
	; Not the ISBN we're looking for, write it back
	pop esi
	pop ecx
	
	; Write line
	mov eax, filehandle
	mov edx, esi
	call WriteToFile
	
	; Write CRLF
	mov eax, filehandle
	mov edx, OFFSET CRLF_BYTES
	push ecx
	mov ecx, 2
	call WriteToFile
	pop ecx
	
	jmp return_advance
	
return_skip_this_line:
	; Mark as found
	mov edi, OFFSET TEMP_LINE
	mov byte ptr [edi], 1
	pop esi
	pop ecx
	
return_advance:
	add ebx, ecx
	cmp byte ptr [OFFSET buffer_mem + ebx], 0Dh
	jne return_skip_lf
	inc ebx
return_skip_lf:
	cmp byte ptr [OFFSET buffer_mem + ebx], 0Ah
	jne return_next_line
	inc ebx
return_next_line:
	jmp return_search_loop
	
return_check_found:
	INVOKE CloseHandle, filehandle
	
	; Check if we found the ISBN
	mov edi, OFFSET TEMP_LINE
	cmp byte ptr [edi], 1
	jne return_book_not_issued
	
	INVOKE MSG_DISPLAY, ADDR BOOK_RETURNED_SUCCESS_MSG
	JMP SHOW_MEMBER_MENU
	
return_book_not_issued:
	INVOKE MSG_DISPLAY, ADDR BOOK_NOT_ISSUED_MSG
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

; Sort option handlers
SORT_NAME_ASC:
    mov eax, 0  ; field index 0 = name
    mov ebx, 0  ; ascending order
    call SortAndDisplayBooks
    JMP SHOW_MEMBER_MENU

SORT_NAME_DESC:
    mov eax, 0  ; field index 0 = name
    mov ebx, 1  ; descending order
    call SortAndDisplayBooks
    JMP SHOW_MEMBER_MENU

SORT_AUTHOR_ASC:
    mov eax, 1  ; field index 1 = author
    mov ebx, 0  ; ascending order
    call SortAndDisplayBooks
    JMP SHOW_MEMBER_MENU

SORT_AUTHOR_DESC:
    mov eax, 1  ; field index 1 = author
    mov ebx, 1  ; descending order
    call SortAndDisplayBooks
    JMP SHOW_MEMBER_MENU

SORT_PUB_ASC:
    mov eax, 2  ; field index 2 = publisher
    mov ebx, 0  ; ascending order
    call SortAndDisplayBooks
    JMP SHOW_MEMBER_MENU

SORT_PUB_DESC:
    mov eax, 2  ; field index 2 = publisher
    mov ebx, 1  ; descending order
    call SortAndDisplayBooks
    JMP SHOW_MEMBER_MENU

SORT_YEAR_ASC:
    mov eax, 4  ; field index 4 = year
    mov ebx, 0  ; ascending order
    call SortAndDisplayBooks
    JMP SHOW_MEMBER_MENU

SORT_YEAR_DESC:
    mov eax, 4  ; field index 4 = year
    mov ebx, 1  ; descending order
    call SortAndDisplayBooks
    JMP SHOW_MEMBER_MENU

SORT_ISBN_ASC:
    mov eax, 5  ; field index 5 = ISBN
    mov ebx, 0  ; ascending order
    call SortAndDisplayBooks
    JMP SHOW_MEMBER_MENU

SORT_ISBN_DESC:
    mov eax, 5  ; field index 5 = ISBN
    mov ebx, 1  ; descending order
    call SortAndDisplayBooks
    JMP SHOW_MEMBER_MENU

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

; ============================================================================
; SortAndDisplayBooks - Sorts books by a specified field and displays them
; Input: EAX = field index (0=name, 1=author, 2=publisher, 3=genre, 4=year, 5=ISBN)
;        EBX = order (0=ascending, 1=descending)
; ============================================================================
SortAndDisplayBooks PROC
	push eax
	push ebx
	push ecx
	push edx
	push esi
	push edi
	
	; Save sort parameters
	push eax  ; field index
	push ebx  ; order
	
	; Open BOOKS.txt
	INVOKE CreateFile, ADDR BOOKS_FILE, GENERIC_READ, DO_NOT_SHARE, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0
	cmp eax, INVALID_HANDLE_VALUE
	je sort_no_books
	
	mov filehandle, eax
	call ReadAllBooks
	
	; Check if file has data
	mov eax, DWORD PTR bytesRead
	cmp eax, 0
	je sort_no_books
	
	; Parse buffer into line pointers
	call ParseLinesIntoArray
	
	; Check if we have books
	mov eax, NUM_LINES
	cmp eax, 0
	je sort_no_books
	
	; Pop sort parameters
	pop ebx  ; order
	pop eax  ; field index
	
	; Sort the lines
	push eax
	push ebx
	call SortLines
	pop ebx
	pop eax
	
	; Display sorted books
	call DisplaySortedBooks
	
	jmp sort_done
	
sort_no_books:
	; Clean up stack
	pop ebx
	pop eax
	INVOKE MSG_DISPLAY, ADDR NO_BOOKS_MSG
	
sort_done:
	pop edi
	pop esi
	pop edx
	pop ecx
	pop ebx
	pop eax
	ret
SortAndDisplayBooks ENDP

; ============================================================================
; ParseLinesIntoArray - Parse BUFFER_BOOK into line pointers
; ============================================================================
ParseLinesIntoArray PROC
	pushad
	
	xor ebx, ebx  ; offset in BUFFER_BOOK
	xor ecx, ecx  ; line counter
	
parse_lines_loop:
	; Check if we reached end of buffer
	mov eax, DWORD PTR bytesRead
	cmp ebx, eax
	jge parse_lines_done
	
	; Check if we reached max books
	cmp ecx, MAX_BOOKS
	jge parse_lines_done
	
	; Store pointer to start of line
	lea esi, [OFFSET BUFFER_BOOK + ebx]
	mov edi, OFFSET LINE_POINTERS
	mov eax, ecx
	shl eax, 2  ; multiply by 4 (size of pointer)
	add edi, eax
	mov [edi], esi
	
	; Find end of line
	xor edx, edx  ; line length
parse_find_eol:
	mov al, [esi + edx]
	cmp al, 0
	je parse_line_end
	cmp al, 0Dh
	je parse_line_end
	cmp al, 0Ah
	je parse_line_end
	inc edx
	jmp parse_find_eol
	
parse_line_end:
	; Store line length
	mov edi, OFFSET LINE_LENGTHS
	mov eax, ecx
	shl eax, 2
	add edi, eax
	mov [edi], edx
	
	; Move to next line
	add ebx, edx
	
	; Skip CR/LF
parse_skip_crlf:
	cmp byte ptr [OFFSET BUFFER_BOOK + ebx], 0Dh
	jne parse_skip_lf
	inc ebx
parse_skip_lf:
	cmp byte ptr [OFFSET BUFFER_BOOK + ebx], 0Ah
	jne parse_next_line
	inc ebx
	
parse_next_line:
	inc ecx
	jmp parse_lines_loop
	
parse_lines_done:
	mov NUM_LINES, ecx
	popad
	ret
ParseLinesIntoArray ENDP

; ============================================================================
; SortLines - Bubble sort lines by specified field
; Input: EAX = field index, EBX = order (0=asc, 1=desc)
; Uses LINE_POINTERS array
; ============================================================================
SortLines PROC
	; Preserve caller-saved registers
	push eax
	push ebx
	push ecx
	push edx
	push esi
	push edi

	; Allocate locals and store params
	; [esp+0]  = swappedFlag (DWORD)
	; [esp+4]  = passCount  (DWORD)
	; [esp+8]  = fieldIndex (DWORD)
	; [esp+12] = order      (DWORD)
	sub esp, 16
	mov [esp+8], eax     ; save field index
	mov [esp+12], ebx    ; save order

	; Get number of lines
	mov ecx, NUM_LINES
	cmp ecx, 2
	jl sort_lines_done   ; need at least 2 lines to sort

	; Bubble sort outer loop (ecx = n-1 passes)
	dec ecx
	mov [esp+4], ecx     ; passCount

sort_outer_loop:
	mov DWORD PTR [esp], 0  ; swappedFlag = 0

	; Inner loop - compare adjacent elements
	mov edx, 0              ; current index
sort_inner_loop:
	mov eax, edx
	inc eax                 ; next index
	cmp eax, NUM_LINES
	jge sort_check_swapped

	; Get pointers to current and next lines
	mov esi, OFFSET LINE_POINTERS
	mov edi, edx
	shl edi, 2
	add esi, edi
	mov esi, [esi]          ; ESI = current line pointer

	mov edi, OFFSET LINE_POINTERS
	mov ebx, eax
	shl ebx, 2
	add edi, ebx
	mov edi, [edi]          ; EDI = next line pointer

	; Load comparison parameters
	mov eax, [esp+8]        ; field index
	mov ebx, [esp+12]       ; order
	call CompareFields      ; EAX = cmp result (-1,0,1)

	; Check if swap needed
	mov ebx, [esp+12]       ; order
	cmp ebx, 0
	je sort_check_asc

	; Descending order: swap if current < next
	cmp eax, 0
	jge sort_no_swap
	jmp sort_do_swap

sort_check_asc:
	; Ascending order: swap if current > next
	cmp eax, 0
	jle sort_no_swap

sort_do_swap:
	; Swap pointers in LINE_POINTERS
	mov esi, OFFSET LINE_POINTERS
	mov edi, edx
	shl edi, 2
	add esi, edi
	mov edi, [esi]          ; temp = LINE_POINTERS[edx]

	mov ebx, OFFSET LINE_POINTERS
	mov eax, edx
	inc eax
	shl eax, 2
	add ebx, eax
	mov eax, [ebx]
	mov [esi], eax          ; LINE_POINTERS[edx] = LINE_POINTERS[edx+1]
	mov [ebx], edi          ; LINE_POINTERS[edx+1] = temp

	; Set swapped flag
	mov DWORD PTR [esp], 1

sort_no_swap:
	inc edx
	jmp sort_inner_loop

sort_check_swapped:
	; If no swaps were made, we're done
	cmp DWORD PTR [esp], 0
	je sort_lines_done

	dec DWORD PTR [esp+4]   ; passCount--
	cmp DWORD PTR [esp+4], 0
	jg sort_outer_loop

sort_lines_done:
	; Free locals and restore registers
	add esp, 16

	pop edi
	pop esi
	pop edx
	pop ecx
	pop ebx
	pop eax
	ret
SortLines ENDP

; ============================================================================
; CompareFields - Compare specified field from two CSV lines
; Input: ESI = pointer to line 1, EDI = pointer to line 2
;        EAX = field index (0=name, 1=author, etc.)
; Output: EAX = 0 if equal, <0 if line1<line2, >0 if line1>line2
; ============================================================================
CompareFields PROC
	push ebx
	push ecx
	push edx
	push esi
	push edi
	
	; Save field index
	push eax
	
	; Extract field from line 1 into TEMP_FIELD
	call ExtractField
	
	; Copy TEMP_FIELD to SORT_TEMP_LINE for later comparison
	push esi
	push edi
	mov esi, OFFSET TEMP_FIELD
	mov edi, OFFSET SORT_TEMP_LINE
	mov ecx, 200
cmp_copy_loop:
	mov al, [esi]
	mov [edi], al
	cmp al, 0
	je cmp_copy_done
	inc esi
	inc edi
	loop cmp_copy_loop
cmp_copy_done:
	pop edi
	pop esi
	
	; Convert SORT_TEMP_LINE to uppercase for case-insensitive comparison
	push eax
	INVOKE Str_ucase, ADDR SORT_TEMP_LINE
	pop eax
	
	; Extract field from line 2 into TEMP_FIELD
	mov esi, edi
	pop eax
	push eax
	call ExtractField
	
	; Convert TEMP_FIELD to uppercase for case-insensitive comparison
	push eax
	INVOKE Str_ucase, ADDR TEMP_FIELD
	pop eax
	
	; Compare SORT_TEMP_LINE with TEMP_FIELD (both now uppercase)
	; Do lexicographic comparison manually using unsigned comparison
	push esi
	push edi
	mov esi, OFFSET SORT_TEMP_LINE
	mov edi, OFFSET TEMP_FIELD
	xor eax, eax
cmp_strcmp_loop:
	mov al, [esi]
	mov bl, [edi]
	cmp al, bl
	jb cmp_less_than    ; Use unsigned comparison (jb instead of jl)
	ja cmp_greater_than ; Use unsigned comparison (ja instead of jg)
	cmp al, 0
	je cmp_equal
	inc esi
	inc edi
	jmp cmp_strcmp_loop
cmp_less_than:
	mov eax, -1
	jmp cmp_strcmp_done
cmp_greater_than:
	mov eax, 1
	jmp cmp_strcmp_done
cmp_equal:
	xor eax, eax
cmp_strcmp_done:
	pop edi
	pop esi
	; EAX now contains comparison result (-1, 0, or 1)
	
	pop ebx  ; clean up field index from stack
	
	pop edi
	pop esi
	pop edx
	pop ecx
	pop ebx
	ret
CompareFields ENDP

; ============================================================================
; ExtractField - Extract specified field from CSV line
; Input: ESI = pointer to CSV line, EAX = field index
; Output: TEMP_FIELD contains extracted field
; ============================================================================
ExtractField PROC
	push ebx
	push ecx
	push edx
	push esi
	push edi
	
	; Clear TEMP_FIELD
	push eax
	mov edi, OFFSET TEMP_FIELD
	mov ecx, 200
	xor al, al
extract_clear:
	mov [edi], al
	inc edi
	loop extract_clear
	pop eax
	
	; EAX = field index, ESI = line pointer
	mov ecx, eax  ; ecx = fields to skip
	mov edx, 0    ; comma counter
	
	; Skip to the desired field
extract_skip_fields:
	cmp ecx, 0
	je extract_copy_field
	
	mov al, [esi]
	cmp al, 0
	je extract_field_done
	cmp al, 0Dh
	je extract_field_done
	cmp al, 0Ah
	je extract_field_done
	cmp al, ','
	jne extract_next_char
	dec ecx
	
extract_next_char:
	inc esi
	jmp extract_skip_fields
	
extract_copy_field:
	; Copy field to TEMP_FIELD
	mov edi, OFFSET TEMP_FIELD
extract_copy_loop:
	mov al, [esi]
	cmp al, 0
	je extract_field_done
	cmp al, 0Dh
	je extract_field_done
	cmp al, 0Ah
	je extract_field_done
	cmp al, ','
	je extract_field_done
	mov [edi], al
	inc esi
	inc edi
	jmp extract_copy_loop
	
extract_field_done:
	mov byte ptr [edi], 0
	
	pop edi
	pop esi
	pop edx
	pop ecx
	pop ebx
	ret
ExtractField ENDP

; ============================================================================
; DisplaySortedBooks - Display all sorted books from LINE_POINTERS array
; ============================================================================
DisplaySortedBooks PROC
	pushad
	
	; Display header
	INVOKE MSG_DISPLAY, ADDR VIEW_BOOKS_MSG
	
	; Loop through sorted line pointers
	xor ecx, ecx
display_sorted_loop:
	cmp ecx, NUM_LINES
	jge display_sorted_done
	
	; Get pointer to line
	mov esi, OFFSET LINE_POINTERS
	mov eax, ecx
	shl eax, 2
	add esi, eax
	mov esi, [esi]
	
	; Copy line to TEMP_LINE with proper null termination
	push ecx
	mov edi, OFFSET TEMP_LINE
	mov ecx, 0
display_copy_line:
	mov al, [esi]
	cmp al, 0
	je display_line_copied
	cmp al, 0Dh
	je display_line_copied
	cmp al, 0Ah
	je display_line_copied
	mov [edi], al
	inc esi
	inc edi
	inc ecx
	cmp ecx, 512
	jl display_copy_line
display_line_copied:
	mov byte ptr [edi], 0
	pop ecx
	
	; Display the line using DisplayBookLine helper
	push ecx
	mov edx, OFFSET TEMP_LINE
	call DisplayBookLine
	pop ecx
	
	inc ecx
	jmp display_sorted_loop
	
display_sorted_done:
	popad
	ret
DisplaySortedBooks ENDP

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