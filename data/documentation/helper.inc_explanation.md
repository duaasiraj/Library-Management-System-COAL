# helper.inc - Utility Procedures Module

## Overview
The `helper.inc` file (previously `logic.inc`) provides essential utility procedures used throughout the Library Management System. It contains helper functions for message display, string input, file operations, and formatted book display.

---

## Procedures

### 1. MSG_DISPLAY - Message Display Wrapper

#### Purpose
Simplifies displaying string messages by wrapping the `WRITESTRING` procedure.

#### Signature
```assembly
MSG_DISPLAY PROC USES EDX, VAR: ptr dword
    MOV EDX, VAR
    CALL WRITESTRING
    RET
MSG_DISPLAY ENDP
```

#### Parameters
- **VAR**: Pointer to null-terminated string (DWORD)

#### Registers
- **EDX**: Preserved (USES directive)
- **Modified**: None (caller's perspective)

#### Usage Example
```assembly
INVOKE MSG_DISPLAY, ADDR topMsg
; Equivalent to:
; mov edx, OFFSET topMsg
; call WriteString
```

#### Benefits
1. **INVOKE Syntax**: Allows high-level calling convention
2. **Register Preservation**: Automatic via USES
3. **Clarity**: Self-documenting procedure name
4. **Consistency**: Uniform message display across system

#### Implementation Details
**USES Directive**:
- Compiler-generated PUSH/POP for EDX
- Expands to:
  ```assembly
  MSG_DISPLAY PROC
      push edx
      mov edx, [esp+8]  ; Get VAR parameter
      call WriteString
      pop edx
      ret 4  ; Clean up parameter
  MSG_DISPLAY ENDP
  ```

---

### 2. STRING_INPUT - String Input Wrapper

#### Purpose
Standardized string input with fixed large buffer size.

#### Signature
```assembly
STRING_INPUT PROC USES EDX ECX, var: ptr dword
    MOV EDX, VAR
    MOV ECX, 5000
    CALL READSTRING
    RET
STRING_INPUT ENDP
```

#### Parameters
- **var**: Pointer to buffer (DWORD)

#### Behavior
- **EDX**: Buffer address
- **ECX**: Maximum characters (hardcoded to 5000)
- Calls Irvine32's `READSTRING`

#### Limitations
1. **Fixed Size**: Always 5000 characters
2. **No Validation**: Doesn't check buffer capacity
3. **Overflow Risk**: Buffer must be ≥5000 bytes
4. **Unused**: Not actively used in current codebase

#### Better Usage Pattern
```assembly
; Instead of using STRING_INPUT
INVOKE MSG_DISPLAY, ADDR prompt
mov edx, OFFSET buffer
mov ecx, BUFFER_SIZE  ; Actual buffer size
CALL READSTRING
```

**Why Not Used**:
- Most inputs have specific size limits (ISBN: 20, username: 20)
- 5000 is overkill and dangerous
- Direct `READSTRING` calls more flexible

---

### 3. ReadAllBooks - Complete File Reader

#### Purpose
Reads the entire BOOKS.txt file into `BUFFER_BOOK` with proper null-termination.

#### Signature
```assembly
ReadAllBooks PROC
    ; Expects: filehandle contains open file handle
    ; Returns: bytesRead updated, BUFFER_BOOK filled and null-terminated
    ; Modifies: File handle (closes it)
```

#### Process Flow

**Phase 1: Get File Size**
```assembly
pushad  ; Save all general-purpose registers

; Move to end of file
INVOKE SetFilePointer, filehandle, 0, 0, FILE_END
mov esi, eax  ; ESI = file size (low DWORD)
```

**FILE_END Constant**: 
- Value: 2
- Moves pointer to end
- Returns file size in EAX

**Phase 2: Return to Beginning**
```assembly
INVOKE SetFilePointer, filehandle, 0, 0, FILE_BEGIN
```

**FILE_BEGIN Constant**:
- Value: 0
- Resets pointer to start
- Essential for `ReadFile` to work

**Phase 3: Size Limiting**
```assembly
; Limit to BUFFER_SIZE-1 (leave space for NUL)
mov eax, BUFFER_SIZE  ; 5000
dec eax               ; 4999
cmp esi, eax
jle size_ok
mov esi, eax         ; Truncate to buffer size

size_ok:
```

**Why -1**: Reserve one byte for null terminator.

**Example**:
- File Size: 6000 bytes
- BUFFER_SIZE: 5000
- Read Limit: 4999 bytes
- Result: Truncated, last 1001 bytes lost

**Phase 4: Read File**
```assembly
INVOKE ReadFile, filehandle, ADDR BUFFER_BOOK, esi, ADDR bytesRead, 0
```

**ReadFile Parameters**:
1. **filehandle**: Open file handle
2. **ADDR BUFFER_BOOK**: Destination buffer
3. **esi**: Number of bytes to read
4. **ADDR bytesRead**: Pointer to DWORD receiving actual bytes read
5. **0**: NULL (no overlapped I/O)

**Phase 5: Close File**
```assembly
invoke CloseHandle, filehandle
```

**Important**: File handle closed automatically by this procedure.

**Phase 6: Null-Terminate Buffer**
```assembly
; Null-terminate at bytesRead position
mov eax, DWORD PTR bytesRead
lea edi, [OFFSET BUFFER_BOOK]
add edi, eax
mov byte ptr [edi], 0  ; BUFFER_BOOK[bytesRead] = '\0'

popad  ; Restore all registers
ret
```

**Why Null-Terminate**:
- CSV parsing relies on null terminator
- String functions expect null termination
- Prevents reading garbage beyond data

#### Usage Example
```assembly
; Open file
INVOKE CreateFile, ADDR BOOKS_FILE, GENERIC_READ, ...
mov filehandle, eax

; Read entire file
CALL ReadAllBooks
; File is now closed, BUFFER_BOOK filled, bytesRead set

; Check if file had data
mov eax, DWORD PTR bytesRead
cmp eax, 0
je no_books_found
```

#### Edge Cases

**Empty File**:
```
bytesRead = 0
BUFFER_BOOK[0] = '\0'
```

**Exactly BUFFER_SIZE File**:
```
File: 5000 bytes
Read: 4999 bytes
Last byte lost
```

**Small File**:
```
File: 50 bytes
Read: 50 bytes
BUFFER_BOOK[50] = '\0'
```

---

### 4. DisplayBookLine - Formatted Book Display

#### Purpose
Parses a CSV book line and displays it with labeled fields.

#### Signature
```assembly
DisplayBookLine PROC
    ; Expects: EDX = pointer to null-terminated CSV line
    ; Modifies: Book buffers, displays formatted output
```

#### Parameters
- **EDX**: Pointer to CSV line (must be null-terminated)

#### CSV Format Expected
```
Name,Author,Publisher,Genre,Year,ISBN
```

#### Process Flow

**Phase 1: Clear All Book Buffers**
```assembly
push eax
push ebx
push ecx
push edx
push esi
push edi

; Clear BOOK_NAME_BUF
mov edi, OFFSET BOOK_NAME_BUF
mov ecx, BOOK_NAME_SIZE  ; 150
xor al, al
dbl_clear_name:
    mov [edi], al
    inc edi
    loop dbl_clear_name
```

**Buffers Cleared**:
1. `BOOK_NAME_BUF` (150 bytes)
2. `BOOK_AUTHOR_BUF` (150 bytes)
3. `BOOK_PUBLISHER_BUF` (150 bytes)
4. `BOOK_GENRE_BUF` (100 bytes)
5. `BOOK_YEAR_BUF` (10 bytes)
6. `BOOK_ISBN_BUF` (20 bytes)

**Why Clear**: Prevents leftover data from previous calls.

**Phase 2: Parse CSV Line**

**Setup**:
```assembly
mov esi, edx  ; ESI = line pointer
```

**Field 1: Name**
```assembly
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
    inc esi  ; Skip comma
dbl_after_name:
```

**Pattern**: Copy characters until comma or null, skip comma if present.

**Fields 2-6**: Same pattern for Author, Publisher, Genre, Year, ISBN.

**Phase 3: Display with Labels**
```assembly
INVOKE MSG_DISPLAY, ADDR CRLF_BYTES

INVOKE MSG_DISPLAY, ADDR NAME_LABEL  ; "Name: "
mov edx, OFFSET BOOK_NAME_BUF
call WriteString
call CRLF

INVOKE MSG_DISPLAY, ADDR AUTHOR_LABEL  ; "Author: "
mov edx, OFFSET BOOK_AUTHOR_BUF
call WriteString
call CRLF

; ... repeat for all 6 fields ...
```

**Display Sequence**:
1. Blank line (CRLF)
2. "Name: " + book name + newline
3. "Author: " + author + newline
4. "Publisher: " + publisher + newline
5. "Genre: " + genre + newline
6. "Year: " + year + newline
7. "ISBN: " + ISBN + newline

**Phase 4: Cleanup**
```assembly
pop edi
pop esi
pop edx
pop ecx
pop ebx
pop eax
ret
```

#### Sample Input/Output

**Input** (EDX points to):
```
"1984,George Orwell,Secker & Warburg,Dystopian,1949,9780451524935"
```

**Output** (to console):
```

Name: 1984
Author: George Orwell
Publisher: Secker & Warburg
Genre: Dystopian
Year: 1949
ISBN: 9780451524935
```

#### Edge Cases Handled

**Missing Fields**:
```
Input: "1984,Orwell"
Result:
    Name: 1984
    Author: Orwell
    Publisher: 
    Genre: 
    Year: 
    ISBN: 
```

**Empty Fields**:
```
Input: "1984,,Secker,,1949,"
Result:
    Name: 1984
    Author: 
    Publisher: Secker
    Genre: 
    Year: 1949
    ISBN: 
```

**Extra Commas**:
```
Input: "1984,Orwell,Secker,Dystopian,1949,9780451524935,Extra"
Result: Parses first 6 fields, ignores "Extra"
```

---

## Helper Comparison

### MSG_DISPLAY vs Direct WRITESTRING

**Using MSG_DISPLAY**:
```assembly
INVOKE MSG_DISPLAY, ADDR message
```

**Direct WRITESTRING**:
```assembly
mov edx, OFFSET message
call WriteString
```

**Advantages of MSG_DISPLAY**:
- High-level INVOKE syntax
- Automatic register preservation
- Parameter passing via stack
- More readable code

**Disadvantages**:
- Slight overhead (stack operations)
- One extra procedure call
- More instructions generated

---

## File Reading Best Practices

### Current Implementation Issues

**ReadAllBooks**:
```assembly
; Problem: Silent truncation
mov eax, BUFFER_SIZE
dec eax
cmp esi, eax
jle size_ok
mov esi, eax  ; Truncates without warning
```

**Better Implementation**:
```assembly
mov eax, BUFFER_SIZE
dec eax
cmp esi, eax
jle size_ok

; File too large - notify user
INVOKE MSG_DISPLAY, ADDR FILE_TOO_LARGE_MSG
; Option: Read first N books, ignore rest
; Option: Dynamic allocation
; Option: Chunked reading
```

### Dynamic Buffer Allocation (Future Enhancement)
```assembly
; Get file size
INVOKE SetFilePointer, filehandle, 0, 0, FILE_END
mov esi, eax

; Allocate dynamic buffer
INVOKE HeapAlloc, processHeap, 0, esi
mov bufferPtr, eax

; Read into dynamic buffer
INVOKE ReadFile, filehandle, bufferPtr, esi, ADDR bytesRead, 0

; Process...

; Free buffer
INVOKE HeapFree, processHeap, 0, bufferPtr
```

---

## Display Formatting

### DisplayBookLine Output Format

**Standard Format**:
```
[blank line]
Name: [value]
Author: [value]
Publisher: [value]
Genre: [value]
Year: [value]
ISBN: [value]
```

**Compact Alternative** (not implemented):
```
[Name] by [Author] ([Year]) | ISBN: [ISBN]
```

**Table Format** (not implemented):
```
+------------------+------------------+------+
| Name             | Author           | Year |
+------------------+------------------+------+
| 1984             | George Orwell    | 1949 |
| Animal Farm      | George Orwell    | 1945 |
+------------------+------------------+------+
```

---

## Register Usage Patterns

### MSG_DISPLAY
- **Preserves**: EDX (via USES)
- **Uses**: EDX (internally)
- **Stack**: 1 parameter (4 bytes)

### STRING_INPUT
- **Preserves**: EDX, ECX (via USES)
- **Uses**: EDX, ECX (internally)
- **Stack**: 1 parameter (4 bytes)

### ReadAllBooks
- **Preserves**: All (via PUSHAD/POPAD)
- **Uses**: EAX, ESI, EDI (internally)
- **Modifies**: filehandle (closes), bytesRead, BUFFER_BOOK

### DisplayBookLine
- **Preserves**: All (manual push/pop)
- **Uses**: All general-purpose (internally)
- **Modifies**: All BOOK_*_BUF buffers

---

## Buffer Management

### Buffer Clearing Pattern
```assembly
; Fill buffer with zeros
mov edi, OFFSET buffer
mov ecx, buffer_size
xor al, al
clear_loop:
    mov [edi], al
    inc edi
    loop clear_loop
```

**Alternative (Faster)**:
```assembly
; Using STOSB
mov edi, OFFSET buffer
mov ecx, buffer_size
xor al, al
rep stosb  ; Fills ECX bytes at EDI with AL
```

**Why Not Used**: Possibly for clarity/readability.

---

## Error Handling

### ReadAllBooks Errors

**No Error Checking**:
- `SetFilePointer` failure not checked
- `ReadFile` failure not checked
- Assumes file handle is valid

**Robust Version**:
```assembly
INVOKE SetFilePointer, filehandle, 0, 0, FILE_END
cmp eax, INVALID_SET_FILE_POINTER
je read_error

INVOKE ReadFile, filehandle, ADDR BUFFER_BOOK, esi, ADDR bytesRead, 0
test eax, eax
jz read_error

; Success path
jmp read_success

read_error:
    ; Handle error
    mov DWORD PTR bytesRead, 0
    
read_success:
    invoke CloseHandle, filehandle
```

---

## Performance Considerations

### Procedure Call Overhead

**MSG_DISPLAY**:
```
1. CALL instruction
2. PUSH parameters (INVOKE)
3. PUSH EDX (USES)
4. MOV EDX, [ESP+8]
5. CALL WriteString
6. POP EDX
7. RET 4
```
**Cost**: ~7 instructions vs 2 for direct call

**When Overhead Matters**: Tight loops, high-frequency calls

**When It Doesn't**: One-time displays, user interaction

### Buffer Clearing Optimization

**Current** (DisplayBookLine):
```assembly
; 150 iterations for BOOK_NAME_BUF
loop dbl_clear_name  ; ~2-3 cycles per iteration
; Total: ~300-450 cycles
```

**Optimized**:
```assembly
; Use STOSD (4 bytes at a time)
mov edi, OFFSET BOOK_NAME_BUF
mov ecx, BOOK_NAME_SIZE / 4
xor eax, eax
rep stosd
; Remaining bytes
mov ecx, BOOK_NAME_SIZE % 4
rep stosb
; Total: ~40 cycles
```

**Speedup**: ~10x faster

---

## Related Files
- `data.inc`: Buffer definitions, constants
- `books.inc`: Uses `ReadAllBooks`, `DisplayBookLine`
- `search.inc`: Uses `ReadAllBooks`, `DisplayBookLine`
- `sorting.inc`: Uses `ReadAllBooks`, `DisplayBookLine`
- `issued.inc`: Uses similar file reading patterns
- Irvine32: `WRITESTRING`, `READSTRING`, `WriteString`
- Windows API: `SetFilePointer`, `ReadFile`, `CloseHandle`

---

## Usage Recommendations

### When to Use MSG_DISPLAY
✓ User-facing messages
✓ Infrequent calls
✓ Consistency across codebase

✗ Tight loops
✗ Performance-critical paths

### When to Use ReadAllBooks
✓ Loading BOOKS.txt
✓ File fits in BUFFER_SIZE
✓ Need entire file in memory

✗ Large files (>4999 bytes)
✗ Partial reads needed
✗ Streaming processing required

### When to Use DisplayBookLine
✓ Formatted book display
✓ Consistent presentation
✓ User-friendly output

✗ Compact display needed
✗ Custom formatting required
✗ Performance-critical loops

---

## Future Enhancements

1. **Error Handling**: Return status codes from procedures
2. **Dynamic Buffers**: Allocate based on file size
3. **Chunked Reading**: Support large files
4. **Custom Formatting**: Parameterize DisplayBookLine
5. **Performance**: Use REP STOSB for buffer clearing
6. **Logging**: Add debug/trace output
7. **Validation**: Check buffer sizes before operations
