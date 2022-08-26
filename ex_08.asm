; Two strings of bytes A and B are given. Parse the shortest string of those two and build a third string C as follows:
; up to the length of the shortest string C contains the largest element of the same rank from the two strings
; then, up to the length of the longest string C will be filled with 1 and 0, alternatively.
; Example:
; a db 4h, 28h, 16h, 18h, 6h, 8h
; b db 24h, 22h, 10h
; resulted string: c -> 24h, 28h, 16h, 01h, 00h, 01h

bits 32 

global start        

segment data use32 class=data
   a db 4h, 28h, 16h, 18h, 6h, 8h
   l_a equ $-a
   b db 24h, 22h, 10h
   l_b equ $-b
   c times l_a+l_b db 0
   
segment code use32 class=code
    start:
        mov eax, 0               ; clean registries
        mov ecx, 0
        mov edx, 0
        mov esi, 0
    
        mov eax, l_a             ; compare the lengths of the 2 strings
        cmp eax, l_b
        jb shortest              ; b- short string, a- long string
            mov ecx, l_b         ; if l_a>=l_b, no of iterations = length of b because it's shorter
            mov esi, b           ; we have to parse string b because it's shorter
            mov edx, l_a         ; edx = l_a-l_b
            sub edx, l_b         ; store in edx difference of lengths = how many 1 and 0 we have to put at the end of string c
            mov edi, c           ; load offset of new string c
            mov ebx, 0           ; index 
            
            jecxz End            ; skip if ecx=0
            cld                  ; parse string s from left to right
            repeat:
                                 ; we want to store into al the larger element 
                lodsb            ; put into a element of shorter string : al = b[esi], inc esi
                cmp al, [a+ebx]  ; compare the 2 elements if the same rank(ebx)
                jg larger1
                mov al, [a+ebx]  ; in case element of the same rank from the other string is larger, change value from al
                larger1:         ; in either case, execute label
                    stosb        ; store al into edi, inc edi the larger one
                
                inc ebx          ; increase index
            loop repeat
            End:
            jmp end_if
            
        shortest:                ; a- short string, b- long string
            mov ecx, l_a         ; no of iterations = length of a because it's shorter
            mov esi, a           ; we have to parse string b because it's shorter
            mov edx, l_b         ; edx = l_b-l_a
            sub edx, l_a         ; store in edx difference of lengths = how many 1 and 0 we have to put at the end of string c
            mov edi, c           ; load offset of new string c
            mov ebx, 0           ; index 
            
            jecxz Endloop        ; skip if ecx=0
            cld                  ; parse string s from left to right
            repeatloop:
                ; we want to store into al the larger element 
                lodsb            ; put into a element of shorter string : al = a[esi], inc esi
                cmp al, [b+ebx]  ; compare the 2 elements if the same rank(ebx)
                jg larger2
                mov al, [b+ebx]  ; in case element of the same rank from the other string is larger, change value from al
                larger2:         ; in either case, execute label
                    stosb        ; store al into edi, inc edi the larger one
                
                inc ebx          ; increase index
            loop repeatloop
            
            Endloop:
        end_if: 
        
        ;up to the length of the longest string C will be filled with 1 and 0, alternatively.
        mov ecx, edx             ; how many more 1 and 0 should we put
        mov dl, 1                ; like an ok - start with 1
        jecxz end
        alternate:
            cmp dl, 0
            je zero      
            mov al, byte 1
            mov dl, 0            ; at every iteration change value of dl
            jmp over             ; jump over
            zero:
                mov al, byte 0
                mov dl, 1
            over:
            stosb                ; store either 1 or 0 into c
        loop alternate
        
        end:
        push dword 0