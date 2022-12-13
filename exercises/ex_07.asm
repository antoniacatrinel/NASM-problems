; Given an array S of doublewords, build the array of bytes D formed from bytes of doublewords sorted as unsigned numbers in ascending order.
; Example:
;  s DD 1234_5607h, 1A2B_3C15h
;  d DB 07h, 12h, 15h, 1Ah, 2Bh, 34h, 3Ch, 56h

bits 32 

global start        

segment data use32 class=data
   s dd 12345607h, 1A2B3C15h
   l_s equ ($-s)/4             ; compute length of string s in doublewords
   d times l_s*4 db -1         ; declare and initialize destination string
   
segment code use32 class=code
    start:
        
        ; move all bytes of the doublewords from s to d
        mov ecx, l_s             ; store length of s = number of iterations of the loop
        mov esi, s               ; load offset of source string s into esi
        mov edi, d               ; load offset of destination string d into edi
        jecxz End                ; skip if ecx=0
        cld                      ; parse string s from left to right
        repeat:                  ; for each dword in s
            ; store low word
            lodsw                ; ax = the low word of the current doubleword from the string, esi=esi+2
            stosb                ; store in <es:edi> low byte of word, edi= edi+1
            mov al, ah
            stosb                ; store in <es:edi> high byte of word, edi= edi+1
            
            ; store high word
            lodsw                ; ax = the high word of the current doubleword from the string, esi=esi+2
            stosb                ; store in <es:edi> low byte of word, edi= edi+1
            mov al, ah           ; only keep high part
            stosb                ; store in <es:edi> high byte of word, edi= edi+1
        loop repeat
        End: 
        
        ; now I sorted string d in ascending order using bubblesort principle
        mov bx, 1                ; bx is like ok, takes value 1 if I need to repeat the loop (string not sorted yet) 
                                 ; and 0 if all elements of the string are sorted
        repeat_while:           
            cmp bx, 0            ; check whether loop is over or not and 
            je end_while         ; if bx=0 jump to end of the loop
            mov esi, d           ; load offset of string d into esi
            mov bx, 0            
            mov ecx, l_s*4-1     ; store (length of d)-1 = number of iterations of the loop
            
            repeat_for:          ; parse through string d 
                lodsb            ; load into al next element( the element I want to compare with) + esi=esi+2
                lodsb            ; al = [esi+1]
                sub esi, 2       ; dec esi in order to come back to current element
                
                cmp al, [esi]    ; compare the 2 consecutive elements of the string :cmp [esi+1], [esi]
                jg good          ; if the next element is > current element order is good
                mov dl, [esi]    ; swap elements [esi+1], [esi] if they are not in correct order
                mov [esi], al
                mov [esi+1], dl
                mov bx, 1        ; bx= 1 because we did a swap, so string is not sorted yet
                
                good:
                inc esi          ; go to next element
            loop repeat_for
            
        jmp repeat_while       
        end_while:
        push 0