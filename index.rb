def main
	files = Dir['Contents/*.md']
	url = "https://github.com/Artwalk/LittleMaster/blob/master/Contents/"
	lists = {}

	for file in files

		File.open(file)  do | text |
			text.each_line { |line|
				if line.include?"\#"
					lists[file.delete("Contents/" ".md")] = line.chomp.delete("\#")
					break
				end
			}
		end
	end

	lists.keys.sort

	File.open("README.md", "w") do |file|  
		file.puts "#LittleMaster\n\n"
		file.puts "小法师系列\n"
		file.puts "每个程序员上辈纸都是法力无边的巫师\n\n"
		file.puts "---\n\n"


		for k, v in lists
			link = "1. " + "[" + v + "](" + url + k +".md)"
			file.puts link
		end

	end 


	lists["00"] = "404"
	lists[ "%02d"% (lists.length)]  = "别点啦，还没写呢 (๑′°︿°๑)"

	for file in files

		File.open(file, File::RDWR|File::CREAT, 0644) { |f|
			f.flock(File::LOCK_EX)
			text = f.read
			if	!text.include?"-------"
				text += "\n\n-------\n上一篇：  \n下一篇："
				f.rewind
				f.write("#{text}")
				f.flush
				f.truncate(f.pos)
			end 
		}

	end

	puts lists

	for file in files

		File.open(file, File::RDWR|File::CREAT, 0644) { |f|
			f.flock(File::LOCK_EX)

			filename =  file.delete "Contents/" '.md'
			n = filename.to_i

			fNum = "%02d"% (n-1)
			pervp = "上一篇：" + "[" + lists[fNum] + "](" + url + fNum + ".md)  "

			fNum = "%02d"% (n+1)
			nextp = "下一篇：" + "[" + lists[fNum] + "](" + url + fNum + ".md)"

			text = f.read
			text = text.gsub(/^上一篇：.*$/) { pervp }
			text = text.gsub(/^下一篇：.*$/) { nextp }


			f.rewind
			f.write("#{text}")
			f.flush
			f.truncate(f.pos)
		}

	end

end



if __FILE__ == $0
	main()
end

