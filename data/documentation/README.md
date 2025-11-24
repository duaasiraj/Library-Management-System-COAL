# Library Management System - Complete Documentation Index

## Overview
This directory contains comprehensive documentation for all `.inc` (include) files in the Library Management System assembly language project.

---

## Documentation Files

### 1. [data.inc_explanation.md](data.inc_explanation.md)
**Data Section Documentation**

Covers all data declarations including:
- Menu messages and UI strings
- File paths and handles
- Data buffers and structures
- System constants and configuration
- Book and member data structures
- CSV file format specifications

**Key Sections**:
- Menu Messages (Main, Librarian, Member, Search, Sort)
- Authentication Messages
- File Management (BOOKS.txt, MEMBERS.txt, ISSUED_BOOKS.txt)
- Book Data Structures and Buffers
- Issue/Return System Buffers
- Overdue and Fines System
- Sorting Structures
- Menu Option Constants

---

### 2. [books.inc_explanation.md](books.inc_explanation.md)
**Book Management Module**

Covers book-related operations:
- Adding new books with ISBN validation
- Viewing books from in-memory array (legacy)
- Displaying books from file with CSV parsing
- Formatted book display with labels

**Key Procedures**:
- `ADD_B`: Add book to catalog
- `VIEW_B`: View books from memory (legacy)
- `VIEW_BFILE`: View books from BOOKS.txt file

**Topics Covered**:
- CSV format specification
- Field-by-field parsing logic
- Error handling for file operations
- Display formatting
- Security issues and improvements

---

### 3. [members.inc_explanation.md](members.inc_explanation.md)
**Member Authentication and Management Module**

Covers user management:
- Member authentication (signin)
- Librarian authentication (hardcoded code)
- Member registration
- Viewing member lists

**Key Procedures**:
- `MEMBER_SIGNIN`: CSV-based credential verification
- `LIB_LOGIN`: Hardcoded librarian access (code: 987102)
- `REG_M`: New member registration
- `VIEW_M`: View members from memory (legacy)
- `VIEW_MFILE`: View members from MEMBERS.txt

**Topics Covered**:
- CSV parsing for authentication
- Stack management in nested loops
- Security vulnerabilities (plaintext passwords)
- File-based user storage
- Edge case handling

---

### 4. [search.inc_explanation.md](search.inc_explanation.md)
**Book Search Module**

Covers search functionality:
- Search by Book Name (field 1)
- Search by Author (field 2)
- Search by Publisher (field 3)
- Search by Year (field 5)

**Key Procedures**:
- `SEARCH_BOOK_FUNC`: Main search menu handler
- `SEARCH_BY_NAME_FUNC`: Name-based search
- `SEARCH_BY_AUTHOR_FUNC`: Author-based search
- `SEARCH_BY_PUBLISHER_FUNC`: Publisher-based search
- `SEARCH_BY_YEAR_FUNC`: Year-based search

**Topics Covered**:
- Line-by-line CSV parsing patterns
- Field extraction by comma counting
- String comparison logic
- Stack management for nested parsing
- Performance analysis (O(n×m) complexity)
- Limitations (exact match only, case-sensitive)

---

### 5. [issued.inc_explanation.md](issued.inc_explanation.md)
**Book Issue and Return Module**

Covers circulation system:
- Issuing books to members (5-book limit)
- Returning borrowed books
- Viewing all issued books
- Automatic return date calculation (10-day period)

**Key Procedures**:
- `ISSUE_BOOK_FUNC`: Check out books with validation
- `RETURN_BOOK_FUNC`: Return books using file rebuild
- `VIEW_ISSUED_BOOKS_FUNC`: Display all issued books

**Topics Covered**:
- Windows `GetLocalTime` API usage
- SYSTEMTIME structure layout
- Date formatting (DD/MM/YYYY)
- Date arithmetic (simplified 30-day months)
- CSV format for issued books
- User limit enforcement
- Duplicate issue prevention
- File rebuild strategy for returns

