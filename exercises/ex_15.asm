; A text file is given. Read the content of the file, determine the lowercase letter with the highest frequency and display the letter along with its frequency on the screen. 
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
    file_name db "ex_15_input.txt", 0
    access_mode db "r", 0
    format db "Letter %c, frequency %d", 13, 0
    file_desc dd -1
    len equ 100
    text times (len+1) db 0
    text_len resb 1
    frequency times 10 db 0
    letter dd 0
    letter_frq dd 0
    
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
        
        mov [text_len], eax     ; make a copy of length
        mov esi, text
        mov edi, frequency
        cld
        mov ebx, 0
        mov edx, 0 
        mov ecx, eax   ; number of chars we read
        repeat:
            mov eax, 0
            lodsb
            ; check if it's lowercase letter
            cmp al, 'a'
            jb not_lower
            
            cmp al, 'z'
            ja not_lower
            
            sub al, 'a' ; obtain digit from ascii(al) - ascii(a)
            
            add [edi+eax], byte 1  ; increase frequency
            
            not_lower:
        loop repeat
            
        ; go through frequency string on positions 0 to 9
        mov ecx, 10
        mov ebx, 0
        get_max:
            mov eax, 0
            mov al, [frequency+ebx]
            cmp al, byte [letter_frq]
            ja new_max
            jmp end_if
            new_max:
                mov [letter], bl
                add [letter], byte 'a'
                mov [letter_frq], al
            end_if:
            inc ebx
        loop get_max
        
        ; display the result on screen
        ; printf(format, digit, digit_frq)
        push dword [letter_frq]       ; frequency
        push dword [letter]           ; letter
        push dword format
        call [printf]
        add esp, 4 * 3
        
        ; call fclose() to close the file
        ; fclose(file_descriptor)
        push dword [file_desc]
        call [fclose]
        add esp, 4
        
        end:
        push dword 0          ; push on stack the parameter for exit
        call [exit]           ; call exit to terminate the program
