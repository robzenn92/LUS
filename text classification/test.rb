
@test_file = "NLSPARQL.test.tok"
@test_results = "test_results.txt"
@labels_file = "labels.txt"
@prob_file = "output.txt"
@label_count = "label_count.txt"

@labels = []
@prob_file_var = []
@cardinality = []

def set_label(str)
	max = 0.0
	predicted_label = ""
	@labels.each do |label|
		act = calc_prob(str, label)
		if (max < act) then
			max = act
			predicted_label = label
		end
	end
	puts "HA VINTO " +predicted_label
	predicted_label
end

def calc_prob(str, label)
	puts "calc prob di \"" + str + "\" con label=" + label
	prob = 1.0;
	str.split(" ").each do |word|
		prob *= calc_prob_token(word, label)
	end
	prob

end

def calc_prob_token(word, label)
	@prob_file_var.each do |line|
		lab, token, prob = line.split("\t")
		return prob.to_f if(lab == label and token == word)
	end
	puts count(label)
	return 1.0/9999999999; #count(label);
end

def count(label)
	@cardinality.each do |line|
		c, lab = line.split(" ")
		return c.to_f if(lab == label)
	end
	0.0
end

def get_labels
	i = File.open(@labels_file, 'r');
	i.each_line do |label|
		@labels << label.delete!("\n")
	end
	i.close
end

def get_sentences
	i = File.open(@test_file, 'r');
	sentences = []
	i.each_line do |line|
		sentences << line.delete!("\n")
	end
	i.close
	sentences
end

def get_prob_file_var
	i = File.open(@prob_file, 'r');
	i.each_line do |line|
		@prob_file_var << line.delete!("\n")
	end
	i.close
end

def get_cardinality_labels
	label_count = File.open(@label_count, "r");
	label_count.each_line do |line|
		@cardinality << line
	end
	label_count.close
end

def test()

	get_labels
	sentences = get_sentences
	get_prob_file_var
	get_cardinality_labels

	@o = File.open(@test_results, 'w');
	sentences.each do |sentence|
		@o.puts set_label(sentence.delete("\n"))
	end
	@o.close

end

test