---

### 6. [fines.inc_explanation.md](fines.inc_explanation.md)
**Overdue Books and Fine Calculation Module**

Covers penalty system:
- Identifying overdue books
- Calculating late fees (Rs. 10/day)
- Date comparison using YYYYMMDD encoding

**Key Procedures**:
- `VIEW_OVERDUE_FUNC`: Display all overdue books
- `CALCULATE_FINES_FUNC`: Calculate fine for specific ISBN

**Topics Covered**:
- Date conversion (DD/MM/YYYY → YYYYMMDD)
- ASCII to integer parsing
- Date comparison logic
- Days overdue calculation
- Fine calculation formula
- Return date extraction from CSV
- Stack management complexity
- Date arithmetic limitations

---

### 7. [sorting.inc_explanation.md](sorting.inc_explanation.md)
**Book Sorting and Display Module**

Covers sorting system:
- Sort by Name, Author, Publisher, Year, ISBN
- Ascending and descending order
- Bubble sort with pointer arrays

**Key Procedures**:
- `VIEW_SORTED_FUNC`: Sort menu handler
- `SortAndDisplayBooks`: Main coordinator
- `ParseLinesIntoArray`: Build pointer arrays
- `SortLines`: Bubble sort implementation
- `CompareFields`: Field-based comparison
- `ExtractField`: CSV field extractor
- `DisplaySortedBooks`: Formatted output

**Topics Covered**:
- Pointer array sorting strategy
- Bubble sort algorithm (O(n²))
- Case-insensitive comparison (uppercase conversion)
- Field extraction by index
- Lexicographic string comparison
- Memory layout of LINE_POINTERS
- Performance analysis
- Optimization opportunities (QuickSort, etc.)

---

### 8. [helper.inc_explanation.md](helper.inc_explanation.md)
**Utility Procedures Module**

Covers helper functions:
- Message display wrapper
- String input wrapper
- Complete file reading
- Formatted book display

**Key Procedures**:
- `MSG_DISPLAY`: WRITESTRING wrapper with INVOKE support
- `STRING_INPUT`: READSTRING wrapper (unused)
- `ReadAllBooks`: Read entire BOOKS.txt into buffer
- `DisplayBookLine`: Parse CSV and display with labels

**Topics Covered**:
- USES directive for register preservation
- INVOKE calling convention
- File reading with SetFilePointer
- Buffer null-termination
- Buffer clearing patterns
- CSV field-by-field extraction
- Register usage and preservation
- Performance optimization opportunities

---

## Module Dependencies

```
Main Program (SourceCode.asm)
├── data.inc (Data definitions)
├── helper.inc (Utilities)
│   ├── MSG_DISPLAY
│   ├── ReadAllBooks
│   └── DisplayBookLine
├── members.inc (Authentication)
│   └── Uses: helper.inc, data.inc
├── books.inc (Book management)
│   └── Uses: helper.inc, data.inc
├── search.inc (Book search)
│   └── Uses: helper.inc, data.inc
├── sorting.inc (Book sorting)
│   └── Uses: helper.inc, data.inc
├── issued.inc (Circulation)
│   └── Uses: helper.inc, data.inc
└── fines.inc (Penalties)
    └── Uses: helper.inc, data.inc
```

---

## Common Patterns Across Modules

### 1. CSV Parsing Pattern
```assembly
; Find line start and length
lea edi, [OFFSET buffer + offset]
xor ecx, ecx
find_eol:
    mov al, [edi + ecx]
    cmp al, 0Dh
    je process_line
    inc ecx

; Extract field
xor edx, edx
find_comma:
    cmp byte ptr [edi + edx], ','
    je got_comma
    inc edx

; Copy field
copy_field:
    mov al, [esi]
    mov [edi], al
    inc esi
    inc edi
```

