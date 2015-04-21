
@input = "try_to_test.txt"
@output = "try_to_test_good.txt"

def adjust
	f = File.open(@input, "r");
	o = File.open(@output, 'w');
	f.each_line do |line|
		expected, predicted = line.split("\t");
		predicted.delete!("\n")
		if expected.include? " " then
			good = false
			expected_labels = expected.split(" ")
			expected_labels.each do |exp|
				if (exp == predicted) then
					o.puts predicted + "\t" + exp
					good = true
					break
				end
			end
			if !good then
				o.puts predicted + "\t" + expected_labels.first
			end
		else
			o.puts line
		end
	end
	o.close
	f.close
end

adjust