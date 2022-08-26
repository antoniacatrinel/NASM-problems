; A text file is given. The text file contains numbers (in base 10) separated by spaces. 
; Read the content of the file, determine the maximum number (from the numbers that have been read) and write the result at the end of file.

bits 32
global start        

; declare extern functions used by the program
extern exit, fopen, fclose, fprintf, fread, printf      
import exit msvcrt.dll    
import fopen msvcrt.dll  
import fread msvcrt.dll   
import fclose msvcrt.dll    
import fprintf msvcrt.dll 
import printf msvcrt.dll 

segment data use32 class=data
    file_name db "ex_19_input.txt", 0   ; filename to be read
    access_mode db "r+", 0          ; file access mode: opens a file for reading and writing. The file must exist.
    file_descriptor dd -1           ; variable to hold the file descriptor
    len equ 100                     ; maximum number of characters to be read
    text times (len+1) db 0         ; string to hold the text which is read from file
    format db " The maximum number read from the file is %d.", 0
    max dw 0
    number dw 0
    copy_ecx db 0
segment  code use32 class=code
    start:
        ; call fopen() to create/ open file
        ; eax = fopen(file_name, access_mode)
        push dword access_mode
        push dword file_name
        call [fopen]
        add esp, 4 * 2               ; clean-up the stack
        
        mov [file_descriptor], eax   ; store file descriptor returned by fopen
        
        ; check if the file was successfuly created/ opened (eax !=0)
        cmp eax, 0
        je end
        
        ; call fread() to read text from file
        ; eax = fread(text, 1, len, file_descriptor)  in eax=no of characters read
        push dword [file_descriptor]
        push dword len
        push dword 1
        push dword text
        call [fread]
        add esp, 4 * 4
        
        mov esi, text                ; we store the offset of the text in esi 
        mov ecx, eax                 ; we store the length of the text in ecx
        inc ecx                      ; in order to come back to last element
        cld                          ; parse string text from left to right
        
        mov ebx, 0                   ; ebx = no of digits of each number
        repeat:         
            lodsb                    ; al = current byte from text ; esi = esi+1
            
            cmp al, ' '              ; compare the ascii code of al to the ascii code of space       
            je skip                  ; if ascii(al) = ascii(' '), it's not a digit, so we jump to the label skip
            inc ebx
            jmp end_if
            skip:   
                mov [copy_ecx], ecx   
                mov ecx, ebx         ; no of iterations of loop = no of digits of number
                sub esi, 2           ; come back to last digit
                mov eax, 0
                mov al, [esi]        ; put digit in al
                sub al, '0'          ; al is a digit, so we substract the value of '0', which is 48, to now have in al a value between [0,9]
                add [number], al
                mov edx, 0
                mov eax, 0
                dec esi
                dec ecx
                mov dl, 10
                jecxz end_construct  ; skip if ecx = 0
                construct_number:
                    mov al, [esi]    ; put digit in l
                    sub al, '0'      ; al is a digit, so we substract the value of '0', which is 48, to now have in al a value between [0,9]
                    mul dl
                    add [number], ax
                    mov al, dl
                    mov dl, 10
                    mul dl
                    mov dx, ax
                    dec esi
                loop construct_number   
                end_construct:
                mov eax, 0
                mov ax, [number]
                cmp [max], ax       ; compare current number with maximum till then
                jae not_max
                mov [max], ax
                not_max:
                mov [number], word 0 ; reset number
                add esi, ebx     
                add esi, 2          ; come back to next number
                mov ecx, [copy_ecx] ; come back to main loop
                mov ebx, 0          ; start new number
            end_if:
            loop repeat             ; we loop again
        
        ; append the text to file using fprintf()
        ; fprintf(file_descriptor, max)
        push dword [max]
        push dword format
        push dword [file_descriptor]
        call [fprintf]
        add esp, 4 * 2
        
        ; call fclose() to close the file
        ; fclose(file_descriptor)
        push dword [file_descriptor]
        call [fclose]
        add esp, 4 * 1
        
        end:
        push dword 0              ; push on stack the parameter for exit
        call [exit]               ; call exit to terminate the program