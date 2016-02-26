100.times.each_with_index do |i|
  remaining_bottles = 99 - i
  bottles_text = remaining_bottles != 1 ? "bottles" : "bottle"
  puts "#{remaining_bottles} #{bottles_text} of beer on the wall, #{remaining_bottles} #{bottles_text} of beer"
  puts "take one down, pass it around."

  if remaining_bottles == 0
    puts "No more bottles of beer on the wall"
  end
end


