reports = IO.foreach('input/02').map { |line| line.split.map &:to_i }

# Part 1
to_deltas = ->(report) { report.each_cons(2).map { _2 - _1 } }
is_safe = -> (ds) { [(-3..-1), (1..3)].any? { |rng| ds.all? &rng.method(:===) } }

puts reports.count &is_safe << to_deltas


# Part 2
def make_alternatives(r) =
  [r] + r.size.times.map { |i| r.dup.tap { _1.delete_at(i) } }

pp reports.count { make_alternatives(_1).any? &is_safe << to_deltas }
