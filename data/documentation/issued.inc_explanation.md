# issued.inc - Book Issue and Return Module

## Overview
The `issued.inc` file manages the book circulation system, handling book checkouts, returns, and viewing issued books. It implements a 10-day borrowing period with automatic return date calculation.

---

## Core Procedures

### 1. ISSUE_BOOK_FUNC - Issue Book to Member

#### Purpose
Allows authenticated members to check out books from the library with a 5-book limit per user.

#### Process Flow

**Phase 1: User Limit Verification**
```assembly
; Check if user has already issued 5 books
INVOKE CreateFile, ADDR ISSUED_BOOKS_FILE, GENERIC_READ, ...
INVOKE ReadFile, filehandle, ADDR buffer_mem, BUFFER_SIZE, ...

xor esi, esi  ; Counter for user's books

issue_count_loop:
    ; Extract username (first field)
    ; Compare with USERNAME_BUF
    INVOKE Str_compare, ADDR USERNAME_BUF, ADDR TEMP_FIELD
    jne issue_count_advance
    inc esi  ; Increment count if match
```
- Reads ISSUED_BOOKS.txt
- Counts books issued by current user
- Limit: 5 books maximum
- Jumps to `issue_limit_reached` if limit exceeded

**Phase 2: ISBN Input**
```assembly
INVOKE MSG_DISPLAY, ADDR ISSUE_BOOK_MSG
mov edx, OFFSET ISBN_SEARCH_BUF
mov ecx, 20
CALL READSTRING
```

**Phase 3: Book Existence Verification**
```assembly
INVOKE CreateFile, ADDR BOOKS_FILE, GENERIC_READ, ...
CALL ReadAllBooks

; Search for ISBN in BOOKS.txt (field 6)
issue_search_loop:
    ; Skip 5 commas to reach ISBN field
    issue_find_isbn_field:
        cmp edx, 5
        je issue_extract_isbn
        
    ; Compare ISBN
    INVOKE Str_compare, ADDR ISBN_SEARCH_BUF, ADDR TEMP_FIELD
    je issue_book_found
```
- Opens BOOKS.txt
- Searches for matching ISBN
- Jumps to `issue_book_not_found` if not found

**Phase 4: Duplicate Issue Check**
```assembly
; Check if book already issued
INVOKE CreateFile, ADDR ISSUED_BOOKS_FILE, GENERIC_READ, ...

issue_check_loop:
    ; Extract ISBN from issued books (3rd field)
    ; Compare with search buffer
    INVOKE Str_compare, ADDR ISBN_SEARCH_BUF, ADDR TEMP_FIELD
    je issue_already_issued
```
- Prevents same book being issued twice
- Any member with book blocks checkout

**Phase 5: Date Calculation**

**Current Date Retrieval**:
```assembly
sub esp, 16  ; Allocate SYSTEMTIME structure
mov esi, esp
INVOKE GetLocalTime, esi

movzx eax, WORD PTR [esi+2]  ; wMonth (offset 2)
movzx ebx, WORD PTR [esi+6]  ; wDay (offset 6)
movzx ecx, WORD PTR [esi]    ; wYear (offset 0)
```

**SYSTEMTIME Structure Layout**:
| Offset | Field | Size |
|--------|-------|------|
| 0 | wYear | 2 bytes |
| 2 | wMonth | 2 bytes |
| 4 | wDayOfWeek | 2 bytes |
| 6 | wDay | 2 bytes |
| 8 | wHour | 2 bytes |
| 10 | wMinute | 2 bytes |
| 12 | wSecond | 2 bytes |
| 14 | wMilliseconds | 2 bytes |

**Date Formatting** (DD/MM/YYYY):
```assembly
; Day (2 digits)
xor edx, edx
mov ecx, 10
div ecx
add al, '0'  ; Tens digit
mov [edi], al
mov al, dl
add al, '0'  ; Ones digit
mov [edi+1], al

; Separator
mov byte ptr [edi+2], '/'

; Month (2 digits) - same process
; Year (4 digits) - divide by 1000, 100, 10, 1
```

