# sorting.inc - Book Sorting and Display Module

## Overview
The `sorting.inc` file implements a complete sorting system for library books, allowing users to sort by various fields in ascending or descending order. It uses bubble sort with in-memory pointer arrays for efficient display without modifying the source file.

---

## Main Entry Point

### VIEW_SORTED_FUNC - Sort Menu Handler

#### Purpose
Displays sort menu and routes to appropriate sort configuration.

#### Menu Structure
```assembly
VIEW_SORTED_FUNC:
    INVOKE MSG_DISPLAY, ADDR SORT_MENU_MSG
    CALL READINT
    
    CMP EAX, 1
    JE SORT_NAME_ASC
    CMP EAX, 2
    JE SORT_NAME_DESC
    ; ... 10 options total ...
    CMP EAX, 11
    JE SHOW_MEMBER_MENU
```

#### Sort Options Matrix
| Option | Field | Order | Field Index | Order Flag |
|--------|-------|-------|-------------|-----------|
| 1 | Name | Ascending | 0 | 0 |
| 2 | Name | Descending | 0 | 1 |
| 3 | Author | Ascending | 1 | 0 |
| 4 | Author | Descending | 1 | 1 |
| 5 | Publisher | Ascending | 2 | 0 |
| 6 | Publisher | Descending | 2 | 1 |
| 7 | Year | Ascending | 4 | 0 |
| 8 | Year | Descending | 4 | 1 |
| 9 | ISBN | Ascending | 5 | 0 |
| 10 | ISBN | Descending | 5 | 1 |
| 11 | Back | - | - | - |

**Note**: Genre (field 3) not included in sort options.

#### Sort Option Handlers
```assembly
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
```

**Pattern**: Each handler sets EAX (field index) and EBX (order) before calling main sorting procedure.

---

## Core Procedures

### 1. SortAndDisplayBooks - Main Sorting Coordinator

#### Purpose
Orchestrates the complete sorting process from file read to display.

#### Process Flow
```assembly
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
```

**Phase 1: File Loading**
```assembly
INVOKE CreateFile, ADDR BOOKS_FILE, GENERIC_READ, ...
cmp eax, INVALID_HANDLE_VALUE
je sort_no_books

mov filehandle, eax
call ReadAllBooks  ; Load entire file into BUFFER_BOOK
```

**Phase 2: Parsing**
```assembly
call ParseLinesIntoArray
; Populates LINE_POINTERS and LINE_LENGTHS arrays
; Sets NUM_LINES to book count
```

**Phase 3: Validation**
```assembly
mov eax, NUM_LINES
cmp eax, 0
je sort_no_books
```

**Phase 4: Sorting**
```assembly
pop ebx  ; order
pop eax  ; field index

push eax
push ebx
call SortLines  ; Performs bubble sort
pop ebx
pop eax
```

**Phase 5: Display**
```assembly
call DisplaySortedBooks
```

**Phase 6: Cleanup**
```assembly
pop edi
pop esi
pop edx
pop ecx
pop ebx
pop eax
ret
```

---

### 2. ParseLinesIntoArray - Line Pointer Builder

#### Purpose
Converts BUFFER_BOOK into an array of pointers for efficient sorting.

#### Data Structures Built
```assembly
LINE_POINTERS DD 100 DUP(?)  ; Array of pointers to line starts
LINE_LENGTHS  DD 100 DUP(?)  ; Array of line lengths
NUM_LINES     DWORD 0        ; Count of lines parsed
```

#### Process Flow
```assembly
ParseLinesIntoArray PROC
    pushad
    
    xor ebx, ebx  ; offset in BUFFER_BOOK
    xor ecx, ecx  ; line counter
```

**Phase 1: Line Detection**
```assembly
parse_lines_loop:
    ; Check end conditions
    mov eax, DWORD PTR bytesRead
    cmp ebx, eax
    jge parse_lines_done
    
    ; Check max capacity
    cmp ecx, MAX_BOOKS
    jge parse_lines_done
```

**Phase 2: Store Line Pointer**
```assembly
; Store pointer to start of line
lea esi, [OFFSET BUFFER_BOOK + ebx]
mov edi, OFFSET LINE_POINTERS
mov eax, ecx
shl eax, 2  ; multiply by 4 (size of DWORD pointer)
add edi, eax
mov [edi], esi  ; LINE_POINTERS[ecx] = pointer to line
```

