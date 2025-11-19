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

; ---------------------------------------------------------
; ReadWholeFile
; IN:  fileName (LPSTR), destBuf (LPBYTE)
; OUT: EAX = bytesRead  (0 if failure)
; ---------------------------------------------------------

ReadWholeFile PROC fileName:DWORD, destBuf:DWORD
    LOCAL hFile:DWORD
    LOCAL LocalbytesRead:DWORD

    INVOKE CreateFile, fileName, GENERIC_READ, 0, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0
    mov hFile, eax
    cmp eax, INVALID_HANDLE_VALUE
    je  read_fail

    INVOKE ReadFile, hFile, destBuf, BUFFER_SIZE, ADDR LocalbytesRead, 0
    INVOKE CloseHandle, hFile

    ; Null-terminate buffer
    mov ecx, LocalbytesRead
    mov edi, destBuf
    mov byte ptr [edi+ecx], 0

    mov eax, LocalbytesRead
    ret

read_fail:
    xor eax, eax
    ret
ReadWholeFile ENDP

; ---------------------------------------------------------
; NextLine
; IN:  buffer (char*), pOffset (DWORD*)
; OUT: EAX = line pointer
;      EDX = line length (bytes, not including CR/LF)
;      Offset updated for next call
; ---------------------------------------------------------

NextLine PROC buffer:DWORD, pOffset:DWORD
    push esi
    push edi
    push ebx
    push ecx

    mov ebx, pOffset
    mov eax, [ebx]        ; offset
    mov esi, buffer
    add esi, eax          ; esi = ptr to this line
    mov edi, esi

    ; Check end of buffer
    cmp byte ptr [esi], 0
    je end_of_lines

    ; Find line length until CR or LF or 0
    xor ecx, ecx
find_eol:
    mov al, [esi+ecx]
    cmp al, 0
    je got_len
    cmp al, 0Dh
    je got_len
    cmp al, 0Ah
    je got_len
    inc ecx
    jmp find_eol

got_len:
    ; Output:
    mov eax, edi  ; line pointer
    mov edx, ecx  ; line length

    ; Advance offset:
    add [ebx], ecx     ; skip content

    ; Skip CR
   mov esi, buffer
    add esi, [ebx]
    mov al, [esi]

    cmp al, 0Dh
    jne skip_lf
    inc dword ptr [ebx]

skip_lf:
    mov esi, buffer
    add esi, [ebx]
    mov al, [esi]

    cmp al, 0Ah
    jne done
    inc dword ptr [ebx]

done:
    pop ecx
    pop ebx
    pop edi
    pop esi
    ret

end_of_lines:
    xor eax, eax
    xor edx, edx
    jmp done

NextLine ENDP

; ---------------------------------------------------------
; FindField
; Extracts field #fieldIndex from a CSV line.
;
; IN:  linePtr    (char*)
;      fieldIndex (0-based)
;      outPtr     (char*)
; OUT: outPtr filled with field, null-terminated
; ---------------------------------------------------------

FindField PROC USES esi edi ecx edx, linePtr:DWORD, fieldIndex:DWORD, outPtr:DWORD
    mov esi, linePtr
    mov edi, outPtr
    xor ecx, ecx              ; current field number

; Skip fields until we reach fieldIndex
skipFields:
    cmp ecx, fieldIndex
    je copyField
    lodsb
    cmp al, 0
    je endField
    cmp al, 0Dh
    je endField
    cmp al, ','
    jne skipFields
    inc ecx
    jmp skipFields

; Copy field into buffer
copyField:
    lodsb
    cmp al, 0
    je endField
    cmp al, 0Dh
    je endField
    cmp al, ','
    je endField
    stosb
    jmp copyField

endField:
    mov byte ptr [edi], 0
    ret

FindField ENDP

; NUM_FIELDS must match your CSV format
NUM_FIELDS EQU 6    ; name, author, publisher, genre, year, ISBN

ParseCSVLine PROC USES esi edi ecx edx, srcPtr:DWORD, dstArrayPtr:DWORD
    mov esi, srcPtr
    mov ebx, dstArrayPtr
    xor ecx, ecx

parseLoop:
    cmp ecx, NUM_FIELDS
    jge done
    mov edi, [ebx + ecx*4]
    INVOKE FindField, esi, ecx, edi
    inc ecx
    jmp parseLoop

done:
    ret
ParseCSVLine ENDP

; WriteCSVField - writes a string buffer to file, then a comma
; Expects: eax = file handle, edx = buffer address
WriteCSVField PROC fh:DWORD, buf:DWORD
    push ecx
    push edx

    ; Write the buffer
    mov edx, buf
    INVOKE Str_length, edx
    mov ecx, eax
    mov eax, fh
    call WriteToFile

    ; Write comma
    mov eax, fh
    mov edx, OFFSET COMMA_BYTE
    mov ecx, 1
    call WriteToFile

    pop edx
    pop ecx
    ret
WriteCSVField ENDP
