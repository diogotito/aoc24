reports = IO.foreach('../in/02').map { |line| line.split.map &:to_i }

class Array
  def deltas       = each_cons(2).map { _2 - _1 }
  def safe?        = all? { (1..3) === _1 } || all? { (-3..-1) === _1 }
  def alternatives = [self] + size.times.map { |i| dup.tap { _1.delete_at(i) } }
end

puts reports.count { _1.deltas.safe? }
puts reports.count { _1.alternatives.map(&:deltas).any? &:safe? }
