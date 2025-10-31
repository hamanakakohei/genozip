SAMPLE_FILE=sample_gvcf.txt
DIR=results/

ls -l logs/err.*.log | awk '{print $5}' | sort | uniq -c > 1.txt
ls -l logs/out.*.log | awk '{print $5}' | sort | uniq -c > 2.txt
wc -l logs/out.*.log | sort > 3.txt
cat logs/out.*.log > 4.txt
awk '{ sub(/\.gz$/, ".genozip.log", $2); print $2 }' $SAMPLE_FILE | xargs -I{} tail -n1 {} | sort | uniq -c > 5.txt
awk '{ sub(/\.gz$/, ".genozip.log", $2); print $2 }' $SAMPLE_FILE | xargs -I{} bash -c 'wc -l < "{}"' | sort | uniq -c > 6.txt
awk '{ sub(/\.gz$/, ".genozip.log", $2); print $2 }' $SAMPLE_FILE | xargs -I{} wc -l {} > 7.txt
awk '{ sub(/\.gz$/, ".genozip.log", $2); print $2 }' $SAMPLE_FILE | xargs -I{} cat {} > 8.txt
find $DIR -name "*.g.vcf.gz" > 9.txt
awk -F/  '{print $NF}' 9.txt  | cut -d"." -f1 | sort | uniq -c | sort > 10.txt
find $DIR -name "*.g.vcf.genozip" > 11.txt
awk -F/  '{print $NF}' 11.txt | cut -d"." -f1 | sort | uniq -c | sort > 12.txt
find $DIR -name "*.g.vcf.genozip.log" > 13.txt
awk -F/  '{print $NF}' 13.txt | cut -d"." -f1 | sort | uniq -c | sort > 14.txt


mkdir check
mv [1-9].txt 1[0-4].txt check/
