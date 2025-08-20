import sys
import os
import argparse

parser = argparse.ArgumentParser(description='Calculate qcov and tcov.')
parser.add_argument('-in1', help='query faa file')
parser.add_argument('-in2', help='subject faa file')
parser.add_argument('-in3', help='diamond blastp file')
parser.add_argument('--taxon_level', choices=['genus', 'family'], required=True, help='Taxon level for coverage threshold')
args = parser.parse_args()

in1 = args.in1
in2 = args.in2
in3 = args.in3

com = {}
flag = 0

with open(in3, 'r') as f3:
    for line in f3:
        flag += 1
        if flag % 1000000 == 0:
            print(f"Processed {flag} lines")
        data = line.strip('\n').split('\t')
        q_prot, s_prot = data[0], data[1]
        
        q_virus = '_'.join(q_prot.split('_')[:-1])
        s_virus = '_'.join(s_prot.split('_')[:-1])
        
        if q_virus == s_virus:
            continue  
        
        sorted_pair = sorted([q_virus, s_virus])
        key = f"{q_virus}-{s_virus}"
        
        is_forward = (q_virus == sorted_pair[0])
        if key not in com:
            com[key] = [set(), set()]  
        com[key][0].add(q_prot)
        com[key][1].add(s_prot)
    
virus_protein_count = {}
virus_protein_count2 = {}

with open(in1, 'r') as f:
    for line in f:
        if line.startswith('>'):
            prot_id = line.split()[0].strip('>')
            virus = '_'.join(prot_id.split('_')[:-1])
            if virus not in virus_protein_count.keys():
                virus_protein_count[virus]=1
            else:
                virus_protein_count[virus]+=1
with open(in2, 'r') as f:
    for line in f:
        if line.startswith('>'):
            prot_id = line.split()[0].strip('>')
            virus = '_'.join(prot_id.split('_')[:-1])
            if virus not in virus_protein_count2.keys():
                virus_protein_count2[virus]=1
            else:
                virus_protein_count2[virus]+=1

# 输出结果
output_file = in3 + '_cov.tsv'
with open(output_file, 'w') as out:
    out.write('virus1\tvirus2\tcov1\tcov2\n')
    for key in com:
        virus1, virus2 = key.split('-')
        # 获取病毒1和病毒2的比对蛋白数
        count1 = len(com[key][0])
        count2 = len(com[key][1])
        # 获取总蛋白数
        
        total1 = virus_protein_count[virus1]
        total2 = virus_protein_count2[virus2]
        
        # 计算覆盖率
        cov1 = count1 * 100.0 / total1
        cov2 = count2 * 100.0 / total2
        
        if args.taxon_level == 'genus':
            threshold = 20
        else: # family
            threshold = 10
            
        if min(cov1, cov2) >= threshold:
            out.write(f"{virus1}\t{virus2}\t{cov1:.2f}\t{cov2:.2f}\t{count1}\t{count2}\t{total1}\t{total2}\n")
