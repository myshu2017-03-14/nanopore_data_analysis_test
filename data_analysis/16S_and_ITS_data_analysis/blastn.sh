#!/usr/bin/env bash 
#!/bin/bash
# echo the help if not input all the options
help()
{
cat <<HELP
USAGE: $0 fasta_dir fasta_len_dir
    or $0 ‐h # show this message
EXAMPLE:
    $0 test/ test/
HELP
exit 0
}
[ -z "$1" ] && help
[ "$1" = "-h" ] && help

IN_DIR=$1 # input fasta file
IN_LEN=$2 # input length file of fasta
if [ ! -d "blastn_out" ]; then
	mkdir blastn_out
fi
cd blastn_out
for i in $IN_DIR/BC*.fasta
do
	name=$(basename $i .fasta)
	# 16S
	blastn -query $i -db /database/16S_db/NCBI-16S/blast_db/NCBI-16S-18998 -out $name\_blastn_16S.out -outfmt 6 -evalue 1e-5 -num_threads 6 -max_target_seqs 5
	perl /database/program/result2anno.pl -in $name\_blastn_16S.out -tab /database/16S_db/NCBI-16S/NCBI-16S-18998.tab -out $name\_blastn_16S_anno.out
	perl /database/program/calculate_coverage_for_blast_results.pl -in $name\_blastn_16S_anno.out -len $IN_LEN/$name.len -out $name\_blastn_16S_anno_cov.out
	perl /database/program/get_one_results_of_each.pl -in $name\_blastn_16S_anno_cov.out -out $name\_blastn_16S_anno_cov_uniq.out

	# ITS
	blastn -query $i -db /database/ITS_db/NCBI-refseq-targetedloci/blast_db/fungi.ITS -out $name\_blastn_ITS.out -outfmt 6 -evalue 1e-5 -num_threads 6 -max_target_seqs 5
	perl /database/program/result2anno.pl -in $name\_blastn_ITS.out -tab /database/ITS_db/NCBI-refseq-targetedloci/fungi.ITS.tab -out $name\_blastn_ITS_anno.out
	perl /database/program/calculate_coverage_for_blast_results.pl -in $name\_blastn_ITS_anno.out -len $IN_LEN/$name.len -out $name\_blastn_ITS_anno_cov.out
	perl /database/program/get_one_results_of_each.pl -in $name\_blastn_ITS_anno_cov.out -out $name\_blastn_ITS_anno_cov_uniq.out


done	