**Memory Layout Example**:
```
BUFFER_BOOK:
0x1000: "1984,Orwell,..."      ← LINE_POINTERS[0]
0x1050: "Gatsby,Fitzgerald,..."← LINE_POINTERS[1]
0x10A0: "Mockingbird,Lee,..."  ← LINE_POINTERS[2]

LINE_POINTERS:
[0]: 0x1000
[1]: 0x1050
[2]: 0x10A0

LINE_LENGTHS:
[0]: 80
[1]: 80
[2]: 80
```

**Phase 3: Find Line Length**
```assembly
xor edx, edx  ; line length counter

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
    mov [edi], edx  ; LINE_LENGTHS[ecx] = length
```

**Phase 4: Advance to Next Line**
```assembly
; Move offset by line length
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
    inc ecx  ; Increment line counter
    jmp parse_lines_loop
```

**Phase 5: Finalize**
```assembly
parse_lines_done:
    mov NUM_LINES, ecx
    popad
    ret
```

---

### 3. SortLines - Bubble Sort Implementation

#### Purpose
Sorts the LINE_POINTERS array based on specified field using bubble sort algorithm.

#### Parameters
- **EAX**: Field index (0=name, 1=author, 2=publisher, 4=year, 5=ISBN)
- **EBX**: Order (0=ascending, 1=descending)

#### Local Variables (Stack)
```assembly
; Allocate locals
sub esp, 16
; [esp+0]  = swappedFlag (DWORD)
; [esp+4]  = passCount  (DWORD)
; [esp+8]  = fieldIndex (DWORD)
; [esp+12] = order      (DWORD)

mov [esp+8], eax   ; save field index
mov [esp+12], ebx  ; save order
```

#### Algorithm: Bubble Sort

**Outer Loop** (Passes):
```assembly
mov ecx, NUM_LINES
cmp ecx, 2
jl sort_lines_done  ; Need at least 2 to sort

dec ecx
mov [esp+4], ecx    ; passCount = n - 1

sort_outer_loop:
    mov DWORD PTR [esp], 0  ; swappedFlag = 0
```

**Inner Loop** (Comparisons):
```assembly
mov edx, 0  ; current index

sort_inner_loop:
    mov eax, edx
    inc eax     ; next index
    cmp eax, NUM_LINES
    jge sort_check_swapped
```

**Get Pointers**:
```assembly
; Get current line pointer
mov esi, OFFSET LINE_POINTERS
mov edi, edx
shl edi, 2
add esi, edi
mov esi, [esi]  ; ESI = LINE_POINTERS[edx]

; Get next line pointer
mov edi, OFFSET LINE_POINTERS
mov ebx, eax
shl ebx, 2
add edi, ebx
mov edi, [edi]  ; EDI = LINE_POINTERS[edx+1]
```

**Compare Fields**:
```assembly
; Load comparison parameters
mov eax, [esp+8]   ; field index
mov ebx, [esp+12]  ; order
call CompareFields ; EAX = cmp result (-1,0,1)
```

**Swap Decision**:
```assembly
mov ebx, [esp+12]  ; order
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
```

**Swap Pointers**:
```assembly
sort_do_swap:
    ; Swap LINE_POINTERS[edx] and LINE_POINTERS[edx+1]
    mov esi, OFFSET LINE_POINTERS
    mov edi, edx
    shl edi, 2
    add esi, edi
    mov edi, [esi]  ; temp = LINE_POINTERS[edx]
    
    mov ebx, OFFSET LINE_POINTERS
    mov eax, edx
    inc eax
    shl eax, 2
    add ebx, eax
    mov eax, [ebx]
    mov [esi], eax  ; LINE_POINTERS[edx] = LINE_POINTERS[edx+1]
    mov [ebx], edi  ; LINE_POINTERS[edx+1] = temp
    
    ; Set swapped flag
    mov DWORD PTR [esp], 1
```

**Optimization: Early Exit**:
```assembly
sort_check_swapped:
    ; If no swaps made, array is sorted
    cmp DWORD PTR [esp], 0
    je sort_lines_done
    
    dec DWORD PTR [esp+4]  ; passCount--
    cmp DWORD PTR [esp+4], 0
    jg sort_outer_loop
```

**Cleanup**:
```assembly
sort_lines_done:
    add esp, 16  ; Free locals
    ; Restore registers
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
```

#### Time Complexity
- **Best Case**: O(n) - already sorted, early exit after 1 pass
- **Average Case**: O(n²)
- **Worst Case**: O(n²) - reverse sorted
- **Space**: O(1) - in-place sorting of pointer array

---

### 4. CompareFields - Field-based String Comparison

#### Purpose
Extracts and compares a specific CSV field from two book lines.

#### Parameters
- **ESI**: Pointer to line 1
- **EDI**: Pointer to line 2
- **EAX**: Field index (0-5)

