######################################
#                                    #
#          CORAL GENOMICS            #
#                                    #
#   Create LFMM [1] environmental    #
#        data input file             #
#                                    #
#  Copyright Sept 2016 R Jordan      #
#                                    #
######################################

# [1] Frichot et al 2013 Mol Biol Evol 30, 1687-1699

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


## NOTE:  Assume naming format used in Coral project 000_RR0-00, where RR is Reef and 0 are numbers
##        Numbers being (in order) DArTseq number, Reef site number and sample (within reef) number

# Input: .012.indv file of samples for LFMM analysis (matching 012 genotype file being used in LFMM analysis)
# Input: file of environmental data by site;  1st row = column names; 1st column = Reef Code, subsequent columns = environmental data

# Usage: lfmm_envirodata_file.sh <.012.indv_file> <envirodata_file> <output_prefix>

    # Adjust .012.indv file to include column of Reef info

awk 'BEGIN{print "SampleID\tReef"}{split($1,a,"_"); print $1 "\t" substr(a[2],1,2)}' $1 > $3.adj.012.indv

    # Create labelled environmental variable matrix

cp $3.adj.012.indv $3_envirodata_labelled.txt
cat $2 | while read -r reefX dataX; do sed -i "s/\b$reefX\b/$reefX\t$dataX/" $3_envirodata_labelled.txt; done

    # Create unlabelled environmental variable matrix (LFMM input)

awk 'NR>1' $3_envirodata_labelled.txt | cut -f 3- > $3_envirodata.txt