**Return Date Calculation** (10-day period):
```assembly
; Add 10 to the day
add eax, 10

; Check if day exceeds 30
cmp eax, 30
jle return_date_ok

; Move to next month
sub eax, 30
inc ebx

; Check if month exceeds 12
cmp ebx, 12
jle return_date_ok

; Move to next year
sub ebx, 12
inc ecx
```
- **Simplification**: Assumes 30 days per month
- **Limitation**: Doesn't handle actual month lengths
- **Example**: Jan 25 + 10 days = Feb 4 (not Feb 5)

**Phase 6: Write to ISSUED_BOOKS.txt**
```assembly
INVOKE CreateFile, ADDR ISSUED_BOOKS_FILE, GENERIC_WRITE, ...
INVOKE SetFilePointer, filehandle, 0, 0, FILE_END

; Write CSV line: username,bookname,ISBN,issuedate,returndate
; Write username
mov edx, OFFSET USERNAME_BUF
INVOKE Str_length, edx
mov ecx, eax
call WriteToFile

; Write comma
mov edx, OFFSET COMMA_BYTE
mov ecx, 1
call WriteToFile

; ... repeat for bookname, ISBN, dates ...

; Write CRLF
mov edx, OFFSET CRLF_BYTES
mov ecx, 2
call WriteToFile
```

**CSV Format**:
```
username,bookname,ISBN,DD/MM/YYYY,DD/MM/YYYY\r\n
```

**Example Entry**:
```
alice,1984,9780451524935,15/11/2025,25/11/2025
```

---

### 2. RETURN_BOOK_FUNC - Return Borrowed Book

#### Purpose
Processes book returns by removing entries from ISSUED_BOOKS.txt.

#### Process Flow

**Phase 1: ISBN Input**
```assembly
INVOKE MSG_DISPLAY, ADDR RETURN_BOOK_MSG
mov edx, OFFSET ISBN_SEARCH_BUF
mov ecx, 20
CALL READSTRING
```

**Phase 2: Load Issued Books**
```assembly
INVOKE CreateFile, ADDR ISSUED_BOOKS_FILE, GENERIC_READ, ...
INVOKE ReadFile, filehandle, ADDR buffer_mem, BUFFER_SIZE, ...
INVOKE CloseHandle, filehandle

; Null-terminate
mov edi, OFFSET buffer_mem
mov ecx, DWORD PTR bytesRead
mov byte ptr [edi + ecx], 0
```

**Phase 3: File Rebuild Strategy**
```assembly
; Reopen file for writing (truncate)
INVOKE CreateFile, ADDR ISSUED_BOOKS_FILE, GENERIC_WRITE, ...
; CREATE_ALWAYS truncates existing file

return_search_loop:
    ; Extract ISBN (3rd field) from each line
    ; If ISBN doesn't match search, write line back
    ; If ISBN matches, skip line (effectively deleting it)
```

**ISBN Extraction Logic**:
```assembly
return_skip_to_isbn:
    mov al, [esi]
    cmp al, ','
    jne return_skip_next
    inc edx
    cmp edx, 2  ; Skip 2 commas to reach ISBN
    je return_isbn_field_found

return_isbn_field_found:
    inc esi  ; Skip comma
    
    ; Copy ISBN to TEMP_FIELD
    return_copy_isbn_field:
        mov al, [esi]
        cmp al, ','
        je return_compare_isbn
```

**Conditional Write**:
```assembly
return_compare_isbn:
    INVOKE Str_compare, ADDR ISBN_SEARCH_BUF, ADDR TEMP_FIELD
    je return_skip_this_line  ; Found it, don't write

return_no_isbn_match:
    ; Write line back to file
    mov eax, filehandle
    mov edx, esi
    call WriteToFile
    
    ; Write CRLF
    mov edx, OFFSET CRLF_BYTES
    mov ecx, 2
    call WriteToFile
    
return_skip_this_line:
    ; Mark as found
    mov byte ptr [TEMP_LINE], 1
```

