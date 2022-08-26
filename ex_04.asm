; Two character strings S1 and S2 are given. Obtain the string D by concatenating the elements found on the positions 
; multiple of 3 from S1 and the elements of S2 in reverse order.
; Example:
; pos:  0,   1,   2,   3,   4,   5,   6,   7
;  S1: '+', '4', '2', 'a', '8', '4', 'X', '5'
;  S2: 'a', '4', '5'
;   D: '+', 'a', 'X', '5', '4', 'a'

bits 32 

global start        

segment data use32 class=data
    s1 db '+42a84X5'           ; declare and inititalize string s1 of bytes
    l_s1 equ $-s1              ; declare and inititalize length of s1 
    s2 db 'a45'                ; declare and inititalize string s2 of bytes
    l_s2 equ $-s2              ; declare and inititalize length of s2
    D times l_s2 + l_s1 db 0   ; declare and inititalize string d of bytes
    
segment code use32 class=code
    start:
 
        mov ecx, l_s1/3+1      ; put nr of iterations in ECX to make the loop=nr of positions multiple of 3: l_s1/3 +1(always with 0)
        mov esi, 0             ; inititalize with 0 the index of the string s1
        mov edi, 0             ; inititalize with 0 the index of the string D 
        jecxz End              ; skip loop if ecx=0
        Repeat:
            mov al, [s1+esi]    ; al = s1[esi]
            mov [D+edi], al     ; D[edi] = al
            inc edi             ; increment index of D
            inc esi             ; increment index of S1 3 times in order to obtain positions multiple of 3
            inc esi
            inc esi
        Loop Repeat             ; repeat loop until ecx = 0 (string s1 is over)
        End:
        
        ;elements of S2 in reverse order in D
        mov ecx, l_s2           ; put length of string s2 in ECX to make the loop
        mov esi, l_s2-1         ; inititalize with value of last position the index of the string s2
        jecxz EndFor            ; skip loop if ecx=0
        Repeatt:
            mov al, [s2+esi]    ; al = s2[esi]
            mov [D+edi], al     ; D[edi] = al
            inc edi             ; increment index of D
            dec esi             ; decrement index of S2 
        Loop Repeatt            ; repeat loop until ecx = 0 (string s2 is over)
        EndFor:
            
        push dword 0