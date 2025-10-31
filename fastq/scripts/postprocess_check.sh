SAMPLE_FILE=sample_fastq-prefix_cram__R1_001.fastq.gz__1720_ordered.txt

ls -l logs/err.*.log | awk '{print $5}' | sort | uniq -c > 1.txt
ls -l logs/out.*.log | awk '{print $5}' | sort | uniq -c > 2.txt
wc -l logs/out.*.log > 3.txt
cat logs/out.*.log > 4.txt
awk '{print $2"_R1+2.fastq.genozip.log"}' $SAMPLE_FILE | xargs -I{} tail -n1 {} | sort | uniq -c > 5.txt
awk '{print $2"_R1+2.fastq.genozip.log"}' $SAMPLE_FILE | xargs -I{} bash -c 'wc -l < "{}"' | sort | uniq -c > 6.txt
awk '{print $2"_R1+2.fastq.genozip.log"}' $SAMPLE_FILE | xargs -I{} wc -l {} | sort > 7.txt
awk '{print $2"_R1+2.fastq.genozip.log"}' $SAMPLE_FILE | xargs -I{} cat {} > 8.txt
find /betelgeuse10/analysis/wgs/ncgm2024/data/ -name "*fastq.gz" > 9.txt
find /betelgeuse10/analysis/wgs/ncgm2024/data/ -name "*fastq.genozip" > 10.txt
find /betelgeuse10/analysis/wgs/ncgm2024/data/ -name "*fastq.genozip.log" > 11.txt

mkdir check
mv [1-9].txt 10.txt 11.txt check/

