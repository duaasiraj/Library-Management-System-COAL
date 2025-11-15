# books.inc - Book Management Module

## Overview
The `books.inc` file implements all book-related operations including adding new books and viewing the book catalog. This module handles book data validation, file I/O, and formatted display of book information.

---

## Procedures

### 1. ADD_B - Add Book Procedure

#### Purpose
Adds a new book to the library catalog with full validation and persistence to BOOKS.txt.

#### Flow
1. **ISBN Input & Validation**
   - Prompts user for 13-digit ISBN
   - Validates length using `Str_length`
   - Rejects invalid ISBNs

2. **Book Details Collection**
   - Book Name (up to 150 characters)
   - Author Name (up to 150 characters)
   - Publisher Name (up to 150 characters)
   - Genre (up to 100 characters)
   - Publishing Year (4 digits)

3. **Data Persistence**
   - Opens BOOKS.txt with `CreateFile` API
   - Moves file pointer to end (`FILE_END`)
   - Writes CSV-formatted line:
     ```
     Name,Author,Publisher,Genre,Year,ISBN\r\n
     ```
   - Uses `WriteToFile` helper for each field
   - Closes file handle

4. **User Feedback**
   - Success: Displays `BOOK_ADDED_MSG`
   - Failure: Displays `INVALID_ISBN_MSG`

#### Jump Targets
- `SHOW_FULL_MENU`: Returns to librarian menu after completion
- `invalid_isbn`: Error handling for invalid ISBN

#### Notes
- Duplicate checking is commented out (simplified implementation)
- No ISBN format validation beyond length check
- Fields can contain commas (potential CSV parsing issue)
- Increments `NUM_BOOKS` counter (legacy feature)

---

### 2. VIEW_B - View Books (Legacy Array Version)

#### Purpose
Displays books from in-memory array (legacy functionality, not actively used).

#### Implementation
```assembly
MOV ECX, NUM_BOOKS
cmp ECX, 0
JE SHOW_FULL_MENU
```

#### Loop Logic
- Iterates through `BOOKS` array
- Uses `BOOK_SIZE` (30) to calculate offset
- Displays each book with `WRITESTRING`
- Adds line break with `CRLF`

#### Limitations
- Only shows books added in current session
- Array limited to 6 books
- Does not read from BOOKS.txt file

---

### 3. VIEW_BFILE - View Books from File

#### Purpose
Reads and displays all books from BOOKS.txt with formatted output showing labeled fields.

#### Process Overview

#### Phase 1: File Reading
```assembly
INVOKE CreateFile, ADDR BOOKS_FILE, GENERIC_READ, ...
CALL ReadAllBooks  ; Helper from logic.inc
```
- Opens file in read-only mode
- Uses `ReadAllBooks` to load entire file
- Null-terminates buffer at `bytesRead`

#### Phase 2: Line-by-Line Parsing
```assembly
xor ebx, ebx  ; offset into BUFFER_BOOK
vb_loop:
    lea esi, [OFFSET BUFFER_BOOK + ebx]
    ; Find end of line (CR/LF or null)
    vb_find_eol:
        cmp al, 0Dh   ; Carriage Return
        je vb_proc_line
        cmp al, 0Ah   ; Line Feed
        je vb_proc_line
```

#### Phase 3: CSV Field Extraction
Each line is parsed into 6 fields separated by commas:

**Field 1: Book Name**
```assembly
vb_copy_name:
    mov al, [esi]
    cmp al, ','
    je vb_name_done
    mov [edi], al
    inc edi
    inc esi
```
- Copies characters until comma or end-of-line
- Stores in `BOOK_NAME_BUF`
- Null-terminates the field

**Fields 2-6**: Author, Publisher, Genre, Year, ISBN
- Same pattern: copy until comma, skip comma, continue
- Each stored in respective buffer

#### Phase 4: Formatted Display
```assembly
INVOKE MSG_DISPLAY, ADDR NAME_LABEL
mov edx, OFFSET BOOK_NAME_BUF
call WriteString
call CRLF
```
- Displays label (e.g., "Name: ")
- Displays field value
- Adds newline
- Repeats for all 6 fields

