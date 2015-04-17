# TRAIN

paste NLSPARQL.train.tok NLSPARQL.train.utt.labels.txt > train_labels_merge.txt
cat NLSPARQL.train.utt.labels.txt | tr " " "\n" | sort | uniq | cut -f 2 > labels.txt
cat NLSPARQL.train.utt.labels.txt | tr " " "\n" | sort | uniq -c > labels_count.txt

cat words_labels.txt | sort | uniq -c > count.all
awk ' { t = $1; $1 = $3; $3 = t; print; } ' count.all | sort > count.all.sorted
cat NLSPARQL.train.tok | tr " " "\n" | sort | uniq -c > word.count

ruby setup.rb

# TEST

ruby test.rb

paste test_results.txt test_results.txt NLSPARQL.test.utt.labels.txt > try_to_test.txt
perl conlleval.pl -d "\t" < try_to_test.txt