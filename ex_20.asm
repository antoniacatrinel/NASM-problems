; Read two numbers a and b (in base 16) from the keyboard and calculate a+b. Display the result in base 10.

bits 32
global start        

; declare extern functions used by the program
extern exit, printf, scanf     ; add printf and scanf as extern functions            
import exit msvcrt.dll    
import printf msvcrt.dll       ; tell the assembler that function printf can be found in library msvcrt.dll
import scanf msvcrt.dll        ; similar for scanf

segment data use32 class=data
    a db 0
    b db 0
    message1 db "a=", 0
    message2 db "b=", 0
    format db "%x", 0
    format_out db "Sum of a and b in base 10 is: %d", 0
    
segment  code use32 class=code
    start:
        mov ebx, 0            ; compute the sum in ebx
        push dword message1   ; push message "a="
        call [printf]         ; call function printf for printing
        add esp, 4 * 1        ; clean-up the stack; 4 = size of dword; 1 = number of parameters
        
        push dword a          ; read a from keyboard
        push dword format     ; push format (integer in base 16)
        call [scanf]          ; call function scanf for reading
        mov ebx, [a]          ; store value of a in ebx
        add esp, 4 * 2        ; clean-up the stack
        
        push dword message2   ; push message "b="
        call [printf]         ; call function printf for printing
        add esp, 4 * 1        ; clean-up the stack
        
        push dword b          ; read b from keyboard
        push dword format     ; push format (integer in base 16)
        call [scanf]          ; call function scanf for reading
        add ebx, [b]          ; ebx=a+b
        add esp, 4 * 2        ; clean-up the stack
        
        push dword ebx        ; push sum on the stack
        push dword format_out ; push format (integer in base 10)
        call [printf]         ; call function printf for printing 
        add esp, 4 * 2        ; clean-up the stack
        
        push dword 0          ; push on stack the parameter for exit
        call [exit]           ; call exit to terminate the program