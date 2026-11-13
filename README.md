Projeto Prático de Estrutura de Dados — BST e Pilha

Tema A — Equipamentos de rede

Aluno: Christian de Lima
Curso: ADS — 3º semestre, FATEC Ribeirão Preto
Disciplina: Estrutura de Dados — Prof. Me. Heber Castro
Linguagem: C11, programa de terminal com menu interativo
Descrição

O programa cadastra equipamentos de rede em uma árvore binária de busca (BST) ordenada pelo ID e mantém, de forma independente, uma pilha dinâmica que guarda apenas IDs inteiros positivos.

Cada equipamento tem: ID, nome do equipamento, tipo e localização.

Estrutura do repositório
projeto-dados/
├── include/
│   ├── bst.h          # struct Equipamento, nó da BST e protótipos da BST
│   ├── entrada.h      # leitura e validação de dados digitados
│   └── estrutura.h    # pilha (estrutura linear)
├── src/
│   ├── main.c         # menu e laço principal
│   ├── bst.c          # inserção, busca, remoção, listagem em-ordem e liberação
│   ├── entrada.c      # leitura de linha, validação de ID e de texto
│   └── estrutura.c    # push, pop, exibição e liberação da pilha
├── tests/
│   ├── executar_testes.sh   # roda todos os testes
│   ├── resultados.md        # tabela gerada: entrada, esperado e obtido
│   └── saida/               # entrada e saída completa de cada teste
├── docs/
│   └── relatorio_tecnico.pdf
└── README.md

Ambiente utilizado
Sistema operacional: macOS
Compilador: Apple clang (é o que o comando gcc executa no macOS), no padrão C11
Como compilar e executar

Na raiz do projeto:

bash
gcc -std=c11 -Wall -Wextra -g -Iinclude src/*.c -o programa
./programa

A opção -Iinclude indica onde ficam os arquivos .h.

Menu
1 - Cadastrar registro na BST
2 - Buscar registro por ID na BST
3 - Remover registro da BST
4 - Listar registros em-ordem
5 - Inserir ID na estrutura linear
6 - Remover da estrutura linear
7 - Exibir estrutura linear
0 - Encerrar

Também é possível encerrar com Ctrl+D (fim da entrada). Ao sair, toda a memória alocada é liberada.

Regras de validação
ID (na BST e na pilha): inteiro maior que zero e dentro do intervalo de int. São rejeitados: zero, negativo, texto não numérico (abc, 12abc, 3.5), campo vazio e valores fora do intervalo de int.
ID na BST: além disso, não pode repetir um ID já cadastrado.
ID na pilha: repetidos são permitidos, e a pilha não depende da BST (um ID da pilha não precisa existir na árvore).
Textos (nome, tipo e localização): de 1 a 79 caracteres depois de remover os espaços das pontas. Espaços internos são permitidos. Texto vazio ou só com espaços é rejeitado. Cada texto é guardado em char[80].
Linhas muito longas: uma linha digitada com mais de 255 caracteres é rejeitada e o restante dela é descartado.
Estruturas de dados
BST: cada nó guarda um Equipamento e dois ponteiros (esquerdo e direito). Operações: inserir, buscar por ID, remover (nó folha, com um filho e com dois filhos, usando o menor nó da subárvore direita) e listar em-ordem.
Pilha (estrutura linear): lista encadeada com ponteiro para o topo. Operações: push, pop e exibição do topo à base. Remover de uma pilha vazia mostra um aviso e o programa continua.
Como reproduzir os testes

Na raiz do projeto:

bash
bash tests/executar_testes.sh

O script compila o programa, executa os testes automaticamente (a entrada de cada teste é enviada ao programa pela entrada padrão) e mostra PASS ou FAIL para cada um. Ele gera:

tests/resultados.md: tabela com entrada, resultado esperado e resultado obtido de cada teste, com a data, o sistema e o compilador usados;
tests/saida/: a entrada (*.entrada.txt) e a saída completa (*.txt) de cada teste.

Os testes cobrem: cadastro, busca e listagem em-ordem; remoção de folha, de nó com um filho (esquerdo e direito), de raiz e de nó com dois filhos; ID duplicado; IDs inválidos; textos inválidos e no limite de tamanho; menu inválido; pilha com IDs repetidos, remoção e exibição; pilha vazia; independência entre a pilha e a BST; e encerramento sem vazamento de memória.

O último teste usa leaks (macOS) ou valgrind (Linux), o que estiver instalado. Para rodá-lo manualmente:

bash
leaks --atExit -- ./programa          # macOS
valgrind --leak-check=full ./programa # Linux

O resultado esperado do leaks é a linha 0 leaks for 0 total leaked bytes.

Observações
Sinal e zeros à esquerda são aceitos na conversão do ID: +5 e 007 valem 5 e 7.
Se o cadastro na BST falhar, a mensagem informa que o ID já existe ou que faltou memória, porque as duas situações devolvem o mesmo código de falha.