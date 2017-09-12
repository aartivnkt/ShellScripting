#!/bin/bash
#pipeline to align reads to reference genomes

#$ -N Align_PE
#$ -S /bin/bash
#$ -l h_vmem=5g
#$ -cwd 
#$ -q blades.q
#$ -o /scratch/aartiv/Lemur/Lemur_SNP/Alignments
#$ -e /scratch/aartiv/Lemur/Lemur_SNP/Alignments

bwa_path=/mnt/lustre/home/aartiv/Scripts/BWA/bwa-0.5.9

#echo Running $bwa_path/bwa sampe -a $1 -f $2/$3.PE.sam  Reference/Dyakuba_Ref.fasta $2/$4 $2/$5 $6 $7

#bwa_path/bwa sampe -a $1 -f $2/$3.PE.sam  Reference/Dyakuba_Ref.fasta $2/$4 $2/$5 $6 $7

echo Running $bwa_path/bwa sampe -f $1/$2.PE.sam /scratch/aartiv/Lemur/Lemur_SNP/gapClosed.scafSeq $2/$4 $2/$5 $6 $7
$bwa_path/bwa sampe -a $1 -f $2/$3.PE.sam /scratch/aartiv/Lemur/Lemur_SNP/gapClosed.scafSeq $2/$4 $2/$5 $6 $7

echo  Running samtools view -bS $2/$3.PE.sam > $2/$3.PE.bam
samtools view -bS $2/$3.PE.sam > $2/$3.PE.bam

echo filtering alignment based on mapping quality and retain only proper pairs
samtools view -b -q 20 -f 0x0002 $2/$3.PE.bam > $2/$3.PE.reliable.mapping.bam

echo Running samtools sort 
samtools sort $2/$3.PE.reliable.mapping.bam $2/$3.PE.sort

echo removing PCR duplicates
samtools rmdup $2/$3.PE.sort.bam $2/$3.PE.nodup.sort.bam

echo indexing the bam
samtools index $2/$3.PE.nodup.sort.bam

#create the read group file

#echo Appending to Yakuba.PE.rg.txt  

echo Appending to Lemur.rg.txt
echo -e "@RG\tID:$3.PE.nodup.sort\tSM:$3\tLB:Lib-$3\tPL:Illumina" >> /scratch/aartiv/Lemur/Lemur_SNP/Alignments/Lemur.rg.txt
