#include <stdio.h>
#include <stdlib.h>
#include "bst.h"
 
No *bst_inserir(No *raiz, Equipamento e, int *status) {
    if (raiz == NULL) {
        No *novo = malloc(sizeof(No));
        if (novo == NULL) {
            *status = 0;
            return NULL;
        }
        novo->dados = e;
        novo->esq = NULL;
        novo->dir = NULL;
        *status = 1;
        return novo;
    }
 
    if (e.id < raiz->dados.id) {
        raiz->esq = bst_inserir(raiz->esq, e, status);

    } else if (e.id > raiz->dados.id) {
        raiz->dir = bst_inserir(raiz->dir, e, status);

    } else {
        *status = 0;   /* ID duplicado */
    }
    return raiz;
}
 
No *bst_buscar(No *raiz, int id) {
    while (raiz != NULL) {
        if (id == raiz->dados.id) {
            return raiz;
        }
        raiz = (id < raiz->dados.id) ? raiz->esq : raiz->dir;
    }
    return NULL;
}
 
No *bst_minimo(No *no) {
    while (no != NULL && no->esq != NULL) {
        no = no->esq;
    }
    return no;
}
 
No *bst_remover(No *raiz, int id, int *removido) {
    if (raiz == NULL) {
        *removido = 0;
        return NULL;
    }
 
    if (id < raiz->dados.id) {
        raiz->esq = bst_remover(raiz->esq, id, removido);

    } else if (id > raiz->dados.id) {
        raiz->dir = bst_remover(raiz->dir, id, removido);
        
    } else {
        *removido = 1;
 
        /* 0 filhos ou so filho direito */
        if (raiz->esq == NULL) {
            No *filho = raiz->dir;
            free(raiz);
            return filho;
        }
        /* so filho esquerdo */
        if (raiz->dir == NULL) {
            No *filho = raiz->esq;
            free(raiz);
            return filho;
        }
        /* 2 filhos: copia o sucessor (menor da subarvore direita) e remove o sucessor */
        No *sucessor = bst_minimo(raiz->dir);
        int ignorado;
        raiz->dados = sucessor->dados;
        raiz->dir = bst_remover(raiz->dir, sucessor->dados.id, &ignorado);
    }
    return raiz;
}
 
void bst_listar_em_ordem(const No *raiz) {
    if (raiz == NULL) {
        return;
    }
    bst_listar_em_ordem(raiz->esq);
    printf("ID: %d | Nome: %s | Tipo: %s | Localizacao: %s\n",
           raiz->dados.id,
           raiz->dados.nome_equipamento,
           raiz->dados.tipo,
           raiz->dados.localizacao);
    bst_listar_em_ordem(raiz->dir);
}
 
void bst_liberar(No *raiz) {
    if (raiz == NULL) {
        return;
    }
    bst_liberar(raiz->esq);
    bst_liberar(raiz->dir);
    free(raiz);
}