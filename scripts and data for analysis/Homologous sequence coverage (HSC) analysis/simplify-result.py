
import sys
import statistics
import argparse
from collections import defaultdict

# --- Get input file paths from command line ---
# sys.argv[1]: BDP vs BDP blastp coverage file
# sys.argv[2]: BDP vs BUP blastp coverage file
bdp_vs_bdp_file = sys.argv[1]
bdp_vs_bup_file = sys.argv[2]
taxon_level = sys.argv[3] # The third argument specifies the taxon level: 'genus' or 'family'

combined_output_file = bdp_vs_bdp_file + '_cov_vs_cov.tsv'

def get_coverage_distribution(input_file, data_type, output_writer):
  
    # Initialize dictionaries for binning
    tcov_to_bin_label = {}    # Maps integer tcov to a bin label, e.g., 15 -> '10-20'
    bin_label_to_qcovs = {}   # Maps bin label to a list of qcov values, e.g., '10-20' -> [15.1, 22.3, ...]
    bin_label_to_center = {}  # Maps bin label to its center point, e.g., '10-20' -> '15.0'

    for i in range(0, 100, 10):
        label = f"{i}-{i+10}"
        bin_label_to_qcovs[label] = []
        bin_label_to_center[label] = str((i + i + 10) / 2.0)
        for val_in_bin in range(i, i + 10):
            tcov_to_bin_label[val_in_bin] = label
    tcov_to_bin_label[100] = '90-100'

    # Read the input file and populate the qcov lists
    for line in input_file:
        if line.startswith('virus'):
            continue
        
        parts = line.strip().split('\t')
        qcov = float(parts[2])
        tcov = float(parts[3])
        
        bin_label = tcov_to_bin_label.get(int(tcov))
        if bin_label:
            bin_label_to_qcovs[bin_label].append(qcov)

    # Write the processed data to the output file
    for bin_label, qcov_list in bin_label_to_qcovs.items():
        center_point = bin_label_to_center[bin_label]
        for qcov in qcov_list:
            output_writer.write(f"{bin_label}\t{center_point}\t{qcov}\t{data_type}\n")

with open(bdp_vs_bdp_file, 'r') as f_bdp, \
     open(bdp_vs_bup_file, 'r') as f_bup, \
     open(combined_output_file, 'w') as f_out:
    
    f_out.write('num\tloca\tcov\ttype\n')
    
    get_coverage_distribution(f_bdp, "BDP", f_out)
    get_coverage_distribution(f_bup, 'BUP', f_out)

def calculate_median_from_file(file_path, taxon_level_param):

    output_median_file = file_path + '-median.tsv'
    
    # Determine the bins to analyze based on the taxon level
    if taxon_level_param == 'genus':
        coverage_bins = {
            '20-30': {'BDP': [], 'BUP': []}, '30-40': {'BDP': [], 'BUP': []},
            '40-50': {'BDP': [], 'BUP': []}, '50-60': {'BDP': [], 'BUP': []},
            '60-70': {'BDP': [], 'BUP': []}, '70-80': {'BDP': [], 'BUP': []},
            '80-90': {'BDP': [], 'BUP': []}, '90-100': {'BDP': [], 'BUP': []}
        }
    elif taxon_level_param == 'family':
        coverage_bins = {
            '10-20': {'BDP': [], 'BUP': []}, '20-30': {'BDP': [], 'BUP': []},
            '30-40': {'BDP': [], 'BUP': []}, '40-50': {'BDP': [], 'BUP': []},
            '50-60': {'BDP': [], 'BUP': []}, '60-70': {'BDP': [], 'BUP': []},
            '70-80': {'BDP': [], 'BUP': []}, '80-90': {'BDP': [], 'BUP': []},
            '90-100': {'BDP': [], 'BUP': []}
        }
    else:
        print(f"Error: Unknown taxon level '{taxon_level_param}'. Please use 'genus' or 'family'.", file=sys.stderr)
        return

    with open(file_path, 'r') as f_in:
        next(f_in) # Skip header line
        for line in f_in:
            parts = line.strip().split('\t')
            bin_label = parts[0]
            data_type = parts[3]
            coverage_value = float(parts[2])
            
            if bin_label in coverage_bins:
                coverage_bins[bin_label][data_type].append(coverage_value)

    with open(output_median_file, 'w') as f_out:
        f_out.write('subject_HSC_bin\tQuery_HSC_median\ttype\n')
        
        for bin_label, data in coverage_bins.items():
            median_bdp = 0
            median_bup = 0
            
            # Calculate median for BDP
            try:
                if data['BDP']:
                    median_bdp = statistics.median(data['BDP'])
            except statistics.StatisticsError:
                print(f"Info: Could not calculate BDP median for bin {bin_label} in {file_path} (list is empty or contains non-numeric data).")

            # Calculate median for BUP
            try:
                if data['BUP']:
                    median_bup = statistics.median(data['BUP'])
            except statistics.StatisticsError:
                print(f"Info: Could not calculate BUP median for bin {bin_label} in {file_path} (list is empty or contains non-numeric data).")

            f_out.write(f"{bin_label}\t{median_bdp}\tBDP\n")
            f_out.write(f"{bin_label}\t{median_bup}\tBUP\n")

calculate_median_from_file(combined_output_file, taxon_level)
