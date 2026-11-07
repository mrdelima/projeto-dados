#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <limits.h>
#include <errno.h>
#include "entrada.h"
 
#define TAM_LINHA 256
 
/* Le uma linha do teclado sem o '\n'.
   Retorna 1 se ok, 0 se a linha era maior que o buffer (o resto e descartado), -1 se EOF. */
static int ler_linha(char *buf, size_t tam) {
    size_t len;
    int c;
 
    if (fgets(buf, (int)tam, stdin) == NULL) {
        return -1;
    }
 
    len = strlen(buf);
    if (len > 0 && buf[len - 1] == '\n') {
        buf[len - 1] = '\0';
        return 1;
    }
 
    if (feof(stdin)) {   /* ultima linha sem '\n' */
        return 1;
    }
 
    /* linha maior que o buffer: descarta o resto */
    while ((c = getchar()) != '\n' && c != EOF) {
    }
    return 0;
}
 
void remover_espacos_extremos(char *s) {
    size_t len = strlen(s);
    size_t ini = 0;
 
    while (len > 0 && isspace((unsigned char)s[len - 1])) {
        len--;
    }
    s[len] = '\0';
 
    while (s[ini] != '\0' && isspace((unsigned char)s[ini])) {
        ini++;
    }
    if (ini > 0) {
        memmove(s, s + ini, strlen(s + ini) + 1);
    }
}
 
int texto_valido(const char *s) {
    size_t len = strlen(s);
    return len > 0 && len < TAM_TEXTO;   /* ate 79 caracteres */
}
 
int ler_texto(const char *prompt, char *destino) {
    char buf[TAM_LINHA];
 
    printf("%s", prompt);
    if (ler_linha(buf, sizeof buf) != 1) {
        return 0;
    }
    remover_espacos_extremos(buf);
    if (!texto_valido(buf)) {
        return 0;
    }
    strcpy(destino, buf);   /* seguro: buf tem no maximo 79 caracteres */
    return 1;
}
 
int ler_id(const char *prompt, int *id) {
    char buf[TAM_LINHA];
    char *fim;
    long valor;
 
    printf("%s", prompt);
    if (ler_linha(buf, sizeof buf) != 1) {
        return 0;
    }
    remover_espacos_extremos(buf);
    if (buf[0] == '\0') {
        return 0;
    }
 
    errno = 0;
    valor = strtol(buf, &fim, 10);
 
    if (fim == buf || *fim != '\0') {          /* texto nao numerico ou com sobra */
        return 0;
    }
    if (errno == ERANGE || valor > INT_MAX) {  /* fora do intervalo de int */
        return 0;
    }
    if (valor <= 0) {                          /* zero ou negativo */
        return 0;
    }
 
    *id = (int)valor;
    return 1;
}
 
int ler_opcao(void) {
    char buf[TAM_LINHA];
    char *fim;
    long valor;
    int r;
 
    printf("Escolha uma opcao: ");
    r = ler_linha(buf, sizeof buf);
    if (r == -1) {
        return 0;    /* EOF (Ctrl+D): encerra o programa normalmente */
    }
    if (r == 0) {
        return -1;
    }
 
    remover_espacos_extremos(buf);
    if (buf[0] == '\0') {
        return -1;
    }
 
    valor = strtol(buf, &fim, 10);
    if (fim == buf || *fim != '\0' || valor < 0 || valor > 7) {
        return -1;
    }
    return (int)valor;
}
 
int ler_equipamento(Equipamento *e) {
    if (!ler_id("ID (inteiro positivo): ", &e->id)) {
        printf("ID invalido. Use um inteiro positivo.\n");
        return 0;
    }
    if (!ler_texto("Nome do equipamento: ", e->nome_equipamento) ||
        !ler_texto("Tipo: ", e->tipo) ||
        !ler_texto("Localizacao: ", e->localizacao)) {
        printf("Texto invalido. Nao pode ser vazio nem ter mais de 79 caracteres.\n");
        return 0;
    }
    return 1;
}
 
void exibir_menu(void) {
    printf("==========================================\n");
    printf("      SISTEMA DE ESTRUTURA DE DADOS\n");
    printf("==========================================\n");
    printf("1 - Cadastrar registro na BST\n");
    printf("2 - Buscar registro por ID na BST\n");
    printf("3 - Remover registro da BST\n");
    printf("4 - Listar registros em-ordem\n");
    printf("5 - Inserir ID na estrutura linear\n");
    printf("6 - Remover da estrutura linear\n");
    printf("7 - Exibir estrutura linear\n");
    printf("0 - Encerrar\n");
    printf("==========================================\n");
}
 
void exibir_equipamento(const Equipamento *e) {
    printf("ID: %d\n", e->id);
    printf("Nome do equipamento: %s\n", e->nome_equipamento);
    printf("Tipo: %s\n", e->tipo);
    printf("Localizacao: %s\n", e->localizacao);
}