@tag_count = "tag.count";
@token_tag_count = "token-tag.count";
@output_path = "out.txt";
@tags = [];

def count(lookup)
	f = File.open(@tag_count, "r");
	f.each_line do |line|
		c, tag_found = line.split(' ')
		@tags << tag_found
		return ("%.2f" % c).to_f if(tag_found == lookup)
	end
	f.close
end

def read_token_tag_file()
	f = File.open(@token_tag_count, "r");
	o = File.open(@output_path, 'w')
	prob = 0.0;
	f.each_line do |line|
		c, token, tag = line.split(' ')
		prob = ("%.2f" % c).to_f / count(tag)
		o.puts "0\t0\t" + token + "\t" + tag + "\t" + (-Math.log(prob)).to_s
	end
	f.close

	@tags.uniq.each do |t|
		o.puts "0\t0\t<unk>\t" + t + "\t" + (-Math.log((1.0 / @tags.uniq.length))).to_s
	end
	o.puts "0"
	o.close
end

read_token_tag_file