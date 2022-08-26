; A byte string S is given. Obtain the string D1 which contains the elements found on the even positions of S 
; and the string D2 which contains the elements found on the odd positions of S.
; Example:
;posS: 0, 1, 2, 3, 4, 5
;   S: 1, 5, 3, 8, 2, 9
;  D1: 1, 3, 2
;  D2: 5, 8, 9

bits 32 

global start        

segment data use32 class=data
    S db '1538298'                ; declare the string S of bytes
    l_S equ $-S                   ; compute length of string S in l_S
    D1 times (l_S+1)/2 db 0       ; reserve (l_S+1)/2 bytes for destination string D1 and initialize it with 0
    D2 times (l_S+1)/2 db 0       ; reserve (l_S+1)/2 bytes for destination string D2 and initialize it with 0
    
segment code use32 class=code
    start:
        
        mov ecx, l_S              ; put length of string in ecx to make the loop
        mov esi, 0                ; inititalize with 0 the index of the string S
        mov edi, 0                ; inititalize with 0 the index of the strings D1, D2 
        jecxz End                 ; skip loop if ecx=0
        Repeat:
            mov al, [S+esi]       ; al = S[esi]
            test esi, 1           ; test parity of position in string (does esi AND 00000001b) - only keep lowest bit
                                  ; binary values are even when lowest bit=0
            
            jz even               ; jump zero to 'even' if lowest bit = 0 -> position in string is even
                mov [D2+edi], al  ; if esi is odd put element from S into D2
                inc edi           ; if esi is odd, it means we put both elements (even, odd pos) from S into D1 and D2, so
                                  ; we can move to the next set of (even, odd); this also works if length of S is odd
                jmp end_if        ; jump over 'even'
            even:
                mov [D1+edi], al  ; if esi is even put element from S into D1
            end_if:
            inc esi               ; increment index of string
        Loop Repeat               ; repeat loop until ecx = 0 (string is over)
        End:
        push dword 0