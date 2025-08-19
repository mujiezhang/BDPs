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

  For a given viral genome, if its full-length sequence mapped contiguously to a host genome and the ends of the mapped interval bordered by identical direct repeats (DRs), we designated the DRs as the definitive att site. And we aligned all complete viral genomes from RefSeq to RefSeq bacterial and archaeal genomes using Blastn:
```
blastn -db RefSeq_bacterial_and_archaeal_genomes -query all_RefSeq_complete_virus.fna -out RefSeq-complete_virus_vs_bacterial_and_archaeal_genoems_id-95_e-10.txt -perc_identity 95  -outfmt "6 qseqid qlen sseqid slen pident qcovhsp length mismatch gapopen qstart qend sstart send evalue bitscore" -num_threads 64 -evalue 1e-10
```

  **Note**: Most of the att sequences found in viruses through this method are not located at the ends of the viral genome but rather in the middle, because the majority of viral genomes are circular, and sequencing does not necessarily start exactly at the att site, as shown in the following diagram:
![att-positive](https://github.com/user-attachments/assets/ae7c6eb9-b145-4a75-bd21-f95ba79bb1ea)

### 3. Viral sequences clustering
<details>
<summary><strong>vOTU clustering based on ANI</strong></summary>
  
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

</details>

<details>
<summary><strong>Genus and Family level clustering based on AAI</strong></summary>
  
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

</details>

### 4. Homologous sequence coverage (HSC) analysis
We found extensive sharing of BDPs and BUPs at the genus and family levels. Within the same viral cluster, the genome size of BDPs was consistently larger than that of BUPs. We hypothesize that a significant number of BUPs degenerated from BDPs. To validate this, we conducted HSC analysis, as illustrated below, using the following algorithm:

![HSC-analysis](https://github.com/user-attachments/assets/192421c9-9f16-4029-ace2-e8ba11da5b8f)

```
# take gVC_1 for example
# step1. perform diamond blastp between BDPs-BUPs and between BDPs-BDPs in gVC_1
diamond makedb -in gvc1_BDPs.faa --db gvc1_BDPs
diamond makedb -in gvc1_BUPs.faa --db gvc1_BUPs
diamond blastp --query gvc1_BDPs.faa --db gvc1_BDPs.dmnd --out gvc_1_BDP_vs_BDP_blastp.tsv --outfmt 6 --evalue 1e-5 --max-target-seqs 10000000 --query-cover 50 --subject-cover 50
diamond blastp --query gvc1_BDPs.faa --db gvc1_BUPs.dmnd --out gvc_1_BDP_vs_BUP_blastp.tsv --outfmt 6 --evalue 1e-5 --max-target-seqs 10000000 --query-cover 50 --subject-cover 50

# step2. calculate HSC


# step3. get plot data


```

### 5. Conservation analysis of att.
- **for att sequence conservation**: extract the att sequences of a certain viral cluster and perform CD-HIT-EST
  ```
  # take vOTU_1 for example
  cd-hit-est -i votu_1_att_sequence.fna -o  votu_1_att_sequence_cd-hit-est.txt -c 0.85 -M 0 -T 60 -n 2 -l 4 -d 0 -aS 0.9
  ```
- **for att length conservation**: count the number of different att lengths in a certain viral cluster

### 6. Analysis of integration protein types in proviruses
```
# hmmsearch against PF07508 (S-int) and PF00589 (Y-int)
hmmsearch --tblout all_BDPs_vs_pfam-S-int.tsv --noali --notextw --cut_ga --cpu 64 PF07508.hmm all_BDPs.faa
hmmsearch --tblout all_BDPs_vs_pfam-Y-int.tsv --noali --notextw --cut_ga --cpu 64 PF00589.hmm all_BDPs.faa

# diamond blastp against S-int and Y-int from NCBI
diamond blastp --db ncbi-serine-tyrosine-integrase.dmnd --threads 64 --out BDPs-vs-ncbi-S-int-Y-int-qcov-50-scov50-e-0.001.tsv --max-target-seqs 1 --query-cover 50 --subject-cover 50 --query all_BDPs.faa --more-sensitive --outfmt 6
```

### 7. Functional gene identification

We download VFDB setA for VFG detection from [**https://www.mgc.ac.cn/VFs/download.htm**](https://www.mgc.ac.cn/VFs/download.htm) and SARG for ARG detection from [**https://smile.hku.hk/ARGs/Indexing/download**](https://smile.hku.hk/ARGs/Indexing/download)
```
# for VFG
diamond blastp --threads 64 --db VFDB_setA_pro.dmnd --max-target-seqs 1 --out BDPs-vs-VFDB_setA-id-80-qcov-scov50-e-5.tsv --evalue 1e-5 --more-sensitive --query all_BDPs.faa --id 80 --query-cover 50 --subject-cover 50

# for ARG
diamond blastp --threads 64 --db 4.SARG_v3.2_20220917_Short_subdatabase.dmnd --max-target-seqs 1 --out BDPs-vs-sarg-id-80-qcov-scov50-e-5.tsv --evalue 1e-5 --more-sensitive --query all_BDPs.faa --id 80 --query-cover 50 --subject-cover 50

# for AMP
macrel contigs -f all_BDPs.fna -o BDP_AMP_prediction -t 64 --keep-fasta-headers

# for Defense system and Anti-defense system
defense-finder run -o BDPs-defense-finder -w 20 --db-type gembase --models-dir ~/software/defense-finder -a  all_BDPs.faa
```
### 8. Detection for dark proviruses


### 9. Protein sharing network analysis

Viral protein sharing networks were constructed using vConTACT2 (v2.0) and the resulting networks were visualized using Cytoscape (v3.8.2) with a prefuse force-directed layout model.
```
# prepare input
vcontact2_gene2genome -p DPs_and_BDP_family.faa -o gene2genome.csv -s Prodigal-FAA
# run vcontact2
vcontact2 -r DPs_and_BDP_family.faa.faa -p gene2genome.csv --db None -o DPs_and_BDP_family_vcontact2 -t 64
```

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
