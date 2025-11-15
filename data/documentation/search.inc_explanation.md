# search.inc - Book Search Module

## Overview
The `search.inc` file implements comprehensive book search functionality, allowing users to search the library catalog by Name, Author, Publisher, or Year. It uses CSV parsing and string comparison to locate matching books.

---

## Main Entry Point

### SEARCH_BOOK_FUNC - Search Menu Handler

#### Purpose
Displays search menu and routes to appropriate search function.

#### Menu Flow
```assembly
SEARCH_BOOK_FUNC:
    INVOKE MSG_DISPLAY, ADDR SEARCH_MENU_MSG
    CALL READINT
    
    CMP EAX, SEARCH_BY_NAME
    JE SEARCH_BY_NAME_FUNC
    CMP EAX, SEARCH_BY_AUTHOR
    JE SEARCH_BY_AUTHOR_FUNC
    CMP EAX, SEARCH_BY_PUBLISHER
    JE SEARCH_BY_PUBLISHER_FUNC
    CMP EAX, SEARCH_BY_YEAR
    JE SEARCH_BY_YEAR_FUNC
    CMP EAX, SEARCH_BACK
    JE SHOW_MEMBER_MENU
    JMP SEARCH_BOOK_FUNC  ; Invalid option -> retry
```

#### Options
1. By Name (field 1)
2. By Author (field 2)
3. By Publisher (field 3)
4. By Year (field 5)
5. Back to Member Menu

---

## Search Functions

### 1. SEARCH_BY_NAME_FUNC - Search by Book Name

#### Purpose
Searches for books matching a given name (first CSV field).

#### Process Flow

**Phase 1: Input Collection**
```assembly
INVOKE MSG_DISPLAY, ADDR BOOK_NAME_PROMPT
mov edx, OFFSET BOOK_NAME_BUF
mov ecx, BOOK_NAME_SIZE
CALL READSTRING
```

**Phase 2: File Loading**
```assembly
INVOKE CreateFile, ADDR BOOKS_FILE, GENERIC_READ, ...
CALL ReadAllBooks  ; Loads entire BOOKS.txt into BUFFER_BOOK
```

**Phase 3: Buffer Parsing**
```assembly
xor ebx, ebx  ; offset in BUFFER_BOOK

search_name_loop:
    mov eax, DWORD PTR bytesRead
    cmp ebx, eax
    jge search_name_done  ; Reached end
    
    lea edi, [OFFSET BUFFER_BOOK + ebx]
```

**Phase 4: Line Processing**

1. **Find Line Length**:
   ```assembly
   find_eol_name:
       mov al, [edi + ecx]
       cmp al, 0
       je process_name_line
       cmp al, 0Dh
       je process_name_line
       cmp al, 0Ah
       je process_name_line
       inc ecx
   ```

2. **Extract First Field** (Name):
   ```assembly
   find_comma_name:
       cmp byte ptr [edi + edx], ','
       je got_comma_name
       inc edx
   ```
   - Scans until first comma
   - `edx` = field length

3. **Copy to TEMP_FIELD**:
   ```assembly
   copy_field_name:
       mov al, [esi]
       mov [edi], al
       inc esi
       inc edi
       dec ecx
   ```

4. **String Comparison**:
   ```assembly
   INVOKE Str_compare, ADDR BOOK_NAME_BUF, ADDR TEMP_FIELD
   jne continue_name  ; Not a match
   ```

**Phase 5: Display Match**
```assembly
; Copy full line to TEMP_LINE
copy_line_to_temp:
    mov al, [esi]
    mov [edi], al
    inc esi
    inc edi
    dec ecx

mov edx, OFFSET TEMP_LINE
call DisplayBookLine  ; Helper from logic.inc
```

**Phase 6: Line Advancement**
```assembly
add ebx, ecx  ; Move offset by line length

; Skip CR/LF
skip_lf_name:
    cmp byte ptr [OFFSET BUFFER_BOOK + ebx], 0Dh
    jne cont_loop_name
    inc ebx
    cmp byte ptr [OFFSET BUFFER_BOOK + ebx], 0Ah
    jne cont_loop_name
    inc ebx
```

