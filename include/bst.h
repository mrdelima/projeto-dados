#ifndef BST_H
#define BST_H

#define TAM_TEXTO 80   // 79 caracteres + '\0'

typedef struct {
    int  id;
    char nome_equipamento[TAM_TEXTO];
    char tipo[TAM_TEXTO];
    char localizacao[TAM_TEXTO];
} Equipamento;

typedef struct No {
    Equipamento dados;
    struct No *esq;
    struct No *dir;
} No;

No   *bst_inserir(No *raiz, Equipamento e, int *status);  // status: 1 inseriu, 0 ID duplicado (ou falha de malloc)
No   *bst_buscar(No *raiz, int id);                       // NULL se não achar
No   *bst_remover(No *raiz, int id, int *removido);       // removido: 1 ou 0
No   *bst_minimo(No *no);                                 // auxiliar da remoção com 2 filhos
void  bst_listar_em_ordem(const No *raiz);
void  bst_liberar(No *raiz);

#endif