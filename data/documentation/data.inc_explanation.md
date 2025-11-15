# data.inc - Data Section Documentation

## Overview
The `data.inc` file contains all data declarations for the Library Management System. This includes menu strings, error messages, file paths, buffers, and system constants used throughout the application.

## File Purpose
This file serves as the central repository for:
- User interface messages and menu text
- File paths and handles
- Data buffers for temporary storage
- System constants and configuration values
- Book and member structure definitions

---

## Data Sections

### 1. Menu Messages

#### Main Menu (`topMsg`)
- **Purpose**: Displays the initial welcome screen
- **Options**: Librarian (1), Member (2), Exit (3)
- **Format**: Multi-line string with ASCII art borders

#### Librarian Menu (`msg1`)
- **Purpose**: Shows librarian-specific options
- **Options**:
  1. View Overdue Books
  2. Calculate Fines
  3. Add Book
  4. Display All Books
  5. Display All Users
  6. View Issued Books
  7. Logout

#### Member Menu (`MEMBER_OPTIONS_MSG`)
- **Purpose**: Shows member-specific options
- **Options**:
  1. Search a Book
  2. Issue Book
  3. Return Book
  4. View Sorted Books
  5. Logout

#### Search Menu (`SEARCH_MENU_MSG`)
- **Purpose**: Book search options
- **Fields**: Name, Author, Publisher, Year, Back option

#### Sort Menu (`SORT_MENU_MSG`)
- **Purpose**: Sorting options for books
- **Options**: Ascending/Descending sorting by Name, Author, Publisher, Year, ISBN
- **Total Options**: 10 sort combinations + Back option

---

### 2. Authentication Messages

#### Librarian Login
- `LIB_LOGIN_MSG`: Prompts for librarian code
- `INVALID_CODE_MSG`: Invalid code error
- `LIB_SUCCESS_MSG`: Successful login confirmation
- **Note**: Hardcoded librarian code is `987102`

#### Member Authentication
- `MEMBER_MENU_MSG`: Sign In/Register options
- `SIGNIN_USER_MSG`: Username prompt
- `SIGNIN_PASS_MSG`: Password prompt
- `INVALID_CRED_MSG`: Invalid credentials error
- `MEMBER_SUCCESS_MSG/MSG2`: Welcome message components

---

### 3. File Management

#### File Paths
```assembly
MEMBERS_FILE   BYTE "data\\MEMBERS.txt",0
BOOKS_FILE     BYTE "data\\BOOKS.txt",0
ISSUED_BOOKS_FILE BYTE "data\\ISSUED_BOOKS.txt",0
```
- **Storage Location**: `data/` directory
- **Format**: CSV (Comma-Separated Values)
- **Purpose**: Persistent storage of library data

#### File Handling Variables
- `filehandle`: Windows file handle (DWORD)
- `BUFFER_SIZE = 5000`: Maximum buffer size
- `buffer_mem`: General-purpose buffer (5000 bytes)
- `buffer_book`: Book-specific buffer (5000 bytes)
- `bytesRead`: Tracks bytes read from file

---

### 4. Book Data Structures

#### Book Buffers
```assembly
BOOK_NAME_BUF      DB 150 DUP (?)
BOOK_AUTHOR_BUF    DB 150 DUP (?)
BOOK_PUBLISHER_BUF DB 150 DUP (?)
BOOK_GENRE_BUF     DB 100 DUP (?)
BOOK_YEAR_BUF      DB 10 DUP (?)
BOOK_ISBN_BUF      DB 20 DUP (?)
```
- **Purpose**: Temporary storage for book field parsing
- **Size Constraints**: Prevent buffer overflow

#### Book Input Prompts
- `ISBN_PROMPT`: "Enter ISBN: "
- `BOOK_NAME_PROMPT`: "Enter book name: "
- `BOOK_AUTHOR_PROMPT`: "Enter author name: "
- `BOOK_PUBLISHER_PROMPT`: "Enter publisher name: "
- `BOOK_GENRE_PROMPT`: "Enter Genre: "
- `BOOK_YEAR_PROMPT`: "Enter publishing year: "

#### Book Operation Messages
- `BOOK_ADDED_MSG`: Success confirmation
- `INVALID_ISBN_MSG`: ISBN validation error (must be 13 digits)
- `DUPLICATE_ISBN_MSG`: Book already exists error

---

### 5. Issue/Return System

#### Buffers
- `ISBN_SEARCH_BUF`: ISBN for book lookup (20 bytes)
- `DATE_BUF`: Issue date storage (20 bytes)
- `RETURN_DATE_BUF`: Return date storage (20 bytes)
- `ISSUED_BOOK_NAME_BUF`: Book name for issued book (150 bytes)

#### Date Tracking
- `CURRENT_DATE_BUF`: Current system date
- `PARSED_RETURN_DATE_BUF`: Parsed return date from file
- **Format**: DD/MM/YYYY

#### Issue/Return Messages
- `ISSUE_BOOK_MSG`: Issue book prompt
- `RETURN_BOOK_MSG`: Return book prompt
- `BOOK_NOT_FOUND_MSG`: Book doesn't exist
- `BOOK_ISSUED_SUCCESS_MSG`: Successfully issued
- `BOOK_ALREADY_ISSUED_MSG`: Book already checked out
- `BOOK_RETURNED_SUCCESS_MSG`: Successfully returned
- `BOOK_NOT_ISSUED_MSG`: Book wasn't issued
- `BOOK_LIMIT_REACHED_MSG`: Maximum 5 books per member

---

