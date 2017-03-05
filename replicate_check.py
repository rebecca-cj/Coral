#################################################
##                                             ##
##   Compare genotypes of replicate samples    ##
##   (to gain an estimate of genotype error)   ##
##     	       	       	       	       	       ##
##   Copyright Aug 2016 Rebecca Jordan         ##
##     	       	       	       	       	       ##
#################################################  

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


##-- INPUTS --##
# input_genotypes = vcftools .012 output file with sample names added as 1st column (1st = sample name; 2nd = sample (vcf) number; 3rd++ = genotypes in 012 format)
# input_samplenames = text file of sample names (excluding replicate prefix or suffix); one sample name per line
# output_name = prefix for output file

# Usage: python replicate_check.py <input_genotypes> <input_samplenames> <output_name>

import sys
import fnmatch

genotypes=sys.argv[1]
samplereps=sys.argv[2]
outputname=sys.argv[3]

sampleList = open(samplereps).readlines()
genodata = open(genotypes).readlines()
numloci = len(genodata[0].strip().split()[2:])

errorDict={}
for lineX in sampleList:
    sampleX=lineX.strip()
    datamat={}
    for lineG in genodata:
        currentline=lineG.strip().split()
        if sampleX in currentline[0]:
            datamat[currentline[0]]=currentline[2:]
    print(datamat.keys())
    missing=0
    same=0
    diff=0
    for locus in range(0,numloci):
        tmplocus=[]
        for reps in datamat.keys():
            tmplocus.append(datamat[reps][locus])
        if '-1' in tmplocus:
            missing = missing + 1
        elif len(set(tmplocus))==1:
            same = same + 1
        else:
            diff = diff + 1
    nonmissing=numloci-missing
    errorDict[sampleX]=str(numloci) + "," + str(missing) + "," + str(nonmissing) + "," + str(same) + "," + str(diff) + "," + str((float(diff)/float(nonmissing))*100)

outfile=open(outputname + '_error.csv','w')    
outfile.write("Sample,TotalLoci,Missing,Scored,Same,Different,%Diff" + "\n")
for samples in errorDict.keys():
	outfile.write(samples + "," + errorDict[samples] + "\n")	
outfile.close()

