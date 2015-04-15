
i=0

rm tag_sentences_tagged.txt

while read line
do
	i="$((i+1))"
	echo $line

	ruby text2fsa.rb -p "$line" > in.txt
	fstcompile --isymbols=lex.lex --osymbols=lex.lex in.txt > in.fst

	# It tests the language model with the input string
	fstcompose in.fst out.fst | fstcompose - pos.lm | fstrmepsilon | fstshortestpath > final.fst

	# echo "fstprint --isymbols=lex.lex --osymbols=lex.lex final.fst\n"
	# fstprint --isymbols=lex.lex --osymbols=lex.lex final.fst | sort
	# # fstdraw --isymbols=lex.lex --osymbols=lex.lex --portrait=true --width=10 final.fst| dot -Tjpg > final.jpg
	# echo "-----\n"

	# | sed 's/^ *$/#/g' | tr "\n" " "  | tr "#" "\n"
	# | sed 's/^ *$/#/g' | tr "\n" " "  | tr "#" "\n"
	# echo "$line" >> tag_sentences_tagged.txt
	# fstprint --isymbols=lex.lex --osymbols=lex.lex final.fst | sort -r | cut -f 4 >> tag_sentences_tagged.txt

	fstprint --isymbols=lex.lex --osymbols=lex.lex --fst_align final.fst | sort -r | cut -f 4 | sed 's/^ *$/#/g' | tr "\n" " "  | tr "#" "\n"
	# fstdraw --isymbols=lex.lex --osymbols=lex.lex --portrait=true --width=10 final.fst| dot -Tjpg > final.jpg

	# fstprint --isymbols=lex.lex --osymbols=lex.lex final.fst | cut -f 4 >> tag_sentences_tagged.txt
	# fstprint --isymbols=lex.lex --osymbols=lex.lex final.fst | sort -r | cut -f 4 >> tag_sentences_tagged_sorted.txt

	# fstdraw --isymbols=lex.lex --osymbols=lex.lex --portrait=true --width=10 final.fst| dot -Tjpg > final.jpg
	# fstprint --isymbols=lex.lex --osymbols=lex.lex final.fst | sort -r | cut -f 4 | sed 's/^ *$/#/g' | tr "\n" " "  | tr "#" "\n"

	# echo "cat outputttone.txt:\n"
	# cat outputttone.txt
	# echo "-----\n"

done < word_sentences_per_line.txt

echo "$i sentences has been tested."