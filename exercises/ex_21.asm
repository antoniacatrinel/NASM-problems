; Read from keyboard a file name, a special character s (besides letters and numbers) and a number n on a byte. 
; The file contains words separated by space. Write in file output.txt the words transformed in the following way: 
; the n- th character of each word is transformed into the special character.
; if the number of characters of ha word is smaller than n, prefix the word with the special character. 
; Example:
; file name : input.txt
; file content : mere pere banane mandarine
; s: +
; n: 6
; output.txt: ++mere ++pere banan+ manda+

bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

extern exit, fopen, fclose, scanf, fprintf, fread              
import exit msvcrt.dll    
import fopen msvcrt.dll
import fclose msvcrt.dll
import scanf msvcrt.dll
import fprintf msvcrt.dll
import fread msvcrt.dll

segment data use32 class=data
    file_name_input resb 30
    access_mode_input db "r", 0
    file_descriptor_input dd -1
    format_input db "%s", 0
    
    file_name_output db "output.txt", 0
    access_mode_output db "w", 0
    file_descriptor_output dd -1
    
    format_char db "%c", 0
    format_char_int db "%c %d", 0
    format_int db "%d", 0
    format_print db "%s ", 10, 0
    
    character resb 1
    s db 0
    tex1 resb 100
    n db 0
    text2 resb 100
    w resb 100
segment code use32 class=code
    start:
        ; read file name
        push dword file_name_input
        push dword format_input
        call [scanf]
        add esp, 4 * 2
        
        ; read special character
        push dword n
        push dword s
        push dword format_char_int
        call [scanf]
        add esp, 12
        
        ; opean file for reading
        push dword access_mode_input
        push dword file_name_input
        call [fopen]
        add esp, 4 * 2
        
        mov [file_descriptor_input], eax
        cmp eax, 0
        je end
        
        ; opean file for writing output
        push dword access_mode_output
        push dword file_descriptor_output
        call [fopen]
        add esp, 4 * 2
        
        mov [file_descriptor_output], eax
        cmp eax, 0
        je end
        
        ; read from file
        mov ebx, 0  ; counter for word
        
        repeat:
           pushad
           ; fread() reads len times bytes
           ; we read byte by byte
           push dword [file_descriptor_input]
           push dword 1
           push dword 1
           push dword character
           call [fread]
           add esp, 4 * 4
           
           cmp al, 0  ; end of file
           je end_loop
        
           popad
           
           mov eax, 0
           mov al, byte [character]
           cmp al, ' '
           je end_word
                  
           mov [w+ebx], al  ; form word
           inc ebx          ; ebx+1 will be length of word  
 
           jmp end_if
           
           end_word: 
               ;add ebx, 1 ; compute length of word
               
               cmp ebx, dword [n]
               jae replace
               ; prefix word with special character 2 times
               pushad
               
               push dword s
               push dword format_char
               push dword [file_descriptor_output]
               call [fprintf]
               add esp, 4 * 3
               
               cmp eax, 0
               je end_loop
               popad
               pushad
               
               push dword s
               push dword format_char
               push dword [file_descriptor_output]
               call [fprintf]
               add esp, 4 * 3
               
               cmp eax, 0
               je end_loop
               
               popad
               pushad
               ; print word as it is
               push dword w
               push dword format_print
               push dword [file_descriptor_output]
               call [fprintf]
               add esp, 4 * 3
               
               cmp eax, 0
               je end_loop
               
               popad
               
               jmp end_print  ; jump to reinitialize
               replace:
                   ; can replace
                   
                   ;replace n-th char of w with s   
                   mov ecx, ebx  ; length of word
                   mov edx, 0    ; counter for position
                   replace_char:
                        inc edx
                        cmp edx, dword [n]
                        je good_position
                        jmp continue_search
                        good_position:
                            dec edx
                            mov eax, 0
                            mov al, byte [n]
                            mov [w+edx], al
                            jmp end_replace
                        continue_search:
                        loop replace_char
                        
                   end_replace:
                   pushad
                   push dword w
                   push dword format_print
                   push dword [file_descriptor_output]
                   call [fprintf]
                   add esp, 4 * 3
                   
                   cmp eax, 0
                   je end_loop
                   popad
               
               end_print:
               mov ebx, 0   ; reinitialize word
               mov dword [w], 0
               end_if:
               jmp repeat
        
        end_loop:
        
        ; close both files
        push dword [file_descriptor_input]
        call [fclose]
        add esp, 4
        
        push dword [file_descriptor_output]
        call [fclose]
        add esp, 4
        
        end:
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
