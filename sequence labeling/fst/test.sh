
i=0
rm -f tag_sentences_tagged.txt
lines=$(wc -l < word_sentences_per_line.txt)

while read line
do
	i="$((i+1))"

	# PROGRESS BAR:
	# Testing: [#######		] 70%
	# ---------------------------
	VAR=$((i))*10/$((lines))
	printf '\rTesting: [';
	for p in {1..10}
	do
	   	if [ "$((p))" -le "$((VAR))" ]; then
        	printf '##';
        else
        	printf '  ';
        fi
	done
	printf '] ';
	printf $((VAR))0;

	# printf '] ';
	# ---------------------------

	ruby text2fsa.rb -p "$line" > in.txt
	fstcompile --isymbols=lex.lex --osymbols=lex.lex in.txt > in.fst

	# It tests the language model with the input string
	fstcompose in.fst out.fst | fstcompose - pos.lm | fstrmepsilon | fstshortestpath > final.fst
	fstprint --isymbols=lex.lex --osymbols=lex.lex --fst_align final.fst | sort -r -g | cut -f 4 >> tag_sentences_tagged.txt

done < word_sentences_per_line.txt
echo "\n"
echo "$i sentences tested."

# Wrap up results..
paste word_sentences.txt tag_sentences_expected.txt tag_sentences_tagged.txt | sed '/^ *$/d' | tr "\t" "#" | sed 's/##//g' | sed 's/#/_T-/g' | tr "_" "\t" > result.txt

# Evaluation
perl conlleval.pl -d "\t" < result.txt