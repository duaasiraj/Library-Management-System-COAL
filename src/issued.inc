
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
	
	; Write username, book name, ISBN, and issue date via helper
	INVOKE WriteCSVField, filehandle, OFFSET USERNAME_BUF
	INVOKE WriteCSVField, filehandle, OFFSET ISSUED_BOOK_NAME_BUF
	INVOKE WriteCSVField, filehandle, OFFSET ISBN_SEARCH_BUF
	INVOKE WriteCSVField, filehandle, OFFSET DATE_BUF
	
	; Write return date (final field, no trailing comma)
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

	; Loop and rebuild file
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

