; função para leitura d "n" setores de uma unidade de
; armazenamento. a quantidade de setores a ser lida deverá
; ser colocada antes de chamar a função no registrador DH.
; o número da unidade de armazenamento a ser lida deverá ter
; sido colocado em DL. os setores lidos ficarão disponíveis
; na memória no endereço ES:BX
ler_disco:
    pusha
    push dx 
    mov ah, 0x02 ; função 2 da bios (leitura)
    mov al, dh ; copiamos para al a quantidade de setores
    ; a ser lida
    mov cl, 0x02 ; número do setor a ser lido (0x01 é o boot)
    mov ch, 0x00 ; número do cilindro (0x00)
    ; DL já deve conter o código da unidade, sendo:
    ; 0: disquete A   1: disquete B   0x80: HD1 (C:)  0x81: HD2 (D:)
    mov dh, 0x00 ; número da cabeça
    ; [es:bx] é o local da memória onde ficarão os dados lidos
    int 0x13 ; interrupção 13h: serviços de disco da BIOS
    jc erro_disco ; pule para erro_disco se gerou um "carry bit"

    pop dx
    cmp al, dh ; verifica se a quantidade de setores lida está
    jne erro_setor ; correta. se não (jump not equal) pula para
               ; tratamento do erro
    ; se não, encerra
    popa
    ret

erro_disco:
    mov bx, MENSAGEM_ERRO_DISCO
    call imprime
    call imprime_quebra
    mov dh, ah ; AH contém o código do erro
    call imprime_hexa
    jmp loop_disco

erro_setor:
    mov bx, MENSAGEM_ERRO_SETOR
    call imprime

loop_disco:
    jmp $

MENSAGEM_ERRO_DISCO: db "Erro na leitura do disco", 0
MENSAGEM_ERRO_SETOR: db "Qtd. incorreta de setores lidos", 0
