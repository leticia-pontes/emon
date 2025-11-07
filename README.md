[![CI](https://github.com/leticia-pontes/emon/actions/workflows/test-assembly.yml/badge.svg)](https://github.com/leticia-pontes/emon/actions/workflows/test-assembly.yml)

# Emon OS/Kernel

Emon é um projeto de kernel de baixo nível (bare-metal) desenvolvido principalmente em **Assembly** e **C**, focado na arquitetura **i386 (32-bit)**.

Objetivos do Projeto:
* Aprender Programação de Baixo Nível: Entender a fundo o funcionamento do hardware, registradores e a inicialização do sistema.
* Criar um Setor de Boot Funcional: Desenvolver um boot sector eficiente, responsável por iniciar o processo de carregamento.
* Implementar o Modo Protegido: Configurar a CPU para operar no modo protegido de 32 bits, um passo crucial para um kernel moderno.

## Tecnologias Utilizadas

| Ferramenta | Uso |
| :--- | :--- |
| **Linguagem Principal** | Assembly x86 e C |
| **Montador (Assembler)** | NASM (Netwide Assembler) |
| **Emulador/Teste** | QEMU (QEMU System Emulator for i386) |

## ⚙️ Como Montar e Executar

Para compilar e testar alguma versão do boot sector, você precisará ter o **NASM** e o **QEMU-system-x86** instalados em sua máquina (de preferência, use uma **máquina virtual**).

### Pré-requisitos

  * **NASM**
  * **QEMU** (pacote `qemu-system-x86` no Linux/Debian)

### Passos de Compilação e Execução

Siga os comandos abaixo para montar o boot sector (`boot_vX.asm`) e executá-lo no QEMU:

1.  **Entre na pasta `boot/`**

    ```bash
    cd boot
    ```

2.  **Montar o código Assembly:**

    ```bash
    nasm -f bin boot_vX.asm -o boot_vX.bin
    ```

3.  **Executar no QEMU:**

    ```bash
    qemu-system-i386 boot_vX.bin
    ```

### Teste de Integração Contínua (CI)

Este projeto usa **GitHub Actions** para garantir que a montagem e a execução no QEMU funcionem em cada *commit*. O status do build pode ser visualizado no topo desta página.

> Para rodar versões diferentes do boot sector, altere o arquivo `.github/workflows/test-assembly.yml`.

## Funcionalidades Atuais

  * Setor de boot inicial (512 bytes).
  * Exibição de mensagem na tela/console serial.

## Contribuições

No momento, o projeto Emon está focado em objetivos de desenvolvimento e aprendizado internos. Por isso, não estou aceitando Pull Requests (PRs) para o código principal. Se você tiver dúvidas, sugestões ou encontrar um problema, sinta-se à vontade para abrir uma.
