
bits 64

section .text

global _start
_start:
    call main
    jmp exit

exit:
    mov rdi, rax
    mov rax, 60
    syscall

main:
    push rbp
    mov rbp, rsp
    sub rsp, 8

    ; mov edi, 5
    ; call find_prime_optimized

    call print_example_calls

.return:
    mov rsp, rbp
    pop rbp
    ret


modulo:
    mov eax, edi
    cdq
    idiv esi
    mov eax, edx
    ret


rounded_square_root:
    cvtsi2sd xmm0, edi
    xorpd xmm1, xmm1
    sqrtsd xmm0, xmm0
    cvttpd2dq xmm0, xmm0
    cvtdq2pd xmm0, xmm0
    addsd xmm0, [v0f5]
    cvttsd2si eax, xmm0
    ret


is_prime:
    push rbp
    mov rbp, rsp
    sub rsp, 12
    mov [rsp], edi

    mov eax, [rsp]
    cmp eax, 1
    mov eax, 0
    je .return

    mov eax, [rsp]
    cmp eax, 2
    mov eax, 1
    je .return

    mov edi, [rsp]
    call rounded_square_root
    mov [rsp + 4], eax

    mov eax, 2
    mov [rsp + 8], eax
.loop0_begin:
    mov eax, [rsp + 8]
    mov ebx, [rsp + 4]
    cmp eax, ebx
    jle .loop0_body
    jmp .loop0_end
.loop0_body:
    mov edi, [rsp]
    mov esi, [rsp + 8]
    call modulo
    cmp eax, 0
    je .if0_body
    jmp .if0_end
.if0_body:
    mov eax, 0
    jmp .return
.if0_end:
    mov eax, [rsp + 8]
    add eax, 1
    mov [rsp + 8], eax
    jmp .loop0_begin
.loop0_end:
    mov eax, 1
.return:
    mov rsp, rbp
    pop rbp
    ret


find_prime:
    push rbp
    mov rbp, rsp
    sub rsp, 12
    mov [rsp], edi
    mov dword [rsp + 4], 0
    mov dword [rsp + 8], 2

.loop0_begin:
    mov eax, [rsp + 4]
    mov ebx, [rsp]
    cmp eax, ebx
    jl .loop0_body
    jmp .loop0_end
.loop0_body:
    mov eax, [rsp + 8]
    add eax, 1
    mov [rsp + 8], eax

.loop1_begin:
    mov edi, [rsp + 8]
    call is_prime
    cmp eax, 0
    je .loop1_body
    jmp .loop1_end
.loop1_body:
    mov eax, [rsp + 8]
    add eax, 1
    mov [rsp + 8], eax
    jmp .loop1_begin
.loop1_end:
    mov eax, [rsp + 4]
    add eax, 1
    mov [rsp + 4], eax
    jmp .loop0_begin
.loop0_end:
    mov eax, [rsp + 8]
.return:
    mov rsp, rbp
    pop rbp
    ret


is_prime_optimized:
    cmp edi, 1
    jne .not_one
    mov eax, 1
.not_one:
    cmp edi, 2
    jne .not_two
    mov eax, 1
    ret
.not_two:
    call rounded_square_root
    mov r9d, eax
    mov r10d, 2
.loop0_begin:
    cmp r10d, r9d
    jg .loop0_end
    mov esi, r10d
    mov eax, edi
    cdq
    idiv esi
    cmp edx, 0
    jne .if0_end
    xor eax, eax
    jmp .return
.if0_end:
    inc r10d
    jmp .loop0_begin
.loop0_end:
    mov eax, 1
.return:
    ret

find_prime_optimized:
    mov r11d, edi
    xor r12d, r12d
    mov r13d, 2
.loop0_begin:
    cmp r12d, r11d
    jge .loop0_end
    inc r13d
.loop1_begin:
    mov edi, r13d
    call is_prime_optimized
    cmp eax, 0
    jne .loop1_end
    inc r13d
    jmp .loop1_begin
.loop1_end:
    inc r12d
    jmp .loop0_begin
