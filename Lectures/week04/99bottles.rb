class Bottles

  def self.main
    100.times.each_with_index do |i|
      remaining_bottles = 99 - i
      puts "#{remaining_bottles} #{pluralized_bottles(remaining_bottles)} of beer on the wall, #{remaining_bottles} #{pluralized_bottles(remaining_bottles)} of beer"
      puts "take one down, pass it around."

      if remaining_bottles == 0
        puts "No more bottles of beer on the wall"
      end
    end
  end

  private

  def self.pluralized_bottles(number)
    return "bottles" if number != 1
    "bottle"
  end

end

Bottles.main
