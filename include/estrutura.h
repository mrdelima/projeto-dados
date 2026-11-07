#ifndef ESTRUTURA_H
#define ESTRUTURA_H

typedef struct NoLinear {
    int id;
    struct NoLinear *prox;
} NoLinear;

typedef struct {
    NoLinear *topo;
} Pilha;

void pilha_iniciar(Pilha *p);
int  pilha_push(Pilha *p, int id);
int  pilha_pop(Pilha *p, int *id);
void pilha_exibir(const Pilha *p);
void pilha_liberar(Pilha *p);

#endif
