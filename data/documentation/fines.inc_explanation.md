# fines.inc - Overdue Books and Fine Calculation Module

## Overview
The `fines.inc` file implements the library's penalty system, tracking overdue books and calculating late fees based on return dates. It uses date comparison and arithmetic to determine fines at Rs. 10 per day.

---

## Procedures

### 1. VIEW_OVERDUE_FUNC - Display Overdue Books

#### Purpose
Identifies and displays all books with return dates past the current date.

#### Process Flow

**Phase 1: Current Date Retrieval**
```assembly
; Allocate SYSTEMTIME structure (16 bytes)
sub esp, 16
mov esi, esp
INVOKE GetLocalTime, esi

; Extract components
movzx eax, WORD PTR [esi+2]  ; wMonth
movzx ebx, WORD PTR [esi+6]  ; wDay
movzx ecx, WORD PTR [esi]    ; wYear
add esp, 16
```

**Phase 2: Date Conversion to YYYYMMDD**
```assembly
; Convert to comparable integer format
; Current date = year*10000 + month*100 + day

mov eax, ecx     ; year
mov edx, 10000
mul edx
mov ecx, eax     ; ecx = year * 10000

pop eax          ; restore month
mov edx, 100
mul edx
add ecx, eax     ; ecx += month * 100

pop eax          ; get day
add ecx, eax     ; ecx += day

push ecx         ; Save current date as YYYYMMDD
```

**Example Conversions**:
| Date | Year×10000 | Month×100 | Day | YYYYMMDD |
|------|-----------|-----------|-----|----------|
| 15/11/2025 | 20250000 | 1100 | 15 | 20251115 |
| 01/01/2024 | 20240000 | 100 | 1 | 20240101 |
| 31/12/2025 | 20250000 | 1200 | 31 | 20251231 |

**Phase 3: Load Issued Books**
```assembly
INVOKE CreateFile, ADDR ISSUED_BOOKS_FILE, GENERIC_READ, ...
INVOKE ReadFile, filehandle, ADDR buffer_mem, BUFFER_SIZE, ...
INVOKE CloseHandle, filehandle
```

**Phase 4: Line-by-Line Processing**
```assembly
xor ebx, ebx  ; offset in buffer
xor esi, esi  ; counter for overdue books

overdue_loop:
    lea edi, [OFFSET buffer_mem + ebx]
    
    overdue_find_eol:
        mov al, [edi + ecx]
        cmp al, 0Dh
        je overdue_process_line
```

**Phase 5: Return Date Extraction**

**Skip to 5th Field** (returndate):
```assembly
overdue_skip_to_return_date:
    mov al, [esi]
    cmp al, ','
    jne overdue_skip_char
    inc edx
    cmp edx, 4  ; Skip 4 commas: name, book, ISBN, issuedate
    je overdue_found_return_date
```

**Copy Return Date**:
```assembly
overdue_copy_date:
    mov al, [esi]
    cmp al, 0Dh
    je overdue_date_copied
    cmp al, 0Ah
    je overdue_date_copied
    mov [edi], al
    inc esi
    inc edi
```
→ Stored in `PARSED_RETURN_DATE_BUF` (format: DD/MM/YYYY)

**Phase 6: Date Parsing and Conversion**

**Parse DD/MM/YYYY String**:
```assembly
mov esi, OFFSET PARSED_RETURN_DATE_BUF

; Extract day (chars 0-1)
movzx eax, byte ptr [esi]
sub al, '0'        ; Convert ASCII to number
mov bl, 10
mul bl             ; Tens place × 10
movzx edx, byte ptr [esi+1]
sub dl, '0'        ; Ones place
add al, dl
push eax           ; Save day

; Extract month (chars 3-4, after '/')
movzx eax, byte ptr [esi+3]
sub al, '0'
mov bl, 10
mul bl
movzx edx, byte ptr [esi+4]
sub dl, '0'
add al, dl
push eax           ; Save month

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
; ecx now contains year
```

