#!/usr/bin/env bash

# ============================================================
# PIPELINE DE ANALISIS DE SECUENCIAS PROTEICAS Y CODIFICANTES
# Bioinformatica 1
#
# Herramientas:
# - Bash
# - Entrez Direct (efetch)
# - BioAWK
# - grep
#
# Automatiza la descarga y el analisis de las secuencias de
# SnRK1/KIN10 y TOR de Arabidopsis thaliana desde NCBI.
# ============================================================

set -Eeuo pipefail

# El directorio del proyecto se determina a partir de la
# ubicacion de este script, independientemente desde donde
# se lo ejecute.
ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
DATA_DIR="$ROOT_DIR/data"
mkdir -p "$DATA_DIR"

# ------------------------------------------------------------
# 1. VERIFICACION DE HERRAMIENTAS
# ------------------------------------------------------------

echo "=============================================="
echo "PIPELINE DE BIOINFORMATICA 1"
echo "=============================================="
echo ""
echo "Verificando herramientas necesarias..."

for herramienta in efetch bioawk grep; do
    if ! command -v "$herramienta" >/dev/null 2>&1; then
        echo "Error: no se encontro la herramienta '$herramienta'." >&2
        echo "Instale la herramienta y vuelva a ejecutar el pipeline." >&2
        exit 1
    fi
done

echo "Herramientas verificadas correctamente."

# ------------------------------------------------------------
# 2. DESCARGA DE SECUENCIAS DESDE NCBI
# ------------------------------------------------------------

echo ""
echo "Descargando secuencias desde NCBI..."

descargar_fasta() {
    local base_datos="$1"
    local identificador="$2"
    local formato="$3"
    local archivo="$4"
    local temporal="${archivo}.tmp"

    echo "  - Descargando $archivo..."

    if ! efetch -db "$base_datos" -id "$identificador" -format "$formato" > "$temporal"; then
        rm -f "$temporal"
        echo "Error: fallo la descarga de $identificador desde NCBI." >&2
        exit 1
    fi

    if [[ ! -s "$temporal" ]] || ! grep -q '^>' "$temporal"; then
        rm -f "$temporal"
        echo "Error: la descarga de $identificador esta vacia o no tiene formato FASTA." >&2
        exit 1
    fi

    mv "$temporal" "$archivo"
}

descargar_fasta protein Q38997.3 fasta \
    "$DATA_DIR/snrk1_kin10.fasta"

descargar_fasta protein Q9FR53.1 fasta \
    "$DATA_DIR/tor_arabidopsis.fasta"

# fasta_cds_na descarga la region codificante (CDS) en nucleotidos.
# Se conservan los nombres originales usados en el trabajo.
descargar_fasta nuccore NM_001125074.2 fasta_cds_na \
    "$DATA_DIR/KIN10_ARNm.fasta"

descargar_fasta nuccore NM_103891.4 fasta_cds_na \
    "$DATA_DIR/TOR_ARNm.fasta"

echo "Descarga completada correctamente."

# ------------------------------------------------------------
# 3. BUSQUEDA DE SITIOS DE INTERES
# ------------------------------------------------------------

echo ""
echo "=============================================="
echo "BUSQUEDA DE SITIOS DE INTERES"
echo "=============================================="

echo ""
echo "Sitio de interes en SnRK1/KIN10 (TSCGSPNYAAPE):"

bioawk -c fastx '{print $seq}' "$DATA_DIR/snrk1_kin10.fasta" |
    { grep -oE 'TSCGSPNYAAPE' || true; } |
    wc -l

echo ""
echo "Patrones WHE[A-Z] encontrados en TOR:"

bioawk -c fastx '{print $seq}' "$DATA_DIR/tor_arabidopsis.fasta" |
    { grep -oE 'WHE[A-Z]' || true; } |
    wc -l

echo "Coincidencias encontradas."

# ------------------------------------------------------------
# 4. CANTIDAD Y LONGITUD DE SECUENCIAS
# ------------------------------------------------------------

ARCHIVOS=(
    "$DATA_DIR/snrk1_kin10.fasta"
    "$DATA_DIR/tor_arabidopsis.fasta"
    "$DATA_DIR/KIN10_ARNm.fasta"
    "$DATA_DIR/TOR_ARNm.fasta"
)

echo ""
echo "=============================================="
echo "CANTIDAD DE SECUENCIAS"
echo "=============================================="

for archivo in "${ARCHIVOS[@]}"; do
    echo "$(basename "$archivo"):"
    bioawk -c fastx 'END {print NR}' "$archivo"
done

echo ""
echo "=============================================="
echo "LONGITUD DE LAS SECUENCIAS"
echo "=============================================="

for archivo in "${ARCHIVOS[@]}"; do
    echo "$(basename "$archivo"):"
    bioawk -c fastx '{print $name, length($seq)}' "$archivo"
done

# ------------------------------------------------------------
# 5. PORCENTAJE GC DE LAS CDS
# ------------------------------------------------------------

echo ""
echo "=============================================="
echo "PORCENTAJE GC DE LAS CDS"
echo "=============================================="

for archivo in "$DATA_DIR/KIN10_ARNm.fasta" "$DATA_DIR/TOR_ARNm.fasta"; do
    echo ""
    echo "$(basename "$archivo"):"

    bioawk -c fastx '{
        s = toupper($seq)

        copia_total = s
        copia_gc = s

        total = gsub(/[ACGT]/, "", copia_total)
        cantidad_gc = gsub(/[GC]/, "", copia_gc)

        if (total > 0)
            printf "%s\t%.2f%%\n", $name, (cantidad_gc/total)*100
    }' "$archivo"
done

# ------------------------------------------------------------
# 6. COMPOSICION DE AMINOACIDOS DE LAS PROTEINAS
# ------------------------------------------------------------

echo ""
echo "=============================================="
echo "COMPOSICION DE AMINOACIDOS"
echo "=============================================="

for archivo in "$DATA_DIR/snrk1_kin10.fasta" "$DATA_DIR/tor_arabidopsis.fasta"; do
    echo ""
    echo "Analizando $(basename "$archivo")..."

    bioawk -c fastx '{
        s = toupper($seq)
        n = length(s)

        print "\n" $name

        for (i = 1; i <= 20; i++) {
            aa = substr("ACDEFGHIKLMNPQRSTVWY", i, 1)

            copia = s
            cantidad = gsub(aa, "", copia)

            if (n > 0)
                printf "%s: %d (%.2f%%)\n", aa, cantidad, cantidad/n*100
        }
    }' "$archivo"
done

# ------------------------------------------------------------
# 7. FINALIZACION
# ------------------------------------------------------------

echo ""
echo "=============================================="
echo "Pipeline finalizado correctamente."
echo "Los archivos FASTA se encuentran en: $DATA_DIR"
echo "=============================================="