#### Search Characteristics
- **Case Sensitivity**: Exact match required
- **Partial Matching**: Not supported
- **Multiple Results**: Displays all matches
- **Display Format**: Labeled fields via `DisplayBookLine`

---

### 2. SEARCH_BY_AUTHOR_FUNC - Search by Author Name

#### Purpose
Searches for books by a specific author (second CSV field).

#### Key Differences from Name Search

**Field Extraction**:
```assembly
find_first_comma_author:
    mov al, [edi + edx]
    cmp al, ','
    je got_first_comma_author
    inc edx

got_first_comma_author:
    inc edx  ; Move past first comma to author field
```

**Field Boundary Detection**:
```assembly
find_end_author2:
    mov al, [edi + ebp]
    cmp al, ','
    je got_end_author2  ; Stop at next comma
    inc ebp
```
- Finds both start and end of author field
- `ebp - edx` = field length

**Copy Author to TEMP_FIELD**:
```assembly
lea esi, [edi + edx]  ; Source = line start + author offset
mov edi, OFFSET TEMP_FIELD
mov ecx, eax  ; length

copy_author_to_temp:
    mov al, [esi]
    mov [edi], al
    inc esi
    inc edi
    dec ecx
```

**Comparison and Display**:
```assembly
INVOKE Str_compare, ADDR BOOK_AUTHOR_BUF, ADDR TEMP_FIELD
jne restore_author_and_continue

; Match found - display full book details
```

#### Edge Cases
- **No Author Field**: Jumps to `no_author_field`
- **Empty Author**: Skips field
- **Multiple Commas**: Handled by field counting

---

### 3. SEARCH_BY_PUBLISHER_FUNC - Search by Publisher

#### Purpose
Searches for books by publisher name (third CSV field).

#### Field Navigation Logic
```assembly
; Skip first comma (end of name)
find_first_comma_pub:
    cmp al, ','
    je found_first_comma_pub
    inc edx

found_first_comma_pub:
    inc edx  ; Now at start of author field
    
; Skip second comma (end of author)
find_second_comma_pub:
    cmp al, ','
    je found_second_comma_pub
    inc edx

found_second_comma_pub:
    inc edx  ; Now at start of publisher field
```

**Publisher Field Extraction**:
```assembly
push edx  ; Save publisher field start

find_end_publisher2:
    mov al, [edi + ebp]
    cmp al, ','
    je got_end_publisher2  ; Stop at genre field
    inc ebp

got_end_publisher2:
    mov eax, ebp
    sub eax, edx  ; Calculate publisher length
```

**Stack Usage**:
- Saves publisher field start position
- Line length on stack from earlier
- Must balance 2 pushes before popping

---

### 4. SEARCH_BY_YEAR_FUNC - Search by Publishing Year

#### Purpose
Searches for books by publication year (fifth CSV field).

#### Multi-Comma Skip Logic
```assembly
xor ebp, ebp  ; comma counter

find_year_field:
    mov al, [edi + edx]
    cmp al, ','
    jne skip_comma_year
    inc ebp
    cmp ebp, 4  ; Skip 4 commas to reach year
    je year_field_start
skip_comma_year:
    inc edx
```

**Field Sequence**:
1. Name (field 1)
2. Author (field 2)
3. Publisher (field 3)
4. Genre (field 4)
5. **Year** (field 5) ← Target field
6. ISBN (field 6)

**Year Extraction**:
```assembly
year_field_start:
    inc edx  ; Skip 4th comma
    
find_end_year2:
    mov al, [edi + ebp]
    cmp al, ','
    je got_end_year2  ; Stop before ISBN
    inc ebp
```

**Year Format**:
- Expected: 4-digit year (e.g., "1984")
- Stored as string (not numeric)
- Exact match required

---

## Common Search Patterns

### Line-by-Line Iteration
All search functions follow this pattern:
```assembly
1. Calculate line start pointer
2. Find line length (scan for CR/LF/null)
3. Store line length on stack
4. Skip empty lines
5. Extract target field
6. Compare with search query
7. Display if match
8. Advance offset by line length + CRLF
9. Loop until end of buffer
```