### 2. File Operation Pattern
```assembly
; Open file
INVOKE CreateFile, ADDR filename, GENERIC_READ, ...
mov filehandle, eax

; Read file
INVOKE ReadFile, filehandle, ADDR buffer, size, ADDR bytesRead, 0

; Close file
INVOKE CloseHandle, filehandle
```

### 3. Stack Management Pattern
```assembly
; Save context
push ecx
push edi
push esi

; ... processing ...

; Restore context (reverse order)
pop esi
pop edi
pop ecx
```

---

## Data Flow Diagram

```
User Input
    ↓
Main Menu (SourceCode.asm)
    ↓
┌─────────┬──────────┬─────────┬─────────┬─────────┐
│ Members │  Books   │ Search  │ Issued  │ Fines   │
│  .inc   │  .inc    │  .inc   │  .inc   │  .inc   │
└─────────┴──────────┴─────────┴─────────┴─────────┘
    ↓           ↓          ↓         ↓         ↓
    └───────────┴──────────┴─────────┴─────────┘
                     ↓
              ┌────────────┐
              │ helper.inc │
              │ data.inc   │
              └────────────┘
                     ↓
          ┌──────────────────────┐
          │ File System          │
          │ - MEMBERS.txt        │
          │ - BOOKS.txt          │
          │ - ISSUED_BOOKS.txt   │
          └──────────────────────┘
```

---

## Key Algorithms

### 1. Date Conversion (fines.inc)
```
DD/MM/YYYY → YYYYMMDD
Example: 15/11/2025 → 20251115
Formula: Year×10000 + Month×100 + Day
```

### 2. Bubble Sort (sorting.inc)
```
Time: O(n²) average and worst case
Space: O(1) - in-place pointer swap
Optimization: Early exit if no swaps
```

### 3. ISBN Validation (books.inc)
```
Current: Length check only (13 digits)
Better: ISBN-13 checksum algorithm
```

### 4. Fine Calculation (fines.inc)
```
Fine = Days_Overdue × Fine_Rate
Fine_Rate = Rs. 10 per day
Days_Overdue = Current_Date - Return_Date
```

---

## Configuration Constants

| Constant | Value | File | Purpose |
|----------|-------|------|---------|
| `BUFFER_SIZE` | 5000 | data.inc | Max file read size |
| `MAX_BOOKS` | 100 | data.inc | Sort capacity |
| `FINE_RATE` | 10 | data.inc | Rs. per day late fee |
| `BOOK_NAME_SIZE` | 150 | data.inc | Book name buffer |
| `MEMBER_SIZE` | 20 | data.inc | Member name length |
| Librarian Code | 987102 | members.inc | Admin password |
| Borrow Period | 10 days | issued.inc | Loan duration |
| Book Limit | 5 | issued.inc | Max per member |

---

## CSV File Formats

### BOOKS.txt
```csv
Name,Author,Publisher,Genre,Year,ISBN
1984,George Orwell,Secker & Warburg,Dystopian,1949,9780451524935
```

### MEMBERS.txt
```csv
Username,Password
alice,pass123
```

### ISSUED_BOOKS.txt
```csv
Username,BookName,ISBN,IssueDate,ReturnDate
alice,1984,9780451524935,15/11/2025,25/11/2025
```

---

## External Dependencies

### Irvine32 Library
- `WRITESTRING`, `READSTRING`, `READINT`
- `CRLF`, `WriteDec`, `WriteString`
- `Str_compare`, `Str_length`, `Str_ucase`

### Windows API
- `CreateFile`, `ReadFile`, `WriteFile`
- `SetFilePointer`, `CloseHandle`
- `GetLocalTime`

---

## Security Issues Summary

1. **Plaintext Passwords**: MEMBERS.txt stores unencrypted
2. **Hardcoded Admin Code**: 987102 visible in binary
3. **No Input Sanitization**: Commas in fields break CSV
4. **No Rate Limiting**: Unlimited login attempts
5. **No Audit Trail**: Failed operations not logged
6. **File Locking**: DO_NOT_SHARE prevents concurrent access
7. **Buffer Overflows**: Minimal size checking
8. **Date Manipulation**: System time can be changed

