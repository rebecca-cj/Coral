######################################
#                                    #      
#          CORAL GENOMICS            #
#                                    #
#  Create OutFLANK [1] input file    #
#      from filtered vcf file        #  
#                                    #
#  Copyright 2016 Rebecca Jordan     #
#                                    #
######################################

# [1] Whitlock & Lotterhos 2015, Am Nat 186, S24-S36

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
# Usage: vcf_to_outflank.sh <input_vcf> <output_prefix>

  # output 012 format

vcftools --vcf $1 --012 --out $2

  # Replace '-1' for missing data with '9' in genotype file and remove first column of sample numbers

sed 's/-1/9/g' $2.012 | cut -f 2- > $2.outflank.012

  # Create locus list

awk '{print $1"_"$2}' $2.012.pos > $2.outflank.012.pos

  # Create list of populations for each sample in 012 file

#awk '{split($1,a,"_"); split(a[2],b,"-"); print substr(b[1],1,2)}' $2.012.indv > $2.outflank.012.indv

  # Clean up

#rm $2.012 $2.012.indv $2.012.pos


