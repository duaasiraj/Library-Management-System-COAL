# members.inc - Member Authentication and Management Module

## Overview
The `members.inc` file handles all member-related operations including user authentication, registration, and member listing. It implements CSV-based credential verification and file management for persistent user data.

---

## Procedures

### 1. MEMBER_SIGNIN - Member Authentication

#### Purpose
Authenticates members by verifying username and password against MEMBERS.txt file.

#### Authentication Flow

**Phase 1: Credential Collection**
```assembly
INVOKE MSG_DISPLAY, ADDR SIGNIN_USER_MSG  ; "Enter username: "
mov edx, OFFSET USERNAME_BUF
mov ecx, 20
CALL READSTRING

INVOKE MSG_DISPLAY, ADDR SIGNIN_PASS_MSG  ; "Enter password: "
mov edx, OFFSET PASSWORD_BUF
mov ecx, 10
CALL READSTRING
```
- Username: Max 20 characters
- Password: Max 10 characters
- No input masking for password (security issue)

**Phase 2: File Reading**
```assembly
INVOKE CreateFile, ADDR MEMBERS_FILE, GENERIC_READ, ...
invoke ReadFile, filehandle, ADDR BUFFER_MEM, BUFFER_SIZE, ADDR bytesRead, 0
invoke CloseHandle, filehandle
```
- Opens `data\MEMBERS.txt`
- Reads entire file into `BUFFER_MEM`
- Closes handle immediately after read

**Phase 3: CSV Parsing and Verification**
```assembly
search_loop:
    lea edi, [OFFSET BUFFER_MEM + ebx]  ; Current line pointer
    
    find_eol:  ; Find line length
        cmp al, 0Dh  ; Check for CR
        je process_line
        
    process_line:
        ; Find comma separator
        find_comma:
            cmp byte ptr [edi + edx], ','
            je got_comma
```

**Field Extraction Logic**
1. **Username Extraction** (before comma):
   ```assembly
   copy_user:
       mov al, [esi]
       mov [edi], al
       inc esi
       inc edi
   ```
   - Copies characters to `LINE_USER_BUF`
   - Stops at comma delimiter
   - Null-terminates string

2. **Password Extraction** (after comma):
   ```assembly
   ; Calculate password length = lineLen - commaIndex - 1
   mov eax, [esp]  ; Get line length from stack
   sub eax, edx
   dec eax
   ```
   - Starts after comma position
   - Copies to `LINE_PASS_BUF`
   - Handles variable-length passwords

**Phase 4: Credential Comparison**
```assembly
INVOKE Str_compare, ADDR USERNAME_BUF, ADDR LINE_USER_BUF
jne restore_and_continue

INVOKE Str_compare, ADDR PASSWORD_BUF, ADDR LINE_PASS_BUF
jne restore_and_continue
```
- Uses Irvine library's `Str_compare` (case-sensitive)
- Both must match to authenticate
- Short-circuits on username mismatch

**Phase 5: Success/Failure Handling**

**Success Path**:
```assembly
; Display "Login successful! Welcome, "
INVOKE MSG_DISPLAY, ADDR MEMBER_SUCCESS_MSG
; Display the username
mov edx, OFFSET LINE_USER_BUF
call WriteString
; Display "."
INVOKE MSG_DISPLAY, ADDR MEMBER_SUCCESS_MSG2
JMP SHOW_MEMBER_MENU
```
- Personalized welcome message
- Redirects to member menu

**Failure Path**:
```assembly
invalid:
    INVOKE MSG_DISPLAY, ADDR INVALID_CRED_MSG
    JMP START
```
- Generic error message (security best practice)
- Returns to main menu

#### Stack Management
The procedure uses extensive stack operations:
```assembly
push ecx  ; Save line length
push edx  ; Save comma position
push edi  ; Save line pointer
```
- Critical for nested loop preservation
- Must balance pushes/pops to avoid corruption

#### Edge Cases Handled
1. **File Not Found**: Jumps to `signin_file_error`
2. **Empty File**: Treats as invalid login
3. **Missing Comma**: Skips malformed line
4. **Extra Whitespace**: Not trimmed (exact match required)

---

### 2. LIB_LOGIN - Librarian Authentication

