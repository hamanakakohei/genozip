#!/usr/bin/env bash

export PATH=${PATH}:/path/to/samtools-1.17/bin/


SAMPLE=DA00xxx
REF_GENOZIP=/path/to/Homo_sapiens_assembly38.ref.genozip
REF=/path/to/Homo_sapiens_assembly38.fasta


zcat  ${SAMPLE}.autosome.g.vcf.gz                        |  md5sum
zcat  ${SAMPLE}.autosome.genounzip.normal.g.vcf.gz       |  md5sum
zcat  ${SAMPLE}.autosome.genounzip.best.g.vcf.gz         |  md5sum

zcat  ${SAMPLE}_R1.fastq.gz                              |  md5sum
zcat  ${SAMPLE}_R2.fastq.gz                              |  md5sum
zcat  ${SAMPLE}_fastq_normal/${SAMPLE}_R1.fastq.gz       |  md5sum
zcat  ${SAMPLE}_fastq_normal/${SAMPLE}_R2.fastq.gz       |  md5sum
zcat  ${SAMPLE}_fastq_best/${SAMPLE}_R1.fastq.gz         |  md5sum
zcat  ${SAMPLE}_fastq_best/${SAMPLE}_R2.fastq.gz         |  md5sum
zcat  ${SAMPLE}_fastq_bamass/${SAMPLE}_R1.fastq.gz       |  md5sum
zcat  ${SAMPLE}_fastq_bamass/${SAMPLE}_R2.fastq.gz       |  md5sum
zcat  ${SAMPLE}_fastq_bamass.best/${SAMPLE}_R1.fastq.gz  |  md5sum
zcat  ${SAMPLE}_fastq_bamass.best/${SAMPLE}_R2.fastq.gz  |  md5sum

samtools view -T ${REF} ${SAMPLE}.cram       	      |  md5sum
samtools view -T ${REF} ${SAMPLE}.genocat.best.cram   |  md5sum
samtools view -T ${REF} ${SAMPLE}.genocat.normal.cram |  md5sum
