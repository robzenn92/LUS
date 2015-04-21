@lemma_var = {}

def find_replace_with_lemmas(path)
	f = File.open(path, "r");
	
	f.each_line do |line|
		words = line.split(" ");
		words.each do |w|
			if (@lemma_var.has_key?(w)) then
				lemma = @lemma_var["#{w}"]
				if(w == words.last) then 
					printf("%s\n", lemma)
				else
					print lemma + " "
				end
			end
		end
	end
	f.close
end

def load_lemmas(lemma_path)
	f = File.open(lemma_path, "r");
	f.each_line do |line|
		word, lemma = line.split(" ");
		lemma.delete!("\n")

		if(@lemma_var.length != 0) then
			@lemma_var.merge!({ word => lemma })
		else
			@lemma_var = { word => lemma }
		end
	end
	f.close
end

if not ARGV.empty? then
	if ARGV.length == 2 then
		load_lemmas(ARGV[0])
		find_replace_with_lemmas(ARGV[1])
	end
end