#### Purpose
Simple hardcoded authentication for librarian access.

#### Implementation
```assembly
LIB_LOGIN:
    INVOKE MSG_DISPLAY, ADDR LIB_LOGIN_MSG
    CALL READINT
    CMP EAX, 987102
    JE LIB_LOGIN_SUCCESS
    INVOKE MSG_DISPLAY, ADDR INVALID_CODE_MSG
    JMP START

LIB_LOGIN_SUCCESS:
    INVOKE MSG_DISPLAY, ADDR LIB_SUCCESS_MSG
    JMP SHOW_FULL_MENU
```

#### Security Analysis
- **Hardcoded Password**: `987102` is in plaintext
- **No Encryption**: Code visible in binary
- **No Lockout**: Unlimited login attempts
- **No Logging**: Failed attempts not tracked

#### Improvement Suggestions
1. Store hashed code in configuration file
2. Implement attempt limiting
3. Add session timeout
4. Log all authentication attempts

---

### 3. REG_M - Member Registration

#### Purpose
Registers new members by collecting username and password, then appending to MEMBERS.txt.

#### Registration Flow

**Phase 1: Username Collection**
```assembly
INVOKE MSG_DISPLAY, ADDR REG_MSG  ; "Enter Name: "
MOV ESI, OFFSET MEMBERS
MOV EAX, MEMBER_SIZE
MUL NUM_MEMBERS
ADD ESI, EAX
MOV EDX, ESI
MOV ECX, MEMBER_SIZE
CALL READSTRING
INC NUM_MEMBERS
```
- Stores in legacy `MEMBERS` array
- Calculates offset based on `NUM_MEMBERS`
- Increments counter

**Phase 2: File Preparation**
```assembly
INVOKE CreateFile,
    ADDR MEMBERS_FILE,
    GENERIC_WRITE,
    DO_NOT_SHARE,
    NULL,
    OPEN_ALWAYS,        ; Create if doesn't exist
    FILE_ATTRIBUTE_NORMAL,
    0

; Move to end for appending
INVOKE SetFilePointer, filehandle, 0, 0, FILE_END
```
- Opens in write mode
- `OPEN_ALWAYS`: Creates file if needed
- Positions cursor at end

**Phase 3: Password Collection**
```assembly
INVOKE MSG_DISPLAY, ADDR SIGNIN_PASS_MSG
mov edx, OFFSET PASSWORD_BUF
mov ecx, 10
CALL READSTRING
```
- Max 10 characters
- No confirmation prompt (UX issue)
- No complexity requirements

**Phase 4: Data Writing**
```assembly
; Write username
mov edx, esi  ; Points to member buffer
INVOKE Str_length, edx
mov ecx, eax
mov eax, filehandle
call WriteToFile

; Write comma
mov eax, filehandle
mov edx, OFFSET COMMA_BYTE
mov ecx, 1
call WriteToFile

; Write password
mov edx, OFFSET PASSWORD_BUF
INVOKE Str_length, edx
mov ecx, eax
mov eax, filehandle
call WriteToFile

; Write CRLF
mov eax, filehandle
mov edx, OFFSET CRLF_BYTES
mov ecx, 2
call WriteToFile

invoke CloseHandle, filehandle
```

**CSV Format Written**:
```
username,password\r\n
```

#### Validation Gaps
1. **No Username Check**: Allows duplicates
2. **No Password Policy**: Any password accepted
3. **No Confirmation**: Single password entry
4. **No Email Validation**: Username format unchecked

---

### 4. VIEW_M - View Members (Legacy)

#### Purpose
Displays members from in-memory array (not file).

#### Implementation
```assembly
VIEW_M:
    INVOKE MSG_DISPLAY, ADDR VIEW_MEMBERS_MSG
    MOV ECX, NUM_MEMBERS
    cmp ECX, 0
    JE START
    
    OUTPUT:
        MOV ESI, OFFSET MEMBERS
        MOV EAX, MEMBER_SIZE
        MUL EBX
        ADD ESI, EAX
        MOV EDX, ESI
        CALL WRITESTRING
        CALL CRLF
    LOOP OUTPUT
    JMP START
```

#### Limitations
- Only shows members from current session
- Does not read MEMBERS.txt
- Limited to 6 members (array size)

