
#ifndef ENTRADA_H
#define ENTRADA_H

#include "bst.h"

void remover_espacos_extremos(char *s);
int ler_opcao(void);
int  texto_valido(const char *s);                          // não vazio e até 79 caracteres
int  ler_texto(const char *prompt, char *destino);         // 1 ok, 0 inválido
int  ler_id(const char *prompt, int *id);                  // inteiro > 0, dentro do intervalo de int
int  ler_equipamento(Equipamento *e);                      // usa ler_id e ler_texto
void exibir_menu(void);
void exibir_equipamento(const Equipamento *e);
#endif