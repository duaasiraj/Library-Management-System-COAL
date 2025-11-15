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
