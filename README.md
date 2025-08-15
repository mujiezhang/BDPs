# Description

This is the supporting materials for the following manuscript:

Mujie Zhang, Yali Hao, Yi Yi, Yecheng Wang, Taoliang Zhang, Xiang Xiao, Huahua Jian. "Deciphering Pervasive Domestication and Active "Dark Matter" of Proviruses in Prokaryotes via Precision Border Mapping". xxx (2025)

# Documents
## For analysis:

### 1. Proviruses Border Delimitation and Activity Detection

  We use the pipeline **ProBord**, to predict the precise borders of proviruses and **ProAct**, to detect the activity of proviruses. 
  
<div align="center">
  <img src="https://github.com/user-attachments/assets/28dbd6a3-d854-45b6-a991-32af13be782d" alt="ProBord-ProAct" width="600" />
</div>

- The ProBord scripts and usage instructions are available at **https://github.com/mujiezhang/ProBord**.
- The ProAct scripts and usage instructions are available at **https://github.com/YaliHao/ProAct** .

### 2. Viral Sequence Reverse Mapping (VSRM): construct att positive set
### 3. Viral sequences clustering
#### vOTU clustering based on ANI
- We clustered vOTUs using the [**CheckV pipeline**](https://bitbucket.org/berkeleylab/checkv/src/master/), based all-versus-all BLASTn search and Leiden algorithm，following MIUViG guidelines (95% average nucleotide identity (ANI); 85% aligned fraction (AF)
  - step1: all-vs-all blastn
    ```
    makeblastdb -in all_virus.fna -dbtype nucl -out all_virus
    blastn -query all_virus.fna -db all_virus -outfmt '6 std qlen slen' -max_target_seqs 100000 -out my_blast.tsv -num_threads 64 -task megablast -evalue 1e-5
    ```
  - step2: calculate ANI using script `anicalc.py` from [**CheckV**](https://bitbucket.org/berkeleylab/checkv/src/master/scripts/)
    ```
    python anicalc.py -i my_blast.tsv -o my_ani.tsv
    ```
  - step3: vOTU clustering using script `aniclust.py` from [**CheckV**](https://bitbucket.org/berkeleylab/checkv/src/master/scripts/)
    ```
    python aniclust.py --fna all_virus.fna --ani my_ani.tsv --out my_clusters.tsv --min_ani 95 --min_tcov 85 --min_qcov 0
    ```
**Reference**: Nayfach S, Camargo A P, Schulz F, et al. CheckV assesses the quality and completeness of metagenome-assembled viral genomes[J]. Nature biotechnology, 2021, 39(5): 578-585.
#### Genus and Family level clustering based on AAI
- We performed genus/family clustering using the [**MGV pipeline**](https://github.com/snayfach/MGV/tree/master/aai_cluster) based on all-vs-all BLASTp search and MCL
  - step1: all-vs-all blastp
    ```
    prodigal -a all_votu.faa  -i all_otu.fna   -p meta
    diamond makedb --in all_votu.faa --db viral_proteins --threads 10
    diamond blastp --query all_votu.faa --db viral_proteins.dmnd --out blastp.tsv --outfmt 6 --evalue 1e-5 --max-target-seqs 1000000 --query-cover 50 --subject-cover 50
    ```
  - step2: calculate AAI (script `amino_acid_identity.py` is downloaded from [**MGV pipeline**](https://github.com/snayfach/MGV/tree/master/aai_cluster))
    ```
    python amino_acid_identity.py --in_faa query all_votu.faa --in_blast blastp.tsv --out_tsv aai.tsv
    ```
    Note: Modified script `amino_acid_identity.py` for Python3 compatibility: line21:`print "parse"`→`print("parse")`; line38:`print "compute"`→`print("compute")`; line52:`print "write"`→`print("write")`
  - step3: Filter edges and prepare MCL input (script `filter_aai.py` is downloaded from [**MGV pipeline**](https://github.com/snayfach/MGV/tree/master/aai_cluster))
    ```
    python filter_aai.py --in_aai aai.tsv --min_percent_shared 20 --min_num_shared 16 --min_aai 50 --out_tsv genus_edges.tsv
    python filter_aai.py --in_aai aai.tsv --min_percent_shared 10 --min_num_shared 8 --min_aai 20 --out_tsv family_edges.tsv
    ```
  - step4: Genus and family level clustering based on MCL 
    ```
    mcl genus_edges.tsv -te 8 -I 2.0 --abc -o genus_clusters.txt
    mcl family_edges.tsv -te 8 -I 1.2 --abc -o family_clusters.txt
    ```
    Note: Adjusted genus filtering to `--min_aai 50` following the parameters in their [**paper**](https://www.nature.com/articles/s41564-021-00928-6)
    
**Reference**: Nayfach S, Páez-Espino D, Call L, et al. Metagenomic compendium of 189,680 DNA viruses from the human gut microbiome[J]. Nature microbiology, 2021, 6(7): 960-970.
### 4. Homologous sequence coverage (HSC) analysis
### 5. Conservation analysis of att sequence.
### 6. Analysis of integration protein types in proviruses
### 7. Functional gene identification
### 8. Detection for dark proviruses

## For Figures:

### Fig.1
### Fig.2
### Fig.3
### Fig.4
### Fig.5
### Fig.6

### Extended Data Fig.1
### Extended Data Fig.2
### Extended Data Fig.3
### Extended Data Fig.4
### Extended Data Fig.5

### Supplementary Fig.1
### Supplementary Fig.2
### Supplementary Fig.3
### Supplementary Fig.4
### Supplementary Fig.5
