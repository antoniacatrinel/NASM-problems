; An array of doublewords, where each doubleword contains 2 values on a word (unpacked, so each nibble is preceded by a 0) 
; is given. Write an asm program to create a new array of bytes which contain those values (packed on a single byte), 
; arranged in an ascending manner in memory, these being considered signed numbers. 
; Example:
; initial array: 0702090Ah, 0B0C0304h, 05060108h  
; result: 72h, 9Ah, 0BCh, 34h, 56h, 18h 
; result in arranged manner: 9Ah, 0BCh, 18h, 34h, 56h, 72h

bits 32

global start        

extern exit
import exit msvcrt.dll

segment data use32 class=data
    s dd 0702090Ah, 0B0C0304h, 05060108h       ; declare and initialize initial string
    len equ ($ - s)/4                           ; declare and initialize length of initial string
    res resb len * 2                            ; reserve space of resulted string

segment code use32 class=code
    start:
        mov esi, 0                             ; clean registries
        mov edi, 0
        mov ecx, 0 
        
        mov esi, s                             ; store initial string into esi
        mov edi, res                           ; store resulted string into edi
        mov ecx, len                           ; store length of initial string into ecx
        cld                                    ; DF=0
        
        ; compute the array
        compute:
            lodsd                              ; eax = dword from <ds:esi>, esi:=esi+4
            
            rol eax, 16                        ; rotate with 16 positions to the left
            mov bl, ah
            shl bl, 4                          ; shift with 4 positions to the left
            add al, bl
            
            stosb                              ; al = byte from <es:edi>, inc edi
            
            rol eax, 16                        ; rotate with 16 positions to the left
            mov bl, ah
            shl bl, 4                          ; shift with 4 positions to the left
            add al, bl
            
            stosb                              ; al = byte from <es:edi>, inc edi
            
            loop compute
            
        ; sort the resulted array using bubble sort
        mov edx, 0                             ; clean registries
        mov ecx, 0
        mov dx, 1                              ; variable used for checking end of sorting
        
        loop1:
            cmp dx, 0
            je done
            
            mov esi, res                       ; store string into esi
            mov ecx, len * 2 - 1               ; store length of string into ecx
            mov dx, 0
            cld                                ; DF=0
            
            loop2:
                mov al, [esi]                  ; compare consecutive elements
                cmp al, [esi + 1]
                jle ordered
                    mov ah, [esi + 1]
                    mov [esi], ah
                    mov [esi + 1], al
                    mov dx, 1
                    
                ordered:
                inc esi                         ; go through string
                loop loop2
                jmp loop1

        done:
        push dword 0      ; push the parameter for exit onto the stack
        call [exit]       ; call exit to terminate the program
