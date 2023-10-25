; Copyright 2023 Nastase Cristian-Gabriel 315CA
%include "../include/io.mac"

struc avg   ; avg struct declaration
    .quo: resw 1
    .remain: resw 1

struc proc
    .pid: resw 1
    .prio: resb 1
    .time: resw 1
endstruc

    ;; Hint: you can use these global arrays
section .data
    prio_result dd 0, 0, 0, 0, 0
    time_result dd 0, 0, 0, 0, 0

i:  ; 'for' contor
    dd 0

section .text
    global run_procs

run_procs:
    ;; DO NOT MODIFY

    push ebp
    mov ebp, esp
    pusha

    xor ecx, ecx

clean_results:
    mov dword [time_result + 4 * ecx], dword 0
    mov dword [prio_result + 4 * ecx],  0

    inc ecx
    cmp ecx, 5
    jne clean_results

    mov ecx, [ebp + 8]      ; processes
    mov ebx, [ebp + 12]     ; length
    mov edx, [ebp + 16]     ; proc_avg
    ;; DO NOT MODIFY

    ;; Your code starts here

    xor eax, eax
    mov [i], eax

    for_1:  ; for (i = 0; i < lenght; i++) {

    ; 'for' condition
    mov eax, [i]
    cmp eax, ebx
    jg endfor_1

        push ebx
        mov ebx, [i]

        xor eax, eax
        mov eax, ebx
        imul eax, 5
        mov ebx, eax
        ; we store: ebx = i * sizeof(proc)


        xor eax, eax
        ; if (proc->prio == 1) (if 1)
            mov al, [ecx + ebx + 2]
            cmp al, 1
            jne not_equal_with_1

            ; if (proc->prio == 1) {
                xor eax, eax
                mov ax, WORD [ecx + ebx + 3]
                add WORD [edx + 0], ax
                add WORD [edx + 2], 1
            ; }

        ; end (if 1)

        not_equal_with_1:
        xor eax, eax
        ; if (proc->prio == 2) (if 2)
            mov al, [ecx + ebx + 2]
            cmp al, 2
            jne not_equal_with_2
            ; if (proc->prio == 2) {
                xor eax, eax
                mov ax, WORD [ecx + ebx + 3]
                add WORD [edx + 4], ax
                add WORD [edx + 6], 1
            ; }

        ; end (if 2)
        not_equal_with_2:

        xor eax, eax
        ; if (proc->prio == 3) (if 3)
            mov al, [ecx + ebx + 2]
            cmp al, 3
            jne not_equal_with_3
            ; if (proc->prio == 3) {
                xor eax, eax
                mov ax, WORD [ecx + ebx + 3]
                add WORD [edx + 8], ax
                add WORD [edx + 10], 1
            ; }

        ; end (if 3)
        not_equal_with_3:

        xor eax, eax
        ; if (proc->prio == 4) (if 4)
            mov al, [ecx + ebx + 2]
            cmp al, 4
            jne not_equal_with_4
            ; if (proc->prio == 4) {
                xor eax, eax
                mov ax, WORD [ecx + ebx + 3]
                add WORD [edx + 12], ax
                add WORD [edx + 14], 1
            ; }

        ; end (if 4)
        not_equal_with_4:

        xor eax, eax
        ; if (proc->prio == 5) (if 5)

            mov al, [ecx + ebx + 2]
            cmp al, 5
            jne not_equal_with_5
            ; if (proc->prio == 5) {
                xor eax, eax
                mov ax, WORD [ecx + ebx + 3]
                add WORD [edx + 16], ax
                add WORD [edx + 18], 1
            ; }

        ; end (if 5)
        not_equal_with_5:



        ; incrementarea lui i
        pop ebx

        mov eax, [i]
        inc eax
        mov [i], eax
        cmp eax, ebx
        jl for_1
    ; }
    endfor_1:

    ; in the previous for we stored in 'quo' field the sum
    ; and in 'remain' field the number of appearances

    ; i = 0
    xor eax, eax
    mov [i], eax

    for_2:  ; for (i = 0; i < 5; i++) {

    ; 'for' condition
    mov eax, [i]
    cmp eax, 5
    jg endfor_2

        mov ebx, [i]

        xor eax, eax
        mov eax, ebx
        imul eax, 4
        mov ebx, eax
        ; we store: ebx = i * sizeof(avg)

        xor eax, eax
        xor ecx, ecx
        ; ax = avg->quo
        mov WORD ax, [edx + ebx]
        mov WORD cx, [edx + ebx + 2]

        cmp ecx, 0
        je inc

        push edx
        xor edx, edx

        div cx  ; the sum / contor
        mov cx, dx

        pop edx

        mov WORD [edx + ebx], ax
        mov WORD [edx + ebx + 2], cx

    inc:    ; increment i

        xor eax, eax
        mov eax, [i]
        inc eax
        mov [i], eax
        cmp eax, 5
        jl for_2

    ; }
    endfor_2:

    ;; Your code ends here

    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY


    ;  b) run_procs
    ;     I go through all the process struct with a for,
    ; that starts at label "for_1" (line 52)

    ;     In this for there are 5 if-s, one for every priority.
    ; I calculate the sum and contor directly in the "avg" struct
    ; sum for procs with prio == 1 is stored in avg[0].quo
    ; contor for procs with prio == 1 is stored in avg[0].remain
    ; ...
    ; sum for procs with prio == 5 is stored in avg[4].quo
    ; contor for procs with prio == 5 is stored in avg[4].remain

    ;     After everything is stored I am going to use another for
    ; ("for_2" line 166, for(i = 0 -> 4))
    ;     I store in ax and cx the calculated values. The "div"
    ; instruction divides the "ax" by the given register
    ; (in our case "cx")
    ;     Everything is done and we store the correct values in
    ; avg[i].quo and avg[n].remain
