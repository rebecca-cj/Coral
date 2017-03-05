SUMMARY OF SCRIPTS

Data preparation and QC
	dartcsv2vcf.py = converts DArTseq '1 SNP per row' data in csv format to basic vcf format
	replicate_check.py = calculate genotyping error between replicated samples
	missing_from_vcf_basic.sh = calculate amount of missing data per sample
	linked_from_vcf.sh = create lists of 'linked' loci from vcf input file, using PLINK (* note Coral project specific adjustments within script)

Creation of input files for various analysis programs
* note Coral project specific adjustments within script
	vcf_to_adegenet.sh = create 'adegenet' input files from vcf format
	vcf_to_fastSTR.sh = create fastSTRUCTURE input files from vcf format
	faststr_to_clumpack.sh = create CLUMPAK input file from fastSTRUCTURE results
	vcf_to_arlequin.sh * = create Arlequin input files from vcf format, using PGDspider
	vcf_to_bayescan.sh * = create BayeScan input file from vcf format, using PGDspider
	vcf_to_lositan.sh * = create Lositan input file from vcf format, using PGDspider
	vcf_to_bayenv.sh * = create Bayenv2 input SNPFILE from vcf format, using PGDspider
	vcf_to_outflank.sh = create Outflank input file from vcf format
	vcf_to_lfmm.sh = create LFMM input file from vcf format
	lfmm_envirodata_file.sh = create LFMM environment input files 

Bayenv2 processing
	coral_bayenv_meanCovMat.sh = create average covariance matrix for Bayenv2. Requires: coral_bayenv_meanCovMat.py

Summarise Bayenv2 results
	coral_bayenv_results.sh = wrapper script to summaries Bayenv2 results using following three scripts
		(i) coral_bayenv_enviro_summary.py = filter Bayenv2 association results by association strength 
		(ii) coral_bayenv_summary_to_loci.sh = convert Bayenv2 SNP numbers to SNP loci
		(iii) coral_bayenv_table_results.py = create table output of Bayenv2 results (SNPs as rows, variables as columns)

Process LFMM results
	coral_lfmm_candidates_to_loci.sh = convert LFMM SNP numbers to actual SNP loci
