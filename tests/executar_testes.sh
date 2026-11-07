#!/bin/bash
# Testes do projeto: Equipamentos de rede (BST + pilha).
# Uso, na raiz do projeto:   bash tests/executar_testes.sh
# Gera:
#   tests/resultados.md  -> tabela com entrada, esperado e obtido de cada teste
#   tests/saida/         -> entrada e saida completa de cada teste

cd "$(dirname "$0")/.." || exit 1

PROG=./programa
SAIDA=tests/saida
MD=tests/resultados.md

echo "Compilando..."
gcc -std=c11 -Wall -Wextra -g -Iinclude src/*.c -o programa || { echo "Falha na compilacao."; exit 1; }

rm -rf "$SAIDA"
mkdir -p "$SAIDA"
TMP="$SAIDA/entrada_atual.txt"

{
    echo "# Resultados dos testes"
    echo
    echo "- Data: $(date '+%d/%m/%Y %H:%M')"
    echo "- Sistema: $(uname -srm)"
    echo "- Compilador: $(gcc --version | head -n 1)"
    echo
    echo "Cada item da coluna Entrada e uma linha digitada pelo usuario (separadas por /)."
    echo "No menu: 1 cadastrar, 2 buscar, 3 remover, 4 listar, 5 inserir na pilha, 6 remover da pilha, 7 exibir pilha, 0 encerrar."
    echo
    echo "| ID | Cenario | Entrada | Esperado | Obtido |"
    echo "| --- | --- | --- | --- | --- |"
} > "$MD"

TOTAL=0
FALHAS=0

# ---------- auxiliares para montar a entrada ----------
lin() { printf '%s\n' "$@"; }                                                   # cada argumento vira uma linha
cad() { printf '%s\n' 1 "$1" "${2:-Equip $1}" "${3:-Tipo}" "${4:-Local}"; }     # opcao 1 + ID, nome, tipo, local

# ---------- registro do resultado ----------
registrar() {   # id cenario esperado resultado
    local resumo
    resumo=$(paste -sd'/' "$TMP")
    if [ -z "$resumo" ]; then resumo="(vazia)"; fi
    if [ ${#resumo} -gt 90 ]; then resumo="${resumo:0:90}..."; fi
    echo "| $1 | $2 | \`$resumo\` | $3 | $4 |" >> "$MD"
}

# rodar_teste ID "cenario" esperado...    (a entrada esta em $TMP)
# Esperado: texto simples (aparece na saida), LINHA:texto (linha exata),
#           ORDEM:ids (IDs da listagem em-ordem), NAO:texto (nao pode aparecer).
rodar_teste() {
    local id="$1" cenario="$2"
    shift 2
    local saida="$SAIDA/$id.txt"
    local ok=1 motivo="" desc_esp="" codigo esp texto esperado obtido

    cp "$TMP" "$SAIDA/$id.entrada.txt"
    $PROG < "$TMP" > "$saida" 2>&1
    codigo=$?
    if [ "$codigo" -ne 0 ]; then ok=0; motivo="$motivo codigo de saida $codigo;"; fi

    for esp in "$@"; do
        case "$esp" in
            LINHA:*)
                # a linha precisa TERMINAR com o texto (sem espacos sobrando no fim);
                # o inicio pode vir colado no prompt, pois a entrada redirecionada nao ecoa o Enter
                texto="${esp#LINHA:}"
                desc_esp="${desc_esp:+$desc_esp; }linha: $texto"
                awk -v t="$texto" '{ n = length($0); m = length(t); if (n >= m && substr($0, n - m + 1) == t) achou = 1 } END { exit !achou }' "$saida" \
                    || { ok=0; motivo="$motivo faltou a linha: $texto;"; }
                ;;
            ORDEM:*)
                esperado="${esp#ORDEM:}"
                desc_esp="${desc_esp:+$desc_esp; }IDs em ordem: $esperado"
                obtido=$(grep -o 'ID: [0-9][0-9]* |' "$saida" | sed 's/ID: \([0-9]*\) |/\1/' | tr '\n' ' ' | sed 's/ $//')
                [ "$obtido" = "$esperado" ] || { ok=0; motivo="$motivo ordem obtida: $obtido;"; }
                ;;
            NAO:*)
                texto="${esp#NAO:}"
                desc_esp="${desc_esp:+$desc_esp; }nao exibe: $texto"
                if grep -Fq -- "$texto" "$saida"; then ok=0; motivo="$motivo apareceu: $texto;"; fi
                ;;
            *)
                desc_esp="${desc_esp:+$desc_esp; }$esp"
                grep -Fq -- "$esp" "$saida" || { ok=0; motivo="$motivo faltou: $esp;"; }
                ;;
        esac
    done

    TOTAL=$((TOTAL + 1))
    if [ $ok -eq 1 ]; then
        echo "PASS  $id  $cenario"
        registrar "$id" "$cenario" "$desc_esp" "PASS"
    else
        FALHAS=$((FALHAS + 1))
        echo "FAIL  $id  $cenario  ->$motivo"
        registrar "$id" "$cenario" "$desc_esp" "FAIL ($motivo)"
    fi
}

# Teste de memoria: usa leaks (macOS) ou valgrind (Linux), se disponivel.
teste_memoria() {   # id cenario
    local id="$1" cenario="$2" saida="$SAIDA/$1.txt" esperado resultado
    cp "$TMP" "$SAIDA/$id.entrada.txt"

    if command -v leaks > /dev/null 2>&1; then
        esperado="0 leaks for 0 total leaked bytes"
        leaks --atExit -- $PROG < "$TMP" > "$saida" 2>&1
        if grep -Fq "$esperado" "$saida"; then resultado="PASS"; else resultado="FAIL"; fi
    elif command -v valgrind > /dev/null 2>&1; then
        esperado="All heap blocks were freed -- no leaks are possible"
        valgrind --leak-check=full --error-exitcode=2 $PROG < "$TMP" > "$saida" 2>&1
        if [ $? -eq 0 ] && grep -Fq "$esperado" "$saida"; then resultado="PASS"; else resultado="FAIL"; fi
    else
        esperado="0 leaks (leaks) ou sem blocos perdidos (valgrind)"
        resultado="SKIP (nem leaks nem valgrind disponiveis)"
    fi

    if [ "${resultado%% *}" != "SKIP" ]; then TOTAL=$((TOTAL + 1)); fi
    if [ "$resultado" = "FAIL" ]; then FALHAS=$((FALHAS + 1)); fi
    echo "${resultado%% *}  $id  $cenario"
    registrar "$id" "$cenario" "$esperado" "$resultado"
}

N79=$(printf 'A%.0s' $(seq 1 79))
N80=$(printf 'A%.0s' $(seq 1 80))
N300=$(printf 'A%.0s' $(seq 1 300))

# =====================  BST  =====================
{ cad 10 "Roteador Central" Roteador "Sala 1"; lin 2 10 0; } > "$TMP"
rodar_teste T01 "Cadastra o ID 10 e busca o ID 10" \
    "Equipamento cadastrado com sucesso." \
    "LINHA:Nome do equipamento: Roteador Central" \
    "LINHA:Tipo: Roteador" \
    "LINHA:Localizacao: Sala 1"

lin 4 0 > "$TMP"
rodar_teste T02 "Lista em-ordem com a BST vazia" "Nenhum registro cadastrado."

{ cad 50; cad 30; cad 70; cad 20; cad 40; cad 60; cad 80; lin 4 0; } > "$TMP"
rodar_teste T03 "Cadastra 50, 30, 70, 20, 40, 60, 80 e lista em-ordem" "ORDEM:20 30 40 50 60 70 80"

{ cad 10; lin 2 99 0; } > "$TMP"
rodar_teste T04 "Busca de ID que nao existe" "Equipamento nao encontrado."

{ cad 10 Primeiro; cad 10 Segundo; lin 4 0; } > "$TMP"
rodar_teste T05 "Cadastro de ID duplicado e rejeitado" \
    "Nao foi possivel cadastrar: ID ja existe" "ORDEM:10" "Nome: Primeiro" "NAO:Segundo"

{ cad 50; cad 30; cad 70; lin 3 30 4 0; } > "$TMP"
rodar_teste T06 "Remove folha (30)" "Registro removido." "ORDEM:50 70"

{ cad 50; cad 30; cad 20; lin 3 30 4 0; } > "$TMP"
rodar_teste T07 "Remove no com so filho esquerdo (30)" "Registro removido." "ORDEM:20 50"

{ cad 50; cad 70; cad 80; lin 3 70 4 0; } > "$TMP"
rodar_teste T08 "Remove no com so filho direito (70)" "Registro removido." "ORDEM:50 80"

{ cad 50; cad 30; lin 3 50 4 0; } > "$TMP"
rodar_teste T09 "Remove a raiz (50) que tem um filho" "Registro removido." "ORDEM:30"

{ cad 50; cad 30; cad 70; cad 20; cad 40; cad 60; cad 80; lin 3 50 2 60 4 0; } > "$TMP"
rodar_teste T10 "Remove a raiz (50) com dois filhos, busca 60 e lista" \
    "Registro removido." "LINHA:Nome do equipamento: Equip 60" "ORDEM:20 30 40 60 70 80"

{ cad 50; cad 30; cad 70; cad 20; cad 40; cad 60; cad 80; lin 3 70 4 0; } > "$TMP"
rodar_teste T11 "Remove no interno (70) com dois filhos" "Registro removido." "ORDEM:20 30 40 50 60 80"

{ cad 10; lin 3 99 4 0; } > "$TMP"
rodar_teste T12 "Remocao de ID que nao existe" "ID nao encontrado." "ORDEM:10"

{ cad 10; lin 3 10 4 0; } > "$TMP"
rodar_teste T13 "Remove o unico registro e lista" "Registro removido." "Nenhum registro cadastrado."

# =====================  Validacao de ID  =====================
INVALIDOS=("abc" "0" "-5" "3.5" "12abc" "" "   " "99999999999" "2147483648" "1 2")
i=0
for v in "${INVALIDOS[@]}"; do
    i=$((i + 1))
    lin 1 "$v" 0 > "$TMP"
    rodar_teste "T14-$i" "ID invalido no cadastro: \"$v\"" "ID invalido. Use um inteiro positivo."
done

{ lin 1 2147483647 Maior Tipo Local 2 2147483647 0; } > "$TMP"
rodar_teste T15 "ID no limite do int (2147483647) e aceito" \
    "Equipamento cadastrado com sucesso." "LINHA:ID: 2147483647"

lin 2 abc 3 abc 0 > "$TMP"
rodar_teste T16 "ID invalido na busca e na remocao" "ID invalido. Use um inteiro positivo." "NAO:nao encontrado"

# =====================  Validacao de texto  =====================
lin 1 10 "" 0 > "$TMP"
rodar_teste T17 "Nome vazio" "Texto invalido"

lin 1 10 "   " 0 > "$TMP"
rodar_teste T18 "Nome so com espacos" "Texto invalido"

lin 1 10 "$N80" 0 > "$TMP"
rodar_teste T19 "Nome com 80 caracteres (limite e 79)" "Texto invalido"

lin 1 10 Nome "" 0 > "$TMP"
rodar_teste T20 "Tipo vazio" "Texto invalido"

lin 1 10 Nome Tipo "" 0 > "$TMP"
rodar_teste T21 "Localizacao vazia" "Texto invalido"

lin 1 10 "$N79" Tipo Local 2 10 0 > "$TMP"
rodar_teste T22 "Nome com 79 caracteres e aceito" \
    "Equipamento cadastrado com sucesso." "LINHA:Nome do equipamento: $N79"

lin 1 10 "   Switch X   " "  Tipo Y  " "  Sala Z  " 2 10 0 > "$TMP"
rodar_teste T23 "Espacos nas extremidades sao removidos (espacos internos ficam)" \
    "LINHA:Nome do equipamento: Switch X" "LINHA:Tipo: Tipo Y" "LINHA:Localizacao: Sala Z"

lin 1 10 "$N300" 4 0 > "$TMP"
rodar_teste T24 "Linha de 300 caracteres e rejeitada e o resto nao vira opcao do menu" \
    "Texto invalido" "Nenhum registro cadastrado." "NAO:Opcao invalida"

# =====================  Menu  =====================
lin 9 abc "" -1 8 0 > "$TMP"
rodar_teste T25 "Opcoes de menu invalidas" "Opcao invalida. Escolha de 0 a 7." "Encerrando..."

lin 0 > "$TMP"
rodar_teste T26 "Encerra pela opcao 0" "Encerrando..."

: > "$TMP"
rodar_teste T27 "Fim da entrada (Ctrl+D) encerra o programa" "Encerrando..."

# =====================  Pilha  =====================
lin 5 1 5 2 5 3 5 2 7 0 > "$TMP"
rodar_teste T28 "Empilha 1, 2, 3, 2 (repetidos permitidos) e exibe do topo a base" \
    "ID 1 inserido na pilha." "Topo -> Base: 2 3 2 1"

lin 5 1 5 2 5 3 6 7 0 > "$TMP"
rodar_teste T29 "Empilha 1, 2, 3, desempilha e exibe" "ID 3 removido da pilha." "Topo -> Base: 2 1"

lin 6 0 > "$TMP"
rodar_teste T30 "Remove com a pilha vazia (programa continua)" "Pilha vazia. Nada para remover." "Encerrando..."

lin 7 0 > "$TMP"
rodar_teste T31 "Exibe a pilha vazia" "LINHA:Pilha vazia."

lin 5 4 6 6 7 0 > "$TMP"
rodar_teste T32 "Esvazia a pilha e tenta remover de novo" \
    "ID 4 removido da pilha." "Pilha vazia. Nada para remover." "LINHA:Pilha vazia."

lin 5 abc 5 0 5 -1 7 0 > "$TMP"
rodar_teste T33 "ID invalido na pilha nao e inserido" "ID invalido. Use um inteiro positivo." "LINHA:Pilha vazia."

{ cad 10; lin 5 10 5 999 3 10 7 0; } > "$TMP"
rodar_teste T34 "Pilha e independente da BST (ID 999 nao existe; ID 10 fica apos sair da BST)" \
    "ID 999 inserido na pilha." "Registro removido." "Topo -> Base: 999 10"

# =====================  Memoria  =====================
{ cad 50; cad 30; cad 70; cad 20; cad 40; lin 5 1 5 2 5 3 3 50 3 20 6 4 7 0; } > "$TMP"
teste_memoria T35 "Encerra sem vazamento (BST e pilha ainda preenchidas ao sair)"

rm -f "$TMP"

{
    echo
    echo "Total de testes executados: $TOTAL. Falhas: $FALHAS."
} >> "$MD"

echo
echo "Testes executados: $TOTAL | Falhas: $FALHAS"
echo "Tabela gerada em $MD"
[ "$FALHAS" -eq 0 ]