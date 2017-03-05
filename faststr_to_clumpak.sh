########################################
#      	     	       	       	       #
#         CORAL GENOMICS               #
#      	     	       	               #
#   Prepare fastSTRUCTURE [1] output   #
#    for running on CLUMPAK [2]        #
#                                      #
#  Copyright 2016  R Jordan            #
#      	     	       	       	       #
########################################

# [1] Raj et al (2014) Genetics, 197, 573-589
# [2] Kopelman et al (2015) Mol Ecol Res 15, 1179-1191

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


# Input:  prefix of fastSTRUCTURE output files (excluding .run*.meanQ)
# Input:  folder to send adjusted results files to
# Input:  smallest (k_min) and largest (k_max) values of k to be considered

## Usage: faststr_to_clumpak.sh <input_prefix> <output_folder> <k_min> <k_max>

# add .txt extension, change line end from \n to \r, ensure line return (\n) at end of last line
	for f in $1.run*.meanQ; do sed 's/\n/\r/g' $f | sed -e '$a\' > $2/${f%.meanQ}.txt; done

# change directory to location of output CLUMPAK files
	cd $2

# zip results by k
	for f in `seq $3 $4`; do zip $1-k$f.zip $1.run*.$f.txt; done

# zip all results into one
	zip $1.zip $1-k*.zip
 

