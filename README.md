# Análisis bioinformático de las proteínas TOR y SnRK1/KIN10 en *Arabidopsis thaliana*

## 1. Descripción del proyecto

Este trabajo práctico final tiene como objetivo realizar un análisis bioinformático de las proteínas TOR (Target of Rapamycin) y SnRK1/KIN10 (SNF1-related protein kinase 1) de la especie vegetal *Arabidopsis thaliana*.

Se estudian sus secuencias nucleotídicas y proteicas mediante diferentes herramientas de bioinformática, con el propósito de caracterizar sus propiedades moleculares y explorar sus estructuras tridimensionales.

Los análisis realizados incluyen:

- Descarga de secuencias desde bases de datos biológicas.
- Determinación de la longitud de las secuencias.
- Cálculo del contenido GC de las regiones codificantes.
- Análisis de la composición de aminoácidos.
- Búsqueda de motivos específicos en las secuencias proteicas.
- Visualización y exploración de modelos estructurales tridimensionales mediante UCSF ChimeraX.

## 2. Organización del proyecto

El proyecto se organiza mediante la siguiente estructura de directorios:

```text
Proyecto_Final_Bioinformatica_1/
│
├── README.md
├── .gitignore
│
├── data/
│   └── raw/
│       ├── snrk1_kin10.fasta
│       ├── tor_arabidopsis.fasta
│       ├── KIN10_ARNm.fasta
│       └── TOR_ARNm.fasta
│
├── scripts/
│   └── pipeline.sh
│
├── estructuras/
│   ├── KIN10_AlphaFold.cif
│   └── TOR_AlphaFold.cif
│
├── results/
│   ├── KIN10_cartoon.png
│   ├── KIN10_surface.png
│   ├── TOR_cartoon.png
│   └── TOR_surface.png
│
└── docs/
    └── referencias.md
```

### Descripción de los directorios

- **data/raw/**: contiene las secuencias originales en formato FASTA utilizadas en los análisis.
- **scripts/**: contiene los scripts Bash empleados para automatizar el procesamiento de las secuencias.
- **estructuras/**: almacena los modelos tridimensionales de las proteínas estudiadas.
- **results/**: contiene las imágenes y los resultados obtenidos durante el trabajo.
- **docs/**: contiene documentación y referencias complementarias.
- **README.md**: presenta la descripción general y las instrucciones del proyecto.
- **.gitignore**: especifica los archivos que deben excluirse del control de versiones.

La estructura fue creada manualmente mediante comandos Bash, sin utilizar generadores automáticos de proyectos como Cookiecutter.

## 3. Herramientas y requisitos

Para reproducir los análisis se utilizan las siguientes herramientas:

- **Ubuntu mediante WSL:** entorno de trabajo Linux.
- **Bash:** ejecución de comandos y automatización del pipeline.
- **Entrez Direct (NCBI):** recuperación de secuencias biológicas mediante `efetch`.
- **BioAWK:** procesamiento de secuencias en formato FASTA y cálculo de métricas.
- **grep:** búsqueda de patrones y motivos en secuencias.
- **UCSF ChimeraX:** visualización y análisis de estructuras tridimensionales.
- **Git:** control de versiones local.
- **GitHub:** alojamiento remoto del repositorio.

## 4. Datos utilizados

Se analizaron las siguientes secuencias:

| Proteína o región | Identificador utilizado |
|---|---|
| SnRK1/KIN10 | Q38997.3 |
| TOR | Q9FR53.1 |
| Región codificante de KIN10 | NM_001125074.2 |
| Región codificante de TOR | NM_103891.4 |

Las secuencias se recuperaron mediante Entrez Direct y se almacenaron en archivos FASTA.

**Nota:** la opción `fasta_cds_na` de Entrez Direct permite recuperar las secuencias nucleotídicas correspondientes a las regiones codificantes (CDS), no necesariamente el ARNm completo.

## 5. Metodología de análisis de secuencias

Se realizaron diferentes análisis sobre las secuencias obtenidas:

### 5.1. Longitud de las secuencias

Se utilizó BioAWK para determinar la cantidad de nucleótidos o aminoácidos presentes en cada secuencia.

### 5.2. Contenido GC

Se calculó el porcentaje de guanina y citosina sobre el total de nucleótidos válidos (A, C, G y T) de cada región codificante.

### 5.3. Composición de aminoácidos

Se determinó la frecuencia absoluta y relativa de los 20 aminoácidos estándar en las secuencias proteicas de TOR y SnRK1/KIN10.

### 5.4. Búsqueda de motivos

Se realizaron búsquedas de patrones específicos en las secuencias proteicas:

- **SnRK1/KIN10:** motivo `TSCGSPNYAAPE`.
- **TOR:** patrón `WHE[A-Z]`, que permite identificar secuencias de cuatro aminoácidos que comienzan con WHE.

Las coincidencias obtenidas se utilizaron para localizar regiones de interés dentro de las proteínas.

## 6. Análisis estructural tridimensional

Se exploraron modelos tridimensionales de las proteínas TOR y SnRK1/KIN10 mediante UCSF ChimeraX.

Se utilizaron modelos predichos por AlphaFold y se exploraron diferentes representaciones:

- **Cartoon:** visualización de la estructura secundaria y organización general de la proteína.
- **Atoms:** representación de los átomos y grupos de átomos de regiones seleccionadas.
- **Surface:** visualización de la superficie molecular y posibles cavidades o regiones de interacción.

Se destacaron regiones de interés mediante colores y se generaron imágenes para documentar las observaciones.

Los modelos de AlphaFold son predicciones estructurales y no deben interpretarse como estructuras experimentales.

## 7. Ejecución del pipeline

El procesamiento de las secuencias se automatiza mediante un script Bash.

Para ejecutar el pipeline, se debe contar con las herramientas indicadas en la sección de requisitos y ubicarse en el directorio principal del proyecto.

Ejecutar:

```bash
bash scripts/pipeline.sh
```

El script contempla la recuperación y el procesamiento de las secuencias, así como los análisis de longitud, contenido GC, composición de aminoácidos y búsqueda de motivos.

Los archivos de entrada y salida se organizan en los directorios correspondientes.

## 8. Control de versiones

Se utilizó Git para realizar el control de versiones del proyecto.

El repositorio local permite registrar los cambios mediante commits, consultar el historial y mantener un seguimiento de las modificaciones realizadas.

Además, se creó un repositorio privado en GitHub para almacenar una copia remota del proyecto y sincronizar los cambios.

Entre los comandos utilizados se encuentran:

```bash
git init
git status
git add .
git commit -m "Descripcion de los cambios"
git log --oneline
git remote add origin URL_DEL_REPOSITORIO
git push -u origin main
git pull
```

## 9. Referencias y bases de datos

- **NCBI:** https://www.ncbi.nlm.nih.gov/
- **NCBI Entrez Direct:** https://www.ncbi.nlm.nih.gov/books/NBK179288/
- **RCSB Protein Data Bank:** https://www.rcsb.org/
- **AlphaFold Protein Structure Database:** https://alphafold.ebi.ac.uk/
- **UCSF ChimeraX:** https://www.cgl.ucsf.edu/chimerax/
- **Git:** https://git-scm.com/
- **GitHub:** https://github.com/

---

**Proyecto Final – Bioinformática 1**  
Facultad de Ingeniería / Facultad de Bioingeniería – Universidad Nacional de Entre Ríos (UNER).
