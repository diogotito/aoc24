input_stones = File.readlines('../in/11').first.split.map &:to_i

def blink(stone)
  return [1] if stone.zero?

  ndigits = Math::log10(stone).floor + 1
  return stone.divmod 10 ** (ndigits / 2) if ndigits.even?

  [stone * 2024]
end

blink_counter = Hash.new do |counter, (stone, blinks)|
  counter[[stone, blinks]] = if blinks.zero?
                               1
                             else
                               blink(stone).sum do |new_stone|
                                 blink_counter[[new_stone, blinks - 1]]
                               end
                             end
end


puts "Part One: #{input_stones.sum { |stone| blink_counter[[stone, 25]] }}" # 187738
puts "Part Two: #{input_stones.sum { |stone| blink_counter[[stone, 75]] }}" # 223767210249237
