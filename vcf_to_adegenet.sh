############################################
#                                          #
#          CORAL PROJECT                   #
#  Create input file (from vcf file) for   #
#        R package 'adegenet' [1]          #
#                                          #
#  Copyright 2016 Rebecca Jordan           #
#                                          #
############################################

# [1] Jombart & Ahmed 2011 Bioinformatics 27, 3070-3071

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
# Usage: vcf_to_adegenet.sh <input_vcf> <output_prefix>

  # output 012 format

vcftools --vcf $1 --012 --out $2

  # Replace '-1' for missing data with 'NA' in genotype file

sed 's/-1/NA/g' $2.012 > $2_NA.012

  # Adjust position file to include third column with "chr_position"

awk '{print $1,$2,$1"_"$2}' $2.012.pos > $2.012adjusted.pos

  # Adjust individual file to create an additional column = site

awk '{split($1,a,"_"); split(a[2],b,"-"); print $1, b[1]}' $2.012.indv > $2.012adjusted.indv

