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
