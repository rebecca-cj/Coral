######################################
##                                  ##
##         CORAL GENOMICS           ##
##                                  ##
##  Create lists of "linked" loci   ##
##          using PLINK             ##
##                                  ##
##   Copyright Sept 2016 R Jordan   ##
##     	       	       	       	    ##
######################################

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

# **NOTE**  Adjustments to PED files specific to Coral Genomics project

# Input: FILTERED .vcf file containing only those samples and loci to be analysed  (no additional filtering performed in this script)
# Linked loci identified using --indep-pairwise function in PLINK, window of 50 SNPs, 'step' of 5 SNPs.  r^2 specified in script

# Usage: linked_from_vcf.sh <.vcf_input> <output_prefix> <r^2_linkage_cutoff>

# output PED format from vcf file

	vcftools --vcf $1 --plink --out $2
	# std.out automatically sent to 'output_prefix'.log by vcftools

# Adjust .ped so that first column is Reef
        cut -f 2- $2.ped | awk '{split($1,a,"_"); print substr(a[2],1,2) "\t" $0}' - > $2.adj.ped

# Adjust .map file so all "chromosomes" are 1 (plink can't deal with Chr # > number human chromosomes)
        awk '{print "1\t" $2 "\t" $3 "\t" $4}' $2.map > $2.adj.map

# identify linked loci using PLINK 
	plink --file $2.adj --indep-pairwise 50 5 $3
	mv plink.prune.in prune.$2.in; sed -i 's/:/\t/g' prune.$2.in
	mv plink.prune.out prune.$2.out; sed -i 's/:/\t/g' prune.$2.out
	
	# console output automatically sent to plink.log by PLINK
	mv plink.log $2.plink.log