#### Returns
- **EAX**: 
  - `-1` if line1 < line2
  - `0` if line1 == line2
  - `1` if line1 > line2

#### Process Flow

**Phase 1: Extract Field from Line 1**
```assembly
push eax  ; Save field index
call ExtractField  ; Extracts to TEMP_FIELD
```

**Phase 2: Copy to Temporary Storage**
```assembly
; Copy TEMP_FIELD to SORT_TEMP_LINE
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
```

**Phase 3: Convert to Uppercase**
```assembly
INVOKE Str_ucase, ADDR SORT_TEMP_LINE
; Makes comparison case-insensitive
```

**Phase 4: Extract Field from Line 2**
```assembly
mov esi, edi  ; Line 2 pointer
pop eax       ; Field index
push eax
call ExtractField  ; Extracts to TEMP_FIELD
```

**Phase 5: Convert to Uppercase**
```assembly
INVOKE Str_ucase, ADDR TEMP_FIELD
```

**Phase 6: Lexicographic Comparison**
```assembly
mov esi, OFFSET SORT_TEMP_LINE
mov edi, OFFSET TEMP_FIELD
xor eax, eax

cmp_strcmp_loop:
    mov al, [esi]
    mov bl, [edi]
    cmp al, bl
    jb cmp_less_than    ; Use unsigned comparison
    ja cmp_greater_than
    cmp al, 0           ; Both null? Equal
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
```

**Why Unsigned Comparison (JB/JA)**:
- Handles ASCII values correctly
- 'a' (97) > 'Z' (90) in ASCII
- After `Str_ucase`, all lowercase → uppercase
- Ensures alphabetical ordering

**Example Comparisons**:
```
"1984" vs "BRAVE NEW WORLD"
'1' (49) < 'B' (66)
Result: -1

"ORWELL" vs "FITZGERALD"
'O' (79) > 'F' (70)
Result: 1

"ORWELL" vs "ORWELL"
Equal at null terminator
Result: 0
```

---

### 5. ExtractField - CSV Field Extractor

#### Purpose
Extracts a specific field from a CSV line by field index.

#### Parameters
- **ESI**: Pointer to CSV line
- **EAX**: Field index (0-based)

#### Output
- **TEMP_FIELD**: Contains extracted field (null-terminated)

#### Process Flow

**Phase 1: Clear Buffer**
```assembly
push eax
mov edi, OFFSET TEMP_FIELD
mov ecx, 200
xor al, al

extract_clear:
    mov [edi], al
    inc edi
    loop extract_clear
pop eax
```

**Phase 2: Skip to Target Field**
```assembly
mov ecx, eax  ; ecx = fields to skip
mov edx, 0    ; comma counter

extract_skip_fields:
    cmp ecx, 0
    je extract_copy_field  ; Reached target field
    
    mov al, [esi]
    cmp al, 0
    je extract_field_done  ; End of line
    cmp al, 0Dh
    je extract_field_done
    cmp al, 0Ah
    je extract_field_done
    cmp al, ','
    jne extract_next_char
    dec ecx  ; Found comma, decrement field counter
    
extract_next_char:
    inc esi
    jmp extract_skip_fields
```

**Field Skip Examples**:
```
Line: "1984,Orwell,Secker,Dystopian,1949,9780451524935"

Field 0 (Name):
- Skip 0 commas
- Start at '1'

Field 1 (Author):
- Skip 1 comma
- Start at 'O'

Field 5 (ISBN):
- Skip 5 commas
- Start at '9'
```

**Phase 3: Copy Field to TEMP_FIELD**
```assembly
extract_copy_field:
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
    je extract_field_done  ; Stop at next comma
    mov [edi], al
    inc esi
    inc edi
    jmp extract_copy_loop

extract_field_done:
    mov byte ptr [edi], 0  ; Null-terminate
```

**Example Extraction**:
```
Input:  "1984,Orwell,Secker,Dystopian,1949,9780451524935"
Index:  1 (Author)
Output: "Orwell" (in TEMP_FIELD)
```

---

### 6. DisplaySortedBooks - Formatted Display

#### Purpose
Displays all sorted books using the sorted LINE_POINTERS array.

#### Process Flow

**Phase 1: Header**
```assembly
DisplaySortedBooks PROC
    pushad
    
    INVOKE MSG_DISPLAY, ADDR VIEW_BOOKS_MSG
```

**Phase 2: Loop Through Sorted Pointers**
```assembly
xor ecx, ecx

display_sorted_loop:
    cmp ecx, NUM_LINES
    jge display_sorted_done
    
    ; Get pointer to line
    mov esi, OFFSET LINE_POINTERS
    mov eax, ecx
    shl eax, 2
    add esi, eax
    mov esi, [esi]  ; ESI = LINE_POINTERS[ecx]
```

