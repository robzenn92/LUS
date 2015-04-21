
@test_file = "NLSPARQL.test.tok"
@test_results = "test_results.txt"
@labels_file = "labels.txt"
@prob_file = "output.txt"
@label_count = "label_count.txt"

@labels = []
@prob_file_var = {}
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
	predicted_label
end

def calc_prob(str, label)
	prob = 1.0;
	str.split(" ").each do |word|
		prob *= calc_prob_token(word, label)
	end
	prob
end

def calc_prob_token(word, label)
	return @prob_file_var[label][word] if(@prob_file_var.has_key?(label) and @prob_file_var[label].has_key?(word))
	return 1.0/116130; # train word count
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
		lab, token, prob = line.delete!("\n").split("\t")
		if(!@prob_file_var.has_key?(lab))
			if(@prob_file_var.length != 0) then
				@prob_file_var.merge!({ lab => {token => prob.to_f} })
			else
				@prob_file_var = { lab => {token => prob.to_f} }
			end
		else
			@prob_file_var["#{lab}"].merge!({token => prob.to_f})
		end
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

	sentences.each do |sentence|
		puts set_label(sentence.delete("\n"))
	end
end

test