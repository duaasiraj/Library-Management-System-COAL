
.DATA

topMsg BYTE 0AH
    BYTE    "--------------------------------------------",0dh,0ah
    BYTE    "--  WELCOME TO LIBRARY MANAGEMENT SYSTEM  --",0dh,0ah
    BYTE    "--------------------------------------------",0dh,0ah,0ah
    BYTE    "1-> Librarian",0dh,0ah
    BYTE    "2-> Member",0dh,0ah
    BYTE    "3-> Exit",0dh,0ah
    BYTE    "Choose Your Option : ",0

msg1     BYTE 0AH
    BYTE    "Librarian Menu:", 0dh, 0ah
    BYTE    "1. View Overdue Books", 0dh,0ah
    BYTE    "2. Calculate Fines", 0dh,0ah
    BYTE    "3. Add Book", 0dh,0ah
    BYTE    "4. Display All Books", 0dh,0ah
    BYTE    "5. Display All Users", 0dh,0ah
    BYTE    "6. View Issued Books", 0dh,0ah
    BYTE    "7. Logout", 0dh,0ah
    BYTE    "Choose Your Option : ",0
    LIB_LOGIN_MSG BYTE 0AH, "Enter librarian code: ",0
    INVALID_CODE_MSG BYTE 0AH, "Invalid code. Returning to top menu.",0dh,0ah,0
    LIB_SUCCESS_MSG BYTE 0AH, "Login successful! Welcome, Librarian.",0dh,0ah,0

MEMBER_MENU_MSG BYTE 0Ah, "1-> Sign In",0dh,0ah, "2-> Register",0dh,0ah, "Choose Your Option : ",0
MEMBER_SUCCESS_MSG BYTE 0AH, "Login successful! Welcome, ",0
MEMBER_SUCCESS_MSG2 BYTE ".",0dh,0ah,0

MEMBER_OPTIONS_MSG BYTE 0Ah
    BYTE    "Member Menu:",0dh,0ah
    BYTE    "1. Search a Book",0dh,0ah
    BYTE    "2. Issue Book",0dh,0ah
    BYTE    "3. Return Book",0dh,0ah
    BYTE    "4. View Sorted Books",0dh,0ah
    BYTE    "5. Logout",0dh,0ah
    BYTE    "Select an option: ",0

SEARCH_MENU_MSG BYTE 0Ah
    BYTE    "Search Menu:",0dh,0ah
    BYTE    "1. By Name",0dh,0ah
    BYTE    "2. By Author",0dh,0ah
    BYTE    "3. By Publisher",0dh,0ah
    BYTE    "4. By Year",0dh,0ah
    BYTE    "5. Back",0dh,0ah
    BYTE    "Select an option: ",0
 
SORT_MENU_MSG BYTE 0Ah
    BYTE    "Sort Menu:",0dh,0ah
    BYTE    "1. Name (Ascending)",0dh,0ah
    BYTE    "2. Name (Descending)",0dh,0ah
    BYTE    "3. Author (Ascending)",0dh,0ah
    BYTE    "4. Author (Descending)",0dh,0ah
    BYTE    "5. Publisher (Ascending)",0dh,0ah
    BYTE    "6. Publisher (Descending)",0dh,0ah
    BYTE    "7. Year (Ascending)",0dh,0ah
    BYTE    "8. Year (Descending)",0dh,0ah
    BYTE    "9. ISBN (Ascending)",0dh,0ah
    BYTE    "10. ISBN (Descending)",0dh,0ah
    BYTE    "11. Back",0dh,0ah
    BYTE    "Select an option: ",0

SIGNIN_USER_MSG BYTE "Enter username: ",0
SIGNIN_PASS_MSG BYTE "Enter password: ",0
INVALID_CRED_MSG BYTE 0Ah, "Invalid email or password.",0dh,0ah,0

