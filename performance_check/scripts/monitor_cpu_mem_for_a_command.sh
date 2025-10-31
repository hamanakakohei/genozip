#!/bin/bash


# 使い方:
# ./monitor_cpu_mem_for_a_command.sh "<command>" [output_file.csv]

# 引数チェック
if [ $# -lt 1 ]; then
  echo "Usage: $0 \"<command to run>\" [output_file]"
  exit 1
fi

# コマンド引数
CMD="$1"

# 出力ファイル名（第2引数があればそれ、なければ usage.csv）
OUTPUT_FILE="${2:-usage.csv}"

# 開始時刻（UNIXタイムスタンプ）
START_TIME=$(date +%s)

# 任意のコマンドをバックグラウンドで実行
eval "$CMD &"
PID=$!

# CSVヘッダー
echo "elapsed_sec,cpu,mem_gb" > "$OUTPUT_FILE"

# 監視ループ
while kill -0 $PID 2>/dev/null; do
  CURRENT_TIME=$(date +%s)
  ELAPSED=$((CURRENT_TIME - START_TIME))
  CPU=$(ps -p $PID -o %cpu=)
  CPU=$(echo "$CPU" | xargs) 
  RSS_KB=$(ps -p $PID -o rss=)
  MEM_GB=$(echo "scale=2; $RSS_KB / 1048576" | bc)
  echo "${ELAPSED},${CPU},${MEM_GB}" >> "$OUTPUT_FILE"
  sleep 1
done

