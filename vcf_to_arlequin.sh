##################################################
#                                                #
#           CORAL GENOMICS                       #
#                                                #
#  Create Arlequin [1] input file from vcf file  #
#      	       	       	       	                 #
#  Copyright 2016 Rebecca Jordan                 #
#      	       	       	       	                 #
##################################################

# [1] Excoffier et al 2005 Evolutionary Bioinformatics 1, 47-50

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

# **NOTE**  Adjustments	to PED files specific to Coral Genomics project

# Input:  FILTERED vcf file (no filtering of SNPs performed in this script)
# Input:  List of samples to include (required even if all samples are to be retained)
# Input:  PED to Arlequin PGDspider conversion file (including path if not in current directory)
# Usage:  vcf_to_arlequin.sh <vcf_file> <sample_list> <output_prefix> <path/.spid_file>

# Output plink files
	vcftools --vcf $1 --keep $2 --plink --out $3

# Adjust .ped so that first column is Site
	cut -f 2- $3.ped | awk '{split($1,a,"_"); print substr(a[2],1,2) "\t" $0}' - > $3.adj.ped

# Adjust .map file so all "chromosomes" are 1 (plink can't deal with Chr # > number human chromosomes)
	awk '{print "1\t" $2 "\t" $3 "\t" $4}' $3.map > $3.adj.map

# adjust .spid file to indicate correct .map file 
	sed -i 's/PED_PARSER_MAP_FILE_QUESTION=.*$/PED_PARSER_MAP_FILE_QUESTION='$3'.adj.map/' $4

# convert from PED to Arlequin using PGDSpider
       java -Xmx2g -jar ~/data/java/PGDSpider_2.0.7.4/PGDSpider2-cli.jar -inputfile $3.adj.ped -inputformat PED -outputfile $3.arp -outputformat ARLEQUIN -spid $4