#### Line Advancement Logic
```assembly
vb_loop_continue:
    ; Skip CR if present
    cmp byte ptr [OFFSET BUFFER_BOOK + ebx], 0Dh
    jne vb_skip_lf
    inc ebx
    ; Skip LF if present
    cmp byte ptr [OFFSET BUFFER_BOOK + ebx], 0Ah
    jne vb_loop_continue
    inc ebx
```
- Handles both Windows (CRLF) and Unix (LF) line endings
- Prevents double-counting line terminators

#### Edge Cases Handled
1. **Empty Lines**: Skipped via `vb_advance_only`
2. **Missing Fields**: Gracefully handles incomplete CSV
3. **Long Lines**: Truncated at `BUFFER_SIZE`
4. **No Books**: Returns to menu immediately

---

## CSV Format Specification

### Expected Format
```
BookName,Author,Publisher,Genre,Year,ISBN
```

### Example Entry
```
1984,George Orwell,Secker & Warburg,Dystopian,1949,9780451524935
```

### Parsing Rules
1. **Delimiter**: Single comma (,)
2. **Line Ending**: CRLF (Windows) or LF (Unix)
3. **Field Count**: Exactly 6 fields
4. **Encoding**: ASCII
5. **No Quoting**: Fields cannot contain commas

---

## Register Usage

### ADD_B Procedure
- **EAX**: String length, file handle
- **ECX**: Buffer size for input
- **EDX**: Pointer to input buffers
- **ESI**: Source pointer for data
- **EDI**: Destination pointer (not heavily used)

### VIEW_BFILE Procedure
- **EBX**: Current offset into `BUFFER_BOOK`
- **ECX**: Line length, loop counters
- **ESI**: Source pointer for copying
- **EDI**: Destination pointer for field buffers
- **EDX**: Display string pointer

---

## Helper Dependencies

### From Irvine32 Library
- `READSTRING`: Read user input
- `WRITESTRING`: Display string
- `CRLF`: Print newline
- `Str_length`: Get string length

### From helper.inc
- `ReadAllBooks`: Reads entire file into buffer
- `MSG_DISPLAY`: Display message wrapper
- `WriteToFile`: Write data to file

### Windows API
- `CreateFile`: Open/create file
- `SetFilePointer`: Move file cursor
- `CloseHandle`: Close file handle

---

## Error Handling

### ADD_B Errors
1. **Invalid ISBN Length**
   - Check: `Str_length` != 13
   - Action: Display error, return to menu
   - Label: `invalid_isbn`

2. **File Creation Failure**
   - Not explicitly checked
   - Potential crash if file creation fails

### VIEW_BFILE Errors
1. **File Not Found**
   - Handle: `INVALID_HANDLE_VALUE`
   - Action: Jump to `SHOW_FULL_MENU`

2. **Empty File**
   - Check: `bytesRead == 0`
   - Action: Return to menu

3. **Buffer Overflow**
   - Prevention: `BUFFER_SIZE` limit
   - Truncates large files silently

---

## Display Output Example

```
    Viewing Books in Library:

Name: The Great Gatsby
Author: F. Scott Fitzgerald
Publisher: Scribner
Genre: Classic Fiction
Year: 1925
ISBN: 9780743273565

Name: To Kill a Mockingbird
Author: Harper Lee
Publisher: J.B. Lippincott & Co.
Genre: Southern Gothic
Year: 1960
ISBN: 9780060935467
```

---

## Performance Considerations

1. **File I/O**: Entire file loaded into memory (5000-byte limit)
2. **Parsing**: Character-by-character scanning (no optimization)
3. **Display**: Individual `WriteString` calls per field (slow)
4. **Scalability**: Limited to ~100-200 books due to buffer size

---

## Security Issues

1. **No ISBN Duplication Check**: Allows duplicate books
2. **No Input Sanitization**: Commas in fields break CSV format
3. **Buffer Overflow Risk**: No bounds checking on user input
4. **File Locking**: `DO_NOT_SHARE` mode prevents concurrent access

---

## Suggested Improvements

1. **ISBN Validation**: Check digit verification (ISBN-13 algorithm)
2. **Duplicate Detection**: Search existing books before adding
3. **CSV Escaping**: Handle commas in fields with quotes
4. **Pagination**: Display books in pages for large catalogs
5. **Error Recovery**: Graceful handling of corrupted CSV

---

## Related Files
- `data.inc`: Buffer and constant definitions
- `helper.inc`: `ReadAllBooks`, `DisplayBookLine`
- `search.inc`: Book search by various fields
- `sorting.inc`: Display sorted book lists
