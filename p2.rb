input = File.readlines("input/02", chomp: true)

ex = [
"7 6 4 2 1",
"1 2 7 8 9",
"9 7 6 2 1",
"1 3 2 4 5",
"8 6 4 4 1",
"1 3 6 7 9"
]

def unsafe?(l)
  dir = l[0] > l[-1] ? :dec : :inc
  l[1..].each.with_index(1) { |cur, i|
    prev = l[i-1]
    if (dir == :dec && prev < cur) || (dir == :inc && prev > cur) || ((prev-cur).abs < 1) || ((prev-cur).abs > 3)
      return i
    end
  }
  nil
end

def part_one(input)
  input = input.map { _1.split.map(&:to_i) }
  input.count { !unsafe?(_1) }
end

puts part_one(input) # 252

def part_two(input)
  input = input.map { _1.split.map(&:to_i) }
  input.map { |l|
    f = unsafe?(l)
    next if !f
    next if !unsafe?(l[...f]+l[f+1..])
    f += 1
    next if !unsafe?(l[...f]+l[f+1..])
    f -= 2
    unsafe?(l[...f]+l[f+1..])
  }.count(&:nil?)
end

puts part_two(input) # 324
