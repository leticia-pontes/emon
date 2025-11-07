## Anotações

### 22/10/2025
**ETAPAS PARA ENTRAR EM MODO PROTEGIDO (32 BITS)**

<u>1. Nova maneira de imprimir na tela</u>
Sem percisar escrever um driver!
Como? **Acessando diretamente uma parte da memória de vídeo!**

- Modo texto VGA: 25 linhas e 80 colunas de texto
- Endereço do Buffer: 0xB8000

- Mapeada diretamente para -> GPU -> Monitor
- Cada caractere ocupa 2 bytes na memória:
	- 1 byte para código ASCII
	- 1 byte para cor
- Fórmula da poição de um caractere: `0xB8000 + 2 x (linha x 80 + coluna)`

<u>2. Habilitando a proteção de memória</u>

- Prepara a <u>GDT</u> (Global Descriptor Table)
- Definir segmentos de memória e seus atributos
- Deve ser definida pelo S.O. e "passada" à <u>CPU</u>
- Registrador de segmento apontará para um <u>Descritor de Segmento</u> na tabela
- Cada descritor é composto de 8 bytes (64 bits), sendo:
	- Endereço base (32 bits)
	- Limite de segmento (20 bits)
	- "Flags" de atributos (12 bits)
		- Privilégio
		- Read/Write
		- etc.

### 29/10/2025
**GDT (Global Descriptor Table)**

- Cada entrada na GDT é composta de 8 bytes (64 bits), sendo:
	- 32 bits: endereço base do segmento
	- 20 bits: limite do segmento (seu tamanho)
	- 12 bits: "flags" de controle, sendo:
		- 1 bit: está <u>presente</u> na memória?
		- 2 bits: privilégio (modo núcleo = 00)
		- 1 bit: tipo de descritor (1 = Código ou Dados)

- 1 bit: <u>Código</u> (1 para código, 0 para dados)
- 1 bit: <u>Conformidade</u> (segmento menos privilegiado pode acessar? 0 = Não pode)
- 1 bit: <u>Leitura</u> (1 = Sim, 0 = Só execução)
- 1 bit: <u>Acessado</u> (0, usado em debugging)
- 1 bit: <u>Granularidade</u> (se setado 1, aumenta o tamanho)
- 1 bit: <u>32-bits</u> (1 = Sim)
- 1 bit: <u>64-bits</u> (0 = Não)
- 1 bit: <u>AVL</u> (0, uso livre)

### 05/11/2025

- O registrador AX/EAX é o mais popular, de uso genérico.
- Relembrando ponteiros: O ponteiro é declarado com um * na frente do tipo (ex.: char*). O 'type* var' armazena o endereço referência para o valor. O valor em si está em '*var'.

Perguntas:
- Por que a variável 'memoria_de_video' no kernel.c é um ponteiro? Por que não armazenar um char simples?