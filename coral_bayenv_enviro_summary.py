##############################################################
#                                                            #
#                   CORAL GENOMICS                           #
#                                                            #
#    Filter Bayenv2 [1] environmental association results    #
#    for SNPs significantly associated with variables        #
#                                                            #
#         Copyright Sept 2016 Rebecca Jordan                 #
#                                                            #
##############################################################

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


#-- NOTE --#
# Assumes fewer than 10000 SNPs being tested
# Assumes Spearman's rho calculated along with BF (= 3 column per environmental variable, BF, rho, Pearson's r)
# Associations filtered using Kass and Raftery interpretation of Bayes Factors (as per Bayenv2 manual)
# 'Positive' = 3 < BF < 20; 'Strong' = 20 <= BF < 150; 'VeryStrong = BF > 150
# SNP numbers adjusted by 1 to match numbered loci in .numbered.map file, used to convert SNP numbers to SNP loci (Bayenv counts from 0, .numbered.map counts from 1)

# Input: Bayenv2 environmental association OUTFILE (by default = "bf_environ.ENVIRONFILE.txt"); SNPs as rows, Environmental variables as columns

# Usage: coral_bayenv_enviro_summary.py <input_file> <output_prefix> <number_variables>

import sys
import os

dataIN=sys.argv[1]
prefixOUT=sys.argv[2]
countVar=sys.argv[3]

print "number of variables considered:  " + countVar

# create list of columns with BF results
calccolumns=range(1,((int(countVar)*3)+1),3)

print "data columns used to assess BF (first column = 0):  " + str(calccolumns)

# Extract rho data and calculate 5% and 1% cutoffs for each variable
# based on absolute rho values (raw data varies between -1 and 1)
fileIN=open(dataIN).readlines()
RhoData={}
for count in range(0,int(countVar)):
    rhocolumn=calccolumns[count]+1
    var=int(count)+1
    RhoData[var]=[]
    for lineX in fileIN:
        raw=lineX.strip().split()
        RhoData[var].append(abs(float(raw[rhocolumn])))

RhoCutoff={}
for varX in RhoData.keys():
    RhoCutoff[varX]=[]
    tmpSORTED=sorted(RhoData[varX])
    RhoCutoff[varX].append(tmpSORTED[int(len(tmpSORTED)*0.95)])
    RhoCutoff[varX].append(tmpSORTED[int(len(tmpSORTED)*0.99)])

# Get associations based on BF and rho cutoffs
fileIN=open(dataIN).readlines()
EnviroVar={}
RhoVar={}
for count in range(0,int(countVar)):
    datacolumn=calccolumns[count]
    rhocolumn=calccolumns[count]+1
    var=int(count)+1
    EnviroVar[var]={}
    tmp3=[]
    tmp20=[]
    tmp150=[]
    RhoVar[var]={}
    tmp5=[]
    tmp1=[]
    for lineX in fileIN:
        raw=lineX.strip().split()
        if float(raw[datacolumn])>3 and float(raw[datacolumn])<20:
            tmp3.append(int(raw[0][-4:])+1)
        elif float(raw[datacolumn])>=20 and float(raw[datacolumn])<150:
            tmp20.append(int(raw[0][-4:])+1)
        elif float(raw[datacolumn])>=150:
            tmp150.append(int(raw[0][-4:])+1)
        if abs(float(raw[rhocolumn]))>=RhoCutoff[var][1]:
            tmp1.append(int(raw[0][-4:])+1)
        if abs(float(raw[rhocolumn]))>=RhoCutoff[var][0]:
            tmp5.append(int(raw[0][-4:])+1)
    EnviroVar[var]['positive']=tmp3
    EnviroVar[var]['strong']=tmp20
    EnviroVar[var]['verystrong']=tmp150
    RhoVar[var]['top5']=tmp5
    RhoVar[var]['top1']=tmp1


# create results directory
os.mkdir("./"+prefixOUT+"_snps")
    
# Output count of number of SNPs associated with each variable at each "association strength"
outsummary=open("./"+prefixOUT+"_snps/"+prefixOUT+'_BFsummary.txt','a')
outsummary.write("Variable\tPositive\tStrong\tVeryStrong\n")
for var in EnviroVar.keys():
    outsummary.write(str(var) + "\t" + str(len(EnviroVar[var]['positive'])) + "\t" + str(len(EnviroVar[var]['strong'])) + "\t" + str(len(EnviroVar[var]['verystrong'])) + "\n")
outsummary.close()

# Output individual files for each variable and SNP strength based on BF
for var in EnviroVar.keys():
    for BF in EnviroVar[var].keys():
        outfile=open("./"+prefixOUT+"_snps/"+str(var)+"."+BF+".SNPs",'w')
        for i in range(0,len(EnviroVar[var][BF])):
             outfile.write(str(EnviroVar[var][BF][i]) + "\n")
        outfile.write("\n")
        outfile.close()
        
# Output individual files for each variable and rho cutoff
for var in RhoVar.keys():
    for r in RhoVar[var].keys():
        outfile2=open("./"+prefixOUT+"_snps/"+str(var)+".rho"+r+".SNPs",'w')
        for i in range(0,len(RhoVar[var][r])):
            outfile2.write(str(RhoVar[var][r][i]) + "\n")
        outfile2.write("\n")
        outfile2.close()