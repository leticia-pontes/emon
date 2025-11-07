### 08/10/2025

A execução dos comandos para montagem e execução dos programas Assembly pelo VSCode resultou em erro. O VSCode precisa de alguma instalação/configuração adicional para montar e executar os programas pelo seu terminal. É preciso rodar os comandos pela linha de comando do SO.

### 22/10/2025 

Por algum motivo, os arquivos `boot_v6.asm` e `ler_disco.asm` apresentaram erros, antes mesmo de compilar (os erros estavam sendo mostrados pelo VSCode).
É como se o `imprime.asm`, que estava sendo importado por esses arquivos, estava sendo reescrito dentro desses arquivos.
Aparentemente, o erro foi porque eles estavam importando também o `imprime_hexa.asm`, que já inclui o `imprime.asm`.
Para resolver, foi necessário remover o `imprime.asm` dos códigos.
A mesma coisa aconteceu no `boot_v8.asm` ao importar o `imprime_hexa.asm`, porque ele já é importado pelo `ler_disco.asm`, outro arquivo importado no `boot_v8.asm`.

`boot_v8.asm` -> `ler_disco.asm` -> `imprime_hexa.asm` -> `imprime.asm`

(-> = importa)
