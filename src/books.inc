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

	; find end of line (ecc = line length)
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
