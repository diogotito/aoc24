input_chunks = IO.foreach("../in/05", chomp: true)
  .chunk { _1.empty? && :_separator }.lazy.map { _2 }

$precedences = input_chunks.next
  .each_with_object(Hash.new { |hash, key| hash[key] = Set.new }) do |line, hash|
    before, after = line.split('|').map(&:to_i) 
    hash[before] << after
  end
updates = input_chunks.next.map { |line| line.split(',').map(&:to_i) }

def update_is_correct?(update)
  update.each_with_index.all? do |lpage, i|
    update[(i+1)..].all? { |rpage| $precedences[lpage].include? rpage }
  end
end
puts updates.keep_if { update_is_correct? _1 }.sum { _1[_1.size / 2] }
