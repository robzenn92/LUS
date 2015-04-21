@input = "train_labels_merge_splitted.txt";
@output_label = "words_labels.txt"

@words = "word.count"
@label = "count.all.sorted"

@output = "output.txt"

def setup
	f = File.open(@input, "r");
	o = File.open(@output_label, 'w');
	f.each_line do |line|
		sentence, label = line.split("\t");
		sentence.split(" ").each do |word|
			o.puts word + "\t" + label
		end
	end
	o.close
	f.close
end

def count(label)
	words = File.open(@words, "r");
	words.each_line do |line|
		c, token = line.split(" ")
		return c if(token == label)
	end
	words.close
end

def cal_prob
	out = File.open(@output, 'w');
	labels = File.open(@label, 'r');
	labels.each_line do |line|
		label, token, count = line.split(" ")
		prob = (count.to_f / ("%.8f" % count(token)).to_f)
		out.puts "#{label}\t#{token}\t#{prob.to_s}"
	end
	out.close
	labels.close
end

setup
cal_prob