load "text2fsa.rb";

@expected = "tag_sentences_expected.txt";
@word = "word_sentences.txt";

def read_file()
	e = File.open(@expected, "r");
	w = File.open(@word, "r");
	o = File.open("resulted.txt", 'w')

	w.each_line do |line|

		puts parse_input line

		# words = line.split(' ')
		# words.each do |word|
		# 	o.puts word
		# end
		# o.puts "";
	end
	o.close
	w.close
	e.close
end

read_file