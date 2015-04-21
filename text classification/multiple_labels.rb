@input = "train_labels_merge.txt"
@output = "train_labels_merge_splitted.txt"

def setup
	f = File.open(@input, "r");
	o = File.open(@output, 'w');
	f.each_line do |line|
		sentence, label = line.split("\t");
		label.split(" ").each do |l|
			o.puts sentence + "\t" + label
		end
	end
	o.close
	f.close
end

setup