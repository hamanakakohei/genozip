#!/usr/bin/env bash
set -euo pipefail

export PATH=${PATH}:/path/to/genozip-linux-x86_64/
export PATH=${PATH}:/path/to/samtools-1.17/bin/
export PATH=${PATH}:/path/to/genozip/performance_check/scripts/

SAMPLE=DA0xxx
REF_GENOZIP=/path/to/Homo_sapiens_assembly38.ref.genozip


## 1. gvcf
IN=${SAMPLE}.autosome.g.vcf.gz
FORMAT=gvcf

# 1-1. normal
echo 1-1-1
TYPE=normal
ZIP_CMD=genozip
ZIPPED=${SAMPLE}.autosome.g.vcf.${TYPE}.genozip
CMD="${ZIP_CMD} \
  -e ${REF_GENOZIP} \
  -o ${ZIPPED} \
  ${IN} \
  > ${ZIP_CMD}_${FORMAT}_${TYPE}_${SAMPLE}.log 2>&1"
USAGE=usage_${ZIP_CMD}_${FORMAT}_${TYPE}_${SAMPLE}.csv
monitor_cpu_mem_for_a_command.sh "${CMD}" ${USAGE}

echo 1-1-2
ZIP_CMD=genounzip
UNZIPPED=${SAMPLE}.autosome.${ZIP_CMD}.${TYPE}.g.vcf.gz
CMD="${ZIP_CMD} \
  -e ${REF_GENOZIP} \
  -o ${UNZIPPED} \
  ${ZIPPED} \
  > ${ZIP_CMD}_${FORMAT}_${TYPE}_${SAMPLE}.log 2>&1"
USAGE=usage_${ZIP_CMD}_${FORMAT}_${TYPE}_${SAMPLE}.csv
monitor_cpu_mem_for_a_command.sh "${CMD}" ${USAGE}

# 1-2. best
echo 1-2-1
TYPE=best
ZIP_CMD=genozip
ZIPPED=${SAMPLE}.autosome.g.vcf.${TYPE}.genozip
CMD="${ZIP_CMD} \
  -e ${REF_GENOZIP} \
  -o ${ZIPPED} \
  --best \
  ${IN} \
  > ${ZIP_CMD}_${FORMAT}_${TYPE}_${SAMPLE}.log 2>&1"
USAGE=usage_${ZIP_CMD}_${FORMAT}_${TYPE}_${SAMPLE}.csv
monitor_cpu_mem_for_a_command.sh "${CMD}" ${USAGE}

echo 1-2-2
ZIP_CMD=genounzip
UNZIPPED=${SAMPLE}.autosome.${ZIP_CMD}.${TYPE}.g.vcf.gz
CMD="${ZIP_CMD} \
  -e ${REF_GENOZIP} \
  -o ${UNZIPPED} \
  ${ZIPPED} \
  > ${ZIP_CMD}_${FORMAT}_${TYPE}_${SAMPLE}.log 2>&1"
USAGE=usage_${ZIP_CMD}_${FORMAT}_${TYPE}_${SAMPLE}.csv
monitor_cpu_mem_for_a_command.sh "${CMD}" ${USAGE}


## 2. fastq
IN="${SAMPLE}_R1.fastq.gz ${SAMPLE}_R2.fastq.gz"
FORMAT=fq
CRAM=${SAMPLE}.cram

# 2-1. normal
echo 2-1-1
TYPE=normal
ZIP_CMD=genozip
ZIPPED=${SAMPLE}_R1+2.fastq.${TYPE}.genozip
CMD="${ZIP_CMD} \
  --pair \
  -e ${REF_GENOZIP} \
  -o ${ZIPPED} \
  ${IN} \
  > ${ZIP_CMD}_${FORMAT}_${TYPE}_${SAMPLE}.log 2>&1"
USAGE=usage_${ZIP_CMD}_${FORMAT}_${TYPE}_${SAMPLE}.csv
monitor_cpu_mem_for_a_command.sh "${CMD}" ${USAGE}

echo 2-1-2
ZIP_CMD=genounzip
UNZIPPED=${SAMPLE}_fastq_${TYPE}/
CMD="${ZIP_CMD} \
  -e ${REF_GENOZIP} \
  -o ${UNZIPPED} \
  ${ZIPPED} \
  > ${ZIP_CMD}_${FORMAT}_${TYPE}_${SAMPLE}.log 2>&1"
USAGE=usage_${ZIP_CMD}_${FORMAT}_${TYPE}_${SAMPLE}.csv
monitor_cpu_mem_for_a_command.sh "${CMD}" ${USAGE}

# 2-2. best
echo 2-2-1
TYPE=best
ZIP_CMD=genozip
ZIPPED=${SAMPLE}_R1+2.fastq.${TYPE}.genozip
CMD="${ZIP_CMD} \
  --pair --best \
  -e ${REF_GENOZIP} \
  -o ${ZIPPED} \
  ${IN} \
  > ${ZIP_CMD}_${FORMAT}_${TYPE}_${SAMPLE}.log 2>&1"
USAGE=usage_${ZIP_CMD}_${FORMAT}_${TYPE}_${SAMPLE}.csv
monitor_cpu_mem_for_a_command.sh "${CMD}" ${USAGE}

echo 2-2-2
ZIP_CMD=genounzip
UNZIPPED=${SAMPLE}_fastq_${TYPE}/
CMD="${ZIP_CMD} \
  -e ${REF_GENOZIP} \
  -o ${UNZIPPED} \
  ${ZIPPED} \
  > ${ZIP_CMD}_${FORMAT}_${TYPE}_${SAMPLE}.log 2>&1"
