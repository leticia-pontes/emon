; recebemos o valor a ser impresso no registrador DX
; suponha que DX = 0x1234

imprime_hexa:
    pusha
    mov cx, 0 ; servirá como um "índice/contador"

; estratégia: obter o último número em DX e convertê-lo para ASCII
; na tabela ASCII '0' é 0x30 e '9' é 0x39 então para valores
; entre 0 e 9 basta somar 0x30 que obteremos o equivalente em ASCII.
; já para os valores alfabéticos (A-F) 'A' é 0x41 e 'F' é 0x46.
; então nestes casos deveremos somar 7 ao valor.
; em seguida, copiaremos o valor resultante para uma posição na
; string de destino
hexa_loop:
    cmp cx, 4 ; repetiremos 4 vezes (uma vez para cada número hexa)
    je fim2 ; se igual a 4 já "convertemos" todos e podemos encerrar    

    ; 1. converte o último número em DX no seu equivalente ASCII
    mov ax, dx ; copiamos o valor original para ax
    and ax, 0x000f ; fazemos um AND bit a bit em AX. assim, só
    ; vai "sobrar" nele o último número
    add al, 0x30 ; adicionamos 0x30 ao valor para obter seu ASCII
    ; porém, e se ele for maior que 9 (A, B, C, D, E ou F)???
    cmp al, 0x39
    jle passo2 ; jle: jump if less or equal (vai ao passo2)
    add al, 7 ; se não saltou, o dígito é algum de A a F
    ; então acresentemos 7 ao valor em al para chegar
    ; ao ASCII correspondente ('A' a 'F') 

passo2:
    ; 2. obter a posição da string que conterá o valor hexa
    ; convertido.
    mov bx, HEX_OUT + 5
    sub bx, cx ; variável índice
    mov [bx], al ; copia o valor ASCII em al para a posição em bx
    ror dx, 4 ; rotaciona o valor em dx por quatro bits
    ; antes do ror: 0x1234
    ; depois do primeiro ror: 0x4123
    ; depois do segundo ror (próximo loop): 0x3412
    ; depois do terceiro ror (depois do segundo loop): 0x2341
    ; depois do último ror (último loop): 0x1234
    add cx, 1 ; incrementa o contador
    jmp hexa_loop ; volta o loop

fim2:    ; terminamos a "conversão"
    mov bx, HEX_OUT
    call imprime

    popa
    ret

HEX_OUT:
    db '0x0000', 0  ; espaço na memória onde ficará a
    ; string com os dígitos hexa
