# Setting up the environment..
ngramsymbols NLSPARQL.train.feats.txt > lex.lex
cat NLSPARQL.train.feats.txt | cut -f 2 | sort | uniq -c | tail -n +2 > tag.count
cat NLSPARQL.train.feats.txt | cut -f 1-2 | sort | uniq -c | tail -n +2 > token-tag.count
cat NLSPARQL.train.feats.txt | cut -f 2 | sed 's/^ *$/#/g' | tr "\n" " "  | tr "#" "\n" > train_tag.txt

cat NLSPARQL.test.feats.txt | cut -f 2 | sed 's/^ *$/#/g' | tr "\n" " "  | tr "#" "\n" > tag_sentences_expected.txt
cat NLSPARQL.test.feats.txt | cut -f 1  > word_sentences.txt
cat NLSPARQL.test.feats.txt | cut -f 1 | sed 's/^ *$/#/g' | tr "\n" " "  | tr "#" "\n" > word_sentences_per_line.txt

# | sed 's/^ *$/#/g' | tr "\n" " "  | tr "#" "\n"

# It produces the out.txt file
# ruby fsa_generator.rb

fstcompile --isymbols=lex.lex --osymbols=lex.lex out.txt > out.fst
fstdraw --isymbols=lex.lex --osymbols=lex.lex --portrait=true out.fst | dot -Tjpg > out.jpg

# ruby text2fsa.rb -p "star of thor" > in.txt
# fstcompile --isymbols=lex.lex --osymbols=lex.lex in.txt > in.fst
# fstdraw --isymbols=lex.lex --osymbols=lex.lex --portrait=true in.fst | dot -Tjpg > in.jpg

# It creates the language model
farcompilestrings --symbols=lex.lex --unknown_symbol='<unk>' train_tag.txt > comp.far
ngramcount --order=3 --require_symbols=false comp.far > pos.cnt
ngrammake --method=witten_bell pos.cnt > pos.lm

# It tests the language model with the input string "star of thor"
# fstcompose in.fst out.fst | fstcompose - pos.lm | fstrmepsilon | fstshortestpath > final.fst
# fstprint --isymbols=lex.lex --osymbols=lex.lex final.fst
# fstdraw --isymbols=lex.lex --osymbols=lex.lex --portrait=true --width=10 final.fst| dot -Tjpg > final.jpg