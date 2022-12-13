; Given 4 bytes, compute in AX the sum of the integers represented by the bits 4-6 of the 4 bytes.

bits 32 

global start        

segment data use32 class=data
   a db 0111_0111b
   b db 0101_0111b
   c db 1001_1011b
   d db 1011_1110b

segment code use32 class=code
    start:
        ;get bits 4-6 of byte a
        mov eax, 0           ; clean registries and compute result into bl
        mov ebx, 0 
        mov ecx, 0
        mov edx, 0 
        
        mov dl, byte [a]     ; isolate bits 4-6 of a in dl : dl = 0111_0111b
        and dl, 0111_0000b   ; dl = (0111_0111b and 0111_0000b) = 0111_0000b
        mov cl, 4            ; 4 - 0 = 4
        ror dl, cl           ; rotate with 4 positions to the right
        or bl, dl            ; put the bits into result : BL = 07h
        
        ;add the integer represented by the bits 4-6 of a to sum in AX
        mov al, bl           ; AL = 07h
        
        ;get bits 4-6 of byte b 
        mov ebx, 0           ; clean registries and compute result into bl
        mov ecx, 0
        mov edx, 0
        
        mov dl, byte [b]     ; isolate bits 4-6 of b in dl : dl = 0101_0111b
        and dl, 0111_0000b   ; dl = (0101_0111b and 0111_0000b) = 0101_0000b
        mov cl, 4            ; 4 - 0 = 4
        ror dl, cl           ; rotate with 4 positions to the right
        or bl, dl            ; put the bits into result : BL = 05h
        
        ;add the integer represented by the bits 4-6 of b to sum
        add al, bl           ; AL = 07h + 05h = 0Ch
        adc ah, 0            ; add the carry in case there is one
        
        ;get bits 4-6 of byte c
        mov ebx, 0           ; clean registries and compute result into bl
        mov ecx, 0
        mov edx, 0
        
        mov dl, byte [c]     ; isolate bits 4-6 of c in dl : dl = 1001_1011b
        and dl, 0111_0000b   ; dl = (1001_1011b and 0111_0000b) = 0001_0000b
        mov cl, 4            ; 4 - 0 = 4
        ror dl, cl           ; rotate with 4 positions to the right
        or bl, dl            ; put the bits into result : BL = 01h
        
        ;add the integer represented by the bits 4-6 of c to sum
        add al, bl           ; AL = 0Ch + 01h = 0Dh
        adc ah, 0            ; add the carry in case there is one
        
        ;get bits 4-6 of byte d
        mov ebx, 0           ; clean registries and compute result into bl
        mov ecx, 0
        mov edx, 0
      
        mov dl, byte [d]     ; isolate bits 4-6 of c in dl : dl = 1011_1110b
        and dl, 0111_0000b   ; dl = (1011_1110b and 0111_0000b) = 0011_0000b
        mov cl, 4            ; 4 - 0 = 4
        ror dl, cl           ; rotate with 4 positions to the right
        or bl, dl            ; put the bits into result : BL = 03h
        
        ;add the integer represented by the bits 4-6 of d to sum
        add al, bl           ; AL = 0Dh + 03h = 10h
        adc ah, 0
        push dword 0
        
        
        
        
        