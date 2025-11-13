; procedimentos para entrar em modo protegido (32-bits)
; começamos em modo real (16 bits)
[bits 16]
mudar_para_modo_protegido:
    cli ; começamos desabilitando as interrupções do processador
    lgdt [gdt_descritor] ; este comando "carrega" a GDT no processador
    ; para alternar para modo protegido devemos setar um bit no registrador CR0
    mov eax, cr0
    or eax, 0x1
    mov cr0, eax
    jmp SEGMENTO_CODIGO:iniciar_modo_protegido

; mudamos para modo protegido (32 bits)
[bits 32]
iniciar_modo_protegido:
    mov ax, SEGMENTO_DADOS
    ; atualizamos os registradores de segmento
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    
	mov ebp, 0x90000 ; Atualiza o endereço da pilha
    mov esp, ebp

    call INICIAR_MP
