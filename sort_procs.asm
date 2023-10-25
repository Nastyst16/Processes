; Copyright 2023 Nastase Cristian-Gabriel 315CA
%include "../include/io.mac"

struc proc
    .pid: resw 1
    .prio: resb 1
    .time: resw 1
endstruc

; initializes a x variable
section .data
ok:
    dd 0
i:
    dd 0
aux:
    dd 0

section .text
    global sort_procs
    extern printf

sort_procs:
    ;; DO NOT MODIFY
    enter 0,0
    pusha

    mov edx, [ebp + 8]      ; processes
    mov eax, [ebp + 12]     ; length
    ;; DO NOT MODIFY

    ;; Your code starts here

    mov ecx, eax;
    sub ecx, 1;

    moving_trough_vector:
    ; do
        ; ok = 0;
        mov eax, 0
        mov [ok], eax
        ; //

        ; i = 0
        mov eax, 0
        mov [i], eax
        for:
        ; for (i = 0; i < ecx - 1; i++) {
            ; verifying the for condition
            mov eax, [i]
            cmp eax, ecx
            jg endfor
            ; //

            ; "for" content {
                push ecx
                mov ecx, [i]

                ; ecx = i * sizeof(proc), when [edx + ecx], it means "proc[i]" {
                xor eax, eax
                mov eax, ecx
                imul eax, 5
                mov ecx, eax
                ; }

                ; if (proc[i].prio > proc[i+1].prio) {  (if 1)

                    ; "if" condition check
                        xor eax, eax
                        mov al, BYTE [edx + ecx + 2]
                        mov ah, BYTE [edx + ecx + 7]
                        cmp ah, al
                        je not_if_1
                        jg not_if_1
                    ; end condition check

                    ; swap(proc[i], proc[i+1]);

                    call swap

                    ; ok = 1;
                    mov eax, 1
                    mov [ok], eax
                    ; //

                    ; end swap

                ; end (if 1)
                not_if_1:

                ; if (s[i].prio == s[i+1].prio &&
                ;     s[i].time > s[i+1].time) {   (if 2)

                    ; if condition check
                        xor eax, eax
                        mov al, BYTE [edx + ecx + 2]
                        mov ah, BYTE [edx + ecx + 7]
                        cmp ah, al
                        jne failed_if_check

                        xor eax, eax
                        xor ebx, ebx
                        mov ax, WORD [edx + ecx + 3]
                        mov bx, WORD [edx + ecx + 8]
                        cmp eax, ebx
                        je not_if_2
                        jl not_if_2
                    ; end condition check

                    call swap

                    ; ok = 1;
                    mov eax, 1
                    mov [ok], eax
                    ; //


                ; } end (if 2)
                not_if_2:


                ; if (s[i].prio == s[i+1].prio &&
                ;     s[i].time == s[i+1].time &&
                ;     s[i].pid > s[i+1].pid) {   (if 3)

                    ; if condition check
                        xor eax, eax
                        mov al, BYTE [edx + ecx + 2]
                        mov ah, BYTE [edx + ecx + 7]
                        cmp ah, al
                        jne failed_if_check

                        xor eax, eax
                        xor ebx, ebx
                        mov ax, WORD [edx + ecx + 3]
                        mov bx, WORD [edx + ecx + 8]
                        cmp eax, ebx
                        jne failed_if_check

                        xor eax, eax
                        xor ebx, ebx
                        mov ax, WORD [edx + ecx]
                        mov bx, WORD [edx + ecx + 5]
                        cmp eax, ebx
                        je failed_if_check
                        jl not_if_3
                    ; end condition check

                    call swap

                    ; ok = 1;
                    mov eax, 1
                    mov [ok], eax
                    ; //

                ; end (if 3)
                not_if_3:

            failed_if_check:

            pop ecx
            mov eax, [i]

            ; i++;
            inc eax
            mov [i], eax

            ; verifying the for condition
            mov eax, [i]
            cmp eax, ecx
            jl for
            ;
        ; }
        endfor:

        ; if while condition does not verify
        mov eax, 1
        cmp [ok], eax
        je moving_trough_vector
        ; we jump to the beginning of "while"

    ; while (ok == 1)
    end_moving_trough_vector:

    jmp end ; jumping over swap
    swap:
        mov eax, [edx + ecx] ; eax = prio[i];
        mov ebx, [edx + ecx + proc_size] ; ebx = prio[i+1]
        mov [edx + ecx], ebx ; prio[i] = prio[i+1]
        mov [edx + ecx + proc_size], eax ; prio[i+1] = prio[i]
        ret

    end:

    ;; Your code ends here

    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY


;     a) sort_procs
;         For a easier implementation i wrote the solution in C,
;     and guided myself with this code:
;
;     do {
;         ok = 0;
;         for (int i = 0; i < n - 1; i++) {
;             if (s[i].prio > s[i+1].prio) {
;                 aux = s[i];
;                 s[i] = s[i+1];
;                 s[i+1] = aux;
;                 ok = 1;
;             }

;             if (s[i].prio == s[i+1].prio &&
;                 s[i].time > s[i+1].time) {
;                 aux = s[i];
;                 s[i] = s[i+1];
;                 s[i+1] = aux;
;                 ok = 1;
;             }

;             if (s[i].prio == s[i+1].prio &&
;                 s[i].time == s[i+1].time &&
;                 s[i].pid > s[i+1].pid) {
;                 aux = s[i];
;                 s[i] = s[i+1];
;                 s[i+1] = aux;
;                 ok = 1;
;             }
;         }
;     } while (ok);
;
;         I went through this code line by line and
;     tried to implement in asm as well as I could.