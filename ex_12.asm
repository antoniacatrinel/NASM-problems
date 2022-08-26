 ; A text file is given. Read the content of the file, count the number of odd digits and display the result on the screen. 
 ; The name of text file is defined in the data segment.

bits 32
global start        

; declare extern functions used by the program
extern exit, printf, fread, fopen, fclose         ; add printf and scanf as extern functions            
import exit msvcrt.dll    
import printf msvcrt.dll                          ; tell the assembler that function printf can be found in library msvcrt.dll
import fopen msvcrt.dll      
import fclose msvcrt.dll 
import fread msvcrt.dll 

segment data use32 class=data
    file_name db "ex_12_input.txt", 0
    access_mode db "r", 0
    file_desc dd -1
    len equ 100
    text times (len+1) db 0
    format db "We read %d odd digits", 0
segment  code use32 class=code
    start:
        ; call fopen() to create the file
        ; fopen() will return a file descriptor in the EAX or 0 in case of error
        ; eax = fopen(file_name, access_mode)
        push dword access_mode
        push dword file_name
        call [fopen]
        add esp, 4 * 2
        
        mov [file_desc], eax
        
        cmp eax, 0
        je end
        ; read the text from file using fread()
        ; after the fread() call, EAX will contain the number of chars we've read 
        ; eax = fread(text, byte = 1, len, file_descriptor)
        push dword [file_desc]
        push dword len
        push dword 1
        push dword text
        call [fread]
        add esp, 4 * 4
        
        mov esi, text
        cld
        mov edx, 0 ; number of odd digits
        mov ecx, eax   ; number of chars we read
        mov eax, 0
        repeat:
            lodsb
            cmp al, '0'
            jb not_digit
            cmp al, '9'
            ja not_digit
            
            test al, 1
            jz even
            inc edx
            even:
            not_digit:
            loop repeat
        
        ; display the result on screen
        ; printf(format, edx, message)
        push dword edx
        push dword format
        call [printf]
        add esp, 4 * 2
        
        ; call fclose() to close the file
        ; fclose(file_descriptor)
        push dword [file_desc]
        call [fclose]
        add esp, 4
        
        end:
        push dword 0          ; push on stack the parameter for exit
        call [exit]           ; call exit to terminate the program
