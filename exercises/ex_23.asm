; Read grades from a given file and compute the sum and the difference of all grades and print them at the end of the file.

bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, fopen, fclose, fread, fprintf              ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    
import fopen msvcrt.dll
import fclose msvcrt.dll
import fread msvcrt.dll
import fprintf msvcrt.dll
; our data is declared here (the variables needed by our program)
segment data use32 class=data
    file_name db "ex_23_input.txt", 0
    access_mode db "a+", 0
    file_descriptor dd -1
    format db "%d", 0
    format_print db " %i", 0
    character resb 1
    grade resb 1
    sum dd 0
    diff dd 0
; our code starts here
segment code use32 class=code

    start:
        push dword access_mode
        push dword file_name
        call [fopen]
        add esp, 4 * 2
        
        mov [file_descriptor], eax
        
        cmp eax, 0
        je end
        
        mov edx, 0 ; counter for constructing numbers
        ; read from file
        repeat_read:
            pushad
            push dword [file_descriptor]
            push dword 1
            push dword 1
            push dword character
            call [fread]
            add esp, 4 * 4
            
            cmp al, 0
            je end_read
            
            popad
            mov eax, 0
            mov al, byte [character]
            cmp al, ' '
            
            je space
            mov [grade], al
            add edx, 1
            
            jmp end_if
            space:
                cmp edx, 1
                je one_digit
                add [sum], byte 10 ; if it hasnt 1 digit can only be 10
                jmp over
                one_digit:
                    mov eax, 0
                    mov al, byte [grade]
                    sub al, '0'
                    add [sum], al
                over:
                mov edx, 0
            end_if:
            
            jmp repeat_read
        end_read:
        
        mov eax, 0
        mov al, [sum]
        neg al
        mov [diff], al
        
        push dword [sum]
        push dword format_print
        push dword [file_descriptor]
        call [fprintf]
        add esp, 4 * 3
        
        push dword [diff]
        push dword format_print
        push dword [file_descriptor]
        call [fprintf]
        add esp, 4 * 3
        
        push dword [file_descriptor]
        call [fclose]
        add esp, 4
        
        end:
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
