files = Dir['Contents/*.md']

lists = {}


for file in files

	File.open(file)  do | text |
		text.each_line{ |line|
			if line.include?"title: "
				lists[file.delete("Contents/")] = line.chomp.delete("title: ")
				break
			end
		}
	end 
end

lists.keys.sort

# print lists


File.open("README.md", "w") do |file|  
	file.puts "#LittleMaster\n\n"
	file.puts "从前有个小法师\n\n"
	file.puts "---\n\n"

	url = "https://github.com/Artwalk/LittleMaster/blob/master/Contents/"

	for k, v in lists
		link = "1. " + "[" + v + "](" + url + k +")"
		file.puts link
	end

end 

