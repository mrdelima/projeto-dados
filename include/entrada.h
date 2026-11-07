#ifndef ENTRADA_H
#define ENTRADA_H

#include "bst.h"

void remover_espacos_extremos(char *s);
int  texto_valido(const char *s);
int  ler_texto(const char *prompt, char *destino);
int  ler_id(const char *prompt, int *id);
int  ler_opcao(void);
int  ler_equipamento(Equipamento *e);
void exibir_menu(void);
void exibir_equipamento(const Equipamento *e);

#endif
