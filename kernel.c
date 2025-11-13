#include "stdbool.h"
#include "stddef.h"
#include "stdint.h"

// valores para cores do texto e fundo
enum vga_color {
	VGA_COLOR_BLACK = 0,
	VGA_COLOR_BLUE = 1,
	VGA_COLOR_GREEN = 2,
	VGA_COLOR_CYAN = 3,
	VGA_COLOR_RED = 4,
	VGA_COLOR_MAGENTA = 5,
	VGA_COLOR_BROWN = 6,
	VGA_COLOR_LIGHT_GREY = 7,
	VGA_COLOR_DARK_GREY = 8,
	VGA_COLOR_LIGHT_BLUE = 9,
	VGA_COLOR_LIGHT_GREEN = 10,
	VGA_COLOR_LIGHT_CYAN = 11,
	VGA_COLOR_LIGHT_RED = 12,
	VGA_COLOR_LIGHT_MAGENTA = 13,
	VGA_COLOR_LIGHT_BROWN = 14,
	VGA_COLOR_WHITE = 15,
};

/* 
	parâmetros:
		fg (foreground): cor para o texto
		bg (background): cor para o fundo
	retorno:
		inteiro de 1 byte sem sinal contendo os códigos para cor do texto e do fundo
*/
static inline uint8_t vga_entry_color(enum vga_color fg, enum vga_color bg) 
{
	return fg | bg << 4;
}

/* 
	parâmetros:
		uc: caractere a ser impresso
		color: inteiro de 1 byte sem sinal contendo o código da cor do texto e do fundo
		       (criado com a função vga_entry_color)
	retorno:
		inteiro de 1 byte sem sinal contendo os códigos para cor do texto e do fundo
*/

static inline uint16_t vga_entry(unsigned char uc, uint8_t color) 
{
	return (uint16_t) uc | (uint16_t) color << 8;
}

/*
	parâmetro:
		str: ponteiro para uma string
	retorno:
		inteiro com o tamanho da string
*/
size_t strlen(const char* str) 
{
	size_t len = 0;
	while (str[len])
		len++;
	return len;
}


#define VGA_WIDTH   80			// constante com a quantidade de colunas em uma linha
#define VGA_HEIGHT  25			// constante com a quantidade de linhas na tela
#define VGA_MEMORY  0xB8000 	// constante com o endereço da memória do buffer de video

size_t terminal_row;			// armazena a "linha de impressão atual"
size_t terminal_column;			// armazena a "coluna de impressão atual"
uint8_t terminal_color;			// armazena a "atual" 

// ponteiro para a posição da memória do buffer de vídeo
uint16_t* terminal_buffer = (uint16_t*)VGA_MEMORY;

// "inicializa" o terminal (basicamente, limpa a tela)
void terminal_initialize(void) 
{
	terminal_row = 0;
	terminal_column = 0;
	terminal_color = vga_entry_color(VGA_COLOR_LIGHT_GREY, VGA_COLOR_BLACK);
	
	for (size_t y = 0; y < VGA_HEIGHT; y++) {
		for (size_t x = 0; x < VGA_WIDTH; x++) {
			const size_t index = y * VGA_WIDTH + x;
			terminal_buffer[index] = vga_entry(' ', terminal_color);
		}
	}
}

/* define a cor do texto/fundo padrão ("atual")
 	
 	parâmetro:
 		color: inteiro de 1 byte sem sinal contendo o código da cor do texto e do fundo
		       (criado com a função vga_entry_color)
*/
void terminal_setcolor(uint8_t color) 
{
	terminal_color = color;
}

// imprime um caractere (c) na coordenada de tela passada (x e y)
void terminal_putentryat(char c, uint8_t color, size_t x, size_t y) 
{
	const size_t index = y * VGA_WIDTH + x;
	terminal_buffer[index] = vga_entry(c, color);
}

// imprime um caractere (c) na linha e coluna atual 
// variáveis globais terminal_row e terminal_column, respectivamente)
void terminal_putchar(char c) 
{
	// IMPRIME QUEBRA DE LINHA
	// se o caractere for '\n' (em c o compilador interpreta como um único caractere), zera a coluna e avança uma linha
	if (c == '\n') {
		terminal_column = 0;
		terminal_row++;
		// se passar da altura da tela, volta para o começo
		if (terminal_row == VGA_HEIGHT)
			terminal_row = 0;
	} else {
		terminal_putentryat(c, terminal_color, terminal_column, terminal_row);
		if (++terminal_column == VGA_WIDTH) {
			terminal_column = 0;
			if (++terminal_row == VGA_HEIGHT)
			terminal_row = 0;
		}
	}
}


