; código para uma função de impressão de strings
imprime:
    pusha ; push all = empilha os valores de todos os registradores

inicio:
    mov al, [bx] ; bx vai conter o endereço para o começo da string
    cmp al, 0 ; verifica se é o valor terminador da string (zero)
    je fim ; je = jump if equal. pula para "fim" se for zero
           ; se não for, segue
    
    mov ah, 0x0e
    int 0x10

    add bx, 1 ; incrementa o "ponteiro" do caractere atual da string
    jmp inicio ; volta ao inicio (loop)

fim:
    popa ; pop all = desempilha os valores de todos os registradores
    ret

imprime_quebra:
    pusha
    mov ah, 0x0e
    mov al, 0x0a ; quebra de linha (line feed)
    int 0x10
    mov al, 0x0d ; retorno do cursor (carriage return)
    int 0x10
    popa
    ret

