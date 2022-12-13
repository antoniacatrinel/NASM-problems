; Read a file name and a text from the keyboard. Create a file with that name in the current folder and write the text that has been read to file.
; Observations: The file name has maximum 30 characters. The text has maximum 120 characters.

bits 32

global start        

; declare extern functions used by the program
extern exit, fprintf, fread, fopen, fclose, scanf         ; add printf and scanf as extern functions            
import exit msvcrt.dll    
import fprintf msvcrt.dll     ; tell the assembler that function printf can be found in library msvcrt.dll
import fopen msvcrt.dll      
import fclose msvcrt.dll 
import fread msvcrt.dll 
import scanf msvcrt.dll 

segment data use32 class=data
   format_read db "%s", 0
   file_name resb 30
   file_desc dd -1
   access_mode db "w", 0
   text resb 120
segment  code use32 class=code
    start:
        ; scanf(format, variable)
        push dword file_name
        push dword format_read
        call [scanf]
        add esp, 4 * 2
        
        ; call fopen() to create file
        ; eax = fopen(file_name, access_mode)
        push dword access_mode
        push dword file_name
        call [fopen]
        add esp, 4 * 2
        
        mov [file_desc], eax
        
        cmp eax, 0
        je end
        
        ; read text from keyboard
        push dword text
        push dword format_read
        call [scanf]
        add esp, 4 * 2
        
        ; print text in file
        ; fprintf(file_descriptor, text)
        push dword text
        push dword [file_desc]
        call [fprintf]
        add esp, 4 * 2
        
        ; call fclose() to close file
        ;fclose(file_desc)
        push dword [file_desc]
        call [fclose]
        add esp, 4
        
        end:
        push dword 0          ; push on stack the parameter for exit
        call [exit]           ; call exit to terminate the program
