; A file is given. Replace all lowercase letters with their ascii code and write the content to another file.

bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, fopen, fread, fprintf, fclose              ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll                                  ; exit is a function that ends the calling process. It is defined in msvcrt.dll
import fopen msvcrt.dll 
import fread msvcrt.dll 
import fprintf msvcrt.dll 
import fclose msvcrt.dll 

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    file_name_input db "ex_22_input.txt", 0
    file_name_output db "ex_22_output.txt", 0
    access_mode_input db "r", 0
    access_mode_output db "w", 0
    file_descriptor_input dd -1
    file_descriptor_output dd -1
    character resb 1
    text times 100 db 0
    letter_format db "%c", 0
    ascii_format db "%d", 0
    
; our code starts here
segment code use32 class=code
    start:
        push dword access_mode_input
        push dword file_name_input
        call [fopen]
        add esp, 4 * 2
        
        mov [file_descriptor_input], eax
        
        cmp eax, 0
        je end
        
        push dword access_mode_output
        push dword file_name_output
        call [fopen]
        add esp, 4 * 2
        
        mov [file_descriptor_output], eax
        
        cmp eax, 0
        je end
        
        ; read from fie
        repeat:
            push dword [file_descriptor_input]
            push dword 1
            push dword 1
            push dword character
            call [fread]
            add esp, 4 * 4
            
            cmp eax, 0
            je end_read
            
            cmp byte [character], 'a'
            jb not_letter
            
            cmp byte [character], 'z'
            ja not_letter
            
            ; print to output file ascii code
            push dword [character]
            push dword ascii_format
            push dword [file_descriptor_output]
            call [fprintf]
            add esp, 4 * 3
            
            jmp end_print
            not_letter:
                push dword [character]
                push dword letter_format
                push dword [file_descriptor_output]
                call [fprintf]
                add esp, 4 * 3
                
            end_print:
            jmp repeat
        
        end_read:
        push dword [file_descriptor_input]
        call [fclose]
        add esp, 4
        
        push dword [file_descriptor_output]
        call [fclose]
        add esp, 4
        
        end:
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
