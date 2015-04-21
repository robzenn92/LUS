# Clear
sh clean.sh

# Setting up the environment..
echo "\nSetting up the environment.."
ngramsymbols NLSPARQL.train.feats.txt > lex.lex
cat NLSPARQL.train.feats.txt | cut -f 2 | sort | uniq -c | tail -n +2 > tag.count
cat NLSPARQL.train.feats.txt | cut -f 1 > token.list
cat NLSPARQL.train.feats.txt | cut -f 1-2 | sort | uniq -c | tail -n +2 > token-tag.count
cat NLSPARQL.train.feats.txt | cut -f 2 | sed 's/^ *$/#/g' | tr "\n" " "  | tr "#" "\n" > train_tag.txt

cat NLSPARQL.test.feats.txt | cut -f 2 > tag_sentences_expected.txt
cat NLSPARQL.test.feats.txt | cut -f 2 | sed 's/^ *$/#/g' | tr "\n" " "  | tr "#" "\n" > tag_sentences_expected_per_line.txt
cat NLSPARQL.test.feats.txt | cut -f 1  > word_sentences.txt
cat NLSPARQL.test.feats.txt | cut -f 1 | sed 's/^ *$/#/g' | tr "\n" " "  | tr "#" "\n" > word_sentences_per_line.txt

# It produces the out.txt file
echo "Generating the tagger.. stored in out.fst"
ruby fsa_generator.rb

fstcompile --isymbols=lex.lex --osymbols=lex.lex out.txt > out.fst

# It builds the language model
echo "Building the language model.."
farcompilestrings --symbols=lex.lex --unknown_symbol='<unk>' train_tag.txt > comp.far
ngramcount --order=3 --require_symbols=false comp.far > pos.cnt
ngrammake --method=witten_bell pos.cnt > pos.lm

echo "Done.\n"