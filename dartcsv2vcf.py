#################################################
#                                               #
#               CORAL GENOMICS                  #
#                                               #
#    Convert DArTseq .csv to basic VCF file     #
#                                               #
#     Copyright Sept 2016 Pim Bongaerts &       #
#              Rebecca Jordan                   #
#                                               #
#################################################

#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program.  If not, see <http://www.gnu.org/licenses/>.

# INPUT: .csv file of 'ScoringData_SNP1Row' DArTseq results - "AlleleID", "SNP" and "SnpPosition" columns plus sample genotypes
# INPUT: file of sample number (1st column) and sample name (2nd column)

import sys

VCF_HEADER = '#CHROM\tPOS\tID\tREF\tALT\tQUAL\tFILTER\tINFO\tFORMAT'
CSV_HEADER = 'AlleleID'
CSV_INDIV_STARTCOL = 3
CSV_COL_CHROM = 0
CSV_COL_CHROMPOS = 2
CSV_COL_CHROM_SPLIT = '|F|0'
CSV_COL_ALLELE_INFO = 1
CSV_COL_POS = 2

def is_header(line, header):
    # Assess whether line is a header
    return line[0:len(header)] == header

def get_vcf_gt(genotype):
    # Convert DaRT to VCF genotype
    dart_gt = genotype.strip()
    if dart_gt == '-':
        vcf_gt = './.'
    elif dart_gt == '0':
        vcf_gt = '0/0'
    elif dart_gt == '1':
        vcf_gt = '1/1'
    elif dart_gt == '2':
        vcf_gt = '0/1'
    else:
        print(dart_gt)
        vcf_gt = 'err'
    return vcf_gt
    
def init_sampleid_dict(sampleid_filename):
    # Initialise dictionary with old (key) and new (value) sample names
    sampleid_file = open(sampleid_filename, 'r')
    sampleids = {}
    for line in sampleid_file:
        cols = line.split('\t')
        sampleids[cols[0]] = cols[1].strip()
    return sampleids

def main(csv_filename, sampleid_filename):
    # Generate look-up dict with sample names
    sampleids = init_sampleid_dict(sampleid_filename)
    
    # Open VCF output file
    vcf_file = open(csv_filename.replace('.csv', '.vcf'), 'w')

    # Iterate over CSV input file and output to VCF
    csv_file = open(csv_filename, 'r')
    for line in csv_file:
        cols = line.split(',')
        if is_header(line, CSV_HEADER):
            # Output VCF header
            sample_names = []
            # Convert old to new sample names
            for indiv in cols[CSV_INDIV_STARTCOL:]:
                indiv_key = indiv.strip()
                indiv_name = sampleids[indiv_key]
                sample_names.append('{0}_{1}'.format(indiv_key, indiv_name))
            indivs = '\t'.join(sample_names)
            vcf_file.write('{0}\t{1}\n'.format(VCF_HEADER, indivs))
        else:
            # Obtain values for VCF output
            scaffold = cols[CSV_COL_CHROM].split(CSV_COL_CHROM_SPLIT)[0]
            chrompos = cols[CSV_COL_POS]
	    alleles = cols[CSV_COL_ALLELE_INFO].split(':')[1]
            ref_allele = alleles[0]
            alt_allele = alleles[2]
            # Convert genotypes to VCF format
            vcf_gts = []
            for dart_gt in cols[CSV_INDIV_STARTCOL:]:
                vcf_gts.append(get_vcf_gt(dart_gt))
            vcf_gts_concat = '\t'.join(vcf_gts)
            std_values = '.\tPASS\t.\tGT'
            # Output SNP line to file
            output_line = '{0}\t{1}\t.\t{2}\t{3}\t{4}\t{5}\n'.format(scaffold, 
                    chrompos,ref_allele, alt_allele, std_values, vcf_gts_concat)
            vcf_file.write(output_line)
            
    csv_file.close()      
    vcf_file.close()

if __name__ == '__main__':
   main(sys.argv[1], sys.argv[2])
