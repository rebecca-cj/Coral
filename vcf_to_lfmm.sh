###################################
#                                 #   
#          CORAL PROJECT          #
#                                 #
#   Create LFMM [1] SNP input     #
#      from vcf file              #
#                                 #   
#  Copyright 2016 Rebecca Jordan  #
#                                 #   
###################################

# [1] Frichot et al 2013 Mol Biol Evol 30, 1687-1699

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


# REQUIRED PROGRAMS
# VCFtools  Danecek et al 2011 Bioinformatics 27, 2156-2158

# ** NB: no filtering of SNPs or individuals performed on vcf file **

# Input: vcf file ("pre-filtered"; no additional filtering performed)
# Input: output prefix
# Usage: vcf_to_lfmm.sh <input_vcf> <output_prefix>

  # output 012 format

vcftools --vcf $1 --012 --out $2

  # Adjust genotype matrix to remove 1st column of sample numbers and replace '-1' for missing data with '9'

sed 's/-1/9/g' $2.012 | cut -f 2- > $2.adj.012

  # Create "numbered" positions file (for later conversion of SNP numbers back to SNP loci)

awk '{print NR "\t" $1 ":" $2}' $2.012.pos > $2.012.numbered.pos
