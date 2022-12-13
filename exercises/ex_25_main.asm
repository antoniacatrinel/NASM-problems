; Read a sentence from the keyboard. For each word, obtain a new one by taking the letters in reverse order and print each new word.  

bits 32

global start

import scanf msvcrt.dll
import exit msvcrt.dll
extern scanf, exit

extern reverse

segment data use32
    s_char resb 1
    format_s db "%c", 0
    new_word times 50 db 0
    format_word db "%s", 0
    l_word db 0
    inverse times 10 dd ''
segment code use32 public code
start:
    mov edi, new_word                ; move into edi off set of new word
    cld
    read_words:
        read_chars:
            push dword s_char         ; read current character 
            push dword format_s
            call [scanf]
            add esp, 4*2  
            
            mov eax, 0
            mov al, byte [s_char]
            cmp al, ' '   
            je next_word              ; if current character is equal to ascii(' ') then start a new word
            
            ; if character is not space
            cmp al, '.'    ; first check if character is .
            je end_sentence           ; sentence is over, get out of loop
            
            ; if character is not . and space, it means it is a letter so we can form the word
            
            stosb                     ; form word
            add [l_word], byte 1      ; increase length
            jmp read_chars
            next_word:
                push dword new_word
                mov eax, dword [l_word]
                push eax
                call reverse
                add esp, 4*2                 ; 2 dwords remained on stack and we have to clean them
                
                mov edi, new_word                 ; reinitialize index of word
                mov [l_word], byte 0              ; reinitialize length
                jmp read_words
            
    end_sentence:       
	push dword 0
	call [exit]