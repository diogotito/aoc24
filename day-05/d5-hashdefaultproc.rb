input_chunks = IO.foreach("../in/05", chomp: true)
  .chunk { _1.empty? && :_separator }.lazy.map { _2 }

$precedences = Hash.new { |hash, key| hash[key] = Set.new }
input_chunks.next.each do |line|
  before, after = line.split('|').map(&:to_i)
  $precedences[before] << after
end

updates = input_chunks.next.map { _1.split(',').map(&:to_i) }

class Array
  def update_is_correct?
    each_with_index.all? do |lpage, i|
      self[(i+1)..].all? { |rpage| $precedences[lpage].include? rpage }
    end
  end
  def mid = at size/2
end

sorted, unsorted = updates.partition(&:update_is_correct?)

part1 = sorted.sum(&:mid)
puts "Part One: #{part1}"

part2 = unsorted.sum do |update|
  puts "sorting #{update}"
  update.permutation.find(&:update_is_correct?).mid
end
puts "Part Two: #{part2}"
