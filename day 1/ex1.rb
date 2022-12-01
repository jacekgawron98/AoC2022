calories_on_elf = [ 0 ]
File.foreach("ex1.txt") { |line| 
    line.chomp!
    line.empty? ? calories_on_elf.push(0) : calories_on_elf[-1] += line.to_i;
}
puts calories_on_elf.max;
puts calories_on_elf.sort_by{ |i| -i }.first(3).inject(:+);