require 'matrix'

DIRS = [ Vector[0, 1], Vector[0, -1], Vector[1, 0], Vector[-1, 0] ]

INPUT = open '../in/10' # DATA
map = Matrix.rows(INPUT.readlines(chomp: true).map { _1.chars.map(&:to_i) })

def map.count_trails_from(pos, dir, reachable_9s)
  fwd = pos + dir
  return 0 unless (0...column_size) === fwd[0] and (0...column_count) === fwd[1]
  pos_v, fwd_v = self[*pos], self[*fwd]
  return 0 if pos_v + 1 != fwd_v
  reachable_9s << fwd and return 1 if fwd_v == 9
  DIRS.sum { |dir| count_trails_from(fwd, dir, reachable_9s) }
end

all_scores, all_ratings = map.each_with_index.sum(Vector.zero 2) do |height, r, c|
  next Vector.zero 2 unless height.zero?
  trailhead = Vector[r, c]
  reachable_9s = Set.new
  rating = DIRS.sum { |dir| map.count_trails_from(trailhead, dir, reachable_9s) }
  Vector[reachable_9s.count, rating]
end.to_a

puts "Part One: #{all_scores}"  # 36
puts "Part Two: #{all_ratings}" # 81

__END__
89010123
78121874
87430965
96549874
45678903
32019012
01329801
10456732
