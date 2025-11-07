void funcao_vazia() {

}

void main() {
    char* memoria_de_video = (char*)0XB8000;
    *memoria_de_video = 'U';
}