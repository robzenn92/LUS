
@lexer_path = "token.list";

def is_in_train(word)
	f = File.open(@lexer_path, "r");
	f.each_line do |line|
		if (line == word + "\n")
			return true
		end
	end
	f.close
	false
end

def parse_input(str, print = false)

	result = ""
	v = str.split(" ");
	s = 0;

	for i in 0..(v.length - 1) do
		if(is_in_train(v[i])) then
			result += s.to_s + "\t" + (s + 1).to_s + "\t" + v[i].to_s + "\t" + v[i].to_s + "\n";
		else
			result += s.to_s + "\t" + (s + 1).to_s + "\t<unk>\t<unk>\n";
		end
		s = s + 1;
	end

	result += s.to_s;
	puts result if print
	result
end

if not ARGV.empty? then
	ARGV.length == 1 ? parse_input(ARGV[0]) : parse_input(ARGV[1], true)
end