### Stack Management Pattern
```assembly
push ecx  ; Line length
push edx  ; Field position/length
push edi  ; Line pointer

; ... processing ...

pop edi   ; Restore in reverse order
pop edx
pop ecx
```

### Error Recovery
All functions handle:
- Missing fields (jump to advance label)
- Empty fields (skip comparison)
- Malformed lines (continue to next)
- No matches (silent, returns to menu)

---

## Helper Procedure

### DisplayBookLine (from helper.inc)

#### Purpose
Parses CSV line and displays formatted book details with labels.

#### Usage
```assembly
mov edx, OFFSET TEMP_LINE  ; Pointer to CSV line
call DisplayBookLine
```

#### Output Format
```
Name: [book name]
Author: [author name]
Publisher: [publisher]
Genre: [genre]
Year: [year]
ISBN: [ISBN]
```

---

## Register Usage Patterns

### Common Registers Across Functions
- **EBX**: Current offset into `BUFFER_BOOK`
- **ECX**: Line length, loop counters
- **EDX**: Field position, comma index
- **ESI**: Source pointer for copying
- **EDI**: Destination pointer, line start
- **EBP**: Secondary index (author/publisher/year end position)

### Special Usage
- **ESP**: Critical for stack-based line length tracking
- **EAX**: Bytesread comparison, field length calculation

---

## Performance Analysis

### Time Complexity
- **Per Search**: O(n × m)
  - n = number of books
  - m = average line length
- **No Indexing**: Linear scan required
- **Multiple Matches**: All processed (no early exit)

### Space Complexity
- **Buffer**: 5000 bytes (`BUFFER_BOOK`)
- **Temp Storage**: 512 bytes (`TEMP_LINE`)
- **Field Buffer**: 200 bytes (`TEMP_FIELD`)
- **Total**: ~5.7 KB

### Optimization Opportunities
1. **Binary Search**: Requires sorted file
2. **Indexing**: Build in-memory index on startup
3. **Caching**: Store parsed books in memory
4. **Parallel Search**: Search multiple fields simultaneously

---

## Comparison with Sorting Module

| Feature | search.inc | sorting.inc |
|---------|-----------|-------------|
| File Loading | `ReadAllBooks` | `ReadAllBooks` |
| Parsing | On-the-fly | `ParseLinesIntoArray` |
| Storage | Temporary (`TEMP_FIELD`) | `LINE_POINTERS` array |
| Memory | Low (streaming) | High (all pointers) |
| Speed | Slower | Faster (after parsing) |

---

## Error Messages

### File Errors
- `search_books_notfound`: No books in file
- `search_books_notfound_author`: Author search file error
- `search_books_notfound_publisher`: Publisher search file error
- `search_books_notfound_year`: Year search file error

### Display
```assembly
search_books_notfound:
    INVOKE MSG_DISPLAY, ADDR NO_BOOKS_MSG
    JMP SEARCH_BOOK_FUNC
```

---

## Limitations

### Functional Limitations
1. **Exact Match Only**: No fuzzy search
2. **Case Sensitive**: "Orwell" ≠ "orwell"
3. **No Wildcards**: Can't search "Orwell*"
4. **Single Field**: Can't search multiple criteria
5. **No Sorting**: Results in file order

### Technical Limitations
1. **Buffer Size**: Max 5000 bytes (~50-100 books)
2. **No Pagination**: All results displayed at once
3. **No Result Count**: Doesn't show "X books found"
4. **Memory Overhead**: Loads entire file each search

---

## Security Considerations

### Input Validation
- **No Length Check**: Could overflow buffers
- **No Sanitization**: Special characters unchecked
- **CSV Injection**: Commas in search term could cause issues

### File Access
- **Read-Only**: Good (uses `GENERIC_READ`)
- **Shared Access**: `DO_NOT_SHARE` prevents concurrent reads
- **Error Handling**: File errors handled gracefully

---

## Related Files
- `data.inc`: Search buffers and prompts
- `helper.inc`: `ReadAllBooks`, `DisplayBookLine`
- `sorting.inc`: Alternative display with sorting
- `books.inc`: Book data structure
