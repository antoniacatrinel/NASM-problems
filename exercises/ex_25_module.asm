bits 32

import printf msvcrt.dll
extern printf

segment data use32 class=data
    result resd 10
    format_print db "%s",0
segment code use32 public code

global reverse
reverse:
    ; STACK:
    ;-------------------
    ; return address    - esp
    ;-------------------
    ; length of string  - esp + 4
    ;-------------------
    ; initial word      - esp + 8
    ;-------------------
    mov esi, [esp+8]        ; offset of initial word
    mov ecx, [esp+4]        ; no of iterations=length of current word
    mov edi, result         ; offset of new word
    add edi, ecx            ; we should put characters in reverse, so start from right to left: edi = result + length -1
    dec edi
    repeat:
        cld
        lodsb          ; mov al,[esi] + inc esi
        std
        stosb          ; mov [edi], al + dec esi
        loop repeat
    
    ; print new word
    push dword result
    push dword format_print
    call [printf]
    add esp, 4*2
    ret