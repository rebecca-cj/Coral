################################################
#                                              #
#                CORAL PROJECT                 #
#     Calculate % missing data per sample      #
#                from vcf file                 #
#                                              #
#    Copyright 2016 Rebecca Jordan             #
#                                              #
################################################

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

# Input: FILTERED .vcf file containing only those samples and loci to be included for analysis
#	 N.B. no additional filtering of samples or loci performed here
# Usage: missing_from_vcf_basic.sh <.vcf_input> <output_prefix>

# output 012 file
	vcftools --vcf $1 --012 --out $2
# add column of sample names to .012 file
	paste $2.012.indv $2.012 > $2.012.labelled

# Calculate proportion missing data per individual
	awk '
	BEGIN{print "sample \t missing \t genotyped \t total \t prop_missing"}
	{
	missing=0; genotype=0; total=0;
	for(i=3; i <=NF; i++)
        	{if($i==-1) missing++;
                	else if($i!=-1) genotype++}
	total = missing+genotype;
	prop_miss = missing/total;
	printf("%s\t%d\t%d\t%d\t%f\n",$1,missing,genotype,total,prop_miss)
	}' $2.012.labelled > $2.missing
