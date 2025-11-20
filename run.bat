@echo off
set masm_path=C:\masm32\bin
set irvine_path=C:\Irvine


%masm_path%\ml /c /coff /I "%irvine_path%" SourceCode.asm
if errorlevel 1 goto :error

%masm_path%\link /SUBSYSTEM:CONSOLE SourceCode.obj /LIBPATH:"%irvine_path%" Irvine32.lib kernel32.lib user32.lib
if errorlevel 1 goto :error

if not exist build mkdir build
move SourceCode.obj build >nul 2>&1
move SourceCode.exe build >nul 2>&1

echo.
build\SourceCode.exe
pause
goto :eof

:error
echo.
echo *** Build failed! Check errors above. ***
pause