######################################
#                                    #
#          CORAL GENOMICS            #
#      	       	       	       	     #
#     Convert vcf to BayeScan [1]    #
#    input file using PGDSpider [2]  #
#                                    #
#   Copyright 2016 Rebecca Jordan    #
#      	       	       	       	     #
######################################  

# [1] Foll and Gaggiotti 2008 Genetics, 180, 977-993
# [2] Lischer & Excoffier 2012 Bioinformatics 28, 298-299

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
# PGDspider  Lischer & Excoffier 2012 Bioinformatics 28, 298-299

# **NOTE**  Adjustments to PED files specific to Coral Genomics project

# Input:  FILTERED vcf file (no filtering of SNPs or samples performed in this script)
# Input:  PED to BAYESCAN PGDspider conversion file (including path if not in current directory)
# Usage:  vcf_to_bayescan.sh <vcf_file> <output_prefix> <path/.spid_file>

# Output plink files
        vcftools --vcf $1 --plink --out $2

# Adjust .ped so that first column is Reef
        cut -f 2- $2.ped | awk '{split($1,a,"_"); print substr(a[2],1,2) "\t" $0}' - > $2.adj.ped

# Adjust .map file so all "chromosomes" are 1 (plink can't deal with Chr # > number human chromosomes)
        awk '{print "1\t" $2 "\t" $3 "\t" $4}' $2.map > $2.adj.map

# create altered .map file to have first column as SNP "number" (as per outlier analysis outputs); to convert 'outlier' SNP numbers to actual SNP loci
        awk '{print NR "\t" $0}' $2.adj.map > $2.numbered.map

# adjust .spid file to indicate correct .map file 
	sed -i 's/PED_PARSER_MAP_FILE_QUESTION=.*$/PED_PARSER_MAP_FILE_QUESTION='$2'.adj.map/' $3

# Convert PED file to BayeScan format using PGDSpider
	java -Xmx2g -jar ~/data/java/PGDSpider_2.0.7.4/PGDSpider2-cli.jar -inputfile $2.adj.ped -inputformat PED -outputfile $2.BayeS.txt -outputformat GESTE_BAYE_SCAN -spid $3
