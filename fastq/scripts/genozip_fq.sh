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
UNZIPPED_DIR="genounzip_${FQ_BASE}/"
UNZIP_R1="${UNZIPPED_DIR}/${FQ_BASE}_R1.fastq.gz"
UNZIP_R2="${UNZIPPED_DIR}/${FQ_BASE}_R2.fastq.gz"

# PATH設定
export PATH="${PATH}:/path/to/samtools-1.17/bin"
export PATH="${PATH}:/path/to/genozip-linux-x86_64"


echo "FASTQ: $FQ_PREFIX"
echo "CRAM: $CRAM"
echo "REF: $REF_GENOZIP"


echo "genozipping..."
genozip \
  --pair \
  --bamass "$CRAM" \
  -e "$REF_GENOZIP" \
  -o "$ZIPPED" \
  --threads $THREAD \
  "$IN_R1" "$IN_R2"


echo "genounzipping..."
genounzip -e "${REF_GENOZIP}" -o "${UNZIPPED_DIR}" "${ZIPPED}"

# 展開後のファイル確認
if [[ ! -f "${UNZIP_R1}" || ! -f "${UNZIP_R2}" ]]; then
  echo "Error: genounzipped files not found." >&2
  rm -f "${ZIPPED}"
  exit 1
fi


echo "calculating md5..."
ORIG_MD5_R1=$(zcat "${IN_R1}" | md5sum | cut -d ' ' -f1)
UNZIP_MD5_R1=$(zcat "${UNZIP_R1}" | md5sum | cut -d ' ' -f1)
ORIG_MD5_R2=$(zcat "${IN_R2}" | md5sum | cut -d ' ' -f1)
UNZIP_MD5_R2=$(zcat "${UNZIP_R2}" | md5sum | cut -d ' ' -f1)

echo "R1 MD5 original: ${ORIG_MD5_R1}"
echo "R1 MD5 unzipped: ${UNZIP_MD5_R1}"
echo "R2 MD5 original: ${ORIG_MD5_R2}"
echo "R2 MD5 unzipped: ${UNZIP_MD5_R2}"


if [[ "${ORIG_MD5_R1}" != "${UNZIP_MD5_R1}" || "${ORIG_MD5_R2}" != "${UNZIP_MD5_R2}" ]]; then
  echo "MD5s not matched, deleting genozipped files..."
  rm -v "${ZIPPED}" "${UNZIP_R1}" "${UNZIP_R2}"
  rmdir "${UNZIPPED_DIR}"
  exit 1
else
  echo "MD5s matched, deleting original files..."
  rm -v "${IN_R1}" "${IN_R2}" "${UNZIP_R1}" "${UNZIP_R2}"
  rmdir "${UNZIPPED_DIR}"
  echo "Succeeded."
fi
