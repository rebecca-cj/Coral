############################################
#                                          #
#             CORAL GENOMICS               #
#                                          #
#    Convert SNP numbers from LFMM [1]     #
#           to actual SNP loci             #
#              	       	                   #
#  Copyright Sept 2016 Rebecca Jordan      #
#      	       	             	           #
############################################

# [1] Frichot et al 2013, Mol Biol Evol 30, 1687-1699

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


# Input:  text file containing list of candidiate SNPs by number (one SNP per line).  
# ** NOTE **  Assumes larger SNP dataset starts counting from one (e.g. first SNP =  SNP01, not SNP00)
# Input:  "Numbered" file where first column = SNP 'number' and 2nd column = locus (CHR:POS)
# Usage: coral_lfmm_candidates_to_loci.sh <single_input_file> <path/numbered_file> <output_prefix>

awk 'FNR==NR{a[$1]=$0;next}; $1 in a {print a[$1]}' $2 $1 | awk '{split($2,a,":"); print a[1] "\t" a[2]}' - > $3.loci  
