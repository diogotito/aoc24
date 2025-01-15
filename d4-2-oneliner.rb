puts \
  IO.foreach('input/04', chomp: true)
  .map(&:chars)
  .then { |soup|
    (1..soup.size-2).flat_map { |r| (1..soup.size-2).map { |c| [r, c] } }
      .count do |r, c|
        [[[-1,-1],[0,0],[1,1]], [[1,-1],[0,0],[-1,1]]].all? do |arm|
          %w[MAS SAM].include? arm.map { |dy, dx| soup[r + dy][c + dx] }.join
        end
      end
  }
