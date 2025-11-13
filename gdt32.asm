; implementação da GDT (Global Descriptor Table)
gdt_inicio:
    ; a GDT deve começar com 8 bytes nulos (64 bits)
    dd 0x0  ; dd = define double, armazena uma valo de 32 bits
    dd 0x0

; GDT para o segmento de código
; endereço base: 0x0
; limite: 0xffff
; db (define byte) 8 bits
; dw (define word) 16 bits
; dd (define double) 32 bits
; dq (define quad) 64 bits
gdt_codigo:
    dw 0xffff ; limite (tamanho do segmento) bits 0 - 15
    dw 0x0 ; parte do endereço base do segmento: bits 0 - 15
    db 0x0 ; segunda parte do endereço base: bits 16 - 23
    ; primeira sequência de flags: (presente)1 (privilégio)00 (tipo)1
    ; (código)1 (conformidade)0 (legibilidade)1 (acessada)0
    db 10011010b ; o "b" indicar valor binário
    ; segunda sequência de flags: (granularidade)1 (32-bits)1
    ; (64-bits)0 (avl)0 (restante do tamanho/limite do segmento)1111
    db 11001111b
    db 0x0 ; restante do endereço base (bits 24 - 31)

; segmento de dados (basicamente o mesmo)
gdt_dados:
    dw 0xffff
    dw 0x0
    db 0x0
    db 10010010b
    db 11001111b
    db 0x0

gdt_fim:

gdt_descritor:
    dw gdt_fim - gdt_inicio - 1
    dd gdt_inicio

; constantes que serão usadas posteriormente
SEGMENTO_CODIGO equ gdt_codigo - gdt_inicio
SEGMENTO_DADOS equ gdt_dados - gdt_inicio
