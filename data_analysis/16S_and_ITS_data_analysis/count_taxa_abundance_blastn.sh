#!/bin/bash
#!/usr/bin/env bash 
# echo the help if not input all the options
help()
{
cat <<HELP
USAGE: $0 blastn_out_dir
    or $0 ‐h # show this message
EXAMPLE:
    $0 .
HELP
exit 0
}
[ -z "$1" ] && help
[ "$1" = "-h" ] && help

in=$1

# 16S
for i in $in/blastn_out/*16S_anno_cov_uniq.out
do
	name=$(basename $i .out)
	cut -f 2 $i|grep -v 'Subject'|grep -v 'No hits found'|sort|uniq > $name.taxa.ref.ids
	perl /analysis/software_han/3-finaldata/nanopore-data-out/program/get_taxa_abundance/get_subset_matrix.pl -list $name.taxa.ref.ids -i /database/16S_db/NCBI-16S/NCBI-16S-18998.taxa.tab -n 1 -o $name.taxa.ref.txt
	perl /analysis/software_han/3-finaldata/nanopore-data-out/program/get_taxa_abundance/get_taxa_for_blastTab.pl -i $i -id $name.taxa.ref.txt -o $name.taxa.out
	for n in 1 2 3 4 5 6 7
	do
		/analysis/software_han/3-finaldata/nanopore-data-out/program/get_taxa_abundance/get_taxa_abundace.sh $name.taxa.out $n $name.abundance.level$n.out 16 n
	done
done
# ITS
for i in $in/blastn_out/*ITS_anno_cov_uniq.out
do
	name=$(basename $i .out)
	cut -f 2 $i|grep -v 'Subject'|grep -v 'No hits found'|sort|uniq > $name.taxa.ref.ids
	perl /analysis/software_han/3-finaldata/nanopore-data-out/program/get_taxa_abundance/get_subset_matrix.pl -list $name.taxa.ref.ids -i /database/ITS_db/NCBI-refseq-targetedloci/fungi.ITS.taxa.tab -n 1 -o $name.taxa.ref.txt
	perl /analysis/software_han/3-finaldata/nanopore-data-out/program/get_taxa_abundance/get_taxa_for_blastTab.pl -i $i -id $name.taxa.ref.txt -o $name.taxa.out
	for n in 1 2 3 4 5 6 7
	do
		/analysis/software_han/3-finaldata/nanopore-data-out/program/get_taxa_abundance/get_taxa_abundace.sh $name.taxa.out $n $name.abundance.level$n.out 16 n
	done
done

rm *_blastn*.taxa.ref.* 
mv *_blastn*.abundance* *blastn*.taxa.out $in/blastn_out/