**Phase 4: Success/Failure Check**
```assembly
return_check_found:
    INVOKE CloseHandle, filehandle
    
    cmp byte ptr [TEMP_LINE], 1
    jne return_book_not_issued
    
    INVOKE MSG_DISPLAY, ADDR BOOK_RETURNED_SUCCESS_MSG
    JMP SHOW_MEMBER_MENU
```

#### Return Logic Summary
1. Read entire file into memory
2. Create new file (truncate old)
3. Write all lines EXCEPT the one being returned
4. Close file
5. Result: Book removed from issued list

---

### 3. VIEW_ISSUED_BOOKS_FUNC - Display All Issued Books

#### Purpose
Shows complete list of all currently checked-out books (librarian view).

#### Process Flow

**Phase 1: File Reading**
```assembly
INVOKE MSG_DISPLAY, ADDR ISSUED_BOOKS_HEADER
INVOKE CreateFile, ADDR ISSUED_BOOKS_FILE, GENERIC_READ, ...
INVOKE ReadFile, filehandle, ADDR buffer_mem, BUFFER_SIZE, ...
INVOKE CloseHandle, filehandle
```

**Phase 2: Line-by-Line Parsing**
```assembly
xor ebx, ebx  ; offset
xor esi, esi  ; counter

view_issued_loop:
    lea edi, [OFFSET buffer_mem + ebx]
    
    ; Find line length
    view_issued_find_eol:
        cmp al, 0Dh
        je view_issued_process_line
```

**Phase 3: Field Extraction**

**CSV Format**: `username,bookname,ISBN,issuedate,returndate`

1. **Username** (field 1):
   ```assembly
   view_issued_extract_user:
       mov al, [esi]
       cmp al, ','
       je view_issued_user_done
       mov [edi], al
   ```
   → Stored in `OVERDUE_USERNAME_BUF`

2. **Book Name** (field 2):
   ```assembly
   view_issued_extract_book:
       cmp al, ','
       je view_issued_book_done
   ```
   → Stored in `OVERDUE_BOOKNAME_BUF`

3. **ISBN** (field 3):
   → Stored in `OVERDUE_ISBN_BUF`

4. **Issue Date** (field 4):
   → Stored in `OVERDUE_ISSUE_DATE_BUF`

5. **Return Date** (field 5):
   ```assembly
   view_issued_extract_return:
       cmp al, 0Dh
       je view_issued_return_done
       cmp al, 0Ah
       je view_issued_return_done
   ```
   → Stored in `PARSED_RETURN_DATE_BUF`

**Phase 4: Display Formatted Output**
```assembly
INVOKE MSG_DISPLAY, ADDR USERNAME_LABEL
INVOKE MSG_DISPLAY, ADDR OVERDUE_USERNAME_BUF
INVOKE MSG_DISPLAY, ADDR CRLF_BYTES

INVOKE MSG_DISPLAY, ADDR NAME_LABEL
INVOKE MSG_DISPLAY, ADDR OVERDUE_BOOKNAME_BUF
INVOKE MSG_DISPLAY, ADDR CRLF_BYTES

; ... ISBN, Issue Date, Return Date ...

INVOKE MSG_DISPLAY, ADDR OVERDUE_SEPARATOR
inc esi  ; increment counter
```

**Sample Output**:
```
========== ISSUED BOOKS ==========
Username: alice
Name: 1984
ISBN: 9780451524935
Issue Date: 15/11/2025
Return Date: 25/11/2025
-----------------------------------
Username: bob
Name: Brave New World
ISBN: 9780060850524
Issue Date: 10/11/2025
Return Date: 20/11/2025
-----------------------------------
```

---

## Data Structures

### ISSUED_BOOKS.txt Format
```csv
username,bookname,ISBN,issuedate,returndate
alice,1984,9780451524935,15/11/2025,25/11/2025
bob,Brave New World,9780060850524,10/11/2025,20/11/2025
```

