# TRAIN

paste NLSPARQL.train.tok NLSPARQL.train.utt.labels.txt > train_labels_merge.txt

# If a sentence is tagged with N labels than it will be repeated N times, each time with a different label
ruby multiple_labels.rb

cat NLSPARQL.train.utt.labels.txt | tr " " "\n" | sort | uniq | cut -f 2 > labels.txt
cat NLSPARQL.train.utt.labels.txt | tr " " "\n" | sort | uniq -c > labels_count.txt

cat words_labels.txt | sort | uniq -c > count.all
awk ' { t = $1; $1 = $3; $3 = t; print; } ' count.all | sort > count.all.sorted
cat NLSPARQL.train.tok | tr " " "\n" | sort | uniq -c > word.count

ruby setup.rb

# TEST
ruby test.rb > test_results.txt
paste NLSPARQL.test.utt.labels.txt test_results.txt > try_to_test.txt
ruby adjust_results.rb

 # | tr "\t" "#" | sed 's/#/+T-/g' | tr "+" "\t"
paste test_results.txt try_to_test_good.txt |  tr "\t" "#" | sed 's/#/+T-/g' | tr "+" "\t" | sed 's/^/#/g' | tr "#" "\n" > try_to_test.txt
perl conlleval.pl -d "\t" < try_to_test.txt