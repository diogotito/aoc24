garden = File.open("../in/12") do |f|
  lines = f.readlines(chomp: true).map(&:chars)
  SIZE = lines.length

  # Pad the grid with nils
  [[nil] * SIZE] + lines.map { [nil] + _1 + [nil] } + [[nil] * SIZE]
end

def garden.each_neighbour((r,c))
  [[-1, 0], [0, 1], [1, 0], [0, -1]].each do |(dy,dx)|
    nr, nc = [r + dy, c + dx]
    next unless (0...length) === nr and (0...length) === nc
    yield [nr, nc], self[nr][nc], [dy, dx]
  end
end

unexplored_garden = Set.new((1..SIZE).to_a.then { _1.product _1 })
crops = []

until unexplored_garden.empty?
  (pos, plant) = unexplored_garden.first
    .tap { unexplored_garden.delete _1 }
    .then { [_1, garden.dig(*_1)] }

  crop = Set[pos]
  fence = Set.new
  plant_frontier = [pos]
  until plant_frontier.empty?
    fpos = plant_frontier.pop
    garden.each_neighbour(fpos) do |npos, nplant, dir|
      next if crop.include?(npos)
      if nplant == plant
        crop << npos
        plant_frontier << npos
      else
        fence << [npos, dir]
      end
    end
  end
  crops << {plant:, crop:, fence:}
  unexplored_garden.subtract(crop)
end

total_price = crops.sum { _1[:crop].count * _1[:fence].count }

puts
puts "Part 1: #{total_price}" # 1424006
