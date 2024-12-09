input_chunks = IO.foreach("input/05", chomp: true)
  .chunk { _1.empty? && :_separator }.lazy.map { _2 }

$precedences = input_chunks.next
  .each_with_object(Hash.new { |hash, key| hash[key] = Set.new }) do |line, hash|
    before, after = line.split('|').map(&:to_i) 
    hash[before] << after
  end

updates = input_chunks.next.map do |line| line.split(',').map(&:to_i) end

class Array
  def update_is_correct?
    each_with_index.all? do |lpage, i|
      self[(i+1)..].all? { |rpage| $precedences[lpage].include? rpage }
    end
  end
  def mid = at size/2
end

puts updates.keep_if(&:update_is_correct?).sum(&:mid)