USAGE=usage_${ZIP_CMD}_${FORMAT}_${TYPE}_${SAMPLE}.csv
monitor_cpu_mem_for_a_command.sh "${CMD}" ${USAGE}

# 2-3. bamass
echo 2-3-1
TYPE=bamass
ZIP_CMD=genozip
ZIPPED=${SAMPLE}_R1+2.fastq.${TYPE}.genozip
CMD="${ZIP_CMD} \
  --pair --bamass ${CRAM} \
  -e ${REF_GENOZIP} \
  -o ${ZIPPED} \
  ${IN} \
  > ${ZIP_CMD}_${FORMAT}_${TYPE}_${SAMPLE}.log 2>&1"
USAGE=usage_${ZIP_CMD}_${FORMAT}_${TYPE}_${SAMPLE}.csv
monitor_cpu_mem_for_a_command.sh "${CMD}" ${USAGE}

echo 2-3-2
ZIP_CMD=genounzip
UNZIPPED=${SAMPLE}_fastq_${TYPE}/
CMD="${ZIP_CMD} \
  -e ${REF_GENOZIP} \
  -o ${UNZIPPED} \
  ${ZIPPED} \
  > ${ZIP_CMD}_${FORMAT}_${TYPE}_${SAMPLE}.log 2>&1"
USAGE=usage_${ZIP_CMD}_${FORMAT}_${TYPE}_${SAMPLE}.csv
monitor_cpu_mem_for_a_command.sh "${CMD}" ${USAGE}

# 2-4. bamass + best
echo 2-4-1
TYPE=bamass.best
ZIP_CMD=genozip
ZIPPED=${SAMPLE}_R1+2.fastq.${TYPE}.genozip
CMD="${ZIP_CMD} \
  --pair --bamass ${CRAM} --best \
  -e ${REF_GENOZIP} \
  -o ${ZIPPED} \
  ${IN} \
  > ${ZIP_CMD}_${FORMAT}_${TYPE}_${SAMPLE}.log 2>&1"
USAGE=usage_${ZIP_CMD}_${FORMAT}_${TYPE}_${SAMPLE}.csv
monitor_cpu_mem_for_a_command.sh "${CMD}" ${USAGE}

echo 2-4-2
ZIP_CMD=genounzip
UNZIPPED=${SAMPLE}_fastq_${TYPE}/
CMD="${ZIP_CMD} \
  -e ${REF_GENOZIP} \
  -o ${UNZIPPED} \
  ${ZIPPED} \
  > ${ZIP_CMD}_${FORMAT}_${TYPE}_${SAMPLE}.log 2>&1"
USAGE=usage_${ZIP_CMD}_${FORMAT}_${TYPE}_${SAMPLE}.csv
monitor_cpu_mem_for_a_command.sh "${CMD}" ${USAGE}


## 3. CRAM 
IN=${SAMPLE}.cram
FORMAT=cram

# 3-1. normal
echo 3-1-1
TYPE=normal
ZIP_CMD=genozip
ZIPPED=${SAMPLE}.cram.${TYPE}.genozip
CMD="${ZIP_CMD} \
  -e ${REF_GENOZIP} \
  -o ${ZIPPED} \
  ${IN} \
  > ${ZIP_CMD}_${FORMAT}_${TYPE}_${SAMPLE}.log 2>&1"
USAGE=usage_${ZIP_CMD}_${FORMAT}_${TYPE}_${SAMPLE}.csv
monitor_cpu_mem_for_a_command.sh "${CMD}" ${USAGE}

echo 3-1-2
ZIP_CMD=genocat
UNZIPPED=${SAMPLE}.${ZIP_CMD}.${TYPE}.cram
CMD="${ZIP_CMD} \
  -e ${REF_GENOZIP} \
  -o ${UNZIPPED} \
  ${ZIPPED} \
  > ${ZIP_CMD}_${FORMAT}_${TYPE}_${SAMPLE}.log 2>&1"
USAGE=usage_${ZIP_CMD}_${FORMAT}_${TYPE}_${SAMPLE}.csv
monitor_cpu_mem_for_a_command.sh "${CMD}" ${USAGE}

# 3-2. best
echo 3-2-1
TYPE=best
ZIP_CMD=genozip
ZIPPED=${SAMPLE}.cram.${TYPE}.genozip
CMD="${ZIP_CMD} \
  --best \
  -e ${REF_GENOZIP} \
  -o ${ZIPPED} \
  ${IN} \
  > ${ZIP_CMD}_${FORMAT}_${TYPE}_${SAMPLE}.log 2>&1"
USAGE=usage_${ZIP_CMD}_${FORMAT}_${TYPE}_${SAMPLE}.csv
monitor_cpu_mem_for_a_command.sh "${CMD}" ${USAGE}

echo 3-2-2
ZIP_CMD=genocat
UNZIPPED=${SAMPLE}.${ZIP_CMD}.${TYPE}.cram
CMD="${ZIP_CMD} \
  -e ${REF_GENOZIP} \
  -o ${UNZIPPED} \
  ${ZIPPED} \
  > ${ZIP_CMD}_${FORMAT}_${TYPE}_${SAMPLE}.log 2>&1"
USAGE=usage_${ZIP_CMD}_${FORMAT}_${TYPE}_${SAMPLE}.csv
monitor_cpu_mem_for_a_command.sh "${CMD}" ${USAGE}