---

### 5. VIEW_MFILE - View Members from File

#### Purpose
Reads and displays all registered members from MEMBERS.txt (usernames only, not passwords).

#### Process Flow

**Phase 1: File Reading**
```assembly
INVOKE CreateFile, ADDR MEMBERS_FILE, GENERIC_READ, ...
invoke ReadFile, filehandle, addr BUFFER_MEM, BUFFER_SIZE, addr bytesRead, 0
invoke CloseHandle, filehandle
```

**Phase 2: Buffer Null-Termination**
```assembly
mov eax, DWORD PTR bytesRead
lea edi, [OFFSET BUFFER_MEM]
add edi, eax
mov byte ptr [edi], 0
```

**Phase 3: Line-by-Line Parsing**
```assembly
vm_loop_file:
    lea edi, [OFFSET BUFFER_MEM + ebx]
    
    vm_find_eol_file:
        cmp al, 0Dh
        je vm_proc_line_file
```

**Phase 4: Username Extraction**
```assembly
vm_copy_name_file:
    mov al, [esi + edx]
    cmp al, ','
    je vm_name_done_file  ; Stop at comma
    mov [edi], al
    inc edi
    inc edx
```
- Copies only first field (username)
- Ignores password field (security feature)
- Stores in `TEMP_FIELD`

**Phase 5: Display**
```assembly
mov edx, OFFSET TEMP_FIELD
call WriteString
call CRLF
```

#### Security Considerations
- **Password Protection**: Passwords not displayed
- **Access Control**: Only librarians should access this

---

## CSV File Format

### MEMBERS.txt Structure
```
username1,password1
username2,password2
...
```

### Example Entries
```
alice,pass123
bob,secret456
charlie,qwerty789
```

### Format Rules
1. **Two Fields**: Username, Password
2. **Delimiter**: Single comma
3. **Line Ending**: CRLF (Windows)
4. **No Spaces**: Around delimiter
5. **Case-Sensitive**: Usernames and passwords

---

## Register Usage Summary

### MEMBER_SIGNIN
- **EBX**: Offset into `BUFFER_MEM`
- **ECX**: Line length, loop counter
- **EDX**: Comma position, display pointer
- **ESI**: Source pointer for copying
- **EDI**: Destination pointer, line start
- **ESP**: Stack management for nested loops

### REG_M
- **ESI**: Pointer to member array slot
- **EAX**: Offset calculation, file handle
- **ECX**: String length
- **EDX**: Data pointer

---

## Security Vulnerabilities

### Critical Issues
1. **Plaintext Passwords**: Stored unencrypted in MEMBERS.txt
2. **No Input Sanitization**: Commas in username break format
3. **Hardcoded Admin Code**: `987102` visible in binary
4. **No Session Management**: No timeout or token system
5. **No Audit Trail**: Failed logins not logged

### Recommendations
1. **Password Hashing**: Use SHA-256 or bcrypt
2. **Salt Storage**: Unique salt per user
3. **Input Validation**: Reject special characters
4. **Rate Limiting**: Lock account after failed attempts
5. **Session Tokens**: Generate unique session IDs

---

## Error Handling

### File Operations
- **CreateFile Failure**: Returns `INVALID_HANDLE_VALUE`
- **ReadFile Failure**: Returns 0 in `bytesRead`
- **Empty File**: Treated as invalid credentials

### Parsing Errors
- **Missing Comma**: Line skipped
- **Malformed Line**: Continues to next line
- **Buffer Overflow**: Truncates at `BUFFER_SIZE`

---

## Helper Dependencies

### Irvine32 Library
- `READSTRING`: User input
- `READINT`: Numeric input (librarian code)
- `WRITESTRING`: Display text
- `CRLF`: Newline
- `Str_compare`: String comparison
- `Str_length`: String length

### Windows API
- `CreateFile`: File operations
- `ReadFile`: Read data
- `SetFilePointer`: File cursor
- `CloseHandle`: Release handle

### Custom Helpers
- `WriteToFile`: Write data to file
- `MSG_DISPLAY`: Display message wrapper

---

## Related Files
- `data.inc`: Buffer and message definitions
- `helper.inc`: `WriteToFile` procedure
- Main menu logic for authentication routing
