#!/usr/bin/env bash
set -euo pipefail

export PATH="/path/to/samtools-1.17/bin:$PATH"
export PATH="/path/to/genozip-linux-x86_64:$PATH"


# 引数
if [[ $# -ne 3 ]]; then
  echo "Usage: $0 <GVCF.gz> <REFERENCE_GENOME.genozip> <THREADS>"
  exit 1
fi

GVCF="$1"
REF="$2"
THREAD="$3"


# ファイル名の設定
ZIPPED="${GVCF%.gz}.genozip"
UNZIPPED="${ZIPPED}.genounzip.vcf.gz"


# クリーンアップ関数
cleanup() {
  [[ -f "$ZIPPED" ]] && rm -v "$ZIPPED"
  [[ -f "$UNZIPPED" ]] && rm -v "$UNZIPPED"
}
trap cleanup ERR


# 元のMD5チェック
MD5_ORIG_GZ=$(md5sum "$GVCF" | awk '{print $1}')
MD5_ORIG_RAW=$(zcat "$GVCF" | md5sum | awk '{print $1}')
echo "Original MD5 (gz): $MD5_ORIG_GZ"
echo "Original MD5 (raw): $MD5_ORIG_RAW"


# 圧縮とMD5チェック
genozip \
  -e "$REF" \
  -o "$ZIPPED" \
  --threads "$THREAD" \
  "$GVCF"
  #--replace

MD5_ZIPPED=$(md5sum "$ZIPPED" | awk '{print $1}')
echo "Genozipped MD5: $MD5_ZIPPED"


# 解凍とMD5チェック
genounzip \
  -e "$REF" \
  -o "$UNZIPPED" \
  --threads "$THREAD" \
  "$ZIPPED"

MD5_UNZIPPED=$(zcat "$UNZIPPED" | md5sum | awk '{print $1}')
echo "Genounzipped MD5: $MD5_UNZIPPED"


# 比較
if [[ "$MD5_ORIG_RAW" != "$MD5_UNZIPPED" ]]; then
  echo "ERROR: MD5 mismatch"
  exit 1
else
  echo "MD5 matched"
  #rm -v "$GVCF"
  rm -v "$UNZIPPED"
fi

echo "Done."
