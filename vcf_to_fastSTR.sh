#############################################
#                                           #
#         CORAL GENOMICS                    #
#                                           #
#  Create fastSTRUCTURE [1] input file      #
#                                           #
#  Copyright 2016 Rebecca Jordan            #
#                                           #
#############################################

# [1] Raj et al (2014) Genetics, 197, 573-589

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
# PLINK  Purcell et al 2007 Am J Human Genetics 81, 559-575

# Input:  FILTERED vcf file (no filtering of SNPs performed in this script)
# Input:  List of samples to kept (must be provided even if all samples are to be kept)
# Usage:  vcf_to_fastSTR.sh <vcf_file> <sample_list> <output_prefix>

# Create input file
	vcftools --vcf $1 --keep $2 --plink --out $3

# Adjust .ped so that first column is Site
	cut -f 2- $3.ped | awk '{split($1,a,"_"); split(a[2],b,"-"); print b[1] "\t" $0}' - > $3.adj.ped

# Adjust .map file so all "chromosomes" are 1 (plink can't deal with Chr # > number human chromosomes)
	awk '{print "1\t" $2 "\t" $3 "\t" $4}' $3.map > $3.adj.map

# Convert to bed format
	plink --file $3.adj --make-bed --out $3

# Create "popfile" for later plotting
	awk '{print $1}' $3.adj.ped > $3.popfile

