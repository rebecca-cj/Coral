#####################################################
##     	       	    	       	       	       	   ##
##             CORAL GENOMICS                      ##
##     	       	    	       	       	       	   ##
##    Create mean covariance matrix from last      ##
##   X draws of matrix estimation for Bayenv2 [1]  ##
##     	       	    	       	       	       	   ##
##   Copyright Sept 2016 Rebecca Jordan            ##
##                                                 ##
#####################################################

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


# Input: matrix estimation output from Bayenv2
# Dependancy: coral_bayenv_meanCovMat.py

# Usage: coral_bayenv_meanCovMat.sh <input_file> <number_pops> <number_matrices_to_average> <output_directory> <path/coral_bayenv_meanCovMat.py>

# create input variables
total=`wc -l $1 | cut -d " " -f 1`
npops=$2
poplines=$((npops+2))
nmatrix=$3

# calculate line of matrix output file to start to get last X number of matrices 
start_line=$((total-(poplines*nmatrix)+1))

# create individual files for the last X matrices
for rep in `seq 0 $((nmatrix-1))`; do
	count=$((rep+1))
	start=$((start_line+(rep*poplines)))
	awk -v start=$start -v size=$npops 'NR>=start+1 && NR<=start+size' $1 > $4/$1.$count
	done

# move to folder of individual files
cd $4

# run python script to calculate mean covariance matrix
python $5 $1 $3
