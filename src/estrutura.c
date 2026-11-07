#include <stdio.h>
#include <stdlib.h>
#include "estrutura.h"
 
void pilha_iniciar(Pilha *p) {
    p->topo = NULL;
}
 
int pilha_push(Pilha *p, int id) {
    NoLinear *novo = malloc(sizeof(NoLinear));
    if (novo == NULL) {
        return 0;
    }
    novo->id = id;
    novo->prox = p->topo;
    p->topo = novo;
    return 1;
}
 
int pilha_pop(Pilha *p, int *id) {
    NoLinear *remover;
 
    if (p->topo == NULL) {
        return 0;
    }
    remover = p->topo;
    *id = remover->id;
    p->topo = remover->prox;
    free(remover);
    return 1;
}
 
void pilha_exibir(const Pilha *p) {
    const NoLinear *atual = p->topo;
 
    if (atual == NULL) {
        printf("Pilha vazia.\n");
        return;
    }
    printf("Topo -> Base: ");
    while (atual != NULL) {
        printf("%d ", atual->id);
        atual = atual->prox;
    }
    printf("\n");
}
 
void pilha_liberar(Pilha *p) {
    int descartado;
    while (pilha_pop(p, &descartado)) {
    }
}