**Convert to YYYYMMDD**:
```assembly
mov eax, ecx    ; year
mov edx, 10000
mul edx
mov ecx, eax    ; ecx = year * 10000

pop eax         ; get month
mov edx, 100
mul edx
add ecx, eax    ; ecx += month * 100

pop eax         ; get day
add ecx, eax    ; ecx += day
```

**Phase 7: Date Comparison**
```assembly
; Compare return date with current date
mov eax, [esp+8]      ; Get current date from stack
cmp ecx, eax
jge overdue_line_done ; return date >= current date, not overdue
```

**Logic**:
- If `return_date >= current_date`: Book is not overdue
- If `return_date < current_date`: Book is overdue

**Example**:
- Current: 20251115 (Nov 15, 2025)
- Return: 20251110 (Nov 10, 2025)
- Result: 20251110 < 20251115 → **Overdue**

**Phase 8: Extract and Display Overdue Book Details**
```assembly
; Field 1: Username
overdue_extract_user:
    mov al, [esi]
    cmp al, ','
    je overdue_user_done
    mov [edi], al
    inc esi
    inc edi

; Field 2: Book name
overdue_extract_book:
    cmp al, ','
    je overdue_book_done

; Field 3: ISBN
overdue_extract_isbn:
    ...

; Field 4: Issue date
overdue_extract_issue:
    ...
```

**Display Format**:
```assembly
INVOKE MSG_DISPLAY, ADDR USERNAME_LABEL
INVOKE MSG_DISPLAY, ADDR OVERDUE_USERNAME_BUF
INVOKE MSG_DISPLAY, ADDR CRLF_BYTES

INVOKE MSG_DISPLAY, ADDR NAME_LABEL
INVOKE MSG_DISPLAY, ADDR OVERDUE_BOOKNAME_BUF
...
```

**Sample Output**:
```
========== OVERDUE BOOKS ==========
Username: alice
Name: 1984
ISBN: 9780451524935
Issue Date: 01/11/2025
Return Date: 11/11/2025
-----------------------------------
```

---

### 2. CALCULATE_FINES_FUNC - Calculate Late Fees

#### Purpose
Calculates fine amount for a specific book by ISBN based on days overdue.

#### Process Flow

**Phase 1: ISBN Input**
```assembly
INVOKE MSG_DISPLAY, ADDR ISBN_PROMPT
mov edx, OFFSET ISBN_SEARCH_BUF
mov ecx, 20
CALL READSTRING
```

**Phase 2: Header Display**
```assembly
INVOKE MSG_DISPLAY, ADDR FINES_HEADER
INVOKE MSG_DISPLAY, ADDR FINE_RATE_MSG
; "(Fine rate: Rs. 10 per day)"
```

**Phase 3: Get Current Date**
Same as VIEW_OVERDUE_FUNC:
1. Call `GetLocalTime`
2. Convert to YYYYMMDD
3. Also store individual components (day, month, year)

**Stack Layout**:
```assembly
push ecx  ; current date YYYYMMDD
push ecx  ; current year
push eax  ; current month
push ebx  ; current day
```

**Phase 4: Search for ISBN in Issued Books**
```assembly
fines_loop:
    lea edi, [OFFSET buffer_mem + ebx]
    
    ; Skip to ISBN field (3rd field)
    fines_skip_to_isbn:
        cmp edx, 2
        je fines_found_isbn_field
        
    ; Compare ISBN
    fines_compare_isbn:
        mov al, [esi]
        mov bl, [edi]
        cmp bl, 0
        je fines_check_isbn_end
        cmp al, bl
        jne fines_isbn_no_match
```

**Phase 5: Extract Return Date from Matching Line**
Same parsing logic as VIEW_OVERDUE_FUNC.

**Phase 6: Compare Dates**
```assembly
mov eax, [esp+8+12]  ; current date YYYYMMDD
cmp ecx, eax
jge fines_line_done  ; Not overdue
```

**Phase 7: Calculate Days Overdue**