**Phase 3: Copy Line to TEMP_LINE**
```assembly
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
```

**Phase 4: Display Using Helper**
```assembly
push ecx
mov edx, OFFSET TEMP_LINE
call DisplayBookLine  ; Helper from logic.inc
pop ecx

inc ecx
jmp display_sorted_loop
```

**Output Format** (via DisplayBookLine):
```
Name: 1984
Author: George Orwell
Publisher: Secker & Warburg
Genre: Dystopian
Year: 1949
ISBN: 9780451524935

Name: Brave New World
Author: Aldous Huxley
...
```

---

## Sorting Examples

### Example 1: Sort by Name (Ascending)
**Input** (BOOKS.txt):
```
Brave New World,Huxley,Harper,Science Fiction,1932,9780060850524
1984,Orwell,Secker,Dystopian,1949,9780451524935
Animal Farm,Orwell,Secker,Satire,1945,9780451526342
```

**After ParseLinesIntoArray**:
```
LINE_POINTERS[0] → "Brave New World,..."
LINE_POINTERS[1] → "1984,..."
LINE_POINTERS[2] → "Animal Farm,..."
```

**Comparison Process**:
1. Compare "BRAVE NEW WORLD" vs "1984"
   - 'B' > '1' → Swap
2. Compare "1984" vs "ANIMAL FARM"
   - '1' < 'A' → No swap
3. Compare "BRAVE NEW WORLD" vs "ANIMAL FARM"
   - 'B' > 'A' → Swap

**After SortLines**:
```
LINE_POINTERS[0] → "1984,..."
LINE_POINTERS[1] → "Animal Farm,..."
LINE_POINTERS[2] → "Brave New World,..."
```

**Display**: Books shown in alphabetical order by name.

---

### Example 2: Sort by Year (Descending)
**Input**:
```
1984,Orwell,Secker,Dystopian,1949,9780451524935
Brave New World,Huxley,Harper,SciFi,1932,9780060850524
Animal Farm,Orwell,Secker,Satire,1945,9780451526342
```

**Extracted Years** (Field 4):
- Line 0: "1949"
- Line 1: "1932"
- Line 2: "1945"

**String Comparison** (Descending):
- "1949" > "1945" > "1932"

**Result**:
```
LINE_POINTERS[0] → "1984,..." (1949)
LINE_POINTERS[1] → "Animal Farm,..." (1945)
LINE_POINTERS[2] → "Brave New World,..." (1932)
```

---

## Performance Analysis

### Time Complexity
| Operation | Complexity | Count |
|-----------|-----------|-------|
| ParseLinesIntoArray | O(n × m) | Once |
| SortLines | O(n² × k) | Once |
| DisplaySortedBooks | O(n × m) | Once |
| **Total** | **O(n² × k)** | - |

Where:
- n = number of books
- m = average line length
- k = average field length

### Space Complexity
| Structure | Size | Purpose |
|-----------|------|---------|
| BUFFER_BOOK | 5000 bytes | File content |
| LINE_POINTERS | 400 bytes | Pointers (100×4) |
| LINE_LENGTHS | 400 bytes | Lengths (100×4) |
| TEMP_FIELD | 200 bytes | Field extraction |
| SORT_TEMP_LINE | 512 bytes | Comparison temp |
| **Total** | **~6.5 KB** | - |

### Optimization Opportunities
1. **QuickSort**: O(n log n) average case
2. **Insertion Sort**: Better for small datasets
3. **Index Caching**: Build reverse lookup
4. **Hybrid Sort**: Insertion sort for small partitions

---

## Comparison with Other Approaches

### Current: Pointer Array Sort
✓ **Advantages**:
- File unchanged
- Fast redisplay
- Low memory (only pointers)

✗ **Disadvantages**:
- Bubble sort inefficient
- Re-parse each session
- Limited capacity (100 books)

### Alternative: File Sort
```assembly
; Sort and rewrite file
1. Load all books
2. Sort in memory
3. Overwrite file
```

✓ **Advantages**:
- Persistent sorting
- No re-sort needed

✗ **Disadvantages**:
- Data loss risk
- Slower writes
- File corruption potential

---

## Related Files
- `data.inc`: Sort menu, buffers, constants
- `helper.inc`: `ReadAllBooks`, `DisplayBookLine`
- `search.inc`: Similar CSV parsing logic
- Irvine32: `Str_ucase`, `Str_length`
