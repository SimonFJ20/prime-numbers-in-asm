bits 64
default rel

one_half: dq 0.5

global squareroot
squareroot:
    cvtsi2sd xmm0, edi
    xorpd xmm1, xmm1
    sqrtsd xmm0, xmm0
    cvttpd2dq xmm0, xmm0
    cvtdq2pd xmm0, xmm0
    addsd xmm0, [one_half]
    cvttsd2si eax, xmm0
    ret


