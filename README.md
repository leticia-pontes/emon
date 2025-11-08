[![CI](https://github.com/leticia-pontes/emon/actions/workflows/test-assembly.yml/badge.svg)](https://github.com/leticia-pontes/emon/actions/workflows/test-assembly.yml)

# Emon OS/Kernel

Emon é um projeto de kernel de baixo nível (bare-metal) desenvolvido principalmente em **Assembly** e **C**, focado na arquitetura **i386 (32-bit)**.

## Objetivos do Projeto
* Aprender Programação de Baixo Nível: Entender a fundo o funcionamento do hardware, registradores e a inicialização do sistema.
* Criar um Setor de Boot Funcional: Desenvolver um boot sector eficiente, responsável por iniciar o processo de carregamento.
* Implementar o Kernel em C: Permitir manipulação da memória de vídeo e outras funcionalidades básicas do sistema.
* Integrar Bootloader e Kernel: Executar testes completos de inicialização no QEMU.

## Tecnologias Utilizadas

| Ferramenta | Uso |
| :--- | :--- |
| **Linguagem Principal** | Assembly x86 e C |
| **Montador (Assembler)** | NASM (Netwide Assembler) |
| **Compilador C** | GCC (32-bit, freestanding) |
| **Emulador/Teste** | QEMU (QEMU System Emulator for i386) |

## ⚙️ Como Montar e Executar

Para compilar e testar o sistema operacional:

### Pré-requisitos

  * **NASM**
  * **GCC (32-bit)**
  * **QEMU** (`qemu-system-x86` no Linux/Debian)

### Passos de Compilação e Execução

1. Entre na pasta do bootloader:
    ```bash
    cd boot
    ```

2. Montar o código Assembly do bootloader:
    ```bash
    nasm -f bin boot_vX.asm -o boot_vX.bin
    ```

3. Volte para a raiz e compile o kernel C:
    ```bash
    gcc -m32 -ffreestanding -fno-pie -c kernel.c -o kernel.o
    nasm -f elf kernel_entrada.asm -o kernel_entrada.o
    ld -m elf_i386 -Ttext 0x1000 kernel_entrada.o kernel.o --oformat binary -o kernel.bin
    ```

4. Criar a imagem bootável:
    ```bash
    cat boot/boot_vX.bin kernel.bin > imagem-so.bin
    ```

5. Executar no QEMU:
    ```bash
    qemu-system-i386 -nographic -serial stdio imagem-so.bin
    ```

### Teste de Integração Contínua (CI)

O projeto usa **GitHub Actions** para validar a montagem do bootloader, a compilação do kernel e a execução no QEMU a cada commit. O status do build aparece no badge do topo desta página.

> Para rodar versões diferentes do bootloader, altere o arquivo `.github/workflows/test-assembly.yml`.

## Funcionalidades Atuais

* Setor de boot inicial (512 bytes)
* Kernel C inicializando e escrevendo na memória de vídeo
* Exibição de mensagens na tela/console serial

## Contribuições

Atualmente, o projeto é voltado para aprendizado interno. Pull Requests não são aceitos. Para dúvidas, sugestões ou problemas, abra uma issue.
