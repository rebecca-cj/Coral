############################################
#                                          #
#         CORAL GENOMICS                   #
#                                          #
#  Convert SNP numbers (from Bayenv2 [1])  #
#      to actual SNP loci                  #
#                                          #
#  Copyright Sept 2016 Rebecca Jordan      #
#                                          #
############################################

# [1] Gunther & Coop 2013 Genetics 195, 205-220

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

# Input:  *.SNPs output files from bayenv_enviro_summary.py (each file containing list of SNPs associated with particular variable at particular BF 'strength')
# Input:  "Numbered" .map (plink) file (output from adjustPED.sh) where additional column created such that column 1 = SNP 'number'
# Usage: coral_bayenv_summary_to_loci.sh <single_input_file> <path/numbered.map_file> <output_prefix>

awk 'FNR==NR{a[$1]=$0;next}; $1 in a {print a[$1]}' $2 $1 > $3.loci  

rm $1