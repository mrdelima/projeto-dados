#include <stdio.h>
#include "bst.h"
#include "entrada.h"
#include "estrutura.h"
 
int main(void) {
    No *raiz = NULL;
    Pilha pilha;
    int opcao;
 
    pilha_iniciar(&pilha);
 
    do {
        exibir_menu();
        opcao = ler_opcao();
 
        switch (opcao) {
            case 1: {
                Equipamento e;
                int status = 0;
 
                if (ler_equipamento(&e)) {
                    raiz = bst_inserir(raiz, e, &status);
                    if (status) {
                        printf("Equipamento cadastrado com sucesso.\n");
                    } else {
                        printf("Nao foi possivel cadastrar: ID ja existe (ou falta de memoria).\n");
                    }
                }
                break;
            }
            case 2: {
                int id;
 
                if (!ler_id("ID a buscar: ", &id)) {
                    printf("ID invalido. Use um inteiro positivo.\n");
                } else {
                    No *achado = bst_buscar(raiz, id);
                    if (achado != NULL) {
                        exibir_equipamento(&achado->dados);
                    } else {
                        printf("Equipamento nao encontrado.\n");
                    }
                }
                break;
            }
            case 3: {
                int id;
                int removido = 0;
 
                if (!ler_id("ID a remover: ", &id)) {
                    printf("ID invalido. Use um inteiro positivo.\n");
                } else {
                    raiz = bst_remover(raiz, id, &removido);
                    if (removido) {
                        printf("Registro removido.\n");
                    } else {
                        printf("ID nao encontrado.\n");
                    }
                }
                break;
            }
            case 4:
                if (raiz == NULL) {
                    printf("Nenhum registro cadastrado.\n");
                } else {
                    bst_listar_em_ordem(raiz);
                }
                break;
            case 5: {
                int id;
 
                if (!ler_id("ID para inserir na pilha: ", &id)) {
                    printf("ID invalido. Use um inteiro positivo.\n");
                } else if (pilha_push(&pilha, id)) {
                    printf("ID %d inserido na pilha.\n", id);
                } else {
                    printf("Falta de memoria.\n");
                }
                break;
            }
            case 6: {
                int id;
 
                if (pilha_pop(&pilha, &id)) {
                    printf("ID %d removido da pilha.\n", id);
                } else {
                    printf("Pilha vazia. Nada para remover.\n");
                }
                break;
            }
            case 7:
                pilha_exibir(&pilha);
                break;
            case 0:
                printf("Encerrando...\n");
                break;
            default:
                printf("Opcao invalida. Escolha de 0 a 7.\n");
                break;
        }
        printf("\n");
    } while (opcao != 0);
 
    bst_liberar(raiz);
    pilha_liberar(&pilha);
    return 0;
}