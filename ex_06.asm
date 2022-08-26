; Given an array S of doublewords, build the array of bytes D formed from lower bytes of lower words, bytes multiple of 7.
; Example:
;     s: DD 1234_5607h, 1A2B_3C15h, 13A3_3412h
;     d: DB 07h, 15h

bits 32 

global start        

segment data use32 class=data
   s dd 12345607h, 1A2B3C15h, 13A33412h
   l_s equ ($-s)/4                  ; compute length of string s in doublewords
   seven db 7                       ; variable used for testing divisibility with 7
   d times l_s db 0                 ; reserve bytes for string d
   
segment code use32 class=code
    start:
        mov edi, d                  ; store into edi offset of destination string d
        mov esi, s                  ; store into esi offset of source string s
        cld                         ; parse string from left to right
        mov ecx, l_s                ; no of iterations from loop = length of source string s
        jecxz End
        Repeat:
            lodsw                   ; in AX we will have the low word of the doubleword, esi:=esi+2
            mov ah, 0               ; only keep the low byte of the low word in AL
            mov ebx, 0              ; clean registry
            mov bl, al              ; keep a copy of the byte from AL
            
            ; check wherther the byte from AL is divisible with 7
            div byte [seven] 
            cmp ah, 0               ; if remainder from AH is 0, it means it is divisible with 7
            jz multiple             ; jump zero to 'multiple'
            jmp end_if              ; jump over 'multiple' label
            multiple:
                    mov al, bl
                    stosb           ; if the byte is a multiple of 7, store it in string d + inc edi
            end_if:
            inc esi                 ; increment esi 2 times in order to go to the next doubleword
            inc esi
        Loop Repeat                 ; repeat loop until ecx = 0
        End:
        push 0    