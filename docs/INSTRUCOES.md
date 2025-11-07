### Comandos para montar, compilar e executar o S.O. com o kernel

1. Compilar o kernel.c com GCC
```bash
gcc -m32 -fno-pie -ffreestanding -c kernel.c -o kernel.o
```

2. Gerar o binário para o ponto de entrada do kernel
```bash
nasm kernel_entrada.asm -f elf -o kernel_entrada.o
```

3. Ligar ("linkar") o binário do kernel com o ponto de entrada
```bash
ld -m elf_i386 -o kernel.bin -Ttext 0x1000 kernel_entrada.o kernel.o --oformat binary
```

> O arquivo `kernel.bin` gerado na etapa é um binário criado com código ASM e C

4. Gerar o binário do setor de boot
```bash
nasm bootsect.asm -f bin -o bootsect.o
```

5. Criar uma imagem "bootável" de "disco" contendo o boot sector e depois o kernel
```bash
cat bootsect.o kernel.bin > imagem-so.bin
```

6. Testar no emulador QEMU
```bash
qemu-system-i386 -fda imagem-so.bin
```