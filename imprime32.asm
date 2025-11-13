; função para impressão na tela em modo protegido (32 bits)
[bits 32] ; indica que o código será escrito e executado em modo 32 bits

; novidade: constantes em assembly!
MEMORIA_DE_VIDEO    equ     0xb8000  ; endereço da memória de video modo texto
BRANCO_EM_PRETO     equ     0x0f ; valor hexa para texto branco no fundo preto
VERMELHO_EM_PRETO   equ     0x0c 

imprime_mp:     ; imprime em modo protegido
    pusha
    mov edx, MEMORIA_DE_VIDEO ; EDX é o DX com 32 bits de tamanho

imprime_mp_loop:
    mov al, [ebx] ; EBX contém o endereço do caractere a ser impresso
    mov ah, BRANCO_EM_PRETO ; hexa para cor

    cmp al, 0 ; comparação para verificar se chegamos ao final da string
    je imprime_mp_fim ; se chegamos a final, salta para "imprime_mp_fim"
    ; se não terminou, continua...

    mov [edx], ax ; armazena na posição de memória em EDX o caractere e
                  ; o código de cor desejado
    add ebx, 1 ; avança para o próximo caractere
    add edx, 2 ; avança para a próxima posição da memória de vídeo
    jmp imprime_mp_loop ; repete o laço

imprime_mp_fim: ; chegou ao fim
    popa
    ret
    
                      