NO_BOOKS_MSG BYTE 0Ah, "No books found.",0Dh,0Ah,0
OVERDUE_BOOKS_HEADER BYTE 0Ah, "========== OVERDUE BOOKS ==========" ,0dh,0ah,0
NO_OVERDUE_MSG BYTE 0Ah, "No overdue books found.",0dh,0ah,0
ISSUED_BOOKS_HEADER BYTE 0Ah, "========== ISSUED BOOKS ==========" ,0dh,0ah,0
NO_ISSUED_MSG BYTE 0Ah, "No books are currently issued.",0dh,0ah,0
OVERDUE_SEPARATOR BYTE "-----------------------------------",0dh,0ah,0
USERNAME_LABEL BYTE "Username: ",0
ISSUE_DATE_LABEL BYTE "Issue Date: ",0
RETURN_DATE_LABEL BYTE "Return Date: ",0
FINES_HEADER BYTE 0Ah, "========== CALCULATE FINES ==========" ,0dh,0ah,0
DAYS_OVERDUE_LABEL BYTE "Days Overdue: ",0
FINE_AMOUNT_LABEL BYTE "Fine Amount: Rs. ",0
TOTAL_FINE_LABEL BYTE 0Ah, "Total Fines: Rs. ",0
NO_FINES_MSG BYTE 0Ah, "No fine to collect for this book. Book not found or returned on time!",0dh,0ah,0
FINE_RATE_MSG BYTE "(Fine rate: Rs. 10 per day)",0dh,0ah,0

USERNAME_BUF BYTE 20 DUP(?)
PASSWORD_BUF BYTE 10 DUP(?)
COMMA_BYTE BYTE ',',0
LINE_USER_BUF BYTE 20 DUP(?)
LINE_PASS_BUF BYTE 10 DUP(?)
REG_MSG    BYTE "    Enter Name: ",0
VIEW_MEMBERS_MSG BYTE 0Ah,"    Viewing Registered Members: ",0AH, 0DH, 0
ADD_MSG             BYTE "    Enter Book Name & Author Name to Add: ", 0dh, 0ah,
                 "    Separated By Comma:",0
VIEW_BOOKS_MSG BYTE 0Ah, "    Viewing Books in Library: ",  0dh, 0ah, 0
EXIT_MSG       BYTE 0AH,
                    "    ----------------- ",0dh, 0ah,
                    "    Exiting Program...",0dh, 0ah,
                    "    See you again  :')",0dh, 0ah,
                    "    ------------------", 0
                    
    CRLF_BYTES BYTE 0Dh,0Ah,0
    NAME_LABEL BYTE "Name: ",0
    AUTHOR_LABEL BYTE "Author: ",0
    PUBLISHER_LABEL BYTE "Publisher: ",0
    GENRE_LABEL BYTE "Genre: ",0
    YEAR_LABEL BYTE "Year: ",0
    ISBN_LABEL BYTE "ISBN: ",0
                    
; variables to maniulate Books & Members

bool           DWORD ?
MEMBERS_FILE   BYTE "data\\MEMBERS.txt",0
BOOKS_FILE     BYTE "data\\BOOKS.txt",0
ISSUED_BOOKS_FILE BYTE "data\\ISSUED_BOOKS.txt",0
filehandle     DWORD ?
BUFFER_SIZE = 5000
buffer_mem   BYTE buffer_size DUP (?)
buffer_book  BYTE buffer_size DUP (?)
bytesRead dword 1 dup(0)
; Librarian menu options
VIEW_OVERDUE    DWORD 1
CALCULATE_FINES DWORD 2
ADD_BOOK     DWORD 3
DISPLAY_BOOKS     DWORD 4
DISPLAY_USERS     DWORD 5
VIEW_ISSUED_BOOKS DWORD 6
LIB_LOGOUT     DWORD 7

; Member menu options
SEARCH_BOOK     DWORD 1
ISSUE_BOOK     DWORD 2
RETURN_BOOK     DWORD 3
VIEW_SORTED     DWORD 4
MEMBER_LOGOUT DWORD 5

; Search menu options
SEARCH_BY_NAME     DWORD 1
SEARCH_BY_AUTHOR DWORD 2
SEARCH_BY_PUBLISHER DWORD 3
SEARCH_BY_YEAR     DWORD 4
SEARCH_BACK     DWORD 5    
MEMBER_SIZE = 20
MEMBER1 DB MEMBER_SIZE DUP (?)
MEMBER2 DB MEMBER_SIZE DUP (?)
MEMBER3 DB MEMBER_SIZE DUP (?)
MEMBER4 DB MEMBER_SIZE DUP (?)
MEMBER5 DB MEMBER_SIZE DUP (?)
MEMBER6 DB MEMBER_SIZE DUP (?)
NUM_MEMBERS DWORD 0
MEMBERS DD MEMBER1, MEMBER2, MEMBER3, MEMBER4, MEMBER5, MEMBER6, 0AH, 0DH, 0

BOOK_SIZE = 30
BOOK1 DB BOOK_SIZE DUP (?)
BOOK2 DB BOOK_SIZE DUP (?)
BOOK3 DB BOOK_SIZE DUP (?)
BOOK4 DB BOOK_SIZE DUP (?)
BOOK5 DB BOOK_SIZE DUP (?)
BOOK6 DB BOOK_SIZE DUP (?)
NUM_BOOKS DWORD 0
BOOKS DD BOOK1, BOOK2, BOOK3, BOOK4, BOOK5, BOOK6, 0AH, 0DH, 0

