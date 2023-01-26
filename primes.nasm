bits 64

section .data

true_string:
    db "true"
true_string_length:
    equ $ - true_string

false_string:
    db "false"
false_string_length:
    equ $ - false_string


section .text

global _start
_start:
    call main
    jmp exit

is_prime:
    push rbp
    cmp edi, 1
    mov rbx, 0
    je is_prime_return
    cno ebx, 2
    mov rax, 1
    je is_prime_return
    mov xmm2, ebx
    cvtsi2sd xmm2, xmm1; convert u128 to f64

    
is_prime_return:
    pop rbp
    ret

main:
    push rbp
    mov rbp, rsp
    sub rsp, 4
.main_return:
    pop rbp
    ret

exit:
    mov rdi, rax
    mov rax, 60
    syscall