### 6. Overdue and Fines System

#### Overdue Tracking Buffers
```assembly
OVERDUE_USERNAME_BUF   DB 20 DUP(?)
OVERDUE_BOOKNAME_BUF   DB 150 DUP(?)
OVERDUE_ISBN_BUF       DB 20 DUP(?)
OVERDUE_ISSUE_DATE_BUF DB 20 DUP(?)
```

#### Fine Calculation
- `FINE_RATE DWORD 10`: Rs. 10 per day late fee
- `DAYS_OVERDUE_BUF`: Days overdue counter
- `FINE_AMOUNT_BUF`: Calculated fine amount

#### Display Labels
- `OVERDUE_BOOKS_HEADER`: Header for overdue list
- `ISSUED_BOOKS_HEADER`: Header for issued books
- `NO_OVERDUE_MSG`: No overdue books message
- `NO_ISSUED_MSG`: No issued books message
- `OVERDUE_SEPARATOR`: Visual separator line
- `FINE_RATE_MSG`: "(Fine rate: Rs. 10 per day)"

---

### 7. Member Management

#### Member Arrays
```assembly
MEMBER_SIZE = 20
MEMBER1 DB 20 DUP (?)
MEMBER2 DB 20 DUP (?)
...
MEMBER6 DB 20 DUP (?)
NUM_MEMBERS DWORD 0
MEMBERS DD MEMBER1, MEMBER2, MEMBER3, MEMBER4, MEMBER5, MEMBER6
```
- **Capacity**: 6 members (legacy array)
- **Note**: Actual member storage uses MEMBERS.txt file

#### Authentication Buffers
- `USERNAME_BUF`: Login username (20 bytes)
- `PASSWORD_BUF`: Login password (10 bytes)
- `LINE_USER_BUF`: Parsed username from file
- `LINE_PASS_BUF`: Parsed password from file

---

### 8. Sorting System

#### Sort Structures
```assembly
MAX_BOOKS = 100
LINE_POINTERS DD 100 DUP(?)
LINE_LENGTHS  DD 100 DUP(?)
NUM_LINES     DWORD 0
SORT_TEMP_LINE DB 512 DUP(?)
```
- **LINE_POINTERS**: Array of pointers to book lines in buffer
- **LINE_LENGTHS**: Length of each book line
- **NUM_LINES**: Count of books loaded
- **MAX_BOOKS**: System limit of 100 books

---

### 9. Menu Option Constants

#### Librarian Options
```assembly
VIEW_OVERDUE    DWORD 1
CALCULATE_FINES DWORD 2
ADD_BOOK        DWORD 3
DISPLAY_BOOKS   DWORD 4
DISPLAY_USERS   DWORD 5
VIEW_ISSUED_BOOKS DWORD 6
LIB_LOGOUT      DWORD 7
```

#### Member Options
```assembly
SEARCH_BOOK    DWORD 1
ISSUE_BOOK     DWORD 2
RETURN_BOOK    DWORD 3
VIEW_SORTED    DWORD 4
MEMBER_LOGOUT  DWORD 5
```

#### Search Options
```assembly
SEARCH_BY_NAME      DWORD 1
SEARCH_BY_AUTHOR    DWORD 2
SEARCH_BY_PUBLISHER DWORD 3
SEARCH_BY_YEAR      DWORD 4
SEARCH_BACK         DWORD 5
```

---

### 10. Utility Data

#### Display Helpers
- `CRLF_BYTES`: Carriage return + line feed (0Dh, 0Ah)
- `COMMA_BYTE`: CSV field separator (',')
- `NAME_LABEL`, `AUTHOR_LABEL`, etc.: Field labels for display

#### Temporary Buffers
- `TEMP_FIELD`: General field extraction (200 bytes)
- `TEMP_LINE`: Full line storage (512 bytes)

---

## CSV File Format

### BOOKS.txt
```
Name,Author,Publisher,Genre,Year,ISBN
```

### MEMBERS.txt
```
Username,Password
```

### ISSUED_BOOKS.txt
```
Username,BookName,ISBN,IssueDate,ReturnDate
```
- **Date Format**: DD/MM/YYYY
- **Return Period**: 10 days from issue date

---

## Constants and Limits

| Constant | Value | Purpose |
|----------|-------|---------|
| `BUFFER_SIZE` | 5000 | Maximum file read size |
| `MEMBER_SIZE` | 20 | Member name length |
| `BOOK_SIZE` | 30 | Book field length (legacy) |
| `BOOK_NAME_SIZE` | 150 | Book name buffer |
| `BOOK_AUTHOR_SIZE` | 150 | Author name buffer |
| `MAX_BOOKS` | 100 | Maximum sortable books |
| `FINE_RATE` | 10 | Rupees per day late fee |
| Librarian Code | 987102 | Hardcoded admin code |

---

## Usage Notes

1. **Buffer Management**: All buffers are pre-allocated with `DUP(?)` to avoid initialization overhead
2. **CSV Parsing**: Comma delimiters require careful parsing to handle fields correctly
3. **Date Handling**: Uses Windows `GetLocalTime` API for current date
4. **File Paths**: Relative paths assume execution from project root
5. **Security**: Passwords stored in plain text (not encrypted)

---

## Related Files
- `books.inc`: Book management operations
- `members.inc`: Member authentication and registration
- `issued.inc`: Book issue/return logic
- `fines.inc`: Overdue and fine calculations
- `search.inc`: Search functionality
- `sorting.inc`: Sorting algorithms
- `helper.inc`: Utility procedures