**Simple Calculation** (Same Month):
```assembly
; Get return date components
movzx ebx, al  ; return day
movzx ecx, al  ; return month

; Get current date components
mov eax, [esp+8]    ; current day
mov edx, [esp+8+4]  ; current month

cmp edx, ecx
jne fines_diff_month

; Same month: days = current_day - return_day
sub eax, ebx
```

**Different Month Calculation**:
```assembly
fines_diff_month:
    ; Simplified: add 30 days for month difference
    mov eax, 30
    sub eax, ebx      ; days left in return month
    add eax, [esp+8]  ; add days in current month
```

**Limitations**:
- Assumes 30 days per month
- Doesn't handle multiple month gaps accurately
- Year boundaries not properly handled

**Better Algorithm**:
```
days_overdue = (current_date - return_date) in actual days
Requires: Julian date conversion or date library
```

**Phase 8: Calculate Fine**
```assembly
fines_calc_fine:
    cmp eax, 0
    jle fines_line_done  ; Skip if not actually overdue
    
    ; Calculate fine: days * rate
    mov edx, FINE_RATE   ; 10 (Rs. per day)
    mul edx              ; eax = days * 10
    
    push eax             ; Save fine amount
```

**Phase 9: Display Fine Details**
```assembly
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
pop eax  ; Get fine amount
call WriteDec  ; Display as decimal number
INVOKE MSG_DISPLAY, ADDR CRLF_BYTES
```

**Sample Output**:
```
========== CALCULATE FINES ==========
(Fine rate: Rs. 10 per day)
Username: alice
Name: 1984
Return Date: 11/11/2025
Fine Amount: Rs. 40
-----------------------------------
```

**Calculation Example**:
- Return Date: Nov 11, 2025
- Current Date: Nov 15, 2025
- Days Overdue: 15 - 11 = 4 days
- Fine: 4 × Rs. 10 = **Rs. 40**

---

## Date Conversion Algorithm

### ASCII to Integer Parsing
```assembly
; Convert '2' to 2
movzx eax, byte ptr [esi]
sub al, '0'

; Convert "25" to 25
; First digit: '2' - '0' = 2
; Multiply by 10: 2 × 10 = 20
; Second digit: '5' - '0' = 5
; Add: 20 + 5 = 25

mov al, '2'
sub al, '0'    ; al = 2
mov bl, 10
mul bl         ; al = 20
mov dl, '5'
sub dl, '0'    ; dl = 5
add al, dl     ; al = 25
```

### Year Parsing (4 digits)
```assembly
; "2025" → 2025
; '2' → 2 × 1000 = 2000
; '0' → 0 × 100  = 0
; '2' → 2 × 10   = 20
; '5' → 5 × 1    = 5
; Total: 2025
```

### YYYYMMDD Encoding
**Purpose**: Single integer comparison for dates

**Formula**:
```
YYYYMMDD = Year × 10000 + Month × 100 + Day
```

**Examples**:
| Date | Calculation | YYYYMMDD |
|------|------------|----------|
| 15/11/2025 | 2025×10000 + 11×100 + 15 | 20251115 |
| 01/01/2026 | 2026×10000 + 1×100 + 1 | 20260101 |
| 31/12/2024 | 2024×10000 + 12×100 + 31 | 20241231 |

**Comparison**:
```assembly
; Nov 15, 2025 vs Nov 10, 2025
20251115 > 20251110  ; Nov 15 is later (book overdue)

; Dec 1, 2025 vs Nov 30, 2025
20251201 > 20251130  ; Dec 1 is later
```

---

## Fine Rate Configuration

### Current Settings
```assembly
FINE_RATE DWORD 10  ; Rs. 10 per day fine
```

### Changing Fine Rate
To modify the late fee:
1. Update `FINE_RATE` in `data.inc`
2. Update `FINE_RATE_MSG` to reflect new rate
3. No code changes needed (uses variable)