.loop0_end:
    mov eax, r13d
.return:
    ret

print_string:
    mov rdx, rsi
    mov rsi, rdi
    mov rax, 1
    mov rdi, 1
    syscall
    ret

strlen:
    mov ecx, esi
    xor eax, eax
.loop0_begin:
    cmp byte [rbx + rax], 0
    je .loop0_end
    inc rax
    cmp rcx, rax
    jne .loop0_begin
    mov eax, ecx
.loop0_end:
    ret

print_int:
    push rbp
    mov rbp, rsp
    sub rsp, 36
    mov qword [rsp], 0
    mov qword [rsp + 4], 0
    mov qword  [rsp + 8], 0
    mov qword  [rsp + 12], 0
    mov qword  [rsp + 16], 0
    mov [rsp + 24], edi
    mov [rsp + 28], esi
    mov dword [rsp + 32], 22
.loop0_begin:
    mov eax, [rsp + 24]
    and eax, [rsp + 32]
    cmp eax, 0
    je .loop0_end

    mov rax, [rsp + 24]
    mov rdx, 0
    idiv qword [rsp + 28]
    xor rsi, rsi
    mov esi, edx
    add rsi, int_chars
    mov al, [rsi]
    mov eax, [rsp + 32]
    mov rsi, rsp
    add rsi, rax
    mov byte [rsi], al

    inc qword [rsp + 32]

    mov eax, [rsp + 24]
    mov edx, 0
    idiv qword [rsp + 28]
    mov [rsp + 24], eax
.loop0_end:
    mov rbx, rsp
    mov esi, 24
    call strlen
    mov rdi, rsp
    add rdi, 0
    mov rsi, rax
    call print_string
.return:
    mov rsp, rbp
    pop rbp
    ret

print_example_calls:
    push rbp
    mov rbp, rsp
    sub rsp, 4
    mov dword [rsp], 1
.loop0_begin:
    mov eax, [rsp]
    cmp eax, 10
    jg .loop0_end

    mov rdi, string_p1
    mov rsi, string_p1_length
    call print_string

    mov edi, [rsp]
    mov esi, 10
    call print_int
    
    mov rdi, string_p2
    mov rsi, string_p2_length
    call print_string

    mov rdi, [rsp]
    call is_prime_optimized
    cmp eax, 0
    je .if0_falsy
.if0_truthy:
    mov rdi, string_true
    mov rsi, string_true_length
    call print_string
    jmp .if0_end
.if0_falsy:
    mov rdi, string_false
    mov rsi, string_false_length
    call print_string
.if0_end:
    
    mov rdi, string_p3
    mov rsi, string_p3_length
    call print_string
    
    inc dword [rsp]
    jmp .loop0_begin
.loop0_end:
    mov dword [rsp], 0
.loop1_begin:
    mov eax, [rsp]
    cmp eax, 10
    jge .loop1_end

    mov rdi, string_p4
    mov rsi, string_p4_length
    call print_string

    mov edi, [rsp]
    mov esi, 10
    call print_int
    
    mov rdi, string_p2
    mov rsi, string_p2_length
    call print_string

    mov edi, [rsp]
    call find_prime_optimized
    mov edi, eax
    mov esi, 10
    call print_int
    
    mov rdi, string_p3
    mov rsi, string_p3_length
    call print_string
    

    inc dword [rsp]
    jmp .loop1_begin
.loop1_end:

.return:
    mov rsp, rbp
    pop rbp
    ret

mov rax, 2
jmp exit

section .data

v0f5: dq 0.5

int_chars: db "0123456789abcdef"

string_true: db "true"
string_true_length: equ $ - string_true

string_false: db "false"
string_false_length: equ $ - string_false

string_p1: db "is_prime("
string_p1_length: equ $ - string_p1

string_p2: db ") == "
string_p2_length: equ $ - string_p2

string_p3: db 10
string_p3_length: equ $ - string_p3

string_p4: db "find_prime("
string_p4_length: equ $ - string_p4

