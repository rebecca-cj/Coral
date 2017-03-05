##################################################
#                                                #
#           CORAL GENOMICS                       #
#                                                #
#  Create Lositan [1] input file from vcf file   #
#                                                #
#  Copyright 2016 Rebecca Jordan                 #
#                                                #
##################################################

# [1] Antao et al 2008 BMC bioinformatics, 9, 323

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
# Input:  PED to GENEPOP PGDspider conversion file (including path if not in current directory)
# Usage:  vcf_to_lositan.sh <vcf_file> <output_prefix> <path/.spid_file>

# Output plink files
        vcftools --vcf $1 --plink --out $2

# Adjust .ped so that first column is Site
        cut -f 2- $2.ped | awk '{split($1,a,"_"); print substr(a[2],1,2) "\t" $0}' - > $2.adj.ped

# Adjust .map file so all "chromosomes" are 1 (plink can't deal with Chr # > number human chromosomes)
        awk '{print "1\t" $2 "\t" $3 "\t" $4}' $2.map > $2.adj.map

# adjust .spid file to indicate correct .map file 
	sed -i 's/PED_PARSER_MAP_FILE_QUESTION=.*$/PED_PARSER_MAP_FILE_QUESTION='$2'.adj.map/' $3

# convert from PED to GENEPOP (for Lositan) using PGDSpider
       java -Xmx2g -jar ~/data/java/PGDSpider_2.0.7.4/PGDSpider2-cli.jar -inputfile $2.adj.ped -inputformat PED -outputfile $2.txt -outputformat GENEPOP -spid $3

# clean-up
       rm $2.ped $2.map $2.adj.map $2.adj.ped *.log
