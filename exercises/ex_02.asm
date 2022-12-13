; Given the quadword A, obtain the integer number N represented on the bits 17-19 of A. Then obtain the
; doubleword B by rotating the high doubleword of A N positions to the left. Obtain the byte C as follows:
;     - the bits 0-2 of C are the same as the bits 9-11 of B
;     - the bits 3-7 of C are the same as the bits 20-24 of B

bits 32 

global start        

segment data use32 class=data
    a dq 1001_0100_0010_1101_1111_0011_1111_0110_1001_0100_0010_1101_1111_0011_1111_0110b
    n resb 1
    b resd 1
    c resb 1
    
segment code use32 class=code
    start:
        mov eax, 0               ; clean registries         
        mov ecx, 0
        
        ;obtain the integer number N represented on the bits 17-19 of A
        mov eax, dword [a]       ; isolate bits 17-19 of A (low part)in eax = 1001_0100_0010_1101_1111_0011_1111_0110b
        and eax, 0000_0000_0000_1110_0000_0000_0000_0000b         ; eax = 0000_0000_0000_1100_0000_0000_0000_0000b     
        mov cl, 17               ; 17 - 0 = 17
        ror eax, cl              ; rotate with 17 positions to the right : eax = 0000_0000_0000_0000_0000_0000_0000_0110b
        or [n], al               ; store result in n: n = 06h = 0110b
        
        ;obtain the doubleword B by rotating the high doubleword of A N positions to the left
        mov eax, 0
        mov ecx, 0
        mov eax, [a+4]           ; high part of a : eax = 1001_0100_0010_1101_1111_0011_1111_0110b
        mov cl, byte [n]
        rol eax, cl              ; rotate with 6 positions to the left
        mov [b], eax             ; save result in doubleword b = 0000_1011_0111_1100_1111_1101_1010_0101b
        
        ; byte C 
            ; the bits 0-2 of C are the same as the bits 9-11 of B
            ; the bits 3-7 of C are the same as the bits 20-24 of B
        mov eax, 0
        mov ecx, 0
        
        ; the bits 0-2 of C are the same as the bits 9-11 of B
        mov eax, dword [b]       ; isolate bits 9-11 of B in : eax = 0000_1011_0111_1100_1111_1101_1010_0101b
        and eax, 0000_0000_0000_0000_0000_1110_0000_0000b  ; eax = 0000_0000_0000_0000_0000_1100_0000_0000b
        mov cl, 9                ; 9 - 0 = 9
        ror eax, cl              ; rotate with 9 positions to the right : eax = 0000_0000_0000_0000_0000_0000_0000_0110b
        or [c], al               ; store result into c = 06h = 0110b
        
        ; the bits 3-7 of C are the same as the bits 20-24 of B
        mov eax, 0
        mov ecx, 0
        mov eax, dword [b]       ; eax = 0000_1011_0111_1100_1111_1101_1010_0101b
        and eax, 0000_0001_1111_0000_0000_0000_0000_0000b  ; eax = 0000_0001_0111_0000_0000_0000_0000_0000b
        mov cl, 17               ; 20 - 3 = 17
        ror eax, cl              ; rotate with 17 positions to the right : eax = 0000_0000_0000_0000_0000_0000_1011_1000b
        or [c], al               ; store result into c = Eh = 1110b
        push dword 0