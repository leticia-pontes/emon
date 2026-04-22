[![CI](https://github.com/leticia-pontes/emon/actions/workflows/test-assembly.yml/badge.svg)](https://github.com/leticia-pontes/emon/actions/workflows/test-assembly.yml)

# 🇺🇸 Emon — Minimal x86 Kernel (i386)

Emon is a low-level, bare-metal kernel project developed in Assembly (x86) and C, targeting the i386 (32-bit) architecture. The goal is to explore system initialization, memory interaction, and the integration between bootloader and kernel in a freestanding environment.

---

## Overview

This project implements a minimal bootable system, starting from a custom boot sector and transitioning execution to a C-based kernel. It focuses on understanding how software interacts directly with hardware without the support of an operating system.

---

## Objectives

- Understand low-level system initialization and CPU execution flow  
- Implement a custom bootloader (512-byte boot sector)  
- Transition execution from Assembly to a C kernel  
- Manipulate hardware directly (e.g., video memory)  
- Validate the full boot process using an emulator  

---

## Architecture

The system is composed of two main components:

```

[ BIOS ]
↓
[ Bootloader (Assembly, 512 bytes) ]
↓
[ Kernel Entry (Assembly bridge) ]
↓
[ Kernel (C) ]
↓
[ Video Memory Output ]

````

### Execution Flow

1. The BIOS loads the boot sector into memory and transfers control  
2. The bootloader initializes the environment and loads the kernel  
3. Control is passed to an Assembly entry point  
4. The kernel (written in C) is executed in a freestanding environment  
5. Output is written directly to video memory or serial interface  

---

## Tech Stack

- **Assembly (x86)** — bootloader and low-level control  
- **C (freestanding)** — kernel implementation  
- **NASM** — assembler  
- **GCC (32-bit)** — kernel compilation  
- **LD (linker)** — binary linking  
- **QEMU** — system emulation and testing  
- **GitHub Actions** — CI pipeline for build validation  

---

## Key Design Decisions

- **Freestanding C environment**  
  Avoided standard libraries to ensure full control over memory and execution  

- **Assembly → C transition**  
  Used an Assembly entry point to bridge low-level boot logic with higher-level kernel code  

- **Flat binary output**  
  Generated raw binary for direct boot compatibility instead of using ELF at runtime  

- **QEMU-based testing**  
  Enabled reproducible testing without relying on physical hardware  

---

## Current Features

- Custom boot sector (512 bytes)  
- Kernel loading and execution  
- Basic output via video memory or serial console  
- Automated build and execution via CI  

---

## Limitations

- No memory management (paging/segmentation not implemented)  
- No interrupt handling (IDT not configured)  
- No filesystem or user input support  
- Single-stage boot process  

---

## Future Improvements

- Implement basic interrupt handling (IDT)  
- Add memory management (paging)  
- Introduce keyboard input handling  
- Expand kernel capabilities beyond simple output  
- Multi-stage bootloader  

---

## Build & Run

### Requirements

- NASM  
- GCC (32-bit support)  
- QEMU (`qemu-system-i386`)  

### Steps

```bash
cd boot
nasm -f bin boot_vX.asm -o boot_vX.bin

cd ..
gcc -m32 -ffreestanding -fno-pie -c kernel.c -o kernel.o
nasm -f elf kernel_entrada.asm -o kernel_entrada.o
ld -m elf_i386 -Ttext 0x1000 kernel_entrada.o kernel.o --oformat binary -o kernel.bin

cat boot/boot_vX.bin kernel.bin > imagem-so.bin

qemu-system-i386 -nographic -serial stdio imagem-so.bin
````

---

## CI Pipeline

The project uses GitHub Actions to automatically:

* Assemble the bootloader
* Compile the kernel
* Link the binary
* Run the system in QEMU for validation

---

## Notes

This project is focused on low-level learning and experimentation. It is not intended to be a production-ready operating system, but rather a foundation for understanding OS internals and system programming.

---

# 🇧🇷 Emon — Kernel x86 Minimalista (i386)

Emon é um projeto de kernel de baixo nível (bare-metal) desenvolvido em Assembly (x86) e C, voltado para a arquitetura i386 (32-bit). O objetivo é explorar a inicialização do sistema, interação com memória e a integração entre bootloader e kernel em um ambiente freestanding.

---

## Visão Geral

O projeto implementa um sistema mínimo inicializável, começando com um boot sector customizado e transferindo a execução para um kernel em C. O foco está em entender como o software interage diretamente com o hardware sem o suporte de um sistema operacional.

---

## Objetivos

* Entender inicialização de sistemas e fluxo de execução da CPU
* Implementar um bootloader customizado (512 bytes)
* Transicionar execução de Assembly para um kernel em C
* Manipular hardware diretamente (ex: memória de vídeo)
* Validar o processo completo de boot via emulação

---

## Arquitetura

O sistema é composto por dois componentes principais:

```
[ BIOS ]
   ↓
[ Bootloader (Assembly, 512 bytes) ]
   ↓
[ Entry do Kernel (ponte em Assembly) ]
   ↓
[ Kernel (C) ]
   ↓
[ Saída via memória de vídeo ]
```

### Fluxo de Execução

1. A BIOS carrega o boot sector na memória e transfere o controle
2. O bootloader inicializa o ambiente e carrega o kernel
3. O controle é passado para um ponto de entrada em Assembly
4. O kernel (em C) é executado em ambiente freestanding
5. A saída é feita diretamente na memória de vídeo ou interface serial

---

## Stack Tecnológica

* **Assembly (x86)** — bootloader e controle de baixo nível
* **C (freestanding)** — implementação do kernel
* **NASM** — assembler
* **GCC (32-bit)** — compilação do kernel
* **LD** — linkagem binária
* **QEMU** — emulação e testes
* **GitHub Actions** — pipeline de CI

---

## Decisões de Design

* **Ambiente C freestanding**
  Sem uso de bibliotecas padrão para manter controle total de execução

* **Transição Assembly → C**
  Uso de um entry point em Assembly como ponte para o kernel

* **Binário flat**
  Geração de binário bruto compatível com boot direto

* **Testes com QEMU**
  Execução reproduzível sem depender de hardware físico

---

## Funcionalidades Atuais

* Boot sector customizado (512 bytes)
* Carregamento e execução do kernel
* Saída básica via memória de vídeo ou console serial
* Build e execução automatizados via CI

---

## Limitações

* Sem gerenciamento de memória (paging/segmentação não implementados)
* Sem tratamento de interrupções (IDT não configurada)
* Sem sistema de arquivos ou entrada de usuário
* Boot de estágio único

---

## Melhorias Futuras

* Implementar tratamento de interrupções (IDT)
* Adicionar gerenciamento de memória (paging)
* Suporte a entrada de teclado
* Expandir funcionalidades do kernel
* Bootloader multi-stage

---

## Build & Execução

### Requisitos

* NASM
* GCC (32-bit)
* QEMU (`qemu-system-i386`)

### Passos

```bash
cd boot
nasm -f bin boot_vX.asm -o boot_vX.bin

cd ..
gcc -m32 -ffreestanding -fno-pie -c kernel.c -o kernel.o
nasm -f elf kernel_entrada.asm -o kernel_entrada.o
ld -m elf_i386 -Ttext 0x1000 kernel_entrada.o kernel.o --oformat binary -o kernel.bin

cat boot/boot_vX.bin kernel.bin > imagem-so.bin

qemu-system-i386 -nographic -serial stdio imagem-so.bin
```

---

## Pipeline de CI

O projeto utiliza GitHub Actions para:

* Montar o bootloader
* Compilar o kernel
* Gerar o binário
* Executar no QEMU para validação

---

## Observações

Este projeto é voltado para aprendizado e experimentação em baixo nível. Não é um sistema operacional pronto para produção, mas sim uma base para estudo de sistemas e programação de baixo nível.
