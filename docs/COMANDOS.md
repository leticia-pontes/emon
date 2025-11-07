#### ASSEMBLY

Montar o Assembly
```bash
nasm -f bin boot_v5.asm -o boot_v5.bin
```

Executar o binário
```bash
qemu-system-i386 boot_v5.bin
```

#### C

Compilação de arquivo objeto
```bash
gcc -ffreestanding -c test1.c -o test1.o
```

Mostra o conteúdo do arquivo objeto
```bash
objdump -M intel -d test1.o
```