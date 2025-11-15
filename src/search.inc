; Search module: search.inc
; Contains member search menu and search-by-field routines

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

search_name_loop:
	mov eax, DWORD PTR bytesRead
	cmp ebx, eax
	jge search_name_done

	; Calculate line start pointer (don't use ESI here, keep it safe)
	lea edi, [OFFSET BUFFER_BOOK + ebx]
	
	; Find line length
	xor ecx, ecx
find_eol_name:
	mov al, [edi + ecx]
	cmp al, 0
	je process_name_line
	cmp al, 0Dh
	je process_name_line
	cmp al, 0Ah
	je process_name_line
	inc ecx
	jmp find_eol_name

process_name_line:
	; Store line length on stack for later use
	push ecx
	
	cmp ecx, 0
	je advance_name_offset_pop

	; find comma index in edx (0..ecx-1)
	xor edx, edx
find_comma_name:
	cmp edx, ecx
	jge advance_name_offset_pop
	cmp byte ptr [edi + edx], ','
	je got_comma_name
	inc edx
	jmp find_comma_name

got_comma_name:
	; Save edx (field length) and copy first field into TEMP_FIELD
	push edx
	push edi
	
	; Source: current line start (edi)
	; Dest: TEMP_FIELD
	; Length: edx
	mov esi, edi
	mov edi, OFFSET TEMP_FIELD
	mov ecx, edx
copy_field_name:
	cmp ecx, 0
	je term_field_name
	mov al, [esi]
	mov [edi], al
	inc esi
	inc edi
	dec ecx
	jmp copy_field_name
term_field_name:
	mov byte ptr [edi], 0

	; Restore edi (line start pointer)
	pop edi
	pop edx
	
	; compare user input BOOK_NAME_BUF with TEMP_FIELD
	INVOKE Str_compare, ADDR BOOK_NAME_BUF, ADDR TEMP_FIELD
	jne continue_name

	; match -> parse and display with labels
	; Get line length from stack (don't pop yet)
	mov ecx, [esp]
	
	; Copy full line to TEMP_LINE
	push edi
	mov esi, edi
	mov edi, OFFSET TEMP_LINE
copy_line_to_temp:
	cmp ecx, 0
	je term_temp_line
	mov al, [esi]
	mov [edi], al
	inc esi
	inc edi
	dec ecx
	jmp copy_line_to_temp
term_temp_line:
	mov byte ptr [edi], 0
	pop edi
	
	; Display formatted output with labels
	mov edx, OFFSET TEMP_LINE
	call DisplayBookLine

continue_name:
	; Get line length from stack
	pop ecx
	
	; advance offset by lineLen and skip CR/LF
	add ebx, ecx
	
	; skip CR then LF if present
	cmp byte ptr [OFFSET BUFFER_BOOK + ebx], 0Dh
	jne skip_lf_name
	inc ebx
skip_lf_name:
	cmp byte ptr [OFFSET BUFFER_BOOK + ebx], 0Ah
	jne cont_loop_name
	inc ebx
cont_loop_name:
	jmp search_name_loop

advance_name_offset_pop:
	; Pop the line length we pushed earlier
	pop ecx
	
	; Skip this line
	add ebx, ecx
	cmp byte ptr [OFFSET BUFFER_BOOK + ebx], 0Dh
	jne skip_lf_name2
	inc ebx
skip_lf_name2:
	cmp byte ptr [OFFSET BUFFER_BOOK + ebx], 0Ah
	jne after_cr_name
	inc ebx
after_cr_name:
	jmp search_name_loop

search_name_done:
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

	