; Book structure variables
BOOK_STRUCT_SIZE = 200
CURRENT_BOOK DB BOOK_STRUCT_SIZE DUP (?)
BOOK_NAME_SIZE = 150
BOOK_AUTHOR_SIZE = 150
BOOK_PUBLISHER_SIZE = 150
BOOK_GENRE_SIZE = 100

; Book input buffers
BOOK_NAME_BUF DB BOOK_NAME_SIZE DUP (?)
BOOK_AUTHOR_BUF DB BOOK_AUTHOR_SIZE DUP (?)
BOOK_PUBLISHER_BUF DB BOOK_PUBLISHER_SIZE DUP (?)
BOOK_GENRE_BUF DB BOOK_GENRE_SIZE DUP (?)
BOOK_YEAR_BUF DB 10 DUP (?)
BOOK_ISBN_BUF DB 20 DUP (?)

; Temp buffers used by search routines
TEMP_FIELD DB 200 DUP(?)
TEMP_LINE  DB 512 DUP(?)

; Book input prompts
ISBN_PROMPT BYTE "Enter ISBN: ",0
BOOK_NAME_PROMPT BYTE "Enter book name: ",0
BOOK_AUTHOR_PROMPT BYTE "Enter author name: ",0
BOOK_PUBLISHER_PROMPT BYTE "Enter publisher name: ",0
BOOK_GENRE_PROMPT BYTE "Enter Genre: ",0
BOOK_YEAR_PROMPT BYTE "Enter publishing year: ",0
INVALID_ISBN_MSG BYTE "You must enter a valid 13 digit ISBN number.",0dh,0ah,0
DUPLICATE_ISBN_MSG BYTE "That book already exists. Please check the ISBN number again.",0dh,0ah,0
BOOK_ADDED_MSG BYTE "Book added successfully!",0dh,0ah,0

; Issue/Return book messages
ISSUE_BOOK_MSG BYTE 0Ah, "Issue Book",0dh,0ah, "Enter ISBN of book to issue: ",0
RETURN_BOOK_MSG BYTE 0Ah, "Return Book",0dh,0ah, "Enter ISBN of book to return: ",0
BOOK_NOT_FOUND_MSG BYTE "Book not found in library.",0dh,0ah,0
BOOK_ISSUED_SUCCESS_MSG BYTE "Book issued successfully!",0dh,0ah,0
BOOK_ALREADY_ISSUED_MSG BYTE "This book is already issued.",0dh,0ah,0
BOOK_RETURNED_SUCCESS_MSG BYTE "Book returned successfully!",0dh,0ah,0
BOOK_NOT_ISSUED_MSG BYTE "This book was not issued to any member.",0dh,0ah,0
BOOK_LIMIT_REACHED_MSG BYTE "You have reached the maximum limit of 5 issued books.",0dh,0ah, "Please return a book before issuing a new one.",0dh,0ah,0

; ISBN search buffer
ISBN_SEARCH_BUF DB 20 DUP(?)

; Date buffer for issue/return
DATE_BUF DB 20 DUP(?)
RETURN_DATE_BUF DB 20 DUP(?)
ISSUED_BOOK_NAME_BUF DB 150 DUP(?)
CURRENT_DATE_BUF DB 20 DUP(?)
PARSED_RETURN_DATE_BUF DB 20 DUP(?)
OVERDUE_USERNAME_BUF DB 20 DUP(?)
OVERDUE_BOOKNAME_BUF DB 150 DUP(?)
OVERDUE_ISBN_BUF DB 20 DUP(?)
OVERDUE_ISSUE_DATE_BUF DB 20 DUP(?)
DAYS_OVERDUE_BUF DB 10 DUP(?)
FINE_AMOUNT_BUF DB 20 DUP(?)
FINE_RATE DWORD 10  ; Rs. 10 per day fine

; ISBN validation constants
ISBN_CHECK QWORD 1000000000000
VALID_ISBN_MIN QWORD 1000000000000
VALID_ISBN_MAX QWORD 9999999999999

; Sorting structures
MAX_BOOKS = 100
LINE_POINTERS DD MAX_BOOKS DUP(?)
LINE_LENGTHS DD MAX_BOOKS DUP(?)
NUM_LINES DWORD 0
SORT_TEMP_LINE DB 512 DUP(?)