### Progressive Fine System (Enhancement)
```assembly
; Example: Increasing rates
; Days 1-7:   Rs. 5/day
; Days 8-14:  Rs. 10/day
; Days 15+:   Rs. 20/day

cmp eax, 7
jle rate_5
cmp eax, 14
jle rate_10
mov edx, 20
jmp calc_fine

rate_10:
    mov edx, 10
    jmp calc_fine
    
rate_5:
    mov edx, 5
    
calc_fine:
    mul edx
```

---

## Stack Management Complexity

### VIEW_OVERDUE Stack
```assembly
push ecx      ; current date YYYYMMDD
; ... processing ...
pop ecx       ; restore

pop edx       ; cleanup saved registers
pop ecx
pop ebx
pop eax
```

### CALCULATE_FINES Stack
```assembly
push ecx      ; current date YYYYMMDD
push ecx      ; current year
push eax      ; current month
push ebx      ; current day
; ... complex processing ...
pop ebx       ; day
pop ecx       ; month
pop edx       ; year
pop eax       ; current date
```

**Critical**: Stack must be balanced across all code paths.

---

## Error Handling

### No Overdue Books
```assembly
overdue_check_count:
    cmp esi, 0
    jne overdue_done
    
overdue_no_books:
    INVOKE MSG_DISPLAY, ADDR NO_OVERDUE_MSG
```

### No Fines to Calculate
```assembly
fines_no_books:
    add esp, 16  ; Clean up date components
    INVOKE MSG_DISPLAY, ADDR NO_FINES_MSG
```
**Message**: "No fine to collect for this book. Book not found or returned on time!"

---

## Register Usage

### Common Across Both Functions
- **EAX**: Date components, calculations
- **EBX**: Offset, date component (day)
- **ECX**: Date component (month/year), line length, counters
- **EDX**: Date component, field counters
- **ESI**: Source pointer, counters
- **EDI**: Destination pointer, buffer pointer
- **EBP**: Secondary index for field parsing

---

## Date Arithmetic Issues

### Current Limitations
1. **Month Length**: All months treated as 30 days
2. **Leap Years**: Not considered
3. **Year Boundaries**: Basic handling only
4. **Accuracy**: ±1-2 day error possible

### Real-World Impact
**Example Error Case**:
- Issue: Jan 28, 2025 (10-day period)
- Expected Return: Feb 7, 2025
- System Calculates: Feb 7 (28 + 10 = 38, 38 - 30 = 8 + 30 days in Jan = Feb 8)
- **Error**: 1 day off

### Correct Implementation
```c
// Pseudo-code for accurate date arithmetic
struct Date {
    int day, month, year;
};

int daysInMonth[] = {31,28,31,30,31,30,31,31,30,31,30,31};

Date addDays(Date d, int days) {
    while (days > 0) {
        int daysInCurrentMonth = daysInMonth[d.month-1];
        if (isLeapYear(d.year) && d.month == 2)
            daysInCurrentMonth = 29;
            
        if (d.day + days <= daysInCurrentMonth) {
            d.day += days;
            break;
        }
        days -= (daysInCurrentMonth - d.day + 1);
        d.day = 1;
        d.month++;
        if (d.month > 12) {
            d.month = 1;
            d.year++;
        }
    }
    return d;
}
```

---

## Performance Analysis

### VIEW_OVERDUE
- **Time**: O(n) where n = issued books
- **Space**: O(1) (streams through buffer)
- **File I/O**: 1 read operation

### CALCULATE_FINES
- **Time**: O(n) with early exit on match
- **Space**: O(1)
- **File I/O**: 1 read operation

---

## Security Considerations

1. **Fine Tampering**: Rate hardcoded but visible in binary
2. **Date Manipulation**: Relies on system time (can be changed)
3. **No Payment Tracking**: Fines calculated but not recorded
4. **No Waiver System**: No admin override for forgiveness

---

## Related Files
- `data.inc`: Fine rate, buffers, messages
- `issued.inc`: Issued books management
- `helper.inc`: Display helpers
- Windows API: `GetLocalTime`
