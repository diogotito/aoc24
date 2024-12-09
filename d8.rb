require 'matrix'

input = open('input/08')
input = DATA if false # reads what's below __END__

map = Matrix.rows input.readlines(chomp: true).map &:chars
SIZE = map.column_count

puts map.to_a.map(&:join).join("\n")
puts "#{map.column_count} columns, #{map.column_size} rows"

Vector.define_method :in_bounds? do
  (0...SIZE) === component(0) and (0...SIZE) === component(1)
end

antennas = Hash.new { |h, k| h[k] = [] }
antinodes_1 = Set.new
antinodes_2 = Set.new

map.each_with_index do |freq, r, c|
  next if freq == ?.
  pos = Vector[r, c]
  antennas[freq].each do |antenna|
    d = pos - antenna
    antinodes_1.merge [pos + d, antenna - d].filter &:in_bounds?
    antinodes_2.merge Enumerator.produce(pos)     { _1 + d }.take_while &:in_bounds?
    antinodes_2.merge Enumerator.produce(antenna) { _1 - d }.take_while &:in_bounds?
  end
  antennas[freq] << pos
end

puts "Part One: #{antinodes_1.count}"
puts "Part Two: #{antinodes_2.count}"


__END__
............
........0...
.....0......
.......0....
....0.......
......A.....
............
............
........A...
.........A..
............
............