---

## Performance Characteristics

| Operation | Time Complexity | Space Complexity |
|-----------|----------------|------------------|
| Member Login | O(n) | O(1) |
| Add Book | O(1) | O(1) |
| View Books | O(n×m) | O(1) |
| Search Book | O(n×m) | O(1) |
| Sort Books | O(n²×k) | O(n) |
| Issue Book | O(n) | O(1) |
| Return Book | O(n) | O(n) |
| Calculate Fine | O(n) | O(1) |

Where:
- n = number of records
- m = average line length
- k = average field length

---

## Future Enhancement Suggestions

### High Priority
1. **Password Hashing**: Implement SHA-256 or bcrypt
2. **Input Validation**: Sanitize all user inputs
3. **Error Recovery**: Handle file corruption gracefully
4. **Date Library**: Use proper date arithmetic

### Medium Priority
5. **QuickSort**: Replace bubble sort (O(n log n))
6. **Dynamic Buffers**: Support unlimited file sizes
7. **Indexing**: Build hash tables for fast lookup
8. **Transaction Log**: Audit all operations

### Low Priority
9. **Multi-user**: Support concurrent access with locking
10. **Backup System**: Automatic file backups
11. **Export/Import**: CSV import/export tools
12. **Statistics**: Generate usage reports

---

## Testing Checklist

### Functional Tests
- [ ] Add book with valid ISBN
- [ ] Add book with invalid ISBN
- [ ] View empty book list
- [ ] View 100+ books
- [ ] Search by each field
- [ ] Sort by each field (asc/desc)
- [ ] Register new member
- [ ] Login with valid credentials
- [ ] Login with invalid credentials
- [ ] Issue book (within limit)
- [ ] Issue 6th book (should fail)
- [ ] Return book
- [ ] Return non-issued book
- [ ] Calculate fine for overdue book
- [ ] Calculate fine for on-time book

### Edge Case Tests
- [ ] Empty CSV files
- [ ] Malformed CSV (missing commas)
- [ ] Very long field values
- [ ] Special characters in fields
- [ ] Leap year date calculations
- [ ] Year boundary crossings
- [ ] Concurrent file access
- [ ] File locked by another process

### Performance Tests
- [ ] 100 books - all operations
- [ ] 1000 members login
- [ ] Search in large dataset
- [ ] Sort 100 books
- [ ] Issue/return stress test

---

## Troubleshooting Guide

### Common Issues

**"Book not found"**
- Check ISBN exactly matches (case-sensitive)
- Verify BOOKS.txt is in data/ directory
- Ensure file is not empty
- Check CSV format (6 fields)

**"Invalid credentials"**
- Username and password are case-sensitive
- Check MEMBERS.txt for correct entry
- Verify no extra spaces
- Ensure file has CRLF line endings

**"Maximum limit of 5 books"**
- Return a book before issuing new one
- Check ISSUED_BOOKS.txt for user's entries
- Username must match exactly

**Program crash on file operation**
- Verify data/ directory exists
- Check file permissions
- Ensure files are not locked
- Validate CSV format

---

## Additional Resources

- Assembly Language Documentation
- Irvine32 Library Reference
- Windows API Documentation
- CSV Format Specification (RFC 4180)
- x86 Instruction Set Reference

---

## Contributing

When modifying the code:
1. Update relevant .inc file
2. Update corresponding documentation
3. Test thoroughly (see checklist)
4. Document any new procedures
5. Update this index if adding new files

---

## License

[Project License Information]

---

## Version History

- **v1.0** (Current): Initial documentation complete
  - All 8 .inc files documented
  - Comprehensive explanations
  - Code examples and diagrams
  - Security analysis
  - Performance profiling

---

**Last Updated**: November 15, 2025
