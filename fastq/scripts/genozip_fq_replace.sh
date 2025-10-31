#!/bin/bash
set -euo pipefail


# 引数確認
if [[ $# -ne 4 ]]; then
  echo "Usage: $0 <FQ_PREFIX> <CRAM_FILE> <REF_GENOZIP> <THREAD>"
  exit 1
fi

# 引数取得
FQ_PREFIX="$1"
CRAM="$2"
REF_GENOZIP="$3"
THREAD="$4"

# パスの分解
FQ_DIR=$(dirname "${FQ_PREFIX}")
FQ_BASE=$(basename "${FQ_PREFIX}")

# ファイル定義
FQ_DIR="${FQ_DIR:?FQ_DIR is empty}"
IN_R1="${FQ_DIR}/${FQ_BASE}_R1.fastq.gz"
IN_R2="${FQ_DIR}/${FQ_BASE}_R2.fastq.gz"
ZIPPED="${FQ_DIR}/${FQ_BASE}_R1+2.fastq.genozip"

# PATH設定
export PATH="/path/to/samtools-1.17/bin:${PATH}"
export PATH="${PATH}/path/to/genozip-linux-x86_64"


echo "FASTQ: $FQ_PREFIX"
echo "CRAM: $CRAM"
echo "REF: $REF_GENOZIP"


echo "calculating md5..."
#ORIG_MD5_R1GZ=$(md5sum "$IN_R1" | cut -d ' ' -f1)
#ORIG_MD5_R2GZ=$(md5sum "$IN_R2" | cut -d ' ' -f1)
#echo "R1.gz MD5 original: $ORIG_MD5_R1GZ"
#echo "R2.gz MD5 original: $ORIG_MD5_R2GZ"
ORIG_MD5_R1=$(zcat "$IN_R1" | md5sum | cut -d ' ' -f1)
ORIG_MD5_R2=$(zcat "$IN_R2" | md5sum | cut -d ' ' -f1)
echo "R1 MD5 original: $ORIG_MD5_R1"
echo "R2 MD5 original: $ORIG_MD5_R2"


echo "genozipping..."
genozip \
  --replace \
  --pair \
  --bamass "$CRAM" \
  -e "$REF_GENOZIP" \
  -o "$ZIPPED" \
  --threads $THREAD \
  "$IN_R1" "$IN_R2"

#ZIPPED_MD5=$(md5sum "$ZIPPED" | cut -d ' ' -f1)
#echo "Genozipped MD5: $ZIPPED_MD5"


echo "finished"
