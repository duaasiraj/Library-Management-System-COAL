INCLUDE IRVINE32.inc
INCLUDE src\data.inc

.CODE
MSG_DISPLAY proto, var: PTR DWORD
STRING_INPUT proto, var1: PTR DWORD
WriteCSVField PROTO :DWORD, :DWORD

main PROC
	START:
	; Top-level menu: Librarian / Member / Exit
	INVOKE MSG_DISPLAY, ADDR topMsg
	CALL READINT ; read top-level choice

	CMP EAX, 1
	JE LIB_LOGIN
	CMP EAX, 2
	JE MEMBER_MENU
	CMP EAX, 3
	JE EXIT_MENU
	; any other input -> show top menu again
	JMP START

SHOW_FULL_MENU:
	; display the librarian menu and read option
	INVOKE MSG_DISPLAY, ADDR MSG1
	CALL READINT ; input for options

	CMP EAX, VIEW_OVERDUE
	JE VIEW_OVERDUE_FUNC	; jump to View Overdue Books section
	CMP EAX, CALCULATE_FINES
	JE CALCULATE_FINES_FUNC	; jump to Calculate Fines section
	CMP EAX, ADD_BOOK
	JE ADD_B		; jump to Add Book section
	CMP EAX, DISPLAY_BOOKS
	JE VIEW_BFILE		; jump to Display All Books section (from file)
	CMP EAX, DISPLAY_USERS
	JE VIEW_MFILE		; jump to Display All Users section
	CMP EAX, VIEW_ISSUED_BOOKS
	JE VIEW_ISSUED_BOOKS_FUNC	; jump to View Issued Books section
	CMP EAX, LIB_LOGOUT
	JE START		; logout -> return to main menu
	JMP SHOW_FULL_MENU	; invalid option -> show menu again

SHOW_MEMBER_MENU:
	; display member menu and read option
	INVOKE MSG_DISPLAY, ADDR MEMBER_OPTIONS_MSG
	CALL READINT ; input for options

	CMP EAX, SEARCH_BOOK
	JE SEARCH_BOOK_FUNC	; jump to Search Book section
	CMP EAX, ISSUE_BOOK
	JE ISSUE_BOOK_FUNC	; jump to Issue Book section
	CMP EAX, RETURN_BOOK
	JE RETURN_BOOK_FUNC	; jump to Return Book section
	CMP EAX, VIEW_SORTED
	JE VIEW_SORTED_FUNC	; jump to View Sorted Books section
	CMP EAX, MEMBER_LOGOUT
	JE START		; logout -> return to main menu
	JMP SHOW_MEMBER_MENU	; invalid option -> show menu again

MEMBER_MENU:
	; Show member options: Sign In or Register
	INVOKE MSG_DISPLAY, ADDR MEMBER_MENU_MSG
	CALL READINT
	CMP EAX, 1
	JE MEMBER_SIGNIN
	CMP EAX, 2
	JE REG_M    ; Register -> call registration routine directly
	JMP START


INCLUDE  src\members.inc
INCLUDE  src\fines.inc
INCLUDE  src\issued.inc
INCLUDE  src\search.inc
INCLUDE  src\sorting.inc
INCLUDE  src\books.inc

main endp

INCLUDE  src\helper.inc

end main