// imprime a string apontada pelo parâmetro "data" na linha e coluna atual 
// (variáveis globais terminal_row e terminal_column, respectivamente).
// é necessário passar o tamanho da string no parâmetro size
void terminal_write(const char* data, size_t size) 
{
	for (size_t i = 0; i < size; i++) {
		terminal_putchar(data[i]);
	}
}

// imprime a string apontada pelo parâmetro "data" na linha e coluna atual 
// (variáveis globais terminal_row e terminal_column, respectivamente).
void terminal_writestring(const char* data) 
{
	terminal_write(data, strlen(data));
}

void terminal_writestring_location(size_t x, size_t y, char* text, uint8_t color) {
	terminal_column = x;
	terminal_row = y;
	terminal_setcolor(color);
	terminal_writestring(text);
}

void terminal_writestring_centered(size_t y, char* text, uint8_t color) {
	terminal_row = y;
	terminal_column = (VGA_WIDTH - strlen(text)) / 2;
	terminal_setcolor(color);
	terminal_writestring(text);
}

void terminal_write_border(char character, uint8_t color) {
    for (size_t x = 0; x < VGA_WIDTH; x++) {
        terminal_putentryat(character, color, x, 0);
    }

    for (size_t x = 0; x < VGA_WIDTH; x++) {
        terminal_putentryat(character, color, x, VGA_HEIGHT - 1);
    }

    for (size_t y = 1; y < VGA_HEIGHT - 1; y++) {
        terminal_putentryat(character, color, 0, y);
        terminal_putentryat(character, color, VGA_WIDTH - 1, y);
    }
}

void terminal_write_rectangle(size_t x, size_t y, uint8_t width, uint8_t height, char character, uint8_t color) {
	terminal_row = y;
	terminal_column = x;
	terminal_setcolor(color);
	for (size_t i = 0; i < width; i++) {
		for (size_t j = 0; j < height; j++) {
			terminal_putentryat(character, color, terminal_column + i, terminal_row + j);
		}
	}
}

void terminal_write_right_triangle(size_t x, size_t y, uint8_t height, char character, uint8_t color) {
	terminal_row = y;
	terminal_column = x;
	uint8_t row_length = 1;
	for (size_t i = 0; i < height; i++) {
		uint8_t characters_put = 0;
		while (characters_put < row_length) {
			terminal_putentryat(character, color, terminal_column + characters_put, terminal_row + i);
			characters_put++;
		}
		row_length++;
	}
}

void main() {
   	terminal_initialize();
   	terminal_writestring("Oi teste");
   	// mudando a cor
   	terminal_setcolor(VGA_COLOR_RED);
   	terminal_writestring("Em vermelho agora");
   	// imprime um X no centro (mais ou menos...) da tela (x: 40 e y: 12)
	terminal_putentryat('X', vga_entry_color(VGA_COLOR_RED, VGA_COLOR_LIGHT_GREY), 40, 12);

   	/* Funções do kernel implementadas */
   	// volta a cor do texto para branco
   	terminal_setcolor(VGA_COLOR_WHITE);
	// 1 - Quebra de linha
   	terminal_writestring("\n\nTem quebra de linha aqui");
	// 2 - Texto nas coordenadas especificadas com cor especificada
   	terminal_writestring_location(15, 15, "Esse texto esta na posicao (15, 15) em magenta", vga_entry_color(VGA_COLOR_MAGENTA, VGA_COLOR_LIGHT_GREY));
	// 3 - Texto centralizado com a cor especificada
	terminal_writestring_centered(12, "Este texto esta sendo escrito a partir do meio da linha", vga_entry_color(VGA_COLOR_LIGHT_CYAN, VGA_COLOR_WHITE));
	// 4 - Borda
	terminal_write_border('#', vga_entry_color(VGA_COLOR_BLACK, VGA_COLOR_LIGHT_CYAN));
	// 5 - Retângulo nas coordenadas especificadas com tamanho especificado com cor especificada
	terminal_write_rectangle(5, 2, 42, 7, '#', vga_entry_color(VGA_COLOR_BLUE, VGA_COLOR_LIGHT_GREY));
	// 6 - Triângulo nas coordenadas especificadas com tamanho especificado com cor especificada
	terminal_write_right_triangle(1, 10, 12, '%', vga_entry_color(VGA_COLOR_RED, VGA_COLOR_WHITE));
}
