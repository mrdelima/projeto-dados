# Resultados dos testes

- Data: 07/11/2026 14:57
- Sistema: Darwin 25.6.0 arm64
- Compilador: Apple clang version 17.0.0 (clang-1700.6.3.2)

Cada item da coluna Entrada e uma linha digitada pelo usuario (separadas por /).
No menu: 1 cadastrar, 2 buscar, 3 remover, 4 listar, 5 inserir na pilha, 6 remover da pilha, 7 exibir pilha, 0 encerrar.

| ID | Cenario | Entrada | Esperado | Obtido |
| --- | --- | --- | --- | --- |
| T01 | Cadastra o ID 10 e busca o ID 10 | `1/10/Roteador Central/Roteador/Sala 1/2/10/0` | Equipamento cadastrado com sucesso.; linha: Nome do equipamento: Roteador Central; linha: Tipo: Roteador; linha: Localizacao: Sala 1 | PASS |
| T02 | Lista em-ordem com a BST vazia | `4/0` | Nenhum registro cadastrado. | PASS |
| T03 | Cadastra 50, 30, 70, 20, 40, 60, 80 e lista em-ordem | `1/50/Equip 50/Tipo/Local/1/30/Equip 30/Tipo/Local/1/70/Equip 70/Tipo/Local/1/20/Equip 20/T...` | IDs em ordem: 20 30 40 50 60 70 80 | PASS |
| T04 | Busca de ID que nao existe | `1/10/Equip 10/Tipo/Local/2/99/0` | Equipamento nao encontrado. | PASS |
| T05 | Cadastro de ID duplicado e rejeitado | `1/10/Primeiro/Tipo/Local/1/10/Segundo/Tipo/Local/4/0` | Nao foi possivel cadastrar: ID ja existe; IDs em ordem: 10; Nome: Primeiro; nao exibe: Segundo | PASS |
| T06 | Remove folha (30) | `1/50/Equip 50/Tipo/Local/1/30/Equip 30/Tipo/Local/1/70/Equip 70/Tipo/Local/3/30/4/0` | Registro removido.; IDs em ordem: 50 70 | PASS |
| T07 | Remove no com so filho esquerdo (30) | `1/50/Equip 50/Tipo/Local/1/30/Equip 30/Tipo/Local/1/20/Equip 20/Tipo/Local/3/30/4/0` | Registro removido.; IDs em ordem: 20 50 | PASS |
| T08 | Remove no com so filho direito (70) | `1/50/Equip 50/Tipo/Local/1/70/Equip 70/Tipo/Local/1/80/Equip 80/Tipo/Local/3/70/4/0` | Registro removido.; IDs em ordem: 50 80 | PASS |
| T09 | Remove a raiz (50) que tem um filho | `1/50/Equip 50/Tipo/Local/1/30/Equip 30/Tipo/Local/3/50/4/0` | Registro removido.; IDs em ordem: 30 | PASS |
| T10 | Remove a raiz (50) com dois filhos, busca 60 e lista | `1/50/Equip 50/Tipo/Local/1/30/Equip 30/Tipo/Local/1/70/Equip 70/Tipo/Local/1/20/Equip 20/T...` | Registro removido.; linha: Nome do equipamento: Equip 60; IDs em ordem: 20 30 40 60 70 80 | PASS |
| T11 | Remove no interno (70) com dois filhos | `1/50/Equip 50/Tipo/Local/1/30/Equip 30/Tipo/Local/1/70/Equip 70/Tipo/Local/1/20/Equip 20/T...` | Registro removido.; IDs em ordem: 20 30 40 50 60 80 | PASS |
| T12 | Remocao de ID que nao existe | `1/10/Equip 10/Tipo/Local/3/99/4/0` | ID nao encontrado.; IDs em ordem: 10 | PASS |
| T13 | Remove o unico registro e lista | `1/10/Equip 10/Tipo/Local/3/10/4/0` | Registro removido.; Nenhum registro cadastrado. | PASS |
| T14-1 | ID invalido no cadastro: "abc" | `1/abc/0` | ID invalido. Use um inteiro positivo. | PASS |
| T14-2 | ID invalido no cadastro: "0" | `1/0/0` | ID invalido. Use um inteiro positivo. | PASS |
| T14-3 | ID invalido no cadastro: "-5" | `1/-5/0` | ID invalido. Use um inteiro positivo. | PASS |
| T14-4 | ID invalido no cadastro: "3.5" | `1/3.5/0` | ID invalido. Use um inteiro positivo. | PASS |
| T14-5 | ID invalido no cadastro: "12abc" | `1/12abc/0` | ID invalido. Use um inteiro positivo. | PASS |
| T14-6 | ID invalido no cadastro: "" | `1//0` | ID invalido. Use um inteiro positivo. | PASS |
| T14-7 | ID invalido no cadastro: "   " | `1/   /0` | ID invalido. Use um inteiro positivo. | PASS |
| T14-8 | ID invalido no cadastro: "99999999999" | `1/99999999999/0` | ID invalido. Use um inteiro positivo. | PASS |
| T14-9 | ID invalido no cadastro: "2147483648" | `1/2147483648/0` | ID invalido. Use um inteiro positivo. | PASS |
| T14-10 | ID invalido no cadastro: "1 2" | `1/1 2/0` | ID invalido. Use um inteiro positivo. | PASS |
| T15 | ID no limite do int (2147483647) e aceito | `1/2147483647/Maior/Tipo/Local/2/2147483647/0` | Equipamento cadastrado com sucesso.; linha: ID: 2147483647 | PASS |
| T16 | ID invalido na busca e na remocao | `2/abc/3/abc/0` | ID invalido. Use um inteiro positivo.; nao exibe: nao encontrado | PASS |
| T17 | Nome vazio | `1/10//0` | Texto invalido | PASS |
| T18 | Nome so com espacos | `1/10/   /0` | Texto invalido | PASS |
| T19 | Nome com 80 caracteres (limite e 79) | `1/10/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA/0` | Texto invalido | PASS |
| T20 | Tipo vazio | `1/10/Nome//0` | Texto invalido | PASS |
| T21 | Localizacao vazia | `1/10/Nome/Tipo//0` | Texto invalido | PASS |
| T22 | Nome com 79 caracteres e aceito | `1/10/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA/Tipo/...` | Equipamento cadastrado com sucesso.; linha: Nome do equipamento: AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA | PASS |
| T23 | Espacos nas extremidades sao removidos (espacos internos ficam) | `1/10/   Switch X   /  Tipo Y  /  Sala Z  /2/10/0` | linha: Nome do equipamento: Switch X; linha: Tipo: Tipo Y; linha: Localizacao: Sala Z | PASS |
| T24 | Linha de 300 caracteres e rejeitada e o resto nao vira opcao do menu | `1/10/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA...` | Texto invalido; Nenhum registro cadastrado.; nao exibe: Opcao invalida | PASS |
| T25 | Opcoes de menu invalidas | `9/abc//-1/8/0` | Opcao invalida. Escolha de 0 a 7.; Encerrando... | PASS |
| T26 | Encerra pela opcao 0 | `0` | Encerrando... | PASS |
| T27 | Fim da entrada (Ctrl+D) encerra o programa | `(vazia)` | Encerrando... | PASS |
| T28 | Empilha 1, 2, 3, 2 (repetidos permitidos) e exibe do topo a base | `5/1/5/2/5/3/5/2/7/0` | ID 1 inserido na pilha.; Topo -> Base: 2 3 2 1 | PASS |
| T29 | Empilha 1, 2, 3, desempilha e exibe | `5/1/5/2/5/3/6/7/0` | ID 3 removido da pilha.; Topo -> Base: 2 1 | PASS |
| T30 | Remove com a pilha vazia (programa continua) | `6/0` | Pilha vazia. Nada para remover.; Encerrando... | PASS |
| T31 | Exibe a pilha vazia | `7/0` | linha: Pilha vazia. | PASS |
| T32 | Esvazia a pilha e tenta remover de novo | `5/4/6/6/7/0` | ID 4 removido da pilha.; Pilha vazia. Nada para remover.; linha: Pilha vazia. | PASS |
| T33 | ID invalido na pilha nao e inserido | `5/abc/5/0/5/-1/7/0` | ID invalido. Use um inteiro positivo.; linha: Pilha vazia. | PASS |
| T34 | Pilha e independente da BST (ID 999 nao existe; ID 10 fica apos sair da BST) | `1/10/Equip 10/Tipo/Local/5/10/5/999/3/10/7/0` | ID 999 inserido na pilha.; Registro removido.; Topo -> Base: 999 10 | PASS |
| T35 | Encerra sem vazamento (BST e pilha ainda preenchidas ao sair) | `1/50/Equip 50/Tipo/Local/1/30/Equip 30/Tipo/Local/1/70/Equip 70/Tipo/Local/1/20/Equip 20/T...` | 0 leaks for 0 total leaked bytes | PASS |

Total de testes executados: 44. Falhas: 0.
