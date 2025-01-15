reports = IO.foreach('../in/02').map { |line| line.split.map &:to_i }

to_deltas = ->(report) { report.each_cons(2).map { _2 - _1 } }
is_safe = ->(ds) { [(-3..-1), (1..3)].any? { |rng| ds.all? &rng.method(:===) } }

puts reports.count &is_safe << to_deltas