### Field Definitions
| Field | Max Length | Example | Validation |
|-------|-----------|---------|------------|
| Username | 20 chars | alice | From `USERNAME_BUF` |
| Bookname | 150 chars | 1984 | From BOOKS.txt |
| ISBN | 20 chars | 9780451524935 | 13 digits |
| Issue Date | 10 chars | 15/11/2025 | DD/MM/YYYY |
| Return Date | 10 chars | 25/11/2025 | DD/MM/YYYY |

---

## Date Handling

### Windows API: GetLocalTime
```assembly
SYSTEMTIME STRUCT
    wYear         WORD ?
    wMonth        WORD ?
    wDayOfWeek    WORD ?
    wDay          WORD ?
    wHour         WORD ?
    wMinute       WORD ?
    wSecond       WORD ?
    wMilliseconds WORD ?
SYSTEMTIME ENDS
```

### Date Arithmetic Issues
1. **Month Length**: Assumes all months have 30 days
2. **Leap Years**: Not handled
3. **Year Boundary**: Basic rollover logic
4. **Accuracy**: ±1 day error possible

### Correct Implementation Would Need
```assembly
; Array of days per month
monthDays BYTE 31,28,31,30,31,30,31,31,30,31,30,31

; Leap year check
mov eax, year
test eax, 3      ; Check if divisible by 4
jnz not_leap
; Additional checks for 100 and 400...
```

---

## Stack Usage Patterns

### Issue Book Stack
```assembly
push ecx    ; year
push eax    ; month
push ebx    ; day
; ... date formatting ...
pop eax     ; day
pop ebx     ; month
pop ecx     ; year
; ... return date calculation ...
```

### Return Book Stack
```assembly
push ecx    ; line length
push edi    ; line pointer
push esi    ; field pointer
; ... processing ...
pop esi
pop edi
pop ecx
```

---

## Error Messages

### Issue Errors
- `issue_limit_reached`: "Maximum limit of 5 issued books"
- `issue_book_not_found`: "Book not found in library"
- `issue_already_issued`: "This book is already issued"

### Return Errors
- `return_book_not_issued`: "Book was not issued to any member"

### Success Messages
- `BOOK_ISSUED_SUCCESS_MSG`: "Book issued successfully!"
- `BOOK_RETURNED_SUCCESS_MSG`: "Book returned successfully!"

---

## Register Usage

### Common Pattern
- **EBX**: Offset into buffer
- **ECX**: Line length
- **ESI**: Source pointer / counter
- **EDI**: Destination pointer
- **EDX**: Field position
- **EAX**: Date components, lengths

---

## Business Logic

### Borrowing Rules
1. **Limit**: 5 books per member
2. **Period**: 10 days
3. **Check**: Book must exist in catalog
4. **Duplicate**: Same book can't be issued twice (by anyone)

### Return Rules
1. **Verification**: ISBN must match issued book
2. **Instant**: No fine calculation on return
3. **Availability**: Book immediately available for re-issue

---

## File Operations

### Issue Book
1. Read ISSUED_BOOKS.txt (count)
2. Read BOOKS.txt (verify)
3. Read ISSUED_BOOKS.txt (duplicate check)
4. Append to ISSUED_BOOKS.txt

### Return Book
1. Read ISSUED_BOOKS.txt (full file)
2. Truncate ISSUED_BOOKS.txt
3. Write all except returned book

---

## Performance Considerations

### Issue Book: 4 File Operations
- Slow for large datasets
- Could use in-memory index

### Return Book: File Rewrite
- Inefficient for large files
- Better: Mark as returned (soft delete)

---

## Security Issues

1. **No User Verification**: Any member can return any book
2. **Race Conditions**: Concurrent issues not handled
3. **Data Loss**: File truncation risks in return process
4. **No Backup**: Failed write loses all data

---

## Related Files
- `data.inc`: Buffer definitions, constants
- `fines.inc`: Overdue checking, fine calculation
- `books.inc`: Book catalog management
- `members.inc`: User authentication
