require 'stringio'

garden = begin
          lines = DATA.readlines(chomp: true).map(&:chars)
          lines = File.readlines("input/12", chomp: true).map(&:chars)
          # lines = lines.drop(20).take(80).map { _1.drop(80).take(20) }

          SIZE = lines.length
          RANGE = (1..SIZE)
          def positions = RANGE.to_a.to_enum(:product, RANGE.to_a)

          # Pad the grid with nils
          [[nil] * SIZE] + lines.map { [nil] + _1 + [nil] } + [[nil] * SIZE]
        end

garden.instance_eval do
  def each_neighbour((r,c), &b)
    return to_enum(__method__, [r,c]) unless block_given?
    [[-1, 0], [0, 1], [1, 0], [0, -1]].filter_map do |(dy,dx)|
      nr, nc = [r + dy, c + dx]
      next unless (0...length) === nr and (0...length) === nc
      [[nr, nc], self[nr][nc], [dy, dx]]
    end.each(&b)
  end
end

WHITE = "\x1b[2m\x1b[37m"
YELLOW = "\x1b[33m"
MAGENTA = "\x1b[35m"
BLACK = "\x1b[2m\x1b[30m"
RESET = "\x1b[0m"
CLS = `clear`

unexplored_garden = Set.new(positions)
crops = Hash.new { |h, plant| h[plant] = Set.new }

c = 0
dbg = StringIO.new
until unexplored_garden.empty?
  dbg.string = CLS.dup

  (pos, plant) = unexplored_garden.first
    .tap { unexplored_garden.delete _1 }
    .then { [_1, garden.dig(*_1)] }

  ###DEBUG
  if (c += 1).pred.modulo(1).zero? 
    dbg.print CLS
    dbg.puts "------+---------" if false
    dbg.printf "%5d | Analysed %5d / %5d  (%.2f%%)", c, (SIZE**2 - unexplored_garden.count), SIZE**2, (SIZE**2 - unexplored_garden.count).fdiv(SIZE**2) * 100
    dbg.printf "  @ %s # %d\n", plant, crops[plant].length
    if false 
      dbg.puts
      crops.each_slice(5)
        .each { |s| s.each { |plant, pos| dbg.printf "      #%s = %3d", plant, pos.length }; dbg.puts }
    end
    # exit if c > 1000
  end
  ###DEBUG
  
  crop = Set[pos]
  fence = Set.new
  plant_frontier = [pos]
  until plant_frontier.empty?
    fpos = plant_frontier.pop
    garden.each_neighbour(fpos) do |npos, nplant, dir|
      next if crop.include?(npos) # or plant_frontier.include?(npos)
      if nplant == plant
        crop << npos
        plant_frontier << npos
      else
        fence << [npos, dir]
      end
    end
  end
  crops[plant] << {plant:, crop:, fence:}
  unexplored_garden.subtract(crop)

  ###DEBUG
  if true
    dbg.puts "----------------------"
    rmin, rmax = crop.map(&:first).minmax
    cmin, cmax = crop.map(&:last).minmax
    dbg.puts "#{WHITE}#{(cmin - 1).to_s.rjust(6)}<#{' ' * (cmax - cmin + 1)}>#{cmax + 1}#{RESET}"
    (rmin - 1..rmax + 1).each { |r|
      dbg.print "#{case r when rmin - 1, rmax + 1; WHITE else BLACK end}#{r.to_s.rjust(3)} - #{RESET}"
      (cmin - 1..cmax + 1).each { |c|
        dbg.print(if crop.include?([r, c])
                YELLOW + plant + RESET
              elsif !(fences = fence.filter { |pos, _| pos == [r, c] }).empty?
                MAGENTA + case [0, 1].map { |d| fences.any? { |_, dir| dir[d] != 0 } }
                in [true, false]; ?-
                in [false, true]; ?|
                in [true, true];  ?+
                else ??
                end + RESET
              elsif garden[r][c].nil?
                BLACK + ?# + RESET
              else
                BLACK + ?. + RESET
              end)
      }
      dbg.puts
    }
    dbg.puts "----------------------"
  end
  print dbg.string
  ###DEBUG
end

total_price = crops.sum do |_plant, crops|
  crops.sum do |crop|
    crop => {crop: plant_positions, fence: fences}
    plant_positions.count * fences.count
  end
end

puts
puts "Part 1: #{total_price}"

# 27937166: too high
# 3777971:  too high

# last example: 1930

__END__
RRRRIICCFF
RRRRIICCCF
VVRRRCCFFF
VVRCCCJFFF
VVVVCJJCFE
VVIVCCJJEE
VVIIICJJEE
MIIIIIJJEE
MIIISIJEEE
MMMISSJEEE
